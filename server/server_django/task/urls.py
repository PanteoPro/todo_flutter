from django.urls import path

from . import views

urlpatterns = [
    path('', views.GetTasks.as_view(), name='get_tasks'),
    path('delete', views.DeleteTask.as_view(), name='delete_task'),
    path('changeChecked', views.ChangeCheckedTask.as_view(), name='change_checked_task'),
    path('create', views.CreateTask.as_view(), name='create_task'),
    path('changePosition', views.ChangePositionTask.as_view(), name='change_position_task'),
    path('changeContent', views.ChangeContentTask.as_view(), name='change_content_task'),
    path('help', views.Help.as_view(), name='help'),
]