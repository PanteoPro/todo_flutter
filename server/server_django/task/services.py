from . import models
from django.db.models import Max
import json

def _getMaxPosition() -> int:
    return models.Task.objects.aggregate(Max('position'))['position__max']

def getTasksService(request):
    tasks = models.Task.objects.all()
    tasksJson = []
    for task in tasks:
        tasksJson.append(_taskToJson(task))
    return tasksJson

def _taskToJson(task) -> dict:
    json = {
        'id': task.id,
        'title': task.title,
        'body': task.body,
        'isChecked': task.isChecked,
        'position': task.position
    }
    return json

def deleteTaskService(idToDelete) -> bool:
    try:
        task = models.Task.objects.get(id=idToDelete)
        task.delete()
        return {'isDeleted': True, 'task': _taskToJson(task)}
    except:
        return False

def changeCheckedService(idToChange) -> bool:
    try:
        task = models.Task.objects.get(id=idToChange)
        task.isChecked = False if task.isChecked else True
        task.save()
        return {'isChangedChecked': True, 'task': _taskToJson(task)}
    except:
        return {'isChangedChecked': False}

def createTaskService(data: bytes) -> bool:
    try:
        my_json = data.decode('utf8')
        data_json = json.loads(my_json)
        kwargs = {
            "title": data_json['title'],
            "body": data_json['body']
        }
        position = data_json.get('position')
        if not position:
            max__position = _getMaxPosition()
            if max__position != None:
                models.Task.objects.filter(position = max__position)
                position = max__position + 1
            else:
                position = 0
        kwargs.update({'position': position})
        task = models.Task.objects.create(**kwargs)
        return {'isCreated': True, 'task': _taskToJson(task)}
    except:
        return {'isCreated': False}

def changePositionService(data: bytes) -> bool:
    try:
        my_json = data.decode('utf8')
        data_json = json.loads(my_json)
        task = models.Task.objects.get(id=data_json.get('id'))
        max_position = _getMaxPosition()
        if data_json.get('position') > max_position:
            task.position = max_position
        else:
            task.position = data_json.get('position')
        task.save()
        return {'isChangedPosition': True, 'task': _taskToJson(task)}
    except:
        return {'isChangedPosition': False}

def changeContentService(data: bytes) -> bool:
    try:
        my_json = data.decode('utf8')
        data_json = json.loads(my_json)
        task = models.Task.objects.get(id=data_json.get('id'))
        isChanged = False
        if data_json.get('title') and task.title != data_json.get('title'):
            isChanged = True
            task.title = data_json.get('title')
        if data_json.get('body') and task.body != data_json.get('body'):
            isChanged = True
            task.body = data_json.get('body')
        if isChanged:
            task.save()
            return {'isChangedContent': True, 'task': _taskToJson(task)}
        else:
            return {'isChangedContent': False, 'message': 'Not have new data', 'task': _taskToJson(task)}
    except:
        return {'isChangedPosition': False}