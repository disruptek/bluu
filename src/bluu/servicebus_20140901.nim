
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ServiceBusManagementClient
## version: 2014-09-01
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  Call_OperationsList_567879 = ref object of OpenApiRestCall_567657
proc url_OperationsList_567881(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567880(path: JsonNode; query: JsonNode;
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
  var valid_568040 = query.getOrDefault("api-version")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "api-version", valid_568040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568063: Call_OperationsList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available ServiceBus REST API operations.
  ## 
  let valid = call_568063.validator(path, query, header, formData, body)
  let scheme = call_568063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568063.url(scheme.get, call_568063.host, call_568063.base,
                         call_568063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568063, url, valid)

proc call*(call_568134: Call_OperationsList_567879; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available ServiceBus REST API operations.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var operationsList* = Call_OperationsList_567879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceBus/operations",
    validator: validate_OperationsList_567880, base: "", url: url_OperationsList_567881,
    schemes: {Scheme.Https})
type
  Call_NamespacesCheckNameAvailability_568175 = ref object of OpenApiRestCall_567657
proc url_NamespacesCheckNameAvailability_568177(protocol: Scheme; host: string;
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

proc validate_NamespacesCheckNameAvailability_568176(path: JsonNode;
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
  var valid_568209 = path.getOrDefault("subscriptionId")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "subscriptionId", valid_568209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568210 = query.getOrDefault("api-version")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "api-version", valid_568210
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

proc call*(call_568212: Call_NamespacesCheckNameAvailability_568175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give namespace name availability.
  ## 
  let valid = call_568212.validator(path, query, header, formData, body)
  let scheme = call_568212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568212.url(scheme.get, call_568212.host, call_568212.base,
                         call_568212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568212, url, valid)

proc call*(call_568213: Call_NamespacesCheckNameAvailability_568175;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCheckNameAvailability
  ## Check the give namespace name availability.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given namespace name
  var path_568214 = newJObject()
  var query_568215 = newJObject()
  var body_568216 = newJObject()
  add(query_568215, "api-version", newJString(apiVersion))
  add(path_568214, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568216 = parameters
  result = call_568213.call(path_568214, query_568215, nil, nil, body_568216)

var namespacesCheckNameAvailability* = Call_NamespacesCheckNameAvailability_568175(
    name: "namespacesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceBus/CheckNameAvailability",
    validator: validate_NamespacesCheckNameAvailability_568176, base: "",
    url: url_NamespacesCheckNameAvailability_568177, schemes: {Scheme.Https})
type
  Call_NamespacesCheckNameSpaceAvailability_568217 = ref object of OpenApiRestCall_567657
proc url_NamespacesCheckNameSpaceAvailability_568219(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/CheckNameSpaceAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCheckNameSpaceAvailability_568218(path: JsonNode;
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
  var valid_568220 = path.getOrDefault("subscriptionId")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "subscriptionId", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
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

proc call*(call_568223: Call_NamespacesCheckNameSpaceAvailability_568217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give namespace name availability.
  ## 
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_NamespacesCheckNameSpaceAvailability_568217;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCheckNameSpaceAvailability
  ## Check the give namespace name availability.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given namespace name
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  var body_568227 = newJObject()
  add(query_568226, "api-version", newJString(apiVersion))
  add(path_568225, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568227 = parameters
  result = call_568224.call(path_568225, query_568226, nil, nil, body_568227)

var namespacesCheckNameSpaceAvailability* = Call_NamespacesCheckNameSpaceAvailability_568217(
    name: "namespacesCheckNameSpaceAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceBus/CheckNameSpaceAvailability",
    validator: validate_NamespacesCheckNameSpaceAvailability_568218, base: "",
    url: url_NamespacesCheckNameSpaceAvailability_568219, schemes: {Scheme.Https})
type
  Call_NamespacesListBySubscription_568228 = ref object of OpenApiRestCall_567657
proc url_NamespacesListBySubscription_568230(protocol: Scheme; host: string;
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

proc validate_NamespacesListBySubscription_568229(path: JsonNode; query: JsonNode;
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

proc call*(call_568233: Call_NamespacesListBySubscription_568228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the available namespaces within the subscription, irrespective of the resource groups.
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

proc call*(call_568234: Call_NamespacesListBySubscription_568228;
          apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesListBySubscription
  ## Gets all the available namespaces within the subscription, irrespective of the resource groups.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var namespacesListBySubscription* = Call_NamespacesListBySubscription_568228(
    name: "namespacesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceBus/namespaces",
    validator: validate_NamespacesListBySubscription_568229, base: "",
    url: url_NamespacesListBySubscription_568230, schemes: {Scheme.Https})
type
  Call_NamespacesListByResourceGroup_568237 = ref object of OpenApiRestCall_567657
proc url_NamespacesListByResourceGroup_568239(protocol: Scheme; host: string;
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

proc validate_NamespacesListByResourceGroup_568238(path: JsonNode; query: JsonNode;
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
  var valid_568240 = path.getOrDefault("resourceGroupName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "resourceGroupName", valid_568240
  var valid_568241 = path.getOrDefault("subscriptionId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "subscriptionId", valid_568241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568242 = query.getOrDefault("api-version")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "api-version", valid_568242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568243: Call_NamespacesListByResourceGroup_568237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the available namespaces within a resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_NamespacesListByResourceGroup_568237;
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
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  add(path_568245, "resourceGroupName", newJString(resourceGroupName))
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "subscriptionId", newJString(subscriptionId))
  result = call_568244.call(path_568245, query_568246, nil, nil, nil)

var namespacesListByResourceGroup* = Call_NamespacesListByResourceGroup_568237(
    name: "namespacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces",
    validator: validate_NamespacesListByResourceGroup_568238, base: "",
    url: url_NamespacesListByResourceGroup_568239, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdate_568258 = ref object of OpenApiRestCall_567657
proc url_NamespacesCreateOrUpdate_568260(protocol: Scheme; host: string;
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

proc validate_NamespacesCreateOrUpdate_568259(path: JsonNode; query: JsonNode;
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
  var valid_568261 = path.getOrDefault("namespaceName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "namespaceName", valid_568261
  var valid_568262 = path.getOrDefault("resourceGroupName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "resourceGroupName", valid_568262
  var valid_568263 = path.getOrDefault("subscriptionId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "subscriptionId", valid_568263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568264 = query.getOrDefault("api-version")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "api-version", valid_568264
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

proc call*(call_568266: Call_NamespacesCreateOrUpdate_568258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639408.aspx
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_NamespacesCreateOrUpdate_568258;
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
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  var body_568270 = newJObject()
  add(path_568268, "namespaceName", newJString(namespaceName))
  add(path_568268, "resourceGroupName", newJString(resourceGroupName))
  add(query_568269, "api-version", newJString(apiVersion))
  add(path_568268, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568270 = parameters
  result = call_568267.call(path_568268, query_568269, nil, nil, body_568270)

var namespacesCreateOrUpdate* = Call_NamespacesCreateOrUpdate_568258(
    name: "namespacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}",
    validator: validate_NamespacesCreateOrUpdate_568259, base: "",
    url: url_NamespacesCreateOrUpdate_568260, schemes: {Scheme.Https})
type
  Call_NamespacesGet_568247 = ref object of OpenApiRestCall_567657
proc url_NamespacesGet_568249(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesGet_568248(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568250 = path.getOrDefault("namespaceName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "namespaceName", valid_568250
  var valid_568251 = path.getOrDefault("resourceGroupName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "resourceGroupName", valid_568251
  var valid_568252 = path.getOrDefault("subscriptionId")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "subscriptionId", valid_568252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568253 = query.getOrDefault("api-version")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "api-version", valid_568253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568254: Call_NamespacesGet_568247; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a description for the specified namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639379.aspx
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_NamespacesGet_568247; namespaceName: string;
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
  var path_568256 = newJObject()
  var query_568257 = newJObject()
  add(path_568256, "namespaceName", newJString(namespaceName))
  add(path_568256, "resourceGroupName", newJString(resourceGroupName))
  add(query_568257, "api-version", newJString(apiVersion))
  add(path_568256, "subscriptionId", newJString(subscriptionId))
  result = call_568255.call(path_568256, query_568257, nil, nil, nil)

var namespacesGet* = Call_NamespacesGet_568247(name: "namespacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}",
    validator: validate_NamespacesGet_568248, base: "", url: url_NamespacesGet_568249,
    schemes: {Scheme.Https})
type
  Call_NamespacesUpdate_568282 = ref object of OpenApiRestCall_567657
proc url_NamespacesUpdate_568284(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesUpdate_568283(path: JsonNode; query: JsonNode;
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
  var valid_568285 = path.getOrDefault("namespaceName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "namespaceName", valid_568285
  var valid_568286 = path.getOrDefault("resourceGroupName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "resourceGroupName", valid_568286
  var valid_568287 = path.getOrDefault("subscriptionId")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "subscriptionId", valid_568287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568288 = query.getOrDefault("api-version")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "api-version", valid_568288
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

proc call*(call_568290: Call_NamespacesUpdate_568282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  let valid = call_568290.validator(path, query, header, formData, body)
  let scheme = call_568290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568290.url(scheme.get, call_568290.host, call_568290.base,
                         call_568290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568290, url, valid)

proc call*(call_568291: Call_NamespacesUpdate_568282; namespaceName: string;
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
  var path_568292 = newJObject()
  var query_568293 = newJObject()
  var body_568294 = newJObject()
  add(path_568292, "namespaceName", newJString(namespaceName))
  add(path_568292, "resourceGroupName", newJString(resourceGroupName))
  add(query_568293, "api-version", newJString(apiVersion))
  add(path_568292, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568294 = parameters
  result = call_568291.call(path_568292, query_568293, nil, nil, body_568294)

var namespacesUpdate* = Call_NamespacesUpdate_568282(name: "namespacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}",
    validator: validate_NamespacesUpdate_568283, base: "",
    url: url_NamespacesUpdate_568284, schemes: {Scheme.Https})
type
  Call_NamespacesDelete_568271 = ref object of OpenApiRestCall_567657
proc url_NamespacesDelete_568273(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesDelete_568272(path: JsonNode; query: JsonNode;
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
  var valid_568274 = path.getOrDefault("namespaceName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "namespaceName", valid_568274
  var valid_568275 = path.getOrDefault("resourceGroupName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "resourceGroupName", valid_568275
  var valid_568276 = path.getOrDefault("subscriptionId")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "subscriptionId", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568277 = query.getOrDefault("api-version")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "api-version", valid_568277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568278: Call_NamespacesDelete_568271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639389.aspx
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_NamespacesDelete_568271; namespaceName: string;
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
  var path_568280 = newJObject()
  var query_568281 = newJObject()
  add(path_568280, "namespaceName", newJString(namespaceName))
  add(path_568280, "resourceGroupName", newJString(resourceGroupName))
  add(query_568281, "api-version", newJString(apiVersion))
  add(path_568280, "subscriptionId", newJString(subscriptionId))
  result = call_568279.call(path_568280, query_568281, nil, nil, nil)

var namespacesDelete* = Call_NamespacesDelete_568271(name: "namespacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}",
    validator: validate_NamespacesDelete_568272, base: "",
    url: url_NamespacesDelete_568273, schemes: {Scheme.Https})
type
  Call_NamespacesListPostAuthorizationRules_568306 = ref object of OpenApiRestCall_567657
proc url_NamespacesListPostAuthorizationRules_568308(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_NamespacesListPostAuthorizationRules_568307(path: JsonNode;
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
  var valid_568309 = path.getOrDefault("namespaceName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "namespaceName", valid_568309
  var valid_568310 = path.getOrDefault("resourceGroupName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "resourceGroupName", valid_568310
  var valid_568311 = path.getOrDefault("subscriptionId")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "subscriptionId", valid_568311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568312 = query.getOrDefault("api-version")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "api-version", valid_568312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568313: Call_NamespacesListPostAuthorizationRules_568306;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639376.aspx
  let valid = call_568313.validator(path, query, header, formData, body)
  let scheme = call_568313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568313.url(scheme.get, call_568313.host, call_568313.base,
                         call_568313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568313, url, valid)

proc call*(call_568314: Call_NamespacesListPostAuthorizationRules_568306;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesListPostAuthorizationRules
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
  var path_568315 = newJObject()
  var query_568316 = newJObject()
  add(path_568315, "namespaceName", newJString(namespaceName))
  add(path_568315, "resourceGroupName", newJString(resourceGroupName))
  add(query_568316, "api-version", newJString(apiVersion))
  add(path_568315, "subscriptionId", newJString(subscriptionId))
  result = call_568314.call(path_568315, query_568316, nil, nil, nil)

var namespacesListPostAuthorizationRules* = Call_NamespacesListPostAuthorizationRules_568306(
    name: "namespacesListPostAuthorizationRules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListPostAuthorizationRules_568307, base: "",
    url: url_NamespacesListPostAuthorizationRules_568308, schemes: {Scheme.Https})
type
  Call_NamespacesListAuthorizationRules_568295 = ref object of OpenApiRestCall_567657
proc url_NamespacesListAuthorizationRules_568297(protocol: Scheme; host: string;
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

proc validate_NamespacesListAuthorizationRules_568296(path: JsonNode;
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
  var valid_568298 = path.getOrDefault("namespaceName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "namespaceName", valid_568298
  var valid_568299 = path.getOrDefault("resourceGroupName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "resourceGroupName", valid_568299
  var valid_568300 = path.getOrDefault("subscriptionId")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "subscriptionId", valid_568300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568301 = query.getOrDefault("api-version")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "api-version", valid_568301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568302: Call_NamespacesListAuthorizationRules_568295;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639376.aspx
  let valid = call_568302.validator(path, query, header, formData, body)
  let scheme = call_568302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568302.url(scheme.get, call_568302.host, call_568302.base,
                         call_568302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568302, url, valid)

proc call*(call_568303: Call_NamespacesListAuthorizationRules_568295;
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
  var path_568304 = newJObject()
  var query_568305 = newJObject()
  add(path_568304, "namespaceName", newJString(namespaceName))
  add(path_568304, "resourceGroupName", newJString(resourceGroupName))
  add(query_568305, "api-version", newJString(apiVersion))
  add(path_568304, "subscriptionId", newJString(subscriptionId))
  result = call_568303.call(path_568304, query_568305, nil, nil, nil)

var namespacesListAuthorizationRules* = Call_NamespacesListAuthorizationRules_568295(
    name: "namespacesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListAuthorizationRules_568296, base: "",
    url: url_NamespacesListAuthorizationRules_568297, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateAuthorizationRule_568329 = ref object of OpenApiRestCall_567657
proc url_NamespacesCreateOrUpdateAuthorizationRule_568331(protocol: Scheme;
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

proc validate_NamespacesCreateOrUpdateAuthorizationRule_568330(path: JsonNode;
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
  var valid_568332 = path.getOrDefault("namespaceName")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "namespaceName", valid_568332
  var valid_568333 = path.getOrDefault("resourceGroupName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "resourceGroupName", valid_568333
  var valid_568334 = path.getOrDefault("authorizationRuleName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "authorizationRuleName", valid_568334
  var valid_568335 = path.getOrDefault("subscriptionId")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "subscriptionId", valid_568335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568336 = query.getOrDefault("api-version")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "api-version", valid_568336
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

proc call*(call_568338: Call_NamespacesCreateOrUpdateAuthorizationRule_568329;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an authorization rule for a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639410.aspx
  let valid = call_568338.validator(path, query, header, formData, body)
  let scheme = call_568338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568338.url(scheme.get, call_568338.host, call_568338.base,
                         call_568338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568338, url, valid)

proc call*(call_568339: Call_NamespacesCreateOrUpdateAuthorizationRule_568329;
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
  var path_568340 = newJObject()
  var query_568341 = newJObject()
  var body_568342 = newJObject()
  add(path_568340, "namespaceName", newJString(namespaceName))
  add(path_568340, "resourceGroupName", newJString(resourceGroupName))
  add(query_568341, "api-version", newJString(apiVersion))
  add(path_568340, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568340, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568342 = parameters
  result = call_568339.call(path_568340, query_568341, nil, nil, body_568342)

var namespacesCreateOrUpdateAuthorizationRule* = Call_NamespacesCreateOrUpdateAuthorizationRule_568329(
    name: "namespacesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesCreateOrUpdateAuthorizationRule_568330,
    base: "", url: url_NamespacesCreateOrUpdateAuthorizationRule_568331,
    schemes: {Scheme.Https})
type
  Call_NamespacesPostAuthorizationRule_568343 = ref object of OpenApiRestCall_567657
proc url_NamespacesPostAuthorizationRule_568345(protocol: Scheme; host: string;
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

proc validate_NamespacesPostAuthorizationRule_568344(path: JsonNode;
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
  var valid_568346 = path.getOrDefault("namespaceName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "namespaceName", valid_568346
  var valid_568347 = path.getOrDefault("resourceGroupName")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "resourceGroupName", valid_568347
  var valid_568348 = path.getOrDefault("authorizationRuleName")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "authorizationRuleName", valid_568348
  var valid_568349 = path.getOrDefault("subscriptionId")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "subscriptionId", valid_568349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568350 = query.getOrDefault("api-version")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "api-version", valid_568350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568351: Call_NamespacesPostAuthorizationRule_568343;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an authorization rule for a namespace by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639392.aspx
  let valid = call_568351.validator(path, query, header, formData, body)
  let scheme = call_568351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568351.url(scheme.get, call_568351.host, call_568351.base,
                         call_568351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568351, url, valid)

proc call*(call_568352: Call_NamespacesPostAuthorizationRule_568343;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesPostAuthorizationRule
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
  var path_568353 = newJObject()
  var query_568354 = newJObject()
  add(path_568353, "namespaceName", newJString(namespaceName))
  add(path_568353, "resourceGroupName", newJString(resourceGroupName))
  add(query_568354, "api-version", newJString(apiVersion))
  add(path_568353, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568353, "subscriptionId", newJString(subscriptionId))
  result = call_568352.call(path_568353, query_568354, nil, nil, nil)

var namespacesPostAuthorizationRule* = Call_NamespacesPostAuthorizationRule_568343(
    name: "namespacesPostAuthorizationRule", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesPostAuthorizationRule_568344, base: "",
    url: url_NamespacesPostAuthorizationRule_568345, schemes: {Scheme.Https})
type
  Call_NamespacesGetAuthorizationRule_568317 = ref object of OpenApiRestCall_567657
proc url_NamespacesGetAuthorizationRule_568319(protocol: Scheme; host: string;
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

proc validate_NamespacesGetAuthorizationRule_568318(path: JsonNode;
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
  var valid_568320 = path.getOrDefault("namespaceName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "namespaceName", valid_568320
  var valid_568321 = path.getOrDefault("resourceGroupName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "resourceGroupName", valid_568321
  var valid_568322 = path.getOrDefault("authorizationRuleName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "authorizationRuleName", valid_568322
  var valid_568323 = path.getOrDefault("subscriptionId")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "subscriptionId", valid_568323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568324 = query.getOrDefault("api-version")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "api-version", valid_568324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568325: Call_NamespacesGetAuthorizationRule_568317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an authorization rule for a namespace by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639392.aspx
  let valid = call_568325.validator(path, query, header, formData, body)
  let scheme = call_568325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568325.url(scheme.get, call_568325.host, call_568325.base,
                         call_568325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568325, url, valid)

proc call*(call_568326: Call_NamespacesGetAuthorizationRule_568317;
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
  var path_568327 = newJObject()
  var query_568328 = newJObject()
  add(path_568327, "namespaceName", newJString(namespaceName))
  add(path_568327, "resourceGroupName", newJString(resourceGroupName))
  add(query_568328, "api-version", newJString(apiVersion))
  add(path_568327, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568327, "subscriptionId", newJString(subscriptionId))
  result = call_568326.call(path_568327, query_568328, nil, nil, nil)

var namespacesGetAuthorizationRule* = Call_NamespacesGetAuthorizationRule_568317(
    name: "namespacesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesGetAuthorizationRule_568318, base: "",
    url: url_NamespacesGetAuthorizationRule_568319, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteAuthorizationRule_568355 = ref object of OpenApiRestCall_567657
proc url_NamespacesDeleteAuthorizationRule_568357(protocol: Scheme; host: string;
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

proc validate_NamespacesDeleteAuthorizationRule_568356(path: JsonNode;
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
  var valid_568358 = path.getOrDefault("namespaceName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "namespaceName", valid_568358
  var valid_568359 = path.getOrDefault("resourceGroupName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "resourceGroupName", valid_568359
  var valid_568360 = path.getOrDefault("authorizationRuleName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "authorizationRuleName", valid_568360
  var valid_568361 = path.getOrDefault("subscriptionId")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "subscriptionId", valid_568361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568362 = query.getOrDefault("api-version")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "api-version", valid_568362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568363: Call_NamespacesDeleteAuthorizationRule_568355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a namespace authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639417.aspx
  let valid = call_568363.validator(path, query, header, formData, body)
  let scheme = call_568363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568363.url(scheme.get, call_568363.host, call_568363.base,
                         call_568363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568363, url, valid)

proc call*(call_568364: Call_NamespacesDeleteAuthorizationRule_568355;
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
  var path_568365 = newJObject()
  var query_568366 = newJObject()
  add(path_568365, "namespaceName", newJString(namespaceName))
  add(path_568365, "resourceGroupName", newJString(resourceGroupName))
  add(query_568366, "api-version", newJString(apiVersion))
  add(path_568365, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568365, "subscriptionId", newJString(subscriptionId))
  result = call_568364.call(path_568365, query_568366, nil, nil, nil)

var namespacesDeleteAuthorizationRule* = Call_NamespacesDeleteAuthorizationRule_568355(
    name: "namespacesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesDeleteAuthorizationRule_568356, base: "",
    url: url_NamespacesDeleteAuthorizationRule_568357, schemes: {Scheme.Https})
type
  Call_EventHubListAuthorizationRules_568367 = ref object of OpenApiRestCall_567657
proc url_EventHubListAuthorizationRules_568369(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventhubName" in path, "`eventhubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventhubName"),
               (kind: ConstantSegment, value: "/authorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubListAuthorizationRules_568368(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets authorization rules for a eventhub.
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
  ##   eventhubName: JString (required)
  ##               : The eventhub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568370 = path.getOrDefault("namespaceName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "namespaceName", valid_568370
  var valid_568371 = path.getOrDefault("resourceGroupName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "resourceGroupName", valid_568371
  var valid_568372 = path.getOrDefault("subscriptionId")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "subscriptionId", valid_568372
  var valid_568373 = path.getOrDefault("eventhubName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "eventhubName", valid_568373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568374 = query.getOrDefault("api-version")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "api-version", valid_568374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568375: Call_EventHubListAuthorizationRules_568367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets authorization rules for a eventhub.
  ## 
  let valid = call_568375.validator(path, query, header, formData, body)
  let scheme = call_568375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568375.url(scheme.get, call_568375.host, call_568375.base,
                         call_568375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568375, url, valid)

proc call*(call_568376: Call_EventHubListAuthorizationRules_568367;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; eventhubName: string): Recallable =
  ## eventHubListAuthorizationRules
  ## Gets authorization rules for a eventhub.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   eventhubName: string (required)
  ##               : The eventhub name.
  var path_568377 = newJObject()
  var query_568378 = newJObject()
  add(path_568377, "namespaceName", newJString(namespaceName))
  add(path_568377, "resourceGroupName", newJString(resourceGroupName))
  add(query_568378, "api-version", newJString(apiVersion))
  add(path_568377, "subscriptionId", newJString(subscriptionId))
  add(path_568377, "eventhubName", newJString(eventhubName))
  result = call_568376.call(path_568377, query_568378, nil, nil, nil)

var eventHubListAuthorizationRules* = Call_EventHubListAuthorizationRules_568367(
    name: "eventHubListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/eventhubs/{eventhubName}/authorizationRules",
    validator: validate_EventHubListAuthorizationRules_568368, base: "",
    url: url_EventHubListAuthorizationRules_568369, schemes: {Scheme.Https})
type
  Call_EventHubGetAuthorizationRule_568379 = ref object of OpenApiRestCall_567657
proc url_EventHubGetAuthorizationRule_568381(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventhubName" in path, "`eventhubName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventhubName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubGetAuthorizationRule_568380(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified authorization rule.
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
  ##   eventhubName: JString (required)
  ##               : The eventhub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568382 = path.getOrDefault("namespaceName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "namespaceName", valid_568382
  var valid_568383 = path.getOrDefault("resourceGroupName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "resourceGroupName", valid_568383
  var valid_568384 = path.getOrDefault("authorizationRuleName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "authorizationRuleName", valid_568384
  var valid_568385 = path.getOrDefault("subscriptionId")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "subscriptionId", valid_568385
  var valid_568386 = path.getOrDefault("eventhubName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "eventhubName", valid_568386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568387 = query.getOrDefault("api-version")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "api-version", valid_568387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568388: Call_EventHubGetAuthorizationRule_568379; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified authorization rule.
  ## 
  let valid = call_568388.validator(path, query, header, formData, body)
  let scheme = call_568388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568388.url(scheme.get, call_568388.host, call_568388.base,
                         call_568388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568388, url, valid)

proc call*(call_568389: Call_EventHubGetAuthorizationRule_568379;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          eventhubName: string): Recallable =
  ## eventHubGetAuthorizationRule
  ## Returns the specified authorization rule.
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
  ##   eventhubName: string (required)
  ##               : The eventhub name.
  var path_568390 = newJObject()
  var query_568391 = newJObject()
  add(path_568390, "namespaceName", newJString(namespaceName))
  add(path_568390, "resourceGroupName", newJString(resourceGroupName))
  add(query_568391, "api-version", newJString(apiVersion))
  add(path_568390, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568390, "subscriptionId", newJString(subscriptionId))
  add(path_568390, "eventhubName", newJString(eventhubName))
  result = call_568389.call(path_568390, query_568391, nil, nil, nil)

var eventHubGetAuthorizationRule* = Call_EventHubGetAuthorizationRule_568379(
    name: "eventHubGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/eventhubs/{eventhubName}/authorizationRules/{authorizationRuleName}",
    validator: validate_EventHubGetAuthorizationRule_568380, base: "",
    url: url_EventHubGetAuthorizationRule_568381, schemes: {Scheme.Https})
type
  Call_MessagingPlanCreateOrUpdate_568403 = ref object of OpenApiRestCall_567657
proc url_MessagingPlanCreateOrUpdate_568405(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/messagingplan")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MessagingPlanCreateOrUpdate_568404(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Messaging Plan for a namespace
  ## 
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
  var valid_568406 = path.getOrDefault("namespaceName")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "namespaceName", valid_568406
  var valid_568407 = path.getOrDefault("resourceGroupName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "resourceGroupName", valid_568407
  var valid_568408 = path.getOrDefault("subscriptionId")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "subscriptionId", valid_568408
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568409 = query.getOrDefault("api-version")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "api-version", valid_568409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a messaging plan.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568411: Call_MessagingPlanCreateOrUpdate_568403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Messaging Plan for a namespace
  ## 
  let valid = call_568411.validator(path, query, header, formData, body)
  let scheme = call_568411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568411.url(scheme.get, call_568411.host, call_568411.base,
                         call_568411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568411, url, valid)

proc call*(call_568412: Call_MessagingPlanCreateOrUpdate_568403;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## messagingPlanCreateOrUpdate
  ## Creates or updates a Messaging Plan for a namespace
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a messaging plan.
  var path_568413 = newJObject()
  var query_568414 = newJObject()
  var body_568415 = newJObject()
  add(path_568413, "namespaceName", newJString(namespaceName))
  add(path_568413, "resourceGroupName", newJString(resourceGroupName))
  add(query_568414, "api-version", newJString(apiVersion))
  add(path_568413, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568415 = parameters
  result = call_568412.call(path_568413, query_568414, nil, nil, body_568415)

var messagingPlanCreateOrUpdate* = Call_MessagingPlanCreateOrUpdate_568403(
    name: "messagingPlanCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/messagingplan",
    validator: validate_MessagingPlanCreateOrUpdate_568404, base: "",
    url: url_MessagingPlanCreateOrUpdate_568405, schemes: {Scheme.Https})
type
  Call_MessagingPlanGet_568392 = ref object of OpenApiRestCall_567657
proc url_MessagingPlanGet_568394(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/messagingplan")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MessagingPlanGet_568393(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a description for the specified namespace.
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
  var valid_568395 = path.getOrDefault("namespaceName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "namespaceName", valid_568395
  var valid_568396 = path.getOrDefault("resourceGroupName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "resourceGroupName", valid_568396
  var valid_568397 = path.getOrDefault("subscriptionId")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "subscriptionId", valid_568397
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568398 = query.getOrDefault("api-version")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "api-version", valid_568398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568399: Call_MessagingPlanGet_568392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a description for the specified namespace.
  ## 
  let valid = call_568399.validator(path, query, header, formData, body)
  let scheme = call_568399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568399.url(scheme.get, call_568399.host, call_568399.base,
                         call_568399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568399, url, valid)

proc call*(call_568400: Call_MessagingPlanGet_568392; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## messagingPlanGet
  ## Gets a description for the specified namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568401 = newJObject()
  var query_568402 = newJObject()
  add(path_568401, "namespaceName", newJString(namespaceName))
  add(path_568401, "resourceGroupName", newJString(resourceGroupName))
  add(query_568402, "api-version", newJString(apiVersion))
  add(path_568401, "subscriptionId", newJString(subscriptionId))
  result = call_568400.call(path_568401, query_568402, nil, nil, nil)

var messagingPlanGet* = Call_MessagingPlanGet_568392(name: "messagingPlanGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/messagingplan",
    validator: validate_MessagingPlanGet_568393, base: "",
    url: url_MessagingPlanGet_568394, schemes: {Scheme.Https})
type
  Call_QueuesListAll_568416 = ref object of OpenApiRestCall_567657
proc url_QueuesListAll_568418(protocol: Scheme; host: string; base: string;
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

proc validate_QueuesListAll_568417(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568419 = path.getOrDefault("namespaceName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "namespaceName", valid_568419
  var valid_568420 = path.getOrDefault("resourceGroupName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "resourceGroupName", valid_568420
  var valid_568421 = path.getOrDefault("subscriptionId")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "subscriptionId", valid_568421
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568422 = query.getOrDefault("api-version")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "api-version", valid_568422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568423: Call_QueuesListAll_568416; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the queues within a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639415.aspx
  let valid = call_568423.validator(path, query, header, formData, body)
  let scheme = call_568423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568423.url(scheme.get, call_568423.host, call_568423.base,
                         call_568423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568423, url, valid)

proc call*(call_568424: Call_QueuesListAll_568416; namespaceName: string;
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
  var path_568425 = newJObject()
  var query_568426 = newJObject()
  add(path_568425, "namespaceName", newJString(namespaceName))
  add(path_568425, "resourceGroupName", newJString(resourceGroupName))
  add(query_568426, "api-version", newJString(apiVersion))
  add(path_568425, "subscriptionId", newJString(subscriptionId))
  result = call_568424.call(path_568425, query_568426, nil, nil, nil)

var queuesListAll* = Call_QueuesListAll_568416(name: "queuesListAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues",
    validator: validate_QueuesListAll_568417, base: "", url: url_QueuesListAll_568418,
    schemes: {Scheme.Https})
type
  Call_QueuesCreateOrUpdate_568439 = ref object of OpenApiRestCall_567657
proc url_QueuesCreateOrUpdate_568441(protocol: Scheme; host: string; base: string;
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

proc validate_QueuesCreateOrUpdate_568440(path: JsonNode; query: JsonNode;
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
  var valid_568442 = path.getOrDefault("namespaceName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "namespaceName", valid_568442
  var valid_568443 = path.getOrDefault("resourceGroupName")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "resourceGroupName", valid_568443
  var valid_568444 = path.getOrDefault("subscriptionId")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "subscriptionId", valid_568444
  var valid_568445 = path.getOrDefault("queueName")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "queueName", valid_568445
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568446 = query.getOrDefault("api-version")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "api-version", valid_568446
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

proc call*(call_568448: Call_QueuesCreateOrUpdate_568439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Service Bus queue. This operation is idempotent.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639395.aspx
  let valid = call_568448.validator(path, query, header, formData, body)
  let scheme = call_568448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568448.url(scheme.get, call_568448.host, call_568448.base,
                         call_568448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568448, url, valid)

proc call*(call_568449: Call_QueuesCreateOrUpdate_568439; namespaceName: string;
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
  var path_568450 = newJObject()
  var query_568451 = newJObject()
  var body_568452 = newJObject()
  add(path_568450, "namespaceName", newJString(namespaceName))
  add(path_568450, "resourceGroupName", newJString(resourceGroupName))
  add(query_568451, "api-version", newJString(apiVersion))
  add(path_568450, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568452 = parameters
  add(path_568450, "queueName", newJString(queueName))
  result = call_568449.call(path_568450, query_568451, nil, nil, body_568452)

var queuesCreateOrUpdate* = Call_QueuesCreateOrUpdate_568439(
    name: "queuesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}",
    validator: validate_QueuesCreateOrUpdate_568440, base: "",
    url: url_QueuesCreateOrUpdate_568441, schemes: {Scheme.Https})
type
  Call_QueuesGet_568427 = ref object of OpenApiRestCall_567657
proc url_QueuesGet_568429(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_QueuesGet_568428(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568430 = path.getOrDefault("namespaceName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "namespaceName", valid_568430
  var valid_568431 = path.getOrDefault("resourceGroupName")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "resourceGroupName", valid_568431
  var valid_568432 = path.getOrDefault("subscriptionId")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "subscriptionId", valid_568432
  var valid_568433 = path.getOrDefault("queueName")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "queueName", valid_568433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568434 = query.getOrDefault("api-version")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "api-version", valid_568434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568435: Call_QueuesGet_568427; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a description for the specified queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639380.aspx
  let valid = call_568435.validator(path, query, header, formData, body)
  let scheme = call_568435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568435.url(scheme.get, call_568435.host, call_568435.base,
                         call_568435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568435, url, valid)

proc call*(call_568436: Call_QueuesGet_568427; namespaceName: string;
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
  var path_568437 = newJObject()
  var query_568438 = newJObject()
  add(path_568437, "namespaceName", newJString(namespaceName))
  add(path_568437, "resourceGroupName", newJString(resourceGroupName))
  add(query_568438, "api-version", newJString(apiVersion))
  add(path_568437, "subscriptionId", newJString(subscriptionId))
  add(path_568437, "queueName", newJString(queueName))
  result = call_568436.call(path_568437, query_568438, nil, nil, nil)

var queuesGet* = Call_QueuesGet_568427(name: "queuesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}",
                                    validator: validate_QueuesGet_568428,
                                    base: "", url: url_QueuesGet_568429,
                                    schemes: {Scheme.Https})
type
  Call_QueuesDelete_568453 = ref object of OpenApiRestCall_567657
proc url_QueuesDelete_568455(protocol: Scheme; host: string; base: string;
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

proc validate_QueuesDelete_568454(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568456 = path.getOrDefault("namespaceName")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "namespaceName", valid_568456
  var valid_568457 = path.getOrDefault("resourceGroupName")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "resourceGroupName", valid_568457
  var valid_568458 = path.getOrDefault("subscriptionId")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "subscriptionId", valid_568458
  var valid_568459 = path.getOrDefault("queueName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "queueName", valid_568459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568460 = query.getOrDefault("api-version")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "api-version", valid_568460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568461: Call_QueuesDelete_568453; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a queue from the specified namespace in a resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639411.aspx
  let valid = call_568461.validator(path, query, header, formData, body)
  let scheme = call_568461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568461.url(scheme.get, call_568461.host, call_568461.base,
                         call_568461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568461, url, valid)

proc call*(call_568462: Call_QueuesDelete_568453; namespaceName: string;
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
  var path_568463 = newJObject()
  var query_568464 = newJObject()
  add(path_568463, "namespaceName", newJString(namespaceName))
  add(path_568463, "resourceGroupName", newJString(resourceGroupName))
  add(query_568464, "api-version", newJString(apiVersion))
  add(path_568463, "subscriptionId", newJString(subscriptionId))
  add(path_568463, "queueName", newJString(queueName))
  result = call_568462.call(path_568463, query_568464, nil, nil, nil)

var queuesDelete* = Call_QueuesDelete_568453(name: "queuesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}",
    validator: validate_QueuesDelete_568454, base: "", url: url_QueuesDelete_568455,
    schemes: {Scheme.Https})
type
  Call_QueuesListAuthorizationRules_568465 = ref object of OpenApiRestCall_567657
proc url_QueuesListAuthorizationRules_568467(protocol: Scheme; host: string;
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

proc validate_QueuesListAuthorizationRules_568466(path: JsonNode; query: JsonNode;
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
  var valid_568468 = path.getOrDefault("namespaceName")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "namespaceName", valid_568468
  var valid_568469 = path.getOrDefault("resourceGroupName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "resourceGroupName", valid_568469
  var valid_568470 = path.getOrDefault("subscriptionId")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "subscriptionId", valid_568470
  var valid_568471 = path.getOrDefault("queueName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "queueName", valid_568471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568472 = query.getOrDefault("api-version")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "api-version", valid_568472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568473: Call_QueuesListAuthorizationRules_568465; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all authorization rules for a queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705607.aspx
  let valid = call_568473.validator(path, query, header, formData, body)
  let scheme = call_568473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568473.url(scheme.get, call_568473.host, call_568473.base,
                         call_568473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568473, url, valid)

proc call*(call_568474: Call_QueuesListAuthorizationRules_568465;
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
  var path_568475 = newJObject()
  var query_568476 = newJObject()
  add(path_568475, "namespaceName", newJString(namespaceName))
  add(path_568475, "resourceGroupName", newJString(resourceGroupName))
  add(query_568476, "api-version", newJString(apiVersion))
  add(path_568475, "subscriptionId", newJString(subscriptionId))
  add(path_568475, "queueName", newJString(queueName))
  result = call_568474.call(path_568475, query_568476, nil, nil, nil)

var queuesListAuthorizationRules* = Call_QueuesListAuthorizationRules_568465(
    name: "queuesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules",
    validator: validate_QueuesListAuthorizationRules_568466, base: "",
    url: url_QueuesListAuthorizationRules_568467, schemes: {Scheme.Https})
type
  Call_QueuesCreateOrUpdateAuthorizationRule_568490 = ref object of OpenApiRestCall_567657
proc url_QueuesCreateOrUpdateAuthorizationRule_568492(protocol: Scheme;
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

proc validate_QueuesCreateOrUpdateAuthorizationRule_568491(path: JsonNode;
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
  var valid_568493 = path.getOrDefault("namespaceName")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "namespaceName", valid_568493
  var valid_568494 = path.getOrDefault("resourceGroupName")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "resourceGroupName", valid_568494
  var valid_568495 = path.getOrDefault("authorizationRuleName")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "authorizationRuleName", valid_568495
  var valid_568496 = path.getOrDefault("subscriptionId")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "subscriptionId", valid_568496
  var valid_568497 = path.getOrDefault("queueName")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "queueName", valid_568497
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568498 = query.getOrDefault("api-version")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "api-version", valid_568498
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

proc call*(call_568500: Call_QueuesCreateOrUpdateAuthorizationRule_568490;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an authorization rule for a queue.
  ## 
  let valid = call_568500.validator(path, query, header, formData, body)
  let scheme = call_568500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568500.url(scheme.get, call_568500.host, call_568500.base,
                         call_568500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568500, url, valid)

proc call*(call_568501: Call_QueuesCreateOrUpdateAuthorizationRule_568490;
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
  var path_568502 = newJObject()
  var query_568503 = newJObject()
  var body_568504 = newJObject()
  add(path_568502, "namespaceName", newJString(namespaceName))
  add(path_568502, "resourceGroupName", newJString(resourceGroupName))
  add(query_568503, "api-version", newJString(apiVersion))
  add(path_568502, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568502, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568504 = parameters
  add(path_568502, "queueName", newJString(queueName))
  result = call_568501.call(path_568502, query_568503, nil, nil, body_568504)

var queuesCreateOrUpdateAuthorizationRule* = Call_QueuesCreateOrUpdateAuthorizationRule_568490(
    name: "queuesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}",
    validator: validate_QueuesCreateOrUpdateAuthorizationRule_568491, base: "",
    url: url_QueuesCreateOrUpdateAuthorizationRule_568492, schemes: {Scheme.Https})
type
  Call_QueuesPostAuthorizationRule_568505 = ref object of OpenApiRestCall_567657
proc url_QueuesPostAuthorizationRule_568507(protocol: Scheme; host: string;
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

proc validate_QueuesPostAuthorizationRule_568506(path: JsonNode; query: JsonNode;
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
  var valid_568508 = path.getOrDefault("namespaceName")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "namespaceName", valid_568508
  var valid_568509 = path.getOrDefault("resourceGroupName")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "resourceGroupName", valid_568509
  var valid_568510 = path.getOrDefault("authorizationRuleName")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "authorizationRuleName", valid_568510
  var valid_568511 = path.getOrDefault("subscriptionId")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "subscriptionId", valid_568511
  var valid_568512 = path.getOrDefault("queueName")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "queueName", valid_568512
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568513 = query.getOrDefault("api-version")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "api-version", valid_568513
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568514: Call_QueuesPostAuthorizationRule_568505; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an authorization rule for a queue by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705611.aspx
  let valid = call_568514.validator(path, query, header, formData, body)
  let scheme = call_568514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568514.url(scheme.get, call_568514.host, call_568514.base,
                         call_568514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568514, url, valid)

proc call*(call_568515: Call_QueuesPostAuthorizationRule_568505;
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
  var path_568516 = newJObject()
  var query_568517 = newJObject()
  add(path_568516, "namespaceName", newJString(namespaceName))
  add(path_568516, "resourceGroupName", newJString(resourceGroupName))
  add(query_568517, "api-version", newJString(apiVersion))
  add(path_568516, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568516, "subscriptionId", newJString(subscriptionId))
  add(path_568516, "queueName", newJString(queueName))
  result = call_568515.call(path_568516, query_568517, nil, nil, nil)

var queuesPostAuthorizationRule* = Call_QueuesPostAuthorizationRule_568505(
    name: "queuesPostAuthorizationRule", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}",
    validator: validate_QueuesPostAuthorizationRule_568506, base: "",
    url: url_QueuesPostAuthorizationRule_568507, schemes: {Scheme.Https})
type
  Call_QueuesGetAuthorizationRule_568477 = ref object of OpenApiRestCall_567657
proc url_QueuesGetAuthorizationRule_568479(protocol: Scheme; host: string;
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

proc validate_QueuesGetAuthorizationRule_568478(path: JsonNode; query: JsonNode;
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
  var valid_568480 = path.getOrDefault("namespaceName")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "namespaceName", valid_568480
  var valid_568481 = path.getOrDefault("resourceGroupName")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "resourceGroupName", valid_568481
  var valid_568482 = path.getOrDefault("authorizationRuleName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "authorizationRuleName", valid_568482
  var valid_568483 = path.getOrDefault("subscriptionId")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "subscriptionId", valid_568483
  var valid_568484 = path.getOrDefault("queueName")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "queueName", valid_568484
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568485 = query.getOrDefault("api-version")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "api-version", valid_568485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568486: Call_QueuesGetAuthorizationRule_568477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an authorization rule for a queue by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705611.aspx
  let valid = call_568486.validator(path, query, header, formData, body)
  let scheme = call_568486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568486.url(scheme.get, call_568486.host, call_568486.base,
                         call_568486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568486, url, valid)

proc call*(call_568487: Call_QueuesGetAuthorizationRule_568477;
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
  var path_568488 = newJObject()
  var query_568489 = newJObject()
  add(path_568488, "namespaceName", newJString(namespaceName))
  add(path_568488, "resourceGroupName", newJString(resourceGroupName))
  add(query_568489, "api-version", newJString(apiVersion))
  add(path_568488, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568488, "subscriptionId", newJString(subscriptionId))
  add(path_568488, "queueName", newJString(queueName))
  result = call_568487.call(path_568488, query_568489, nil, nil, nil)

var queuesGetAuthorizationRule* = Call_QueuesGetAuthorizationRule_568477(
    name: "queuesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}",
    validator: validate_QueuesGetAuthorizationRule_568478, base: "",
    url: url_QueuesGetAuthorizationRule_568479, schemes: {Scheme.Https})
type
  Call_QueuesDeleteAuthorizationRule_568518 = ref object of OpenApiRestCall_567657
proc url_QueuesDeleteAuthorizationRule_568520(protocol: Scheme; host: string;
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

proc validate_QueuesDeleteAuthorizationRule_568519(path: JsonNode; query: JsonNode;
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
  var valid_568521 = path.getOrDefault("namespaceName")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "namespaceName", valid_568521
  var valid_568522 = path.getOrDefault("resourceGroupName")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "resourceGroupName", valid_568522
  var valid_568523 = path.getOrDefault("authorizationRuleName")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "authorizationRuleName", valid_568523
  var valid_568524 = path.getOrDefault("subscriptionId")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "subscriptionId", valid_568524
  var valid_568525 = path.getOrDefault("queueName")
  valid_568525 = validateParameter(valid_568525, JString, required = true,
                                 default = nil)
  if valid_568525 != nil:
    section.add "queueName", valid_568525
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568526 = query.getOrDefault("api-version")
  valid_568526 = validateParameter(valid_568526, JString, required = true,
                                 default = nil)
  if valid_568526 != nil:
    section.add "api-version", valid_568526
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568527: Call_QueuesDeleteAuthorizationRule_568518; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a queue authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705609.aspx
  let valid = call_568527.validator(path, query, header, formData, body)
  let scheme = call_568527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568527.url(scheme.get, call_568527.host, call_568527.base,
                         call_568527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568527, url, valid)

proc call*(call_568528: Call_QueuesDeleteAuthorizationRule_568518;
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
  var path_568529 = newJObject()
  var query_568530 = newJObject()
  add(path_568529, "namespaceName", newJString(namespaceName))
  add(path_568529, "resourceGroupName", newJString(resourceGroupName))
  add(query_568530, "api-version", newJString(apiVersion))
  add(path_568529, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568529, "subscriptionId", newJString(subscriptionId))
  add(path_568529, "queueName", newJString(queueName))
  result = call_568528.call(path_568529, query_568530, nil, nil, nil)

var queuesDeleteAuthorizationRule* = Call_QueuesDeleteAuthorizationRule_568518(
    name: "queuesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}",
    validator: validate_QueuesDeleteAuthorizationRule_568519, base: "",
    url: url_QueuesDeleteAuthorizationRule_568520, schemes: {Scheme.Https})
type
  Call_TopicsListAll_568531 = ref object of OpenApiRestCall_567657
proc url_TopicsListAll_568533(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsListAll_568532(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568534 = path.getOrDefault("namespaceName")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "namespaceName", valid_568534
  var valid_568535 = path.getOrDefault("resourceGroupName")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "resourceGroupName", valid_568535
  var valid_568536 = path.getOrDefault("subscriptionId")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = nil)
  if valid_568536 != nil:
    section.add "subscriptionId", valid_568536
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568537 = query.getOrDefault("api-version")
  valid_568537 = validateParameter(valid_568537, JString, required = true,
                                 default = nil)
  if valid_568537 != nil:
    section.add "api-version", valid_568537
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568538: Call_TopicsListAll_568531; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the topics in a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639388.aspx
  let valid = call_568538.validator(path, query, header, formData, body)
  let scheme = call_568538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568538.url(scheme.get, call_568538.host, call_568538.base,
                         call_568538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568538, url, valid)

proc call*(call_568539: Call_TopicsListAll_568531; namespaceName: string;
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
  var path_568540 = newJObject()
  var query_568541 = newJObject()
  add(path_568540, "namespaceName", newJString(namespaceName))
  add(path_568540, "resourceGroupName", newJString(resourceGroupName))
  add(query_568541, "api-version", newJString(apiVersion))
  add(path_568540, "subscriptionId", newJString(subscriptionId))
  result = call_568539.call(path_568540, query_568541, nil, nil, nil)

var topicsListAll* = Call_TopicsListAll_568531(name: "topicsListAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics",
    validator: validate_TopicsListAll_568532, base: "", url: url_TopicsListAll_568533,
    schemes: {Scheme.Https})
type
  Call_TopicsCreateOrUpdate_568554 = ref object of OpenApiRestCall_567657
proc url_TopicsCreateOrUpdate_568556(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsCreateOrUpdate_568555(path: JsonNode; query: JsonNode;
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
  var valid_568557 = path.getOrDefault("namespaceName")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "namespaceName", valid_568557
  var valid_568558 = path.getOrDefault("resourceGroupName")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "resourceGroupName", valid_568558
  var valid_568559 = path.getOrDefault("topicName")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "topicName", valid_568559
  var valid_568560 = path.getOrDefault("subscriptionId")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "subscriptionId", valid_568560
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568561 = query.getOrDefault("api-version")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "api-version", valid_568561
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

proc call*(call_568563: Call_TopicsCreateOrUpdate_568554; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a topic in the specified namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639409.aspx
  let valid = call_568563.validator(path, query, header, formData, body)
  let scheme = call_568563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568563.url(scheme.get, call_568563.host, call_568563.base,
                         call_568563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568563, url, valid)

proc call*(call_568564: Call_TopicsCreateOrUpdate_568554; namespaceName: string;
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
  var path_568565 = newJObject()
  var query_568566 = newJObject()
  var body_568567 = newJObject()
  add(path_568565, "namespaceName", newJString(namespaceName))
  add(path_568565, "resourceGroupName", newJString(resourceGroupName))
  add(query_568566, "api-version", newJString(apiVersion))
  add(path_568565, "topicName", newJString(topicName))
  add(path_568565, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568567 = parameters
  result = call_568564.call(path_568565, query_568566, nil, nil, body_568567)

var topicsCreateOrUpdate* = Call_TopicsCreateOrUpdate_568554(
    name: "topicsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}",
    validator: validate_TopicsCreateOrUpdate_568555, base: "",
    url: url_TopicsCreateOrUpdate_568556, schemes: {Scheme.Https})
type
  Call_TopicsGet_568542 = ref object of OpenApiRestCall_567657
proc url_TopicsGet_568544(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TopicsGet_568543(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568545 = path.getOrDefault("namespaceName")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "namespaceName", valid_568545
  var valid_568546 = path.getOrDefault("resourceGroupName")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "resourceGroupName", valid_568546
  var valid_568547 = path.getOrDefault("topicName")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "topicName", valid_568547
  var valid_568548 = path.getOrDefault("subscriptionId")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "subscriptionId", valid_568548
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568549 = query.getOrDefault("api-version")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "api-version", valid_568549
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568550: Call_TopicsGet_568542; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a description for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639399.aspx
  let valid = call_568550.validator(path, query, header, formData, body)
  let scheme = call_568550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568550.url(scheme.get, call_568550.host, call_568550.base,
                         call_568550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568550, url, valid)

proc call*(call_568551: Call_TopicsGet_568542; namespaceName: string;
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
  var path_568552 = newJObject()
  var query_568553 = newJObject()
  add(path_568552, "namespaceName", newJString(namespaceName))
  add(path_568552, "resourceGroupName", newJString(resourceGroupName))
  add(query_568553, "api-version", newJString(apiVersion))
  add(path_568552, "topicName", newJString(topicName))
  add(path_568552, "subscriptionId", newJString(subscriptionId))
  result = call_568551.call(path_568552, query_568553, nil, nil, nil)

var topicsGet* = Call_TopicsGet_568542(name: "topicsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}",
                                    validator: validate_TopicsGet_568543,
                                    base: "", url: url_TopicsGet_568544,
                                    schemes: {Scheme.Https})
type
  Call_TopicsDelete_568568 = ref object of OpenApiRestCall_567657
proc url_TopicsDelete_568570(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsDelete_568569(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568571 = path.getOrDefault("namespaceName")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "namespaceName", valid_568571
  var valid_568572 = path.getOrDefault("resourceGroupName")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "resourceGroupName", valid_568572
  var valid_568573 = path.getOrDefault("topicName")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "topicName", valid_568573
  var valid_568574 = path.getOrDefault("subscriptionId")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "subscriptionId", valid_568574
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568575 = query.getOrDefault("api-version")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "api-version", valid_568575
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568576: Call_TopicsDelete_568568; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a topic from the specified namespace and resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639404.aspx
  let valid = call_568576.validator(path, query, header, formData, body)
  let scheme = call_568576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568576.url(scheme.get, call_568576.host, call_568576.base,
                         call_568576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568576, url, valid)

proc call*(call_568577: Call_TopicsDelete_568568; namespaceName: string;
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
  var path_568578 = newJObject()
  var query_568579 = newJObject()
  add(path_568578, "namespaceName", newJString(namespaceName))
  add(path_568578, "resourceGroupName", newJString(resourceGroupName))
  add(query_568579, "api-version", newJString(apiVersion))
  add(path_568578, "topicName", newJString(topicName))
  add(path_568578, "subscriptionId", newJString(subscriptionId))
  result = call_568577.call(path_568578, query_568579, nil, nil, nil)

var topicsDelete* = Call_TopicsDelete_568568(name: "topicsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}",
    validator: validate_TopicsDelete_568569, base: "", url: url_TopicsDelete_568570,
    schemes: {Scheme.Https})
type
  Call_TopicsListAuthorizationRules_568580 = ref object of OpenApiRestCall_567657
proc url_TopicsListAuthorizationRules_568582(protocol: Scheme; host: string;
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

proc validate_TopicsListAuthorizationRules_568581(path: JsonNode; query: JsonNode;
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
  var valid_568583 = path.getOrDefault("namespaceName")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = nil)
  if valid_568583 != nil:
    section.add "namespaceName", valid_568583
  var valid_568584 = path.getOrDefault("resourceGroupName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "resourceGroupName", valid_568584
  var valid_568585 = path.getOrDefault("topicName")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "topicName", valid_568585
  var valid_568586 = path.getOrDefault("subscriptionId")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "subscriptionId", valid_568586
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568587 = query.getOrDefault("api-version")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "api-version", valid_568587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568588: Call_TopicsListAuthorizationRules_568580; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets authorization rules for a topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720681.aspx
  let valid = call_568588.validator(path, query, header, formData, body)
  let scheme = call_568588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568588.url(scheme.get, call_568588.host, call_568588.base,
                         call_568588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568588, url, valid)

proc call*(call_568589: Call_TopicsListAuthorizationRules_568580;
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
  var path_568590 = newJObject()
  var query_568591 = newJObject()
  add(path_568590, "namespaceName", newJString(namespaceName))
  add(path_568590, "resourceGroupName", newJString(resourceGroupName))
  add(query_568591, "api-version", newJString(apiVersion))
  add(path_568590, "topicName", newJString(topicName))
  add(path_568590, "subscriptionId", newJString(subscriptionId))
  result = call_568589.call(path_568590, query_568591, nil, nil, nil)

var topicsListAuthorizationRules* = Call_TopicsListAuthorizationRules_568580(
    name: "topicsListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules",
    validator: validate_TopicsListAuthorizationRules_568581, base: "",
    url: url_TopicsListAuthorizationRules_568582, schemes: {Scheme.Https})
type
  Call_TopicsCreateOrUpdateAuthorizationRule_568605 = ref object of OpenApiRestCall_567657
proc url_TopicsCreateOrUpdateAuthorizationRule_568607(protocol: Scheme;
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

proc validate_TopicsCreateOrUpdateAuthorizationRule_568606(path: JsonNode;
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568615: Call_TopicsCreateOrUpdateAuthorizationRule_568605;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an authorization rule for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720678.aspx
  let valid = call_568615.validator(path, query, header, formData, body)
  let scheme = call_568615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568615.url(scheme.get, call_568615.host, call_568615.base,
                         call_568615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568615, url, valid)

proc call*(call_568616: Call_TopicsCreateOrUpdateAuthorizationRule_568605;
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
  var path_568617 = newJObject()
  var query_568618 = newJObject()
  var body_568619 = newJObject()
  add(path_568617, "namespaceName", newJString(namespaceName))
  add(path_568617, "resourceGroupName", newJString(resourceGroupName))
  add(query_568618, "api-version", newJString(apiVersion))
  add(path_568617, "topicName", newJString(topicName))
  add(path_568617, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568617, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568619 = parameters
  result = call_568616.call(path_568617, query_568618, nil, nil, body_568619)

var topicsCreateOrUpdateAuthorizationRule* = Call_TopicsCreateOrUpdateAuthorizationRule_568605(
    name: "topicsCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}",
    validator: validate_TopicsCreateOrUpdateAuthorizationRule_568606, base: "",
    url: url_TopicsCreateOrUpdateAuthorizationRule_568607, schemes: {Scheme.Https})
type
  Call_TopicsPostAuthorizationRule_568620 = ref object of OpenApiRestCall_567657
proc url_TopicsPostAuthorizationRule_568622(protocol: Scheme; host: string;
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

proc validate_TopicsPostAuthorizationRule_568621(path: JsonNode; query: JsonNode;
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
  var valid_568623 = path.getOrDefault("namespaceName")
  valid_568623 = validateParameter(valid_568623, JString, required = true,
                                 default = nil)
  if valid_568623 != nil:
    section.add "namespaceName", valid_568623
  var valid_568624 = path.getOrDefault("resourceGroupName")
  valid_568624 = validateParameter(valid_568624, JString, required = true,
                                 default = nil)
  if valid_568624 != nil:
    section.add "resourceGroupName", valid_568624
  var valid_568625 = path.getOrDefault("topicName")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "topicName", valid_568625
  var valid_568626 = path.getOrDefault("authorizationRuleName")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "authorizationRuleName", valid_568626
  var valid_568627 = path.getOrDefault("subscriptionId")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "subscriptionId", valid_568627
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568628 = query.getOrDefault("api-version")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "api-version", valid_568628
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568629: Call_TopicsPostAuthorizationRule_568620; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720676.aspx
  let valid = call_568629.validator(path, query, header, formData, body)
  let scheme = call_568629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568629.url(scheme.get, call_568629.host, call_568629.base,
                         call_568629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568629, url, valid)

proc call*(call_568630: Call_TopicsPostAuthorizationRule_568620;
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
  var path_568631 = newJObject()
  var query_568632 = newJObject()
  add(path_568631, "namespaceName", newJString(namespaceName))
  add(path_568631, "resourceGroupName", newJString(resourceGroupName))
  add(query_568632, "api-version", newJString(apiVersion))
  add(path_568631, "topicName", newJString(topicName))
  add(path_568631, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568631, "subscriptionId", newJString(subscriptionId))
  result = call_568630.call(path_568631, query_568632, nil, nil, nil)

var topicsPostAuthorizationRule* = Call_TopicsPostAuthorizationRule_568620(
    name: "topicsPostAuthorizationRule", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}",
    validator: validate_TopicsPostAuthorizationRule_568621, base: "",
    url: url_TopicsPostAuthorizationRule_568622, schemes: {Scheme.Https})
type
  Call_TopicsGetAuthorizationRule_568592 = ref object of OpenApiRestCall_567657
proc url_TopicsGetAuthorizationRule_568594(protocol: Scheme; host: string;
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

proc validate_TopicsGetAuthorizationRule_568593(path: JsonNode; query: JsonNode;
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

proc call*(call_568601: Call_TopicsGetAuthorizationRule_568592; path: JsonNode;
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

proc call*(call_568602: Call_TopicsGetAuthorizationRule_568592;
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
  var path_568603 = newJObject()
  var query_568604 = newJObject()
  add(path_568603, "namespaceName", newJString(namespaceName))
  add(path_568603, "resourceGroupName", newJString(resourceGroupName))
  add(query_568604, "api-version", newJString(apiVersion))
  add(path_568603, "topicName", newJString(topicName))
  add(path_568603, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568603, "subscriptionId", newJString(subscriptionId))
  result = call_568602.call(path_568603, query_568604, nil, nil, nil)

var topicsGetAuthorizationRule* = Call_TopicsGetAuthorizationRule_568592(
    name: "topicsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}",
    validator: validate_TopicsGetAuthorizationRule_568593, base: "",
    url: url_TopicsGetAuthorizationRule_568594, schemes: {Scheme.Https})
type
  Call_TopicsDeleteAuthorizationRule_568633 = ref object of OpenApiRestCall_567657
proc url_TopicsDeleteAuthorizationRule_568635(protocol: Scheme; host: string;
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

proc validate_TopicsDeleteAuthorizationRule_568634(path: JsonNode; query: JsonNode;
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
  var valid_568636 = path.getOrDefault("namespaceName")
  valid_568636 = validateParameter(valid_568636, JString, required = true,
                                 default = nil)
  if valid_568636 != nil:
    section.add "namespaceName", valid_568636
  var valid_568637 = path.getOrDefault("resourceGroupName")
  valid_568637 = validateParameter(valid_568637, JString, required = true,
                                 default = nil)
  if valid_568637 != nil:
    section.add "resourceGroupName", valid_568637
  var valid_568638 = path.getOrDefault("topicName")
  valid_568638 = validateParameter(valid_568638, JString, required = true,
                                 default = nil)
  if valid_568638 != nil:
    section.add "topicName", valid_568638
  var valid_568639 = path.getOrDefault("authorizationRuleName")
  valid_568639 = validateParameter(valid_568639, JString, required = true,
                                 default = nil)
  if valid_568639 != nil:
    section.add "authorizationRuleName", valid_568639
  var valid_568640 = path.getOrDefault("subscriptionId")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "subscriptionId", valid_568640
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568641 = query.getOrDefault("api-version")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "api-version", valid_568641
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568642: Call_TopicsDeleteAuthorizationRule_568633; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a topic authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720681.aspx
  let valid = call_568642.validator(path, query, header, formData, body)
  let scheme = call_568642.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568642.url(scheme.get, call_568642.host, call_568642.base,
                         call_568642.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568642, url, valid)

proc call*(call_568643: Call_TopicsDeleteAuthorizationRule_568633;
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
  var path_568644 = newJObject()
  var query_568645 = newJObject()
  add(path_568644, "namespaceName", newJString(namespaceName))
  add(path_568644, "resourceGroupName", newJString(resourceGroupName))
  add(query_568645, "api-version", newJString(apiVersion))
  add(path_568644, "topicName", newJString(topicName))
  add(path_568644, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568644, "subscriptionId", newJString(subscriptionId))
  result = call_568643.call(path_568644, query_568645, nil, nil, nil)

var topicsDeleteAuthorizationRule* = Call_TopicsDeleteAuthorizationRule_568633(
    name: "topicsDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}",
    validator: validate_TopicsDeleteAuthorizationRule_568634, base: "",
    url: url_TopicsDeleteAuthorizationRule_568635, schemes: {Scheme.Https})
type
  Call_SubscriptionsListAll_568646 = ref object of OpenApiRestCall_567657
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
  Call_SubscriptionsCreateOrUpdate_568671 = ref object of OpenApiRestCall_567657
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
  Call_SubscriptionsGet_568658 = ref object of OpenApiRestCall_567657
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
  Call_SubscriptionsDelete_568686 = ref object of OpenApiRestCall_567657
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
