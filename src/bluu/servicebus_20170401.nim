
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ServiceBusManagementClient
## version: 2017-04-01
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

  OpenApiRestCall_567666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567666): Option[Scheme] {.used.} =
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
  Call_OperationsList_567888 = ref object of OpenApiRestCall_567666
proc url_OperationsList_567890(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567889(path: JsonNode; query: JsonNode;
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
  var valid_568049 = query.getOrDefault("api-version")
  valid_568049 = validateParameter(valid_568049, JString, required = true,
                                 default = nil)
  if valid_568049 != nil:
    section.add "api-version", valid_568049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568072: Call_OperationsList_567888; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available ServiceBus REST API operations.
  ## 
  let valid = call_568072.validator(path, query, header, formData, body)
  let scheme = call_568072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568072.url(scheme.get, call_568072.host, call_568072.base,
                         call_568072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568072, url, valid)

proc call*(call_568143: Call_OperationsList_567888; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available ServiceBus REST API operations.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_568144 = newJObject()
  add(query_568144, "api-version", newJString(apiVersion))
  result = call_568143.call(nil, query_568144, nil, nil, nil)

var operationsList* = Call_OperationsList_567888(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceBus/operations",
    validator: validate_OperationsList_567889, base: "", url: url_OperationsList_567890,
    schemes: {Scheme.Https})
type
  Call_NamespacesCheckNameAvailability_568184 = ref object of OpenApiRestCall_567666
proc url_NamespacesCheckNameAvailability_568186(protocol: Scheme; host: string;
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

proc validate_NamespacesCheckNameAvailability_568185(path: JsonNode;
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
  var valid_568218 = path.getOrDefault("subscriptionId")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "subscriptionId", valid_568218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568219 = query.getOrDefault("api-version")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "api-version", valid_568219
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

proc call*(call_568221: Call_NamespacesCheckNameAvailability_568184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give namespace name availability.
  ## 
  let valid = call_568221.validator(path, query, header, formData, body)
  let scheme = call_568221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568221.url(scheme.get, call_568221.host, call_568221.base,
                         call_568221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568221, url, valid)

proc call*(call_568222: Call_NamespacesCheckNameAvailability_568184;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCheckNameAvailability
  ## Check the give namespace name availability.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given namespace name
  var path_568223 = newJObject()
  var query_568224 = newJObject()
  var body_568225 = newJObject()
  add(query_568224, "api-version", newJString(apiVersion))
  add(path_568223, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568225 = parameters
  result = call_568222.call(path_568223, query_568224, nil, nil, body_568225)

var namespacesCheckNameAvailability* = Call_NamespacesCheckNameAvailability_568184(
    name: "namespacesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceBus/CheckNameAvailability",
    validator: validate_NamespacesCheckNameAvailability_568185, base: "",
    url: url_NamespacesCheckNameAvailability_568186, schemes: {Scheme.Https})
type
  Call_NamespacesList_568226 = ref object of OpenApiRestCall_567666
proc url_NamespacesList_568228(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_NamespacesList_568227(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
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
  var valid_568229 = path.getOrDefault("subscriptionId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "subscriptionId", valid_568229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568230 = query.getOrDefault("api-version")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "api-version", valid_568230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568231: Call_NamespacesList_568226; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the available namespaces within the subscription, irrespective of the resource groups.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  let valid = call_568231.validator(path, query, header, formData, body)
  let scheme = call_568231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568231.url(scheme.get, call_568231.host, call_568231.base,
                         call_568231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568231, url, valid)

proc call*(call_568232: Call_NamespacesList_568226; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesList
  ## Gets all the available namespaces within the subscription, irrespective of the resource groups.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568233 = newJObject()
  var query_568234 = newJObject()
  add(query_568234, "api-version", newJString(apiVersion))
  add(path_568233, "subscriptionId", newJString(subscriptionId))
  result = call_568232.call(path_568233, query_568234, nil, nil, nil)

var namespacesList* = Call_NamespacesList_568226(name: "namespacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceBus/namespaces",
    validator: validate_NamespacesList_568227, base: "", url: url_NamespacesList_568228,
    schemes: {Scheme.Https})
type
  Call_PremiumMessagingRegionsList_568235 = ref object of OpenApiRestCall_567666
proc url_PremiumMessagingRegionsList_568237(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ServiceBus/premiumMessagingRegions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PremiumMessagingRegionsList_568236(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the available premium messaging regions for servicebus 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568238 = path.getOrDefault("subscriptionId")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "subscriptionId", valid_568238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568239 = query.getOrDefault("api-version")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "api-version", valid_568239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568240: Call_PremiumMessagingRegionsList_568235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the available premium messaging regions for servicebus 
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_PremiumMessagingRegionsList_568235;
          apiVersion: string; subscriptionId: string): Recallable =
  ## premiumMessagingRegionsList
  ## Gets the available premium messaging regions for servicebus 
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568242 = newJObject()
  var query_568243 = newJObject()
  add(query_568243, "api-version", newJString(apiVersion))
  add(path_568242, "subscriptionId", newJString(subscriptionId))
  result = call_568241.call(path_568242, query_568243, nil, nil, nil)

var premiumMessagingRegionsList* = Call_PremiumMessagingRegionsList_568235(
    name: "premiumMessagingRegionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceBus/premiumMessagingRegions",
    validator: validate_PremiumMessagingRegionsList_568236, base: "",
    url: url_PremiumMessagingRegionsList_568237, schemes: {Scheme.Https})
type
  Call_RegionsListBySku_568244 = ref object of OpenApiRestCall_567666
proc url_RegionsListBySku_568246(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "sku" in path, "`sku` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ServiceBus/sku/"),
               (kind: VariableSegment, value: "sku"),
               (kind: ConstantSegment, value: "/regions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegionsListBySku_568245(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the available Regions for a given sku
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sku: JString (required)
  ##      : The sku type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568247 = path.getOrDefault("subscriptionId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "subscriptionId", valid_568247
  var valid_568248 = path.getOrDefault("sku")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "sku", valid_568248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568249 = query.getOrDefault("api-version")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "api-version", valid_568249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568250: Call_RegionsListBySku_568244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the available Regions for a given sku
  ## 
  let valid = call_568250.validator(path, query, header, formData, body)
  let scheme = call_568250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568250.url(scheme.get, call_568250.host, call_568250.base,
                         call_568250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568250, url, valid)

proc call*(call_568251: Call_RegionsListBySku_568244; apiVersion: string;
          subscriptionId: string; sku: string): Recallable =
  ## regionsListBySku
  ## Gets the available Regions for a given sku
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sku: string (required)
  ##      : The sku type.
  var path_568252 = newJObject()
  var query_568253 = newJObject()
  add(query_568253, "api-version", newJString(apiVersion))
  add(path_568252, "subscriptionId", newJString(subscriptionId))
  add(path_568252, "sku", newJString(sku))
  result = call_568251.call(path_568252, query_568253, nil, nil, nil)

var regionsListBySku* = Call_RegionsListBySku_568244(name: "regionsListBySku",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceBus/sku/{sku}/regions",
    validator: validate_RegionsListBySku_568245, base: "",
    url: url_RegionsListBySku_568246, schemes: {Scheme.Https})
type
  Call_NamespacesListByResourceGroup_568254 = ref object of OpenApiRestCall_567666
proc url_NamespacesListByResourceGroup_568256(protocol: Scheme; host: string;
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

proc validate_NamespacesListByResourceGroup_568255(path: JsonNode; query: JsonNode;
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
  var valid_568257 = path.getOrDefault("resourceGroupName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "resourceGroupName", valid_568257
  var valid_568258 = path.getOrDefault("subscriptionId")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "subscriptionId", valid_568258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568259 = query.getOrDefault("api-version")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "api-version", valid_568259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568260: Call_NamespacesListByResourceGroup_568254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the available namespaces within a resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  let valid = call_568260.validator(path, query, header, formData, body)
  let scheme = call_568260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568260.url(scheme.get, call_568260.host, call_568260.base,
                         call_568260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568260, url, valid)

proc call*(call_568261: Call_NamespacesListByResourceGroup_568254;
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
  var path_568262 = newJObject()
  var query_568263 = newJObject()
  add(path_568262, "resourceGroupName", newJString(resourceGroupName))
  add(query_568263, "api-version", newJString(apiVersion))
  add(path_568262, "subscriptionId", newJString(subscriptionId))
  result = call_568261.call(path_568262, query_568263, nil, nil, nil)

var namespacesListByResourceGroup* = Call_NamespacesListByResourceGroup_568254(
    name: "namespacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces",
    validator: validate_NamespacesListByResourceGroup_568255, base: "",
    url: url_NamespacesListByResourceGroup_568256, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdate_568275 = ref object of OpenApiRestCall_567666
proc url_NamespacesCreateOrUpdate_568277(protocol: Scheme; host: string;
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

proc validate_NamespacesCreateOrUpdate_568276(path: JsonNode; query: JsonNode;
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
  var valid_568278 = path.getOrDefault("namespaceName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "namespaceName", valid_568278
  var valid_568279 = path.getOrDefault("resourceGroupName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "resourceGroupName", valid_568279
  var valid_568280 = path.getOrDefault("subscriptionId")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "subscriptionId", valid_568280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568281 = query.getOrDefault("api-version")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "api-version", valid_568281
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

proc call*(call_568283: Call_NamespacesCreateOrUpdate_568275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639408.aspx
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_NamespacesCreateOrUpdate_568275;
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
  var path_568285 = newJObject()
  var query_568286 = newJObject()
  var body_568287 = newJObject()
  add(path_568285, "namespaceName", newJString(namespaceName))
  add(path_568285, "resourceGroupName", newJString(resourceGroupName))
  add(query_568286, "api-version", newJString(apiVersion))
  add(path_568285, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568287 = parameters
  result = call_568284.call(path_568285, query_568286, nil, nil, body_568287)

var namespacesCreateOrUpdate* = Call_NamespacesCreateOrUpdate_568275(
    name: "namespacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}",
    validator: validate_NamespacesCreateOrUpdate_568276, base: "",
    url: url_NamespacesCreateOrUpdate_568277, schemes: {Scheme.Https})
type
  Call_NamespacesGet_568264 = ref object of OpenApiRestCall_567666
proc url_NamespacesGet_568266(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesGet_568265(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568267 = path.getOrDefault("namespaceName")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "namespaceName", valid_568267
  var valid_568268 = path.getOrDefault("resourceGroupName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "resourceGroupName", valid_568268
  var valid_568269 = path.getOrDefault("subscriptionId")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "subscriptionId", valid_568269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568270 = query.getOrDefault("api-version")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "api-version", valid_568270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568271: Call_NamespacesGet_568264; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a description for the specified namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639379.aspx
  let valid = call_568271.validator(path, query, header, formData, body)
  let scheme = call_568271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568271.url(scheme.get, call_568271.host, call_568271.base,
                         call_568271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568271, url, valid)

proc call*(call_568272: Call_NamespacesGet_568264; namespaceName: string;
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
  var path_568273 = newJObject()
  var query_568274 = newJObject()
  add(path_568273, "namespaceName", newJString(namespaceName))
  add(path_568273, "resourceGroupName", newJString(resourceGroupName))
  add(query_568274, "api-version", newJString(apiVersion))
  add(path_568273, "subscriptionId", newJString(subscriptionId))
  result = call_568272.call(path_568273, query_568274, nil, nil, nil)

var namespacesGet* = Call_NamespacesGet_568264(name: "namespacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}",
    validator: validate_NamespacesGet_568265, base: "", url: url_NamespacesGet_568266,
    schemes: {Scheme.Https})
type
  Call_NamespacesUpdate_568299 = ref object of OpenApiRestCall_567666
proc url_NamespacesUpdate_568301(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesUpdate_568300(path: JsonNode; query: JsonNode;
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
  var valid_568302 = path.getOrDefault("namespaceName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "namespaceName", valid_568302
  var valid_568303 = path.getOrDefault("resourceGroupName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "resourceGroupName", valid_568303
  var valid_568304 = path.getOrDefault("subscriptionId")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "subscriptionId", valid_568304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568305 = query.getOrDefault("api-version")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "api-version", valid_568305
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

proc call*(call_568307: Call_NamespacesUpdate_568299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  let valid = call_568307.validator(path, query, header, formData, body)
  let scheme = call_568307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568307.url(scheme.get, call_568307.host, call_568307.base,
                         call_568307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568307, url, valid)

proc call*(call_568308: Call_NamespacesUpdate_568299; namespaceName: string;
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
  var path_568309 = newJObject()
  var query_568310 = newJObject()
  var body_568311 = newJObject()
  add(path_568309, "namespaceName", newJString(namespaceName))
  add(path_568309, "resourceGroupName", newJString(resourceGroupName))
  add(query_568310, "api-version", newJString(apiVersion))
  add(path_568309, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568311 = parameters
  result = call_568308.call(path_568309, query_568310, nil, nil, body_568311)

var namespacesUpdate* = Call_NamespacesUpdate_568299(name: "namespacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}",
    validator: validate_NamespacesUpdate_568300, base: "",
    url: url_NamespacesUpdate_568301, schemes: {Scheme.Https})
type
  Call_NamespacesDelete_568288 = ref object of OpenApiRestCall_567666
proc url_NamespacesDelete_568290(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesDelete_568289(path: JsonNode; query: JsonNode;
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
  var valid_568291 = path.getOrDefault("namespaceName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "namespaceName", valid_568291
  var valid_568292 = path.getOrDefault("resourceGroupName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "resourceGroupName", valid_568292
  var valid_568293 = path.getOrDefault("subscriptionId")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "subscriptionId", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568295: Call_NamespacesDelete_568288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639389.aspx
  let valid = call_568295.validator(path, query, header, formData, body)
  let scheme = call_568295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568295.url(scheme.get, call_568295.host, call_568295.base,
                         call_568295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568295, url, valid)

proc call*(call_568296: Call_NamespacesDelete_568288; namespaceName: string;
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
  var path_568297 = newJObject()
  var query_568298 = newJObject()
  add(path_568297, "namespaceName", newJString(namespaceName))
  add(path_568297, "resourceGroupName", newJString(resourceGroupName))
  add(query_568298, "api-version", newJString(apiVersion))
  add(path_568297, "subscriptionId", newJString(subscriptionId))
  result = call_568296.call(path_568297, query_568298, nil, nil, nil)

var namespacesDelete* = Call_NamespacesDelete_568288(name: "namespacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}",
    validator: validate_NamespacesDelete_568289, base: "",
    url: url_NamespacesDelete_568290, schemes: {Scheme.Https})
type
  Call_NamespacesListAuthorizationRules_568312 = ref object of OpenApiRestCall_567666
proc url_NamespacesListAuthorizationRules_568314(protocol: Scheme; host: string;
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

proc validate_NamespacesListAuthorizationRules_568313(path: JsonNode;
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
  var valid_568315 = path.getOrDefault("namespaceName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "namespaceName", valid_568315
  var valid_568316 = path.getOrDefault("resourceGroupName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "resourceGroupName", valid_568316
  var valid_568317 = path.getOrDefault("subscriptionId")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "subscriptionId", valid_568317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568318 = query.getOrDefault("api-version")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "api-version", valid_568318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568319: Call_NamespacesListAuthorizationRules_568312;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639376.aspx
  let valid = call_568319.validator(path, query, header, formData, body)
  let scheme = call_568319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568319.url(scheme.get, call_568319.host, call_568319.base,
                         call_568319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568319, url, valid)

proc call*(call_568320: Call_NamespacesListAuthorizationRules_568312;
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
  var path_568321 = newJObject()
  var query_568322 = newJObject()
  add(path_568321, "namespaceName", newJString(namespaceName))
  add(path_568321, "resourceGroupName", newJString(resourceGroupName))
  add(query_568322, "api-version", newJString(apiVersion))
  add(path_568321, "subscriptionId", newJString(subscriptionId))
  result = call_568320.call(path_568321, query_568322, nil, nil, nil)

var namespacesListAuthorizationRules* = Call_NamespacesListAuthorizationRules_568312(
    name: "namespacesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListAuthorizationRules_568313, base: "",
    url: url_NamespacesListAuthorizationRules_568314, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateAuthorizationRule_568335 = ref object of OpenApiRestCall_567666
proc url_NamespacesCreateOrUpdateAuthorizationRule_568337(protocol: Scheme;
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

proc validate_NamespacesCreateOrUpdateAuthorizationRule_568336(path: JsonNode;
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
  var valid_568338 = path.getOrDefault("namespaceName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "namespaceName", valid_568338
  var valid_568339 = path.getOrDefault("resourceGroupName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "resourceGroupName", valid_568339
  var valid_568340 = path.getOrDefault("authorizationRuleName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "authorizationRuleName", valid_568340
  var valid_568341 = path.getOrDefault("subscriptionId")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "subscriptionId", valid_568341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568342 = query.getOrDefault("api-version")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "api-version", valid_568342
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

proc call*(call_568344: Call_NamespacesCreateOrUpdateAuthorizationRule_568335;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an authorization rule for a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639410.aspx
  let valid = call_568344.validator(path, query, header, formData, body)
  let scheme = call_568344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568344.url(scheme.get, call_568344.host, call_568344.base,
                         call_568344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568344, url, valid)

proc call*(call_568345: Call_NamespacesCreateOrUpdateAuthorizationRule_568335;
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
  var path_568346 = newJObject()
  var query_568347 = newJObject()
  var body_568348 = newJObject()
  add(path_568346, "namespaceName", newJString(namespaceName))
  add(path_568346, "resourceGroupName", newJString(resourceGroupName))
  add(query_568347, "api-version", newJString(apiVersion))
  add(path_568346, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568346, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568348 = parameters
  result = call_568345.call(path_568346, query_568347, nil, nil, body_568348)

var namespacesCreateOrUpdateAuthorizationRule* = Call_NamespacesCreateOrUpdateAuthorizationRule_568335(
    name: "namespacesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesCreateOrUpdateAuthorizationRule_568336,
    base: "", url: url_NamespacesCreateOrUpdateAuthorizationRule_568337,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetAuthorizationRule_568323 = ref object of OpenApiRestCall_567666
proc url_NamespacesGetAuthorizationRule_568325(protocol: Scheme; host: string;
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

proc validate_NamespacesGetAuthorizationRule_568324(path: JsonNode;
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
  var valid_568326 = path.getOrDefault("namespaceName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "namespaceName", valid_568326
  var valid_568327 = path.getOrDefault("resourceGroupName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "resourceGroupName", valid_568327
  var valid_568328 = path.getOrDefault("authorizationRuleName")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "authorizationRuleName", valid_568328
  var valid_568329 = path.getOrDefault("subscriptionId")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "subscriptionId", valid_568329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568330 = query.getOrDefault("api-version")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "api-version", valid_568330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568331: Call_NamespacesGetAuthorizationRule_568323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an authorization rule for a namespace by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639392.aspx
  let valid = call_568331.validator(path, query, header, formData, body)
  let scheme = call_568331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568331.url(scheme.get, call_568331.host, call_568331.base,
                         call_568331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568331, url, valid)

proc call*(call_568332: Call_NamespacesGetAuthorizationRule_568323;
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
  var path_568333 = newJObject()
  var query_568334 = newJObject()
  add(path_568333, "namespaceName", newJString(namespaceName))
  add(path_568333, "resourceGroupName", newJString(resourceGroupName))
  add(query_568334, "api-version", newJString(apiVersion))
  add(path_568333, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568333, "subscriptionId", newJString(subscriptionId))
  result = call_568332.call(path_568333, query_568334, nil, nil, nil)

var namespacesGetAuthorizationRule* = Call_NamespacesGetAuthorizationRule_568323(
    name: "namespacesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesGetAuthorizationRule_568324, base: "",
    url: url_NamespacesGetAuthorizationRule_568325, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteAuthorizationRule_568349 = ref object of OpenApiRestCall_567666
proc url_NamespacesDeleteAuthorizationRule_568351(protocol: Scheme; host: string;
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

proc validate_NamespacesDeleteAuthorizationRule_568350(path: JsonNode;
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
  var valid_568352 = path.getOrDefault("namespaceName")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "namespaceName", valid_568352
  var valid_568353 = path.getOrDefault("resourceGroupName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "resourceGroupName", valid_568353
  var valid_568354 = path.getOrDefault("authorizationRuleName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "authorizationRuleName", valid_568354
  var valid_568355 = path.getOrDefault("subscriptionId")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "subscriptionId", valid_568355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568356 = query.getOrDefault("api-version")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "api-version", valid_568356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568357: Call_NamespacesDeleteAuthorizationRule_568349;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a namespace authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639417.aspx
  let valid = call_568357.validator(path, query, header, formData, body)
  let scheme = call_568357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568357.url(scheme.get, call_568357.host, call_568357.base,
                         call_568357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568357, url, valid)

proc call*(call_568358: Call_NamespacesDeleteAuthorizationRule_568349;
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
  var path_568359 = newJObject()
  var query_568360 = newJObject()
  add(path_568359, "namespaceName", newJString(namespaceName))
  add(path_568359, "resourceGroupName", newJString(resourceGroupName))
  add(query_568360, "api-version", newJString(apiVersion))
  add(path_568359, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568359, "subscriptionId", newJString(subscriptionId))
  result = call_568358.call(path_568359, query_568360, nil, nil, nil)

var namespacesDeleteAuthorizationRule* = Call_NamespacesDeleteAuthorizationRule_568349(
    name: "namespacesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesDeleteAuthorizationRule_568350, base: "",
    url: url_NamespacesDeleteAuthorizationRule_568351, schemes: {Scheme.Https})
type
  Call_NamespacesListKeys_568361 = ref object of OpenApiRestCall_567666
proc url_NamespacesListKeys_568363(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesListKeys_568362(path: JsonNode; query: JsonNode;
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
  var valid_568364 = path.getOrDefault("namespaceName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "namespaceName", valid_568364
  var valid_568365 = path.getOrDefault("resourceGroupName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "resourceGroupName", valid_568365
  var valid_568366 = path.getOrDefault("authorizationRuleName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "authorizationRuleName", valid_568366
  var valid_568367 = path.getOrDefault("subscriptionId")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "subscriptionId", valid_568367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568368 = query.getOrDefault("api-version")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "api-version", valid_568368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568369: Call_NamespacesListKeys_568361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the primary and secondary connection strings for the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639398.aspx
  let valid = call_568369.validator(path, query, header, formData, body)
  let scheme = call_568369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568369.url(scheme.get, call_568369.host, call_568369.base,
                         call_568369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568369, url, valid)

proc call*(call_568370: Call_NamespacesListKeys_568361; namespaceName: string;
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
  var path_568371 = newJObject()
  var query_568372 = newJObject()
  add(path_568371, "namespaceName", newJString(namespaceName))
  add(path_568371, "resourceGroupName", newJString(resourceGroupName))
  add(query_568372, "api-version", newJString(apiVersion))
  add(path_568371, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568371, "subscriptionId", newJString(subscriptionId))
  result = call_568370.call(path_568371, query_568372, nil, nil, nil)

var namespacesListKeys* = Call_NamespacesListKeys_568361(
    name: "namespacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_NamespacesListKeys_568362, base: "",
    url: url_NamespacesListKeys_568363, schemes: {Scheme.Https})
type
  Call_NamespacesRegenerateKeys_568373 = ref object of OpenApiRestCall_567666
proc url_NamespacesRegenerateKeys_568375(protocol: Scheme; host: string;
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

proc validate_NamespacesRegenerateKeys_568374(path: JsonNode; query: JsonNode;
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
  var valid_568376 = path.getOrDefault("namespaceName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "namespaceName", valid_568376
  var valid_568377 = path.getOrDefault("resourceGroupName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "resourceGroupName", valid_568377
  var valid_568378 = path.getOrDefault("authorizationRuleName")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "authorizationRuleName", valid_568378
  var valid_568379 = path.getOrDefault("subscriptionId")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "subscriptionId", valid_568379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568380 = query.getOrDefault("api-version")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "api-version", valid_568380
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

proc call*(call_568382: Call_NamespacesRegenerateKeys_568373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the primary or secondary connection strings for the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt718977.aspx
  let valid = call_568382.validator(path, query, header, formData, body)
  let scheme = call_568382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568382.url(scheme.get, call_568382.host, call_568382.base,
                         call_568382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568382, url, valid)

proc call*(call_568383: Call_NamespacesRegenerateKeys_568373;
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
  var path_568384 = newJObject()
  var query_568385 = newJObject()
  var body_568386 = newJObject()
  add(path_568384, "namespaceName", newJString(namespaceName))
  add(path_568384, "resourceGroupName", newJString(resourceGroupName))
  add(query_568385, "api-version", newJString(apiVersion))
  add(path_568384, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568384, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568386 = parameters
  result = call_568383.call(path_568384, query_568385, nil, nil, body_568386)

var namespacesRegenerateKeys* = Call_NamespacesRegenerateKeys_568373(
    name: "namespacesRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_NamespacesRegenerateKeys_568374, base: "",
    url: url_NamespacesRegenerateKeys_568375, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsList_568387 = ref object of OpenApiRestCall_567666
proc url_DisasterRecoveryConfigsList_568389(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsList_568388(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all Alias(Disaster Recovery configurations)
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
  var valid_568390 = path.getOrDefault("namespaceName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "namespaceName", valid_568390
  var valid_568391 = path.getOrDefault("resourceGroupName")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "resourceGroupName", valid_568391
  var valid_568392 = path.getOrDefault("subscriptionId")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "subscriptionId", valid_568392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568393 = query.getOrDefault("api-version")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "api-version", valid_568393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568394: Call_DisasterRecoveryConfigsList_568387; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Alias(Disaster Recovery configurations)
  ## 
  let valid = call_568394.validator(path, query, header, formData, body)
  let scheme = call_568394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568394.url(scheme.get, call_568394.host, call_568394.base,
                         call_568394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568394, url, valid)

proc call*(call_568395: Call_DisasterRecoveryConfigsList_568387;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## disasterRecoveryConfigsList
  ## Gets all Alias(Disaster Recovery configurations)
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568396 = newJObject()
  var query_568397 = newJObject()
  add(path_568396, "namespaceName", newJString(namespaceName))
  add(path_568396, "resourceGroupName", newJString(resourceGroupName))
  add(query_568397, "api-version", newJString(apiVersion))
  add(path_568396, "subscriptionId", newJString(subscriptionId))
  result = call_568395.call(path_568396, query_568397, nil, nil, nil)

var disasterRecoveryConfigsList* = Call_DisasterRecoveryConfigsList_568387(
    name: "disasterRecoveryConfigsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs",
    validator: validate_DisasterRecoveryConfigsList_568388, base: "",
    url: url_DisasterRecoveryConfigsList_568389, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsCheckNameAvailability_568398 = ref object of OpenApiRestCall_567666
proc url_DisasterRecoveryConfigsCheckNameAvailability_568400(protocol: Scheme;
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
               (kind: VariableSegment, value: "namespaceName"), (
        kind: ConstantSegment,
        value: "/disasterRecoveryConfigs/CheckNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsCheckNameAvailability_568399(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the give namespace name availability.
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
  var valid_568401 = path.getOrDefault("namespaceName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "namespaceName", valid_568401
  var valid_568402 = path.getOrDefault("resourceGroupName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "resourceGroupName", valid_568402
  var valid_568403 = path.getOrDefault("subscriptionId")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "subscriptionId", valid_568403
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given namespace name
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568406: Call_DisasterRecoveryConfigsCheckNameAvailability_568398;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give namespace name availability.
  ## 
  let valid = call_568406.validator(path, query, header, formData, body)
  let scheme = call_568406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568406.url(scheme.get, call_568406.host, call_568406.base,
                         call_568406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568406, url, valid)

proc call*(call_568407: Call_DisasterRecoveryConfigsCheckNameAvailability_568398;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## disasterRecoveryConfigsCheckNameAvailability
  ## Check the give namespace name availability.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given namespace name
  var path_568408 = newJObject()
  var query_568409 = newJObject()
  var body_568410 = newJObject()
  add(path_568408, "namespaceName", newJString(namespaceName))
  add(path_568408, "resourceGroupName", newJString(resourceGroupName))
  add(query_568409, "api-version", newJString(apiVersion))
  add(path_568408, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568410 = parameters
  result = call_568407.call(path_568408, query_568409, nil, nil, body_568410)

var disasterRecoveryConfigsCheckNameAvailability* = Call_DisasterRecoveryConfigsCheckNameAvailability_568398(
    name: "disasterRecoveryConfigsCheckNameAvailability",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/CheckNameAvailability",
    validator: validate_DisasterRecoveryConfigsCheckNameAvailability_568399,
    base: "", url: url_DisasterRecoveryConfigsCheckNameAvailability_568400,
    schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsCreateOrUpdate_568423 = ref object of OpenApiRestCall_567666
proc url_DisasterRecoveryConfigsCreateOrUpdate_568425(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsCreateOrUpdate_568424(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a new Alias(Disaster Recovery configuration)
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
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568426 = path.getOrDefault("namespaceName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "namespaceName", valid_568426
  var valid_568427 = path.getOrDefault("resourceGroupName")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "resourceGroupName", valid_568427
  var valid_568428 = path.getOrDefault("subscriptionId")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "subscriptionId", valid_568428
  var valid_568429 = path.getOrDefault("alias")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "alias", valid_568429
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568430 = query.getOrDefault("api-version")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "api-version", valid_568430
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters required to create an Alias(Disaster Recovery configuration)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568432: Call_DisasterRecoveryConfigsCreateOrUpdate_568423;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a new Alias(Disaster Recovery configuration)
  ## 
  let valid = call_568432.validator(path, query, header, formData, body)
  let scheme = call_568432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568432.url(scheme.get, call_568432.host, call_568432.base,
                         call_568432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568432, url, valid)

proc call*(call_568433: Call_DisasterRecoveryConfigsCreateOrUpdate_568423;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; alias: string): Recallable =
  ## disasterRecoveryConfigsCreateOrUpdate
  ## Creates or updates a new Alias(Disaster Recovery configuration)
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters required to create an Alias(Disaster Recovery configuration)
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_568434 = newJObject()
  var query_568435 = newJObject()
  var body_568436 = newJObject()
  add(path_568434, "namespaceName", newJString(namespaceName))
  add(path_568434, "resourceGroupName", newJString(resourceGroupName))
  add(query_568435, "api-version", newJString(apiVersion))
  add(path_568434, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568436 = parameters
  add(path_568434, "alias", newJString(alias))
  result = call_568433.call(path_568434, query_568435, nil, nil, body_568436)

var disasterRecoveryConfigsCreateOrUpdate* = Call_DisasterRecoveryConfigsCreateOrUpdate_568423(
    name: "disasterRecoveryConfigsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}",
    validator: validate_DisasterRecoveryConfigsCreateOrUpdate_568424, base: "",
    url: url_DisasterRecoveryConfigsCreateOrUpdate_568425, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsGet_568411 = ref object of OpenApiRestCall_567666
proc url_DisasterRecoveryConfigsGet_568413(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsGet_568412(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves Alias(Disaster Recovery configuration) for primary or secondary namespace
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
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568414 = path.getOrDefault("namespaceName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "namespaceName", valid_568414
  var valid_568415 = path.getOrDefault("resourceGroupName")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "resourceGroupName", valid_568415
  var valid_568416 = path.getOrDefault("subscriptionId")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "subscriptionId", valid_568416
  var valid_568417 = path.getOrDefault("alias")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "alias", valid_568417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568418 = query.getOrDefault("api-version")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "api-version", valid_568418
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568419: Call_DisasterRecoveryConfigsGet_568411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves Alias(Disaster Recovery configuration) for primary or secondary namespace
  ## 
  let valid = call_568419.validator(path, query, header, formData, body)
  let scheme = call_568419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568419.url(scheme.get, call_568419.host, call_568419.base,
                         call_568419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568419, url, valid)

proc call*(call_568420: Call_DisasterRecoveryConfigsGet_568411;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsGet
  ## Retrieves Alias(Disaster Recovery configuration) for primary or secondary namespace
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_568421 = newJObject()
  var query_568422 = newJObject()
  add(path_568421, "namespaceName", newJString(namespaceName))
  add(path_568421, "resourceGroupName", newJString(resourceGroupName))
  add(query_568422, "api-version", newJString(apiVersion))
  add(path_568421, "subscriptionId", newJString(subscriptionId))
  add(path_568421, "alias", newJString(alias))
  result = call_568420.call(path_568421, query_568422, nil, nil, nil)

var disasterRecoveryConfigsGet* = Call_DisasterRecoveryConfigsGet_568411(
    name: "disasterRecoveryConfigsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}",
    validator: validate_DisasterRecoveryConfigsGet_568412, base: "",
    url: url_DisasterRecoveryConfigsGet_568413, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsDelete_568437 = ref object of OpenApiRestCall_567666
proc url_DisasterRecoveryConfigsDelete_568439(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsDelete_568438(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an Alias(Disaster Recovery configuration)
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
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568440 = path.getOrDefault("namespaceName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "namespaceName", valid_568440
  var valid_568441 = path.getOrDefault("resourceGroupName")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "resourceGroupName", valid_568441
  var valid_568442 = path.getOrDefault("subscriptionId")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "subscriptionId", valid_568442
  var valid_568443 = path.getOrDefault("alias")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "alias", valid_568443
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568444 = query.getOrDefault("api-version")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "api-version", valid_568444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568445: Call_DisasterRecoveryConfigsDelete_568437; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Alias(Disaster Recovery configuration)
  ## 
  let valid = call_568445.validator(path, query, header, formData, body)
  let scheme = call_568445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568445.url(scheme.get, call_568445.host, call_568445.base,
                         call_568445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568445, url, valid)

proc call*(call_568446: Call_DisasterRecoveryConfigsDelete_568437;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsDelete
  ## Deletes an Alias(Disaster Recovery configuration)
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_568447 = newJObject()
  var query_568448 = newJObject()
  add(path_568447, "namespaceName", newJString(namespaceName))
  add(path_568447, "resourceGroupName", newJString(resourceGroupName))
  add(query_568448, "api-version", newJString(apiVersion))
  add(path_568447, "subscriptionId", newJString(subscriptionId))
  add(path_568447, "alias", newJString(alias))
  result = call_568446.call(path_568447, query_568448, nil, nil, nil)

var disasterRecoveryConfigsDelete* = Call_DisasterRecoveryConfigsDelete_568437(
    name: "disasterRecoveryConfigsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}",
    validator: validate_DisasterRecoveryConfigsDelete_568438, base: "",
    url: url_DisasterRecoveryConfigsDelete_568439, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsListAuthorizationRules_568449 = ref object of OpenApiRestCall_567666
proc url_DisasterRecoveryConfigsListAuthorizationRules_568451(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias"),
               (kind: ConstantSegment, value: "/AuthorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsListAuthorizationRules_568450(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
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
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
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
  var valid_568454 = path.getOrDefault("subscriptionId")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "subscriptionId", valid_568454
  var valid_568455 = path.getOrDefault("alias")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "alias", valid_568455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568456 = query.getOrDefault("api-version")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "api-version", valid_568456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568457: Call_DisasterRecoveryConfigsListAuthorizationRules_568449;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639376.aspx
  let valid = call_568457.validator(path, query, header, formData, body)
  let scheme = call_568457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568457.url(scheme.get, call_568457.host, call_568457.base,
                         call_568457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568457, url, valid)

proc call*(call_568458: Call_DisasterRecoveryConfigsListAuthorizationRules_568449;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsListAuthorizationRules
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
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_568459 = newJObject()
  var query_568460 = newJObject()
  add(path_568459, "namespaceName", newJString(namespaceName))
  add(path_568459, "resourceGroupName", newJString(resourceGroupName))
  add(query_568460, "api-version", newJString(apiVersion))
  add(path_568459, "subscriptionId", newJString(subscriptionId))
  add(path_568459, "alias", newJString(alias))
  result = call_568458.call(path_568459, query_568460, nil, nil, nil)

var disasterRecoveryConfigsListAuthorizationRules* = Call_DisasterRecoveryConfigsListAuthorizationRules_568449(
    name: "disasterRecoveryConfigsListAuthorizationRules",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/AuthorizationRules",
    validator: validate_DisasterRecoveryConfigsListAuthorizationRules_568450,
    base: "", url: url_DisasterRecoveryConfigsListAuthorizationRules_568451,
    schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsGetAuthorizationRule_568461 = ref object of OpenApiRestCall_567666
proc url_DisasterRecoveryConfigsGetAuthorizationRule_568463(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
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
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsGetAuthorizationRule_568462(path: JsonNode;
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
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568464 = path.getOrDefault("namespaceName")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "namespaceName", valid_568464
  var valid_568465 = path.getOrDefault("resourceGroupName")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "resourceGroupName", valid_568465
  var valid_568466 = path.getOrDefault("authorizationRuleName")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "authorizationRuleName", valid_568466
  var valid_568467 = path.getOrDefault("subscriptionId")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "subscriptionId", valid_568467
  var valid_568468 = path.getOrDefault("alias")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "alias", valid_568468
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568469 = query.getOrDefault("api-version")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "api-version", valid_568469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568470: Call_DisasterRecoveryConfigsGetAuthorizationRule_568461;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an authorization rule for a namespace by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639392.aspx
  let valid = call_568470.validator(path, query, header, formData, body)
  let scheme = call_568470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568470.url(scheme.get, call_568470.host, call_568470.base,
                         call_568470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568470, url, valid)

proc call*(call_568471: Call_DisasterRecoveryConfigsGetAuthorizationRule_568461;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsGetAuthorizationRule
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
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_568472 = newJObject()
  var query_568473 = newJObject()
  add(path_568472, "namespaceName", newJString(namespaceName))
  add(path_568472, "resourceGroupName", newJString(resourceGroupName))
  add(query_568473, "api-version", newJString(apiVersion))
  add(path_568472, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568472, "subscriptionId", newJString(subscriptionId))
  add(path_568472, "alias", newJString(alias))
  result = call_568471.call(path_568472, query_568473, nil, nil, nil)

var disasterRecoveryConfigsGetAuthorizationRule* = Call_DisasterRecoveryConfigsGetAuthorizationRule_568461(
    name: "disasterRecoveryConfigsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_DisasterRecoveryConfigsGetAuthorizationRule_568462,
    base: "", url: url_DisasterRecoveryConfigsGetAuthorizationRule_568463,
    schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsListKeys_568474 = ref object of OpenApiRestCall_567666
proc url_DisasterRecoveryConfigsListKeys_568476(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
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
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsListKeys_568475(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568477 = path.getOrDefault("namespaceName")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "namespaceName", valid_568477
  var valid_568478 = path.getOrDefault("resourceGroupName")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "resourceGroupName", valid_568478
  var valid_568479 = path.getOrDefault("authorizationRuleName")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "authorizationRuleName", valid_568479
  var valid_568480 = path.getOrDefault("subscriptionId")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "subscriptionId", valid_568480
  var valid_568481 = path.getOrDefault("alias")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "alias", valid_568481
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568482 = query.getOrDefault("api-version")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "api-version", valid_568482
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568483: Call_DisasterRecoveryConfigsListKeys_568474;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the primary and secondary connection strings for the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639398.aspx
  let valid = call_568483.validator(path, query, header, formData, body)
  let scheme = call_568483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568483.url(scheme.get, call_568483.host, call_568483.base,
                         call_568483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568483, url, valid)

proc call*(call_568484: Call_DisasterRecoveryConfigsListKeys_568474;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsListKeys
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
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_568485 = newJObject()
  var query_568486 = newJObject()
  add(path_568485, "namespaceName", newJString(namespaceName))
  add(path_568485, "resourceGroupName", newJString(resourceGroupName))
  add(query_568486, "api-version", newJString(apiVersion))
  add(path_568485, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568485, "subscriptionId", newJString(subscriptionId))
  add(path_568485, "alias", newJString(alias))
  result = call_568484.call(path_568485, query_568486, nil, nil, nil)

var disasterRecoveryConfigsListKeys* = Call_DisasterRecoveryConfigsListKeys_568474(
    name: "disasterRecoveryConfigsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_DisasterRecoveryConfigsListKeys_568475, base: "",
    url: url_DisasterRecoveryConfigsListKeys_568476, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsBreakPairing_568487 = ref object of OpenApiRestCall_567666
proc url_DisasterRecoveryConfigsBreakPairing_568489(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias"),
               (kind: ConstantSegment, value: "/breakPairing")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsBreakPairing_568488(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation disables the Disaster Recovery and stops replicating changes from primary to secondary namespaces
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
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568490 = path.getOrDefault("namespaceName")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "namespaceName", valid_568490
  var valid_568491 = path.getOrDefault("resourceGroupName")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "resourceGroupName", valid_568491
  var valid_568492 = path.getOrDefault("subscriptionId")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "subscriptionId", valid_568492
  var valid_568493 = path.getOrDefault("alias")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "alias", valid_568493
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568494 = query.getOrDefault("api-version")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "api-version", valid_568494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568495: Call_DisasterRecoveryConfigsBreakPairing_568487;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation disables the Disaster Recovery and stops replicating changes from primary to secondary namespaces
  ## 
  let valid = call_568495.validator(path, query, header, formData, body)
  let scheme = call_568495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568495.url(scheme.get, call_568495.host, call_568495.base,
                         call_568495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568495, url, valid)

proc call*(call_568496: Call_DisasterRecoveryConfigsBreakPairing_568487;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsBreakPairing
  ## This operation disables the Disaster Recovery and stops replicating changes from primary to secondary namespaces
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_568497 = newJObject()
  var query_568498 = newJObject()
  add(path_568497, "namespaceName", newJString(namespaceName))
  add(path_568497, "resourceGroupName", newJString(resourceGroupName))
  add(query_568498, "api-version", newJString(apiVersion))
  add(path_568497, "subscriptionId", newJString(subscriptionId))
  add(path_568497, "alias", newJString(alias))
  result = call_568496.call(path_568497, query_568498, nil, nil, nil)

var disasterRecoveryConfigsBreakPairing* = Call_DisasterRecoveryConfigsBreakPairing_568487(
    name: "disasterRecoveryConfigsBreakPairing", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/breakPairing",
    validator: validate_DisasterRecoveryConfigsBreakPairing_568488, base: "",
    url: url_DisasterRecoveryConfigsBreakPairing_568489, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsFailOver_568499 = ref object of OpenApiRestCall_567666
proc url_DisasterRecoveryConfigsFailOver_568501(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias"),
               (kind: ConstantSegment, value: "/failover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsFailOver_568500(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Invokes GEO DR failover and reconfigure the alias to point to the secondary namespace
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
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568502 = path.getOrDefault("namespaceName")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "namespaceName", valid_568502
  var valid_568503 = path.getOrDefault("resourceGroupName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "resourceGroupName", valid_568503
  var valid_568504 = path.getOrDefault("subscriptionId")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "subscriptionId", valid_568504
  var valid_568505 = path.getOrDefault("alias")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "alias", valid_568505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568506 = query.getOrDefault("api-version")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "api-version", valid_568506
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568507: Call_DisasterRecoveryConfigsFailOver_568499;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Invokes GEO DR failover and reconfigure the alias to point to the secondary namespace
  ## 
  let valid = call_568507.validator(path, query, header, formData, body)
  let scheme = call_568507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568507.url(scheme.get, call_568507.host, call_568507.base,
                         call_568507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568507, url, valid)

proc call*(call_568508: Call_DisasterRecoveryConfigsFailOver_568499;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsFailOver
  ## Invokes GEO DR failover and reconfigure the alias to point to the secondary namespace
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_568509 = newJObject()
  var query_568510 = newJObject()
  add(path_568509, "namespaceName", newJString(namespaceName))
  add(path_568509, "resourceGroupName", newJString(resourceGroupName))
  add(query_568510, "api-version", newJString(apiVersion))
  add(path_568509, "subscriptionId", newJString(subscriptionId))
  add(path_568509, "alias", newJString(alias))
  result = call_568508.call(path_568509, query_568510, nil, nil, nil)

var disasterRecoveryConfigsFailOver* = Call_DisasterRecoveryConfigsFailOver_568499(
    name: "disasterRecoveryConfigsFailOver", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/failover",
    validator: validate_DisasterRecoveryConfigsFailOver_568500, base: "",
    url: url_DisasterRecoveryConfigsFailOver_568501, schemes: {Scheme.Https})
type
  Call_EventHubsListByNamespace_568511 = ref object of OpenApiRestCall_567666
proc url_EventHubsListByNamespace_568513(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsListByNamespace_568512(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the Event Hubs in a service bus Namespace.
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
  var valid_568514 = path.getOrDefault("namespaceName")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "namespaceName", valid_568514
  var valid_568515 = path.getOrDefault("resourceGroupName")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "resourceGroupName", valid_568515
  var valid_568516 = path.getOrDefault("subscriptionId")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "subscriptionId", valid_568516
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568517 = query.getOrDefault("api-version")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "api-version", valid_568517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568518: Call_EventHubsListByNamespace_568511; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the Event Hubs in a service bus Namespace.
  ## 
  let valid = call_568518.validator(path, query, header, formData, body)
  let scheme = call_568518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568518.url(scheme.get, call_568518.host, call_568518.base,
                         call_568518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568518, url, valid)

proc call*(call_568519: Call_EventHubsListByNamespace_568511;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## eventHubsListByNamespace
  ## Gets all the Event Hubs in a service bus Namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568520 = newJObject()
  var query_568521 = newJObject()
  add(path_568520, "namespaceName", newJString(namespaceName))
  add(path_568520, "resourceGroupName", newJString(resourceGroupName))
  add(query_568521, "api-version", newJString(apiVersion))
  add(path_568520, "subscriptionId", newJString(subscriptionId))
  result = call_568519.call(path_568520, query_568521, nil, nil, nil)

var eventHubsListByNamespace* = Call_EventHubsListByNamespace_568511(
    name: "eventHubsListByNamespace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/eventhubs",
    validator: validate_EventHubsListByNamespace_568512, base: "",
    url: url_EventHubsListByNamespace_568513, schemes: {Scheme.Https})
type
  Call_NamespacesMigrate_568522 = ref object of OpenApiRestCall_567666
proc url_NamespacesMigrate_568524(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/migrate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesMigrate_568523(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## This operation Migrate the given namespace to provided name type
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
  var valid_568525 = path.getOrDefault("namespaceName")
  valid_568525 = validateParameter(valid_568525, JString, required = true,
                                 default = nil)
  if valid_568525 != nil:
    section.add "namespaceName", valid_568525
  var valid_568526 = path.getOrDefault("resourceGroupName")
  valid_568526 = validateParameter(valid_568526, JString, required = true,
                                 default = nil)
  if valid_568526 != nil:
    section.add "resourceGroupName", valid_568526
  var valid_568527 = path.getOrDefault("subscriptionId")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "subscriptionId", valid_568527
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568528 = query.getOrDefault("api-version")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "api-version", valid_568528
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to migrate namespace type.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568530: Call_NamespacesMigrate_568522; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation Migrate the given namespace to provided name type
  ## 
  let valid = call_568530.validator(path, query, header, formData, body)
  let scheme = call_568530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568530.url(scheme.get, call_568530.host, call_568530.base,
                         call_568530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568530, url, valid)

proc call*(call_568531: Call_NamespacesMigrate_568522; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesMigrate
  ## This operation Migrate the given namespace to provided name type
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to migrate namespace type.
  var path_568532 = newJObject()
  var query_568533 = newJObject()
  var body_568534 = newJObject()
  add(path_568532, "namespaceName", newJString(namespaceName))
  add(path_568532, "resourceGroupName", newJString(resourceGroupName))
  add(query_568533, "api-version", newJString(apiVersion))
  add(path_568532, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568534 = parameters
  result = call_568531.call(path_568532, query_568533, nil, nil, body_568534)

var namespacesMigrate* = Call_NamespacesMigrate_568522(name: "namespacesMigrate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/migrate",
    validator: validate_NamespacesMigrate_568523, base: "",
    url: url_NamespacesMigrate_568524, schemes: {Scheme.Https})
type
  Call_MigrationConfigsList_568535 = ref object of OpenApiRestCall_567666
proc url_MigrationConfigsList_568537(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/migrationConfigurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrationConfigsList_568536(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all migrationConfigurations
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
  var valid_568538 = path.getOrDefault("namespaceName")
  valid_568538 = validateParameter(valid_568538, JString, required = true,
                                 default = nil)
  if valid_568538 != nil:
    section.add "namespaceName", valid_568538
  var valid_568539 = path.getOrDefault("resourceGroupName")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "resourceGroupName", valid_568539
  var valid_568540 = path.getOrDefault("subscriptionId")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "subscriptionId", valid_568540
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568541 = query.getOrDefault("api-version")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "api-version", valid_568541
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568542: Call_MigrationConfigsList_568535; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all migrationConfigurations
  ## 
  let valid = call_568542.validator(path, query, header, formData, body)
  let scheme = call_568542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568542.url(scheme.get, call_568542.host, call_568542.base,
                         call_568542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568542, url, valid)

proc call*(call_568543: Call_MigrationConfigsList_568535; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## migrationConfigsList
  ## Gets all migrationConfigurations
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568544 = newJObject()
  var query_568545 = newJObject()
  add(path_568544, "namespaceName", newJString(namespaceName))
  add(path_568544, "resourceGroupName", newJString(resourceGroupName))
  add(query_568545, "api-version", newJString(apiVersion))
  add(path_568544, "subscriptionId", newJString(subscriptionId))
  result = call_568543.call(path_568544, query_568545, nil, nil, nil)

var migrationConfigsList* = Call_MigrationConfigsList_568535(
    name: "migrationConfigsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/migrationConfigurations",
    validator: validate_MigrationConfigsList_568536, base: "",
    url: url_MigrationConfigsList_568537, schemes: {Scheme.Https})
type
  Call_MigrationConfigsCreateAndStartMigration_568571 = ref object of OpenApiRestCall_567666
proc url_MigrationConfigsCreateAndStartMigration_568573(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "configName" in path, "`configName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/migrationConfigurations/"),
               (kind: VariableSegment, value: "configName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrationConfigsCreateAndStartMigration_568572(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates Migration configuration and starts migration of entities from Standard to Premium namespace
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
  ##   configName: JString (required)
  ##             : The configuration name. Should always be "$default".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568574 = path.getOrDefault("namespaceName")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "namespaceName", valid_568574
  var valid_568575 = path.getOrDefault("resourceGroupName")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "resourceGroupName", valid_568575
  var valid_568576 = path.getOrDefault("subscriptionId")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "subscriptionId", valid_568576
  var valid_568577 = path.getOrDefault("configName")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = newJString("$default"))
  if valid_568577 != nil:
    section.add "configName", valid_568577
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568578 = query.getOrDefault("api-version")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "api-version", valid_568578
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters required to create Migration Configuration
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568580: Call_MigrationConfigsCreateAndStartMigration_568571;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates Migration configuration and starts migration of entities from Standard to Premium namespace
  ## 
  let valid = call_568580.validator(path, query, header, formData, body)
  let scheme = call_568580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568580.url(scheme.get, call_568580.host, call_568580.base,
                         call_568580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568580, url, valid)

proc call*(call_568581: Call_MigrationConfigsCreateAndStartMigration_568571;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode;
          configName: string = "$default"): Recallable =
  ## migrationConfigsCreateAndStartMigration
  ## Creates Migration configuration and starts migration of entities from Standard to Premium namespace
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters required to create Migration Configuration
  ##   configName: string (required)
  ##             : The configuration name. Should always be "$default".
  var path_568582 = newJObject()
  var query_568583 = newJObject()
  var body_568584 = newJObject()
  add(path_568582, "namespaceName", newJString(namespaceName))
  add(path_568582, "resourceGroupName", newJString(resourceGroupName))
  add(query_568583, "api-version", newJString(apiVersion))
  add(path_568582, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568584 = parameters
  add(path_568582, "configName", newJString(configName))
  result = call_568581.call(path_568582, query_568583, nil, nil, body_568584)

var migrationConfigsCreateAndStartMigration* = Call_MigrationConfigsCreateAndStartMigration_568571(
    name: "migrationConfigsCreateAndStartMigration", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/migrationConfigurations/{configName}",
    validator: validate_MigrationConfigsCreateAndStartMigration_568572, base: "",
    url: url_MigrationConfigsCreateAndStartMigration_568573,
    schemes: {Scheme.Https})
type
  Call_MigrationConfigsGet_568546 = ref object of OpenApiRestCall_567666
proc url_MigrationConfigsGet_568548(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "configName" in path, "`configName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/migrationConfigurations/"),
               (kind: VariableSegment, value: "configName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrationConfigsGet_568547(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves Migration Config
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
  ##   configName: JString (required)
  ##             : The configuration name. Should always be "$default".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568549 = path.getOrDefault("namespaceName")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "namespaceName", valid_568549
  var valid_568550 = path.getOrDefault("resourceGroupName")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "resourceGroupName", valid_568550
  var valid_568551 = path.getOrDefault("subscriptionId")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "subscriptionId", valid_568551
  var valid_568565 = path.getOrDefault("configName")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = newJString("$default"))
  if valid_568565 != nil:
    section.add "configName", valid_568565
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568566 = query.getOrDefault("api-version")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "api-version", valid_568566
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568567: Call_MigrationConfigsGet_568546; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves Migration Config
  ## 
  let valid = call_568567.validator(path, query, header, formData, body)
  let scheme = call_568567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568567.url(scheme.get, call_568567.host, call_568567.base,
                         call_568567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568567, url, valid)

proc call*(call_568568: Call_MigrationConfigsGet_568546; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          configName: string = "$default"): Recallable =
  ## migrationConfigsGet
  ## Retrieves Migration Config
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configName: string (required)
  ##             : The configuration name. Should always be "$default".
  var path_568569 = newJObject()
  var query_568570 = newJObject()
  add(path_568569, "namespaceName", newJString(namespaceName))
  add(path_568569, "resourceGroupName", newJString(resourceGroupName))
  add(query_568570, "api-version", newJString(apiVersion))
  add(path_568569, "subscriptionId", newJString(subscriptionId))
  add(path_568569, "configName", newJString(configName))
  result = call_568568.call(path_568569, query_568570, nil, nil, nil)

var migrationConfigsGet* = Call_MigrationConfigsGet_568546(
    name: "migrationConfigsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/migrationConfigurations/{configName}",
    validator: validate_MigrationConfigsGet_568547, base: "",
    url: url_MigrationConfigsGet_568548, schemes: {Scheme.Https})
type
  Call_MigrationConfigsDelete_568585 = ref object of OpenApiRestCall_567666
proc url_MigrationConfigsDelete_568587(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "configName" in path, "`configName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/migrationConfigurations/"),
               (kind: VariableSegment, value: "configName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrationConfigsDelete_568586(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a MigrationConfiguration
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
  ##   configName: JString (required)
  ##             : The configuration name. Should always be "$default".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568588 = path.getOrDefault("namespaceName")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "namespaceName", valid_568588
  var valid_568589 = path.getOrDefault("resourceGroupName")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "resourceGroupName", valid_568589
  var valid_568590 = path.getOrDefault("subscriptionId")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "subscriptionId", valid_568590
  var valid_568591 = path.getOrDefault("configName")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = newJString("$default"))
  if valid_568591 != nil:
    section.add "configName", valid_568591
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568592 = query.getOrDefault("api-version")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "api-version", valid_568592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568593: Call_MigrationConfigsDelete_568585; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a MigrationConfiguration
  ## 
  let valid = call_568593.validator(path, query, header, formData, body)
  let scheme = call_568593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568593.url(scheme.get, call_568593.host, call_568593.base,
                         call_568593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568593, url, valid)

proc call*(call_568594: Call_MigrationConfigsDelete_568585; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          configName: string = "$default"): Recallable =
  ## migrationConfigsDelete
  ## Deletes a MigrationConfiguration
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configName: string (required)
  ##             : The configuration name. Should always be "$default".
  var path_568595 = newJObject()
  var query_568596 = newJObject()
  add(path_568595, "namespaceName", newJString(namespaceName))
  add(path_568595, "resourceGroupName", newJString(resourceGroupName))
  add(query_568596, "api-version", newJString(apiVersion))
  add(path_568595, "subscriptionId", newJString(subscriptionId))
  add(path_568595, "configName", newJString(configName))
  result = call_568594.call(path_568595, query_568596, nil, nil, nil)

var migrationConfigsDelete* = Call_MigrationConfigsDelete_568585(
    name: "migrationConfigsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/migrationConfigurations/{configName}",
    validator: validate_MigrationConfigsDelete_568586, base: "",
    url: url_MigrationConfigsDelete_568587, schemes: {Scheme.Https})
type
  Call_MigrationConfigsRevert_568597 = ref object of OpenApiRestCall_567666
proc url_MigrationConfigsRevert_568599(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "configName" in path, "`configName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/migrationConfigurations/"),
               (kind: VariableSegment, value: "configName"),
               (kind: ConstantSegment, value: "/revert")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrationConfigsRevert_568598(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation reverts Migration
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
  ##   configName: JString (required)
  ##             : The configuration name. Should always be "$default".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568600 = path.getOrDefault("namespaceName")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "namespaceName", valid_568600
  var valid_568601 = path.getOrDefault("resourceGroupName")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "resourceGroupName", valid_568601
  var valid_568602 = path.getOrDefault("subscriptionId")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "subscriptionId", valid_568602
  var valid_568603 = path.getOrDefault("configName")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = newJString("$default"))
  if valid_568603 != nil:
    section.add "configName", valid_568603
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568604 = query.getOrDefault("api-version")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "api-version", valid_568604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568605: Call_MigrationConfigsRevert_568597; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation reverts Migration
  ## 
  let valid = call_568605.validator(path, query, header, formData, body)
  let scheme = call_568605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568605.url(scheme.get, call_568605.host, call_568605.base,
                         call_568605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568605, url, valid)

proc call*(call_568606: Call_MigrationConfigsRevert_568597; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          configName: string = "$default"): Recallable =
  ## migrationConfigsRevert
  ## This operation reverts Migration
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configName: string (required)
  ##             : The configuration name. Should always be "$default".
  var path_568607 = newJObject()
  var query_568608 = newJObject()
  add(path_568607, "namespaceName", newJString(namespaceName))
  add(path_568607, "resourceGroupName", newJString(resourceGroupName))
  add(query_568608, "api-version", newJString(apiVersion))
  add(path_568607, "subscriptionId", newJString(subscriptionId))
  add(path_568607, "configName", newJString(configName))
  result = call_568606.call(path_568607, query_568608, nil, nil, nil)

var migrationConfigsRevert* = Call_MigrationConfigsRevert_568597(
    name: "migrationConfigsRevert", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/migrationConfigurations/{configName}/revert",
    validator: validate_MigrationConfigsRevert_568598, base: "",
    url: url_MigrationConfigsRevert_568599, schemes: {Scheme.Https})
type
  Call_MigrationConfigsCompleteMigration_568609 = ref object of OpenApiRestCall_567666
proc url_MigrationConfigsCompleteMigration_568611(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "configName" in path, "`configName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/migrationConfigurations/"),
               (kind: VariableSegment, value: "configName"),
               (kind: ConstantSegment, value: "/upgrade")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrationConfigsCompleteMigration_568610(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation Completes Migration of entities by pointing the connection strings to Premium namespace and any entities created after the operation will be under Premium Namespace. CompleteMigration operation will fail when entity migration is in-progress.
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
  ##   configName: JString (required)
  ##             : The configuration name. Should always be "$default".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568612 = path.getOrDefault("namespaceName")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "namespaceName", valid_568612
  var valid_568613 = path.getOrDefault("resourceGroupName")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "resourceGroupName", valid_568613
  var valid_568614 = path.getOrDefault("subscriptionId")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "subscriptionId", valid_568614
  var valid_568615 = path.getOrDefault("configName")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = newJString("$default"))
  if valid_568615 != nil:
    section.add "configName", valid_568615
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568616 = query.getOrDefault("api-version")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "api-version", valid_568616
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568617: Call_MigrationConfigsCompleteMigration_568609;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation Completes Migration of entities by pointing the connection strings to Premium namespace and any entities created after the operation will be under Premium Namespace. CompleteMigration operation will fail when entity migration is in-progress.
  ## 
  let valid = call_568617.validator(path, query, header, formData, body)
  let scheme = call_568617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568617.url(scheme.get, call_568617.host, call_568617.base,
                         call_568617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568617, url, valid)

proc call*(call_568618: Call_MigrationConfigsCompleteMigration_568609;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; configName: string = "$default"): Recallable =
  ## migrationConfigsCompleteMigration
  ## This operation Completes Migration of entities by pointing the connection strings to Premium namespace and any entities created after the operation will be under Premium Namespace. CompleteMigration operation will fail when entity migration is in-progress.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configName: string (required)
  ##             : The configuration name. Should always be "$default".
  var path_568619 = newJObject()
  var query_568620 = newJObject()
  add(path_568619, "namespaceName", newJString(namespaceName))
  add(path_568619, "resourceGroupName", newJString(resourceGroupName))
  add(query_568620, "api-version", newJString(apiVersion))
  add(path_568619, "subscriptionId", newJString(subscriptionId))
  add(path_568619, "configName", newJString(configName))
  result = call_568618.call(path_568619, query_568620, nil, nil, nil)

var migrationConfigsCompleteMigration* = Call_MigrationConfigsCompleteMigration_568609(
    name: "migrationConfigsCompleteMigration", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/migrationConfigurations/{configName}/upgrade",
    validator: validate_MigrationConfigsCompleteMigration_568610, base: "",
    url: url_MigrationConfigsCompleteMigration_568611, schemes: {Scheme.Https})
type
  Call_NamespacesListNetworkRuleSets_568621 = ref object of OpenApiRestCall_567666
proc url_NamespacesListNetworkRuleSets_568623(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/networkRuleSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListNetworkRuleSets_568622(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets list of NetworkRuleSet for a Namespace.
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
  var valid_568624 = path.getOrDefault("namespaceName")
  valid_568624 = validateParameter(valid_568624, JString, required = true,
                                 default = nil)
  if valid_568624 != nil:
    section.add "namespaceName", valid_568624
  var valid_568625 = path.getOrDefault("resourceGroupName")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "resourceGroupName", valid_568625
  var valid_568626 = path.getOrDefault("subscriptionId")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "subscriptionId", valid_568626
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568627 = query.getOrDefault("api-version")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "api-version", valid_568627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568628: Call_NamespacesListNetworkRuleSets_568621; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets list of NetworkRuleSet for a Namespace.
  ## 
  let valid = call_568628.validator(path, query, header, formData, body)
  let scheme = call_568628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568628.url(scheme.get, call_568628.host, call_568628.base,
                         call_568628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568628, url, valid)

proc call*(call_568629: Call_NamespacesListNetworkRuleSets_568621;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesListNetworkRuleSets
  ## Gets list of NetworkRuleSet for a Namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568630 = newJObject()
  var query_568631 = newJObject()
  add(path_568630, "namespaceName", newJString(namespaceName))
  add(path_568630, "resourceGroupName", newJString(resourceGroupName))
  add(query_568631, "api-version", newJString(apiVersion))
  add(path_568630, "subscriptionId", newJString(subscriptionId))
  result = call_568629.call(path_568630, query_568631, nil, nil, nil)

var namespacesListNetworkRuleSets* = Call_NamespacesListNetworkRuleSets_568621(
    name: "namespacesListNetworkRuleSets", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/networkRuleSets",
    validator: validate_NamespacesListNetworkRuleSets_568622, base: "",
    url: url_NamespacesListNetworkRuleSets_568623, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateNetworkRuleSet_568643 = ref object of OpenApiRestCall_567666
proc url_NamespacesCreateOrUpdateNetworkRuleSet_568645(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/networkRuleSets/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdateNetworkRuleSet_568644(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update NetworkRuleSet for a Namespace.
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
  var valid_568646 = path.getOrDefault("namespaceName")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "namespaceName", valid_568646
  var valid_568647 = path.getOrDefault("resourceGroupName")
  valid_568647 = validateParameter(valid_568647, JString, required = true,
                                 default = nil)
  if valid_568647 != nil:
    section.add "resourceGroupName", valid_568647
  var valid_568648 = path.getOrDefault("subscriptionId")
  valid_568648 = validateParameter(valid_568648, JString, required = true,
                                 default = nil)
  if valid_568648 != nil:
    section.add "subscriptionId", valid_568648
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568649 = query.getOrDefault("api-version")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = nil)
  if valid_568649 != nil:
    section.add "api-version", valid_568649
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Namespace IpFilterRule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568651: Call_NamespacesCreateOrUpdateNetworkRuleSet_568643;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update NetworkRuleSet for a Namespace.
  ## 
  let valid = call_568651.validator(path, query, header, formData, body)
  let scheme = call_568651.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568651.url(scheme.get, call_568651.host, call_568651.base,
                         call_568651.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568651, url, valid)

proc call*(call_568652: Call_NamespacesCreateOrUpdateNetworkRuleSet_568643;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateNetworkRuleSet
  ## Create or update NetworkRuleSet for a Namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The Namespace IpFilterRule.
  var path_568653 = newJObject()
  var query_568654 = newJObject()
  var body_568655 = newJObject()
  add(path_568653, "namespaceName", newJString(namespaceName))
  add(path_568653, "resourceGroupName", newJString(resourceGroupName))
  add(query_568654, "api-version", newJString(apiVersion))
  add(path_568653, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568655 = parameters
  result = call_568652.call(path_568653, query_568654, nil, nil, body_568655)

var namespacesCreateOrUpdateNetworkRuleSet* = Call_NamespacesCreateOrUpdateNetworkRuleSet_568643(
    name: "namespacesCreateOrUpdateNetworkRuleSet", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/networkRuleSets/default",
    validator: validate_NamespacesCreateOrUpdateNetworkRuleSet_568644, base: "",
    url: url_NamespacesCreateOrUpdateNetworkRuleSet_568645,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetNetworkRuleSet_568632 = ref object of OpenApiRestCall_567666
proc url_NamespacesGetNetworkRuleSet_568634(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/networkRuleSets/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGetNetworkRuleSet_568633(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets NetworkRuleSet for a Namespace.
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
  var valid_568635 = path.getOrDefault("namespaceName")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = nil)
  if valid_568635 != nil:
    section.add "namespaceName", valid_568635
  var valid_568636 = path.getOrDefault("resourceGroupName")
  valid_568636 = validateParameter(valid_568636, JString, required = true,
                                 default = nil)
  if valid_568636 != nil:
    section.add "resourceGroupName", valid_568636
  var valid_568637 = path.getOrDefault("subscriptionId")
  valid_568637 = validateParameter(valid_568637, JString, required = true,
                                 default = nil)
  if valid_568637 != nil:
    section.add "subscriptionId", valid_568637
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568638 = query.getOrDefault("api-version")
  valid_568638 = validateParameter(valid_568638, JString, required = true,
                                 default = nil)
  if valid_568638 != nil:
    section.add "api-version", valid_568638
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568639: Call_NamespacesGetNetworkRuleSet_568632; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets NetworkRuleSet for a Namespace.
  ## 
  let valid = call_568639.validator(path, query, header, formData, body)
  let scheme = call_568639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568639.url(scheme.get, call_568639.host, call_568639.base,
                         call_568639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568639, url, valid)

proc call*(call_568640: Call_NamespacesGetNetworkRuleSet_568632;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesGetNetworkRuleSet
  ## Gets NetworkRuleSet for a Namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568641 = newJObject()
  var query_568642 = newJObject()
  add(path_568641, "namespaceName", newJString(namespaceName))
  add(path_568641, "resourceGroupName", newJString(resourceGroupName))
  add(query_568642, "api-version", newJString(apiVersion))
  add(path_568641, "subscriptionId", newJString(subscriptionId))
  result = call_568640.call(path_568641, query_568642, nil, nil, nil)

var namespacesGetNetworkRuleSet* = Call_NamespacesGetNetworkRuleSet_568632(
    name: "namespacesGetNetworkRuleSet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/networkRuleSets/default",
    validator: validate_NamespacesGetNetworkRuleSet_568633, base: "",
    url: url_NamespacesGetNetworkRuleSet_568634, schemes: {Scheme.Https})
type
  Call_QueuesListByNamespace_568656 = ref object of OpenApiRestCall_567666
proc url_QueuesListByNamespace_568658(protocol: Scheme; host: string; base: string;
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

proc validate_QueuesListByNamespace_568657(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_568660 = path.getOrDefault("namespaceName")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "namespaceName", valid_568660
  var valid_568661 = path.getOrDefault("resourceGroupName")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = nil)
  if valid_568661 != nil:
    section.add "resourceGroupName", valid_568661
  var valid_568662 = path.getOrDefault("subscriptionId")
  valid_568662 = validateParameter(valid_568662, JString, required = true,
                                 default = nil)
  if valid_568662 != nil:
    section.add "subscriptionId", valid_568662
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skip: JInt
  ##        : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568663 = query.getOrDefault("api-version")
  valid_568663 = validateParameter(valid_568663, JString, required = true,
                                 default = nil)
  if valid_568663 != nil:
    section.add "api-version", valid_568663
  var valid_568664 = query.getOrDefault("$top")
  valid_568664 = validateParameter(valid_568664, JInt, required = false, default = nil)
  if valid_568664 != nil:
    section.add "$top", valid_568664
  var valid_568665 = query.getOrDefault("$skip")
  valid_568665 = validateParameter(valid_568665, JInt, required = false, default = nil)
  if valid_568665 != nil:
    section.add "$skip", valid_568665
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568666: Call_QueuesListByNamespace_568656; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the queues within a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639415.aspx
  let valid = call_568666.validator(path, query, header, formData, body)
  let scheme = call_568666.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568666.url(scheme.get, call_568666.host, call_568666.base,
                         call_568666.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568666, url, valid)

proc call*(call_568667: Call_QueuesListByNamespace_568656; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Skip: int = 0): Recallable =
  ## queuesListByNamespace
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
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skip: int
  ##       : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  var path_568668 = newJObject()
  var query_568669 = newJObject()
  add(path_568668, "namespaceName", newJString(namespaceName))
  add(path_568668, "resourceGroupName", newJString(resourceGroupName))
  add(query_568669, "api-version", newJString(apiVersion))
  add(path_568668, "subscriptionId", newJString(subscriptionId))
  add(query_568669, "$top", newJInt(Top))
  add(query_568669, "$skip", newJInt(Skip))
  result = call_568667.call(path_568668, query_568669, nil, nil, nil)

var queuesListByNamespace* = Call_QueuesListByNamespace_568656(
    name: "queuesListByNamespace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues",
    validator: validate_QueuesListByNamespace_568657, base: "",
    url: url_QueuesListByNamespace_568658, schemes: {Scheme.Https})
type
  Call_QueuesCreateOrUpdate_568682 = ref object of OpenApiRestCall_567666
proc url_QueuesCreateOrUpdate_568684(protocol: Scheme; host: string; base: string;
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

proc validate_QueuesCreateOrUpdate_568683(path: JsonNode; query: JsonNode;
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
  var valid_568685 = path.getOrDefault("namespaceName")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "namespaceName", valid_568685
  var valid_568686 = path.getOrDefault("resourceGroupName")
  valid_568686 = validateParameter(valid_568686, JString, required = true,
                                 default = nil)
  if valid_568686 != nil:
    section.add "resourceGroupName", valid_568686
  var valid_568687 = path.getOrDefault("subscriptionId")
  valid_568687 = validateParameter(valid_568687, JString, required = true,
                                 default = nil)
  if valid_568687 != nil:
    section.add "subscriptionId", valid_568687
  var valid_568688 = path.getOrDefault("queueName")
  valid_568688 = validateParameter(valid_568688, JString, required = true,
                                 default = nil)
  if valid_568688 != nil:
    section.add "queueName", valid_568688
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568689 = query.getOrDefault("api-version")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "api-version", valid_568689
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

proc call*(call_568691: Call_QueuesCreateOrUpdate_568682; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Service Bus queue. This operation is idempotent.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639395.aspx
  let valid = call_568691.validator(path, query, header, formData, body)
  let scheme = call_568691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568691.url(scheme.get, call_568691.host, call_568691.base,
                         call_568691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568691, url, valid)

proc call*(call_568692: Call_QueuesCreateOrUpdate_568682; namespaceName: string;
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
  var path_568693 = newJObject()
  var query_568694 = newJObject()
  var body_568695 = newJObject()
  add(path_568693, "namespaceName", newJString(namespaceName))
  add(path_568693, "resourceGroupName", newJString(resourceGroupName))
  add(query_568694, "api-version", newJString(apiVersion))
  add(path_568693, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568695 = parameters
  add(path_568693, "queueName", newJString(queueName))
  result = call_568692.call(path_568693, query_568694, nil, nil, body_568695)

var queuesCreateOrUpdate* = Call_QueuesCreateOrUpdate_568682(
    name: "queuesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}",
    validator: validate_QueuesCreateOrUpdate_568683, base: "",
    url: url_QueuesCreateOrUpdate_568684, schemes: {Scheme.Https})
type
  Call_QueuesGet_568670 = ref object of OpenApiRestCall_567666
proc url_QueuesGet_568672(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_QueuesGet_568671(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568673 = path.getOrDefault("namespaceName")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "namespaceName", valid_568673
  var valid_568674 = path.getOrDefault("resourceGroupName")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "resourceGroupName", valid_568674
  var valid_568675 = path.getOrDefault("subscriptionId")
  valid_568675 = validateParameter(valid_568675, JString, required = true,
                                 default = nil)
  if valid_568675 != nil:
    section.add "subscriptionId", valid_568675
  var valid_568676 = path.getOrDefault("queueName")
  valid_568676 = validateParameter(valid_568676, JString, required = true,
                                 default = nil)
  if valid_568676 != nil:
    section.add "queueName", valid_568676
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568677 = query.getOrDefault("api-version")
  valid_568677 = validateParameter(valid_568677, JString, required = true,
                                 default = nil)
  if valid_568677 != nil:
    section.add "api-version", valid_568677
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568678: Call_QueuesGet_568670; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a description for the specified queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639380.aspx
  let valid = call_568678.validator(path, query, header, formData, body)
  let scheme = call_568678.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568678.url(scheme.get, call_568678.host, call_568678.base,
                         call_568678.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568678, url, valid)

proc call*(call_568679: Call_QueuesGet_568670; namespaceName: string;
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
  var path_568680 = newJObject()
  var query_568681 = newJObject()
  add(path_568680, "namespaceName", newJString(namespaceName))
  add(path_568680, "resourceGroupName", newJString(resourceGroupName))
  add(query_568681, "api-version", newJString(apiVersion))
  add(path_568680, "subscriptionId", newJString(subscriptionId))
  add(path_568680, "queueName", newJString(queueName))
  result = call_568679.call(path_568680, query_568681, nil, nil, nil)

var queuesGet* = Call_QueuesGet_568670(name: "queuesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}",
                                    validator: validate_QueuesGet_568671,
                                    base: "", url: url_QueuesGet_568672,
                                    schemes: {Scheme.Https})
type
  Call_QueuesDelete_568696 = ref object of OpenApiRestCall_567666
proc url_QueuesDelete_568698(protocol: Scheme; host: string; base: string;
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

proc validate_QueuesDelete_568697(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568699 = path.getOrDefault("namespaceName")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "namespaceName", valid_568699
  var valid_568700 = path.getOrDefault("resourceGroupName")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = nil)
  if valid_568700 != nil:
    section.add "resourceGroupName", valid_568700
  var valid_568701 = path.getOrDefault("subscriptionId")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "subscriptionId", valid_568701
  var valid_568702 = path.getOrDefault("queueName")
  valid_568702 = validateParameter(valid_568702, JString, required = true,
                                 default = nil)
  if valid_568702 != nil:
    section.add "queueName", valid_568702
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568703 = query.getOrDefault("api-version")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "api-version", valid_568703
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568704: Call_QueuesDelete_568696; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a queue from the specified namespace in a resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639411.aspx
  let valid = call_568704.validator(path, query, header, formData, body)
  let scheme = call_568704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568704.url(scheme.get, call_568704.host, call_568704.base,
                         call_568704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568704, url, valid)

proc call*(call_568705: Call_QueuesDelete_568696; namespaceName: string;
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
  var path_568706 = newJObject()
  var query_568707 = newJObject()
  add(path_568706, "namespaceName", newJString(namespaceName))
  add(path_568706, "resourceGroupName", newJString(resourceGroupName))
  add(query_568707, "api-version", newJString(apiVersion))
  add(path_568706, "subscriptionId", newJString(subscriptionId))
  add(path_568706, "queueName", newJString(queueName))
  result = call_568705.call(path_568706, query_568707, nil, nil, nil)

var queuesDelete* = Call_QueuesDelete_568696(name: "queuesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}",
    validator: validate_QueuesDelete_568697, base: "", url: url_QueuesDelete_568698,
    schemes: {Scheme.Https})
type
  Call_QueuesListAuthorizationRules_568708 = ref object of OpenApiRestCall_567666
proc url_QueuesListAuthorizationRules_568710(protocol: Scheme; host: string;
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

proc validate_QueuesListAuthorizationRules_568709(path: JsonNode; query: JsonNode;
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
  var valid_568711 = path.getOrDefault("namespaceName")
  valid_568711 = validateParameter(valid_568711, JString, required = true,
                                 default = nil)
  if valid_568711 != nil:
    section.add "namespaceName", valid_568711
  var valid_568712 = path.getOrDefault("resourceGroupName")
  valid_568712 = validateParameter(valid_568712, JString, required = true,
                                 default = nil)
  if valid_568712 != nil:
    section.add "resourceGroupName", valid_568712
  var valid_568713 = path.getOrDefault("subscriptionId")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = nil)
  if valid_568713 != nil:
    section.add "subscriptionId", valid_568713
  var valid_568714 = path.getOrDefault("queueName")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "queueName", valid_568714
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568715 = query.getOrDefault("api-version")
  valid_568715 = validateParameter(valid_568715, JString, required = true,
                                 default = nil)
  if valid_568715 != nil:
    section.add "api-version", valid_568715
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568716: Call_QueuesListAuthorizationRules_568708; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all authorization rules for a queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705607.aspx
  let valid = call_568716.validator(path, query, header, formData, body)
  let scheme = call_568716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568716.url(scheme.get, call_568716.host, call_568716.base,
                         call_568716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568716, url, valid)

proc call*(call_568717: Call_QueuesListAuthorizationRules_568708;
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
  var path_568718 = newJObject()
  var query_568719 = newJObject()
  add(path_568718, "namespaceName", newJString(namespaceName))
  add(path_568718, "resourceGroupName", newJString(resourceGroupName))
  add(query_568719, "api-version", newJString(apiVersion))
  add(path_568718, "subscriptionId", newJString(subscriptionId))
  add(path_568718, "queueName", newJString(queueName))
  result = call_568717.call(path_568718, query_568719, nil, nil, nil)

var queuesListAuthorizationRules* = Call_QueuesListAuthorizationRules_568708(
    name: "queuesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules",
    validator: validate_QueuesListAuthorizationRules_568709, base: "",
    url: url_QueuesListAuthorizationRules_568710, schemes: {Scheme.Https})
type
  Call_QueuesCreateOrUpdateAuthorizationRule_568733 = ref object of OpenApiRestCall_567666
proc url_QueuesCreateOrUpdateAuthorizationRule_568735(protocol: Scheme;
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

proc validate_QueuesCreateOrUpdateAuthorizationRule_568734(path: JsonNode;
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
  var valid_568736 = path.getOrDefault("namespaceName")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "namespaceName", valid_568736
  var valid_568737 = path.getOrDefault("resourceGroupName")
  valid_568737 = validateParameter(valid_568737, JString, required = true,
                                 default = nil)
  if valid_568737 != nil:
    section.add "resourceGroupName", valid_568737
  var valid_568738 = path.getOrDefault("authorizationRuleName")
  valid_568738 = validateParameter(valid_568738, JString, required = true,
                                 default = nil)
  if valid_568738 != nil:
    section.add "authorizationRuleName", valid_568738
  var valid_568739 = path.getOrDefault("subscriptionId")
  valid_568739 = validateParameter(valid_568739, JString, required = true,
                                 default = nil)
  if valid_568739 != nil:
    section.add "subscriptionId", valid_568739
  var valid_568740 = path.getOrDefault("queueName")
  valid_568740 = validateParameter(valid_568740, JString, required = true,
                                 default = nil)
  if valid_568740 != nil:
    section.add "queueName", valid_568740
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568741 = query.getOrDefault("api-version")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "api-version", valid_568741
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

proc call*(call_568743: Call_QueuesCreateOrUpdateAuthorizationRule_568733;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an authorization rule for a queue.
  ## 
  let valid = call_568743.validator(path, query, header, formData, body)
  let scheme = call_568743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568743.url(scheme.get, call_568743.host, call_568743.base,
                         call_568743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568743, url, valid)

proc call*(call_568744: Call_QueuesCreateOrUpdateAuthorizationRule_568733;
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
  var path_568745 = newJObject()
  var query_568746 = newJObject()
  var body_568747 = newJObject()
  add(path_568745, "namespaceName", newJString(namespaceName))
  add(path_568745, "resourceGroupName", newJString(resourceGroupName))
  add(query_568746, "api-version", newJString(apiVersion))
  add(path_568745, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568745, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568747 = parameters
  add(path_568745, "queueName", newJString(queueName))
  result = call_568744.call(path_568745, query_568746, nil, nil, body_568747)

var queuesCreateOrUpdateAuthorizationRule* = Call_QueuesCreateOrUpdateAuthorizationRule_568733(
    name: "queuesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}",
    validator: validate_QueuesCreateOrUpdateAuthorizationRule_568734, base: "",
    url: url_QueuesCreateOrUpdateAuthorizationRule_568735, schemes: {Scheme.Https})
type
  Call_QueuesGetAuthorizationRule_568720 = ref object of OpenApiRestCall_567666
proc url_QueuesGetAuthorizationRule_568722(protocol: Scheme; host: string;
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

proc validate_QueuesGetAuthorizationRule_568721(path: JsonNode; query: JsonNode;
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
  var valid_568723 = path.getOrDefault("namespaceName")
  valid_568723 = validateParameter(valid_568723, JString, required = true,
                                 default = nil)
  if valid_568723 != nil:
    section.add "namespaceName", valid_568723
  var valid_568724 = path.getOrDefault("resourceGroupName")
  valid_568724 = validateParameter(valid_568724, JString, required = true,
                                 default = nil)
  if valid_568724 != nil:
    section.add "resourceGroupName", valid_568724
  var valid_568725 = path.getOrDefault("authorizationRuleName")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = nil)
  if valid_568725 != nil:
    section.add "authorizationRuleName", valid_568725
  var valid_568726 = path.getOrDefault("subscriptionId")
  valid_568726 = validateParameter(valid_568726, JString, required = true,
                                 default = nil)
  if valid_568726 != nil:
    section.add "subscriptionId", valid_568726
  var valid_568727 = path.getOrDefault("queueName")
  valid_568727 = validateParameter(valid_568727, JString, required = true,
                                 default = nil)
  if valid_568727 != nil:
    section.add "queueName", valid_568727
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568728 = query.getOrDefault("api-version")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "api-version", valid_568728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568729: Call_QueuesGetAuthorizationRule_568720; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an authorization rule for a queue by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705611.aspx
  let valid = call_568729.validator(path, query, header, formData, body)
  let scheme = call_568729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568729.url(scheme.get, call_568729.host, call_568729.base,
                         call_568729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568729, url, valid)

proc call*(call_568730: Call_QueuesGetAuthorizationRule_568720;
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
  var path_568731 = newJObject()
  var query_568732 = newJObject()
  add(path_568731, "namespaceName", newJString(namespaceName))
  add(path_568731, "resourceGroupName", newJString(resourceGroupName))
  add(query_568732, "api-version", newJString(apiVersion))
  add(path_568731, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568731, "subscriptionId", newJString(subscriptionId))
  add(path_568731, "queueName", newJString(queueName))
  result = call_568730.call(path_568731, query_568732, nil, nil, nil)

var queuesGetAuthorizationRule* = Call_QueuesGetAuthorizationRule_568720(
    name: "queuesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}",
    validator: validate_QueuesGetAuthorizationRule_568721, base: "",
    url: url_QueuesGetAuthorizationRule_568722, schemes: {Scheme.Https})
type
  Call_QueuesDeleteAuthorizationRule_568748 = ref object of OpenApiRestCall_567666
proc url_QueuesDeleteAuthorizationRule_568750(protocol: Scheme; host: string;
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

proc validate_QueuesDeleteAuthorizationRule_568749(path: JsonNode; query: JsonNode;
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
  var valid_568751 = path.getOrDefault("namespaceName")
  valid_568751 = validateParameter(valid_568751, JString, required = true,
                                 default = nil)
  if valid_568751 != nil:
    section.add "namespaceName", valid_568751
  var valid_568752 = path.getOrDefault("resourceGroupName")
  valid_568752 = validateParameter(valid_568752, JString, required = true,
                                 default = nil)
  if valid_568752 != nil:
    section.add "resourceGroupName", valid_568752
  var valid_568753 = path.getOrDefault("authorizationRuleName")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = nil)
  if valid_568753 != nil:
    section.add "authorizationRuleName", valid_568753
  var valid_568754 = path.getOrDefault("subscriptionId")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "subscriptionId", valid_568754
  var valid_568755 = path.getOrDefault("queueName")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = nil)
  if valid_568755 != nil:
    section.add "queueName", valid_568755
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568756 = query.getOrDefault("api-version")
  valid_568756 = validateParameter(valid_568756, JString, required = true,
                                 default = nil)
  if valid_568756 != nil:
    section.add "api-version", valid_568756
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568757: Call_QueuesDeleteAuthorizationRule_568748; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a queue authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705609.aspx
  let valid = call_568757.validator(path, query, header, formData, body)
  let scheme = call_568757.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568757.url(scheme.get, call_568757.host, call_568757.base,
                         call_568757.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568757, url, valid)

proc call*(call_568758: Call_QueuesDeleteAuthorizationRule_568748;
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
  var path_568759 = newJObject()
  var query_568760 = newJObject()
  add(path_568759, "namespaceName", newJString(namespaceName))
  add(path_568759, "resourceGroupName", newJString(resourceGroupName))
  add(query_568760, "api-version", newJString(apiVersion))
  add(path_568759, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568759, "subscriptionId", newJString(subscriptionId))
  add(path_568759, "queueName", newJString(queueName))
  result = call_568758.call(path_568759, query_568760, nil, nil, nil)

var queuesDeleteAuthorizationRule* = Call_QueuesDeleteAuthorizationRule_568748(
    name: "queuesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}",
    validator: validate_QueuesDeleteAuthorizationRule_568749, base: "",
    url: url_QueuesDeleteAuthorizationRule_568750, schemes: {Scheme.Https})
type
  Call_QueuesListKeys_568761 = ref object of OpenApiRestCall_567666
proc url_QueuesListKeys_568763(protocol: Scheme; host: string; base: string;
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

proc validate_QueuesListKeys_568762(path: JsonNode; query: JsonNode;
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
  var valid_568764 = path.getOrDefault("namespaceName")
  valid_568764 = validateParameter(valid_568764, JString, required = true,
                                 default = nil)
  if valid_568764 != nil:
    section.add "namespaceName", valid_568764
  var valid_568765 = path.getOrDefault("resourceGroupName")
  valid_568765 = validateParameter(valid_568765, JString, required = true,
                                 default = nil)
  if valid_568765 != nil:
    section.add "resourceGroupName", valid_568765
  var valid_568766 = path.getOrDefault("authorizationRuleName")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "authorizationRuleName", valid_568766
  var valid_568767 = path.getOrDefault("subscriptionId")
  valid_568767 = validateParameter(valid_568767, JString, required = true,
                                 default = nil)
  if valid_568767 != nil:
    section.add "subscriptionId", valid_568767
  var valid_568768 = path.getOrDefault("queueName")
  valid_568768 = validateParameter(valid_568768, JString, required = true,
                                 default = nil)
  if valid_568768 != nil:
    section.add "queueName", valid_568768
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568769 = query.getOrDefault("api-version")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "api-version", valid_568769
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568770: Call_QueuesListKeys_568761; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Primary and secondary connection strings to the queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705608.aspx
  let valid = call_568770.validator(path, query, header, formData, body)
  let scheme = call_568770.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568770.url(scheme.get, call_568770.host, call_568770.base,
                         call_568770.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568770, url, valid)

proc call*(call_568771: Call_QueuesListKeys_568761; namespaceName: string;
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
  var path_568772 = newJObject()
  var query_568773 = newJObject()
  add(path_568772, "namespaceName", newJString(namespaceName))
  add(path_568772, "resourceGroupName", newJString(resourceGroupName))
  add(query_568773, "api-version", newJString(apiVersion))
  add(path_568772, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568772, "subscriptionId", newJString(subscriptionId))
  add(path_568772, "queueName", newJString(queueName))
  result = call_568771.call(path_568772, query_568773, nil, nil, nil)

var queuesListKeys* = Call_QueuesListKeys_568761(name: "queuesListKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}/ListKeys",
    validator: validate_QueuesListKeys_568762, base: "", url: url_QueuesListKeys_568763,
    schemes: {Scheme.Https})
type
  Call_QueuesRegenerateKeys_568774 = ref object of OpenApiRestCall_567666
proc url_QueuesRegenerateKeys_568776(protocol: Scheme; host: string; base: string;
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

proc validate_QueuesRegenerateKeys_568775(path: JsonNode; query: JsonNode;
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
  var valid_568777 = path.getOrDefault("namespaceName")
  valid_568777 = validateParameter(valid_568777, JString, required = true,
                                 default = nil)
  if valid_568777 != nil:
    section.add "namespaceName", valid_568777
  var valid_568778 = path.getOrDefault("resourceGroupName")
  valid_568778 = validateParameter(valid_568778, JString, required = true,
                                 default = nil)
  if valid_568778 != nil:
    section.add "resourceGroupName", valid_568778
  var valid_568779 = path.getOrDefault("authorizationRuleName")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "authorizationRuleName", valid_568779
  var valid_568780 = path.getOrDefault("subscriptionId")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "subscriptionId", valid_568780
  var valid_568781 = path.getOrDefault("queueName")
  valid_568781 = validateParameter(valid_568781, JString, required = true,
                                 default = nil)
  if valid_568781 != nil:
    section.add "queueName", valid_568781
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568782 = query.getOrDefault("api-version")
  valid_568782 = validateParameter(valid_568782, JString, required = true,
                                 default = nil)
  if valid_568782 != nil:
    section.add "api-version", valid_568782
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

proc call*(call_568784: Call_QueuesRegenerateKeys_568774; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the primary or secondary connection strings to the queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705606.aspx
  let valid = call_568784.validator(path, query, header, formData, body)
  let scheme = call_568784.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568784.url(scheme.get, call_568784.host, call_568784.base,
                         call_568784.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568784, url, valid)

proc call*(call_568785: Call_QueuesRegenerateKeys_568774; namespaceName: string;
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
  var path_568786 = newJObject()
  var query_568787 = newJObject()
  var body_568788 = newJObject()
  add(path_568786, "namespaceName", newJString(namespaceName))
  add(path_568786, "resourceGroupName", newJString(resourceGroupName))
  add(query_568787, "api-version", newJString(apiVersion))
  add(path_568786, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568786, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568788 = parameters
  add(path_568786, "queueName", newJString(queueName))
  result = call_568785.call(path_568786, query_568787, nil, nil, body_568788)

var queuesRegenerateKeys* = Call_QueuesRegenerateKeys_568774(
    name: "queuesRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_QueuesRegenerateKeys_568775, base: "",
    url: url_QueuesRegenerateKeys_568776, schemes: {Scheme.Https})
type
  Call_TopicsListByNamespace_568789 = ref object of OpenApiRestCall_567666
proc url_TopicsListByNamespace_568791(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsListByNamespace_568790(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_568792 = path.getOrDefault("namespaceName")
  valid_568792 = validateParameter(valid_568792, JString, required = true,
                                 default = nil)
  if valid_568792 != nil:
    section.add "namespaceName", valid_568792
  var valid_568793 = path.getOrDefault("resourceGroupName")
  valid_568793 = validateParameter(valid_568793, JString, required = true,
                                 default = nil)
  if valid_568793 != nil:
    section.add "resourceGroupName", valid_568793
  var valid_568794 = path.getOrDefault("subscriptionId")
  valid_568794 = validateParameter(valid_568794, JString, required = true,
                                 default = nil)
  if valid_568794 != nil:
    section.add "subscriptionId", valid_568794
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skip: JInt
  ##        : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568795 = query.getOrDefault("api-version")
  valid_568795 = validateParameter(valid_568795, JString, required = true,
                                 default = nil)
  if valid_568795 != nil:
    section.add "api-version", valid_568795
  var valid_568796 = query.getOrDefault("$top")
  valid_568796 = validateParameter(valid_568796, JInt, required = false, default = nil)
  if valid_568796 != nil:
    section.add "$top", valid_568796
  var valid_568797 = query.getOrDefault("$skip")
  valid_568797 = validateParameter(valid_568797, JInt, required = false, default = nil)
  if valid_568797 != nil:
    section.add "$skip", valid_568797
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568798: Call_TopicsListByNamespace_568789; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the topics in a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639388.aspx
  let valid = call_568798.validator(path, query, header, formData, body)
  let scheme = call_568798.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568798.url(scheme.get, call_568798.host, call_568798.base,
                         call_568798.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568798, url, valid)

proc call*(call_568799: Call_TopicsListByNamespace_568789; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Skip: int = 0): Recallable =
  ## topicsListByNamespace
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
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skip: int
  ##       : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  var path_568800 = newJObject()
  var query_568801 = newJObject()
  add(path_568800, "namespaceName", newJString(namespaceName))
  add(path_568800, "resourceGroupName", newJString(resourceGroupName))
  add(query_568801, "api-version", newJString(apiVersion))
  add(path_568800, "subscriptionId", newJString(subscriptionId))
  add(query_568801, "$top", newJInt(Top))
  add(query_568801, "$skip", newJInt(Skip))
  result = call_568799.call(path_568800, query_568801, nil, nil, nil)

var topicsListByNamespace* = Call_TopicsListByNamespace_568789(
    name: "topicsListByNamespace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics",
    validator: validate_TopicsListByNamespace_568790, base: "",
    url: url_TopicsListByNamespace_568791, schemes: {Scheme.Https})
type
  Call_TopicsCreateOrUpdate_568814 = ref object of OpenApiRestCall_567666
proc url_TopicsCreateOrUpdate_568816(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsCreateOrUpdate_568815(path: JsonNode; query: JsonNode;
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
  var valid_568817 = path.getOrDefault("namespaceName")
  valid_568817 = validateParameter(valid_568817, JString, required = true,
                                 default = nil)
  if valid_568817 != nil:
    section.add "namespaceName", valid_568817
  var valid_568818 = path.getOrDefault("resourceGroupName")
  valid_568818 = validateParameter(valid_568818, JString, required = true,
                                 default = nil)
  if valid_568818 != nil:
    section.add "resourceGroupName", valid_568818
  var valid_568819 = path.getOrDefault("topicName")
  valid_568819 = validateParameter(valid_568819, JString, required = true,
                                 default = nil)
  if valid_568819 != nil:
    section.add "topicName", valid_568819
  var valid_568820 = path.getOrDefault("subscriptionId")
  valid_568820 = validateParameter(valid_568820, JString, required = true,
                                 default = nil)
  if valid_568820 != nil:
    section.add "subscriptionId", valid_568820
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568821 = query.getOrDefault("api-version")
  valid_568821 = validateParameter(valid_568821, JString, required = true,
                                 default = nil)
  if valid_568821 != nil:
    section.add "api-version", valid_568821
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

proc call*(call_568823: Call_TopicsCreateOrUpdate_568814; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a topic in the specified namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639409.aspx
  let valid = call_568823.validator(path, query, header, formData, body)
  let scheme = call_568823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568823.url(scheme.get, call_568823.host, call_568823.base,
                         call_568823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568823, url, valid)

proc call*(call_568824: Call_TopicsCreateOrUpdate_568814; namespaceName: string;
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
  var path_568825 = newJObject()
  var query_568826 = newJObject()
  var body_568827 = newJObject()
  add(path_568825, "namespaceName", newJString(namespaceName))
  add(path_568825, "resourceGroupName", newJString(resourceGroupName))
  add(query_568826, "api-version", newJString(apiVersion))
  add(path_568825, "topicName", newJString(topicName))
  add(path_568825, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568827 = parameters
  result = call_568824.call(path_568825, query_568826, nil, nil, body_568827)

var topicsCreateOrUpdate* = Call_TopicsCreateOrUpdate_568814(
    name: "topicsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}",
    validator: validate_TopicsCreateOrUpdate_568815, base: "",
    url: url_TopicsCreateOrUpdate_568816, schemes: {Scheme.Https})
type
  Call_TopicsGet_568802 = ref object of OpenApiRestCall_567666
proc url_TopicsGet_568804(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TopicsGet_568803(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568805 = path.getOrDefault("namespaceName")
  valid_568805 = validateParameter(valid_568805, JString, required = true,
                                 default = nil)
  if valid_568805 != nil:
    section.add "namespaceName", valid_568805
  var valid_568806 = path.getOrDefault("resourceGroupName")
  valid_568806 = validateParameter(valid_568806, JString, required = true,
                                 default = nil)
  if valid_568806 != nil:
    section.add "resourceGroupName", valid_568806
  var valid_568807 = path.getOrDefault("topicName")
  valid_568807 = validateParameter(valid_568807, JString, required = true,
                                 default = nil)
  if valid_568807 != nil:
    section.add "topicName", valid_568807
  var valid_568808 = path.getOrDefault("subscriptionId")
  valid_568808 = validateParameter(valid_568808, JString, required = true,
                                 default = nil)
  if valid_568808 != nil:
    section.add "subscriptionId", valid_568808
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568809 = query.getOrDefault("api-version")
  valid_568809 = validateParameter(valid_568809, JString, required = true,
                                 default = nil)
  if valid_568809 != nil:
    section.add "api-version", valid_568809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568810: Call_TopicsGet_568802; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a description for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639399.aspx
  let valid = call_568810.validator(path, query, header, formData, body)
  let scheme = call_568810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568810.url(scheme.get, call_568810.host, call_568810.base,
                         call_568810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568810, url, valid)

proc call*(call_568811: Call_TopicsGet_568802; namespaceName: string;
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
  var path_568812 = newJObject()
  var query_568813 = newJObject()
  add(path_568812, "namespaceName", newJString(namespaceName))
  add(path_568812, "resourceGroupName", newJString(resourceGroupName))
  add(query_568813, "api-version", newJString(apiVersion))
  add(path_568812, "topicName", newJString(topicName))
  add(path_568812, "subscriptionId", newJString(subscriptionId))
  result = call_568811.call(path_568812, query_568813, nil, nil, nil)

var topicsGet* = Call_TopicsGet_568802(name: "topicsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}",
                                    validator: validate_TopicsGet_568803,
                                    base: "", url: url_TopicsGet_568804,
                                    schemes: {Scheme.Https})
type
  Call_TopicsDelete_568828 = ref object of OpenApiRestCall_567666
proc url_TopicsDelete_568830(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsDelete_568829(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568831 = path.getOrDefault("namespaceName")
  valid_568831 = validateParameter(valid_568831, JString, required = true,
                                 default = nil)
  if valid_568831 != nil:
    section.add "namespaceName", valid_568831
  var valid_568832 = path.getOrDefault("resourceGroupName")
  valid_568832 = validateParameter(valid_568832, JString, required = true,
                                 default = nil)
  if valid_568832 != nil:
    section.add "resourceGroupName", valid_568832
  var valid_568833 = path.getOrDefault("topicName")
  valid_568833 = validateParameter(valid_568833, JString, required = true,
                                 default = nil)
  if valid_568833 != nil:
    section.add "topicName", valid_568833
  var valid_568834 = path.getOrDefault("subscriptionId")
  valid_568834 = validateParameter(valid_568834, JString, required = true,
                                 default = nil)
  if valid_568834 != nil:
    section.add "subscriptionId", valid_568834
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568835 = query.getOrDefault("api-version")
  valid_568835 = validateParameter(valid_568835, JString, required = true,
                                 default = nil)
  if valid_568835 != nil:
    section.add "api-version", valid_568835
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568836: Call_TopicsDelete_568828; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a topic from the specified namespace and resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639404.aspx
  let valid = call_568836.validator(path, query, header, formData, body)
  let scheme = call_568836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568836.url(scheme.get, call_568836.host, call_568836.base,
                         call_568836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568836, url, valid)

proc call*(call_568837: Call_TopicsDelete_568828; namespaceName: string;
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
  var path_568838 = newJObject()
  var query_568839 = newJObject()
  add(path_568838, "namespaceName", newJString(namespaceName))
  add(path_568838, "resourceGroupName", newJString(resourceGroupName))
  add(query_568839, "api-version", newJString(apiVersion))
  add(path_568838, "topicName", newJString(topicName))
  add(path_568838, "subscriptionId", newJString(subscriptionId))
  result = call_568837.call(path_568838, query_568839, nil, nil, nil)

var topicsDelete* = Call_TopicsDelete_568828(name: "topicsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}",
    validator: validate_TopicsDelete_568829, base: "", url: url_TopicsDelete_568830,
    schemes: {Scheme.Https})
type
  Call_TopicsListAuthorizationRules_568840 = ref object of OpenApiRestCall_567666
proc url_TopicsListAuthorizationRules_568842(protocol: Scheme; host: string;
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

proc validate_TopicsListAuthorizationRules_568841(path: JsonNode; query: JsonNode;
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
  var valid_568843 = path.getOrDefault("namespaceName")
  valid_568843 = validateParameter(valid_568843, JString, required = true,
                                 default = nil)
  if valid_568843 != nil:
    section.add "namespaceName", valid_568843
  var valid_568844 = path.getOrDefault("resourceGroupName")
  valid_568844 = validateParameter(valid_568844, JString, required = true,
                                 default = nil)
  if valid_568844 != nil:
    section.add "resourceGroupName", valid_568844
  var valid_568845 = path.getOrDefault("topicName")
  valid_568845 = validateParameter(valid_568845, JString, required = true,
                                 default = nil)
  if valid_568845 != nil:
    section.add "topicName", valid_568845
  var valid_568846 = path.getOrDefault("subscriptionId")
  valid_568846 = validateParameter(valid_568846, JString, required = true,
                                 default = nil)
  if valid_568846 != nil:
    section.add "subscriptionId", valid_568846
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568847 = query.getOrDefault("api-version")
  valid_568847 = validateParameter(valid_568847, JString, required = true,
                                 default = nil)
  if valid_568847 != nil:
    section.add "api-version", valid_568847
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568848: Call_TopicsListAuthorizationRules_568840; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets authorization rules for a topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720681.aspx
  let valid = call_568848.validator(path, query, header, formData, body)
  let scheme = call_568848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568848.url(scheme.get, call_568848.host, call_568848.base,
                         call_568848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568848, url, valid)

proc call*(call_568849: Call_TopicsListAuthorizationRules_568840;
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
  var path_568850 = newJObject()
  var query_568851 = newJObject()
  add(path_568850, "namespaceName", newJString(namespaceName))
  add(path_568850, "resourceGroupName", newJString(resourceGroupName))
  add(query_568851, "api-version", newJString(apiVersion))
  add(path_568850, "topicName", newJString(topicName))
  add(path_568850, "subscriptionId", newJString(subscriptionId))
  result = call_568849.call(path_568850, query_568851, nil, nil, nil)

var topicsListAuthorizationRules* = Call_TopicsListAuthorizationRules_568840(
    name: "topicsListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules",
    validator: validate_TopicsListAuthorizationRules_568841, base: "",
    url: url_TopicsListAuthorizationRules_568842, schemes: {Scheme.Https})
type
  Call_TopicsCreateOrUpdateAuthorizationRule_568865 = ref object of OpenApiRestCall_567666
proc url_TopicsCreateOrUpdateAuthorizationRule_568867(protocol: Scheme;
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

proc validate_TopicsCreateOrUpdateAuthorizationRule_568866(path: JsonNode;
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
  var valid_568868 = path.getOrDefault("namespaceName")
  valid_568868 = validateParameter(valid_568868, JString, required = true,
                                 default = nil)
  if valid_568868 != nil:
    section.add "namespaceName", valid_568868
  var valid_568869 = path.getOrDefault("resourceGroupName")
  valid_568869 = validateParameter(valid_568869, JString, required = true,
                                 default = nil)
  if valid_568869 != nil:
    section.add "resourceGroupName", valid_568869
  var valid_568870 = path.getOrDefault("topicName")
  valid_568870 = validateParameter(valid_568870, JString, required = true,
                                 default = nil)
  if valid_568870 != nil:
    section.add "topicName", valid_568870
  var valid_568871 = path.getOrDefault("authorizationRuleName")
  valid_568871 = validateParameter(valid_568871, JString, required = true,
                                 default = nil)
  if valid_568871 != nil:
    section.add "authorizationRuleName", valid_568871
  var valid_568872 = path.getOrDefault("subscriptionId")
  valid_568872 = validateParameter(valid_568872, JString, required = true,
                                 default = nil)
  if valid_568872 != nil:
    section.add "subscriptionId", valid_568872
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568873 = query.getOrDefault("api-version")
  valid_568873 = validateParameter(valid_568873, JString, required = true,
                                 default = nil)
  if valid_568873 != nil:
    section.add "api-version", valid_568873
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

proc call*(call_568875: Call_TopicsCreateOrUpdateAuthorizationRule_568865;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an authorization rule for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720678.aspx
  let valid = call_568875.validator(path, query, header, formData, body)
  let scheme = call_568875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568875.url(scheme.get, call_568875.host, call_568875.base,
                         call_568875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568875, url, valid)

proc call*(call_568876: Call_TopicsCreateOrUpdateAuthorizationRule_568865;
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
  var path_568877 = newJObject()
  var query_568878 = newJObject()
  var body_568879 = newJObject()
  add(path_568877, "namespaceName", newJString(namespaceName))
  add(path_568877, "resourceGroupName", newJString(resourceGroupName))
  add(query_568878, "api-version", newJString(apiVersion))
  add(path_568877, "topicName", newJString(topicName))
  add(path_568877, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568877, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568879 = parameters
  result = call_568876.call(path_568877, query_568878, nil, nil, body_568879)

var topicsCreateOrUpdateAuthorizationRule* = Call_TopicsCreateOrUpdateAuthorizationRule_568865(
    name: "topicsCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}",
    validator: validate_TopicsCreateOrUpdateAuthorizationRule_568866, base: "",
    url: url_TopicsCreateOrUpdateAuthorizationRule_568867, schemes: {Scheme.Https})
type
  Call_TopicsGetAuthorizationRule_568852 = ref object of OpenApiRestCall_567666
proc url_TopicsGetAuthorizationRule_568854(protocol: Scheme; host: string;
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

proc validate_TopicsGetAuthorizationRule_568853(path: JsonNode; query: JsonNode;
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
  var valid_568855 = path.getOrDefault("namespaceName")
  valid_568855 = validateParameter(valid_568855, JString, required = true,
                                 default = nil)
  if valid_568855 != nil:
    section.add "namespaceName", valid_568855
  var valid_568856 = path.getOrDefault("resourceGroupName")
  valid_568856 = validateParameter(valid_568856, JString, required = true,
                                 default = nil)
  if valid_568856 != nil:
    section.add "resourceGroupName", valid_568856
  var valid_568857 = path.getOrDefault("topicName")
  valid_568857 = validateParameter(valid_568857, JString, required = true,
                                 default = nil)
  if valid_568857 != nil:
    section.add "topicName", valid_568857
  var valid_568858 = path.getOrDefault("authorizationRuleName")
  valid_568858 = validateParameter(valid_568858, JString, required = true,
                                 default = nil)
  if valid_568858 != nil:
    section.add "authorizationRuleName", valid_568858
  var valid_568859 = path.getOrDefault("subscriptionId")
  valid_568859 = validateParameter(valid_568859, JString, required = true,
                                 default = nil)
  if valid_568859 != nil:
    section.add "subscriptionId", valid_568859
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568860 = query.getOrDefault("api-version")
  valid_568860 = validateParameter(valid_568860, JString, required = true,
                                 default = nil)
  if valid_568860 != nil:
    section.add "api-version", valid_568860
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568861: Call_TopicsGetAuthorizationRule_568852; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720676.aspx
  let valid = call_568861.validator(path, query, header, formData, body)
  let scheme = call_568861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568861.url(scheme.get, call_568861.host, call_568861.base,
                         call_568861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568861, url, valid)

proc call*(call_568862: Call_TopicsGetAuthorizationRule_568852;
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
  var path_568863 = newJObject()
  var query_568864 = newJObject()
  add(path_568863, "namespaceName", newJString(namespaceName))
  add(path_568863, "resourceGroupName", newJString(resourceGroupName))
  add(query_568864, "api-version", newJString(apiVersion))
  add(path_568863, "topicName", newJString(topicName))
  add(path_568863, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568863, "subscriptionId", newJString(subscriptionId))
  result = call_568862.call(path_568863, query_568864, nil, nil, nil)

var topicsGetAuthorizationRule* = Call_TopicsGetAuthorizationRule_568852(
    name: "topicsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}",
    validator: validate_TopicsGetAuthorizationRule_568853, base: "",
    url: url_TopicsGetAuthorizationRule_568854, schemes: {Scheme.Https})
type
  Call_TopicsDeleteAuthorizationRule_568880 = ref object of OpenApiRestCall_567666
proc url_TopicsDeleteAuthorizationRule_568882(protocol: Scheme; host: string;
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

proc validate_TopicsDeleteAuthorizationRule_568881(path: JsonNode; query: JsonNode;
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
  var valid_568883 = path.getOrDefault("namespaceName")
  valid_568883 = validateParameter(valid_568883, JString, required = true,
                                 default = nil)
  if valid_568883 != nil:
    section.add "namespaceName", valid_568883
  var valid_568884 = path.getOrDefault("resourceGroupName")
  valid_568884 = validateParameter(valid_568884, JString, required = true,
                                 default = nil)
  if valid_568884 != nil:
    section.add "resourceGroupName", valid_568884
  var valid_568885 = path.getOrDefault("topicName")
  valid_568885 = validateParameter(valid_568885, JString, required = true,
                                 default = nil)
  if valid_568885 != nil:
    section.add "topicName", valid_568885
  var valid_568886 = path.getOrDefault("authorizationRuleName")
  valid_568886 = validateParameter(valid_568886, JString, required = true,
                                 default = nil)
  if valid_568886 != nil:
    section.add "authorizationRuleName", valid_568886
  var valid_568887 = path.getOrDefault("subscriptionId")
  valid_568887 = validateParameter(valid_568887, JString, required = true,
                                 default = nil)
  if valid_568887 != nil:
    section.add "subscriptionId", valid_568887
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568888 = query.getOrDefault("api-version")
  valid_568888 = validateParameter(valid_568888, JString, required = true,
                                 default = nil)
  if valid_568888 != nil:
    section.add "api-version", valid_568888
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568889: Call_TopicsDeleteAuthorizationRule_568880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a topic authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720681.aspx
  let valid = call_568889.validator(path, query, header, formData, body)
  let scheme = call_568889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568889.url(scheme.get, call_568889.host, call_568889.base,
                         call_568889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568889, url, valid)

proc call*(call_568890: Call_TopicsDeleteAuthorizationRule_568880;
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
  var path_568891 = newJObject()
  var query_568892 = newJObject()
  add(path_568891, "namespaceName", newJString(namespaceName))
  add(path_568891, "resourceGroupName", newJString(resourceGroupName))
  add(query_568892, "api-version", newJString(apiVersion))
  add(path_568891, "topicName", newJString(topicName))
  add(path_568891, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568891, "subscriptionId", newJString(subscriptionId))
  result = call_568890.call(path_568891, query_568892, nil, nil, nil)

var topicsDeleteAuthorizationRule* = Call_TopicsDeleteAuthorizationRule_568880(
    name: "topicsDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}",
    validator: validate_TopicsDeleteAuthorizationRule_568881, base: "",
    url: url_TopicsDeleteAuthorizationRule_568882, schemes: {Scheme.Https})
type
  Call_TopicsListKeys_568893 = ref object of OpenApiRestCall_567666
proc url_TopicsListKeys_568895(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsListKeys_568894(path: JsonNode; query: JsonNode;
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
  var valid_568896 = path.getOrDefault("namespaceName")
  valid_568896 = validateParameter(valid_568896, JString, required = true,
                                 default = nil)
  if valid_568896 != nil:
    section.add "namespaceName", valid_568896
  var valid_568897 = path.getOrDefault("resourceGroupName")
  valid_568897 = validateParameter(valid_568897, JString, required = true,
                                 default = nil)
  if valid_568897 != nil:
    section.add "resourceGroupName", valid_568897
  var valid_568898 = path.getOrDefault("topicName")
  valid_568898 = validateParameter(valid_568898, JString, required = true,
                                 default = nil)
  if valid_568898 != nil:
    section.add "topicName", valid_568898
  var valid_568899 = path.getOrDefault("authorizationRuleName")
  valid_568899 = validateParameter(valid_568899, JString, required = true,
                                 default = nil)
  if valid_568899 != nil:
    section.add "authorizationRuleName", valid_568899
  var valid_568900 = path.getOrDefault("subscriptionId")
  valid_568900 = validateParameter(valid_568900, JString, required = true,
                                 default = nil)
  if valid_568900 != nil:
    section.add "subscriptionId", valid_568900
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568901 = query.getOrDefault("api-version")
  valid_568901 = validateParameter(valid_568901, JString, required = true,
                                 default = nil)
  if valid_568901 != nil:
    section.add "api-version", valid_568901
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568902: Call_TopicsListKeys_568893; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the primary and secondary connection strings for the topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720677.aspx
  let valid = call_568902.validator(path, query, header, formData, body)
  let scheme = call_568902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568902.url(scheme.get, call_568902.host, call_568902.base,
                         call_568902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568902, url, valid)

proc call*(call_568903: Call_TopicsListKeys_568893; namespaceName: string;
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
  var path_568904 = newJObject()
  var query_568905 = newJObject()
  add(path_568904, "namespaceName", newJString(namespaceName))
  add(path_568904, "resourceGroupName", newJString(resourceGroupName))
  add(query_568905, "api-version", newJString(apiVersion))
  add(path_568904, "topicName", newJString(topicName))
  add(path_568904, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568904, "subscriptionId", newJString(subscriptionId))
  result = call_568903.call(path_568904, query_568905, nil, nil, nil)

var topicsListKeys* = Call_TopicsListKeys_568893(name: "topicsListKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}/ListKeys",
    validator: validate_TopicsListKeys_568894, base: "", url: url_TopicsListKeys_568895,
    schemes: {Scheme.Https})
type
  Call_TopicsRegenerateKeys_568906 = ref object of OpenApiRestCall_567666
proc url_TopicsRegenerateKeys_568908(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsRegenerateKeys_568907(path: JsonNode; query: JsonNode;
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
  var valid_568909 = path.getOrDefault("namespaceName")
  valid_568909 = validateParameter(valid_568909, JString, required = true,
                                 default = nil)
  if valid_568909 != nil:
    section.add "namespaceName", valid_568909
  var valid_568910 = path.getOrDefault("resourceGroupName")
  valid_568910 = validateParameter(valid_568910, JString, required = true,
                                 default = nil)
  if valid_568910 != nil:
    section.add "resourceGroupName", valid_568910
  var valid_568911 = path.getOrDefault("topicName")
  valid_568911 = validateParameter(valid_568911, JString, required = true,
                                 default = nil)
  if valid_568911 != nil:
    section.add "topicName", valid_568911
  var valid_568912 = path.getOrDefault("authorizationRuleName")
  valid_568912 = validateParameter(valid_568912, JString, required = true,
                                 default = nil)
  if valid_568912 != nil:
    section.add "authorizationRuleName", valid_568912
  var valid_568913 = path.getOrDefault("subscriptionId")
  valid_568913 = validateParameter(valid_568913, JString, required = true,
                                 default = nil)
  if valid_568913 != nil:
    section.add "subscriptionId", valid_568913
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568914 = query.getOrDefault("api-version")
  valid_568914 = validateParameter(valid_568914, JString, required = true,
                                 default = nil)
  if valid_568914 != nil:
    section.add "api-version", valid_568914
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

proc call*(call_568916: Call_TopicsRegenerateKeys_568906; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates primary or secondary connection strings for the topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720679.aspx
  let valid = call_568916.validator(path, query, header, formData, body)
  let scheme = call_568916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568916.url(scheme.get, call_568916.host, call_568916.base,
                         call_568916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568916, url, valid)

proc call*(call_568917: Call_TopicsRegenerateKeys_568906; namespaceName: string;
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
  var path_568918 = newJObject()
  var query_568919 = newJObject()
  var body_568920 = newJObject()
  add(path_568918, "namespaceName", newJString(namespaceName))
  add(path_568918, "resourceGroupName", newJString(resourceGroupName))
  add(query_568919, "api-version", newJString(apiVersion))
  add(path_568918, "topicName", newJString(topicName))
  add(path_568918, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568918, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568920 = parameters
  result = call_568917.call(path_568918, query_568919, nil, nil, body_568920)

var topicsRegenerateKeys* = Call_TopicsRegenerateKeys_568906(
    name: "topicsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_TopicsRegenerateKeys_568907, base: "",
    url: url_TopicsRegenerateKeys_568908, schemes: {Scheme.Https})
type
  Call_SubscriptionsListByTopic_568921 = ref object of OpenApiRestCall_567666
proc url_SubscriptionsListByTopic_568923(protocol: Scheme; host: string;
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

proc validate_SubscriptionsListByTopic_568922(path: JsonNode; query: JsonNode;
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
  var valid_568924 = path.getOrDefault("namespaceName")
  valid_568924 = validateParameter(valid_568924, JString, required = true,
                                 default = nil)
  if valid_568924 != nil:
    section.add "namespaceName", valid_568924
  var valid_568925 = path.getOrDefault("resourceGroupName")
  valid_568925 = validateParameter(valid_568925, JString, required = true,
                                 default = nil)
  if valid_568925 != nil:
    section.add "resourceGroupName", valid_568925
  var valid_568926 = path.getOrDefault("topicName")
  valid_568926 = validateParameter(valid_568926, JString, required = true,
                                 default = nil)
  if valid_568926 != nil:
    section.add "topicName", valid_568926
  var valid_568927 = path.getOrDefault("subscriptionId")
  valid_568927 = validateParameter(valid_568927, JString, required = true,
                                 default = nil)
  if valid_568927 != nil:
    section.add "subscriptionId", valid_568927
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skip: JInt
  ##        : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568928 = query.getOrDefault("api-version")
  valid_568928 = validateParameter(valid_568928, JString, required = true,
                                 default = nil)
  if valid_568928 != nil:
    section.add "api-version", valid_568928
  var valid_568929 = query.getOrDefault("$top")
  valid_568929 = validateParameter(valid_568929, JInt, required = false, default = nil)
  if valid_568929 != nil:
    section.add "$top", valid_568929
  var valid_568930 = query.getOrDefault("$skip")
  valid_568930 = validateParameter(valid_568930, JInt, required = false, default = nil)
  if valid_568930 != nil:
    section.add "$skip", valid_568930
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568931: Call_SubscriptionsListByTopic_568921; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the subscriptions under a specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639400.aspx
  let valid = call_568931.validator(path, query, header, formData, body)
  let scheme = call_568931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568931.url(scheme.get, call_568931.host, call_568931.base,
                         call_568931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568931, url, valid)

proc call*(call_568932: Call_SubscriptionsListByTopic_568921;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          topicName: string; subscriptionId: string; Top: int = 0; Skip: int = 0): Recallable =
  ## subscriptionsListByTopic
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
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skip: int
  ##       : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  var path_568933 = newJObject()
  var query_568934 = newJObject()
  add(path_568933, "namespaceName", newJString(namespaceName))
  add(path_568933, "resourceGroupName", newJString(resourceGroupName))
  add(query_568934, "api-version", newJString(apiVersion))
  add(path_568933, "topicName", newJString(topicName))
  add(path_568933, "subscriptionId", newJString(subscriptionId))
  add(query_568934, "$top", newJInt(Top))
  add(query_568934, "$skip", newJInt(Skip))
  result = call_568932.call(path_568933, query_568934, nil, nil, nil)

var subscriptionsListByTopic* = Call_SubscriptionsListByTopic_568921(
    name: "subscriptionsListByTopic", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions",
    validator: validate_SubscriptionsListByTopic_568922, base: "",
    url: url_SubscriptionsListByTopic_568923, schemes: {Scheme.Https})
type
  Call_SubscriptionsCreateOrUpdate_568948 = ref object of OpenApiRestCall_567666
proc url_SubscriptionsCreateOrUpdate_568950(protocol: Scheme; host: string;
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

proc validate_SubscriptionsCreateOrUpdate_568949(path: JsonNode; query: JsonNode;
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
  var valid_568951 = path.getOrDefault("namespaceName")
  valid_568951 = validateParameter(valid_568951, JString, required = true,
                                 default = nil)
  if valid_568951 != nil:
    section.add "namespaceName", valid_568951
  var valid_568952 = path.getOrDefault("resourceGroupName")
  valid_568952 = validateParameter(valid_568952, JString, required = true,
                                 default = nil)
  if valid_568952 != nil:
    section.add "resourceGroupName", valid_568952
  var valid_568953 = path.getOrDefault("topicName")
  valid_568953 = validateParameter(valid_568953, JString, required = true,
                                 default = nil)
  if valid_568953 != nil:
    section.add "topicName", valid_568953
  var valid_568954 = path.getOrDefault("subscriptionId")
  valid_568954 = validateParameter(valid_568954, JString, required = true,
                                 default = nil)
  if valid_568954 != nil:
    section.add "subscriptionId", valid_568954
  var valid_568955 = path.getOrDefault("subscriptionName")
  valid_568955 = validateParameter(valid_568955, JString, required = true,
                                 default = nil)
  if valid_568955 != nil:
    section.add "subscriptionName", valid_568955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568956 = query.getOrDefault("api-version")
  valid_568956 = validateParameter(valid_568956, JString, required = true,
                                 default = nil)
  if valid_568956 != nil:
    section.add "api-version", valid_568956
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

proc call*(call_568958: Call_SubscriptionsCreateOrUpdate_568948; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a topic subscription.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639385.aspx
  let valid = call_568958.validator(path, query, header, formData, body)
  let scheme = call_568958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568958.url(scheme.get, call_568958.host, call_568958.base,
                         call_568958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568958, url, valid)

proc call*(call_568959: Call_SubscriptionsCreateOrUpdate_568948;
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
  var path_568960 = newJObject()
  var query_568961 = newJObject()
  var body_568962 = newJObject()
  add(path_568960, "namespaceName", newJString(namespaceName))
  add(path_568960, "resourceGroupName", newJString(resourceGroupName))
  add(query_568961, "api-version", newJString(apiVersion))
  add(path_568960, "topicName", newJString(topicName))
  add(path_568960, "subscriptionId", newJString(subscriptionId))
  add(path_568960, "subscriptionName", newJString(subscriptionName))
  if parameters != nil:
    body_568962 = parameters
  result = call_568959.call(path_568960, query_568961, nil, nil, body_568962)

var subscriptionsCreateOrUpdate* = Call_SubscriptionsCreateOrUpdate_568948(
    name: "subscriptionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}",
    validator: validate_SubscriptionsCreateOrUpdate_568949, base: "",
    url: url_SubscriptionsCreateOrUpdate_568950, schemes: {Scheme.Https})
type
  Call_SubscriptionsGet_568935 = ref object of OpenApiRestCall_567666
proc url_SubscriptionsGet_568937(protocol: Scheme; host: string; base: string;
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

proc validate_SubscriptionsGet_568936(path: JsonNode; query: JsonNode;
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
  var valid_568938 = path.getOrDefault("namespaceName")
  valid_568938 = validateParameter(valid_568938, JString, required = true,
                                 default = nil)
  if valid_568938 != nil:
    section.add "namespaceName", valid_568938
  var valid_568939 = path.getOrDefault("resourceGroupName")
  valid_568939 = validateParameter(valid_568939, JString, required = true,
                                 default = nil)
  if valid_568939 != nil:
    section.add "resourceGroupName", valid_568939
  var valid_568940 = path.getOrDefault("topicName")
  valid_568940 = validateParameter(valid_568940, JString, required = true,
                                 default = nil)
  if valid_568940 != nil:
    section.add "topicName", valid_568940
  var valid_568941 = path.getOrDefault("subscriptionId")
  valid_568941 = validateParameter(valid_568941, JString, required = true,
                                 default = nil)
  if valid_568941 != nil:
    section.add "subscriptionId", valid_568941
  var valid_568942 = path.getOrDefault("subscriptionName")
  valid_568942 = validateParameter(valid_568942, JString, required = true,
                                 default = nil)
  if valid_568942 != nil:
    section.add "subscriptionName", valid_568942
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568943 = query.getOrDefault("api-version")
  valid_568943 = validateParameter(valid_568943, JString, required = true,
                                 default = nil)
  if valid_568943 != nil:
    section.add "api-version", valid_568943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568944: Call_SubscriptionsGet_568935; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a subscription description for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639402.aspx
  let valid = call_568944.validator(path, query, header, formData, body)
  let scheme = call_568944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568944.url(scheme.get, call_568944.host, call_568944.base,
                         call_568944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568944, url, valid)

proc call*(call_568945: Call_SubscriptionsGet_568935; namespaceName: string;
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
  var path_568946 = newJObject()
  var query_568947 = newJObject()
  add(path_568946, "namespaceName", newJString(namespaceName))
  add(path_568946, "resourceGroupName", newJString(resourceGroupName))
  add(query_568947, "api-version", newJString(apiVersion))
  add(path_568946, "topicName", newJString(topicName))
  add(path_568946, "subscriptionId", newJString(subscriptionId))
  add(path_568946, "subscriptionName", newJString(subscriptionName))
  result = call_568945.call(path_568946, query_568947, nil, nil, nil)

var subscriptionsGet* = Call_SubscriptionsGet_568935(name: "subscriptionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}",
    validator: validate_SubscriptionsGet_568936, base: "",
    url: url_SubscriptionsGet_568937, schemes: {Scheme.Https})
type
  Call_SubscriptionsDelete_568963 = ref object of OpenApiRestCall_567666
proc url_SubscriptionsDelete_568965(protocol: Scheme; host: string; base: string;
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

proc validate_SubscriptionsDelete_568964(path: JsonNode; query: JsonNode;
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
  var valid_568966 = path.getOrDefault("namespaceName")
  valid_568966 = validateParameter(valid_568966, JString, required = true,
                                 default = nil)
  if valid_568966 != nil:
    section.add "namespaceName", valid_568966
  var valid_568967 = path.getOrDefault("resourceGroupName")
  valid_568967 = validateParameter(valid_568967, JString, required = true,
                                 default = nil)
  if valid_568967 != nil:
    section.add "resourceGroupName", valid_568967
  var valid_568968 = path.getOrDefault("topicName")
  valid_568968 = validateParameter(valid_568968, JString, required = true,
                                 default = nil)
  if valid_568968 != nil:
    section.add "topicName", valid_568968
  var valid_568969 = path.getOrDefault("subscriptionId")
  valid_568969 = validateParameter(valid_568969, JString, required = true,
                                 default = nil)
  if valid_568969 != nil:
    section.add "subscriptionId", valid_568969
  var valid_568970 = path.getOrDefault("subscriptionName")
  valid_568970 = validateParameter(valid_568970, JString, required = true,
                                 default = nil)
  if valid_568970 != nil:
    section.add "subscriptionName", valid_568970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568971 = query.getOrDefault("api-version")
  valid_568971 = validateParameter(valid_568971, JString, required = true,
                                 default = nil)
  if valid_568971 != nil:
    section.add "api-version", valid_568971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568972: Call_SubscriptionsDelete_568963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a subscription from the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639381.aspx
  let valid = call_568972.validator(path, query, header, formData, body)
  let scheme = call_568972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568972.url(scheme.get, call_568972.host, call_568972.base,
                         call_568972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568972, url, valid)

proc call*(call_568973: Call_SubscriptionsDelete_568963; namespaceName: string;
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
  var path_568974 = newJObject()
  var query_568975 = newJObject()
  add(path_568974, "namespaceName", newJString(namespaceName))
  add(path_568974, "resourceGroupName", newJString(resourceGroupName))
  add(query_568975, "api-version", newJString(apiVersion))
  add(path_568974, "topicName", newJString(topicName))
  add(path_568974, "subscriptionId", newJString(subscriptionId))
  add(path_568974, "subscriptionName", newJString(subscriptionName))
  result = call_568973.call(path_568974, query_568975, nil, nil, nil)

var subscriptionsDelete* = Call_SubscriptionsDelete_568963(
    name: "subscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}",
    validator: validate_SubscriptionsDelete_568964, base: "",
    url: url_SubscriptionsDelete_568965, schemes: {Scheme.Https})
type
  Call_RulesListBySubscriptions_568976 = ref object of OpenApiRestCall_567666
proc url_RulesListBySubscriptions_568978(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "subscriptionName"),
               (kind: ConstantSegment, value: "/rules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RulesListBySubscriptions_568977(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the rules within given topic-subscription
  ## 
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
  var valid_568979 = path.getOrDefault("namespaceName")
  valid_568979 = validateParameter(valid_568979, JString, required = true,
                                 default = nil)
  if valid_568979 != nil:
    section.add "namespaceName", valid_568979
  var valid_568980 = path.getOrDefault("resourceGroupName")
  valid_568980 = validateParameter(valid_568980, JString, required = true,
                                 default = nil)
  if valid_568980 != nil:
    section.add "resourceGroupName", valid_568980
  var valid_568981 = path.getOrDefault("topicName")
  valid_568981 = validateParameter(valid_568981, JString, required = true,
                                 default = nil)
  if valid_568981 != nil:
    section.add "topicName", valid_568981
  var valid_568982 = path.getOrDefault("subscriptionId")
  valid_568982 = validateParameter(valid_568982, JString, required = true,
                                 default = nil)
  if valid_568982 != nil:
    section.add "subscriptionId", valid_568982
  var valid_568983 = path.getOrDefault("subscriptionName")
  valid_568983 = validateParameter(valid_568983, JString, required = true,
                                 default = nil)
  if valid_568983 != nil:
    section.add "subscriptionName", valid_568983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skip: JInt
  ##        : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568984 = query.getOrDefault("api-version")
  valid_568984 = validateParameter(valid_568984, JString, required = true,
                                 default = nil)
  if valid_568984 != nil:
    section.add "api-version", valid_568984
  var valid_568985 = query.getOrDefault("$top")
  valid_568985 = validateParameter(valid_568985, JInt, required = false, default = nil)
  if valid_568985 != nil:
    section.add "$top", valid_568985
  var valid_568986 = query.getOrDefault("$skip")
  valid_568986 = validateParameter(valid_568986, JInt, required = false, default = nil)
  if valid_568986 != nil:
    section.add "$skip", valid_568986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568987: Call_RulesListBySubscriptions_568976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the rules within given topic-subscription
  ## 
  let valid = call_568987.validator(path, query, header, formData, body)
  let scheme = call_568987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568987.url(scheme.get, call_568987.host, call_568987.base,
                         call_568987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568987, url, valid)

proc call*(call_568988: Call_RulesListBySubscriptions_568976;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          topicName: string; subscriptionId: string; subscriptionName: string;
          Top: int = 0; Skip: int = 0): Recallable =
  ## rulesListBySubscriptions
  ## List all the rules within given topic-subscription
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
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   subscriptionName: string (required)
  ##                   : The subscription name.
  ##   Skip: int
  ##       : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  var path_568989 = newJObject()
  var query_568990 = newJObject()
  add(path_568989, "namespaceName", newJString(namespaceName))
  add(path_568989, "resourceGroupName", newJString(resourceGroupName))
  add(query_568990, "api-version", newJString(apiVersion))
  add(path_568989, "topicName", newJString(topicName))
  add(path_568989, "subscriptionId", newJString(subscriptionId))
  add(query_568990, "$top", newJInt(Top))
  add(path_568989, "subscriptionName", newJString(subscriptionName))
  add(query_568990, "$skip", newJInt(Skip))
  result = call_568988.call(path_568989, query_568990, nil, nil, nil)

var rulesListBySubscriptions* = Call_RulesListBySubscriptions_568976(
    name: "rulesListBySubscriptions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}/rules",
    validator: validate_RulesListBySubscriptions_568977, base: "",
    url: url_RulesListBySubscriptions_568978, schemes: {Scheme.Https})
type
  Call_RulesCreateOrUpdate_569005 = ref object of OpenApiRestCall_567666
proc url_RulesCreateOrUpdate_569007(protocol: Scheme; host: string; base: string;
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
  assert "ruleName" in path, "`ruleName` is a required path parameter"
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
               (kind: VariableSegment, value: "subscriptionName"),
               (kind: ConstantSegment, value: "/rules/"),
               (kind: VariableSegment, value: "ruleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RulesCreateOrUpdate_569006(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new rule and updates an existing rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   ruleName: JString (required)
  ##           : The rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: JString (required)
  ##                   : The subscription name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_569008 = path.getOrDefault("namespaceName")
  valid_569008 = validateParameter(valid_569008, JString, required = true,
                                 default = nil)
  if valid_569008 != nil:
    section.add "namespaceName", valid_569008
  var valid_569009 = path.getOrDefault("resourceGroupName")
  valid_569009 = validateParameter(valid_569009, JString, required = true,
                                 default = nil)
  if valid_569009 != nil:
    section.add "resourceGroupName", valid_569009
  var valid_569010 = path.getOrDefault("topicName")
  valid_569010 = validateParameter(valid_569010, JString, required = true,
                                 default = nil)
  if valid_569010 != nil:
    section.add "topicName", valid_569010
  var valid_569011 = path.getOrDefault("ruleName")
  valid_569011 = validateParameter(valid_569011, JString, required = true,
                                 default = nil)
  if valid_569011 != nil:
    section.add "ruleName", valid_569011
  var valid_569012 = path.getOrDefault("subscriptionId")
  valid_569012 = validateParameter(valid_569012, JString, required = true,
                                 default = nil)
  if valid_569012 != nil:
    section.add "subscriptionId", valid_569012
  var valid_569013 = path.getOrDefault("subscriptionName")
  valid_569013 = validateParameter(valid_569013, JString, required = true,
                                 default = nil)
  if valid_569013 != nil:
    section.add "subscriptionName", valid_569013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569014 = query.getOrDefault("api-version")
  valid_569014 = validateParameter(valid_569014, JString, required = true,
                                 default = nil)
  if valid_569014 != nil:
    section.add "api-version", valid_569014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569016: Call_RulesCreateOrUpdate_569005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new rule and updates an existing rule
  ## 
  let valid = call_569016.validator(path, query, header, formData, body)
  let scheme = call_569016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569016.url(scheme.get, call_569016.host, call_569016.base,
                         call_569016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569016, url, valid)

proc call*(call_569017: Call_RulesCreateOrUpdate_569005; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          ruleName: string; subscriptionId: string; subscriptionName: string;
          parameters: JsonNode): Recallable =
  ## rulesCreateOrUpdate
  ## Creates a new rule and updates an existing rule
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   ruleName: string (required)
  ##           : The rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: string (required)
  ##                   : The subscription name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a rule.
  var path_569018 = newJObject()
  var query_569019 = newJObject()
  var body_569020 = newJObject()
  add(path_569018, "namespaceName", newJString(namespaceName))
  add(path_569018, "resourceGroupName", newJString(resourceGroupName))
  add(query_569019, "api-version", newJString(apiVersion))
  add(path_569018, "topicName", newJString(topicName))
  add(path_569018, "ruleName", newJString(ruleName))
  add(path_569018, "subscriptionId", newJString(subscriptionId))
  add(path_569018, "subscriptionName", newJString(subscriptionName))
  if parameters != nil:
    body_569020 = parameters
  result = call_569017.call(path_569018, query_569019, nil, nil, body_569020)

var rulesCreateOrUpdate* = Call_RulesCreateOrUpdate_569005(
    name: "rulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}/rules/{ruleName}",
    validator: validate_RulesCreateOrUpdate_569006, base: "",
    url: url_RulesCreateOrUpdate_569007, schemes: {Scheme.Https})
type
  Call_RulesGet_568991 = ref object of OpenApiRestCall_567666
proc url_RulesGet_568993(protocol: Scheme; host: string; base: string; route: string;
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
  assert "subscriptionName" in path,
        "`subscriptionName` is a required path parameter"
  assert "ruleName" in path, "`ruleName` is a required path parameter"
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
               (kind: VariableSegment, value: "subscriptionName"),
               (kind: ConstantSegment, value: "/rules/"),
               (kind: VariableSegment, value: "ruleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RulesGet_568992(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the description for the specified rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   ruleName: JString (required)
  ##           : The rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: JString (required)
  ##                   : The subscription name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568994 = path.getOrDefault("namespaceName")
  valid_568994 = validateParameter(valid_568994, JString, required = true,
                                 default = nil)
  if valid_568994 != nil:
    section.add "namespaceName", valid_568994
  var valid_568995 = path.getOrDefault("resourceGroupName")
  valid_568995 = validateParameter(valid_568995, JString, required = true,
                                 default = nil)
  if valid_568995 != nil:
    section.add "resourceGroupName", valid_568995
  var valid_568996 = path.getOrDefault("topicName")
  valid_568996 = validateParameter(valid_568996, JString, required = true,
                                 default = nil)
  if valid_568996 != nil:
    section.add "topicName", valid_568996
  var valid_568997 = path.getOrDefault("ruleName")
  valid_568997 = validateParameter(valid_568997, JString, required = true,
                                 default = nil)
  if valid_568997 != nil:
    section.add "ruleName", valid_568997
  var valid_568998 = path.getOrDefault("subscriptionId")
  valid_568998 = validateParameter(valid_568998, JString, required = true,
                                 default = nil)
  if valid_568998 != nil:
    section.add "subscriptionId", valid_568998
  var valid_568999 = path.getOrDefault("subscriptionName")
  valid_568999 = validateParameter(valid_568999, JString, required = true,
                                 default = nil)
  if valid_568999 != nil:
    section.add "subscriptionName", valid_568999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569000 = query.getOrDefault("api-version")
  valid_569000 = validateParameter(valid_569000, JString, required = true,
                                 default = nil)
  if valid_569000 != nil:
    section.add "api-version", valid_569000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569001: Call_RulesGet_568991; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the description for the specified rule.
  ## 
  let valid = call_569001.validator(path, query, header, formData, body)
  let scheme = call_569001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569001.url(scheme.get, call_569001.host, call_569001.base,
                         call_569001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569001, url, valid)

proc call*(call_569002: Call_RulesGet_568991; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          ruleName: string; subscriptionId: string; subscriptionName: string): Recallable =
  ## rulesGet
  ## Retrieves the description for the specified rule.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   ruleName: string (required)
  ##           : The rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: string (required)
  ##                   : The subscription name.
  var path_569003 = newJObject()
  var query_569004 = newJObject()
  add(path_569003, "namespaceName", newJString(namespaceName))
  add(path_569003, "resourceGroupName", newJString(resourceGroupName))
  add(query_569004, "api-version", newJString(apiVersion))
  add(path_569003, "topicName", newJString(topicName))
  add(path_569003, "ruleName", newJString(ruleName))
  add(path_569003, "subscriptionId", newJString(subscriptionId))
  add(path_569003, "subscriptionName", newJString(subscriptionName))
  result = call_569002.call(path_569003, query_569004, nil, nil, nil)

var rulesGet* = Call_RulesGet_568991(name: "rulesGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}/rules/{ruleName}",
                                  validator: validate_RulesGet_568992, base: "",
                                  url: url_RulesGet_568993,
                                  schemes: {Scheme.Https})
type
  Call_RulesDelete_569021 = ref object of OpenApiRestCall_567666
proc url_RulesDelete_569023(protocol: Scheme; host: string; base: string;
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
  assert "ruleName" in path, "`ruleName` is a required path parameter"
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
               (kind: VariableSegment, value: "subscriptionName"),
               (kind: ConstantSegment, value: "/rules/"),
               (kind: VariableSegment, value: "ruleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RulesDelete_569022(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   ruleName: JString (required)
  ##           : The rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: JString (required)
  ##                   : The subscription name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_569024 = path.getOrDefault("namespaceName")
  valid_569024 = validateParameter(valid_569024, JString, required = true,
                                 default = nil)
  if valid_569024 != nil:
    section.add "namespaceName", valid_569024
  var valid_569025 = path.getOrDefault("resourceGroupName")
  valid_569025 = validateParameter(valid_569025, JString, required = true,
                                 default = nil)
  if valid_569025 != nil:
    section.add "resourceGroupName", valid_569025
  var valid_569026 = path.getOrDefault("topicName")
  valid_569026 = validateParameter(valid_569026, JString, required = true,
                                 default = nil)
  if valid_569026 != nil:
    section.add "topicName", valid_569026
  var valid_569027 = path.getOrDefault("ruleName")
  valid_569027 = validateParameter(valid_569027, JString, required = true,
                                 default = nil)
  if valid_569027 != nil:
    section.add "ruleName", valid_569027
  var valid_569028 = path.getOrDefault("subscriptionId")
  valid_569028 = validateParameter(valid_569028, JString, required = true,
                                 default = nil)
  if valid_569028 != nil:
    section.add "subscriptionId", valid_569028
  var valid_569029 = path.getOrDefault("subscriptionName")
  valid_569029 = validateParameter(valid_569029, JString, required = true,
                                 default = nil)
  if valid_569029 != nil:
    section.add "subscriptionName", valid_569029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569030 = query.getOrDefault("api-version")
  valid_569030 = validateParameter(valid_569030, JString, required = true,
                                 default = nil)
  if valid_569030 != nil:
    section.add "api-version", valid_569030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569031: Call_RulesDelete_569021; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing rule.
  ## 
  let valid = call_569031.validator(path, query, header, formData, body)
  let scheme = call_569031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569031.url(scheme.get, call_569031.host, call_569031.base,
                         call_569031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569031, url, valid)

proc call*(call_569032: Call_RulesDelete_569021; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          ruleName: string; subscriptionId: string; subscriptionName: string): Recallable =
  ## rulesDelete
  ## Deletes an existing rule.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   ruleName: string (required)
  ##           : The rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: string (required)
  ##                   : The subscription name.
  var path_569033 = newJObject()
  var query_569034 = newJObject()
  add(path_569033, "namespaceName", newJString(namespaceName))
  add(path_569033, "resourceGroupName", newJString(resourceGroupName))
  add(query_569034, "api-version", newJString(apiVersion))
  add(path_569033, "topicName", newJString(topicName))
  add(path_569033, "ruleName", newJString(ruleName))
  add(path_569033, "subscriptionId", newJString(subscriptionId))
  add(path_569033, "subscriptionName", newJString(subscriptionName))
  result = call_569032.call(path_569033, query_569034, nil, nil, nil)

var rulesDelete* = Call_RulesDelete_569021(name: "rulesDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}/rules/{ruleName}",
                                        validator: validate_RulesDelete_569022,
                                        base: "", url: url_RulesDelete_569023,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
