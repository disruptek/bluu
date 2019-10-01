
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
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
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593996: Call_NotificationCreateOrUpdate_593988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an Notification.
  ## 
  let valid = call_593996.validator(path, query, header, formData, body)
  let scheme = call_593996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593996.url(scheme.get, call_593996.host, call_593996.base,
                         call_593996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593996, url, valid)

proc call*(call_593997: Call_NotificationCreateOrUpdate_593988;
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
  var path_593998 = newJObject()
  var query_593999 = newJObject()
  add(path_593998, "resourceGroupName", newJString(resourceGroupName))
  add(query_593999, "api-version", newJString(apiVersion))
  add(path_593998, "subscriptionId", newJString(subscriptionId))
  add(path_593998, "notificationName", newJString(notificationName))
  add(path_593998, "serviceName", newJString(serviceName))
  result = call_593997.call(path_593998, query_593999, nil, nil, nil)

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
  Call_NotificationRecipientEmailListByNotification_594000 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientEmailListByNotification_594002(protocol: Scheme;
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

proc validate_NotificationRecipientEmailListByNotification_594001(path: JsonNode;
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
  var valid_594003 = path.getOrDefault("resourceGroupName")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "resourceGroupName", valid_594003
  var valid_594004 = path.getOrDefault("subscriptionId")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "subscriptionId", valid_594004
  var valid_594005 = path.getOrDefault("notificationName")
  valid_594005 = validateParameter(valid_594005, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594005 != nil:
    section.add "notificationName", valid_594005
  var valid_594006 = path.getOrDefault("serviceName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "serviceName", valid_594006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594008: Call_NotificationRecipientEmailListByNotification_594000;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of the Notification Recipient Emails subscribed to a notification.
  ## 
  let valid = call_594008.validator(path, query, header, formData, body)
  let scheme = call_594008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594008.url(scheme.get, call_594008.host, call_594008.base,
                         call_594008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594008, url, valid)

proc call*(call_594009: Call_NotificationRecipientEmailListByNotification_594000;
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
  var path_594010 = newJObject()
  var query_594011 = newJObject()
  add(path_594010, "resourceGroupName", newJString(resourceGroupName))
  add(query_594011, "api-version", newJString(apiVersion))
  add(path_594010, "subscriptionId", newJString(subscriptionId))
  add(path_594010, "notificationName", newJString(notificationName))
  add(path_594010, "serviceName", newJString(serviceName))
  result = call_594009.call(path_594010, query_594011, nil, nil, nil)

var notificationRecipientEmailListByNotification* = Call_NotificationRecipientEmailListByNotification_594000(
    name: "notificationRecipientEmailListByNotification",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientEmails",
    validator: validate_NotificationRecipientEmailListByNotification_594001,
    base: "", url: url_NotificationRecipientEmailListByNotification_594002,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientEmailCreateOrUpdate_594012 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientEmailCreateOrUpdate_594014(protocol: Scheme;
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

proc validate_NotificationRecipientEmailCreateOrUpdate_594013(path: JsonNode;
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
  var valid_594015 = path.getOrDefault("resourceGroupName")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "resourceGroupName", valid_594015
  var valid_594016 = path.getOrDefault("email")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "email", valid_594016
  var valid_594017 = path.getOrDefault("subscriptionId")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "subscriptionId", valid_594017
  var valid_594018 = path.getOrDefault("notificationName")
  valid_594018 = validateParameter(valid_594018, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594018 != nil:
    section.add "notificationName", valid_594018
  var valid_594019 = path.getOrDefault("serviceName")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "serviceName", valid_594019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594020 = query.getOrDefault("api-version")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "api-version", valid_594020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594021: Call_NotificationRecipientEmailCreateOrUpdate_594012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds the Email address to the list of Recipients for the Notification.
  ## 
  let valid = call_594021.validator(path, query, header, formData, body)
  let scheme = call_594021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594021.url(scheme.get, call_594021.host, call_594021.base,
                         call_594021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594021, url, valid)

proc call*(call_594022: Call_NotificationRecipientEmailCreateOrUpdate_594012;
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
  var path_594023 = newJObject()
  var query_594024 = newJObject()
  add(path_594023, "resourceGroupName", newJString(resourceGroupName))
  add(query_594024, "api-version", newJString(apiVersion))
  add(path_594023, "email", newJString(email))
  add(path_594023, "subscriptionId", newJString(subscriptionId))
  add(path_594023, "notificationName", newJString(notificationName))
  add(path_594023, "serviceName", newJString(serviceName))
  result = call_594022.call(path_594023, query_594024, nil, nil, nil)

var notificationRecipientEmailCreateOrUpdate* = Call_NotificationRecipientEmailCreateOrUpdate_594012(
    name: "notificationRecipientEmailCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientEmails/{email}",
    validator: validate_NotificationRecipientEmailCreateOrUpdate_594013, base: "",
    url: url_NotificationRecipientEmailCreateOrUpdate_594014,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientEmailGet_594038 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientEmailGet_594040(protocol: Scheme; host: string;
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

proc validate_NotificationRecipientEmailGet_594039(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_594041 = path.getOrDefault("resourceGroupName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "resourceGroupName", valid_594041
  var valid_594042 = path.getOrDefault("email")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "email", valid_594042
  var valid_594043 = path.getOrDefault("subscriptionId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "subscriptionId", valid_594043
  var valid_594044 = path.getOrDefault("notificationName")
  valid_594044 = validateParameter(valid_594044, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594044 != nil:
    section.add "notificationName", valid_594044
  var valid_594045 = path.getOrDefault("serviceName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "serviceName", valid_594045
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594046 = query.getOrDefault("api-version")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "api-version", valid_594046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594047: Call_NotificationRecipientEmailGet_594038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Determine if Notification Recipient Email subscribed to the notification.
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_NotificationRecipientEmailGet_594038;
          resourceGroupName: string; apiVersion: string; email: string;
          subscriptionId: string; serviceName: string;
          notificationName: string = "RequestPublisherNotificationMessage"): Recallable =
  ## notificationRecipientEmailGet
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
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  add(path_594049, "resourceGroupName", newJString(resourceGroupName))
  add(query_594050, "api-version", newJString(apiVersion))
  add(path_594049, "email", newJString(email))
  add(path_594049, "subscriptionId", newJString(subscriptionId))
  add(path_594049, "notificationName", newJString(notificationName))
  add(path_594049, "serviceName", newJString(serviceName))
  result = call_594048.call(path_594049, query_594050, nil, nil, nil)

var notificationRecipientEmailGet* = Call_NotificationRecipientEmailGet_594038(
    name: "notificationRecipientEmailGet", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientEmails/{email}",
    validator: validate_NotificationRecipientEmailGet_594039, base: "",
    url: url_NotificationRecipientEmailGet_594040, schemes: {Scheme.Https})
type
  Call_NotificationRecipientEmailDelete_594025 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientEmailDelete_594027(protocol: Scheme; host: string;
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

proc validate_NotificationRecipientEmailDelete_594026(path: JsonNode;
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
  var valid_594028 = path.getOrDefault("resourceGroupName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "resourceGroupName", valid_594028
  var valid_594029 = path.getOrDefault("email")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "email", valid_594029
  var valid_594030 = path.getOrDefault("subscriptionId")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "subscriptionId", valid_594030
  var valid_594031 = path.getOrDefault("notificationName")
  valid_594031 = validateParameter(valid_594031, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594031 != nil:
    section.add "notificationName", valid_594031
  var valid_594032 = path.getOrDefault("serviceName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "serviceName", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "api-version", valid_594033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594034: Call_NotificationRecipientEmailDelete_594025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the email from the list of Notification.
  ## 
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_NotificationRecipientEmailDelete_594025;
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
  var path_594036 = newJObject()
  var query_594037 = newJObject()
  add(path_594036, "resourceGroupName", newJString(resourceGroupName))
  add(query_594037, "api-version", newJString(apiVersion))
  add(path_594036, "email", newJString(email))
  add(path_594036, "subscriptionId", newJString(subscriptionId))
  add(path_594036, "notificationName", newJString(notificationName))
  add(path_594036, "serviceName", newJString(serviceName))
  result = call_594035.call(path_594036, query_594037, nil, nil, nil)

var notificationRecipientEmailDelete* = Call_NotificationRecipientEmailDelete_594025(
    name: "notificationRecipientEmailDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientEmails/{email}",
    validator: validate_NotificationRecipientEmailDelete_594026, base: "",
    url: url_NotificationRecipientEmailDelete_594027, schemes: {Scheme.Https})
type
  Call_NotificationRecipientUserListByNotification_594051 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientUserListByNotification_594053(protocol: Scheme;
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

proc validate_NotificationRecipientUserListByNotification_594052(path: JsonNode;
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
  var valid_594054 = path.getOrDefault("resourceGroupName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "resourceGroupName", valid_594054
  var valid_594055 = path.getOrDefault("subscriptionId")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "subscriptionId", valid_594055
  var valid_594056 = path.getOrDefault("notificationName")
  valid_594056 = validateParameter(valid_594056, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594056 != nil:
    section.add "notificationName", valid_594056
  var valid_594057 = path.getOrDefault("serviceName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "serviceName", valid_594057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594058 = query.getOrDefault("api-version")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "api-version", valid_594058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594059: Call_NotificationRecipientUserListByNotification_594051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of the Notification Recipient User subscribed to the notification.
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_NotificationRecipientUserListByNotification_594051;
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
  var path_594061 = newJObject()
  var query_594062 = newJObject()
  add(path_594061, "resourceGroupName", newJString(resourceGroupName))
  add(query_594062, "api-version", newJString(apiVersion))
  add(path_594061, "subscriptionId", newJString(subscriptionId))
  add(path_594061, "notificationName", newJString(notificationName))
  add(path_594061, "serviceName", newJString(serviceName))
  result = call_594060.call(path_594061, query_594062, nil, nil, nil)

var notificationRecipientUserListByNotification* = Call_NotificationRecipientUserListByNotification_594051(
    name: "notificationRecipientUserListByNotification", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientUsers",
    validator: validate_NotificationRecipientUserListByNotification_594052,
    base: "", url: url_NotificationRecipientUserListByNotification_594053,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientUserCreateOrUpdate_594063 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientUserCreateOrUpdate_594065(protocol: Scheme;
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

proc validate_NotificationRecipientUserCreateOrUpdate_594064(path: JsonNode;
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
  var valid_594066 = path.getOrDefault("resourceGroupName")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "resourceGroupName", valid_594066
  var valid_594067 = path.getOrDefault("subscriptionId")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "subscriptionId", valid_594067
  var valid_594068 = path.getOrDefault("notificationName")
  valid_594068 = validateParameter(valid_594068, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594068 != nil:
    section.add "notificationName", valid_594068
  var valid_594069 = path.getOrDefault("uid")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "uid", valid_594069
  var valid_594070 = path.getOrDefault("serviceName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "serviceName", valid_594070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594071 = query.getOrDefault("api-version")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "api-version", valid_594071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594072: Call_NotificationRecipientUserCreateOrUpdate_594063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds the API Management User to the list of Recipients for the Notification.
  ## 
  let valid = call_594072.validator(path, query, header, formData, body)
  let scheme = call_594072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594072.url(scheme.get, call_594072.host, call_594072.base,
                         call_594072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594072, url, valid)

proc call*(call_594073: Call_NotificationRecipientUserCreateOrUpdate_594063;
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
  var path_594074 = newJObject()
  var query_594075 = newJObject()
  add(path_594074, "resourceGroupName", newJString(resourceGroupName))
  add(query_594075, "api-version", newJString(apiVersion))
  add(path_594074, "subscriptionId", newJString(subscriptionId))
  add(path_594074, "notificationName", newJString(notificationName))
  add(path_594074, "uid", newJString(uid))
  add(path_594074, "serviceName", newJString(serviceName))
  result = call_594073.call(path_594074, query_594075, nil, nil, nil)

var notificationRecipientUserCreateOrUpdate* = Call_NotificationRecipientUserCreateOrUpdate_594063(
    name: "notificationRecipientUserCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientUsers/{uid}",
    validator: validate_NotificationRecipientUserCreateOrUpdate_594064, base: "",
    url: url_NotificationRecipientUserCreateOrUpdate_594065,
    schemes: {Scheme.Https})
type
  Call_NotificationRecipientUserGet_594089 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientUserGet_594091(protocol: Scheme; host: string;
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

proc validate_NotificationRecipientUserGet_594090(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_594092 = path.getOrDefault("resourceGroupName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "resourceGroupName", valid_594092
  var valid_594093 = path.getOrDefault("subscriptionId")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "subscriptionId", valid_594093
  var valid_594094 = path.getOrDefault("notificationName")
  valid_594094 = validateParameter(valid_594094, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594094 != nil:
    section.add "notificationName", valid_594094
  var valid_594095 = path.getOrDefault("uid")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "uid", valid_594095
  var valid_594096 = path.getOrDefault("serviceName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "serviceName", valid_594096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594097 = query.getOrDefault("api-version")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "api-version", valid_594097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594098: Call_NotificationRecipientUserGet_594089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Determine if the Notification Recipient User is subscribed to the notification.
  ## 
  let valid = call_594098.validator(path, query, header, formData, body)
  let scheme = call_594098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594098.url(scheme.get, call_594098.host, call_594098.base,
                         call_594098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594098, url, valid)

proc call*(call_594099: Call_NotificationRecipientUserGet_594089;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          uid: string; serviceName: string;
          notificationName: string = "RequestPublisherNotificationMessage"): Recallable =
  ## notificationRecipientUserGet
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
  var path_594100 = newJObject()
  var query_594101 = newJObject()
  add(path_594100, "resourceGroupName", newJString(resourceGroupName))
  add(query_594101, "api-version", newJString(apiVersion))
  add(path_594100, "subscriptionId", newJString(subscriptionId))
  add(path_594100, "notificationName", newJString(notificationName))
  add(path_594100, "uid", newJString(uid))
  add(path_594100, "serviceName", newJString(serviceName))
  result = call_594099.call(path_594100, query_594101, nil, nil, nil)

var notificationRecipientUserGet* = Call_NotificationRecipientUserGet_594089(
    name: "notificationRecipientUserGet", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientUsers/{uid}",
    validator: validate_NotificationRecipientUserGet_594090, base: "",
    url: url_NotificationRecipientUserGet_594091, schemes: {Scheme.Https})
type
  Call_NotificationRecipientUserDelete_594076 = ref object of OpenApiRestCall_593424
proc url_NotificationRecipientUserDelete_594078(protocol: Scheme; host: string;
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

proc validate_NotificationRecipientUserDelete_594077(path: JsonNode;
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
  var valid_594079 = path.getOrDefault("resourceGroupName")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "resourceGroupName", valid_594079
  var valid_594080 = path.getOrDefault("subscriptionId")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "subscriptionId", valid_594080
  var valid_594081 = path.getOrDefault("notificationName")
  valid_594081 = validateParameter(valid_594081, JString, required = true, default = newJString(
      "RequestPublisherNotificationMessage"))
  if valid_594081 != nil:
    section.add "notificationName", valid_594081
  var valid_594082 = path.getOrDefault("uid")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "uid", valid_594082
  var valid_594083 = path.getOrDefault("serviceName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "serviceName", valid_594083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594084 = query.getOrDefault("api-version")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "api-version", valid_594084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594085: Call_NotificationRecipientUserDelete_594076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the API Management user from the list of Notification.
  ## 
  let valid = call_594085.validator(path, query, header, formData, body)
  let scheme = call_594085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594085.url(scheme.get, call_594085.host, call_594085.base,
                         call_594085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594085, url, valid)

proc call*(call_594086: Call_NotificationRecipientUserDelete_594076;
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
  var path_594087 = newJObject()
  var query_594088 = newJObject()
  add(path_594087, "resourceGroupName", newJString(resourceGroupName))
  add(query_594088, "api-version", newJString(apiVersion))
  add(path_594087, "subscriptionId", newJString(subscriptionId))
  add(path_594087, "notificationName", newJString(notificationName))
  add(path_594087, "uid", newJString(uid))
  add(path_594087, "serviceName", newJString(serviceName))
  result = call_594086.call(path_594087, query_594088, nil, nil, nil)

var notificationRecipientUserDelete* = Call_NotificationRecipientUserDelete_594076(
    name: "notificationRecipientUserDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/notifications/{notificationName}/recipientUsers/{uid}",
    validator: validate_NotificationRecipientUserDelete_594077, base: "",
    url: url_NotificationRecipientUserDelete_594078, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
