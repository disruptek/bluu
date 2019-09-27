
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on who is going to receive notifications associated with your Azure API Management deployment.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "apimanagement-apimnotifications"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_NotificationListByService_593646 = ref object of OpenApiRestCall_593424
proc url_NotificationListByService_593648(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/notifications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationListByService_593647(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of properties defined within a service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593809 = path.getOrDefault("resourceGroupName")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "resourceGroupName", valid_593809
  var valid_593810 = path.getOrDefault("subscriptionId")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "subscriptionId", valid_593810
  var valid_593811 = path.getOrDefault("serviceName")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "serviceName", valid_593811
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593812 = query.getOrDefault("api-version")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "api-version", valid_593812
  var valid_593813 = query.getOrDefault("$top")
  valid_593813 = validateParameter(valid_593813, JInt, required = false, default = nil)
  if valid_593813 != nil:
    section.add "$top", valid_593813
  var valid_593814 = query.getOrDefault("$skip")
  valid_593814 = validateParameter(valid_593814, JInt, required = false, default = nil)
  if valid_593814 != nil:
    section.add "$skip", valid_593814
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593841: Call_NotificationListByService_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of properties defined within a service instance.
  ## 
  let valid = call_593841.validator(path, query, header, formData, body)
  let scheme = call_593841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593841.url(scheme.get, call_593841.host, call_593841.base,
                         call_593841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593841, url, valid)

proc call*(call_593912: Call_NotificationListByService_593646;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0): Recallable =
  ## notificationListByService
  ## Lists a collection of properties defined within a service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_593913 = newJObject()
  var query_593915 = newJObject()
  add(path_593913, "resourceGroupName", newJString(resourceGroupName))
  add(query_593915, "api-version", newJString(apiVersion))
  add(path_593913, "subscriptionId", newJString(subscriptionId))
  add(query_593915, "$top", newJInt(Top))
  add(query_593915, "$skip", newJInt(Skip))
  add(path_593913, "serviceName", newJString(serviceName))
  result = call_593912.call(path_593913, query_593915, nil, nil, nil)

var notificationListByService* = Call_NotificationListByService_593646(
    name: "notificationListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications",
    validator: validate_NotificationListByService_593647, base: "",
    url: url_NotificationListByService_593648, schemes: {Scheme.Https})
type
  Call_NotificationCreateOrUpdate_593979 = ref object of OpenApiRestCall_593424
proc url_NotificationCreateOrUpdate_593981(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "notificationName" in path,
        "`notificationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/notifications/"),
               (kind: VariableSegment, value: "notificationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationCreateOrUpdate_593980(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or Update API Management publisher notification.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: JString (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593982 = path.getOrDefault("resourceGroupName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "resourceGroupName", valid_593982
  var valid_593983 = path.getOrDefault("subscriptionId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "subscriptionId", valid_593983
  var valid_593984 = path.getOrDefault("notificationName")
  valid_593984 = validateParameter(valid_593984, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_593984 != nil:
    section.add "notificationName", valid_593984
  var valid_593985 = path.getOrDefault("serviceName")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "serviceName", valid_593985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593986 = query.getOrDefault("api-version")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "api-version", valid_593986
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_593987 = header.getOrDefault("If-Match")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "If-Match", valid_593987
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593988: Call_NotificationCreateOrUpdate_593979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or Update API Management publisher notification.
  ## 
  let valid = call_593988.validator(path, query, header, formData, body)
  let scheme = call_593988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593988.url(scheme.get, call_593988.host, call_593988.base,
                         call_593988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593988, url, valid)

proc call*(call_593989: Call_NotificationCreateOrUpdate_593979;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string;
          notificationName: string = "RequestPublisherNotificationMessage"): Recallable =
  ## notificationCreateOrUpdate
  ## Create or Update API Management publisher notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: string (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_593990 = newJObject()
  var query_593991 = newJObject()
  add(path_593990, "resourceGroupName", newJString(resourceGroupName))
  add(query_593991, "api-version", newJString(apiVersion))
  add(path_593990, "subscriptionId", newJString(subscriptionId))
  add(path_593990, "notificationName", newJString(notificationName))
  add(path_593990, "serviceName", newJString(serviceName))
  result = call_593989.call(path_593990, query_593991, nil, nil, nil)

var notificationCreateOrUpdate* = Call_NotificationCreateOrUpdate_593979(
    name: "notificationCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}",
    validator: validate_NotificationCreateOrUpdate_593980, base: "",
    url: url_NotificationCreateOrUpdate_593981, schemes: {Scheme.Https})
type
  Call_NotificationGet_593954 = ref object of OpenApiRestCall_593424
proc url_NotificationGet_593956(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "notificationName" in path,
        "`notificationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/notifications/"),
               (kind: VariableSegment, value: "notificationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationGet_593955(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the details of the Notification specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: JString (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593957 = path.getOrDefault("resourceGroupName")
  valid_593957 = validateParameter(valid_593957, JString, required = true,
                                 default = nil)
  if valid_593957 != nil:
    section.add "resourceGroupName", valid_593957
  var valid_593958 = path.getOrDefault("subscriptionId")
  valid_593958 = validateParameter(valid_593958, JString, required = true,
                                 default = nil)
  if valid_593958 != nil:
    section.add "subscriptionId", valid_593958
  var valid_593972 = path.getOrDefault("notificationName")
  valid_593972 = validateParameter(valid_593972, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_593972 != nil:
    section.add "notificationName", valid_593972
  var valid_593973 = path.getOrDefault("serviceName")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "serviceName", valid_593973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593974 = query.getOrDefault("api-version")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "api-version", valid_593974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_NotificationGet_593954; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the Notification specified by its identifier.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_NotificationGet_593954; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          notificationName: string = "RequestPublisherNotificationMessage"): Recallable =
  ## notificationGet
  ## Gets the details of the Notification specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: string (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_593977 = newJObject()
  var query_593978 = newJObject()
  add(path_593977, "resourceGroupName", newJString(resourceGroupName))
  add(query_593978, "api-version", newJString(apiVersion))
  add(path_593977, "subscriptionId", newJString(subscriptionId))
  add(path_593977, "notificationName", newJString(notificationName))
  add(path_593977, "serviceName", newJString(serviceName))
  result = call_593976.call(path_593977, query_593978, nil, nil, nil)

var notificationGet* = Call_NotificationGet_593954(name: "notificationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}",
    validator: validate_NotificationGet_593955, base: "", url: url_NotificationGet_593956,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientEmailListByNotification_593992 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientEmailListByNotification_593994(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "notificationName" in path,
        "`notificationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/notifications/"),
               (kind: VariableSegment, value: "notificationName"),
               (kind: ConstantSegment, value: "/recipientEmails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationRecipientEmailListByNotification_593993(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of the Notification Recipient Emails subscribed to a notification.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: JString (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593995 = path.getOrDefault("resourceGroupName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "resourceGroupName", valid_593995
  var valid_593996 = path.getOrDefault("subscriptionId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "subscriptionId", valid_593996
  var valid_593997 = path.getOrDefault("notificationName")
  valid_593997 = validateParameter(valid_593997, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_593997 != nil:
    section.add "notificationName", valid_593997
  var valid_593998 = path.getOrDefault("serviceName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "serviceName", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593999 = query.getOrDefault("api-version")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "api-version", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_NotificationRecipientEmailListByNotification_593992;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of the Notification Recipient Emails subscribed to a notification.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_NotificationRecipientEmailListByNotification_593992;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string;
          notificationName: string = "RequestPublisherNotificationMessage"): Recallable =
  ## notificationRecipientEmailListByNotification
  ## Gets the list of the Notification Recipient Emails subscribed to a notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: string (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  add(path_594002, "resourceGroupName", newJString(resourceGroupName))
  add(query_594003, "api-version", newJString(apiVersion))
  add(path_594002, "subscriptionId", newJString(subscriptionId))
  add(path_594002, "notificationName", newJString(notificationName))
  add(path_594002, "serviceName", newJString(serviceName))
  result = call_594001.call(path_594002, query_594003, nil, nil, nil)

var notificationRecipientEmailListByNotification* = Call_NotificationRecipientEmailListByNotification_593992(
    name: "notificationRecipientEmailListByNotification",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientEmails",
    validator: validate_NotificationRecipientEmailListByNotification_593993,
    base: "", url: url_NotificationRecipientEmailListByNotification_593994,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientEmailCreateOrUpdate_594004 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientEmailCreateOrUpdate_594006(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "notificationName" in path,
        "`notificationName` is a required path parameter"
  assert "email" in path, "`email` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/notifications/"),
               (kind: VariableSegment, value: "notificationName"),
               (kind: ConstantSegment, value: "/recipientEmails/"),
               (kind: VariableSegment, value: "email")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationRecipientEmailCreateOrUpdate_594005(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds the Email address to the list of Recipients for the Notification.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   email: JString (required)
  ##        : Email identifier.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: JString (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594007 = path.getOrDefault("resourceGroupName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "resourceGroupName", valid_594007
  var valid_594008 = path.getOrDefault("email")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "email", valid_594008
  var valid_594009 = path.getOrDefault("subscriptionId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "subscriptionId", valid_594009
  var valid_594010 = path.getOrDefault("notificationName")
  valid_594010 = validateParameter(valid_594010, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594010 != nil:
    section.add "notificationName", valid_594010
  var valid_594011 = path.getOrDefault("serviceName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "serviceName", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594012 = query.getOrDefault("api-version")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "api-version", valid_594012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594013: Call_NotificationRecipientEmailCreateOrUpdate_594004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds the Email address to the list of Recipients for the Notification.
  ## 
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_NotificationRecipientEmailCreateOrUpdate_594004;
          resourceGroupName: string; apiVersion: string; email: string;
          subscriptionId: string; serviceName: string;
          notificationName: string = "RequestPublisherNotificationMessage"): Recallable =
  ## notificationRecipientEmailCreateOrUpdate
  ## Adds the Email address to the list of Recipients for the Notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   email: string (required)
  ##        : Email identifier.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: string (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  add(path_594015, "resourceGroupName", newJString(resourceGroupName))
  add(query_594016, "api-version", newJString(apiVersion))
  add(path_594015, "email", newJString(email))
  add(path_594015, "subscriptionId", newJString(subscriptionId))
  add(path_594015, "notificationName", newJString(notificationName))
  add(path_594015, "serviceName", newJString(serviceName))
  result = call_594014.call(path_594015, query_594016, nil, nil, nil)

var notificationRecipientEmailCreateOrUpdate* = Call_NotificationRecipientEmailCreateOrUpdate_594004(
    name: "notificationRecipientEmailCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientEmails/{email}",
    validator: validate_NotificationRecipientEmailCreateOrUpdate_594005, base: "",
    url: url_NotificationRecipientEmailCreateOrUpdate_594006,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientEmailCheckEntityExists_594030 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientEmailCheckEntityExists_594032(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "notificationName" in path,
        "`notificationName` is a required path parameter"
  assert "email" in path, "`email` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/notifications/"),
               (kind: VariableSegment, value: "notificationName"),
               (kind: ConstantSegment, value: "/recipientEmails/"),
               (kind: VariableSegment, value: "email")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationRecipientEmailCheckEntityExists_594031(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Determine if Notification Recipient Email subscribed to the notification.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   email: JString (required)
  ##        : Email identifier.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: JString (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594033 = path.getOrDefault("resourceGroupName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "resourceGroupName", valid_594033
  var valid_594034 = path.getOrDefault("email")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "email", valid_594034
  var valid_594035 = path.getOrDefault("subscriptionId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "subscriptionId", valid_594035
  var valid_594036 = path.getOrDefault("notificationName")
  valid_594036 = validateParameter(valid_594036, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594036 != nil:
    section.add "notificationName", valid_594036
  var valid_594037 = path.getOrDefault("serviceName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "serviceName", valid_594037
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594038 = query.getOrDefault("api-version")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "api-version", valid_594038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594039: Call_NotificationRecipientEmailCheckEntityExists_594030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Determine if Notification Recipient Email subscribed to the notification.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_NotificationRecipientEmailCheckEntityExists_594030;
          resourceGroupName: string; apiVersion: string; email: string;
          subscriptionId: string; serviceName: string;
          notificationName: string = "RequestPublisherNotificationMessage"): Recallable =
  ## notificationRecipientEmailCheckEntityExists
  ## Determine if Notification Recipient Email subscribed to the notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   email: string (required)
  ##        : Email identifier.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: string (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594041 = newJObject()
  var query_594042 = newJObject()
  add(path_594041, "resourceGroupName", newJString(resourceGroupName))
  add(query_594042, "api-version", newJString(apiVersion))
  add(path_594041, "email", newJString(email))
  add(path_594041, "subscriptionId", newJString(subscriptionId))
  add(path_594041, "notificationName", newJString(notificationName))
  add(path_594041, "serviceName", newJString(serviceName))
  result = call_594040.call(path_594041, query_594042, nil, nil, nil)

var notificationRecipientEmailCheckEntityExists* = Call_NotificationRecipientEmailCheckEntityExists_594030(
    name: "notificationRecipientEmailCheckEntityExists",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientEmails/{email}",
    validator: validate_NotificationRecipientEmailCheckEntityExists_594031,
    base: "", url: url_NotificationRecipientEmailCheckEntityExists_594032,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientEmailDelete_594017 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientEmailDelete_594019(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "notificationName" in path,
        "`notificationName` is a required path parameter"
  assert "email" in path, "`email` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/notifications/"),
               (kind: VariableSegment, value: "notificationName"),
               (kind: ConstantSegment, value: "/recipientEmails/"),
               (kind: VariableSegment, value: "email")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationRecipientEmailDelete_594018(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes the email from the list of Notification.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   email: JString (required)
  ##        : Email identifier.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: JString (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594020 = path.getOrDefault("resourceGroupName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "resourceGroupName", valid_594020
  var valid_594021 = path.getOrDefault("email")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "email", valid_594021
  var valid_594022 = path.getOrDefault("subscriptionId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "subscriptionId", valid_594022
  var valid_594023 = path.getOrDefault("notificationName")
  valid_594023 = validateParameter(valid_594023, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594023 != nil:
    section.add "notificationName", valid_594023
  var valid_594024 = path.getOrDefault("serviceName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "serviceName", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594025 = query.getOrDefault("api-version")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "api-version", valid_594025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_NotificationRecipientEmailDelete_594017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the email from the list of Notification.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_NotificationRecipientEmailDelete_594017;
          resourceGroupName: string; apiVersion: string; email: string;
          subscriptionId: string; serviceName: string;
          notificationName: string = "RequestPublisherNotificationMessage"): Recallable =
  ## notificationRecipientEmailDelete
  ## Removes the email from the list of Notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   email: string (required)
  ##        : Email identifier.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: string (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(path_594028, "resourceGroupName", newJString(resourceGroupName))
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "email", newJString(email))
  add(path_594028, "subscriptionId", newJString(subscriptionId))
  add(path_594028, "notificationName", newJString(notificationName))
  add(path_594028, "serviceName", newJString(serviceName))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var notificationRecipientEmailDelete* = Call_NotificationRecipientEmailDelete_594017(
    name: "notificationRecipientEmailDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientEmails/{email}",
    validator: validate_NotificationRecipientEmailDelete_594018, base: "",
    url: url_NotificationRecipientEmailDelete_594019, schemes: {Scheme.Https})
type
  Call_NotificationRecipientUserListByNotification_594043 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientUserListByNotification_594045(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "notificationName" in path,
        "`notificationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/notifications/"),
               (kind: VariableSegment, value: "notificationName"),
               (kind: ConstantSegment, value: "/recipientUsers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationRecipientUserListByNotification_594044(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of the Notification Recipient User subscribed to the notification.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: JString (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594046 = path.getOrDefault("resourceGroupName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "resourceGroupName", valid_594046
  var valid_594047 = path.getOrDefault("subscriptionId")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "subscriptionId", valid_594047
  var valid_594048 = path.getOrDefault("notificationName")
  valid_594048 = validateParameter(valid_594048, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594048 != nil:
    section.add "notificationName", valid_594048
  var valid_594049 = path.getOrDefault("serviceName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "serviceName", valid_594049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594050 = query.getOrDefault("api-version")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "api-version", valid_594050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594051: Call_NotificationRecipientUserListByNotification_594043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of the Notification Recipient User subscribed to the notification.
  ## 
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_NotificationRecipientUserListByNotification_594043;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string;
          notificationName: string = "RequestPublisherNotificationMessage"): Recallable =
  ## notificationRecipientUserListByNotification
  ## Gets the list of the Notification Recipient User subscribed to the notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: string (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594053 = newJObject()
  var query_594054 = newJObject()
  add(path_594053, "resourceGroupName", newJString(resourceGroupName))
  add(query_594054, "api-version", newJString(apiVersion))
  add(path_594053, "subscriptionId", newJString(subscriptionId))
  add(path_594053, "notificationName", newJString(notificationName))
  add(path_594053, "serviceName", newJString(serviceName))
  result = call_594052.call(path_594053, query_594054, nil, nil, nil)

var notificationRecipientUserListByNotification* = Call_NotificationRecipientUserListByNotification_594043(
    name: "notificationRecipientUserListByNotification", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientUsers",
    validator: validate_NotificationRecipientUserListByNotification_594044,
    base: "", url: url_NotificationRecipientUserListByNotification_594045,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientUserCreateOrUpdate_594055 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientUserCreateOrUpdate_594057(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "notificationName" in path,
        "`notificationName` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/notifications/"),
               (kind: VariableSegment, value: "notificationName"),
               (kind: ConstantSegment, value: "/recipientUsers/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationRecipientUserCreateOrUpdate_594056(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds the API Management User to the list of Recipients for the Notification.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: JString (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   userId: JString (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594058 = path.getOrDefault("resourceGroupName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "resourceGroupName", valid_594058
  var valid_594059 = path.getOrDefault("subscriptionId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "subscriptionId", valid_594059
  var valid_594060 = path.getOrDefault("notificationName")
  valid_594060 = validateParameter(valid_594060, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594060 != nil:
    section.add "notificationName", valid_594060
  var valid_594061 = path.getOrDefault("serviceName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "serviceName", valid_594061
  var valid_594062 = path.getOrDefault("userId")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "userId", valid_594062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594063 = query.getOrDefault("api-version")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "api-version", valid_594063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594064: Call_NotificationRecipientUserCreateOrUpdate_594055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds the API Management User to the list of Recipients for the Notification.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_NotificationRecipientUserCreateOrUpdate_594055;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; userId: string;
          notificationName: string = "RequestPublisherNotificationMessage"): Recallable =
  ## notificationRecipientUserCreateOrUpdate
  ## Adds the API Management User to the list of Recipients for the Notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: string (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   userId: string (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  add(path_594066, "resourceGroupName", newJString(resourceGroupName))
  add(query_594067, "api-version", newJString(apiVersion))
  add(path_594066, "subscriptionId", newJString(subscriptionId))
  add(path_594066, "notificationName", newJString(notificationName))
  add(path_594066, "serviceName", newJString(serviceName))
  add(path_594066, "userId", newJString(userId))
  result = call_594065.call(path_594066, query_594067, nil, nil, nil)

var notificationRecipientUserCreateOrUpdate* = Call_NotificationRecipientUserCreateOrUpdate_594055(
    name: "notificationRecipientUserCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientUsers/{userId}",
    validator: validate_NotificationRecipientUserCreateOrUpdate_594056, base: "",
    url: url_NotificationRecipientUserCreateOrUpdate_594057,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientUserCheckEntityExists_594081 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientUserCheckEntityExists_594083(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "notificationName" in path,
        "`notificationName` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/notifications/"),
               (kind: VariableSegment, value: "notificationName"),
               (kind: ConstantSegment, value: "/recipientUsers/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationRecipientUserCheckEntityExists_594082(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Determine if the Notification Recipient User is subscribed to the notification.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: JString (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   userId: JString (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594084 = path.getOrDefault("resourceGroupName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "resourceGroupName", valid_594084
  var valid_594085 = path.getOrDefault("subscriptionId")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "subscriptionId", valid_594085
  var valid_594086 = path.getOrDefault("notificationName")
  valid_594086 = validateParameter(valid_594086, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594086 != nil:
    section.add "notificationName", valid_594086
  var valid_594087 = path.getOrDefault("serviceName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "serviceName", valid_594087
  var valid_594088 = path.getOrDefault("userId")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "userId", valid_594088
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594089 = query.getOrDefault("api-version")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "api-version", valid_594089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594090: Call_NotificationRecipientUserCheckEntityExists_594081;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Determine if the Notification Recipient User is subscribed to the notification.
  ## 
  let valid = call_594090.validator(path, query, header, formData, body)
  let scheme = call_594090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594090.url(scheme.get, call_594090.host, call_594090.base,
                         call_594090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594090, url, valid)

proc call*(call_594091: Call_NotificationRecipientUserCheckEntityExists_594081;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; userId: string;
          notificationName: string = "RequestPublisherNotificationMessage"): Recallable =
  ## notificationRecipientUserCheckEntityExists
  ## Determine if the Notification Recipient User is subscribed to the notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: string (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   userId: string (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  var path_594092 = newJObject()
  var query_594093 = newJObject()
  add(path_594092, "resourceGroupName", newJString(resourceGroupName))
  add(query_594093, "api-version", newJString(apiVersion))
  add(path_594092, "subscriptionId", newJString(subscriptionId))
  add(path_594092, "notificationName", newJString(notificationName))
  add(path_594092, "serviceName", newJString(serviceName))
  add(path_594092, "userId", newJString(userId))
  result = call_594091.call(path_594092, query_594093, nil, nil, nil)

var notificationRecipientUserCheckEntityExists* = Call_NotificationRecipientUserCheckEntityExists_594081(
    name: "notificationRecipientUserCheckEntityExists", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientUsers/{userId}",
    validator: validate_NotificationRecipientUserCheckEntityExists_594082,
    base: "", url: url_NotificationRecipientUserCheckEntityExists_594083,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientUserDelete_594068 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientUserDelete_594070(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "notificationName" in path,
        "`notificationName` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/notifications/"),
               (kind: VariableSegment, value: "notificationName"),
               (kind: ConstantSegment, value: "/recipientUsers/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationRecipientUserDelete_594069(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes the API Management user from the list of Notification.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: JString (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   userId: JString (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594071 = path.getOrDefault("resourceGroupName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "resourceGroupName", valid_594071
  var valid_594072 = path.getOrDefault("subscriptionId")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "subscriptionId", valid_594072
  var valid_594073 = path.getOrDefault("notificationName")
  valid_594073 = validateParameter(valid_594073, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594073 != nil:
    section.add "notificationName", valid_594073
  var valid_594074 = path.getOrDefault("serviceName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "serviceName", valid_594074
  var valid_594075 = path.getOrDefault("userId")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "userId", valid_594075
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594076 = query.getOrDefault("api-version")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "api-version", valid_594076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594077: Call_NotificationRecipientUserDelete_594068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the API Management user from the list of Notification.
  ## 
  let valid = call_594077.validator(path, query, header, formData, body)
  let scheme = call_594077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594077.url(scheme.get, call_594077.host, call_594077.base,
                         call_594077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594077, url, valid)

proc call*(call_594078: Call_NotificationRecipientUserDelete_594068;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; userId: string;
          notificationName: string = "RequestPublisherNotificationMessage"): Recallable =
  ## notificationRecipientUserDelete
  ## Removes the API Management user from the list of Notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationName: string (required)
  ##                   : Notification Name Identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   userId: string (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  var path_594079 = newJObject()
  var query_594080 = newJObject()
  add(path_594079, "resourceGroupName", newJString(resourceGroupName))
  add(query_594080, "api-version", newJString(apiVersion))
  add(path_594079, "subscriptionId", newJString(subscriptionId))
  add(path_594079, "notificationName", newJString(notificationName))
  add(path_594079, "serviceName", newJString(serviceName))
  add(path_594079, "userId", newJString(userId))
  result = call_594078.call(path_594079, query_594080, nil, nil, nil)

var notificationRecipientUserDelete* = Call_NotificationRecipientUserDelete_594068(
    name: "notificationRecipientUserDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientUsers/{userId}",
    validator: validate_NotificationRecipientUserDelete_594069, base: "",
    url: url_NotificationRecipientUserDelete_594070, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
