from django.http import HttpResponse


def home(request):
    return HttpResponse(
        "Hey, this is my first AWS EC2-hosted containerized Django website."
    )