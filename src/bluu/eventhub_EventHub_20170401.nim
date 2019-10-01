
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: EventHubManagementClient
## version: 2017-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Event Hubs client
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
  macServiceName = "eventhub-EventHub"
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
  ## Lists all of the available Event Hub REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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
  ## Lists all of the available Event Hub REST API operations.
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
  ## Lists all of the available Event Hub REST API operations.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  result = call_568135.call(nil, query_568136, nil, nil, nil)

var operationsList* = Call_OperationsList_567880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.EventHub/operations",
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
        value: "/providers/Microsoft.EventHub/CheckNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCheckNameAvailability_568177(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the give Namespace name availability.
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
  ##              : Client API Version.
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
  ##             : Parameters to check availability of the given Namespace name
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568213: Call_NamespacesCheckNameAvailability_568176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give Namespace name availability.
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
  ## Check the give Namespace name availability.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given Namespace name
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
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventHub/CheckNameAvailability",
    validator: validate_NamespacesCheckNameAvailability_568177, base: "",
    url: url_NamespacesCheckNameAvailability_568178, schemes: {Scheme.Https})
type
  Call_NamespacesList_568218 = ref object of OpenApiRestCall_567658
proc url_NamespacesList_568220(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesList_568219(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the available Namespaces within a subscription, irrespective of the resource groups.
  ## 
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
  ##              : Client API Version.
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

proc call*(call_568223: Call_NamespacesList_568218; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available Namespaces within a subscription, irrespective of the resource groups.
  ## 
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_NamespacesList_568218; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesList
  ## Lists all the available Namespaces within a subscription, irrespective of the resource groups.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  add(query_568226, "api-version", newJString(apiVersion))
  add(path_568225, "subscriptionId", newJString(subscriptionId))
  result = call_568224.call(path_568225, query_568226, nil, nil, nil)

var namespacesList* = Call_NamespacesList_568218(name: "namespacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventHub/namespaces",
    validator: validate_NamespacesList_568219, base: "", url: url_NamespacesList_568220,
    schemes: {Scheme.Https})
type
  Call_RegionsListBySku_568227 = ref object of OpenApiRestCall_567658
proc url_RegionsListBySku_568229(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/sku/"),
               (kind: VariableSegment, value: "sku"),
               (kind: ConstantSegment, value: "/regions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegionsListBySku_568228(path: JsonNode; query: JsonNode;
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
  var valid_568230 = path.getOrDefault("subscriptionId")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "subscriptionId", valid_568230
  var valid_568231 = path.getOrDefault("sku")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "sku", valid_568231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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

proc call*(call_568233: Call_RegionsListBySku_568227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the available Regions for a given sku
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_RegionsListBySku_568227; apiVersion: string;
          subscriptionId: string; sku: string): Recallable =
  ## regionsListBySku
  ## Gets the available Regions for a given sku
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sku: string (required)
  ##      : The sku type.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  add(path_568235, "sku", newJString(sku))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var regionsListBySku* = Call_RegionsListBySku_568227(name: "regionsListBySku",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventHub/sku/{sku}/regions",
    validator: validate_RegionsListBySku_568228, base: "",
    url: url_RegionsListBySku_568229, schemes: {Scheme.Https})
type
  Call_NamespacesListByResourceGroup_568237 = ref object of OpenApiRestCall_567658
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListByResourceGroup_568238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the available Namespaces within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
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
  ##              : Client API Version.
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
  ## Lists the available Namespaces within a resource group.
  ## 
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
  ## Lists the available Namespaces within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
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
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces",
    validator: validate_NamespacesListByResourceGroup_568238, base: "",
    url: url_NamespacesListByResourceGroup_568239, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdate_568258 = ref object of OpenApiRestCall_567658
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdate_568259(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568271 = path.getOrDefault("namespaceName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "namespaceName", valid_568271
  var valid_568272 = path.getOrDefault("resourceGroupName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "resourceGroupName", valid_568272
  var valid_568273 = path.getOrDefault("subscriptionId")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "subscriptionId", valid_568273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568274 = query.getOrDefault("api-version")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "api-version", valid_568274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for creating a namespace resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568276: Call_NamespacesCreateOrUpdate_568258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  let valid = call_568276.validator(path, query, header, formData, body)
  let scheme = call_568276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568276.url(scheme.get, call_568276.host, call_568276.base,
                         call_568276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568276, url, valid)

proc call*(call_568277: Call_NamespacesCreateOrUpdate_568258;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdate
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters for creating a namespace resource.
  var path_568278 = newJObject()
  var query_568279 = newJObject()
  var body_568280 = newJObject()
  add(path_568278, "namespaceName", newJString(namespaceName))
  add(path_568278, "resourceGroupName", newJString(resourceGroupName))
  add(query_568279, "api-version", newJString(apiVersion))
  add(path_568278, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568280 = parameters
  result = call_568277.call(path_568278, query_568279, nil, nil, body_568280)

var namespacesCreateOrUpdate* = Call_NamespacesCreateOrUpdate_568258(
    name: "namespacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesCreateOrUpdate_568259, base: "",
    url: url_NamespacesCreateOrUpdate_568260, schemes: {Scheme.Https})
type
  Call_NamespacesGet_568247 = ref object of OpenApiRestCall_567658
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGet_568248(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the description of the specified namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
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
  ##              : Client API Version.
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
  ## Gets the description of the specified namespace.
  ## 
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
  ## Gets the description of the specified namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
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
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesGet_568248, base: "", url: url_NamespacesGet_568249,
    schemes: {Scheme.Https})
type
  Call_NamespacesUpdate_568292 = ref object of OpenApiRestCall_567658
proc url_NamespacesUpdate_568294(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesUpdate_568293(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568295 = path.getOrDefault("namespaceName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "namespaceName", valid_568295
  var valid_568296 = path.getOrDefault("resourceGroupName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "resourceGroupName", valid_568296
  var valid_568297 = path.getOrDefault("subscriptionId")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "subscriptionId", valid_568297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568298 = query.getOrDefault("api-version")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "api-version", valid_568298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for updating a namespace resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568300: Call_NamespacesUpdate_568292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  let valid = call_568300.validator(path, query, header, formData, body)
  let scheme = call_568300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568300.url(scheme.get, call_568300.host, call_568300.base,
                         call_568300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568300, url, valid)

proc call*(call_568301: Call_NamespacesUpdate_568292; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesUpdate
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters for updating a namespace resource.
  var path_568302 = newJObject()
  var query_568303 = newJObject()
  var body_568304 = newJObject()
  add(path_568302, "namespaceName", newJString(namespaceName))
  add(path_568302, "resourceGroupName", newJString(resourceGroupName))
  add(query_568303, "api-version", newJString(apiVersion))
  add(path_568302, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568304 = parameters
  result = call_568301.call(path_568302, query_568303, nil, nil, body_568304)

var namespacesUpdate* = Call_NamespacesUpdate_568292(name: "namespacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesUpdate_568293, base: "",
    url: url_NamespacesUpdate_568294, schemes: {Scheme.Https})
type
  Call_NamespacesDelete_568281 = ref object of OpenApiRestCall_567658
proc url_NamespacesDelete_568283(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDelete_568282(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568284 = path.getOrDefault("namespaceName")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "namespaceName", valid_568284
  var valid_568285 = path.getOrDefault("resourceGroupName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "resourceGroupName", valid_568285
  var valid_568286 = path.getOrDefault("subscriptionId")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "subscriptionId", valid_568286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568287 = query.getOrDefault("api-version")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "api-version", valid_568287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568288: Call_NamespacesDelete_568281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_NamespacesDelete_568281; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesDelete
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568290 = newJObject()
  var query_568291 = newJObject()
  add(path_568290, "namespaceName", newJString(namespaceName))
  add(path_568290, "resourceGroupName", newJString(resourceGroupName))
  add(query_568291, "api-version", newJString(apiVersion))
  add(path_568290, "subscriptionId", newJString(subscriptionId))
  result = call_568289.call(path_568290, query_568291, nil, nil, nil)

var namespacesDelete* = Call_NamespacesDelete_568281(name: "namespacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesDelete_568282, base: "",
    url: url_NamespacesDelete_568283, schemes: {Scheme.Https})
type
  Call_NamespacesListAuthorizationRules_568305 = ref object of OpenApiRestCall_567658
proc url_NamespacesListAuthorizationRules_568307(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListAuthorizationRules_568306(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of authorization rules for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568308 = path.getOrDefault("namespaceName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "namespaceName", valid_568308
  var valid_568309 = path.getOrDefault("resourceGroupName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "resourceGroupName", valid_568309
  var valid_568310 = path.getOrDefault("subscriptionId")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "subscriptionId", valid_568310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568311 = query.getOrDefault("api-version")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "api-version", valid_568311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568312: Call_NamespacesListAuthorizationRules_568305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of authorization rules for a Namespace.
  ## 
  let valid = call_568312.validator(path, query, header, formData, body)
  let scheme = call_568312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568312.url(scheme.get, call_568312.host, call_568312.base,
                         call_568312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568312, url, valid)

proc call*(call_568313: Call_NamespacesListAuthorizationRules_568305;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesListAuthorizationRules
  ## Gets a list of authorization rules for a Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568314 = newJObject()
  var query_568315 = newJObject()
  add(path_568314, "namespaceName", newJString(namespaceName))
  add(path_568314, "resourceGroupName", newJString(resourceGroupName))
  add(query_568315, "api-version", newJString(apiVersion))
  add(path_568314, "subscriptionId", newJString(subscriptionId))
  result = call_568313.call(path_568314, query_568315, nil, nil, nil)

var namespacesListAuthorizationRules* = Call_NamespacesListAuthorizationRules_568305(
    name: "namespacesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListAuthorizationRules_568306, base: "",
    url: url_NamespacesListAuthorizationRules_568307, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateAuthorizationRule_568328 = ref object of OpenApiRestCall_567658
proc url_NamespacesCreateOrUpdateAuthorizationRule_568330(protocol: Scheme;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdateAuthorizationRule_568329(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an AuthorizationRule for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568331 = path.getOrDefault("namespaceName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "namespaceName", valid_568331
  var valid_568332 = path.getOrDefault("resourceGroupName")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "resourceGroupName", valid_568332
  var valid_568333 = path.getOrDefault("authorizationRuleName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "authorizationRuleName", valid_568333
  var valid_568334 = path.getOrDefault("subscriptionId")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "subscriptionId", valid_568334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568335 = query.getOrDefault("api-version")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "api-version", valid_568335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The shared access AuthorizationRule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568337: Call_NamespacesCreateOrUpdateAuthorizationRule_568328;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an AuthorizationRule for a Namespace.
  ## 
  let valid = call_568337.validator(path, query, header, formData, body)
  let scheme = call_568337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568337.url(scheme.get, call_568337.host, call_568337.base,
                         call_568337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568337, url, valid)

proc call*(call_568338: Call_NamespacesCreateOrUpdateAuthorizationRule_568328;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateAuthorizationRule
  ## Creates or updates an AuthorizationRule for a Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The shared access AuthorizationRule.
  var path_568339 = newJObject()
  var query_568340 = newJObject()
  var body_568341 = newJObject()
  add(path_568339, "namespaceName", newJString(namespaceName))
  add(path_568339, "resourceGroupName", newJString(resourceGroupName))
  add(query_568340, "api-version", newJString(apiVersion))
  add(path_568339, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568339, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568341 = parameters
  result = call_568338.call(path_568339, query_568340, nil, nil, body_568341)

var namespacesCreateOrUpdateAuthorizationRule* = Call_NamespacesCreateOrUpdateAuthorizationRule_568328(
    name: "namespacesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesCreateOrUpdateAuthorizationRule_568329,
    base: "", url: url_NamespacesCreateOrUpdateAuthorizationRule_568330,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetAuthorizationRule_568316 = ref object of OpenApiRestCall_567658
proc url_NamespacesGetAuthorizationRule_568318(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGetAuthorizationRule_568317(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568319 = path.getOrDefault("namespaceName")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "namespaceName", valid_568319
  var valid_568320 = path.getOrDefault("resourceGroupName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "resourceGroupName", valid_568320
  var valid_568321 = path.getOrDefault("authorizationRuleName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "authorizationRuleName", valid_568321
  var valid_568322 = path.getOrDefault("subscriptionId")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "subscriptionId", valid_568322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568323 = query.getOrDefault("api-version")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "api-version", valid_568323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568324: Call_NamespacesGetAuthorizationRule_568316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ## 
  let valid = call_568324.validator(path, query, header, formData, body)
  let scheme = call_568324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568324.url(scheme.get, call_568324.host, call_568324.base,
                         call_568324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568324, url, valid)

proc call*(call_568325: Call_NamespacesGetAuthorizationRule_568316;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesGetAuthorizationRule
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568326 = newJObject()
  var query_568327 = newJObject()
  add(path_568326, "namespaceName", newJString(namespaceName))
  add(path_568326, "resourceGroupName", newJString(resourceGroupName))
  add(query_568327, "api-version", newJString(apiVersion))
  add(path_568326, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568326, "subscriptionId", newJString(subscriptionId))
  result = call_568325.call(path_568326, query_568327, nil, nil, nil)

var namespacesGetAuthorizationRule* = Call_NamespacesGetAuthorizationRule_568316(
    name: "namespacesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesGetAuthorizationRule_568317, base: "",
    url: url_NamespacesGetAuthorizationRule_568318, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteAuthorizationRule_568342 = ref object of OpenApiRestCall_567658
proc url_NamespacesDeleteAuthorizationRule_568344(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDeleteAuthorizationRule_568343(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an AuthorizationRule for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568345 = path.getOrDefault("namespaceName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "namespaceName", valid_568345
  var valid_568346 = path.getOrDefault("resourceGroupName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "resourceGroupName", valid_568346
  var valid_568347 = path.getOrDefault("authorizationRuleName")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "authorizationRuleName", valid_568347
  var valid_568348 = path.getOrDefault("subscriptionId")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "subscriptionId", valid_568348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568349 = query.getOrDefault("api-version")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "api-version", valid_568349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568350: Call_NamespacesDeleteAuthorizationRule_568342;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an AuthorizationRule for a Namespace.
  ## 
  let valid = call_568350.validator(path, query, header, formData, body)
  let scheme = call_568350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568350.url(scheme.get, call_568350.host, call_568350.base,
                         call_568350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568350, url, valid)

proc call*(call_568351: Call_NamespacesDeleteAuthorizationRule_568342;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesDeleteAuthorizationRule
  ## Deletes an AuthorizationRule for a Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568352 = newJObject()
  var query_568353 = newJObject()
  add(path_568352, "namespaceName", newJString(namespaceName))
  add(path_568352, "resourceGroupName", newJString(resourceGroupName))
  add(query_568353, "api-version", newJString(apiVersion))
  add(path_568352, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568352, "subscriptionId", newJString(subscriptionId))
  result = call_568351.call(path_568352, query_568353, nil, nil, nil)

var namespacesDeleteAuthorizationRule* = Call_NamespacesDeleteAuthorizationRule_568342(
    name: "namespacesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesDeleteAuthorizationRule_568343, base: "",
    url: url_NamespacesDeleteAuthorizationRule_568344, schemes: {Scheme.Https})
type
  Call_NamespacesListKeys_568354 = ref object of OpenApiRestCall_567658
proc url_NamespacesListKeys_568356(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListKeys_568355(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the primary and secondary connection strings for the Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568357 = path.getOrDefault("namespaceName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "namespaceName", valid_568357
  var valid_568358 = path.getOrDefault("resourceGroupName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "resourceGroupName", valid_568358
  var valid_568359 = path.getOrDefault("authorizationRuleName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "authorizationRuleName", valid_568359
  var valid_568360 = path.getOrDefault("subscriptionId")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "subscriptionId", valid_568360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568361 = query.getOrDefault("api-version")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "api-version", valid_568361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568362: Call_NamespacesListKeys_568354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the primary and secondary connection strings for the Namespace.
  ## 
  let valid = call_568362.validator(path, query, header, formData, body)
  let scheme = call_568362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568362.url(scheme.get, call_568362.host, call_568362.base,
                         call_568362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568362, url, valid)

proc call*(call_568363: Call_NamespacesListKeys_568354; namespaceName: string;
          resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesListKeys
  ## Gets the primary and secondary connection strings for the Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568364 = newJObject()
  var query_568365 = newJObject()
  add(path_568364, "namespaceName", newJString(namespaceName))
  add(path_568364, "resourceGroupName", newJString(resourceGroupName))
  add(query_568365, "api-version", newJString(apiVersion))
  add(path_568364, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568364, "subscriptionId", newJString(subscriptionId))
  result = call_568363.call(path_568364, query_568365, nil, nil, nil)

var namespacesListKeys* = Call_NamespacesListKeys_568354(
    name: "namespacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_NamespacesListKeys_568355, base: "",
    url: url_NamespacesListKeys_568356, schemes: {Scheme.Https})
type
  Call_NamespacesRegenerateKeys_568366 = ref object of OpenApiRestCall_567658
proc url_NamespacesRegenerateKeys_568368(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesRegenerateKeys_568367(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary or secondary connection strings for the specified Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568369 = path.getOrDefault("namespaceName")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "namespaceName", valid_568369
  var valid_568370 = path.getOrDefault("resourceGroupName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "resourceGroupName", valid_568370
  var valid_568371 = path.getOrDefault("authorizationRuleName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "authorizationRuleName", valid_568371
  var valid_568372 = path.getOrDefault("subscriptionId")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "subscriptionId", valid_568372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568373 = query.getOrDefault("api-version")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "api-version", valid_568373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters required to regenerate the connection string.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568375: Call_NamespacesRegenerateKeys_568366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the primary or secondary connection strings for the specified Namespace.
  ## 
  let valid = call_568375.validator(path, query, header, formData, body)
  let scheme = call_568375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568375.url(scheme.get, call_568375.host, call_568375.base,
                         call_568375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568375, url, valid)

proc call*(call_568376: Call_NamespacesRegenerateKeys_568366;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesRegenerateKeys
  ## Regenerates the primary or secondary connection strings for the specified Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters required to regenerate the connection string.
  var path_568377 = newJObject()
  var query_568378 = newJObject()
  var body_568379 = newJObject()
  add(path_568377, "namespaceName", newJString(namespaceName))
  add(path_568377, "resourceGroupName", newJString(resourceGroupName))
  add(query_568378, "api-version", newJString(apiVersion))
  add(path_568377, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568377, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568379 = parameters
  result = call_568376.call(path_568377, query_568378, nil, nil, body_568379)

var namespacesRegenerateKeys* = Call_NamespacesRegenerateKeys_568366(
    name: "namespacesRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_NamespacesRegenerateKeys_568367, base: "",
    url: url_NamespacesRegenerateKeys_568368, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsList_568380 = ref object of OpenApiRestCall_567658
proc url_DisasterRecoveryConfigsList_568382(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsList_568381(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all Alias(Disaster Recovery configurations)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568383 = path.getOrDefault("namespaceName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "namespaceName", valid_568383
  var valid_568384 = path.getOrDefault("resourceGroupName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "resourceGroupName", valid_568384
  var valid_568385 = path.getOrDefault("subscriptionId")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "subscriptionId", valid_568385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568386 = query.getOrDefault("api-version")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "api-version", valid_568386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568387: Call_DisasterRecoveryConfigsList_568380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Alias(Disaster Recovery configurations)
  ## 
  let valid = call_568387.validator(path, query, header, formData, body)
  let scheme = call_568387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568387.url(scheme.get, call_568387.host, call_568387.base,
                         call_568387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568387, url, valid)

proc call*(call_568388: Call_DisasterRecoveryConfigsList_568380;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## disasterRecoveryConfigsList
  ## Gets all Alias(Disaster Recovery configurations)
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568389 = newJObject()
  var query_568390 = newJObject()
  add(path_568389, "namespaceName", newJString(namespaceName))
  add(path_568389, "resourceGroupName", newJString(resourceGroupName))
  add(query_568390, "api-version", newJString(apiVersion))
  add(path_568389, "subscriptionId", newJString(subscriptionId))
  result = call_568388.call(path_568389, query_568390, nil, nil, nil)

var disasterRecoveryConfigsList* = Call_DisasterRecoveryConfigsList_568380(
    name: "disasterRecoveryConfigsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs",
    validator: validate_DisasterRecoveryConfigsList_568381, base: "",
    url: url_DisasterRecoveryConfigsList_568382, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsCheckNameAvailability_568391 = ref object of OpenApiRestCall_567658
proc url_DisasterRecoveryConfigsCheckNameAvailability_568393(protocol: Scheme;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"), (
        kind: ConstantSegment,
        value: "/disasterRecoveryConfigs/CheckNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsCheckNameAvailability_568392(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the give Namespace name availability.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568394 = path.getOrDefault("namespaceName")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "namespaceName", valid_568394
  var valid_568395 = path.getOrDefault("resourceGroupName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "resourceGroupName", valid_568395
  var valid_568396 = path.getOrDefault("subscriptionId")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "subscriptionId", valid_568396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568397 = query.getOrDefault("api-version")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "api-version", valid_568397
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given Alias name
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568399: Call_DisasterRecoveryConfigsCheckNameAvailability_568391;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give Namespace name availability.
  ## 
  let valid = call_568399.validator(path, query, header, formData, body)
  let scheme = call_568399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568399.url(scheme.get, call_568399.host, call_568399.base,
                         call_568399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568399, url, valid)

proc call*(call_568400: Call_DisasterRecoveryConfigsCheckNameAvailability_568391;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## disasterRecoveryConfigsCheckNameAvailability
  ## Check the give Namespace name availability.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given Alias name
  var path_568401 = newJObject()
  var query_568402 = newJObject()
  var body_568403 = newJObject()
  add(path_568401, "namespaceName", newJString(namespaceName))
  add(path_568401, "resourceGroupName", newJString(resourceGroupName))
  add(query_568402, "api-version", newJString(apiVersion))
  add(path_568401, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568403 = parameters
  result = call_568400.call(path_568401, query_568402, nil, nil, body_568403)

var disasterRecoveryConfigsCheckNameAvailability* = Call_DisasterRecoveryConfigsCheckNameAvailability_568391(
    name: "disasterRecoveryConfigsCheckNameAvailability",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/CheckNameAvailability",
    validator: validate_DisasterRecoveryConfigsCheckNameAvailability_568392,
    base: "", url: url_DisasterRecoveryConfigsCheckNameAvailability_568393,
    schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsCreateOrUpdate_568416 = ref object of OpenApiRestCall_567658
proc url_DisasterRecoveryConfigsCreateOrUpdate_568418(protocol: Scheme;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsCreateOrUpdate_568417(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a new Alias(Disaster Recovery configuration)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
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
  var valid_568422 = path.getOrDefault("alias")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "alias", valid_568422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568423 = query.getOrDefault("api-version")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "api-version", valid_568423
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

proc call*(call_568425: Call_DisasterRecoveryConfigsCreateOrUpdate_568416;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a new Alias(Disaster Recovery configuration)
  ## 
  let valid = call_568425.validator(path, query, header, formData, body)
  let scheme = call_568425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568425.url(scheme.get, call_568425.host, call_568425.base,
                         call_568425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568425, url, valid)

proc call*(call_568426: Call_DisasterRecoveryConfigsCreateOrUpdate_568416;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; alias: string): Recallable =
  ## disasterRecoveryConfigsCreateOrUpdate
  ## Creates or updates a new Alias(Disaster Recovery configuration)
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters required to create an Alias(Disaster Recovery configuration)
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_568427 = newJObject()
  var query_568428 = newJObject()
  var body_568429 = newJObject()
  add(path_568427, "namespaceName", newJString(namespaceName))
  add(path_568427, "resourceGroupName", newJString(resourceGroupName))
  add(query_568428, "api-version", newJString(apiVersion))
  add(path_568427, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568429 = parameters
  add(path_568427, "alias", newJString(alias))
  result = call_568426.call(path_568427, query_568428, nil, nil, body_568429)

var disasterRecoveryConfigsCreateOrUpdate* = Call_DisasterRecoveryConfigsCreateOrUpdate_568416(
    name: "disasterRecoveryConfigsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}",
    validator: validate_DisasterRecoveryConfigsCreateOrUpdate_568417, base: "",
    url: url_DisasterRecoveryConfigsCreateOrUpdate_568418, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsGet_568404 = ref object of OpenApiRestCall_567658
proc url_DisasterRecoveryConfigsGet_568406(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsGet_568405(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves Alias(Disaster Recovery configuration) for primary or secondary namespace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568407 = path.getOrDefault("namespaceName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "namespaceName", valid_568407
  var valid_568408 = path.getOrDefault("resourceGroupName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "resourceGroupName", valid_568408
  var valid_568409 = path.getOrDefault("subscriptionId")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "subscriptionId", valid_568409
  var valid_568410 = path.getOrDefault("alias")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "alias", valid_568410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568411 = query.getOrDefault("api-version")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "api-version", valid_568411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568412: Call_DisasterRecoveryConfigsGet_568404; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves Alias(Disaster Recovery configuration) for primary or secondary namespace
  ## 
  let valid = call_568412.validator(path, query, header, formData, body)
  let scheme = call_568412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568412.url(scheme.get, call_568412.host, call_568412.base,
                         call_568412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568412, url, valid)

proc call*(call_568413: Call_DisasterRecoveryConfigsGet_568404;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsGet
  ## Retrieves Alias(Disaster Recovery configuration) for primary or secondary namespace
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_568414 = newJObject()
  var query_568415 = newJObject()
  add(path_568414, "namespaceName", newJString(namespaceName))
  add(path_568414, "resourceGroupName", newJString(resourceGroupName))
  add(query_568415, "api-version", newJString(apiVersion))
  add(path_568414, "subscriptionId", newJString(subscriptionId))
  add(path_568414, "alias", newJString(alias))
  result = call_568413.call(path_568414, query_568415, nil, nil, nil)

var disasterRecoveryConfigsGet* = Call_DisasterRecoveryConfigsGet_568404(
    name: "disasterRecoveryConfigsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}",
    validator: validate_DisasterRecoveryConfigsGet_568405, base: "",
    url: url_DisasterRecoveryConfigsGet_568406, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsDelete_568430 = ref object of OpenApiRestCall_567658
proc url_DisasterRecoveryConfigsDelete_568432(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsDelete_568431(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an Alias(Disaster Recovery configuration)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568433 = path.getOrDefault("namespaceName")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "namespaceName", valid_568433
  var valid_568434 = path.getOrDefault("resourceGroupName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "resourceGroupName", valid_568434
  var valid_568435 = path.getOrDefault("subscriptionId")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "subscriptionId", valid_568435
  var valid_568436 = path.getOrDefault("alias")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "alias", valid_568436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568437 = query.getOrDefault("api-version")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "api-version", valid_568437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568438: Call_DisasterRecoveryConfigsDelete_568430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Alias(Disaster Recovery configuration)
  ## 
  let valid = call_568438.validator(path, query, header, formData, body)
  let scheme = call_568438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568438.url(scheme.get, call_568438.host, call_568438.base,
                         call_568438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568438, url, valid)

proc call*(call_568439: Call_DisasterRecoveryConfigsDelete_568430;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsDelete
  ## Deletes an Alias(Disaster Recovery configuration)
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_568440 = newJObject()
  var query_568441 = newJObject()
  add(path_568440, "namespaceName", newJString(namespaceName))
  add(path_568440, "resourceGroupName", newJString(resourceGroupName))
  add(query_568441, "api-version", newJString(apiVersion))
  add(path_568440, "subscriptionId", newJString(subscriptionId))
  add(path_568440, "alias", newJString(alias))
  result = call_568439.call(path_568440, query_568441, nil, nil, nil)

var disasterRecoveryConfigsDelete* = Call_DisasterRecoveryConfigsDelete_568430(
    name: "disasterRecoveryConfigsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}",
    validator: validate_DisasterRecoveryConfigsDelete_568431, base: "",
    url: url_DisasterRecoveryConfigsDelete_568432, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsListAuthorizationRules_568442 = ref object of OpenApiRestCall_567658
proc url_DisasterRecoveryConfigsListAuthorizationRules_568444(protocol: Scheme;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias"),
               (kind: ConstantSegment, value: "/AuthorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsListAuthorizationRules_568443(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a list of authorization rules for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568445 = path.getOrDefault("namespaceName")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "namespaceName", valid_568445
  var valid_568446 = path.getOrDefault("resourceGroupName")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "resourceGroupName", valid_568446
  var valid_568447 = path.getOrDefault("subscriptionId")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "subscriptionId", valid_568447
  var valid_568448 = path.getOrDefault("alias")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "alias", valid_568448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568449 = query.getOrDefault("api-version")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "api-version", valid_568449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568450: Call_DisasterRecoveryConfigsListAuthorizationRules_568442;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of authorization rules for a Namespace.
  ## 
  let valid = call_568450.validator(path, query, header, formData, body)
  let scheme = call_568450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568450.url(scheme.get, call_568450.host, call_568450.base,
                         call_568450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568450, url, valid)

proc call*(call_568451: Call_DisasterRecoveryConfigsListAuthorizationRules_568442;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsListAuthorizationRules
  ## Gets a list of authorization rules for a Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_568452 = newJObject()
  var query_568453 = newJObject()
  add(path_568452, "namespaceName", newJString(namespaceName))
  add(path_568452, "resourceGroupName", newJString(resourceGroupName))
  add(query_568453, "api-version", newJString(apiVersion))
  add(path_568452, "subscriptionId", newJString(subscriptionId))
  add(path_568452, "alias", newJString(alias))
  result = call_568451.call(path_568452, query_568453, nil, nil, nil)

var disasterRecoveryConfigsListAuthorizationRules* = Call_DisasterRecoveryConfigsListAuthorizationRules_568442(
    name: "disasterRecoveryConfigsListAuthorizationRules",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/AuthorizationRules",
    validator: validate_DisasterRecoveryConfigsListAuthorizationRules_568443,
    base: "", url: url_DisasterRecoveryConfigsListAuthorizationRules_568444,
    schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsGetAuthorizationRule_568454 = ref object of OpenApiRestCall_567658
proc url_DisasterRecoveryConfigsGetAuthorizationRule_568456(protocol: Scheme;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsGetAuthorizationRule_568455(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568457 = path.getOrDefault("namespaceName")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "namespaceName", valid_568457
  var valid_568458 = path.getOrDefault("resourceGroupName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "resourceGroupName", valid_568458
  var valid_568459 = path.getOrDefault("authorizationRuleName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "authorizationRuleName", valid_568459
  var valid_568460 = path.getOrDefault("subscriptionId")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "subscriptionId", valid_568460
  var valid_568461 = path.getOrDefault("alias")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "alias", valid_568461
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568462 = query.getOrDefault("api-version")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "api-version", valid_568462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568463: Call_DisasterRecoveryConfigsGetAuthorizationRule_568454;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ## 
  let valid = call_568463.validator(path, query, header, formData, body)
  let scheme = call_568463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568463.url(scheme.get, call_568463.host, call_568463.base,
                         call_568463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568463, url, valid)

proc call*(call_568464: Call_DisasterRecoveryConfigsGetAuthorizationRule_568454;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsGetAuthorizationRule
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_568465 = newJObject()
  var query_568466 = newJObject()
  add(path_568465, "namespaceName", newJString(namespaceName))
  add(path_568465, "resourceGroupName", newJString(resourceGroupName))
  add(query_568466, "api-version", newJString(apiVersion))
  add(path_568465, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568465, "subscriptionId", newJString(subscriptionId))
  add(path_568465, "alias", newJString(alias))
  result = call_568464.call(path_568465, query_568466, nil, nil, nil)

var disasterRecoveryConfigsGetAuthorizationRule* = Call_DisasterRecoveryConfigsGetAuthorizationRule_568454(
    name: "disasterRecoveryConfigsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_DisasterRecoveryConfigsGetAuthorizationRule_568455,
    base: "", url: url_DisasterRecoveryConfigsGetAuthorizationRule_568456,
    schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsListKeys_568467 = ref object of OpenApiRestCall_567658
proc url_DisasterRecoveryConfigsListKeys_568469(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
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

proc validate_DisasterRecoveryConfigsListKeys_568468(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the primary and secondary connection strings for the Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568470 = path.getOrDefault("namespaceName")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "namespaceName", valid_568470
  var valid_568471 = path.getOrDefault("resourceGroupName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "resourceGroupName", valid_568471
  var valid_568472 = path.getOrDefault("authorizationRuleName")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "authorizationRuleName", valid_568472
  var valid_568473 = path.getOrDefault("subscriptionId")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "subscriptionId", valid_568473
  var valid_568474 = path.getOrDefault("alias")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "alias", valid_568474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568475 = query.getOrDefault("api-version")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "api-version", valid_568475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568476: Call_DisasterRecoveryConfigsListKeys_568467;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the primary and secondary connection strings for the Namespace.
  ## 
  let valid = call_568476.validator(path, query, header, formData, body)
  let scheme = call_568476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568476.url(scheme.get, call_568476.host, call_568476.base,
                         call_568476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568476, url, valid)

proc call*(call_568477: Call_DisasterRecoveryConfigsListKeys_568467;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsListKeys
  ## Gets the primary and secondary connection strings for the Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_568478 = newJObject()
  var query_568479 = newJObject()
  add(path_568478, "namespaceName", newJString(namespaceName))
  add(path_568478, "resourceGroupName", newJString(resourceGroupName))
  add(query_568479, "api-version", newJString(apiVersion))
  add(path_568478, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568478, "subscriptionId", newJString(subscriptionId))
  add(path_568478, "alias", newJString(alias))
  result = call_568477.call(path_568478, query_568479, nil, nil, nil)

var disasterRecoveryConfigsListKeys* = Call_DisasterRecoveryConfigsListKeys_568467(
    name: "disasterRecoveryConfigsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_DisasterRecoveryConfigsListKeys_568468, base: "",
    url: url_DisasterRecoveryConfigsListKeys_568469, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsBreakPairing_568480 = ref object of OpenApiRestCall_567658
proc url_DisasterRecoveryConfigsBreakPairing_568482(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias"),
               (kind: ConstantSegment, value: "/breakPairing")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsBreakPairing_568481(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation disables the Disaster Recovery and stops replicating changes from primary to secondary namespaces
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568483 = path.getOrDefault("namespaceName")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "namespaceName", valid_568483
  var valid_568484 = path.getOrDefault("resourceGroupName")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "resourceGroupName", valid_568484
  var valid_568485 = path.getOrDefault("subscriptionId")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "subscriptionId", valid_568485
  var valid_568486 = path.getOrDefault("alias")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "alias", valid_568486
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568487 = query.getOrDefault("api-version")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "api-version", valid_568487
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568488: Call_DisasterRecoveryConfigsBreakPairing_568480;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation disables the Disaster Recovery and stops replicating changes from primary to secondary namespaces
  ## 
  let valid = call_568488.validator(path, query, header, formData, body)
  let scheme = call_568488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568488.url(scheme.get, call_568488.host, call_568488.base,
                         call_568488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568488, url, valid)

proc call*(call_568489: Call_DisasterRecoveryConfigsBreakPairing_568480;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsBreakPairing
  ## This operation disables the Disaster Recovery and stops replicating changes from primary to secondary namespaces
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_568490 = newJObject()
  var query_568491 = newJObject()
  add(path_568490, "namespaceName", newJString(namespaceName))
  add(path_568490, "resourceGroupName", newJString(resourceGroupName))
  add(query_568491, "api-version", newJString(apiVersion))
  add(path_568490, "subscriptionId", newJString(subscriptionId))
  add(path_568490, "alias", newJString(alias))
  result = call_568489.call(path_568490, query_568491, nil, nil, nil)

var disasterRecoveryConfigsBreakPairing* = Call_DisasterRecoveryConfigsBreakPairing_568480(
    name: "disasterRecoveryConfigsBreakPairing", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/breakPairing",
    validator: validate_DisasterRecoveryConfigsBreakPairing_568481, base: "",
    url: url_DisasterRecoveryConfigsBreakPairing_568482, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsFailOver_568492 = ref object of OpenApiRestCall_567658
proc url_DisasterRecoveryConfigsFailOver_568494(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias"),
               (kind: ConstantSegment, value: "/failover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsFailOver_568493(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Invokes GEO DR failover and reconfigure the alias to point to the secondary namespace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568495 = path.getOrDefault("namespaceName")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "namespaceName", valid_568495
  var valid_568496 = path.getOrDefault("resourceGroupName")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "resourceGroupName", valid_568496
  var valid_568497 = path.getOrDefault("subscriptionId")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "subscriptionId", valid_568497
  var valid_568498 = path.getOrDefault("alias")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "alias", valid_568498
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568499 = query.getOrDefault("api-version")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "api-version", valid_568499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568500: Call_DisasterRecoveryConfigsFailOver_568492;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Invokes GEO DR failover and reconfigure the alias to point to the secondary namespace
  ## 
  let valid = call_568500.validator(path, query, header, formData, body)
  let scheme = call_568500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568500.url(scheme.get, call_568500.host, call_568500.base,
                         call_568500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568500, url, valid)

proc call*(call_568501: Call_DisasterRecoveryConfigsFailOver_568492;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsFailOver
  ## Invokes GEO DR failover and reconfigure the alias to point to the secondary namespace
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_568502 = newJObject()
  var query_568503 = newJObject()
  add(path_568502, "namespaceName", newJString(namespaceName))
  add(path_568502, "resourceGroupName", newJString(resourceGroupName))
  add(query_568503, "api-version", newJString(apiVersion))
  add(path_568502, "subscriptionId", newJString(subscriptionId))
  add(path_568502, "alias", newJString(alias))
  result = call_568501.call(path_568502, query_568503, nil, nil, nil)

var disasterRecoveryConfigsFailOver* = Call_DisasterRecoveryConfigsFailOver_568492(
    name: "disasterRecoveryConfigsFailOver", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/failover",
    validator: validate_DisasterRecoveryConfigsFailOver_568493, base: "",
    url: url_DisasterRecoveryConfigsFailOver_568494, schemes: {Scheme.Https})
type
  Call_EventHubsListByNamespace_568504 = ref object of OpenApiRestCall_567658
proc url_EventHubsListByNamespace_568506(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsListByNamespace_568505(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the Event Hubs in a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  var valid_568510 = path.getOrDefault("subscriptionId")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "subscriptionId", valid_568510
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skip: JInt
  ##        : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568511 = query.getOrDefault("api-version")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "api-version", valid_568511
  var valid_568512 = query.getOrDefault("$top")
  valid_568512 = validateParameter(valid_568512, JInt, required = false, default = nil)
  if valid_568512 != nil:
    section.add "$top", valid_568512
  var valid_568513 = query.getOrDefault("$skip")
  valid_568513 = validateParameter(valid_568513, JInt, required = false, default = nil)
  if valid_568513 != nil:
    section.add "$skip", valid_568513
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568514: Call_EventHubsListByNamespace_568504; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the Event Hubs in a Namespace.
  ## 
  let valid = call_568514.validator(path, query, header, formData, body)
  let scheme = call_568514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568514.url(scheme.get, call_568514.host, call_568514.base,
                         call_568514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568514, url, valid)

proc call*(call_568515: Call_EventHubsListByNamespace_568504;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; Top: int = 0; Skip: int = 0): Recallable =
  ## eventHubsListByNamespace
  ## Gets all the Event Hubs in a Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skip: int
  ##       : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  var path_568516 = newJObject()
  var query_568517 = newJObject()
  add(path_568516, "namespaceName", newJString(namespaceName))
  add(path_568516, "resourceGroupName", newJString(resourceGroupName))
  add(query_568517, "api-version", newJString(apiVersion))
  add(path_568516, "subscriptionId", newJString(subscriptionId))
  add(query_568517, "$top", newJInt(Top))
  add(query_568517, "$skip", newJInt(Skip))
  result = call_568515.call(path_568516, query_568517, nil, nil, nil)

var eventHubsListByNamespace* = Call_EventHubsListByNamespace_568504(
    name: "eventHubsListByNamespace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs",
    validator: validate_EventHubsListByNamespace_568505, base: "",
    url: url_EventHubsListByNamespace_568506, schemes: {Scheme.Https})
type
  Call_EventHubsCreateOrUpdate_568530 = ref object of OpenApiRestCall_567658
proc url_EventHubsCreateOrUpdate_568532(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsCreateOrUpdate_568531(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a new Event Hub as a nested resource within a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568533 = path.getOrDefault("namespaceName")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "namespaceName", valid_568533
  var valid_568534 = path.getOrDefault("resourceGroupName")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "resourceGroupName", valid_568534
  var valid_568535 = path.getOrDefault("eventHubName")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "eventHubName", valid_568535
  var valid_568536 = path.getOrDefault("subscriptionId")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = nil)
  if valid_568536 != nil:
    section.add "subscriptionId", valid_568536
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create an Event Hub resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568539: Call_EventHubsCreateOrUpdate_568530; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a new Event Hub as a nested resource within a Namespace.
  ## 
  let valid = call_568539.validator(path, query, header, formData, body)
  let scheme = call_568539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568539.url(scheme.get, call_568539.host, call_568539.base,
                         call_568539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568539, url, valid)

proc call*(call_568540: Call_EventHubsCreateOrUpdate_568530; namespaceName: string;
          resourceGroupName: string; apiVersion: string; eventHubName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## eventHubsCreateOrUpdate
  ## Creates or updates a new Event Hub as a nested resource within a Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create an Event Hub resource.
  var path_568541 = newJObject()
  var query_568542 = newJObject()
  var body_568543 = newJObject()
  add(path_568541, "namespaceName", newJString(namespaceName))
  add(path_568541, "resourceGroupName", newJString(resourceGroupName))
  add(query_568542, "api-version", newJString(apiVersion))
  add(path_568541, "eventHubName", newJString(eventHubName))
  add(path_568541, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568543 = parameters
  result = call_568540.call(path_568541, query_568542, nil, nil, body_568543)

var eventHubsCreateOrUpdate* = Call_EventHubsCreateOrUpdate_568530(
    name: "eventHubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}",
    validator: validate_EventHubsCreateOrUpdate_568531, base: "",
    url: url_EventHubsCreateOrUpdate_568532, schemes: {Scheme.Https})
type
  Call_EventHubsGet_568518 = ref object of OpenApiRestCall_567658
proc url_EventHubsGet_568520(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsGet_568519(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an Event Hubs description for the specified Event Hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  var valid_568523 = path.getOrDefault("eventHubName")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "eventHubName", valid_568523
  var valid_568524 = path.getOrDefault("subscriptionId")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "subscriptionId", valid_568524
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568525 = query.getOrDefault("api-version")
  valid_568525 = validateParameter(valid_568525, JString, required = true,
                                 default = nil)
  if valid_568525 != nil:
    section.add "api-version", valid_568525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568526: Call_EventHubsGet_568518; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an Event Hubs description for the specified Event Hub.
  ## 
  let valid = call_568526.validator(path, query, header, formData, body)
  let scheme = call_568526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568526.url(scheme.get, call_568526.host, call_568526.base,
                         call_568526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568526, url, valid)

proc call*(call_568527: Call_EventHubsGet_568518; namespaceName: string;
          resourceGroupName: string; apiVersion: string; eventHubName: string;
          subscriptionId: string): Recallable =
  ## eventHubsGet
  ## Gets an Event Hubs description for the specified Event Hub.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568528 = newJObject()
  var query_568529 = newJObject()
  add(path_568528, "namespaceName", newJString(namespaceName))
  add(path_568528, "resourceGroupName", newJString(resourceGroupName))
  add(query_568529, "api-version", newJString(apiVersion))
  add(path_568528, "eventHubName", newJString(eventHubName))
  add(path_568528, "subscriptionId", newJString(subscriptionId))
  result = call_568527.call(path_568528, query_568529, nil, nil, nil)

var eventHubsGet* = Call_EventHubsGet_568518(name: "eventHubsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}",
    validator: validate_EventHubsGet_568519, base: "", url: url_EventHubsGet_568520,
    schemes: {Scheme.Https})
type
  Call_EventHubsDelete_568544 = ref object of OpenApiRestCall_567658
proc url_EventHubsDelete_568546(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsDelete_568545(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes an Event Hub from the specified Namespace and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568547 = path.getOrDefault("namespaceName")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "namespaceName", valid_568547
  var valid_568548 = path.getOrDefault("resourceGroupName")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "resourceGroupName", valid_568548
  var valid_568549 = path.getOrDefault("eventHubName")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "eventHubName", valid_568549
  var valid_568550 = path.getOrDefault("subscriptionId")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "subscriptionId", valid_568550
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568551 = query.getOrDefault("api-version")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "api-version", valid_568551
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568552: Call_EventHubsDelete_568544; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Event Hub from the specified Namespace and resource group.
  ## 
  let valid = call_568552.validator(path, query, header, formData, body)
  let scheme = call_568552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568552.url(scheme.get, call_568552.host, call_568552.base,
                         call_568552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568552, url, valid)

proc call*(call_568553: Call_EventHubsDelete_568544; namespaceName: string;
          resourceGroupName: string; apiVersion: string; eventHubName: string;
          subscriptionId: string): Recallable =
  ## eventHubsDelete
  ## Deletes an Event Hub from the specified Namespace and resource group.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568554 = newJObject()
  var query_568555 = newJObject()
  add(path_568554, "namespaceName", newJString(namespaceName))
  add(path_568554, "resourceGroupName", newJString(resourceGroupName))
  add(query_568555, "api-version", newJString(apiVersion))
  add(path_568554, "eventHubName", newJString(eventHubName))
  add(path_568554, "subscriptionId", newJString(subscriptionId))
  result = call_568553.call(path_568554, query_568555, nil, nil, nil)

var eventHubsDelete* = Call_EventHubsDelete_568544(name: "eventHubsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}",
    validator: validate_EventHubsDelete_568545, base: "", url: url_EventHubsDelete_568546,
    schemes: {Scheme.Https})
type
  Call_EventHubsListAuthorizationRules_568556 = ref object of OpenApiRestCall_567658
proc url_EventHubsListAuthorizationRules_568558(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/authorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsListAuthorizationRules_568557(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the authorization rules for an Event Hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568559 = path.getOrDefault("namespaceName")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "namespaceName", valid_568559
  var valid_568560 = path.getOrDefault("resourceGroupName")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "resourceGroupName", valid_568560
  var valid_568561 = path.getOrDefault("eventHubName")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "eventHubName", valid_568561
  var valid_568562 = path.getOrDefault("subscriptionId")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "subscriptionId", valid_568562
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568563 = query.getOrDefault("api-version")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "api-version", valid_568563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568564: Call_EventHubsListAuthorizationRules_568556;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for an Event Hub.
  ## 
  let valid = call_568564.validator(path, query, header, formData, body)
  let scheme = call_568564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568564.url(scheme.get, call_568564.host, call_568564.base,
                         call_568564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568564, url, valid)

proc call*(call_568565: Call_EventHubsListAuthorizationRules_568556;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          eventHubName: string; subscriptionId: string): Recallable =
  ## eventHubsListAuthorizationRules
  ## Gets the authorization rules for an Event Hub.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568566 = newJObject()
  var query_568567 = newJObject()
  add(path_568566, "namespaceName", newJString(namespaceName))
  add(path_568566, "resourceGroupName", newJString(resourceGroupName))
  add(query_568567, "api-version", newJString(apiVersion))
  add(path_568566, "eventHubName", newJString(eventHubName))
  add(path_568566, "subscriptionId", newJString(subscriptionId))
  result = call_568565.call(path_568566, query_568567, nil, nil, nil)

var eventHubsListAuthorizationRules* = Call_EventHubsListAuthorizationRules_568556(
    name: "eventHubsListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules",
    validator: validate_EventHubsListAuthorizationRules_568557, base: "",
    url: url_EventHubsListAuthorizationRules_568558, schemes: {Scheme.Https})
type
  Call_EventHubsCreateOrUpdateAuthorizationRule_568581 = ref object of OpenApiRestCall_567658
proc url_EventHubsCreateOrUpdateAuthorizationRule_568583(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsCreateOrUpdateAuthorizationRule_568582(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an AuthorizationRule for the specified Event Hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568584 = path.getOrDefault("namespaceName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "namespaceName", valid_568584
  var valid_568585 = path.getOrDefault("resourceGroupName")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "resourceGroupName", valid_568585
  var valid_568586 = path.getOrDefault("eventHubName")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "eventHubName", valid_568586
  var valid_568587 = path.getOrDefault("authorizationRuleName")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "authorizationRuleName", valid_568587
  var valid_568588 = path.getOrDefault("subscriptionId")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "subscriptionId", valid_568588
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568589 = query.getOrDefault("api-version")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "api-version", valid_568589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The shared access AuthorizationRule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568591: Call_EventHubsCreateOrUpdateAuthorizationRule_568581;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an AuthorizationRule for the specified Event Hub.
  ## 
  let valid = call_568591.validator(path, query, header, formData, body)
  let scheme = call_568591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568591.url(scheme.get, call_568591.host, call_568591.base,
                         call_568591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568591, url, valid)

proc call*(call_568592: Call_EventHubsCreateOrUpdateAuthorizationRule_568581;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          eventHubName: string; authorizationRuleName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## eventHubsCreateOrUpdateAuthorizationRule
  ## Creates or updates an AuthorizationRule for the specified Event Hub.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The shared access AuthorizationRule.
  var path_568593 = newJObject()
  var query_568594 = newJObject()
  var body_568595 = newJObject()
  add(path_568593, "namespaceName", newJString(namespaceName))
  add(path_568593, "resourceGroupName", newJString(resourceGroupName))
  add(query_568594, "api-version", newJString(apiVersion))
  add(path_568593, "eventHubName", newJString(eventHubName))
  add(path_568593, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568593, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568595 = parameters
  result = call_568592.call(path_568593, query_568594, nil, nil, body_568595)

var eventHubsCreateOrUpdateAuthorizationRule* = Call_EventHubsCreateOrUpdateAuthorizationRule_568581(
    name: "eventHubsCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}",
    validator: validate_EventHubsCreateOrUpdateAuthorizationRule_568582, base: "",
    url: url_EventHubsCreateOrUpdateAuthorizationRule_568583,
    schemes: {Scheme.Https})
type
  Call_EventHubsGetAuthorizationRule_568568 = ref object of OpenApiRestCall_567658
proc url_EventHubsGetAuthorizationRule_568570(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsGetAuthorizationRule_568569(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an AuthorizationRule for an Event Hub by rule name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
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
  var valid_568573 = path.getOrDefault("eventHubName")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "eventHubName", valid_568573
  var valid_568574 = path.getOrDefault("authorizationRuleName")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "authorizationRuleName", valid_568574
  var valid_568575 = path.getOrDefault("subscriptionId")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "subscriptionId", valid_568575
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568576 = query.getOrDefault("api-version")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "api-version", valid_568576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568577: Call_EventHubsGetAuthorizationRule_568568; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an AuthorizationRule for an Event Hub by rule name.
  ## 
  let valid = call_568577.validator(path, query, header, formData, body)
  let scheme = call_568577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568577.url(scheme.get, call_568577.host, call_568577.base,
                         call_568577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568577, url, valid)

proc call*(call_568578: Call_EventHubsGetAuthorizationRule_568568;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          eventHubName: string; authorizationRuleName: string;
          subscriptionId: string): Recallable =
  ## eventHubsGetAuthorizationRule
  ## Gets an AuthorizationRule for an Event Hub by rule name.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568579 = newJObject()
  var query_568580 = newJObject()
  add(path_568579, "namespaceName", newJString(namespaceName))
  add(path_568579, "resourceGroupName", newJString(resourceGroupName))
  add(query_568580, "api-version", newJString(apiVersion))
  add(path_568579, "eventHubName", newJString(eventHubName))
  add(path_568579, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568579, "subscriptionId", newJString(subscriptionId))
  result = call_568578.call(path_568579, query_568580, nil, nil, nil)

var eventHubsGetAuthorizationRule* = Call_EventHubsGetAuthorizationRule_568568(
    name: "eventHubsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}",
    validator: validate_EventHubsGetAuthorizationRule_568569, base: "",
    url: url_EventHubsGetAuthorizationRule_568570, schemes: {Scheme.Https})
type
  Call_EventHubsDeleteAuthorizationRule_568596 = ref object of OpenApiRestCall_567658
proc url_EventHubsDeleteAuthorizationRule_568598(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsDeleteAuthorizationRule_568597(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an Event Hub AuthorizationRule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568599 = path.getOrDefault("namespaceName")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "namespaceName", valid_568599
  var valid_568600 = path.getOrDefault("resourceGroupName")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "resourceGroupName", valid_568600
  var valid_568601 = path.getOrDefault("eventHubName")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "eventHubName", valid_568601
  var valid_568602 = path.getOrDefault("authorizationRuleName")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "authorizationRuleName", valid_568602
  var valid_568603 = path.getOrDefault("subscriptionId")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "subscriptionId", valid_568603
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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

proc call*(call_568605: Call_EventHubsDeleteAuthorizationRule_568596;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an Event Hub AuthorizationRule.
  ## 
  let valid = call_568605.validator(path, query, header, formData, body)
  let scheme = call_568605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568605.url(scheme.get, call_568605.host, call_568605.base,
                         call_568605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568605, url, valid)

proc call*(call_568606: Call_EventHubsDeleteAuthorizationRule_568596;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          eventHubName: string; authorizationRuleName: string;
          subscriptionId: string): Recallable =
  ## eventHubsDeleteAuthorizationRule
  ## Deletes an Event Hub AuthorizationRule.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568607 = newJObject()
  var query_568608 = newJObject()
  add(path_568607, "namespaceName", newJString(namespaceName))
  add(path_568607, "resourceGroupName", newJString(resourceGroupName))
  add(query_568608, "api-version", newJString(apiVersion))
  add(path_568607, "eventHubName", newJString(eventHubName))
  add(path_568607, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568607, "subscriptionId", newJString(subscriptionId))
  result = call_568606.call(path_568607, query_568608, nil, nil, nil)

var eventHubsDeleteAuthorizationRule* = Call_EventHubsDeleteAuthorizationRule_568596(
    name: "eventHubsDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}",
    validator: validate_EventHubsDeleteAuthorizationRule_568597, base: "",
    url: url_EventHubsDeleteAuthorizationRule_568598, schemes: {Scheme.Https})
type
  Call_EventHubsListKeys_568609 = ref object of OpenApiRestCall_567658
proc url_EventHubsListKeys_568611(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/ListKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsListKeys_568610(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the ACS and SAS connection strings for the Event Hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  var valid_568614 = path.getOrDefault("eventHubName")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "eventHubName", valid_568614
  var valid_568615 = path.getOrDefault("authorizationRuleName")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "authorizationRuleName", valid_568615
  var valid_568616 = path.getOrDefault("subscriptionId")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "subscriptionId", valid_568616
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568617 = query.getOrDefault("api-version")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "api-version", valid_568617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568618: Call_EventHubsListKeys_568609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the ACS and SAS connection strings for the Event Hub.
  ## 
  let valid = call_568618.validator(path, query, header, formData, body)
  let scheme = call_568618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568618.url(scheme.get, call_568618.host, call_568618.base,
                         call_568618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568618, url, valid)

proc call*(call_568619: Call_EventHubsListKeys_568609; namespaceName: string;
          resourceGroupName: string; apiVersion: string; eventHubName: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## eventHubsListKeys
  ## Gets the ACS and SAS connection strings for the Event Hub.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568620 = newJObject()
  var query_568621 = newJObject()
  add(path_568620, "namespaceName", newJString(namespaceName))
  add(path_568620, "resourceGroupName", newJString(resourceGroupName))
  add(query_568621, "api-version", newJString(apiVersion))
  add(path_568620, "eventHubName", newJString(eventHubName))
  add(path_568620, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568620, "subscriptionId", newJString(subscriptionId))
  result = call_568619.call(path_568620, query_568621, nil, nil, nil)

var eventHubsListKeys* = Call_EventHubsListKeys_568609(name: "eventHubsListKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}/ListKeys",
    validator: validate_EventHubsListKeys_568610, base: "",
    url: url_EventHubsListKeys_568611, schemes: {Scheme.Https})
type
  Call_EventHubsRegenerateKeys_568622 = ref object of OpenApiRestCall_567658
proc url_EventHubsRegenerateKeys_568624(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsRegenerateKeys_568623(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the ACS and SAS connection strings for the Event Hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568625 = path.getOrDefault("namespaceName")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "namespaceName", valid_568625
  var valid_568626 = path.getOrDefault("resourceGroupName")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "resourceGroupName", valid_568626
  var valid_568627 = path.getOrDefault("eventHubName")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "eventHubName", valid_568627
  var valid_568628 = path.getOrDefault("authorizationRuleName")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "authorizationRuleName", valid_568628
  var valid_568629 = path.getOrDefault("subscriptionId")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "subscriptionId", valid_568629
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568630 = query.getOrDefault("api-version")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "api-version", valid_568630
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the AuthorizationRule Keys (PrimaryKey/SecondaryKey).
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568632: Call_EventHubsRegenerateKeys_568622; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the ACS and SAS connection strings for the Event Hub.
  ## 
  let valid = call_568632.validator(path, query, header, formData, body)
  let scheme = call_568632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568632.url(scheme.get, call_568632.host, call_568632.base,
                         call_568632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568632, url, valid)

proc call*(call_568633: Call_EventHubsRegenerateKeys_568622; namespaceName: string;
          resourceGroupName: string; apiVersion: string; eventHubName: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## eventHubsRegenerateKeys
  ## Regenerates the ACS and SAS connection strings for the Event Hub.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the AuthorizationRule Keys (PrimaryKey/SecondaryKey).
  var path_568634 = newJObject()
  var query_568635 = newJObject()
  var body_568636 = newJObject()
  add(path_568634, "namespaceName", newJString(namespaceName))
  add(path_568634, "resourceGroupName", newJString(resourceGroupName))
  add(query_568635, "api-version", newJString(apiVersion))
  add(path_568634, "eventHubName", newJString(eventHubName))
  add(path_568634, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568634, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568636 = parameters
  result = call_568633.call(path_568634, query_568635, nil, nil, body_568636)

var eventHubsRegenerateKeys* = Call_EventHubsRegenerateKeys_568622(
    name: "eventHubsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_EventHubsRegenerateKeys_568623, base: "",
    url: url_EventHubsRegenerateKeys_568624, schemes: {Scheme.Https})
type
  Call_ConsumerGroupsListByEventHub_568637 = ref object of OpenApiRestCall_567658
proc url_ConsumerGroupsListByEventHub_568639(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/consumergroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumerGroupsListByEventHub_568638(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the consumer groups in a Namespace. An empty feed is returned if no consumer group exists in the Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568640 = path.getOrDefault("namespaceName")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "namespaceName", valid_568640
  var valid_568641 = path.getOrDefault("resourceGroupName")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "resourceGroupName", valid_568641
  var valid_568642 = path.getOrDefault("eventHubName")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "eventHubName", valid_568642
  var valid_568643 = path.getOrDefault("subscriptionId")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "subscriptionId", valid_568643
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skip: JInt
  ##        : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568644 = query.getOrDefault("api-version")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "api-version", valid_568644
  var valid_568645 = query.getOrDefault("$top")
  valid_568645 = validateParameter(valid_568645, JInt, required = false, default = nil)
  if valid_568645 != nil:
    section.add "$top", valid_568645
  var valid_568646 = query.getOrDefault("$skip")
  valid_568646 = validateParameter(valid_568646, JInt, required = false, default = nil)
  if valid_568646 != nil:
    section.add "$skip", valid_568646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568647: Call_ConsumerGroupsListByEventHub_568637; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the consumer groups in a Namespace. An empty feed is returned if no consumer group exists in the Namespace.
  ## 
  let valid = call_568647.validator(path, query, header, formData, body)
  let scheme = call_568647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568647.url(scheme.get, call_568647.host, call_568647.base,
                         call_568647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568647, url, valid)

proc call*(call_568648: Call_ConsumerGroupsListByEventHub_568637;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          eventHubName: string; subscriptionId: string; Top: int = 0; Skip: int = 0): Recallable =
  ## consumerGroupsListByEventHub
  ## Gets all the consumer groups in a Namespace. An empty feed is returned if no consumer group exists in the Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skip: int
  ##       : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  var path_568649 = newJObject()
  var query_568650 = newJObject()
  add(path_568649, "namespaceName", newJString(namespaceName))
  add(path_568649, "resourceGroupName", newJString(resourceGroupName))
  add(query_568650, "api-version", newJString(apiVersion))
  add(path_568649, "eventHubName", newJString(eventHubName))
  add(path_568649, "subscriptionId", newJString(subscriptionId))
  add(query_568650, "$top", newJInt(Top))
  add(query_568650, "$skip", newJInt(Skip))
  result = call_568648.call(path_568649, query_568650, nil, nil, nil)

var consumerGroupsListByEventHub* = Call_ConsumerGroupsListByEventHub_568637(
    name: "consumerGroupsListByEventHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/consumergroups",
    validator: validate_ConsumerGroupsListByEventHub_568638, base: "",
    url: url_ConsumerGroupsListByEventHub_568639, schemes: {Scheme.Https})
type
  Call_ConsumerGroupsCreateOrUpdate_568664 = ref object of OpenApiRestCall_567658
proc url_ConsumerGroupsCreateOrUpdate_568666(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "consumerGroupName" in path,
        "`consumerGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/consumergroups/"),
               (kind: VariableSegment, value: "consumerGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumerGroupsCreateOrUpdate_568665(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an Event Hubs consumer group as a nested resource within a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   consumerGroupName: JString (required)
  ##                    : The consumer group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568667 = path.getOrDefault("namespaceName")
  valid_568667 = validateParameter(valid_568667, JString, required = true,
                                 default = nil)
  if valid_568667 != nil:
    section.add "namespaceName", valid_568667
  var valid_568668 = path.getOrDefault("resourceGroupName")
  valid_568668 = validateParameter(valid_568668, JString, required = true,
                                 default = nil)
  if valid_568668 != nil:
    section.add "resourceGroupName", valid_568668
  var valid_568669 = path.getOrDefault("eventHubName")
  valid_568669 = validateParameter(valid_568669, JString, required = true,
                                 default = nil)
  if valid_568669 != nil:
    section.add "eventHubName", valid_568669
  var valid_568670 = path.getOrDefault("subscriptionId")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "subscriptionId", valid_568670
  var valid_568671 = path.getOrDefault("consumerGroupName")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "consumerGroupName", valid_568671
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568672 = query.getOrDefault("api-version")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "api-version", valid_568672
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update a consumer group resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568674: Call_ConsumerGroupsCreateOrUpdate_568664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an Event Hubs consumer group as a nested resource within a Namespace.
  ## 
  let valid = call_568674.validator(path, query, header, formData, body)
  let scheme = call_568674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568674.url(scheme.get, call_568674.host, call_568674.base,
                         call_568674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568674, url, valid)

proc call*(call_568675: Call_ConsumerGroupsCreateOrUpdate_568664;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          eventHubName: string; subscriptionId: string; consumerGroupName: string;
          parameters: JsonNode): Recallable =
  ## consumerGroupsCreateOrUpdate
  ## Creates or updates an Event Hubs consumer group as a nested resource within a Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   consumerGroupName: string (required)
  ##                    : The consumer group name
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update a consumer group resource.
  var path_568676 = newJObject()
  var query_568677 = newJObject()
  var body_568678 = newJObject()
  add(path_568676, "namespaceName", newJString(namespaceName))
  add(path_568676, "resourceGroupName", newJString(resourceGroupName))
  add(query_568677, "api-version", newJString(apiVersion))
  add(path_568676, "eventHubName", newJString(eventHubName))
  add(path_568676, "subscriptionId", newJString(subscriptionId))
  add(path_568676, "consumerGroupName", newJString(consumerGroupName))
  if parameters != nil:
    body_568678 = parameters
  result = call_568675.call(path_568676, query_568677, nil, nil, body_568678)

var consumerGroupsCreateOrUpdate* = Call_ConsumerGroupsCreateOrUpdate_568664(
    name: "consumerGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/consumergroups/{consumerGroupName}",
    validator: validate_ConsumerGroupsCreateOrUpdate_568665, base: "",
    url: url_ConsumerGroupsCreateOrUpdate_568666, schemes: {Scheme.Https})
type
  Call_ConsumerGroupsGet_568651 = ref object of OpenApiRestCall_567658
proc url_ConsumerGroupsGet_568653(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "consumerGroupName" in path,
        "`consumerGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/consumergroups/"),
               (kind: VariableSegment, value: "consumerGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumerGroupsGet_568652(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a description for the specified consumer group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   consumerGroupName: JString (required)
  ##                    : The consumer group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568654 = path.getOrDefault("namespaceName")
  valid_568654 = validateParameter(valid_568654, JString, required = true,
                                 default = nil)
  if valid_568654 != nil:
    section.add "namespaceName", valid_568654
  var valid_568655 = path.getOrDefault("resourceGroupName")
  valid_568655 = validateParameter(valid_568655, JString, required = true,
                                 default = nil)
  if valid_568655 != nil:
    section.add "resourceGroupName", valid_568655
  var valid_568656 = path.getOrDefault("eventHubName")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "eventHubName", valid_568656
  var valid_568657 = path.getOrDefault("subscriptionId")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "subscriptionId", valid_568657
  var valid_568658 = path.getOrDefault("consumerGroupName")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "consumerGroupName", valid_568658
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568659 = query.getOrDefault("api-version")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "api-version", valid_568659
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568660: Call_ConsumerGroupsGet_568651; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a description for the specified consumer group.
  ## 
  let valid = call_568660.validator(path, query, header, formData, body)
  let scheme = call_568660.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568660.url(scheme.get, call_568660.host, call_568660.base,
                         call_568660.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568660, url, valid)

proc call*(call_568661: Call_ConsumerGroupsGet_568651; namespaceName: string;
          resourceGroupName: string; apiVersion: string; eventHubName: string;
          subscriptionId: string; consumerGroupName: string): Recallable =
  ## consumerGroupsGet
  ## Gets a description for the specified consumer group.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   consumerGroupName: string (required)
  ##                    : The consumer group name
  var path_568662 = newJObject()
  var query_568663 = newJObject()
  add(path_568662, "namespaceName", newJString(namespaceName))
  add(path_568662, "resourceGroupName", newJString(resourceGroupName))
  add(query_568663, "api-version", newJString(apiVersion))
  add(path_568662, "eventHubName", newJString(eventHubName))
  add(path_568662, "subscriptionId", newJString(subscriptionId))
  add(path_568662, "consumerGroupName", newJString(consumerGroupName))
  result = call_568661.call(path_568662, query_568663, nil, nil, nil)

var consumerGroupsGet* = Call_ConsumerGroupsGet_568651(name: "consumerGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/consumergroups/{consumerGroupName}",
    validator: validate_ConsumerGroupsGet_568652, base: "",
    url: url_ConsumerGroupsGet_568653, schemes: {Scheme.Https})
type
  Call_ConsumerGroupsDelete_568679 = ref object of OpenApiRestCall_567658
proc url_ConsumerGroupsDelete_568681(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "consumerGroupName" in path,
        "`consumerGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/consumergroups/"),
               (kind: VariableSegment, value: "consumerGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumerGroupsDelete_568680(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a consumer group from the specified Event Hub and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   consumerGroupName: JString (required)
  ##                    : The consumer group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568682 = path.getOrDefault("namespaceName")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "namespaceName", valid_568682
  var valid_568683 = path.getOrDefault("resourceGroupName")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "resourceGroupName", valid_568683
  var valid_568684 = path.getOrDefault("eventHubName")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "eventHubName", valid_568684
  var valid_568685 = path.getOrDefault("subscriptionId")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "subscriptionId", valid_568685
  var valid_568686 = path.getOrDefault("consumerGroupName")
  valid_568686 = validateParameter(valid_568686, JString, required = true,
                                 default = nil)
  if valid_568686 != nil:
    section.add "consumerGroupName", valid_568686
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568687 = query.getOrDefault("api-version")
  valid_568687 = validateParameter(valid_568687, JString, required = true,
                                 default = nil)
  if valid_568687 != nil:
    section.add "api-version", valid_568687
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568688: Call_ConsumerGroupsDelete_568679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a consumer group from the specified Event Hub and resource group.
  ## 
  let valid = call_568688.validator(path, query, header, formData, body)
  let scheme = call_568688.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568688.url(scheme.get, call_568688.host, call_568688.base,
                         call_568688.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568688, url, valid)

proc call*(call_568689: Call_ConsumerGroupsDelete_568679; namespaceName: string;
          resourceGroupName: string; apiVersion: string; eventHubName: string;
          subscriptionId: string; consumerGroupName: string): Recallable =
  ## consumerGroupsDelete
  ## Deletes a consumer group from the specified Event Hub and resource group.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   consumerGroupName: string (required)
  ##                    : The consumer group name
  var path_568690 = newJObject()
  var query_568691 = newJObject()
  add(path_568690, "namespaceName", newJString(namespaceName))
  add(path_568690, "resourceGroupName", newJString(resourceGroupName))
  add(query_568691, "api-version", newJString(apiVersion))
  add(path_568690, "eventHubName", newJString(eventHubName))
  add(path_568690, "subscriptionId", newJString(subscriptionId))
  add(path_568690, "consumerGroupName", newJString(consumerGroupName))
  result = call_568689.call(path_568690, query_568691, nil, nil, nil)

var consumerGroupsDelete* = Call_ConsumerGroupsDelete_568679(
    name: "consumerGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/consumergroups/{consumerGroupName}",
    validator: validate_ConsumerGroupsDelete_568680, base: "",
    url: url_ConsumerGroupsDelete_568681, schemes: {Scheme.Https})
type
  Call_NamespacesGetMessagingPlan_568692 = ref object of OpenApiRestCall_567658
proc url_NamespacesGetMessagingPlan_568694(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/messagingplan")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGetMessagingPlan_568693(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets messaging plan for specified namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568695 = path.getOrDefault("namespaceName")
  valid_568695 = validateParameter(valid_568695, JString, required = true,
                                 default = nil)
  if valid_568695 != nil:
    section.add "namespaceName", valid_568695
  var valid_568696 = path.getOrDefault("resourceGroupName")
  valid_568696 = validateParameter(valid_568696, JString, required = true,
                                 default = nil)
  if valid_568696 != nil:
    section.add "resourceGroupName", valid_568696
  var valid_568697 = path.getOrDefault("subscriptionId")
  valid_568697 = validateParameter(valid_568697, JString, required = true,
                                 default = nil)
  if valid_568697 != nil:
    section.add "subscriptionId", valid_568697
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568698 = query.getOrDefault("api-version")
  valid_568698 = validateParameter(valid_568698, JString, required = true,
                                 default = nil)
  if valid_568698 != nil:
    section.add "api-version", valid_568698
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568699: Call_NamespacesGetMessagingPlan_568692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets messaging plan for specified namespace.
  ## 
  let valid = call_568699.validator(path, query, header, formData, body)
  let scheme = call_568699.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568699.url(scheme.get, call_568699.host, call_568699.base,
                         call_568699.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568699, url, valid)

proc call*(call_568700: Call_NamespacesGetMessagingPlan_568692;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesGetMessagingPlan
  ## Gets messaging plan for specified namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568701 = newJObject()
  var query_568702 = newJObject()
  add(path_568701, "namespaceName", newJString(namespaceName))
  add(path_568701, "resourceGroupName", newJString(resourceGroupName))
  add(query_568702, "api-version", newJString(apiVersion))
  add(path_568701, "subscriptionId", newJString(subscriptionId))
  result = call_568700.call(path_568701, query_568702, nil, nil, nil)

var namespacesGetMessagingPlan* = Call_NamespacesGetMessagingPlan_568692(
    name: "namespacesGetMessagingPlan", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/messagingplan",
    validator: validate_NamespacesGetMessagingPlan_568693, base: "",
    url: url_NamespacesGetMessagingPlan_568694, schemes: {Scheme.Https})
type
  Call_NamespacesListNetworkRuleSets_568703 = ref object of OpenApiRestCall_567658
proc url_NamespacesListNetworkRuleSets_568705(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/networkRuleSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListNetworkRuleSets_568704(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets list of NetworkRuleSet for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568706 = path.getOrDefault("namespaceName")
  valid_568706 = validateParameter(valid_568706, JString, required = true,
                                 default = nil)
  if valid_568706 != nil:
    section.add "namespaceName", valid_568706
  var valid_568707 = path.getOrDefault("resourceGroupName")
  valid_568707 = validateParameter(valid_568707, JString, required = true,
                                 default = nil)
  if valid_568707 != nil:
    section.add "resourceGroupName", valid_568707
  var valid_568708 = path.getOrDefault("subscriptionId")
  valid_568708 = validateParameter(valid_568708, JString, required = true,
                                 default = nil)
  if valid_568708 != nil:
    section.add "subscriptionId", valid_568708
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568709 = query.getOrDefault("api-version")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = nil)
  if valid_568709 != nil:
    section.add "api-version", valid_568709
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568710: Call_NamespacesListNetworkRuleSets_568703; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets list of NetworkRuleSet for a Namespace.
  ## 
  let valid = call_568710.validator(path, query, header, formData, body)
  let scheme = call_568710.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568710.url(scheme.get, call_568710.host, call_568710.base,
                         call_568710.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568710, url, valid)

proc call*(call_568711: Call_NamespacesListNetworkRuleSets_568703;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesListNetworkRuleSets
  ## Gets list of NetworkRuleSet for a Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568712 = newJObject()
  var query_568713 = newJObject()
  add(path_568712, "namespaceName", newJString(namespaceName))
  add(path_568712, "resourceGroupName", newJString(resourceGroupName))
  add(query_568713, "api-version", newJString(apiVersion))
  add(path_568712, "subscriptionId", newJString(subscriptionId))
  result = call_568711.call(path_568712, query_568713, nil, nil, nil)

var namespacesListNetworkRuleSets* = Call_NamespacesListNetworkRuleSets_568703(
    name: "namespacesListNetworkRuleSets", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/networkRuleSets",
    validator: validate_NamespacesListNetworkRuleSets_568704, base: "",
    url: url_NamespacesListNetworkRuleSets_568705, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateNetworkRuleSet_568725 = ref object of OpenApiRestCall_567658
proc url_NamespacesCreateOrUpdateNetworkRuleSet_568727(protocol: Scheme;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/networkRuleSets/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdateNetworkRuleSet_568726(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update NetworkRuleSet for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568728 = path.getOrDefault("namespaceName")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "namespaceName", valid_568728
  var valid_568729 = path.getOrDefault("resourceGroupName")
  valid_568729 = validateParameter(valid_568729, JString, required = true,
                                 default = nil)
  if valid_568729 != nil:
    section.add "resourceGroupName", valid_568729
  var valid_568730 = path.getOrDefault("subscriptionId")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "subscriptionId", valid_568730
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568731 = query.getOrDefault("api-version")
  valid_568731 = validateParameter(valid_568731, JString, required = true,
                                 default = nil)
  if valid_568731 != nil:
    section.add "api-version", valid_568731
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

proc call*(call_568733: Call_NamespacesCreateOrUpdateNetworkRuleSet_568725;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update NetworkRuleSet for a Namespace.
  ## 
  let valid = call_568733.validator(path, query, header, formData, body)
  let scheme = call_568733.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568733.url(scheme.get, call_568733.host, call_568733.base,
                         call_568733.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568733, url, valid)

proc call*(call_568734: Call_NamespacesCreateOrUpdateNetworkRuleSet_568725;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateNetworkRuleSet
  ## Create or update NetworkRuleSet for a Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The Namespace IpFilterRule.
  var path_568735 = newJObject()
  var query_568736 = newJObject()
  var body_568737 = newJObject()
  add(path_568735, "namespaceName", newJString(namespaceName))
  add(path_568735, "resourceGroupName", newJString(resourceGroupName))
  add(query_568736, "api-version", newJString(apiVersion))
  add(path_568735, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568737 = parameters
  result = call_568734.call(path_568735, query_568736, nil, nil, body_568737)

var namespacesCreateOrUpdateNetworkRuleSet* = Call_NamespacesCreateOrUpdateNetworkRuleSet_568725(
    name: "namespacesCreateOrUpdateNetworkRuleSet", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/networkRuleSets/default",
    validator: validate_NamespacesCreateOrUpdateNetworkRuleSet_568726, base: "",
    url: url_NamespacesCreateOrUpdateNetworkRuleSet_568727,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetNetworkRuleSet_568714 = ref object of OpenApiRestCall_567658
proc url_NamespacesGetNetworkRuleSet_568716(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/networkRuleSets/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGetNetworkRuleSet_568715(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets NetworkRuleSet for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568717 = path.getOrDefault("namespaceName")
  valid_568717 = validateParameter(valid_568717, JString, required = true,
                                 default = nil)
  if valid_568717 != nil:
    section.add "namespaceName", valid_568717
  var valid_568718 = path.getOrDefault("resourceGroupName")
  valid_568718 = validateParameter(valid_568718, JString, required = true,
                                 default = nil)
  if valid_568718 != nil:
    section.add "resourceGroupName", valid_568718
  var valid_568719 = path.getOrDefault("subscriptionId")
  valid_568719 = validateParameter(valid_568719, JString, required = true,
                                 default = nil)
  if valid_568719 != nil:
    section.add "subscriptionId", valid_568719
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568720 = query.getOrDefault("api-version")
  valid_568720 = validateParameter(valid_568720, JString, required = true,
                                 default = nil)
  if valid_568720 != nil:
    section.add "api-version", valid_568720
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568721: Call_NamespacesGetNetworkRuleSet_568714; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets NetworkRuleSet for a Namespace.
  ## 
  let valid = call_568721.validator(path, query, header, formData, body)
  let scheme = call_568721.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568721.url(scheme.get, call_568721.host, call_568721.base,
                         call_568721.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568721, url, valid)

proc call*(call_568722: Call_NamespacesGetNetworkRuleSet_568714;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesGetNetworkRuleSet
  ## Gets NetworkRuleSet for a Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568723 = newJObject()
  var query_568724 = newJObject()
  add(path_568723, "namespaceName", newJString(namespaceName))
  add(path_568723, "resourceGroupName", newJString(resourceGroupName))
  add(query_568724, "api-version", newJString(apiVersion))
  add(path_568723, "subscriptionId", newJString(subscriptionId))
  result = call_568722.call(path_568723, query_568724, nil, nil, nil)

var namespacesGetNetworkRuleSet* = Call_NamespacesGetNetworkRuleSet_568714(
    name: "namespacesGetNetworkRuleSet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/networkRuleSets/default",
    validator: validate_NamespacesGetNetworkRuleSet_568715, base: "",
    url: url_NamespacesGetNetworkRuleSet_568716, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
