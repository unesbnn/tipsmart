enum RequestStatus {success, apiError, resourceNotFound}

extension ERequstState on RequestStatus {
  int get code {
    switch (this) {
      case RequestStatus.success:
        return 200;
      case RequestStatus.apiError:
        return 401;
      case RequestStatus.resourceNotFound:
        return 404;
    }
  }
}