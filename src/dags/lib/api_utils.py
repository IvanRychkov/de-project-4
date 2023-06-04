from typing import Generator
from requests import Response

from airflow.providers.http.hooks.http import HttpHook


def request(api_hook: HttpHook, endpoint, **kwargs) -> Response:
    """Делает простой запрос в api."""
    r = api_hook.run(endpoint, **kwargs)
    r.raise_for_status()
    return r.json()


def request_paginated(
        api_hook: HttpHook,
        endpoint: str,
        limit: int = 50,
        data=None,
        **kwargs
) -> Generator[dict, None, None]:
    """Делает запросы с пагинацией."""
    j = True  # инициализируем переменную для запуска цикла
    payload = {
        'limit': limit,
        'offset': 0,
    }
    # Если были переданы дополнительные параметры, кладём их в запрос
    if data:
        payload.update(data)

    # Повторяем запросы и отдаём ответы
    while j:
        r = api_hook.run(endpoint, payload, **kwargs)
        r.raise_for_status()
        j = r.json()
        yield from j
        # Смещаемся на следующую страницу
        payload['offset'] += limit
