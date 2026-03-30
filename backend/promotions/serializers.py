from rest_framework import serializers
from .models import Promotion

class PromotionSerializer(serializers.ModelSerializer):
    id = serializers.CharField(source='code')
    class Meta:
        model = Promotion
        fields = ['id', 'title', 'description', 'date_range', 'promotion_type', 'discount_value', 'min_purchase']
