# Generated by Django 5.1.4 on 2025-01-09 20:54

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("cart", "0001_initial"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="orderitem",
            name="order",
        ),
        migrations.RemoveField(
            model_name="orderitem",
            name="product",
        ),
        migrations.DeleteModel(
            name="Order",
        ),
        migrations.DeleteModel(
            name="OrderItem",
        ),
    ]
