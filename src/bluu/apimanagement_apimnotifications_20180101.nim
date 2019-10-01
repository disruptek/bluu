
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-01-01
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
  Call_NotificationCreateOrUpdate_593988 = ref object of OpenApiRestCall_593424
proc url_NotificationCreateOrUpdate_593990(protocol: Scheme; host: string;
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

proc validate_NotificationCreateOrUpdate_593989(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an Notification.
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
  var valid_593991 = path.getOrDefault("resourceGroupName")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "resourceGroupName", valid_593991
  var valid_593992 = path.getOrDefault("subscriptionId")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "subscriptionId", valid_593992
  var valid_593993 = path.getOrDefault("notificationName")
  valid_593993 = validateParameter(valid_593993, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_593993 != nil:
    section.add "notificationName", valid_593993
  var valid_593994 = path.getOrDefault("serviceName")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "serviceName", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593995 = query.getOrDefault("api-version")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "api-version", valid_593995
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_593996 = header.getOrDefault("If-Match")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "If-Match", valid_593996
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593997: Call_NotificationCreateOrUpdate_593988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an Notification.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_NotificationCreateOrUpdate_593988;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string;
          notificationName: string = "RequestPublisherNotificationMessage"): Recallable =
  ## notificationCreateOrUpdate
  ## Updates an Notification.
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
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  add(path_593999, "resourceGroupName", newJString(resourceGroupName))
  add(query_594000, "api-version", newJString(apiVersion))
  add(path_593999, "subscriptionId", newJString(subscriptionId))
  add(path_593999, "notificationName", newJString(notificationName))
  add(path_593999, "serviceName", newJString(serviceName))
  result = call_593998.call(path_593999, query_594000, nil, nil, nil)

var notificationCreateOrUpdate* = Call_NotificationCreateOrUpdate_593988(
    name: "notificationCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}",
    validator: validate_NotificationCreateOrUpdate_593989, base: "",
    url: url_NotificationCreateOrUpdate_593990, schemes: {Scheme.Https})
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
  var valid_593966 = path.getOrDefault("resourceGroupName")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "resourceGroupName", valid_593966
  var valid_593967 = path.getOrDefault("subscriptionId")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "subscriptionId", valid_593967
  var valid_593981 = path.getOrDefault("notificationName")
  valid_593981 = validateParameter(valid_593981, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_593981 != nil:
    section.add "notificationName", valid_593981
  var valid_593982 = path.getOrDefault("serviceName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "serviceName", valid_593982
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593983 = query.getOrDefault("api-version")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "api-version", valid_593983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593984: Call_NotificationGet_593954; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the Notification specified by its identifier.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_NotificationGet_593954; resourceGroupName: string;
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
  var path_593986 = newJObject()
  var query_593987 = newJObject()
  add(path_593986, "resourceGroupName", newJString(resourceGroupName))
  add(query_593987, "api-version", newJString(apiVersion))
  add(path_593986, "subscriptionId", newJString(subscriptionId))
  add(path_593986, "notificationName", newJString(notificationName))
  add(path_593986, "serviceName", newJString(serviceName))
  result = call_593985.call(path_593986, query_593987, nil, nil, nil)

var notificationGet* = Call_NotificationGet_593954(name: "notificationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}",
    validator: validate_NotificationGet_593955, base: "", url: url_NotificationGet_593956,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientEmailListByNotification_594001 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientEmailListByNotification_594003(protocol: Scheme;
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

proc validate_NotificationRecipientEmailListByNotification_594002(path: JsonNode;
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
  var valid_594004 = path.getOrDefault("resourceGroupName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "resourceGroupName", valid_594004
  var valid_594005 = path.getOrDefault("subscriptionId")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "subscriptionId", valid_594005
  var valid_594006 = path.getOrDefault("notificationName")
  valid_594006 = validateParameter(valid_594006, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594006 != nil:
    section.add "notificationName", valid_594006
  var valid_594007 = path.getOrDefault("serviceName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "serviceName", valid_594007
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594008 = query.getOrDefault("api-version")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "api-version", valid_594008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594009: Call_NotificationRecipientEmailListByNotification_594001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of the Notification Recipient Emails subscribed to a notification.
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_NotificationRecipientEmailListByNotification_594001;
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
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  add(path_594011, "resourceGroupName", newJString(resourceGroupName))
  add(query_594012, "api-version", newJString(apiVersion))
  add(path_594011, "subscriptionId", newJString(subscriptionId))
  add(path_594011, "notificationName", newJString(notificationName))
  add(path_594011, "serviceName", newJString(serviceName))
  result = call_594010.call(path_594011, query_594012, nil, nil, nil)

var notificationRecipientEmailListByNotification* = Call_NotificationRecipientEmailListByNotification_594001(
    name: "notificationRecipientEmailListByNotification",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientEmails",
    validator: validate_NotificationRecipientEmailListByNotification_594002,
    base: "", url: url_NotificationRecipientEmailListByNotification_594003,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientEmailCreateOrUpdate_594013 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientEmailCreateOrUpdate_594015(protocol: Scheme;
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

proc validate_NotificationRecipientEmailCreateOrUpdate_594014(path: JsonNode;
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
  var valid_594016 = path.getOrDefault("resourceGroupName")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "resourceGroupName", valid_594016
  var valid_594017 = path.getOrDefault("email")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "email", valid_594017
  var valid_594018 = path.getOrDefault("subscriptionId")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "subscriptionId", valid_594018
  var valid_594019 = path.getOrDefault("notificationName")
  valid_594019 = validateParameter(valid_594019, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594019 != nil:
    section.add "notificationName", valid_594019
  var valid_594020 = path.getOrDefault("serviceName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "serviceName", valid_594020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594021 = query.getOrDefault("api-version")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "api-version", valid_594021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594022: Call_NotificationRecipientEmailCreateOrUpdate_594013;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds the Email address to the list of Recipients for the Notification.
  ## 
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_NotificationRecipientEmailCreateOrUpdate_594013;
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
  var path_594024 = newJObject()
  var query_594025 = newJObject()
  add(path_594024, "resourceGroupName", newJString(resourceGroupName))
  add(query_594025, "api-version", newJString(apiVersion))
  add(path_594024, "email", newJString(email))
  add(path_594024, "subscriptionId", newJString(subscriptionId))
  add(path_594024, "notificationName", newJString(notificationName))
  add(path_594024, "serviceName", newJString(serviceName))
  result = call_594023.call(path_594024, query_594025, nil, nil, nil)

var notificationRecipientEmailCreateOrUpdate* = Call_NotificationRecipientEmailCreateOrUpdate_594013(
    name: "notificationRecipientEmailCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientEmails/{email}",
    validator: validate_NotificationRecipientEmailCreateOrUpdate_594014, base: "",
    url: url_NotificationRecipientEmailCreateOrUpdate_594015,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientEmailCheckEntityExists_594039 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientEmailCheckEntityExists_594041(protocol: Scheme;
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

proc validate_NotificationRecipientEmailCheckEntityExists_594040(path: JsonNode;
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
  var valid_594042 = path.getOrDefault("resourceGroupName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "resourceGroupName", valid_594042
  var valid_594043 = path.getOrDefault("email")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "email", valid_594043
  var valid_594044 = path.getOrDefault("subscriptionId")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "subscriptionId", valid_594044
  var valid_594045 = path.getOrDefault("notificationName")
  valid_594045 = validateParameter(valid_594045, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594045 != nil:
    section.add "notificationName", valid_594045
  var valid_594046 = path.getOrDefault("serviceName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "serviceName", valid_594046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594047 = query.getOrDefault("api-version")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "api-version", valid_594047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594048: Call_NotificationRecipientEmailCheckEntityExists_594039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Determine if Notification Recipient Email subscribed to the notification.
  ## 
  let valid = call_594048.validator(path, query, header, formData, body)
  let scheme = call_594048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594048.url(scheme.get, call_594048.host, call_594048.base,
                         call_594048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594048, url, valid)

proc call*(call_594049: Call_NotificationRecipientEmailCheckEntityExists_594039;
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
  var path_594050 = newJObject()
  var query_594051 = newJObject()
  add(path_594050, "resourceGroupName", newJString(resourceGroupName))
  add(query_594051, "api-version", newJString(apiVersion))
  add(path_594050, "email", newJString(email))
  add(path_594050, "subscriptionId", newJString(subscriptionId))
  add(path_594050, "notificationName", newJString(notificationName))
  add(path_594050, "serviceName", newJString(serviceName))
  result = call_594049.call(path_594050, query_594051, nil, nil, nil)

var notificationRecipientEmailCheckEntityExists* = Call_NotificationRecipientEmailCheckEntityExists_594039(
    name: "notificationRecipientEmailCheckEntityExists",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientEmails/{email}",
    validator: validate_NotificationRecipientEmailCheckEntityExists_594040,
    base: "", url: url_NotificationRecipientEmailCheckEntityExists_594041,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientEmailDelete_594026 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientEmailDelete_594028(protocol: Scheme; host: string;
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

proc validate_NotificationRecipientEmailDelete_594027(path: JsonNode;
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
  var valid_594029 = path.getOrDefault("resourceGroupName")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "resourceGroupName", valid_594029
  var valid_594030 = path.getOrDefault("email")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "email", valid_594030
  var valid_594031 = path.getOrDefault("subscriptionId")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "subscriptionId", valid_594031
  var valid_594032 = path.getOrDefault("notificationName")
  valid_594032 = validateParameter(valid_594032, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594032 != nil:
    section.add "notificationName", valid_594032
  var valid_594033 = path.getOrDefault("serviceName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "serviceName", valid_594033
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594034 = query.getOrDefault("api-version")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "api-version", valid_594034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594035: Call_NotificationRecipientEmailDelete_594026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the email from the list of Notification.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_NotificationRecipientEmailDelete_594026;
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
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  add(path_594037, "resourceGroupName", newJString(resourceGroupName))
  add(query_594038, "api-version", newJString(apiVersion))
  add(path_594037, "email", newJString(email))
  add(path_594037, "subscriptionId", newJString(subscriptionId))
  add(path_594037, "notificationName", newJString(notificationName))
  add(path_594037, "serviceName", newJString(serviceName))
  result = call_594036.call(path_594037, query_594038, nil, nil, nil)

var notificationRecipientEmailDelete* = Call_NotificationRecipientEmailDelete_594026(
    name: "notificationRecipientEmailDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientEmails/{email}",
    validator: validate_NotificationRecipientEmailDelete_594027, base: "",
    url: url_NotificationRecipientEmailDelete_594028, schemes: {Scheme.Https})
type
  Call_NotificationRecipientUserListByNotification_594052 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientUserListByNotification_594054(protocol: Scheme;
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

proc validate_NotificationRecipientUserListByNotification_594053(path: JsonNode;
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
  var valid_594055 = path.getOrDefault("resourceGroupName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "resourceGroupName", valid_594055
  var valid_594056 = path.getOrDefault("subscriptionId")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "subscriptionId", valid_594056
  var valid_594057 = path.getOrDefault("notificationName")
  valid_594057 = validateParameter(valid_594057, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594057 != nil:
    section.add "notificationName", valid_594057
  var valid_594058 = path.getOrDefault("serviceName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "serviceName", valid_594058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594059 = query.getOrDefault("api-version")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "api-version", valid_594059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594060: Call_NotificationRecipientUserListByNotification_594052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of the Notification Recipient User subscribed to the notification.
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_NotificationRecipientUserListByNotification_594052;
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
  var path_594062 = newJObject()
  var query_594063 = newJObject()
  add(path_594062, "resourceGroupName", newJString(resourceGroupName))
  add(query_594063, "api-version", newJString(apiVersion))
  add(path_594062, "subscriptionId", newJString(subscriptionId))
  add(path_594062, "notificationName", newJString(notificationName))
  add(path_594062, "serviceName", newJString(serviceName))
  result = call_594061.call(path_594062, query_594063, nil, nil, nil)

var notificationRecipientUserListByNotification* = Call_NotificationRecipientUserListByNotification_594052(
    name: "notificationRecipientUserListByNotification", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientUsers",
    validator: validate_NotificationRecipientUserListByNotification_594053,
    base: "", url: url_NotificationRecipientUserListByNotification_594054,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientUserCreateOrUpdate_594064 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientUserCreateOrUpdate_594066(protocol: Scheme;
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
  assert "uid" in path, "`uid` is a required path parameter"
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
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationRecipientUserCreateOrUpdate_594065(path: JsonNode;
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
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594067 = path.getOrDefault("resourceGroupName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "resourceGroupName", valid_594067
  var valid_594068 = path.getOrDefault("subscriptionId")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "subscriptionId", valid_594068
  var valid_594069 = path.getOrDefault("notificationName")
  valid_594069 = validateParameter(valid_594069, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594069 != nil:
    section.add "notificationName", valid_594069
  var valid_594070 = path.getOrDefault("uid")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "uid", valid_594070
  var valid_594071 = path.getOrDefault("serviceName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "serviceName", valid_594071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594072 = query.getOrDefault("api-version")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "api-version", valid_594072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_NotificationRecipientUserCreateOrUpdate_594064;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds the API Management User to the list of Recipients for the Notification.
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_NotificationRecipientUserCreateOrUpdate_594064;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          uid: string; serviceName: string;
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
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  add(path_594075, "resourceGroupName", newJString(resourceGroupName))
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "subscriptionId", newJString(subscriptionId))
  add(path_594075, "notificationName", newJString(notificationName))
  add(path_594075, "uid", newJString(uid))
  add(path_594075, "serviceName", newJString(serviceName))
  result = call_594074.call(path_594075, query_594076, nil, nil, nil)

var notificationRecipientUserCreateOrUpdate* = Call_NotificationRecipientUserCreateOrUpdate_594064(
    name: "notificationRecipientUserCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientUsers/{uid}",
    validator: validate_NotificationRecipientUserCreateOrUpdate_594065, base: "",
    url: url_NotificationRecipientUserCreateOrUpdate_594066,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientUserCheckEntityExists_594090 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientUserCheckEntityExists_594092(protocol: Scheme;
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
  assert "uid" in path, "`uid` is a required path parameter"
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
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationRecipientUserCheckEntityExists_594091(path: JsonNode;
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
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594093 = path.getOrDefault("resourceGroupName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "resourceGroupName", valid_594093
  var valid_594094 = path.getOrDefault("subscriptionId")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "subscriptionId", valid_594094
  var valid_594095 = path.getOrDefault("notificationName")
  valid_594095 = validateParameter(valid_594095, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594095 != nil:
    section.add "notificationName", valid_594095
  var valid_594096 = path.getOrDefault("uid")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "uid", valid_594096
  var valid_594097 = path.getOrDefault("serviceName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "serviceName", valid_594097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594098 = query.getOrDefault("api-version")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "api-version", valid_594098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594099: Call_NotificationRecipientUserCheckEntityExists_594090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Determine if the Notification Recipient User is subscribed to the notification.
  ## 
  let valid = call_594099.validator(path, query, header, formData, body)
  let scheme = call_594099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594099.url(scheme.get, call_594099.host, call_594099.base,
                         call_594099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594099, url, valid)

proc call*(call_594100: Call_NotificationRecipientUserCheckEntityExists_594090;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          uid: string; serviceName: string;
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
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594101 = newJObject()
  var query_594102 = newJObject()
  add(path_594101, "resourceGroupName", newJString(resourceGroupName))
  add(query_594102, "api-version", newJString(apiVersion))
  add(path_594101, "subscriptionId", newJString(subscriptionId))
  add(path_594101, "notificationName", newJString(notificationName))
  add(path_594101, "uid", newJString(uid))
  add(path_594101, "serviceName", newJString(serviceName))
  result = call_594100.call(path_594101, query_594102, nil, nil, nil)

var notificationRecipientUserCheckEntityExists* = Call_NotificationRecipientUserCheckEntityExists_594090(
    name: "notificationRecipientUserCheckEntityExists", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientUsers/{uid}",
    validator: validate_NotificationRecipientUserCheckEntityExists_594091,
    base: "", url: url_NotificationRecipientUserCheckEntityExists_594092,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientUserDelete_594077 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientUserDelete_594079(protocol: Scheme; host: string;
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
  assert "uid" in path, "`uid` is a required path parameter"
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
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationRecipientUserDelete_594078(path: JsonNode;
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
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594080 = path.getOrDefault("resourceGroupName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "resourceGroupName", valid_594080
  var valid_594081 = path.getOrDefault("subscriptionId")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "subscriptionId", valid_594081
  var valid_594082 = path.getOrDefault("notificationName")
  valid_594082 = validateParameter(valid_594082, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594082 != nil:
    section.add "notificationName", valid_594082
  var valid_594083 = path.getOrDefault("uid")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "uid", valid_594083
  var valid_594084 = path.getOrDefault("serviceName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "serviceName", valid_594084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594085 = query.getOrDefault("api-version")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "api-version", valid_594085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594086: Call_NotificationRecipientUserDelete_594077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the API Management user from the list of Notification.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_NotificationRecipientUserDelete_594077;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          uid: string; serviceName: string;
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
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  add(path_594088, "resourceGroupName", newJString(resourceGroupName))
  add(query_594089, "api-version", newJString(apiVersion))
  add(path_594088, "subscriptionId", newJString(subscriptionId))
  add(path_594088, "notificationName", newJString(notificationName))
  add(path_594088, "uid", newJString(uid))
  add(path_594088, "serviceName", newJString(serviceName))
  result = call_594087.call(path_594088, query_594089, nil, nil, nil)

var notificationRecipientUserDelete* = Call_NotificationRecipientUserDelete_594077(
    name: "notificationRecipientUserDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientUsers/{uid}",
    validator: validate_NotificationRecipientUserDelete_594078, base: "",
    url: url_NotificationRecipientUserDelete_594079, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
