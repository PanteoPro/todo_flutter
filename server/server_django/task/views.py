from django.views.generic.base import View
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from django.core.handlers.wsgi import WSGIRequest

from . import services

import json


class GetTasks(View):
    """Получение всех тасков"""
    def get(self, request):
        json = services.getTasksService(request)
        return JsonResponse(json, safe=False)


class DeleteTask(View):
    """
        Удаление таска по id
        ?id=$
    """
    def get(self, request):
        idToDelete = request.GET['id']
        res = services.deleteTaskService(idToDelete)
        return JsonResponse(res)

class ChangeCheckedTask(View):
    """
        Изменение checked таска по id
        ?id=$
    """
    def get(self, request):
        idToChange = request.GET['id']
        res = services.changeCheckedService(idToChange)
        return JsonResponse(res, json_dumps_params={'indent': 4})

@method_decorator(csrf_exempt, name='dispatch')
class CreateTask(View):
    """
        Создание таска
        required id, required title, required body
    """
    def post(self, request: WSGIRequest):
        res = services.createTaskService(request.body)
        return JsonResponse(res, json_dumps_params={'indent': 4})

@method_decorator(csrf_exempt, name='dispatch')
class ChangePositionTask(View):
    """
        Изменение Position таска по id
        required id, required position
    """
    def post(self, request):
        res = services.changePositionService(request.body)
        return JsonResponse(res, json_dumps_params={'indent': 4})

@method_decorator(csrf_exempt, name='dispatch')
class ChangeContentTask(View):
    """
        Изменение контента таска по id
        required id, title, body
    """
    def post(self, request):
        res = services.changeContentService(request.body)
        return JsonResponse(res, json_dumps_params={'indent': 4})

class Help(View):
    def get(self, request):
        host = request.META['HTTP_HOST']
        style = """
            <style>
                li{
                    margin-bottom: 20px;
                }
            </style>
        """
        result = f"""
            {style}
            <h1>У сервера 6 функций</h1>
            <ol>
            <li>Получить все таски - GET <strong>http://{host}/task/</strong></li>
            <li>Удалить таск по id - GET <strong>http://{host}/task/delete?id=$</strong></li>
            <li>Изменить checked по id - GET <strong>http://{host}/task/changeChecked?id=$</strong></li>
            <li>Создать таск - POST <strong>http://{host}/task/create</strong></li>
                - В body записать title, body, можно указать позицию
            <li>Изменить позицию по id - POST <strong>http://{host}/task/changePosition</strong></li>
                - В body запроса записать id, position
            <li>Изменить контент по id - POST <strong>http://{host}/task/changeContent</strong></li>
                - В body запроса записать id и опциональные title, body
            </ol>
        """
        return HttpResponse(result)