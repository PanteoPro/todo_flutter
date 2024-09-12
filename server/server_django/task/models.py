from django.db import models

class Task(models.Model):
    title = models.CharField(verbose_name='Название', max_length=255)
    body = models.TextField(verbose_name='Описание')
    isChecked = models.BooleanField(verbose_name='Выполнено?', default=False)
    position = models.PositiveSmallIntegerField(verbose_name='Позиция')