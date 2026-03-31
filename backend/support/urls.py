from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import FAQViewSet, SupportTicketViewSet, MetadataView, GeminiChatView

router = DefaultRouter()
router.register(r'faqs', FAQViewSet)
router.register(r'tickets', SupportTicketViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('metadata/', MetadataView.as_view(), name='support-metadata'),
    path('ai-chat/', GeminiChatView.as_view(), name='ai-chat'),
]
