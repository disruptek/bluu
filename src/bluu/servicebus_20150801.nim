
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ServiceBusManagementClient
## version: 2015-08-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Service Bus client
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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "servicebus"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567880 = ref object of OpenApiRestCall_567658
proc url_OperationsList_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567881(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available ServiceBus REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568041 = query.getOrDefault("api-version")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "api-version", valid_568041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568064: Call_OperationsList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available ServiceBus REST API operations.
  ## 
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_OperationsList_567880; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available ServiceBus REST API operations.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  result = call_568135.call(nil, query_568136, nil, nil, nil)

var operationsList* = Call_OperationsList_567880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceBus/operations",
    validator: validate_OperationsList_567881, base: "", url: url_OperationsList_567882,
    schemes: {Scheme.Https})
type
  Call_NamespacesCheckNameAvailability_568176 = ref object of OpenApiRestCall_567658
proc url_NamespacesCheckNameAvailability_568178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/CheckNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCheckNameAvailability_568177(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the give namespace name availability.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568210 = path.getOrDefault("subscriptionId")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "subscriptionId", valid_568210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568211 = query.getOrDefault("api-version")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "api-version", valid_568211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given namespace name
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568213: Call_NamespacesCheckNameAvailability_568176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give namespace name availability.
  ## 
  let valid = call_568213.validator(path, query, header, formData, body)
  let scheme = call_568213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568213.url(scheme.get, call_568213.host, call_568213.base,
                         call_568213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568213, url, valid)

proc call*(call_568214: Call_NamespacesCheckNameAvailability_568176;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCheckNameAvailability
  ## Check the give namespace name availability.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given namespace name
  var path_568215 = newJObject()
  var query_568216 = newJObject()
  var body_568217 = newJObject()
  add(query_568216, "api-version", newJString(apiVersion))
  add(path_568215, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568217 = parameters
  result = call_568214.call(path_568215, query_568216, nil, nil, body_568217)

var namespacesCheckNameAvailability* = Call_NamespacesCheckNameAvailability_568176(
    name: "namespacesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceBus/CheckNameAvailability",
    validator: validate_NamespacesCheckNameAvailability_568177, base: "",
    url: url_NamespacesCheckNameAvailability_568178, schemes: {Scheme.Https})
type
  Call_NamespacesListBySubscription_568218 = ref object of OpenApiRestCall_567658
proc url_NamespacesListBySubscription_568220(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ServiceBus/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListBySubscription_568219(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the available namespaces within the subscription, irrespective of the resource groups.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568221 = path.getOrDefault("subscriptionId")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "subscriptionId", valid_568221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568222 = query.getOrDefault("api-version")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "api-version", valid_568222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568223: Call_NamespacesListBySubscription_568218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the available namespaces within the subscription, irrespective of the resource groups.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_NamespacesListBySubscription_568218;
          apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesListBySubscription
  ## Gets all the available namespaces within the subscription, irrespective of the resource groups.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  add(query_568226, "api-version", newJString(apiVersion))
  add(path_568225, "subscriptionId", newJString(subscriptionId))
  result = call_568224.call(path_568225, query_568226, nil, nil, nil)

var namespacesListBySubscription* = Call_NamespacesListBySubscription_568218(
    name: "namespacesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceBus/namespaces",
    validator: validate_NamespacesListBySubscription_568219, base: "",
    url: url_NamespacesListBySubscription_568220, schemes: {Scheme.Https})
type
  Call_NamespacesListByResourceGroup_568227 = ref object of OpenApiRestCall_567658
proc url_NamespacesListByResourceGroup_568229(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ServiceBus/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListByResourceGroup_568228(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the available namespaces within a resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568230 = path.getOrDefault("resourceGroupName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "resourceGroupName", valid_568230
  var valid_568231 = path.getOrDefault("subscriptionId")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "subscriptionId", valid_568231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568232 = query.getOrDefault("api-version")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "api-version", valid_568232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_NamespacesListByResourceGroup_568227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the available namespaces within a resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_NamespacesListByResourceGroup_568227;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesListByResourceGroup
  ## Gets the available namespaces within a resource group.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(path_568235, "resourceGroupName", newJString(resourceGroupName))
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var namespacesListByResourceGroup* = Call_NamespacesListByResourceGroup_568227(
    name: "namespacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces",
    validator: validate_NamespacesListByResourceGroup_568228, base: "",
    url: url_NamespacesListByResourceGroup_568229, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdate_568248 = ref object of OpenApiRestCall_567658
proc url_NamespacesCreateOrUpdate_568250(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdate_568249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639408.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568251 = path.getOrDefault("namespaceName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "namespaceName", valid_568251
  var valid_568252 = path.getOrDefault("resourceGroupName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "resourceGroupName", valid_568252
  var valid_568253 = path.getOrDefault("subscriptionId")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "subscriptionId", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568254 = query.getOrDefault("api-version")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "api-version", valid_568254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a namespace resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568256: Call_NamespacesCreateOrUpdate_568248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639408.aspx
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_NamespacesCreateOrUpdate_568248;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdate
  ## Creates or updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639408.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a namespace resource.
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  var body_568260 = newJObject()
  add(path_568258, "namespaceName", newJString(namespaceName))
  add(path_568258, "resourceGroupName", newJString(resourceGroupName))
  add(query_568259, "api-version", newJString(apiVersion))
  add(path_568258, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568260 = parameters
  result = call_568257.call(path_568258, query_568259, nil, nil, body_568260)

var namespacesCreateOrUpdate* = Call_NamespacesCreateOrUpdate_568248(
    name: "namespacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}",
    validator: validate_NamespacesCreateOrUpdate_568249, base: "",
    url: url_NamespacesCreateOrUpdate_568250, schemes: {Scheme.Https})
type
  Call_NamespacesGet_568237 = ref object of OpenApiRestCall_567658
proc url_NamespacesGet_568239(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGet_568238(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a description for the specified namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639379.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568240 = path.getOrDefault("namespaceName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "namespaceName", valid_568240
  var valid_568241 = path.getOrDefault("resourceGroupName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "resourceGroupName", valid_568241
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568243 = query.getOrDefault("api-version")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "api-version", valid_568243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_NamespacesGet_568237; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a description for the specified namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639379.aspx
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_NamespacesGet_568237; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesGet
  ## Gets a description for the specified namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639379.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  add(path_568246, "namespaceName", newJString(namespaceName))
  add(path_568246, "resourceGroupName", newJString(resourceGroupName))
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  result = call_568245.call(path_568246, query_568247, nil, nil, nil)

var namespacesGet* = Call_NamespacesGet_568237(name: "namespacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}",
    validator: validate_NamespacesGet_568238, base: "", url: url_NamespacesGet_568239,
    schemes: {Scheme.Https})
type
  Call_NamespacesUpdate_568272 = ref object of OpenApiRestCall_567658
proc url_NamespacesUpdate_568274(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesUpdate_568273(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568275 = path.getOrDefault("namespaceName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "namespaceName", valid_568275
  var valid_568276 = path.getOrDefault("resourceGroupName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "resourceGroupName", valid_568276
  var valid_568277 = path.getOrDefault("subscriptionId")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "subscriptionId", valid_568277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568278 = query.getOrDefault("api-version")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "api-version", valid_568278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update a namespace resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568280: Call_NamespacesUpdate_568272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  let valid = call_568280.validator(path, query, header, formData, body)
  let scheme = call_568280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568280.url(scheme.get, call_568280.host, call_568280.base,
                         call_568280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568280, url, valid)

proc call*(call_568281: Call_NamespacesUpdate_568272; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesUpdate
  ## Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update a namespace resource.
  var path_568282 = newJObject()
  var query_568283 = newJObject()
  var body_568284 = newJObject()
  add(path_568282, "namespaceName", newJString(namespaceName))
  add(path_568282, "resourceGroupName", newJString(resourceGroupName))
  add(query_568283, "api-version", newJString(apiVersion))
  add(path_568282, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568284 = parameters
  result = call_568281.call(path_568282, query_568283, nil, nil, body_568284)

var namespacesUpdate* = Call_NamespacesUpdate_568272(name: "namespacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}",
    validator: validate_NamespacesUpdate_568273, base: "",
    url: url_NamespacesUpdate_568274, schemes: {Scheme.Https})
type
  Call_NamespacesDelete_568261 = ref object of OpenApiRestCall_567658
proc url_NamespacesDelete_568263(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDelete_568262(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639389.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568264 = path.getOrDefault("namespaceName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "namespaceName", valid_568264
  var valid_568265 = path.getOrDefault("resourceGroupName")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "resourceGroupName", valid_568265
  var valid_568266 = path.getOrDefault("subscriptionId")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "subscriptionId", valid_568266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568267 = query.getOrDefault("api-version")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "api-version", valid_568267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568268: Call_NamespacesDelete_568261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639389.aspx
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_NamespacesDelete_568261; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesDelete
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639389.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  add(path_568270, "namespaceName", newJString(namespaceName))
  add(path_568270, "resourceGroupName", newJString(resourceGroupName))
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "subscriptionId", newJString(subscriptionId))
  result = call_568269.call(path_568270, query_568271, nil, nil, nil)

var namespacesDelete* = Call_NamespacesDelete_568261(name: "namespacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}",
    validator: validate_NamespacesDelete_568262, base: "",
    url: url_NamespacesDelete_568263, schemes: {Scheme.Https})
type
  Call_NamespacesListAuthorizationRules_568285 = ref object of OpenApiRestCall_567658
proc url_NamespacesListAuthorizationRules_568287(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListAuthorizationRules_568286(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the authorization rules for a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639376.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568288 = path.getOrDefault("namespaceName")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "namespaceName", valid_568288
  var valid_568289 = path.getOrDefault("resourceGroupName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "resourceGroupName", valid_568289
  var valid_568290 = path.getOrDefault("subscriptionId")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "subscriptionId", valid_568290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568291 = query.getOrDefault("api-version")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "api-version", valid_568291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568292: Call_NamespacesListAuthorizationRules_568285;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639376.aspx
  let valid = call_568292.validator(path, query, header, formData, body)
  let scheme = call_568292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568292.url(scheme.get, call_568292.host, call_568292.base,
                         call_568292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568292, url, valid)

proc call*(call_568293: Call_NamespacesListAuthorizationRules_568285;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesListAuthorizationRules
  ## Gets the authorization rules for a namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639376.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568294 = newJObject()
  var query_568295 = newJObject()
  add(path_568294, "namespaceName", newJString(namespaceName))
  add(path_568294, "resourceGroupName", newJString(resourceGroupName))
  add(query_568295, "api-version", newJString(apiVersion))
  add(path_568294, "subscriptionId", newJString(subscriptionId))
  result = call_568293.call(path_568294, query_568295, nil, nil, nil)

var namespacesListAuthorizationRules* = Call_NamespacesListAuthorizationRules_568285(
    name: "namespacesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListAuthorizationRules_568286, base: "",
    url: url_NamespacesListAuthorizationRules_568287, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateAuthorizationRule_568308 = ref object of OpenApiRestCall_567658
proc url_NamespacesCreateOrUpdateAuthorizationRule_568310(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdateAuthorizationRule_568309(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an authorization rule for a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639410.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568311 = path.getOrDefault("namespaceName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "namespaceName", valid_568311
  var valid_568312 = path.getOrDefault("resourceGroupName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "resourceGroupName", valid_568312
  var valid_568313 = path.getOrDefault("authorizationRuleName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "authorizationRuleName", valid_568313
  var valid_568314 = path.getOrDefault("subscriptionId")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "subscriptionId", valid_568314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568315 = query.getOrDefault("api-version")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "api-version", valid_568315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568317: Call_NamespacesCreateOrUpdateAuthorizationRule_568308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an authorization rule for a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639410.aspx
  let valid = call_568317.validator(path, query, header, formData, body)
  let scheme = call_568317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568317.url(scheme.get, call_568317.host, call_568317.base,
                         call_568317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568317, url, valid)

proc call*(call_568318: Call_NamespacesCreateOrUpdateAuthorizationRule_568308;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateAuthorizationRule
  ## Creates or updates an authorization rule for a namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639410.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  var path_568319 = newJObject()
  var query_568320 = newJObject()
  var body_568321 = newJObject()
  add(path_568319, "namespaceName", newJString(namespaceName))
  add(path_568319, "resourceGroupName", newJString(resourceGroupName))
  add(query_568320, "api-version", newJString(apiVersion))
  add(path_568319, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568319, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568321 = parameters
  result = call_568318.call(path_568319, query_568320, nil, nil, body_568321)

var namespacesCreateOrUpdateAuthorizationRule* = Call_NamespacesCreateOrUpdateAuthorizationRule_568308(
    name: "namespacesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesCreateOrUpdateAuthorizationRule_568309,
    base: "", url: url_NamespacesCreateOrUpdateAuthorizationRule_568310,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetAuthorizationRule_568296 = ref object of OpenApiRestCall_567658
proc url_NamespacesGetAuthorizationRule_568298(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGetAuthorizationRule_568297(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an authorization rule for a namespace by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639392.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568299 = path.getOrDefault("namespaceName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "namespaceName", valid_568299
  var valid_568300 = path.getOrDefault("resourceGroupName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "resourceGroupName", valid_568300
  var valid_568301 = path.getOrDefault("authorizationRuleName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "authorizationRuleName", valid_568301
  var valid_568302 = path.getOrDefault("subscriptionId")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "subscriptionId", valid_568302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568303 = query.getOrDefault("api-version")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "api-version", valid_568303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568304: Call_NamespacesGetAuthorizationRule_568296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an authorization rule for a namespace by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639392.aspx
  let valid = call_568304.validator(path, query, header, formData, body)
  let scheme = call_568304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568304.url(scheme.get, call_568304.host, call_568304.base,
                         call_568304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568304, url, valid)

proc call*(call_568305: Call_NamespacesGetAuthorizationRule_568296;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesGetAuthorizationRule
  ## Gets an authorization rule for a namespace by rule name.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639392.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568306 = newJObject()
  var query_568307 = newJObject()
  add(path_568306, "namespaceName", newJString(namespaceName))
  add(path_568306, "resourceGroupName", newJString(resourceGroupName))
  add(query_568307, "api-version", newJString(apiVersion))
  add(path_568306, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568306, "subscriptionId", newJString(subscriptionId))
  result = call_568305.call(path_568306, query_568307, nil, nil, nil)

var namespacesGetAuthorizationRule* = Call_NamespacesGetAuthorizationRule_568296(
    name: "namespacesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesGetAuthorizationRule_568297, base: "",
    url: url_NamespacesGetAuthorizationRule_568298, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteAuthorizationRule_568322 = ref object of OpenApiRestCall_567658
proc url_NamespacesDeleteAuthorizationRule_568324(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDeleteAuthorizationRule_568323(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a namespace authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639417.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568325 = path.getOrDefault("namespaceName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "namespaceName", valid_568325
  var valid_568326 = path.getOrDefault("resourceGroupName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "resourceGroupName", valid_568326
  var valid_568327 = path.getOrDefault("authorizationRuleName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "authorizationRuleName", valid_568327
  var valid_568328 = path.getOrDefault("subscriptionId")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "subscriptionId", valid_568328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568329 = query.getOrDefault("api-version")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "api-version", valid_568329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568330: Call_NamespacesDeleteAuthorizationRule_568322;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a namespace authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639417.aspx
  let valid = call_568330.validator(path, query, header, formData, body)
  let scheme = call_568330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568330.url(scheme.get, call_568330.host, call_568330.base,
                         call_568330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568330, url, valid)

proc call*(call_568331: Call_NamespacesDeleteAuthorizationRule_568322;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesDeleteAuthorizationRule
  ## Deletes a namespace authorization rule.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639417.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568332 = newJObject()
  var query_568333 = newJObject()
  add(path_568332, "namespaceName", newJString(namespaceName))
  add(path_568332, "resourceGroupName", newJString(resourceGroupName))
  add(query_568333, "api-version", newJString(apiVersion))
  add(path_568332, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568332, "subscriptionId", newJString(subscriptionId))
  result = call_568331.call(path_568332, query_568333, nil, nil, nil)

var namespacesDeleteAuthorizationRule* = Call_NamespacesDeleteAuthorizationRule_568322(
    name: "namespacesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesDeleteAuthorizationRule_568323, base: "",
    url: url_NamespacesDeleteAuthorizationRule_568324, schemes: {Scheme.Https})
type
  Call_NamespacesListKeys_568334 = ref object of OpenApiRestCall_567658
proc url_NamespacesListKeys_568336(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListKeys_568335(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the primary and secondary connection strings for the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639398.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568337 = path.getOrDefault("namespaceName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "namespaceName", valid_568337
  var valid_568338 = path.getOrDefault("resourceGroupName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "resourceGroupName", valid_568338
  var valid_568339 = path.getOrDefault("authorizationRuleName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "authorizationRuleName", valid_568339
  var valid_568340 = path.getOrDefault("subscriptionId")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "subscriptionId", valid_568340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568341 = query.getOrDefault("api-version")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "api-version", valid_568341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568342: Call_NamespacesListKeys_568334; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the primary and secondary connection strings for the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639398.aspx
  let valid = call_568342.validator(path, query, header, formData, body)
  let scheme = call_568342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568342.url(scheme.get, call_568342.host, call_568342.base,
                         call_568342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568342, url, valid)

proc call*(call_568343: Call_NamespacesListKeys_568334; namespaceName: string;
          resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesListKeys
  ## Gets the primary and secondary connection strings for the namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639398.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568344 = newJObject()
  var query_568345 = newJObject()
  add(path_568344, "namespaceName", newJString(namespaceName))
  add(path_568344, "resourceGroupName", newJString(resourceGroupName))
  add(query_568345, "api-version", newJString(apiVersion))
  add(path_568344, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568344, "subscriptionId", newJString(subscriptionId))
  result = call_568343.call(path_568344, query_568345, nil, nil, nil)

var namespacesListKeys* = Call_NamespacesListKeys_568334(
    name: "namespacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_NamespacesListKeys_568335, base: "",
    url: url_NamespacesListKeys_568336, schemes: {Scheme.Https})
type
  Call_NamespacesRegenerateKeys_568346 = ref object of OpenApiRestCall_567658
proc url_NamespacesRegenerateKeys_568348(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesRegenerateKeys_568347(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary or secondary connection strings for the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt718977.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568349 = path.getOrDefault("namespaceName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "namespaceName", valid_568349
  var valid_568350 = path.getOrDefault("resourceGroupName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "resourceGroupName", valid_568350
  var valid_568351 = path.getOrDefault("authorizationRuleName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "authorizationRuleName", valid_568351
  var valid_568352 = path.getOrDefault("subscriptionId")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "subscriptionId", valid_568352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568353 = query.getOrDefault("api-version")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "api-version", valid_568353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568355: Call_NamespacesRegenerateKeys_568346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the primary or secondary connection strings for the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt718977.aspx
  let valid = call_568355.validator(path, query, header, formData, body)
  let scheme = call_568355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568355.url(scheme.get, call_568355.host, call_568355.base,
                         call_568355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568355, url, valid)

proc call*(call_568356: Call_NamespacesRegenerateKeys_568346;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesRegenerateKeys
  ## Regenerates the primary or secondary connection strings for the namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt718977.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the authorization rule.
  var path_568357 = newJObject()
  var query_568358 = newJObject()
  var body_568359 = newJObject()
  add(path_568357, "namespaceName", newJString(namespaceName))
  add(path_568357, "resourceGroupName", newJString(resourceGroupName))
  add(query_568358, "api-version", newJString(apiVersion))
  add(path_568357, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568357, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568359 = parameters
  result = call_568356.call(path_568357, query_568358, nil, nil, body_568359)

var namespacesRegenerateKeys* = Call_NamespacesRegenerateKeys_568346(
    name: "namespacesRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_NamespacesRegenerateKeys_568347, base: "",
    url: url_NamespacesRegenerateKeys_568348, schemes: {Scheme.Https})
type
  Call_QueuesListAll_568360 = ref object of OpenApiRestCall_567658
proc url_QueuesListAll_568362(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesListAll_568361(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the queues within a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639415.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568363 = path.getOrDefault("namespaceName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "namespaceName", valid_568363
  var valid_568364 = path.getOrDefault("resourceGroupName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "resourceGroupName", valid_568364
  var valid_568365 = path.getOrDefault("subscriptionId")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "subscriptionId", valid_568365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568366 = query.getOrDefault("api-version")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "api-version", valid_568366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568367: Call_QueuesListAll_568360; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the queues within a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639415.aspx
  let valid = call_568367.validator(path, query, header, formData, body)
  let scheme = call_568367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568367.url(scheme.get, call_568367.host, call_568367.base,
                         call_568367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568367, url, valid)

proc call*(call_568368: Call_QueuesListAll_568360; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## queuesListAll
  ## Gets the queues within a namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639415.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568369 = newJObject()
  var query_568370 = newJObject()
  add(path_568369, "namespaceName", newJString(namespaceName))
  add(path_568369, "resourceGroupName", newJString(resourceGroupName))
  add(query_568370, "api-version", newJString(apiVersion))
  add(path_568369, "subscriptionId", newJString(subscriptionId))
  result = call_568368.call(path_568369, query_568370, nil, nil, nil)

var queuesListAll* = Call_QueuesListAll_568360(name: "queuesListAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues",
    validator: validate_QueuesListAll_568361, base: "", url: url_QueuesListAll_568362,
    schemes: {Scheme.Https})
type
  Call_QueuesCreateOrUpdate_568383 = ref object of OpenApiRestCall_567658
proc url_QueuesCreateOrUpdate_568385(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesCreateOrUpdate_568384(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Service Bus queue. This operation is idempotent.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639395.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568386 = path.getOrDefault("namespaceName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "namespaceName", valid_568386
  var valid_568387 = path.getOrDefault("resourceGroupName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "resourceGroupName", valid_568387
  var valid_568388 = path.getOrDefault("subscriptionId")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "subscriptionId", valid_568388
  var valid_568389 = path.getOrDefault("queueName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "queueName", valid_568389
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568390 = query.getOrDefault("api-version")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "api-version", valid_568390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update a queue resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568392: Call_QueuesCreateOrUpdate_568383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Service Bus queue. This operation is idempotent.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639395.aspx
  let valid = call_568392.validator(path, query, header, formData, body)
  let scheme = call_568392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568392.url(scheme.get, call_568392.host, call_568392.base,
                         call_568392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568392, url, valid)

proc call*(call_568393: Call_QueuesCreateOrUpdate_568383; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; queueName: string): Recallable =
  ## queuesCreateOrUpdate
  ## Creates or updates a Service Bus queue. This operation is idempotent.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639395.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update a queue resource.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_568394 = newJObject()
  var query_568395 = newJObject()
  var body_568396 = newJObject()
  add(path_568394, "namespaceName", newJString(namespaceName))
  add(path_568394, "resourceGroupName", newJString(resourceGroupName))
  add(query_568395, "api-version", newJString(apiVersion))
  add(path_568394, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568396 = parameters
  add(path_568394, "queueName", newJString(queueName))
  result = call_568393.call(path_568394, query_568395, nil, nil, body_568396)

var queuesCreateOrUpdate* = Call_QueuesCreateOrUpdate_568383(
    name: "queuesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}",
    validator: validate_QueuesCreateOrUpdate_568384, base: "",
    url: url_QueuesCreateOrUpdate_568385, schemes: {Scheme.Https})
type
  Call_QueuesGet_568371 = ref object of OpenApiRestCall_567658
proc url_QueuesGet_568373(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesGet_568372(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a description for the specified queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639380.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568374 = path.getOrDefault("namespaceName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "namespaceName", valid_568374
  var valid_568375 = path.getOrDefault("resourceGroupName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "resourceGroupName", valid_568375
  var valid_568376 = path.getOrDefault("subscriptionId")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "subscriptionId", valid_568376
  var valid_568377 = path.getOrDefault("queueName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "queueName", valid_568377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568378 = query.getOrDefault("api-version")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "api-version", valid_568378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568379: Call_QueuesGet_568371; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a description for the specified queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639380.aspx
  let valid = call_568379.validator(path, query, header, formData, body)
  let scheme = call_568379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568379.url(scheme.get, call_568379.host, call_568379.base,
                         call_568379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568379, url, valid)

proc call*(call_568380: Call_QueuesGet_568371; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          queueName: string): Recallable =
  ## queuesGet
  ## Returns a description for the specified queue.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639380.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_568381 = newJObject()
  var query_568382 = newJObject()
  add(path_568381, "namespaceName", newJString(namespaceName))
  add(path_568381, "resourceGroupName", newJString(resourceGroupName))
  add(query_568382, "api-version", newJString(apiVersion))
  add(path_568381, "subscriptionId", newJString(subscriptionId))
  add(path_568381, "queueName", newJString(queueName))
  result = call_568380.call(path_568381, query_568382, nil, nil, nil)

var queuesGet* = Call_QueuesGet_568371(name: "queuesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}",
                                    validator: validate_QueuesGet_568372,
                                    base: "", url: url_QueuesGet_568373,
                                    schemes: {Scheme.Https})
type
  Call_QueuesDelete_568397 = ref object of OpenApiRestCall_567658
proc url_QueuesDelete_568399(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesDelete_568398(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a queue from the specified namespace in a resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639411.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568400 = path.getOrDefault("namespaceName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "namespaceName", valid_568400
  var valid_568401 = path.getOrDefault("resourceGroupName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "resourceGroupName", valid_568401
  var valid_568402 = path.getOrDefault("subscriptionId")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "subscriptionId", valid_568402
  var valid_568403 = path.getOrDefault("queueName")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "queueName", valid_568403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568404 = query.getOrDefault("api-version")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "api-version", valid_568404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568405: Call_QueuesDelete_568397; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a queue from the specified namespace in a resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639411.aspx
  let valid = call_568405.validator(path, query, header, formData, body)
  let scheme = call_568405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568405.url(scheme.get, call_568405.host, call_568405.base,
                         call_568405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568405, url, valid)

proc call*(call_568406: Call_QueuesDelete_568397; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          queueName: string): Recallable =
  ## queuesDelete
  ## Deletes a queue from the specified namespace in a resource group.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639411.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_568407 = newJObject()
  var query_568408 = newJObject()
  add(path_568407, "namespaceName", newJString(namespaceName))
  add(path_568407, "resourceGroupName", newJString(resourceGroupName))
  add(query_568408, "api-version", newJString(apiVersion))
  add(path_568407, "subscriptionId", newJString(subscriptionId))
  add(path_568407, "queueName", newJString(queueName))
  result = call_568406.call(path_568407, query_568408, nil, nil, nil)

var queuesDelete* = Call_QueuesDelete_568397(name: "queuesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}",
    validator: validate_QueuesDelete_568398, base: "", url: url_QueuesDelete_568399,
    schemes: {Scheme.Https})
type
  Call_QueuesListAuthorizationRules_568409 = ref object of OpenApiRestCall_567658
proc url_QueuesListAuthorizationRules_568411(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName"),
               (kind: ConstantSegment, value: "/authorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesListAuthorizationRules_568410(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all authorization rules for a queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705607.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568412 = path.getOrDefault("namespaceName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "namespaceName", valid_568412
  var valid_568413 = path.getOrDefault("resourceGroupName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "resourceGroupName", valid_568413
  var valid_568414 = path.getOrDefault("subscriptionId")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "subscriptionId", valid_568414
  var valid_568415 = path.getOrDefault("queueName")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "queueName", valid_568415
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568416 = query.getOrDefault("api-version")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "api-version", valid_568416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568417: Call_QueuesListAuthorizationRules_568409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all authorization rules for a queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705607.aspx
  let valid = call_568417.validator(path, query, header, formData, body)
  let scheme = call_568417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568417.url(scheme.get, call_568417.host, call_568417.base,
                         call_568417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568417, url, valid)

proc call*(call_568418: Call_QueuesListAuthorizationRules_568409;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; queueName: string): Recallable =
  ## queuesListAuthorizationRules
  ## Gets all authorization rules for a queue.
  ## https://msdn.microsoft.com/en-us/library/azure/mt705607.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_568419 = newJObject()
  var query_568420 = newJObject()
  add(path_568419, "namespaceName", newJString(namespaceName))
  add(path_568419, "resourceGroupName", newJString(resourceGroupName))
  add(query_568420, "api-version", newJString(apiVersion))
  add(path_568419, "subscriptionId", newJString(subscriptionId))
  add(path_568419, "queueName", newJString(queueName))
  result = call_568418.call(path_568419, query_568420, nil, nil, nil)

var queuesListAuthorizationRules* = Call_QueuesListAuthorizationRules_568409(
    name: "queuesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules",
    validator: validate_QueuesListAuthorizationRules_568410, base: "",
    url: url_QueuesListAuthorizationRules_568411, schemes: {Scheme.Https})
type
  Call_QueuesCreateOrUpdateAuthorizationRule_568434 = ref object of OpenApiRestCall_567658
proc url_QueuesCreateOrUpdateAuthorizationRule_568436(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesCreateOrUpdateAuthorizationRule_568435(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an authorization rule for a queue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568437 = path.getOrDefault("namespaceName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "namespaceName", valid_568437
  var valid_568438 = path.getOrDefault("resourceGroupName")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "resourceGroupName", valid_568438
  var valid_568439 = path.getOrDefault("authorizationRuleName")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "authorizationRuleName", valid_568439
  var valid_568440 = path.getOrDefault("subscriptionId")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "subscriptionId", valid_568440
  var valid_568441 = path.getOrDefault("queueName")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "queueName", valid_568441
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568442 = query.getOrDefault("api-version")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "api-version", valid_568442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568444: Call_QueuesCreateOrUpdateAuthorizationRule_568434;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an authorization rule for a queue.
  ## 
  let valid = call_568444.validator(path, query, header, formData, body)
  let scheme = call_568444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568444.url(scheme.get, call_568444.host, call_568444.base,
                         call_568444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568444, url, valid)

proc call*(call_568445: Call_QueuesCreateOrUpdateAuthorizationRule_568434;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode; queueName: string): Recallable =
  ## queuesCreateOrUpdateAuthorizationRule
  ## Creates an authorization rule for a queue.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_568446 = newJObject()
  var query_568447 = newJObject()
  var body_568448 = newJObject()
  add(path_568446, "namespaceName", newJString(namespaceName))
  add(path_568446, "resourceGroupName", newJString(resourceGroupName))
  add(query_568447, "api-version", newJString(apiVersion))
  add(path_568446, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568446, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568448 = parameters
  add(path_568446, "queueName", newJString(queueName))
  result = call_568445.call(path_568446, query_568447, nil, nil, body_568448)

var queuesCreateOrUpdateAuthorizationRule* = Call_QueuesCreateOrUpdateAuthorizationRule_568434(
    name: "queuesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}",
    validator: validate_QueuesCreateOrUpdateAuthorizationRule_568435, base: "",
    url: url_QueuesCreateOrUpdateAuthorizationRule_568436, schemes: {Scheme.Https})
type
  Call_QueuesPostAuthorizationRule_568449 = ref object of OpenApiRestCall_567658
proc url_QueuesPostAuthorizationRule_568451(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesPostAuthorizationRule_568450(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an authorization rule for a queue by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705611.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568452 = path.getOrDefault("namespaceName")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "namespaceName", valid_568452
  var valid_568453 = path.getOrDefault("resourceGroupName")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "resourceGroupName", valid_568453
  var valid_568454 = path.getOrDefault("authorizationRuleName")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "authorizationRuleName", valid_568454
  var valid_568455 = path.getOrDefault("subscriptionId")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "subscriptionId", valid_568455
  var valid_568456 = path.getOrDefault("queueName")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "queueName", valid_568456
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568457 = query.getOrDefault("api-version")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "api-version", valid_568457
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568458: Call_QueuesPostAuthorizationRule_568449; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an authorization rule for a queue by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705611.aspx
  let valid = call_568458.validator(path, query, header, formData, body)
  let scheme = call_568458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568458.url(scheme.get, call_568458.host, call_568458.base,
                         call_568458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568458, url, valid)

proc call*(call_568459: Call_QueuesPostAuthorizationRule_568449;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; queueName: string): Recallable =
  ## queuesPostAuthorizationRule
  ## Gets an authorization rule for a queue by rule name.
  ## https://msdn.microsoft.com/en-us/library/azure/mt705611.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_568460 = newJObject()
  var query_568461 = newJObject()
  add(path_568460, "namespaceName", newJString(namespaceName))
  add(path_568460, "resourceGroupName", newJString(resourceGroupName))
  add(query_568461, "api-version", newJString(apiVersion))
  add(path_568460, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568460, "subscriptionId", newJString(subscriptionId))
  add(path_568460, "queueName", newJString(queueName))
  result = call_568459.call(path_568460, query_568461, nil, nil, nil)

var queuesPostAuthorizationRule* = Call_QueuesPostAuthorizationRule_568449(
    name: "queuesPostAuthorizationRule", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}",
    validator: validate_QueuesPostAuthorizationRule_568450, base: "",
    url: url_QueuesPostAuthorizationRule_568451, schemes: {Scheme.Https})
type
  Call_QueuesGetAuthorizationRule_568421 = ref object of OpenApiRestCall_567658
proc url_QueuesGetAuthorizationRule_568423(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesGetAuthorizationRule_568422(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an authorization rule for a queue by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705611.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568424 = path.getOrDefault("namespaceName")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "namespaceName", valid_568424
  var valid_568425 = path.getOrDefault("resourceGroupName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "resourceGroupName", valid_568425
  var valid_568426 = path.getOrDefault("authorizationRuleName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "authorizationRuleName", valid_568426
  var valid_568427 = path.getOrDefault("subscriptionId")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "subscriptionId", valid_568427
  var valid_568428 = path.getOrDefault("queueName")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "queueName", valid_568428
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568429 = query.getOrDefault("api-version")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "api-version", valid_568429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568430: Call_QueuesGetAuthorizationRule_568421; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an authorization rule for a queue by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705611.aspx
  let valid = call_568430.validator(path, query, header, formData, body)
  let scheme = call_568430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568430.url(scheme.get, call_568430.host, call_568430.base,
                         call_568430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568430, url, valid)

proc call*(call_568431: Call_QueuesGetAuthorizationRule_568421;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; queueName: string): Recallable =
  ## queuesGetAuthorizationRule
  ## Gets an authorization rule for a queue by rule name.
  ## https://msdn.microsoft.com/en-us/library/azure/mt705611.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_568432 = newJObject()
  var query_568433 = newJObject()
  add(path_568432, "namespaceName", newJString(namespaceName))
  add(path_568432, "resourceGroupName", newJString(resourceGroupName))
  add(query_568433, "api-version", newJString(apiVersion))
  add(path_568432, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568432, "subscriptionId", newJString(subscriptionId))
  add(path_568432, "queueName", newJString(queueName))
  result = call_568431.call(path_568432, query_568433, nil, nil, nil)

var queuesGetAuthorizationRule* = Call_QueuesGetAuthorizationRule_568421(
    name: "queuesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}",
    validator: validate_QueuesGetAuthorizationRule_568422, base: "",
    url: url_QueuesGetAuthorizationRule_568423, schemes: {Scheme.Https})
type
  Call_QueuesDeleteAuthorizationRule_568462 = ref object of OpenApiRestCall_567658
proc url_QueuesDeleteAuthorizationRule_568464(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesDeleteAuthorizationRule_568463(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a queue authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705609.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568465 = path.getOrDefault("namespaceName")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "namespaceName", valid_568465
  var valid_568466 = path.getOrDefault("resourceGroupName")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "resourceGroupName", valid_568466
  var valid_568467 = path.getOrDefault("authorizationRuleName")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "authorizationRuleName", valid_568467
  var valid_568468 = path.getOrDefault("subscriptionId")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "subscriptionId", valid_568468
  var valid_568469 = path.getOrDefault("queueName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "queueName", valid_568469
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568470 = query.getOrDefault("api-version")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "api-version", valid_568470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568471: Call_QueuesDeleteAuthorizationRule_568462; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a queue authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705609.aspx
  let valid = call_568471.validator(path, query, header, formData, body)
  let scheme = call_568471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568471.url(scheme.get, call_568471.host, call_568471.base,
                         call_568471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568471, url, valid)

proc call*(call_568472: Call_QueuesDeleteAuthorizationRule_568462;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; queueName: string): Recallable =
  ## queuesDeleteAuthorizationRule
  ## Deletes a queue authorization rule.
  ## https://msdn.microsoft.com/en-us/library/azure/mt705609.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_568473 = newJObject()
  var query_568474 = newJObject()
  add(path_568473, "namespaceName", newJString(namespaceName))
  add(path_568473, "resourceGroupName", newJString(resourceGroupName))
  add(query_568474, "api-version", newJString(apiVersion))
  add(path_568473, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568473, "subscriptionId", newJString(subscriptionId))
  add(path_568473, "queueName", newJString(queueName))
  result = call_568472.call(path_568473, query_568474, nil, nil, nil)

var queuesDeleteAuthorizationRule* = Call_QueuesDeleteAuthorizationRule_568462(
    name: "queuesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}",
    validator: validate_QueuesDeleteAuthorizationRule_568463, base: "",
    url: url_QueuesDeleteAuthorizationRule_568464, schemes: {Scheme.Https})
type
  Call_QueuesListKeys_568475 = ref object of OpenApiRestCall_567658
proc url_QueuesListKeys_568477(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/ListKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesListKeys_568476(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Primary and secondary connection strings to the queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705608.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568478 = path.getOrDefault("namespaceName")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "namespaceName", valid_568478
  var valid_568479 = path.getOrDefault("resourceGroupName")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "resourceGroupName", valid_568479
  var valid_568480 = path.getOrDefault("authorizationRuleName")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "authorizationRuleName", valid_568480
  var valid_568481 = path.getOrDefault("subscriptionId")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "subscriptionId", valid_568481
  var valid_568482 = path.getOrDefault("queueName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "queueName", valid_568482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568483 = query.getOrDefault("api-version")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "api-version", valid_568483
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568484: Call_QueuesListKeys_568475; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Primary and secondary connection strings to the queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705608.aspx
  let valid = call_568484.validator(path, query, header, formData, body)
  let scheme = call_568484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568484.url(scheme.get, call_568484.host, call_568484.base,
                         call_568484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568484, url, valid)

proc call*(call_568485: Call_QueuesListKeys_568475; namespaceName: string;
          resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; queueName: string): Recallable =
  ## queuesListKeys
  ## Primary and secondary connection strings to the queue.
  ## https://msdn.microsoft.com/en-us/library/azure/mt705608.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_568486 = newJObject()
  var query_568487 = newJObject()
  add(path_568486, "namespaceName", newJString(namespaceName))
  add(path_568486, "resourceGroupName", newJString(resourceGroupName))
  add(query_568487, "api-version", newJString(apiVersion))
  add(path_568486, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568486, "subscriptionId", newJString(subscriptionId))
  add(path_568486, "queueName", newJString(queueName))
  result = call_568485.call(path_568486, query_568487, nil, nil, nil)

var queuesListKeys* = Call_QueuesListKeys_568475(name: "queuesListKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}/ListKeys",
    validator: validate_QueuesListKeys_568476, base: "", url: url_QueuesListKeys_568477,
    schemes: {Scheme.Https})
type
  Call_QueuesRegenerateKeys_568488 = ref object of OpenApiRestCall_567658
proc url_QueuesRegenerateKeys_568490(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesRegenerateKeys_568489(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary or secondary connection strings to the queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705606.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568491 = path.getOrDefault("namespaceName")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "namespaceName", valid_568491
  var valid_568492 = path.getOrDefault("resourceGroupName")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "resourceGroupName", valid_568492
  var valid_568493 = path.getOrDefault("authorizationRuleName")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "authorizationRuleName", valid_568493
  var valid_568494 = path.getOrDefault("subscriptionId")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "subscriptionId", valid_568494
  var valid_568495 = path.getOrDefault("queueName")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "queueName", valid_568495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568496 = query.getOrDefault("api-version")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "api-version", valid_568496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568498: Call_QueuesRegenerateKeys_568488; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the primary or secondary connection strings to the queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705606.aspx
  let valid = call_568498.validator(path, query, header, formData, body)
  let scheme = call_568498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568498.url(scheme.get, call_568498.host, call_568498.base,
                         call_568498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568498, url, valid)

proc call*(call_568499: Call_QueuesRegenerateKeys_568488; namespaceName: string;
          resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode; queueName: string): Recallable =
  ## queuesRegenerateKeys
  ## Regenerates the primary or secondary connection strings to the queue.
  ## https://msdn.microsoft.com/en-us/library/azure/mt705606.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the authorization rule.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_568500 = newJObject()
  var query_568501 = newJObject()
  var body_568502 = newJObject()
  add(path_568500, "namespaceName", newJString(namespaceName))
  add(path_568500, "resourceGroupName", newJString(resourceGroupName))
  add(query_568501, "api-version", newJString(apiVersion))
  add(path_568500, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568500, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568502 = parameters
  add(path_568500, "queueName", newJString(queueName))
  result = call_568499.call(path_568500, query_568501, nil, nil, body_568502)

var queuesRegenerateKeys* = Call_QueuesRegenerateKeys_568488(
    name: "queuesRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_QueuesRegenerateKeys_568489, base: "",
    url: url_QueuesRegenerateKeys_568490, schemes: {Scheme.Https})
type
  Call_TopicsListAll_568503 = ref object of OpenApiRestCall_567658
proc url_TopicsListAll_568505(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsListAll_568504(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the topics in a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639388.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568506 = path.getOrDefault("namespaceName")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "namespaceName", valid_568506
  var valid_568507 = path.getOrDefault("resourceGroupName")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "resourceGroupName", valid_568507
  var valid_568508 = path.getOrDefault("subscriptionId")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "subscriptionId", valid_568508
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568509 = query.getOrDefault("api-version")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "api-version", valid_568509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568510: Call_TopicsListAll_568503; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the topics in a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639388.aspx
  let valid = call_568510.validator(path, query, header, formData, body)
  let scheme = call_568510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568510.url(scheme.get, call_568510.host, call_568510.base,
                         call_568510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568510, url, valid)

proc call*(call_568511: Call_TopicsListAll_568503; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## topicsListAll
  ## Gets all the topics in a namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639388.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568512 = newJObject()
  var query_568513 = newJObject()
  add(path_568512, "namespaceName", newJString(namespaceName))
  add(path_568512, "resourceGroupName", newJString(resourceGroupName))
  add(query_568513, "api-version", newJString(apiVersion))
  add(path_568512, "subscriptionId", newJString(subscriptionId))
  result = call_568511.call(path_568512, query_568513, nil, nil, nil)

var topicsListAll* = Call_TopicsListAll_568503(name: "topicsListAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics",
    validator: validate_TopicsListAll_568504, base: "", url: url_TopicsListAll_568505,
    schemes: {Scheme.Https})
type
  Call_TopicsCreateOrUpdate_568526 = ref object of OpenApiRestCall_567658
proc url_TopicsCreateOrUpdate_568528(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsCreateOrUpdate_568527(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a topic in the specified namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639409.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568529 = path.getOrDefault("namespaceName")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "namespaceName", valid_568529
  var valid_568530 = path.getOrDefault("resourceGroupName")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "resourceGroupName", valid_568530
  var valid_568531 = path.getOrDefault("topicName")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "topicName", valid_568531
  var valid_568532 = path.getOrDefault("subscriptionId")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "subscriptionId", valid_568532
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568533 = query.getOrDefault("api-version")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "api-version", valid_568533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a topic resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568535: Call_TopicsCreateOrUpdate_568526; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a topic in the specified namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639409.aspx
  let valid = call_568535.validator(path, query, header, formData, body)
  let scheme = call_568535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568535.url(scheme.get, call_568535.host, call_568535.base,
                         call_568535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568535, url, valid)

proc call*(call_568536: Call_TopicsCreateOrUpdate_568526; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## topicsCreateOrUpdate
  ## Creates a topic in the specified namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639409.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a topic resource.
  var path_568537 = newJObject()
  var query_568538 = newJObject()
  var body_568539 = newJObject()
  add(path_568537, "namespaceName", newJString(namespaceName))
  add(path_568537, "resourceGroupName", newJString(resourceGroupName))
  add(query_568538, "api-version", newJString(apiVersion))
  add(path_568537, "topicName", newJString(topicName))
  add(path_568537, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568539 = parameters
  result = call_568536.call(path_568537, query_568538, nil, nil, body_568539)

var topicsCreateOrUpdate* = Call_TopicsCreateOrUpdate_568526(
    name: "topicsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}",
    validator: validate_TopicsCreateOrUpdate_568527, base: "",
    url: url_TopicsCreateOrUpdate_568528, schemes: {Scheme.Https})
type
  Call_TopicsGet_568514 = ref object of OpenApiRestCall_567658
proc url_TopicsGet_568516(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsGet_568515(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a description for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639399.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568517 = path.getOrDefault("namespaceName")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "namespaceName", valid_568517
  var valid_568518 = path.getOrDefault("resourceGroupName")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "resourceGroupName", valid_568518
  var valid_568519 = path.getOrDefault("topicName")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "topicName", valid_568519
  var valid_568520 = path.getOrDefault("subscriptionId")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "subscriptionId", valid_568520
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568521 = query.getOrDefault("api-version")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "api-version", valid_568521
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568522: Call_TopicsGet_568514; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a description for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639399.aspx
  let valid = call_568522.validator(path, query, header, formData, body)
  let scheme = call_568522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568522.url(scheme.get, call_568522.host, call_568522.base,
                         call_568522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568522, url, valid)

proc call*(call_568523: Call_TopicsGet_568514; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string): Recallable =
  ## topicsGet
  ## Returns a description for the specified topic.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639399.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568524 = newJObject()
  var query_568525 = newJObject()
  add(path_568524, "namespaceName", newJString(namespaceName))
  add(path_568524, "resourceGroupName", newJString(resourceGroupName))
  add(query_568525, "api-version", newJString(apiVersion))
  add(path_568524, "topicName", newJString(topicName))
  add(path_568524, "subscriptionId", newJString(subscriptionId))
  result = call_568523.call(path_568524, query_568525, nil, nil, nil)

var topicsGet* = Call_TopicsGet_568514(name: "topicsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}",
                                    validator: validate_TopicsGet_568515,
                                    base: "", url: url_TopicsGet_568516,
                                    schemes: {Scheme.Https})
type
  Call_TopicsDelete_568540 = ref object of OpenApiRestCall_567658
proc url_TopicsDelete_568542(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsDelete_568541(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a topic from the specified namespace and resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639404.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568543 = path.getOrDefault("namespaceName")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "namespaceName", valid_568543
  var valid_568544 = path.getOrDefault("resourceGroupName")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "resourceGroupName", valid_568544
  var valid_568545 = path.getOrDefault("topicName")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "topicName", valid_568545
  var valid_568546 = path.getOrDefault("subscriptionId")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "subscriptionId", valid_568546
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568547 = query.getOrDefault("api-version")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "api-version", valid_568547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568548: Call_TopicsDelete_568540; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a topic from the specified namespace and resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639404.aspx
  let valid = call_568548.validator(path, query, header, formData, body)
  let scheme = call_568548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568548.url(scheme.get, call_568548.host, call_568548.base,
                         call_568548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568548, url, valid)

proc call*(call_568549: Call_TopicsDelete_568540; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string): Recallable =
  ## topicsDelete
  ## Deletes a topic from the specified namespace and resource group.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639404.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568550 = newJObject()
  var query_568551 = newJObject()
  add(path_568550, "namespaceName", newJString(namespaceName))
  add(path_568550, "resourceGroupName", newJString(resourceGroupName))
  add(query_568551, "api-version", newJString(apiVersion))
  add(path_568550, "topicName", newJString(topicName))
  add(path_568550, "subscriptionId", newJString(subscriptionId))
  result = call_568549.call(path_568550, query_568551, nil, nil, nil)

var topicsDelete* = Call_TopicsDelete_568540(name: "topicsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}",
    validator: validate_TopicsDelete_568541, base: "", url: url_TopicsDelete_568542,
    schemes: {Scheme.Https})
type
  Call_TopicsListAuthorizationRules_568552 = ref object of OpenApiRestCall_567658
proc url_TopicsListAuthorizationRules_568554(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/authorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsListAuthorizationRules_568553(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets authorization rules for a topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720681.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568555 = path.getOrDefault("namespaceName")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "namespaceName", valid_568555
  var valid_568556 = path.getOrDefault("resourceGroupName")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "resourceGroupName", valid_568556
  var valid_568557 = path.getOrDefault("topicName")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "topicName", valid_568557
  var valid_568558 = path.getOrDefault("subscriptionId")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "subscriptionId", valid_568558
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568559 = query.getOrDefault("api-version")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "api-version", valid_568559
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568560: Call_TopicsListAuthorizationRules_568552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets authorization rules for a topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720681.aspx
  let valid = call_568560.validator(path, query, header, formData, body)
  let scheme = call_568560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568560.url(scheme.get, call_568560.host, call_568560.base,
                         call_568560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568560, url, valid)

proc call*(call_568561: Call_TopicsListAuthorizationRules_568552;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          topicName: string; subscriptionId: string): Recallable =
  ## topicsListAuthorizationRules
  ## Gets authorization rules for a topic.
  ## https://msdn.microsoft.com/en-us/library/azure/mt720681.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568562 = newJObject()
  var query_568563 = newJObject()
  add(path_568562, "namespaceName", newJString(namespaceName))
  add(path_568562, "resourceGroupName", newJString(resourceGroupName))
  add(query_568563, "api-version", newJString(apiVersion))
  add(path_568562, "topicName", newJString(topicName))
  add(path_568562, "subscriptionId", newJString(subscriptionId))
  result = call_568561.call(path_568562, query_568563, nil, nil, nil)

var topicsListAuthorizationRules* = Call_TopicsListAuthorizationRules_568552(
    name: "topicsListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules",
    validator: validate_TopicsListAuthorizationRules_568553, base: "",
    url: url_TopicsListAuthorizationRules_568554, schemes: {Scheme.Https})
type
  Call_TopicsCreateOrUpdateAuthorizationRule_568577 = ref object of OpenApiRestCall_567658
proc url_TopicsCreateOrUpdateAuthorizationRule_568579(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsCreateOrUpdateAuthorizationRule_568578(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an authorization rule for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720678.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568580 = path.getOrDefault("namespaceName")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "namespaceName", valid_568580
  var valid_568581 = path.getOrDefault("resourceGroupName")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "resourceGroupName", valid_568581
  var valid_568582 = path.getOrDefault("topicName")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = nil)
  if valid_568582 != nil:
    section.add "topicName", valid_568582
  var valid_568583 = path.getOrDefault("authorizationRuleName")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = nil)
  if valid_568583 != nil:
    section.add "authorizationRuleName", valid_568583
  var valid_568584 = path.getOrDefault("subscriptionId")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "subscriptionId", valid_568584
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568585 = query.getOrDefault("api-version")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "api-version", valid_568585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568587: Call_TopicsCreateOrUpdateAuthorizationRule_568577;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an authorization rule for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720678.aspx
  let valid = call_568587.validator(path, query, header, formData, body)
  let scheme = call_568587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568587.url(scheme.get, call_568587.host, call_568587.base,
                         call_568587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568587, url, valid)

proc call*(call_568588: Call_TopicsCreateOrUpdateAuthorizationRule_568577;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          topicName: string; authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## topicsCreateOrUpdateAuthorizationRule
  ## Creates an authorization rule for the specified topic.
  ## https://msdn.microsoft.com/en-us/library/azure/mt720678.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  var path_568589 = newJObject()
  var query_568590 = newJObject()
  var body_568591 = newJObject()
  add(path_568589, "namespaceName", newJString(namespaceName))
  add(path_568589, "resourceGroupName", newJString(resourceGroupName))
  add(query_568590, "api-version", newJString(apiVersion))
  add(path_568589, "topicName", newJString(topicName))
  add(path_568589, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568589, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568591 = parameters
  result = call_568588.call(path_568589, query_568590, nil, nil, body_568591)

var topicsCreateOrUpdateAuthorizationRule* = Call_TopicsCreateOrUpdateAuthorizationRule_568577(
    name: "topicsCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}",
    validator: validate_TopicsCreateOrUpdateAuthorizationRule_568578, base: "",
    url: url_TopicsCreateOrUpdateAuthorizationRule_568579, schemes: {Scheme.Https})
type
  Call_TopicsPostAuthorizationRule_568592 = ref object of OpenApiRestCall_567658
proc url_TopicsPostAuthorizationRule_568594(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsPostAuthorizationRule_568593(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720676.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568595 = path.getOrDefault("namespaceName")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = nil)
  if valid_568595 != nil:
    section.add "namespaceName", valid_568595
  var valid_568596 = path.getOrDefault("resourceGroupName")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "resourceGroupName", valid_568596
  var valid_568597 = path.getOrDefault("topicName")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "topicName", valid_568597
  var valid_568598 = path.getOrDefault("authorizationRuleName")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "authorizationRuleName", valid_568598
  var valid_568599 = path.getOrDefault("subscriptionId")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "subscriptionId", valid_568599
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568600 = query.getOrDefault("api-version")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "api-version", valid_568600
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568601: Call_TopicsPostAuthorizationRule_568592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720676.aspx
  let valid = call_568601.validator(path, query, header, formData, body)
  let scheme = call_568601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568601.url(scheme.get, call_568601.host, call_568601.base,
                         call_568601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568601, url, valid)

proc call*(call_568602: Call_TopicsPostAuthorizationRule_568592;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          topicName: string; authorizationRuleName: string; subscriptionId: string): Recallable =
  ## topicsPostAuthorizationRule
  ## Returns the specified authorization rule.
  ## https://msdn.microsoft.com/en-us/library/azure/mt720676.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568603 = newJObject()
  var query_568604 = newJObject()
  add(path_568603, "namespaceName", newJString(namespaceName))
  add(path_568603, "resourceGroupName", newJString(resourceGroupName))
  add(query_568604, "api-version", newJString(apiVersion))
  add(path_568603, "topicName", newJString(topicName))
  add(path_568603, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568603, "subscriptionId", newJString(subscriptionId))
  result = call_568602.call(path_568603, query_568604, nil, nil, nil)

var topicsPostAuthorizationRule* = Call_TopicsPostAuthorizationRule_568592(
    name: "topicsPostAuthorizationRule", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}",
    validator: validate_TopicsPostAuthorizationRule_568593, base: "",
    url: url_TopicsPostAuthorizationRule_568594, schemes: {Scheme.Https})
type
  Call_TopicsGetAuthorizationRule_568564 = ref object of OpenApiRestCall_567658
proc url_TopicsGetAuthorizationRule_568566(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsGetAuthorizationRule_568565(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720676.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568567 = path.getOrDefault("namespaceName")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "namespaceName", valid_568567
  var valid_568568 = path.getOrDefault("resourceGroupName")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "resourceGroupName", valid_568568
  var valid_568569 = path.getOrDefault("topicName")
  valid_568569 = validateParameter(valid_568569, JString, required = true,
                                 default = nil)
  if valid_568569 != nil:
    section.add "topicName", valid_568569
  var valid_568570 = path.getOrDefault("authorizationRuleName")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "authorizationRuleName", valid_568570
  var valid_568571 = path.getOrDefault("subscriptionId")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "subscriptionId", valid_568571
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568572 = query.getOrDefault("api-version")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "api-version", valid_568572
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568573: Call_TopicsGetAuthorizationRule_568564; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720676.aspx
  let valid = call_568573.validator(path, query, header, formData, body)
  let scheme = call_568573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568573.url(scheme.get, call_568573.host, call_568573.base,
                         call_568573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568573, url, valid)

proc call*(call_568574: Call_TopicsGetAuthorizationRule_568564;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          topicName: string; authorizationRuleName: string; subscriptionId: string): Recallable =
  ## topicsGetAuthorizationRule
  ## Returns the specified authorization rule.
  ## https://msdn.microsoft.com/en-us/library/azure/mt720676.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568575 = newJObject()
  var query_568576 = newJObject()
  add(path_568575, "namespaceName", newJString(namespaceName))
  add(path_568575, "resourceGroupName", newJString(resourceGroupName))
  add(query_568576, "api-version", newJString(apiVersion))
  add(path_568575, "topicName", newJString(topicName))
  add(path_568575, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568575, "subscriptionId", newJString(subscriptionId))
  result = call_568574.call(path_568575, query_568576, nil, nil, nil)

var topicsGetAuthorizationRule* = Call_TopicsGetAuthorizationRule_568564(
    name: "topicsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}",
    validator: validate_TopicsGetAuthorizationRule_568565, base: "",
    url: url_TopicsGetAuthorizationRule_568566, schemes: {Scheme.Https})
type
  Call_TopicsDeleteAuthorizationRule_568605 = ref object of OpenApiRestCall_567658
proc url_TopicsDeleteAuthorizationRule_568607(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsDeleteAuthorizationRule_568606(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a topic authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720681.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568608 = path.getOrDefault("namespaceName")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "namespaceName", valid_568608
  var valid_568609 = path.getOrDefault("resourceGroupName")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "resourceGroupName", valid_568609
  var valid_568610 = path.getOrDefault("topicName")
  valid_568610 = validateParameter(valid_568610, JString, required = true,
                                 default = nil)
  if valid_568610 != nil:
    section.add "topicName", valid_568610
  var valid_568611 = path.getOrDefault("authorizationRuleName")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "authorizationRuleName", valid_568611
  var valid_568612 = path.getOrDefault("subscriptionId")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "subscriptionId", valid_568612
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568613 = query.getOrDefault("api-version")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "api-version", valid_568613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568614: Call_TopicsDeleteAuthorizationRule_568605; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a topic authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720681.aspx
  let valid = call_568614.validator(path, query, header, formData, body)
  let scheme = call_568614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568614.url(scheme.get, call_568614.host, call_568614.base,
                         call_568614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568614, url, valid)

proc call*(call_568615: Call_TopicsDeleteAuthorizationRule_568605;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          topicName: string; authorizationRuleName: string; subscriptionId: string): Recallable =
  ## topicsDeleteAuthorizationRule
  ## Deletes a topic authorization rule.
  ## https://msdn.microsoft.com/en-us/library/azure/mt720681.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568616 = newJObject()
  var query_568617 = newJObject()
  add(path_568616, "namespaceName", newJString(namespaceName))
  add(path_568616, "resourceGroupName", newJString(resourceGroupName))
  add(query_568617, "api-version", newJString(apiVersion))
  add(path_568616, "topicName", newJString(topicName))
  add(path_568616, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568616, "subscriptionId", newJString(subscriptionId))
  result = call_568615.call(path_568616, query_568617, nil, nil, nil)

var topicsDeleteAuthorizationRule* = Call_TopicsDeleteAuthorizationRule_568605(
    name: "topicsDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}",
    validator: validate_TopicsDeleteAuthorizationRule_568606, base: "",
    url: url_TopicsDeleteAuthorizationRule_568607, schemes: {Scheme.Https})
type
  Call_TopicsListKeys_568618 = ref object of OpenApiRestCall_567658
proc url_TopicsListKeys_568620(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/ListKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsListKeys_568619(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the primary and secondary connection strings for the topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720677.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568621 = path.getOrDefault("namespaceName")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "namespaceName", valid_568621
  var valid_568622 = path.getOrDefault("resourceGroupName")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "resourceGroupName", valid_568622
  var valid_568623 = path.getOrDefault("topicName")
  valid_568623 = validateParameter(valid_568623, JString, required = true,
                                 default = nil)
  if valid_568623 != nil:
    section.add "topicName", valid_568623
  var valid_568624 = path.getOrDefault("authorizationRuleName")
  valid_568624 = validateParameter(valid_568624, JString, required = true,
                                 default = nil)
  if valid_568624 != nil:
    section.add "authorizationRuleName", valid_568624
  var valid_568625 = path.getOrDefault("subscriptionId")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "subscriptionId", valid_568625
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568626 = query.getOrDefault("api-version")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "api-version", valid_568626
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568627: Call_TopicsListKeys_568618; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the primary and secondary connection strings for the topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720677.aspx
  let valid = call_568627.validator(path, query, header, formData, body)
  let scheme = call_568627.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568627.url(scheme.get, call_568627.host, call_568627.base,
                         call_568627.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568627, url, valid)

proc call*(call_568628: Call_TopicsListKeys_568618; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## topicsListKeys
  ## Gets the primary and secondary connection strings for the topic.
  ## https://msdn.microsoft.com/en-us/library/azure/mt720677.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568629 = newJObject()
  var query_568630 = newJObject()
  add(path_568629, "namespaceName", newJString(namespaceName))
  add(path_568629, "resourceGroupName", newJString(resourceGroupName))
  add(query_568630, "api-version", newJString(apiVersion))
  add(path_568629, "topicName", newJString(topicName))
  add(path_568629, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568629, "subscriptionId", newJString(subscriptionId))
  result = call_568628.call(path_568629, query_568630, nil, nil, nil)

var topicsListKeys* = Call_TopicsListKeys_568618(name: "topicsListKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}/ListKeys",
    validator: validate_TopicsListKeys_568619, base: "", url: url_TopicsListKeys_568620,
    schemes: {Scheme.Https})
type
  Call_TopicsRegenerateKeys_568631 = ref object of OpenApiRestCall_567658
proc url_TopicsRegenerateKeys_568633(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsRegenerateKeys_568632(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates primary or secondary connection strings for the topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720679.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568634 = path.getOrDefault("namespaceName")
  valid_568634 = validateParameter(valid_568634, JString, required = true,
                                 default = nil)
  if valid_568634 != nil:
    section.add "namespaceName", valid_568634
  var valid_568635 = path.getOrDefault("resourceGroupName")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = nil)
  if valid_568635 != nil:
    section.add "resourceGroupName", valid_568635
  var valid_568636 = path.getOrDefault("topicName")
  valid_568636 = validateParameter(valid_568636, JString, required = true,
                                 default = nil)
  if valid_568636 != nil:
    section.add "topicName", valid_568636
  var valid_568637 = path.getOrDefault("authorizationRuleName")
  valid_568637 = validateParameter(valid_568637, JString, required = true,
                                 default = nil)
  if valid_568637 != nil:
    section.add "authorizationRuleName", valid_568637
  var valid_568638 = path.getOrDefault("subscriptionId")
  valid_568638 = validateParameter(valid_568638, JString, required = true,
                                 default = nil)
  if valid_568638 != nil:
    section.add "subscriptionId", valid_568638
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568639 = query.getOrDefault("api-version")
  valid_568639 = validateParameter(valid_568639, JString, required = true,
                                 default = nil)
  if valid_568639 != nil:
    section.add "api-version", valid_568639
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568641: Call_TopicsRegenerateKeys_568631; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates primary or secondary connection strings for the topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720679.aspx
  let valid = call_568641.validator(path, query, header, formData, body)
  let scheme = call_568641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568641.url(scheme.get, call_568641.host, call_568641.base,
                         call_568641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568641, url, valid)

proc call*(call_568642: Call_TopicsRegenerateKeys_568631; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## topicsRegenerateKeys
  ## Regenerates primary or secondary connection strings for the topic.
  ## https://msdn.microsoft.com/en-us/library/azure/mt720679.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the authorization rule.
  var path_568643 = newJObject()
  var query_568644 = newJObject()
  var body_568645 = newJObject()
  add(path_568643, "namespaceName", newJString(namespaceName))
  add(path_568643, "resourceGroupName", newJString(resourceGroupName))
  add(query_568644, "api-version", newJString(apiVersion))
  add(path_568643, "topicName", newJString(topicName))
  add(path_568643, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568643, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568645 = parameters
  result = call_568642.call(path_568643, query_568644, nil, nil, body_568645)

var topicsRegenerateKeys* = Call_TopicsRegenerateKeys_568631(
    name: "topicsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_TopicsRegenerateKeys_568632, base: "",
    url: url_TopicsRegenerateKeys_568633, schemes: {Scheme.Https})
type
  Call_SubscriptionsListAll_568646 = ref object of OpenApiRestCall_567658
proc url_SubscriptionsListAll_568648(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsListAll_568647(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the subscriptions under a specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639400.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568649 = path.getOrDefault("namespaceName")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = nil)
  if valid_568649 != nil:
    section.add "namespaceName", valid_568649
  var valid_568650 = path.getOrDefault("resourceGroupName")
  valid_568650 = validateParameter(valid_568650, JString, required = true,
                                 default = nil)
  if valid_568650 != nil:
    section.add "resourceGroupName", valid_568650
  var valid_568651 = path.getOrDefault("topicName")
  valid_568651 = validateParameter(valid_568651, JString, required = true,
                                 default = nil)
  if valid_568651 != nil:
    section.add "topicName", valid_568651
  var valid_568652 = path.getOrDefault("subscriptionId")
  valid_568652 = validateParameter(valid_568652, JString, required = true,
                                 default = nil)
  if valid_568652 != nil:
    section.add "subscriptionId", valid_568652
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568653 = query.getOrDefault("api-version")
  valid_568653 = validateParameter(valid_568653, JString, required = true,
                                 default = nil)
  if valid_568653 != nil:
    section.add "api-version", valid_568653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568654: Call_SubscriptionsListAll_568646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the subscriptions under a specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639400.aspx
  let valid = call_568654.validator(path, query, header, formData, body)
  let scheme = call_568654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568654.url(scheme.get, call_568654.host, call_568654.base,
                         call_568654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568654, url, valid)

proc call*(call_568655: Call_SubscriptionsListAll_568646; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string): Recallable =
  ## subscriptionsListAll
  ## List all the subscriptions under a specified topic.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639400.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568656 = newJObject()
  var query_568657 = newJObject()
  add(path_568656, "namespaceName", newJString(namespaceName))
  add(path_568656, "resourceGroupName", newJString(resourceGroupName))
  add(query_568657, "api-version", newJString(apiVersion))
  add(path_568656, "topicName", newJString(topicName))
  add(path_568656, "subscriptionId", newJString(subscriptionId))
  result = call_568655.call(path_568656, query_568657, nil, nil, nil)

var subscriptionsListAll* = Call_SubscriptionsListAll_568646(
    name: "subscriptionsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions",
    validator: validate_SubscriptionsListAll_568647, base: "",
    url: url_SubscriptionsListAll_568648, schemes: {Scheme.Https})
type
  Call_SubscriptionsCreateOrUpdate_568671 = ref object of OpenApiRestCall_567658
proc url_SubscriptionsCreateOrUpdate_568673(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "subscriptionName" in path,
        "`subscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsCreateOrUpdate_568672(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a topic subscription.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639385.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: JString (required)
  ##                   : The subscription name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568674 = path.getOrDefault("namespaceName")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "namespaceName", valid_568674
  var valid_568675 = path.getOrDefault("resourceGroupName")
  valid_568675 = validateParameter(valid_568675, JString, required = true,
                                 default = nil)
  if valid_568675 != nil:
    section.add "resourceGroupName", valid_568675
  var valid_568676 = path.getOrDefault("topicName")
  valid_568676 = validateParameter(valid_568676, JString, required = true,
                                 default = nil)
  if valid_568676 != nil:
    section.add "topicName", valid_568676
  var valid_568677 = path.getOrDefault("subscriptionId")
  valid_568677 = validateParameter(valid_568677, JString, required = true,
                                 default = nil)
  if valid_568677 != nil:
    section.add "subscriptionId", valid_568677
  var valid_568678 = path.getOrDefault("subscriptionName")
  valid_568678 = validateParameter(valid_568678, JString, required = true,
                                 default = nil)
  if valid_568678 != nil:
    section.add "subscriptionName", valid_568678
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568679 = query.getOrDefault("api-version")
  valid_568679 = validateParameter(valid_568679, JString, required = true,
                                 default = nil)
  if valid_568679 != nil:
    section.add "api-version", valid_568679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a subscription resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568681: Call_SubscriptionsCreateOrUpdate_568671; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a topic subscription.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639385.aspx
  let valid = call_568681.validator(path, query, header, formData, body)
  let scheme = call_568681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568681.url(scheme.get, call_568681.host, call_568681.base,
                         call_568681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568681, url, valid)

proc call*(call_568682: Call_SubscriptionsCreateOrUpdate_568671;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          topicName: string; subscriptionId: string; subscriptionName: string;
          parameters: JsonNode): Recallable =
  ## subscriptionsCreateOrUpdate
  ## Creates a topic subscription.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639385.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: string (required)
  ##                   : The subscription name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a subscription resource.
  var path_568683 = newJObject()
  var query_568684 = newJObject()
  var body_568685 = newJObject()
  add(path_568683, "namespaceName", newJString(namespaceName))
  add(path_568683, "resourceGroupName", newJString(resourceGroupName))
  add(query_568684, "api-version", newJString(apiVersion))
  add(path_568683, "topicName", newJString(topicName))
  add(path_568683, "subscriptionId", newJString(subscriptionId))
  add(path_568683, "subscriptionName", newJString(subscriptionName))
  if parameters != nil:
    body_568685 = parameters
  result = call_568682.call(path_568683, query_568684, nil, nil, body_568685)

var subscriptionsCreateOrUpdate* = Call_SubscriptionsCreateOrUpdate_568671(
    name: "subscriptionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}",
    validator: validate_SubscriptionsCreateOrUpdate_568672, base: "",
    url: url_SubscriptionsCreateOrUpdate_568673, schemes: {Scheme.Https})
type
  Call_SubscriptionsGet_568658 = ref object of OpenApiRestCall_567658
proc url_SubscriptionsGet_568660(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "subscriptionName" in path,
        "`subscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsGet_568659(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns a subscription description for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639402.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: JString (required)
  ##                   : The subscription name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568661 = path.getOrDefault("namespaceName")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = nil)
  if valid_568661 != nil:
    section.add "namespaceName", valid_568661
  var valid_568662 = path.getOrDefault("resourceGroupName")
  valid_568662 = validateParameter(valid_568662, JString, required = true,
                                 default = nil)
  if valid_568662 != nil:
    section.add "resourceGroupName", valid_568662
  var valid_568663 = path.getOrDefault("topicName")
  valid_568663 = validateParameter(valid_568663, JString, required = true,
                                 default = nil)
  if valid_568663 != nil:
    section.add "topicName", valid_568663
  var valid_568664 = path.getOrDefault("subscriptionId")
  valid_568664 = validateParameter(valid_568664, JString, required = true,
                                 default = nil)
  if valid_568664 != nil:
    section.add "subscriptionId", valid_568664
  var valid_568665 = path.getOrDefault("subscriptionName")
  valid_568665 = validateParameter(valid_568665, JString, required = true,
                                 default = nil)
  if valid_568665 != nil:
    section.add "subscriptionName", valid_568665
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568666 = query.getOrDefault("api-version")
  valid_568666 = validateParameter(valid_568666, JString, required = true,
                                 default = nil)
  if valid_568666 != nil:
    section.add "api-version", valid_568666
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568667: Call_SubscriptionsGet_568658; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a subscription description for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639402.aspx
  let valid = call_568667.validator(path, query, header, formData, body)
  let scheme = call_568667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568667.url(scheme.get, call_568667.host, call_568667.base,
                         call_568667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568667, url, valid)

proc call*(call_568668: Call_SubscriptionsGet_568658; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string; subscriptionName: string): Recallable =
  ## subscriptionsGet
  ## Returns a subscription description for the specified topic.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639402.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: string (required)
  ##                   : The subscription name.
  var path_568669 = newJObject()
  var query_568670 = newJObject()
  add(path_568669, "namespaceName", newJString(namespaceName))
  add(path_568669, "resourceGroupName", newJString(resourceGroupName))
  add(query_568670, "api-version", newJString(apiVersion))
  add(path_568669, "topicName", newJString(topicName))
  add(path_568669, "subscriptionId", newJString(subscriptionId))
  add(path_568669, "subscriptionName", newJString(subscriptionName))
  result = call_568668.call(path_568669, query_568670, nil, nil, nil)

var subscriptionsGet* = Call_SubscriptionsGet_568658(name: "subscriptionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}",
    validator: validate_SubscriptionsGet_568659, base: "",
    url: url_SubscriptionsGet_568660, schemes: {Scheme.Https})
type
  Call_SubscriptionsDelete_568686 = ref object of OpenApiRestCall_567658
proc url_SubscriptionsDelete_568688(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "subscriptionName" in path,
        "`subscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsDelete_568687(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a subscription from the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639381.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: JString (required)
  ##                   : The subscription name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568689 = path.getOrDefault("namespaceName")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "namespaceName", valid_568689
  var valid_568690 = path.getOrDefault("resourceGroupName")
  valid_568690 = validateParameter(valid_568690, JString, required = true,
                                 default = nil)
  if valid_568690 != nil:
    section.add "resourceGroupName", valid_568690
  var valid_568691 = path.getOrDefault("topicName")
  valid_568691 = validateParameter(valid_568691, JString, required = true,
                                 default = nil)
  if valid_568691 != nil:
    section.add "topicName", valid_568691
  var valid_568692 = path.getOrDefault("subscriptionId")
  valid_568692 = validateParameter(valid_568692, JString, required = true,
                                 default = nil)
  if valid_568692 != nil:
    section.add "subscriptionId", valid_568692
  var valid_568693 = path.getOrDefault("subscriptionName")
  valid_568693 = validateParameter(valid_568693, JString, required = true,
                                 default = nil)
  if valid_568693 != nil:
    section.add "subscriptionName", valid_568693
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568694 = query.getOrDefault("api-version")
  valid_568694 = validateParameter(valid_568694, JString, required = true,
                                 default = nil)
  if valid_568694 != nil:
    section.add "api-version", valid_568694
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568695: Call_SubscriptionsDelete_568686; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a subscription from the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639381.aspx
  let valid = call_568695.validator(path, query, header, formData, body)
  let scheme = call_568695.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568695.url(scheme.get, call_568695.host, call_568695.base,
                         call_568695.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568695, url, valid)

proc call*(call_568696: Call_SubscriptionsDelete_568686; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string; subscriptionName: string): Recallable =
  ## subscriptionsDelete
  ## Deletes a subscription from the specified topic.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639381.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: string (required)
  ##                   : The subscription name.
  var path_568697 = newJObject()
  var query_568698 = newJObject()
  add(path_568697, "namespaceName", newJString(namespaceName))
  add(path_568697, "resourceGroupName", newJString(resourceGroupName))
  add(query_568698, "api-version", newJString(apiVersion))
  add(path_568697, "topicName", newJString(topicName))
  add(path_568697, "subscriptionId", newJString(subscriptionId))
  add(path_568697, "subscriptionName", newJString(subscriptionName))
  result = call_568696.call(path_568697, query_568698, nil, nil, nil)

var subscriptionsDelete* = Call_SubscriptionsDelete_568686(
    name: "subscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}",
    validator: validate_SubscriptionsDelete_568687, base: "",
    url: url_SubscriptionsDelete_568688, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
