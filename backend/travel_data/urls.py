from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import HomeView, DestinationViewSet, CategoryViewSet, SearchView

router = DefaultRouter()
router.register(r'destinations', DestinationViewSet, basename='destination')
router.register(r'categories', CategoryViewSet, basename='category')

urlpatterns = [
    path('', include(router.urls)),
    path('home/', HomeView.as_view(), name='home'),
    path('search/', SearchView.as_view(), name='search'),
]
