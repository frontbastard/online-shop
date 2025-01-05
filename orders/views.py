from django.shortcuts import render, redirect

from cart.cart import Cart
from online_shop import settings
from orders.models import OrderItem
from orders.forms import OrderCreateForm
from .tasks import order_created


def order_create(request):
    cart = Cart(request)

    if request.method == "POST":
        form = OrderCreateForm(request.POST)

        if form.is_valid():
            order = form.save()

            for item in cart:
                OrderItem.objects.create(
                    order=order,
                    product=item["product"],
                    price=item["price"],
                    quantity=item["quantity"],
                )

            # clear the cart
            cart.clear()
            # launch async task
            order_created.delay(order.id)
            # set the order in the session
            request.session["order_id"] = order.id
            # redirect for payment
            return redirect("payment:process")
    else:
        if settings.DEBUG:
            initial_data = {
                "first_name": "Julio",
                "last_name": "Rodriguez",
                "email": "juliorodriguez@email.com",
                "address": "Santa Maria ave., 7",
                "postal_code": "666666",
                "city": "San Francisco",
            }
        else:
            initial_data = {}

        form = OrderCreateForm(initial=initial_data)
    return render(
        request,
        "orders/order/create.html",
        {"cart": cart, "form": form}
    )
