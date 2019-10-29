
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "eventhub-EventHub"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563778 = ref object of OpenApiRestCall_563556
proc url_OperationsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563779(path: JsonNode; query: JsonNode;
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
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "api-version", valid_563941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_OperationsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Event Hub REST API operations.
  ## 
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_OperationsList_563778; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Event Hub REST API operations.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.EventHub/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_NamespacesCheckNameAvailability_564076 = ref object of OpenApiRestCall_563556
proc url_NamespacesCheckNameAvailability_564078(protocol: Scheme; host: string;
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

proc validate_NamespacesCheckNameAvailability_564077(path: JsonNode;
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
  var valid_564110 = path.getOrDefault("subscriptionId")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "subscriptionId", valid_564110
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564111 = query.getOrDefault("api-version")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "api-version", valid_564111
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

proc call*(call_564113: Call_NamespacesCheckNameAvailability_564076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give Namespace name availability.
  ## 
  let valid = call_564113.validator(path, query, header, formData, body)
  let scheme = call_564113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564113.url(scheme.get, call_564113.host, call_564113.base,
                         call_564113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564113, url, valid)

proc call*(call_564114: Call_NamespacesCheckNameAvailability_564076;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCheckNameAvailability
  ## Check the give Namespace name availability.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given Namespace name
  var path_564115 = newJObject()
  var query_564116 = newJObject()
  var body_564117 = newJObject()
  add(query_564116, "api-version", newJString(apiVersion))
  add(path_564115, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564117 = parameters
  result = call_564114.call(path_564115, query_564116, nil, nil, body_564117)

var namespacesCheckNameAvailability* = Call_NamespacesCheckNameAvailability_564076(
    name: "namespacesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventHub/CheckNameAvailability",
    validator: validate_NamespacesCheckNameAvailability_564077, base: "",
    url: url_NamespacesCheckNameAvailability_564078, schemes: {Scheme.Https})
type
  Call_NamespacesList_564118 = ref object of OpenApiRestCall_563556
proc url_NamespacesList_564120(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesList_564119(path: JsonNode; query: JsonNode;
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
  var valid_564121 = path.getOrDefault("subscriptionId")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "subscriptionId", valid_564121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564122 = query.getOrDefault("api-version")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "api-version", valid_564122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564123: Call_NamespacesList_564118; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available Namespaces within a subscription, irrespective of the resource groups.
  ## 
  let valid = call_564123.validator(path, query, header, formData, body)
  let scheme = call_564123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564123.url(scheme.get, call_564123.host, call_564123.base,
                         call_564123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564123, url, valid)

proc call*(call_564124: Call_NamespacesList_564118; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesList
  ## Lists all the available Namespaces within a subscription, irrespective of the resource groups.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564125 = newJObject()
  var query_564126 = newJObject()
  add(query_564126, "api-version", newJString(apiVersion))
  add(path_564125, "subscriptionId", newJString(subscriptionId))
  result = call_564124.call(path_564125, query_564126, nil, nil, nil)

var namespacesList* = Call_NamespacesList_564118(name: "namespacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventHub/namespaces",
    validator: validate_NamespacesList_564119, base: "", url: url_NamespacesList_564120,
    schemes: {Scheme.Https})
type
  Call_RegionsListBySku_564127 = ref object of OpenApiRestCall_563556
proc url_RegionsListBySku_564129(protocol: Scheme; host: string; base: string;
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

proc validate_RegionsListBySku_564128(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the available Regions for a given sku
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sku: JString (required)
  ##      : The sku type.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sku` field"
  var valid_564130 = path.getOrDefault("sku")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "sku", valid_564130
  var valid_564131 = path.getOrDefault("subscriptionId")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "subscriptionId", valid_564131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564132 = query.getOrDefault("api-version")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "api-version", valid_564132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_RegionsListBySku_564127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the available Regions for a given sku
  ## 
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_RegionsListBySku_564127; apiVersion: string;
          sku: string; subscriptionId: string): Recallable =
  ## regionsListBySku
  ## Gets the available Regions for a given sku
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   sku: string (required)
  ##      : The sku type.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  add(query_564136, "api-version", newJString(apiVersion))
  add(path_564135, "sku", newJString(sku))
  add(path_564135, "subscriptionId", newJString(subscriptionId))
  result = call_564134.call(path_564135, query_564136, nil, nil, nil)

var regionsListBySku* = Call_RegionsListBySku_564127(name: "regionsListBySku",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventHub/sku/{sku}/regions",
    validator: validate_RegionsListBySku_564128, base: "",
    url: url_RegionsListBySku_564129, schemes: {Scheme.Https})
type
  Call_NamespacesListByResourceGroup_564137 = ref object of OpenApiRestCall_563556
proc url_NamespacesListByResourceGroup_564139(protocol: Scheme; host: string;
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

proc validate_NamespacesListByResourceGroup_564138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the available Namespaces within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564140 = path.getOrDefault("subscriptionId")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "subscriptionId", valid_564140
  var valid_564141 = path.getOrDefault("resourceGroupName")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "resourceGroupName", valid_564141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564142 = query.getOrDefault("api-version")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "api-version", valid_564142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564143: Call_NamespacesListByResourceGroup_564137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available Namespaces within a resource group.
  ## 
  let valid = call_564143.validator(path, query, header, formData, body)
  let scheme = call_564143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564143.url(scheme.get, call_564143.host, call_564143.base,
                         call_564143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564143, url, valid)

proc call*(call_564144: Call_NamespacesListByResourceGroup_564137;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesListByResourceGroup
  ## Lists the available Namespaces within a resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564145 = newJObject()
  var query_564146 = newJObject()
  add(query_564146, "api-version", newJString(apiVersion))
  add(path_564145, "subscriptionId", newJString(subscriptionId))
  add(path_564145, "resourceGroupName", newJString(resourceGroupName))
  result = call_564144.call(path_564145, query_564146, nil, nil, nil)

var namespacesListByResourceGroup* = Call_NamespacesListByResourceGroup_564137(
    name: "namespacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces",
    validator: validate_NamespacesListByResourceGroup_564138, base: "",
    url: url_NamespacesListByResourceGroup_564139, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdate_564158 = ref object of OpenApiRestCall_563556
proc url_NamespacesCreateOrUpdate_564160(protocol: Scheme; host: string;
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

proc validate_NamespacesCreateOrUpdate_564159(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564171 = path.getOrDefault("namespaceName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "namespaceName", valid_564171
  var valid_564172 = path.getOrDefault("subscriptionId")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "subscriptionId", valid_564172
  var valid_564173 = path.getOrDefault("resourceGroupName")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "resourceGroupName", valid_564173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564174 = query.getOrDefault("api-version")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "api-version", valid_564174
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

proc call*(call_564176: Call_NamespacesCreateOrUpdate_564158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_NamespacesCreateOrUpdate_564158; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdate
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for creating a namespace resource.
  var path_564178 = newJObject()
  var query_564179 = newJObject()
  var body_564180 = newJObject()
  add(query_564179, "api-version", newJString(apiVersion))
  add(path_564178, "namespaceName", newJString(namespaceName))
  add(path_564178, "subscriptionId", newJString(subscriptionId))
  add(path_564178, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564180 = parameters
  result = call_564177.call(path_564178, query_564179, nil, nil, body_564180)

var namespacesCreateOrUpdate* = Call_NamespacesCreateOrUpdate_564158(
    name: "namespacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesCreateOrUpdate_564159, base: "",
    url: url_NamespacesCreateOrUpdate_564160, schemes: {Scheme.Https})
type
  Call_NamespacesGet_564147 = ref object of OpenApiRestCall_563556
proc url_NamespacesGet_564149(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesGet_564148(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the description of the specified namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564150 = path.getOrDefault("namespaceName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "namespaceName", valid_564150
  var valid_564151 = path.getOrDefault("subscriptionId")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "subscriptionId", valid_564151
  var valid_564152 = path.getOrDefault("resourceGroupName")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "resourceGroupName", valid_564152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564153 = query.getOrDefault("api-version")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "api-version", valid_564153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564154: Call_NamespacesGet_564147; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the description of the specified namespace.
  ## 
  let valid = call_564154.validator(path, query, header, formData, body)
  let scheme = call_564154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564154.url(scheme.get, call_564154.host, call_564154.base,
                         call_564154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564154, url, valid)

proc call*(call_564155: Call_NamespacesGet_564147; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesGet
  ## Gets the description of the specified namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564156 = newJObject()
  var query_564157 = newJObject()
  add(query_564157, "api-version", newJString(apiVersion))
  add(path_564156, "namespaceName", newJString(namespaceName))
  add(path_564156, "subscriptionId", newJString(subscriptionId))
  add(path_564156, "resourceGroupName", newJString(resourceGroupName))
  result = call_564155.call(path_564156, query_564157, nil, nil, nil)

var namespacesGet* = Call_NamespacesGet_564147(name: "namespacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesGet_564148, base: "", url: url_NamespacesGet_564149,
    schemes: {Scheme.Https})
type
  Call_NamespacesUpdate_564192 = ref object of OpenApiRestCall_563556
proc url_NamespacesUpdate_564194(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesUpdate_564193(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564195 = path.getOrDefault("namespaceName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "namespaceName", valid_564195
  var valid_564196 = path.getOrDefault("subscriptionId")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "subscriptionId", valid_564196
  var valid_564197 = path.getOrDefault("resourceGroupName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "resourceGroupName", valid_564197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564198 = query.getOrDefault("api-version")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "api-version", valid_564198
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

proc call*(call_564200: Call_NamespacesUpdate_564192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  let valid = call_564200.validator(path, query, header, formData, body)
  let scheme = call_564200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564200.url(scheme.get, call_564200.host, call_564200.base,
                         call_564200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564200, url, valid)

proc call*(call_564201: Call_NamespacesUpdate_564192; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## namespacesUpdate
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for updating a namespace resource.
  var path_564202 = newJObject()
  var query_564203 = newJObject()
  var body_564204 = newJObject()
  add(query_564203, "api-version", newJString(apiVersion))
  add(path_564202, "namespaceName", newJString(namespaceName))
  add(path_564202, "subscriptionId", newJString(subscriptionId))
  add(path_564202, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564204 = parameters
  result = call_564201.call(path_564202, query_564203, nil, nil, body_564204)

var namespacesUpdate* = Call_NamespacesUpdate_564192(name: "namespacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesUpdate_564193, base: "",
    url: url_NamespacesUpdate_564194, schemes: {Scheme.Https})
type
  Call_NamespacesDelete_564181 = ref object of OpenApiRestCall_563556
proc url_NamespacesDelete_564183(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesDelete_564182(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564184 = path.getOrDefault("namespaceName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "namespaceName", valid_564184
  var valid_564185 = path.getOrDefault("subscriptionId")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "subscriptionId", valid_564185
  var valid_564186 = path.getOrDefault("resourceGroupName")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "resourceGroupName", valid_564186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564187 = query.getOrDefault("api-version")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "api-version", valid_564187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564188: Call_NamespacesDelete_564181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  let valid = call_564188.validator(path, query, header, formData, body)
  let scheme = call_564188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564188.url(scheme.get, call_564188.host, call_564188.base,
                         call_564188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564188, url, valid)

proc call*(call_564189: Call_NamespacesDelete_564181; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesDelete
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564190 = newJObject()
  var query_564191 = newJObject()
  add(query_564191, "api-version", newJString(apiVersion))
  add(path_564190, "namespaceName", newJString(namespaceName))
  add(path_564190, "subscriptionId", newJString(subscriptionId))
  add(path_564190, "resourceGroupName", newJString(resourceGroupName))
  result = call_564189.call(path_564190, query_564191, nil, nil, nil)

var namespacesDelete* = Call_NamespacesDelete_564181(name: "namespacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesDelete_564182, base: "",
    url: url_NamespacesDelete_564183, schemes: {Scheme.Https})
type
  Call_NamespacesListAuthorizationRules_564205 = ref object of OpenApiRestCall_563556
proc url_NamespacesListAuthorizationRules_564207(protocol: Scheme; host: string;
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

proc validate_NamespacesListAuthorizationRules_564206(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of authorization rules for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564208 = path.getOrDefault("namespaceName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "namespaceName", valid_564208
  var valid_564209 = path.getOrDefault("subscriptionId")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "subscriptionId", valid_564209
  var valid_564210 = path.getOrDefault("resourceGroupName")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "resourceGroupName", valid_564210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564211 = query.getOrDefault("api-version")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "api-version", valid_564211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564212: Call_NamespacesListAuthorizationRules_564205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of authorization rules for a Namespace.
  ## 
  let valid = call_564212.validator(path, query, header, formData, body)
  let scheme = call_564212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564212.url(scheme.get, call_564212.host, call_564212.base,
                         call_564212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564212, url, valid)

proc call*(call_564213: Call_NamespacesListAuthorizationRules_564205;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## namespacesListAuthorizationRules
  ## Gets a list of authorization rules for a Namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564214 = newJObject()
  var query_564215 = newJObject()
  add(query_564215, "api-version", newJString(apiVersion))
  add(path_564214, "namespaceName", newJString(namespaceName))
  add(path_564214, "subscriptionId", newJString(subscriptionId))
  add(path_564214, "resourceGroupName", newJString(resourceGroupName))
  result = call_564213.call(path_564214, query_564215, nil, nil, nil)

var namespacesListAuthorizationRules* = Call_NamespacesListAuthorizationRules_564205(
    name: "namespacesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListAuthorizationRules_564206, base: "",
    url: url_NamespacesListAuthorizationRules_564207, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateAuthorizationRule_564228 = ref object of OpenApiRestCall_563556
proc url_NamespacesCreateOrUpdateAuthorizationRule_564230(protocol: Scheme;
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

proc validate_NamespacesCreateOrUpdateAuthorizationRule_564229(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an AuthorizationRule for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564231 = path.getOrDefault("namespaceName")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "namespaceName", valid_564231
  var valid_564232 = path.getOrDefault("subscriptionId")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "subscriptionId", valid_564232
  var valid_564233 = path.getOrDefault("authorizationRuleName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "authorizationRuleName", valid_564233
  var valid_564234 = path.getOrDefault("resourceGroupName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "resourceGroupName", valid_564234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564235 = query.getOrDefault("api-version")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "api-version", valid_564235
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

proc call*(call_564237: Call_NamespacesCreateOrUpdateAuthorizationRule_564228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an AuthorizationRule for a Namespace.
  ## 
  let valid = call_564237.validator(path, query, header, formData, body)
  let scheme = call_564237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564237.url(scheme.get, call_564237.host, call_564237.base,
                         call_564237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564237, url, valid)

proc call*(call_564238: Call_NamespacesCreateOrUpdateAuthorizationRule_564228;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateAuthorizationRule
  ## Creates or updates an AuthorizationRule for a Namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   parameters: JObject (required)
  ##             : The shared access AuthorizationRule.
  var path_564239 = newJObject()
  var query_564240 = newJObject()
  var body_564241 = newJObject()
  add(query_564240, "api-version", newJString(apiVersion))
  add(path_564239, "namespaceName", newJString(namespaceName))
  add(path_564239, "subscriptionId", newJString(subscriptionId))
  add(path_564239, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564239, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564241 = parameters
  result = call_564238.call(path_564239, query_564240, nil, nil, body_564241)

var namespacesCreateOrUpdateAuthorizationRule* = Call_NamespacesCreateOrUpdateAuthorizationRule_564228(
    name: "namespacesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesCreateOrUpdateAuthorizationRule_564229,
    base: "", url: url_NamespacesCreateOrUpdateAuthorizationRule_564230,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetAuthorizationRule_564216 = ref object of OpenApiRestCall_563556
proc url_NamespacesGetAuthorizationRule_564218(protocol: Scheme; host: string;
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

proc validate_NamespacesGetAuthorizationRule_564217(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564219 = path.getOrDefault("namespaceName")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "namespaceName", valid_564219
  var valid_564220 = path.getOrDefault("subscriptionId")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "subscriptionId", valid_564220
  var valid_564221 = path.getOrDefault("authorizationRuleName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "authorizationRuleName", valid_564221
  var valid_564222 = path.getOrDefault("resourceGroupName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "resourceGroupName", valid_564222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564223 = query.getOrDefault("api-version")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "api-version", valid_564223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564224: Call_NamespacesGetAuthorizationRule_564216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ## 
  let valid = call_564224.validator(path, query, header, formData, body)
  let scheme = call_564224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564224.url(scheme.get, call_564224.host, call_564224.base,
                         call_564224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564224, url, valid)

proc call*(call_564225: Call_NamespacesGetAuthorizationRule_564216;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string): Recallable =
  ## namespacesGetAuthorizationRule
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564226 = newJObject()
  var query_564227 = newJObject()
  add(query_564227, "api-version", newJString(apiVersion))
  add(path_564226, "namespaceName", newJString(namespaceName))
  add(path_564226, "subscriptionId", newJString(subscriptionId))
  add(path_564226, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564226, "resourceGroupName", newJString(resourceGroupName))
  result = call_564225.call(path_564226, query_564227, nil, nil, nil)

var namespacesGetAuthorizationRule* = Call_NamespacesGetAuthorizationRule_564216(
    name: "namespacesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesGetAuthorizationRule_564217, base: "",
    url: url_NamespacesGetAuthorizationRule_564218, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteAuthorizationRule_564242 = ref object of OpenApiRestCall_563556
proc url_NamespacesDeleteAuthorizationRule_564244(protocol: Scheme; host: string;
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

proc validate_NamespacesDeleteAuthorizationRule_564243(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an AuthorizationRule for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564245 = path.getOrDefault("namespaceName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "namespaceName", valid_564245
  var valid_564246 = path.getOrDefault("subscriptionId")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "subscriptionId", valid_564246
  var valid_564247 = path.getOrDefault("authorizationRuleName")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "authorizationRuleName", valid_564247
  var valid_564248 = path.getOrDefault("resourceGroupName")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "resourceGroupName", valid_564248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564249 = query.getOrDefault("api-version")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "api-version", valid_564249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564250: Call_NamespacesDeleteAuthorizationRule_564242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an AuthorizationRule for a Namespace.
  ## 
  let valid = call_564250.validator(path, query, header, formData, body)
  let scheme = call_564250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564250.url(scheme.get, call_564250.host, call_564250.base,
                         call_564250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564250, url, valid)

proc call*(call_564251: Call_NamespacesDeleteAuthorizationRule_564242;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string): Recallable =
  ## namespacesDeleteAuthorizationRule
  ## Deletes an AuthorizationRule for a Namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564252 = newJObject()
  var query_564253 = newJObject()
  add(query_564253, "api-version", newJString(apiVersion))
  add(path_564252, "namespaceName", newJString(namespaceName))
  add(path_564252, "subscriptionId", newJString(subscriptionId))
  add(path_564252, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564252, "resourceGroupName", newJString(resourceGroupName))
  result = call_564251.call(path_564252, query_564253, nil, nil, nil)

var namespacesDeleteAuthorizationRule* = Call_NamespacesDeleteAuthorizationRule_564242(
    name: "namespacesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesDeleteAuthorizationRule_564243, base: "",
    url: url_NamespacesDeleteAuthorizationRule_564244, schemes: {Scheme.Https})
type
  Call_NamespacesListKeys_564254 = ref object of OpenApiRestCall_563556
proc url_NamespacesListKeys_564256(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesListKeys_564255(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the primary and secondary connection strings for the Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564257 = path.getOrDefault("namespaceName")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "namespaceName", valid_564257
  var valid_564258 = path.getOrDefault("subscriptionId")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "subscriptionId", valid_564258
  var valid_564259 = path.getOrDefault("authorizationRuleName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "authorizationRuleName", valid_564259
  var valid_564260 = path.getOrDefault("resourceGroupName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "resourceGroupName", valid_564260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564261 = query.getOrDefault("api-version")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "api-version", valid_564261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564262: Call_NamespacesListKeys_564254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the primary and secondary connection strings for the Namespace.
  ## 
  let valid = call_564262.validator(path, query, header, formData, body)
  let scheme = call_564262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564262.url(scheme.get, call_564262.host, call_564262.base,
                         call_564262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564262, url, valid)

proc call*(call_564263: Call_NamespacesListKeys_564254; apiVersion: string;
          namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string): Recallable =
  ## namespacesListKeys
  ## Gets the primary and secondary connection strings for the Namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564264 = newJObject()
  var query_564265 = newJObject()
  add(query_564265, "api-version", newJString(apiVersion))
  add(path_564264, "namespaceName", newJString(namespaceName))
  add(path_564264, "subscriptionId", newJString(subscriptionId))
  add(path_564264, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564264, "resourceGroupName", newJString(resourceGroupName))
  result = call_564263.call(path_564264, query_564265, nil, nil, nil)

var namespacesListKeys* = Call_NamespacesListKeys_564254(
    name: "namespacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_NamespacesListKeys_564255, base: "",
    url: url_NamespacesListKeys_564256, schemes: {Scheme.Https})
type
  Call_NamespacesRegenerateKeys_564266 = ref object of OpenApiRestCall_563556
proc url_NamespacesRegenerateKeys_564268(protocol: Scheme; host: string;
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

proc validate_NamespacesRegenerateKeys_564267(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary or secondary connection strings for the specified Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564269 = path.getOrDefault("namespaceName")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "namespaceName", valid_564269
  var valid_564270 = path.getOrDefault("subscriptionId")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "subscriptionId", valid_564270
  var valid_564271 = path.getOrDefault("authorizationRuleName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "authorizationRuleName", valid_564271
  var valid_564272 = path.getOrDefault("resourceGroupName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "resourceGroupName", valid_564272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564273 = query.getOrDefault("api-version")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "api-version", valid_564273
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

proc call*(call_564275: Call_NamespacesRegenerateKeys_564266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the primary or secondary connection strings for the specified Namespace.
  ## 
  let valid = call_564275.validator(path, query, header, formData, body)
  let scheme = call_564275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564275.url(scheme.get, call_564275.host, call_564275.base,
                         call_564275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564275, url, valid)

proc call*(call_564276: Call_NamespacesRegenerateKeys_564266; apiVersion: string;
          namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## namespacesRegenerateKeys
  ## Regenerates the primary or secondary connection strings for the specified Namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters required to regenerate the connection string.
  var path_564277 = newJObject()
  var query_564278 = newJObject()
  var body_564279 = newJObject()
  add(query_564278, "api-version", newJString(apiVersion))
  add(path_564277, "namespaceName", newJString(namespaceName))
  add(path_564277, "subscriptionId", newJString(subscriptionId))
  add(path_564277, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564277, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564279 = parameters
  result = call_564276.call(path_564277, query_564278, nil, nil, body_564279)

var namespacesRegenerateKeys* = Call_NamespacesRegenerateKeys_564266(
    name: "namespacesRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_NamespacesRegenerateKeys_564267, base: "",
    url: url_NamespacesRegenerateKeys_564268, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsList_564280 = ref object of OpenApiRestCall_563556
proc url_DisasterRecoveryConfigsList_564282(protocol: Scheme; host: string;
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

proc validate_DisasterRecoveryConfigsList_564281(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all Alias(Disaster Recovery configurations)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564283 = path.getOrDefault("namespaceName")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "namespaceName", valid_564283
  var valid_564284 = path.getOrDefault("subscriptionId")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "subscriptionId", valid_564284
  var valid_564285 = path.getOrDefault("resourceGroupName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "resourceGroupName", valid_564285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564286 = query.getOrDefault("api-version")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "api-version", valid_564286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564287: Call_DisasterRecoveryConfigsList_564280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Alias(Disaster Recovery configurations)
  ## 
  let valid = call_564287.validator(path, query, header, formData, body)
  let scheme = call_564287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564287.url(scheme.get, call_564287.host, call_564287.base,
                         call_564287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564287, url, valid)

proc call*(call_564288: Call_DisasterRecoveryConfigsList_564280;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## disasterRecoveryConfigsList
  ## Gets all Alias(Disaster Recovery configurations)
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564289 = newJObject()
  var query_564290 = newJObject()
  add(query_564290, "api-version", newJString(apiVersion))
  add(path_564289, "namespaceName", newJString(namespaceName))
  add(path_564289, "subscriptionId", newJString(subscriptionId))
  add(path_564289, "resourceGroupName", newJString(resourceGroupName))
  result = call_564288.call(path_564289, query_564290, nil, nil, nil)

var disasterRecoveryConfigsList* = Call_DisasterRecoveryConfigsList_564280(
    name: "disasterRecoveryConfigsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs",
    validator: validate_DisasterRecoveryConfigsList_564281, base: "",
    url: url_DisasterRecoveryConfigsList_564282, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsCheckNameAvailability_564291 = ref object of OpenApiRestCall_563556
proc url_DisasterRecoveryConfigsCheckNameAvailability_564293(protocol: Scheme;
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

proc validate_DisasterRecoveryConfigsCheckNameAvailability_564292(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the give Namespace name availability.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564294 = path.getOrDefault("namespaceName")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "namespaceName", valid_564294
  var valid_564295 = path.getOrDefault("subscriptionId")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "subscriptionId", valid_564295
  var valid_564296 = path.getOrDefault("resourceGroupName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "resourceGroupName", valid_564296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564297 = query.getOrDefault("api-version")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "api-version", valid_564297
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

proc call*(call_564299: Call_DisasterRecoveryConfigsCheckNameAvailability_564291;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give Namespace name availability.
  ## 
  let valid = call_564299.validator(path, query, header, formData, body)
  let scheme = call_564299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564299.url(scheme.get, call_564299.host, call_564299.base,
                         call_564299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564299, url, valid)

proc call*(call_564300: Call_DisasterRecoveryConfigsCheckNameAvailability_564291;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## disasterRecoveryConfigsCheckNameAvailability
  ## Check the give Namespace name availability.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given Alias name
  var path_564301 = newJObject()
  var query_564302 = newJObject()
  var body_564303 = newJObject()
  add(query_564302, "api-version", newJString(apiVersion))
  add(path_564301, "namespaceName", newJString(namespaceName))
  add(path_564301, "subscriptionId", newJString(subscriptionId))
  add(path_564301, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564303 = parameters
  result = call_564300.call(path_564301, query_564302, nil, nil, body_564303)

var disasterRecoveryConfigsCheckNameAvailability* = Call_DisasterRecoveryConfigsCheckNameAvailability_564291(
    name: "disasterRecoveryConfigsCheckNameAvailability",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/CheckNameAvailability",
    validator: validate_DisasterRecoveryConfigsCheckNameAvailability_564292,
    base: "", url: url_DisasterRecoveryConfigsCheckNameAvailability_564293,
    schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsCreateOrUpdate_564316 = ref object of OpenApiRestCall_563556
proc url_DisasterRecoveryConfigsCreateOrUpdate_564318(protocol: Scheme;
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

proc validate_DisasterRecoveryConfigsCreateOrUpdate_564317(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a new Alias(Disaster Recovery configuration)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564319 = path.getOrDefault("namespaceName")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "namespaceName", valid_564319
  var valid_564320 = path.getOrDefault("subscriptionId")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "subscriptionId", valid_564320
  var valid_564321 = path.getOrDefault("resourceGroupName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "resourceGroupName", valid_564321
  var valid_564322 = path.getOrDefault("alias")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "alias", valid_564322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564323 = query.getOrDefault("api-version")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "api-version", valid_564323
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

proc call*(call_564325: Call_DisasterRecoveryConfigsCreateOrUpdate_564316;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a new Alias(Disaster Recovery configuration)
  ## 
  let valid = call_564325.validator(path, query, header, formData, body)
  let scheme = call_564325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564325.url(scheme.get, call_564325.host, call_564325.base,
                         call_564325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564325, url, valid)

proc call*(call_564326: Call_DisasterRecoveryConfigsCreateOrUpdate_564316;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string; alias: string; parameters: JsonNode): Recallable =
  ## disasterRecoveryConfigsCreateOrUpdate
  ## Creates or updates a new Alias(Disaster Recovery configuration)
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  ##   parameters: JObject (required)
  ##             : Parameters required to create an Alias(Disaster Recovery configuration)
  var path_564327 = newJObject()
  var query_564328 = newJObject()
  var body_564329 = newJObject()
  add(query_564328, "api-version", newJString(apiVersion))
  add(path_564327, "namespaceName", newJString(namespaceName))
  add(path_564327, "subscriptionId", newJString(subscriptionId))
  add(path_564327, "resourceGroupName", newJString(resourceGroupName))
  add(path_564327, "alias", newJString(alias))
  if parameters != nil:
    body_564329 = parameters
  result = call_564326.call(path_564327, query_564328, nil, nil, body_564329)

var disasterRecoveryConfigsCreateOrUpdate* = Call_DisasterRecoveryConfigsCreateOrUpdate_564316(
    name: "disasterRecoveryConfigsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}",
    validator: validate_DisasterRecoveryConfigsCreateOrUpdate_564317, base: "",
    url: url_DisasterRecoveryConfigsCreateOrUpdate_564318, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsGet_564304 = ref object of OpenApiRestCall_563556
proc url_DisasterRecoveryConfigsGet_564306(protocol: Scheme; host: string;
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

proc validate_DisasterRecoveryConfigsGet_564305(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves Alias(Disaster Recovery configuration) for primary or secondary namespace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564307 = path.getOrDefault("namespaceName")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "namespaceName", valid_564307
  var valid_564308 = path.getOrDefault("subscriptionId")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "subscriptionId", valid_564308
  var valid_564309 = path.getOrDefault("resourceGroupName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "resourceGroupName", valid_564309
  var valid_564310 = path.getOrDefault("alias")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "alias", valid_564310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564311 = query.getOrDefault("api-version")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "api-version", valid_564311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564312: Call_DisasterRecoveryConfigsGet_564304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves Alias(Disaster Recovery configuration) for primary or secondary namespace
  ## 
  let valid = call_564312.validator(path, query, header, formData, body)
  let scheme = call_564312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564312.url(scheme.get, call_564312.host, call_564312.base,
                         call_564312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564312, url, valid)

proc call*(call_564313: Call_DisasterRecoveryConfigsGet_564304; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string;
          alias: string): Recallable =
  ## disasterRecoveryConfigsGet
  ## Retrieves Alias(Disaster Recovery configuration) for primary or secondary namespace
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_564314 = newJObject()
  var query_564315 = newJObject()
  add(query_564315, "api-version", newJString(apiVersion))
  add(path_564314, "namespaceName", newJString(namespaceName))
  add(path_564314, "subscriptionId", newJString(subscriptionId))
  add(path_564314, "resourceGroupName", newJString(resourceGroupName))
  add(path_564314, "alias", newJString(alias))
  result = call_564313.call(path_564314, query_564315, nil, nil, nil)

var disasterRecoveryConfigsGet* = Call_DisasterRecoveryConfigsGet_564304(
    name: "disasterRecoveryConfigsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}",
    validator: validate_DisasterRecoveryConfigsGet_564305, base: "",
    url: url_DisasterRecoveryConfigsGet_564306, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsDelete_564330 = ref object of OpenApiRestCall_563556
proc url_DisasterRecoveryConfigsDelete_564332(protocol: Scheme; host: string;
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

proc validate_DisasterRecoveryConfigsDelete_564331(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an Alias(Disaster Recovery configuration)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564333 = path.getOrDefault("namespaceName")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "namespaceName", valid_564333
  var valid_564334 = path.getOrDefault("subscriptionId")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "subscriptionId", valid_564334
  var valid_564335 = path.getOrDefault("resourceGroupName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "resourceGroupName", valid_564335
  var valid_564336 = path.getOrDefault("alias")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "alias", valid_564336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564337 = query.getOrDefault("api-version")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "api-version", valid_564337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564338: Call_DisasterRecoveryConfigsDelete_564330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Alias(Disaster Recovery configuration)
  ## 
  let valid = call_564338.validator(path, query, header, formData, body)
  let scheme = call_564338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564338.url(scheme.get, call_564338.host, call_564338.base,
                         call_564338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564338, url, valid)

proc call*(call_564339: Call_DisasterRecoveryConfigsDelete_564330;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string; alias: string): Recallable =
  ## disasterRecoveryConfigsDelete
  ## Deletes an Alias(Disaster Recovery configuration)
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_564340 = newJObject()
  var query_564341 = newJObject()
  add(query_564341, "api-version", newJString(apiVersion))
  add(path_564340, "namespaceName", newJString(namespaceName))
  add(path_564340, "subscriptionId", newJString(subscriptionId))
  add(path_564340, "resourceGroupName", newJString(resourceGroupName))
  add(path_564340, "alias", newJString(alias))
  result = call_564339.call(path_564340, query_564341, nil, nil, nil)

var disasterRecoveryConfigsDelete* = Call_DisasterRecoveryConfigsDelete_564330(
    name: "disasterRecoveryConfigsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}",
    validator: validate_DisasterRecoveryConfigsDelete_564331, base: "",
    url: url_DisasterRecoveryConfigsDelete_564332, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsListAuthorizationRules_564342 = ref object of OpenApiRestCall_563556
proc url_DisasterRecoveryConfigsListAuthorizationRules_564344(protocol: Scheme;
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

proc validate_DisasterRecoveryConfigsListAuthorizationRules_564343(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a list of authorization rules for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564345 = path.getOrDefault("namespaceName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "namespaceName", valid_564345
  var valid_564346 = path.getOrDefault("subscriptionId")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "subscriptionId", valid_564346
  var valid_564347 = path.getOrDefault("resourceGroupName")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "resourceGroupName", valid_564347
  var valid_564348 = path.getOrDefault("alias")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "alias", valid_564348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564349 = query.getOrDefault("api-version")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "api-version", valid_564349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564350: Call_DisasterRecoveryConfigsListAuthorizationRules_564342;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of authorization rules for a Namespace.
  ## 
  let valid = call_564350.validator(path, query, header, formData, body)
  let scheme = call_564350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564350.url(scheme.get, call_564350.host, call_564350.base,
                         call_564350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564350, url, valid)

proc call*(call_564351: Call_DisasterRecoveryConfigsListAuthorizationRules_564342;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string; alias: string): Recallable =
  ## disasterRecoveryConfigsListAuthorizationRules
  ## Gets a list of authorization rules for a Namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_564352 = newJObject()
  var query_564353 = newJObject()
  add(query_564353, "api-version", newJString(apiVersion))
  add(path_564352, "namespaceName", newJString(namespaceName))
  add(path_564352, "subscriptionId", newJString(subscriptionId))
  add(path_564352, "resourceGroupName", newJString(resourceGroupName))
  add(path_564352, "alias", newJString(alias))
  result = call_564351.call(path_564352, query_564353, nil, nil, nil)

var disasterRecoveryConfigsListAuthorizationRules* = Call_DisasterRecoveryConfigsListAuthorizationRules_564342(
    name: "disasterRecoveryConfigsListAuthorizationRules",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/AuthorizationRules",
    validator: validate_DisasterRecoveryConfigsListAuthorizationRules_564343,
    base: "", url: url_DisasterRecoveryConfigsListAuthorizationRules_564344,
    schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsGetAuthorizationRule_564354 = ref object of OpenApiRestCall_563556
proc url_DisasterRecoveryConfigsGetAuthorizationRule_564356(protocol: Scheme;
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

proc validate_DisasterRecoveryConfigsGetAuthorizationRule_564355(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564357 = path.getOrDefault("namespaceName")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "namespaceName", valid_564357
  var valid_564358 = path.getOrDefault("subscriptionId")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "subscriptionId", valid_564358
  var valid_564359 = path.getOrDefault("authorizationRuleName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "authorizationRuleName", valid_564359
  var valid_564360 = path.getOrDefault("resourceGroupName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "resourceGroupName", valid_564360
  var valid_564361 = path.getOrDefault("alias")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "alias", valid_564361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564362 = query.getOrDefault("api-version")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "api-version", valid_564362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564363: Call_DisasterRecoveryConfigsGetAuthorizationRule_564354;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ## 
  let valid = call_564363.validator(path, query, header, formData, body)
  let scheme = call_564363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564363.url(scheme.get, call_564363.host, call_564363.base,
                         call_564363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564363, url, valid)

proc call*(call_564364: Call_DisasterRecoveryConfigsGetAuthorizationRule_564354;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string; alias: string): Recallable =
  ## disasterRecoveryConfigsGetAuthorizationRule
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_564365 = newJObject()
  var query_564366 = newJObject()
  add(query_564366, "api-version", newJString(apiVersion))
  add(path_564365, "namespaceName", newJString(namespaceName))
  add(path_564365, "subscriptionId", newJString(subscriptionId))
  add(path_564365, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564365, "resourceGroupName", newJString(resourceGroupName))
  add(path_564365, "alias", newJString(alias))
  result = call_564364.call(path_564365, query_564366, nil, nil, nil)

var disasterRecoveryConfigsGetAuthorizationRule* = Call_DisasterRecoveryConfigsGetAuthorizationRule_564354(
    name: "disasterRecoveryConfigsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_DisasterRecoveryConfigsGetAuthorizationRule_564355,
    base: "", url: url_DisasterRecoveryConfigsGetAuthorizationRule_564356,
    schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsListKeys_564367 = ref object of OpenApiRestCall_563556
proc url_DisasterRecoveryConfigsListKeys_564369(protocol: Scheme; host: string;
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

proc validate_DisasterRecoveryConfigsListKeys_564368(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the primary and secondary connection strings for the Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564370 = path.getOrDefault("namespaceName")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "namespaceName", valid_564370
  var valid_564371 = path.getOrDefault("subscriptionId")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "subscriptionId", valid_564371
  var valid_564372 = path.getOrDefault("authorizationRuleName")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "authorizationRuleName", valid_564372
  var valid_564373 = path.getOrDefault("resourceGroupName")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "resourceGroupName", valid_564373
  var valid_564374 = path.getOrDefault("alias")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "alias", valid_564374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564375 = query.getOrDefault("api-version")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "api-version", valid_564375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564376: Call_DisasterRecoveryConfigsListKeys_564367;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the primary and secondary connection strings for the Namespace.
  ## 
  let valid = call_564376.validator(path, query, header, formData, body)
  let scheme = call_564376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564376.url(scheme.get, call_564376.host, call_564376.base,
                         call_564376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564376, url, valid)

proc call*(call_564377: Call_DisasterRecoveryConfigsListKeys_564367;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string; alias: string): Recallable =
  ## disasterRecoveryConfigsListKeys
  ## Gets the primary and secondary connection strings for the Namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_564378 = newJObject()
  var query_564379 = newJObject()
  add(query_564379, "api-version", newJString(apiVersion))
  add(path_564378, "namespaceName", newJString(namespaceName))
  add(path_564378, "subscriptionId", newJString(subscriptionId))
  add(path_564378, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564378, "resourceGroupName", newJString(resourceGroupName))
  add(path_564378, "alias", newJString(alias))
  result = call_564377.call(path_564378, query_564379, nil, nil, nil)

var disasterRecoveryConfigsListKeys* = Call_DisasterRecoveryConfigsListKeys_564367(
    name: "disasterRecoveryConfigsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_DisasterRecoveryConfigsListKeys_564368, base: "",
    url: url_DisasterRecoveryConfigsListKeys_564369, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsBreakPairing_564380 = ref object of OpenApiRestCall_563556
proc url_DisasterRecoveryConfigsBreakPairing_564382(protocol: Scheme; host: string;
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

proc validate_DisasterRecoveryConfigsBreakPairing_564381(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation disables the Disaster Recovery and stops replicating changes from primary to secondary namespaces
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564383 = path.getOrDefault("namespaceName")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "namespaceName", valid_564383
  var valid_564384 = path.getOrDefault("subscriptionId")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "subscriptionId", valid_564384
  var valid_564385 = path.getOrDefault("resourceGroupName")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "resourceGroupName", valid_564385
  var valid_564386 = path.getOrDefault("alias")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "alias", valid_564386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564387 = query.getOrDefault("api-version")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "api-version", valid_564387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564388: Call_DisasterRecoveryConfigsBreakPairing_564380;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation disables the Disaster Recovery and stops replicating changes from primary to secondary namespaces
  ## 
  let valid = call_564388.validator(path, query, header, formData, body)
  let scheme = call_564388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564388.url(scheme.get, call_564388.host, call_564388.base,
                         call_564388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564388, url, valid)

proc call*(call_564389: Call_DisasterRecoveryConfigsBreakPairing_564380;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string; alias: string): Recallable =
  ## disasterRecoveryConfigsBreakPairing
  ## This operation disables the Disaster Recovery and stops replicating changes from primary to secondary namespaces
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_564390 = newJObject()
  var query_564391 = newJObject()
  add(query_564391, "api-version", newJString(apiVersion))
  add(path_564390, "namespaceName", newJString(namespaceName))
  add(path_564390, "subscriptionId", newJString(subscriptionId))
  add(path_564390, "resourceGroupName", newJString(resourceGroupName))
  add(path_564390, "alias", newJString(alias))
  result = call_564389.call(path_564390, query_564391, nil, nil, nil)

var disasterRecoveryConfigsBreakPairing* = Call_DisasterRecoveryConfigsBreakPairing_564380(
    name: "disasterRecoveryConfigsBreakPairing", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/breakPairing",
    validator: validate_DisasterRecoveryConfigsBreakPairing_564381, base: "",
    url: url_DisasterRecoveryConfigsBreakPairing_564382, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsFailOver_564392 = ref object of OpenApiRestCall_563556
proc url_DisasterRecoveryConfigsFailOver_564394(protocol: Scheme; host: string;
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

proc validate_DisasterRecoveryConfigsFailOver_564393(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Invokes GEO DR failover and reconfigure the alias to point to the secondary namespace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564395 = path.getOrDefault("namespaceName")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "namespaceName", valid_564395
  var valid_564396 = path.getOrDefault("subscriptionId")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "subscriptionId", valid_564396
  var valid_564397 = path.getOrDefault("resourceGroupName")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "resourceGroupName", valid_564397
  var valid_564398 = path.getOrDefault("alias")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "alias", valid_564398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564399 = query.getOrDefault("api-version")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "api-version", valid_564399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564400: Call_DisasterRecoveryConfigsFailOver_564392;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Invokes GEO DR failover and reconfigure the alias to point to the secondary namespace
  ## 
  let valid = call_564400.validator(path, query, header, formData, body)
  let scheme = call_564400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564400.url(scheme.get, call_564400.host, call_564400.base,
                         call_564400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564400, url, valid)

proc call*(call_564401: Call_DisasterRecoveryConfigsFailOver_564392;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string; alias: string): Recallable =
  ## disasterRecoveryConfigsFailOver
  ## Invokes GEO DR failover and reconfigure the alias to point to the secondary namespace
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_564402 = newJObject()
  var query_564403 = newJObject()
  add(query_564403, "api-version", newJString(apiVersion))
  add(path_564402, "namespaceName", newJString(namespaceName))
  add(path_564402, "subscriptionId", newJString(subscriptionId))
  add(path_564402, "resourceGroupName", newJString(resourceGroupName))
  add(path_564402, "alias", newJString(alias))
  result = call_564401.call(path_564402, query_564403, nil, nil, nil)

var disasterRecoveryConfigsFailOver* = Call_DisasterRecoveryConfigsFailOver_564392(
    name: "disasterRecoveryConfigsFailOver", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/failover",
    validator: validate_DisasterRecoveryConfigsFailOver_564393, base: "",
    url: url_DisasterRecoveryConfigsFailOver_564394, schemes: {Scheme.Https})
type
  Call_EventHubsListByNamespace_564404 = ref object of OpenApiRestCall_563556
proc url_EventHubsListByNamespace_564406(protocol: Scheme; host: string;
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

proc validate_EventHubsListByNamespace_564405(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the Event Hubs in a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564408 = path.getOrDefault("namespaceName")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "namespaceName", valid_564408
  var valid_564409 = path.getOrDefault("subscriptionId")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "subscriptionId", valid_564409
  var valid_564410 = path.getOrDefault("resourceGroupName")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "resourceGroupName", valid_564410
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
  var valid_564411 = query.getOrDefault("api-version")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "api-version", valid_564411
  var valid_564412 = query.getOrDefault("$top")
  valid_564412 = validateParameter(valid_564412, JInt, required = false, default = nil)
  if valid_564412 != nil:
    section.add "$top", valid_564412
  var valid_564413 = query.getOrDefault("$skip")
  valid_564413 = validateParameter(valid_564413, JInt, required = false, default = nil)
  if valid_564413 != nil:
    section.add "$skip", valid_564413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564414: Call_EventHubsListByNamespace_564404; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the Event Hubs in a Namespace.
  ## 
  let valid = call_564414.validator(path, query, header, formData, body)
  let scheme = call_564414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564414.url(scheme.get, call_564414.host, call_564414.base,
                         call_564414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564414, url, valid)

proc call*(call_564415: Call_EventHubsListByNamespace_564404; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; Skip: int = 0): Recallable =
  ## eventHubsListByNamespace
  ## Gets all the Event Hubs in a Namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skip: int
  ##       : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564416 = newJObject()
  var query_564417 = newJObject()
  add(query_564417, "api-version", newJString(apiVersion))
  add(path_564416, "namespaceName", newJString(namespaceName))
  add(query_564417, "$top", newJInt(Top))
  add(path_564416, "subscriptionId", newJString(subscriptionId))
  add(query_564417, "$skip", newJInt(Skip))
  add(path_564416, "resourceGroupName", newJString(resourceGroupName))
  result = call_564415.call(path_564416, query_564417, nil, nil, nil)

var eventHubsListByNamespace* = Call_EventHubsListByNamespace_564404(
    name: "eventHubsListByNamespace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs",
    validator: validate_EventHubsListByNamespace_564405, base: "",
    url: url_EventHubsListByNamespace_564406, schemes: {Scheme.Https})
type
  Call_EventHubsCreateOrUpdate_564430 = ref object of OpenApiRestCall_563556
proc url_EventHubsCreateOrUpdate_564432(protocol: Scheme; host: string; base: string;
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

proc validate_EventHubsCreateOrUpdate_564431(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a new Event Hub as a nested resource within a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564433 = path.getOrDefault("namespaceName")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "namespaceName", valid_564433
  var valid_564434 = path.getOrDefault("eventHubName")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "eventHubName", valid_564434
  var valid_564435 = path.getOrDefault("subscriptionId")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "subscriptionId", valid_564435
  var valid_564436 = path.getOrDefault("resourceGroupName")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "resourceGroupName", valid_564436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564437 = query.getOrDefault("api-version")
  valid_564437 = validateParameter(valid_564437, JString, required = true,
                                 default = nil)
  if valid_564437 != nil:
    section.add "api-version", valid_564437
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

proc call*(call_564439: Call_EventHubsCreateOrUpdate_564430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a new Event Hub as a nested resource within a Namespace.
  ## 
  let valid = call_564439.validator(path, query, header, formData, body)
  let scheme = call_564439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564439.url(scheme.get, call_564439.host, call_564439.base,
                         call_564439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564439, url, valid)

proc call*(call_564440: Call_EventHubsCreateOrUpdate_564430; apiVersion: string;
          namespaceName: string; eventHubName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## eventHubsCreateOrUpdate
  ## Creates or updates a new Event Hub as a nested resource within a Namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create an Event Hub resource.
  var path_564441 = newJObject()
  var query_564442 = newJObject()
  var body_564443 = newJObject()
  add(query_564442, "api-version", newJString(apiVersion))
  add(path_564441, "namespaceName", newJString(namespaceName))
  add(path_564441, "eventHubName", newJString(eventHubName))
  add(path_564441, "subscriptionId", newJString(subscriptionId))
  add(path_564441, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564443 = parameters
  result = call_564440.call(path_564441, query_564442, nil, nil, body_564443)

var eventHubsCreateOrUpdate* = Call_EventHubsCreateOrUpdate_564430(
    name: "eventHubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}",
    validator: validate_EventHubsCreateOrUpdate_564431, base: "",
    url: url_EventHubsCreateOrUpdate_564432, schemes: {Scheme.Https})
type
  Call_EventHubsGet_564418 = ref object of OpenApiRestCall_563556
proc url_EventHubsGet_564420(protocol: Scheme; host: string; base: string;
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

proc validate_EventHubsGet_564419(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an Event Hubs description for the specified Event Hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564421 = path.getOrDefault("namespaceName")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "namespaceName", valid_564421
  var valid_564422 = path.getOrDefault("eventHubName")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "eventHubName", valid_564422
  var valid_564423 = path.getOrDefault("subscriptionId")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "subscriptionId", valid_564423
  var valid_564424 = path.getOrDefault("resourceGroupName")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "resourceGroupName", valid_564424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564425 = query.getOrDefault("api-version")
  valid_564425 = validateParameter(valid_564425, JString, required = true,
                                 default = nil)
  if valid_564425 != nil:
    section.add "api-version", valid_564425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564426: Call_EventHubsGet_564418; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an Event Hubs description for the specified Event Hub.
  ## 
  let valid = call_564426.validator(path, query, header, formData, body)
  let scheme = call_564426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564426.url(scheme.get, call_564426.host, call_564426.base,
                         call_564426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564426, url, valid)

proc call*(call_564427: Call_EventHubsGet_564418; apiVersion: string;
          namespaceName: string; eventHubName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## eventHubsGet
  ## Gets an Event Hubs description for the specified Event Hub.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564428 = newJObject()
  var query_564429 = newJObject()
  add(query_564429, "api-version", newJString(apiVersion))
  add(path_564428, "namespaceName", newJString(namespaceName))
  add(path_564428, "eventHubName", newJString(eventHubName))
  add(path_564428, "subscriptionId", newJString(subscriptionId))
  add(path_564428, "resourceGroupName", newJString(resourceGroupName))
  result = call_564427.call(path_564428, query_564429, nil, nil, nil)

var eventHubsGet* = Call_EventHubsGet_564418(name: "eventHubsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}",
    validator: validate_EventHubsGet_564419, base: "", url: url_EventHubsGet_564420,
    schemes: {Scheme.Https})
type
  Call_EventHubsDelete_564444 = ref object of OpenApiRestCall_563556
proc url_EventHubsDelete_564446(protocol: Scheme; host: string; base: string;
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

proc validate_EventHubsDelete_564445(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes an Event Hub from the specified Namespace and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564447 = path.getOrDefault("namespaceName")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "namespaceName", valid_564447
  var valid_564448 = path.getOrDefault("eventHubName")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "eventHubName", valid_564448
  var valid_564449 = path.getOrDefault("subscriptionId")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "subscriptionId", valid_564449
  var valid_564450 = path.getOrDefault("resourceGroupName")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "resourceGroupName", valid_564450
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564451 = query.getOrDefault("api-version")
  valid_564451 = validateParameter(valid_564451, JString, required = true,
                                 default = nil)
  if valid_564451 != nil:
    section.add "api-version", valid_564451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564452: Call_EventHubsDelete_564444; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Event Hub from the specified Namespace and resource group.
  ## 
  let valid = call_564452.validator(path, query, header, formData, body)
  let scheme = call_564452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564452.url(scheme.get, call_564452.host, call_564452.base,
                         call_564452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564452, url, valid)

proc call*(call_564453: Call_EventHubsDelete_564444; apiVersion: string;
          namespaceName: string; eventHubName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## eventHubsDelete
  ## Deletes an Event Hub from the specified Namespace and resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564454 = newJObject()
  var query_564455 = newJObject()
  add(query_564455, "api-version", newJString(apiVersion))
  add(path_564454, "namespaceName", newJString(namespaceName))
  add(path_564454, "eventHubName", newJString(eventHubName))
  add(path_564454, "subscriptionId", newJString(subscriptionId))
  add(path_564454, "resourceGroupName", newJString(resourceGroupName))
  result = call_564453.call(path_564454, query_564455, nil, nil, nil)

var eventHubsDelete* = Call_EventHubsDelete_564444(name: "eventHubsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}",
    validator: validate_EventHubsDelete_564445, base: "", url: url_EventHubsDelete_564446,
    schemes: {Scheme.Https})
type
  Call_EventHubsListAuthorizationRules_564456 = ref object of OpenApiRestCall_563556
proc url_EventHubsListAuthorizationRules_564458(protocol: Scheme; host: string;
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

proc validate_EventHubsListAuthorizationRules_564457(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the authorization rules for an Event Hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564459 = path.getOrDefault("namespaceName")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "namespaceName", valid_564459
  var valid_564460 = path.getOrDefault("eventHubName")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "eventHubName", valid_564460
  var valid_564461 = path.getOrDefault("subscriptionId")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = nil)
  if valid_564461 != nil:
    section.add "subscriptionId", valid_564461
  var valid_564462 = path.getOrDefault("resourceGroupName")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "resourceGroupName", valid_564462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564463 = query.getOrDefault("api-version")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "api-version", valid_564463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564464: Call_EventHubsListAuthorizationRules_564456;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for an Event Hub.
  ## 
  let valid = call_564464.validator(path, query, header, formData, body)
  let scheme = call_564464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564464.url(scheme.get, call_564464.host, call_564464.base,
                         call_564464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564464, url, valid)

proc call*(call_564465: Call_EventHubsListAuthorizationRules_564456;
          apiVersion: string; namespaceName: string; eventHubName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## eventHubsListAuthorizationRules
  ## Gets the authorization rules for an Event Hub.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564466 = newJObject()
  var query_564467 = newJObject()
  add(query_564467, "api-version", newJString(apiVersion))
  add(path_564466, "namespaceName", newJString(namespaceName))
  add(path_564466, "eventHubName", newJString(eventHubName))
  add(path_564466, "subscriptionId", newJString(subscriptionId))
  add(path_564466, "resourceGroupName", newJString(resourceGroupName))
  result = call_564465.call(path_564466, query_564467, nil, nil, nil)

var eventHubsListAuthorizationRules* = Call_EventHubsListAuthorizationRules_564456(
    name: "eventHubsListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules",
    validator: validate_EventHubsListAuthorizationRules_564457, base: "",
    url: url_EventHubsListAuthorizationRules_564458, schemes: {Scheme.Https})
type
  Call_EventHubsCreateOrUpdateAuthorizationRule_564481 = ref object of OpenApiRestCall_563556
proc url_EventHubsCreateOrUpdateAuthorizationRule_564483(protocol: Scheme;
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

proc validate_EventHubsCreateOrUpdateAuthorizationRule_564482(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an AuthorizationRule for the specified Event Hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564484 = path.getOrDefault("namespaceName")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "namespaceName", valid_564484
  var valid_564485 = path.getOrDefault("eventHubName")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "eventHubName", valid_564485
  var valid_564486 = path.getOrDefault("subscriptionId")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "subscriptionId", valid_564486
  var valid_564487 = path.getOrDefault("authorizationRuleName")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "authorizationRuleName", valid_564487
  var valid_564488 = path.getOrDefault("resourceGroupName")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "resourceGroupName", valid_564488
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564489 = query.getOrDefault("api-version")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = nil)
  if valid_564489 != nil:
    section.add "api-version", valid_564489
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

proc call*(call_564491: Call_EventHubsCreateOrUpdateAuthorizationRule_564481;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an AuthorizationRule for the specified Event Hub.
  ## 
  let valid = call_564491.validator(path, query, header, formData, body)
  let scheme = call_564491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564491.url(scheme.get, call_564491.host, call_564491.base,
                         call_564491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564491, url, valid)

proc call*(call_564492: Call_EventHubsCreateOrUpdateAuthorizationRule_564481;
          apiVersion: string; namespaceName: string; eventHubName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## eventHubsCreateOrUpdateAuthorizationRule
  ## Creates or updates an AuthorizationRule for the specified Event Hub.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   parameters: JObject (required)
  ##             : The shared access AuthorizationRule.
  var path_564493 = newJObject()
  var query_564494 = newJObject()
  var body_564495 = newJObject()
  add(query_564494, "api-version", newJString(apiVersion))
  add(path_564493, "namespaceName", newJString(namespaceName))
  add(path_564493, "eventHubName", newJString(eventHubName))
  add(path_564493, "subscriptionId", newJString(subscriptionId))
  add(path_564493, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564493, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564495 = parameters
  result = call_564492.call(path_564493, query_564494, nil, nil, body_564495)

var eventHubsCreateOrUpdateAuthorizationRule* = Call_EventHubsCreateOrUpdateAuthorizationRule_564481(
    name: "eventHubsCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}",
    validator: validate_EventHubsCreateOrUpdateAuthorizationRule_564482, base: "",
    url: url_EventHubsCreateOrUpdateAuthorizationRule_564483,
    schemes: {Scheme.Https})
type
  Call_EventHubsGetAuthorizationRule_564468 = ref object of OpenApiRestCall_563556
proc url_EventHubsGetAuthorizationRule_564470(protocol: Scheme; host: string;
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

proc validate_EventHubsGetAuthorizationRule_564469(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an AuthorizationRule for an Event Hub by rule name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564471 = path.getOrDefault("namespaceName")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "namespaceName", valid_564471
  var valid_564472 = path.getOrDefault("eventHubName")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "eventHubName", valid_564472
  var valid_564473 = path.getOrDefault("subscriptionId")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "subscriptionId", valid_564473
  var valid_564474 = path.getOrDefault("authorizationRuleName")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "authorizationRuleName", valid_564474
  var valid_564475 = path.getOrDefault("resourceGroupName")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = nil)
  if valid_564475 != nil:
    section.add "resourceGroupName", valid_564475
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564476 = query.getOrDefault("api-version")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = nil)
  if valid_564476 != nil:
    section.add "api-version", valid_564476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564477: Call_EventHubsGetAuthorizationRule_564468; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an AuthorizationRule for an Event Hub by rule name.
  ## 
  let valid = call_564477.validator(path, query, header, formData, body)
  let scheme = call_564477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564477.url(scheme.get, call_564477.host, call_564477.base,
                         call_564477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564477, url, valid)

proc call*(call_564478: Call_EventHubsGetAuthorizationRule_564468;
          apiVersion: string; namespaceName: string; eventHubName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string): Recallable =
  ## eventHubsGetAuthorizationRule
  ## Gets an AuthorizationRule for an Event Hub by rule name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564479 = newJObject()
  var query_564480 = newJObject()
  add(query_564480, "api-version", newJString(apiVersion))
  add(path_564479, "namespaceName", newJString(namespaceName))
  add(path_564479, "eventHubName", newJString(eventHubName))
  add(path_564479, "subscriptionId", newJString(subscriptionId))
  add(path_564479, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564479, "resourceGroupName", newJString(resourceGroupName))
  result = call_564478.call(path_564479, query_564480, nil, nil, nil)

var eventHubsGetAuthorizationRule* = Call_EventHubsGetAuthorizationRule_564468(
    name: "eventHubsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}",
    validator: validate_EventHubsGetAuthorizationRule_564469, base: "",
    url: url_EventHubsGetAuthorizationRule_564470, schemes: {Scheme.Https})
type
  Call_EventHubsDeleteAuthorizationRule_564496 = ref object of OpenApiRestCall_563556
proc url_EventHubsDeleteAuthorizationRule_564498(protocol: Scheme; host: string;
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

proc validate_EventHubsDeleteAuthorizationRule_564497(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an Event Hub AuthorizationRule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564499 = path.getOrDefault("namespaceName")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "namespaceName", valid_564499
  var valid_564500 = path.getOrDefault("eventHubName")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "eventHubName", valid_564500
  var valid_564501 = path.getOrDefault("subscriptionId")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "subscriptionId", valid_564501
  var valid_564502 = path.getOrDefault("authorizationRuleName")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "authorizationRuleName", valid_564502
  var valid_564503 = path.getOrDefault("resourceGroupName")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "resourceGroupName", valid_564503
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564504 = query.getOrDefault("api-version")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "api-version", valid_564504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564505: Call_EventHubsDeleteAuthorizationRule_564496;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an Event Hub AuthorizationRule.
  ## 
  let valid = call_564505.validator(path, query, header, formData, body)
  let scheme = call_564505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564505.url(scheme.get, call_564505.host, call_564505.base,
                         call_564505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564505, url, valid)

proc call*(call_564506: Call_EventHubsDeleteAuthorizationRule_564496;
          apiVersion: string; namespaceName: string; eventHubName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string): Recallable =
  ## eventHubsDeleteAuthorizationRule
  ## Deletes an Event Hub AuthorizationRule.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564507 = newJObject()
  var query_564508 = newJObject()
  add(query_564508, "api-version", newJString(apiVersion))
  add(path_564507, "namespaceName", newJString(namespaceName))
  add(path_564507, "eventHubName", newJString(eventHubName))
  add(path_564507, "subscriptionId", newJString(subscriptionId))
  add(path_564507, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564507, "resourceGroupName", newJString(resourceGroupName))
  result = call_564506.call(path_564507, query_564508, nil, nil, nil)

var eventHubsDeleteAuthorizationRule* = Call_EventHubsDeleteAuthorizationRule_564496(
    name: "eventHubsDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}",
    validator: validate_EventHubsDeleteAuthorizationRule_564497, base: "",
    url: url_EventHubsDeleteAuthorizationRule_564498, schemes: {Scheme.Https})
type
  Call_EventHubsListKeys_564509 = ref object of OpenApiRestCall_563556
proc url_EventHubsListKeys_564511(protocol: Scheme; host: string; base: string;
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

proc validate_EventHubsListKeys_564510(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the ACS and SAS connection strings for the Event Hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564512 = path.getOrDefault("namespaceName")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "namespaceName", valid_564512
  var valid_564513 = path.getOrDefault("eventHubName")
  valid_564513 = validateParameter(valid_564513, JString, required = true,
                                 default = nil)
  if valid_564513 != nil:
    section.add "eventHubName", valid_564513
  var valid_564514 = path.getOrDefault("subscriptionId")
  valid_564514 = validateParameter(valid_564514, JString, required = true,
                                 default = nil)
  if valid_564514 != nil:
    section.add "subscriptionId", valid_564514
  var valid_564515 = path.getOrDefault("authorizationRuleName")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "authorizationRuleName", valid_564515
  var valid_564516 = path.getOrDefault("resourceGroupName")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "resourceGroupName", valid_564516
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564517 = query.getOrDefault("api-version")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "api-version", valid_564517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564518: Call_EventHubsListKeys_564509; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the ACS and SAS connection strings for the Event Hub.
  ## 
  let valid = call_564518.validator(path, query, header, formData, body)
  let scheme = call_564518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564518.url(scheme.get, call_564518.host, call_564518.base,
                         call_564518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564518, url, valid)

proc call*(call_564519: Call_EventHubsListKeys_564509; apiVersion: string;
          namespaceName: string; eventHubName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string): Recallable =
  ## eventHubsListKeys
  ## Gets the ACS and SAS connection strings for the Event Hub.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564520 = newJObject()
  var query_564521 = newJObject()
  add(query_564521, "api-version", newJString(apiVersion))
  add(path_564520, "namespaceName", newJString(namespaceName))
  add(path_564520, "eventHubName", newJString(eventHubName))
  add(path_564520, "subscriptionId", newJString(subscriptionId))
  add(path_564520, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564520, "resourceGroupName", newJString(resourceGroupName))
  result = call_564519.call(path_564520, query_564521, nil, nil, nil)

var eventHubsListKeys* = Call_EventHubsListKeys_564509(name: "eventHubsListKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}/ListKeys",
    validator: validate_EventHubsListKeys_564510, base: "",
    url: url_EventHubsListKeys_564511, schemes: {Scheme.Https})
type
  Call_EventHubsRegenerateKeys_564522 = ref object of OpenApiRestCall_563556
proc url_EventHubsRegenerateKeys_564524(protocol: Scheme; host: string; base: string;
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

proc validate_EventHubsRegenerateKeys_564523(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the ACS and SAS connection strings for the Event Hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564525 = path.getOrDefault("namespaceName")
  valid_564525 = validateParameter(valid_564525, JString, required = true,
                                 default = nil)
  if valid_564525 != nil:
    section.add "namespaceName", valid_564525
  var valid_564526 = path.getOrDefault("eventHubName")
  valid_564526 = validateParameter(valid_564526, JString, required = true,
                                 default = nil)
  if valid_564526 != nil:
    section.add "eventHubName", valid_564526
  var valid_564527 = path.getOrDefault("subscriptionId")
  valid_564527 = validateParameter(valid_564527, JString, required = true,
                                 default = nil)
  if valid_564527 != nil:
    section.add "subscriptionId", valid_564527
  var valid_564528 = path.getOrDefault("authorizationRuleName")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "authorizationRuleName", valid_564528
  var valid_564529 = path.getOrDefault("resourceGroupName")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "resourceGroupName", valid_564529
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564530 = query.getOrDefault("api-version")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "api-version", valid_564530
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

proc call*(call_564532: Call_EventHubsRegenerateKeys_564522; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the ACS and SAS connection strings for the Event Hub.
  ## 
  let valid = call_564532.validator(path, query, header, formData, body)
  let scheme = call_564532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564532.url(scheme.get, call_564532.host, call_564532.base,
                         call_564532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564532, url, valid)

proc call*(call_564533: Call_EventHubsRegenerateKeys_564522; apiVersion: string;
          namespaceName: string; eventHubName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## eventHubsRegenerateKeys
  ## Regenerates the ACS and SAS connection strings for the Event Hub.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the AuthorizationRule Keys (PrimaryKey/SecondaryKey).
  var path_564534 = newJObject()
  var query_564535 = newJObject()
  var body_564536 = newJObject()
  add(query_564535, "api-version", newJString(apiVersion))
  add(path_564534, "namespaceName", newJString(namespaceName))
  add(path_564534, "eventHubName", newJString(eventHubName))
  add(path_564534, "subscriptionId", newJString(subscriptionId))
  add(path_564534, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564534, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564536 = parameters
  result = call_564533.call(path_564534, query_564535, nil, nil, body_564536)

var eventHubsRegenerateKeys* = Call_EventHubsRegenerateKeys_564522(
    name: "eventHubsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_EventHubsRegenerateKeys_564523, base: "",
    url: url_EventHubsRegenerateKeys_564524, schemes: {Scheme.Https})
type
  Call_ConsumerGroupsListByEventHub_564537 = ref object of OpenApiRestCall_563556
proc url_ConsumerGroupsListByEventHub_564539(protocol: Scheme; host: string;
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

proc validate_ConsumerGroupsListByEventHub_564538(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the consumer groups in a Namespace. An empty feed is returned if no consumer group exists in the Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564540 = path.getOrDefault("namespaceName")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "namespaceName", valid_564540
  var valid_564541 = path.getOrDefault("eventHubName")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "eventHubName", valid_564541
  var valid_564542 = path.getOrDefault("subscriptionId")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "subscriptionId", valid_564542
  var valid_564543 = path.getOrDefault("resourceGroupName")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "resourceGroupName", valid_564543
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
  var valid_564544 = query.getOrDefault("api-version")
  valid_564544 = validateParameter(valid_564544, JString, required = true,
                                 default = nil)
  if valid_564544 != nil:
    section.add "api-version", valid_564544
  var valid_564545 = query.getOrDefault("$top")
  valid_564545 = validateParameter(valid_564545, JInt, required = false, default = nil)
  if valid_564545 != nil:
    section.add "$top", valid_564545
  var valid_564546 = query.getOrDefault("$skip")
  valid_564546 = validateParameter(valid_564546, JInt, required = false, default = nil)
  if valid_564546 != nil:
    section.add "$skip", valid_564546
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564547: Call_ConsumerGroupsListByEventHub_564537; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the consumer groups in a Namespace. An empty feed is returned if no consumer group exists in the Namespace.
  ## 
  let valid = call_564547.validator(path, query, header, formData, body)
  let scheme = call_564547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564547.url(scheme.get, call_564547.host, call_564547.base,
                         call_564547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564547, url, valid)

proc call*(call_564548: Call_ConsumerGroupsListByEventHub_564537;
          apiVersion: string; namespaceName: string; eventHubName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0; Skip: int = 0): Recallable =
  ## consumerGroupsListByEventHub
  ## Gets all the consumer groups in a Namespace. An empty feed is returned if no consumer group exists in the Namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skip: int
  ##       : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564549 = newJObject()
  var query_564550 = newJObject()
  add(query_564550, "api-version", newJString(apiVersion))
  add(path_564549, "namespaceName", newJString(namespaceName))
  add(query_564550, "$top", newJInt(Top))
  add(path_564549, "eventHubName", newJString(eventHubName))
  add(path_564549, "subscriptionId", newJString(subscriptionId))
  add(query_564550, "$skip", newJInt(Skip))
  add(path_564549, "resourceGroupName", newJString(resourceGroupName))
  result = call_564548.call(path_564549, query_564550, nil, nil, nil)

var consumerGroupsListByEventHub* = Call_ConsumerGroupsListByEventHub_564537(
    name: "consumerGroupsListByEventHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/consumergroups",
    validator: validate_ConsumerGroupsListByEventHub_564538, base: "",
    url: url_ConsumerGroupsListByEventHub_564539, schemes: {Scheme.Https})
type
  Call_ConsumerGroupsCreateOrUpdate_564564 = ref object of OpenApiRestCall_563556
proc url_ConsumerGroupsCreateOrUpdate_564566(protocol: Scheme; host: string;
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

proc validate_ConsumerGroupsCreateOrUpdate_564565(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an Event Hubs consumer group as a nested resource within a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   consumerGroupName: JString (required)
  ##                    : The consumer group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564567 = path.getOrDefault("namespaceName")
  valid_564567 = validateParameter(valid_564567, JString, required = true,
                                 default = nil)
  if valid_564567 != nil:
    section.add "namespaceName", valid_564567
  var valid_564568 = path.getOrDefault("eventHubName")
  valid_564568 = validateParameter(valid_564568, JString, required = true,
                                 default = nil)
  if valid_564568 != nil:
    section.add "eventHubName", valid_564568
  var valid_564569 = path.getOrDefault("subscriptionId")
  valid_564569 = validateParameter(valid_564569, JString, required = true,
                                 default = nil)
  if valid_564569 != nil:
    section.add "subscriptionId", valid_564569
  var valid_564570 = path.getOrDefault("resourceGroupName")
  valid_564570 = validateParameter(valid_564570, JString, required = true,
                                 default = nil)
  if valid_564570 != nil:
    section.add "resourceGroupName", valid_564570
  var valid_564571 = path.getOrDefault("consumerGroupName")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "consumerGroupName", valid_564571
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564572 = query.getOrDefault("api-version")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "api-version", valid_564572
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

proc call*(call_564574: Call_ConsumerGroupsCreateOrUpdate_564564; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an Event Hubs consumer group as a nested resource within a Namespace.
  ## 
  let valid = call_564574.validator(path, query, header, formData, body)
  let scheme = call_564574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564574.url(scheme.get, call_564574.host, call_564574.base,
                         call_564574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564574, url, valid)

proc call*(call_564575: Call_ConsumerGroupsCreateOrUpdate_564564;
          apiVersion: string; namespaceName: string; eventHubName: string;
          subscriptionId: string; resourceGroupName: string;
          consumerGroupName: string; parameters: JsonNode): Recallable =
  ## consumerGroupsCreateOrUpdate
  ## Creates or updates an Event Hubs consumer group as a nested resource within a Namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   consumerGroupName: string (required)
  ##                    : The consumer group name
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update a consumer group resource.
  var path_564576 = newJObject()
  var query_564577 = newJObject()
  var body_564578 = newJObject()
  add(query_564577, "api-version", newJString(apiVersion))
  add(path_564576, "namespaceName", newJString(namespaceName))
  add(path_564576, "eventHubName", newJString(eventHubName))
  add(path_564576, "subscriptionId", newJString(subscriptionId))
  add(path_564576, "resourceGroupName", newJString(resourceGroupName))
  add(path_564576, "consumerGroupName", newJString(consumerGroupName))
  if parameters != nil:
    body_564578 = parameters
  result = call_564575.call(path_564576, query_564577, nil, nil, body_564578)

var consumerGroupsCreateOrUpdate* = Call_ConsumerGroupsCreateOrUpdate_564564(
    name: "consumerGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/consumergroups/{consumerGroupName}",
    validator: validate_ConsumerGroupsCreateOrUpdate_564565, base: "",
    url: url_ConsumerGroupsCreateOrUpdate_564566, schemes: {Scheme.Https})
type
  Call_ConsumerGroupsGet_564551 = ref object of OpenApiRestCall_563556
proc url_ConsumerGroupsGet_564553(protocol: Scheme; host: string; base: string;
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

proc validate_ConsumerGroupsGet_564552(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a description for the specified consumer group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   consumerGroupName: JString (required)
  ##                    : The consumer group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564554 = path.getOrDefault("namespaceName")
  valid_564554 = validateParameter(valid_564554, JString, required = true,
                                 default = nil)
  if valid_564554 != nil:
    section.add "namespaceName", valid_564554
  var valid_564555 = path.getOrDefault("eventHubName")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "eventHubName", valid_564555
  var valid_564556 = path.getOrDefault("subscriptionId")
  valid_564556 = validateParameter(valid_564556, JString, required = true,
                                 default = nil)
  if valid_564556 != nil:
    section.add "subscriptionId", valid_564556
  var valid_564557 = path.getOrDefault("resourceGroupName")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "resourceGroupName", valid_564557
  var valid_564558 = path.getOrDefault("consumerGroupName")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "consumerGroupName", valid_564558
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564559 = query.getOrDefault("api-version")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = nil)
  if valid_564559 != nil:
    section.add "api-version", valid_564559
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564560: Call_ConsumerGroupsGet_564551; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a description for the specified consumer group.
  ## 
  let valid = call_564560.validator(path, query, header, formData, body)
  let scheme = call_564560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564560.url(scheme.get, call_564560.host, call_564560.base,
                         call_564560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564560, url, valid)

proc call*(call_564561: Call_ConsumerGroupsGet_564551; apiVersion: string;
          namespaceName: string; eventHubName: string; subscriptionId: string;
          resourceGroupName: string; consumerGroupName: string): Recallable =
  ## consumerGroupsGet
  ## Gets a description for the specified consumer group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   consumerGroupName: string (required)
  ##                    : The consumer group name
  var path_564562 = newJObject()
  var query_564563 = newJObject()
  add(query_564563, "api-version", newJString(apiVersion))
  add(path_564562, "namespaceName", newJString(namespaceName))
  add(path_564562, "eventHubName", newJString(eventHubName))
  add(path_564562, "subscriptionId", newJString(subscriptionId))
  add(path_564562, "resourceGroupName", newJString(resourceGroupName))
  add(path_564562, "consumerGroupName", newJString(consumerGroupName))
  result = call_564561.call(path_564562, query_564563, nil, nil, nil)

var consumerGroupsGet* = Call_ConsumerGroupsGet_564551(name: "consumerGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/consumergroups/{consumerGroupName}",
    validator: validate_ConsumerGroupsGet_564552, base: "",
    url: url_ConsumerGroupsGet_564553, schemes: {Scheme.Https})
type
  Call_ConsumerGroupsDelete_564579 = ref object of OpenApiRestCall_563556
proc url_ConsumerGroupsDelete_564581(protocol: Scheme; host: string; base: string;
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

proc validate_ConsumerGroupsDelete_564580(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a consumer group from the specified Event Hub and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   consumerGroupName: JString (required)
  ##                    : The consumer group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564582 = path.getOrDefault("namespaceName")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "namespaceName", valid_564582
  var valid_564583 = path.getOrDefault("eventHubName")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "eventHubName", valid_564583
  var valid_564584 = path.getOrDefault("subscriptionId")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "subscriptionId", valid_564584
  var valid_564585 = path.getOrDefault("resourceGroupName")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "resourceGroupName", valid_564585
  var valid_564586 = path.getOrDefault("consumerGroupName")
  valid_564586 = validateParameter(valid_564586, JString, required = true,
                                 default = nil)
  if valid_564586 != nil:
    section.add "consumerGroupName", valid_564586
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564587 = query.getOrDefault("api-version")
  valid_564587 = validateParameter(valid_564587, JString, required = true,
                                 default = nil)
  if valid_564587 != nil:
    section.add "api-version", valid_564587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564588: Call_ConsumerGroupsDelete_564579; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a consumer group from the specified Event Hub and resource group.
  ## 
  let valid = call_564588.validator(path, query, header, formData, body)
  let scheme = call_564588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564588.url(scheme.get, call_564588.host, call_564588.base,
                         call_564588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564588, url, valid)

proc call*(call_564589: Call_ConsumerGroupsDelete_564579; apiVersion: string;
          namespaceName: string; eventHubName: string; subscriptionId: string;
          resourceGroupName: string; consumerGroupName: string): Recallable =
  ## consumerGroupsDelete
  ## Deletes a consumer group from the specified Event Hub and resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   consumerGroupName: string (required)
  ##                    : The consumer group name
  var path_564590 = newJObject()
  var query_564591 = newJObject()
  add(query_564591, "api-version", newJString(apiVersion))
  add(path_564590, "namespaceName", newJString(namespaceName))
  add(path_564590, "eventHubName", newJString(eventHubName))
  add(path_564590, "subscriptionId", newJString(subscriptionId))
  add(path_564590, "resourceGroupName", newJString(resourceGroupName))
  add(path_564590, "consumerGroupName", newJString(consumerGroupName))
  result = call_564589.call(path_564590, query_564591, nil, nil, nil)

var consumerGroupsDelete* = Call_ConsumerGroupsDelete_564579(
    name: "consumerGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/consumergroups/{consumerGroupName}",
    validator: validate_ConsumerGroupsDelete_564580, base: "",
    url: url_ConsumerGroupsDelete_564581, schemes: {Scheme.Https})
type
  Call_NamespacesGetMessagingPlan_564592 = ref object of OpenApiRestCall_563556
proc url_NamespacesGetMessagingPlan_564594(protocol: Scheme; host: string;
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

proc validate_NamespacesGetMessagingPlan_564593(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets messaging plan for specified namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564595 = path.getOrDefault("namespaceName")
  valid_564595 = validateParameter(valid_564595, JString, required = true,
                                 default = nil)
  if valid_564595 != nil:
    section.add "namespaceName", valid_564595
  var valid_564596 = path.getOrDefault("subscriptionId")
  valid_564596 = validateParameter(valid_564596, JString, required = true,
                                 default = nil)
  if valid_564596 != nil:
    section.add "subscriptionId", valid_564596
  var valid_564597 = path.getOrDefault("resourceGroupName")
  valid_564597 = validateParameter(valid_564597, JString, required = true,
                                 default = nil)
  if valid_564597 != nil:
    section.add "resourceGroupName", valid_564597
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564598 = query.getOrDefault("api-version")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "api-version", valid_564598
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564599: Call_NamespacesGetMessagingPlan_564592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets messaging plan for specified namespace.
  ## 
  let valid = call_564599.validator(path, query, header, formData, body)
  let scheme = call_564599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564599.url(scheme.get, call_564599.host, call_564599.base,
                         call_564599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564599, url, valid)

proc call*(call_564600: Call_NamespacesGetMessagingPlan_564592; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesGetMessagingPlan
  ## Gets messaging plan for specified namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564601 = newJObject()
  var query_564602 = newJObject()
  add(query_564602, "api-version", newJString(apiVersion))
  add(path_564601, "namespaceName", newJString(namespaceName))
  add(path_564601, "subscriptionId", newJString(subscriptionId))
  add(path_564601, "resourceGroupName", newJString(resourceGroupName))
  result = call_564600.call(path_564601, query_564602, nil, nil, nil)

var namespacesGetMessagingPlan* = Call_NamespacesGetMessagingPlan_564592(
    name: "namespacesGetMessagingPlan", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/messagingplan",
    validator: validate_NamespacesGetMessagingPlan_564593, base: "",
    url: url_NamespacesGetMessagingPlan_564594, schemes: {Scheme.Https})
type
  Call_NamespacesListNetworkRuleSets_564603 = ref object of OpenApiRestCall_563556
proc url_NamespacesListNetworkRuleSets_564605(protocol: Scheme; host: string;
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

proc validate_NamespacesListNetworkRuleSets_564604(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets list of NetworkRuleSet for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564606 = path.getOrDefault("namespaceName")
  valid_564606 = validateParameter(valid_564606, JString, required = true,
                                 default = nil)
  if valid_564606 != nil:
    section.add "namespaceName", valid_564606
  var valid_564607 = path.getOrDefault("subscriptionId")
  valid_564607 = validateParameter(valid_564607, JString, required = true,
                                 default = nil)
  if valid_564607 != nil:
    section.add "subscriptionId", valid_564607
  var valid_564608 = path.getOrDefault("resourceGroupName")
  valid_564608 = validateParameter(valid_564608, JString, required = true,
                                 default = nil)
  if valid_564608 != nil:
    section.add "resourceGroupName", valid_564608
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564609 = query.getOrDefault("api-version")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "api-version", valid_564609
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564610: Call_NamespacesListNetworkRuleSets_564603; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets list of NetworkRuleSet for a Namespace.
  ## 
  let valid = call_564610.validator(path, query, header, formData, body)
  let scheme = call_564610.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564610.url(scheme.get, call_564610.host, call_564610.base,
                         call_564610.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564610, url, valid)

proc call*(call_564611: Call_NamespacesListNetworkRuleSets_564603;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## namespacesListNetworkRuleSets
  ## Gets list of NetworkRuleSet for a Namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564612 = newJObject()
  var query_564613 = newJObject()
  add(query_564613, "api-version", newJString(apiVersion))
  add(path_564612, "namespaceName", newJString(namespaceName))
  add(path_564612, "subscriptionId", newJString(subscriptionId))
  add(path_564612, "resourceGroupName", newJString(resourceGroupName))
  result = call_564611.call(path_564612, query_564613, nil, nil, nil)

var namespacesListNetworkRuleSets* = Call_NamespacesListNetworkRuleSets_564603(
    name: "namespacesListNetworkRuleSets", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/networkRuleSets",
    validator: validate_NamespacesListNetworkRuleSets_564604, base: "",
    url: url_NamespacesListNetworkRuleSets_564605, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateNetworkRuleSet_564625 = ref object of OpenApiRestCall_563556
proc url_NamespacesCreateOrUpdateNetworkRuleSet_564627(protocol: Scheme;
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

proc validate_NamespacesCreateOrUpdateNetworkRuleSet_564626(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update NetworkRuleSet for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564628 = path.getOrDefault("namespaceName")
  valid_564628 = validateParameter(valid_564628, JString, required = true,
                                 default = nil)
  if valid_564628 != nil:
    section.add "namespaceName", valid_564628
  var valid_564629 = path.getOrDefault("subscriptionId")
  valid_564629 = validateParameter(valid_564629, JString, required = true,
                                 default = nil)
  if valid_564629 != nil:
    section.add "subscriptionId", valid_564629
  var valid_564630 = path.getOrDefault("resourceGroupName")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "resourceGroupName", valid_564630
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564631 = query.getOrDefault("api-version")
  valid_564631 = validateParameter(valid_564631, JString, required = true,
                                 default = nil)
  if valid_564631 != nil:
    section.add "api-version", valid_564631
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

proc call*(call_564633: Call_NamespacesCreateOrUpdateNetworkRuleSet_564625;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update NetworkRuleSet for a Namespace.
  ## 
  let valid = call_564633.validator(path, query, header, formData, body)
  let scheme = call_564633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564633.url(scheme.get, call_564633.host, call_564633.base,
                         call_564633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564633, url, valid)

proc call*(call_564634: Call_NamespacesCreateOrUpdateNetworkRuleSet_564625;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateNetworkRuleSet
  ## Create or update NetworkRuleSet for a Namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   parameters: JObject (required)
  ##             : The Namespace IpFilterRule.
  var path_564635 = newJObject()
  var query_564636 = newJObject()
  var body_564637 = newJObject()
  add(query_564636, "api-version", newJString(apiVersion))
  add(path_564635, "namespaceName", newJString(namespaceName))
  add(path_564635, "subscriptionId", newJString(subscriptionId))
  add(path_564635, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564637 = parameters
  result = call_564634.call(path_564635, query_564636, nil, nil, body_564637)

var namespacesCreateOrUpdateNetworkRuleSet* = Call_NamespacesCreateOrUpdateNetworkRuleSet_564625(
    name: "namespacesCreateOrUpdateNetworkRuleSet", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/networkRuleSets/default",
    validator: validate_NamespacesCreateOrUpdateNetworkRuleSet_564626, base: "",
    url: url_NamespacesCreateOrUpdateNetworkRuleSet_564627,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetNetworkRuleSet_564614 = ref object of OpenApiRestCall_563556
proc url_NamespacesGetNetworkRuleSet_564616(protocol: Scheme; host: string;
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

proc validate_NamespacesGetNetworkRuleSet_564615(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets NetworkRuleSet for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564617 = path.getOrDefault("namespaceName")
  valid_564617 = validateParameter(valid_564617, JString, required = true,
                                 default = nil)
  if valid_564617 != nil:
    section.add "namespaceName", valid_564617
  var valid_564618 = path.getOrDefault("subscriptionId")
  valid_564618 = validateParameter(valid_564618, JString, required = true,
                                 default = nil)
  if valid_564618 != nil:
    section.add "subscriptionId", valid_564618
  var valid_564619 = path.getOrDefault("resourceGroupName")
  valid_564619 = validateParameter(valid_564619, JString, required = true,
                                 default = nil)
  if valid_564619 != nil:
    section.add "resourceGroupName", valid_564619
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564620 = query.getOrDefault("api-version")
  valid_564620 = validateParameter(valid_564620, JString, required = true,
                                 default = nil)
  if valid_564620 != nil:
    section.add "api-version", valid_564620
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564621: Call_NamespacesGetNetworkRuleSet_564614; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets NetworkRuleSet for a Namespace.
  ## 
  let valid = call_564621.validator(path, query, header, formData, body)
  let scheme = call_564621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564621.url(scheme.get, call_564621.host, call_564621.base,
                         call_564621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564621, url, valid)

proc call*(call_564622: Call_NamespacesGetNetworkRuleSet_564614;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## namespacesGetNetworkRuleSet
  ## Gets NetworkRuleSet for a Namespace.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  var path_564623 = newJObject()
  var query_564624 = newJObject()
  add(query_564624, "api-version", newJString(apiVersion))
  add(path_564623, "namespaceName", newJString(namespaceName))
  add(path_564623, "subscriptionId", newJString(subscriptionId))
  add(path_564623, "resourceGroupName", newJString(resourceGroupName))
  result = call_564622.call(path_564623, query_564624, nil, nil, nil)

var namespacesGetNetworkRuleSet* = Call_NamespacesGetNetworkRuleSet_564614(
    name: "namespacesGetNetworkRuleSet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/networkRuleSets/default",
    validator: validate_NamespacesGetNetworkRuleSet_564615, base: "",
    url: url_NamespacesGetNetworkRuleSet_564616, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
