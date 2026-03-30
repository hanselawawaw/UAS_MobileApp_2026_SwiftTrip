from django.db import models

class Promotion(models.Model):
    PROMOTION_TYPE_CHOICES = [
        ('PERCENTAGE', 'Percentage Discount'),
        ('CASHBACK', 'Flat Cashback'),
    ]

    code = models.CharField(max_length=50, unique=True)
    title = models.CharField(max_length=255)
    description = models.TextField()
    date_range = models.CharField(max_length=255)
    
    # New Fields
    promotion_type = models.CharField(
        max_length=20, 
        choices=PROMOTION_TYPE_CHOICES, 
        default='PERCENTAGE'
    )
    discount_value = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    min_purchase = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)

    def __str__(self):
        return f"{self.title} ({self.code})"
