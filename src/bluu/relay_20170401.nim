
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Relay
## version: 2017-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these API to manage Azure Relay resources through Azure Resource Manager.
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "relay"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563777 = ref object of OpenApiRestCall_563555
proc url_OperationsList_563779(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563778(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all available Relay REST API operations.
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
  var valid_563940 = query.getOrDefault("api-version")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "api-version", valid_563940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563963: Call_OperationsList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all available Relay REST API operations.
  ## 
  let valid = call_563963.validator(path, query, header, formData, body)
  let scheme = call_563963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563963.url(scheme.get, call_563963.host, call_563963.base,
                         call_563963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563963, url, valid)

proc call*(call_564034: Call_OperationsList_563777; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all available Relay REST API operations.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_564035 = newJObject()
  add(query_564035, "api-version", newJString(apiVersion))
  result = call_564034.call(nil, query_564035, nil, nil, nil)

var operationsList* = Call_OperationsList_563777(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Relay/operations",
    validator: validate_OperationsList_563778, base: "", url: url_OperationsList_563779,
    schemes: {Scheme.Https})
type
  Call_NamespacesCheckNameAvailability_564075 = ref object of OpenApiRestCall_563555
proc url_NamespacesCheckNameAvailability_564077(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Relay/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCheckNameAvailability_564076(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the specified namespace name availability.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564109 = path.getOrDefault("subscriptionId")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "subscriptionId", valid_564109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564110 = query.getOrDefault("api-version")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "api-version", valid_564110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the specified namespace name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564112: Call_NamespacesCheckNameAvailability_564075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the specified namespace name availability.
  ## 
  let valid = call_564112.validator(path, query, header, formData, body)
  let scheme = call_564112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564112.url(scheme.get, call_564112.host, call_564112.base,
                         call_564112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564112, url, valid)

proc call*(call_564113: Call_NamespacesCheckNameAvailability_564075;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCheckNameAvailability
  ## Check the specified namespace name availability.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the specified namespace name.
  var path_564114 = newJObject()
  var query_564115 = newJObject()
  var body_564116 = newJObject()
  add(query_564115, "api-version", newJString(apiVersion))
  add(path_564114, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564116 = parameters
  result = call_564113.call(path_564114, query_564115, nil, nil, body_564116)

var namespacesCheckNameAvailability* = Call_NamespacesCheckNameAvailability_564075(
    name: "namespacesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Relay/checkNameAvailability",
    validator: validate_NamespacesCheckNameAvailability_564076, base: "",
    url: url_NamespacesCheckNameAvailability_564077, schemes: {Scheme.Https})
type
  Call_NamespacesList_564117 = ref object of OpenApiRestCall_563555
proc url_NamespacesList_564119(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesList_564118(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the available namespaces within the subscription regardless of the resourceGroups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564120 = path.getOrDefault("subscriptionId")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "subscriptionId", valid_564120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564121 = query.getOrDefault("api-version")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "api-version", valid_564121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564122: Call_NamespacesList_564117; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available namespaces within the subscription regardless of the resourceGroups.
  ## 
  let valid = call_564122.validator(path, query, header, formData, body)
  let scheme = call_564122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564122.url(scheme.get, call_564122.host, call_564122.base,
                         call_564122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564122, url, valid)

proc call*(call_564123: Call_NamespacesList_564117; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesList
  ## Lists all the available namespaces within the subscription regardless of the resourceGroups.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564124 = newJObject()
  var query_564125 = newJObject()
  add(query_564125, "api-version", newJString(apiVersion))
  add(path_564124, "subscriptionId", newJString(subscriptionId))
  result = call_564123.call(path_564124, query_564125, nil, nil, nil)

var namespacesList* = Call_NamespacesList_564117(name: "namespacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Relay/namespaces",
    validator: validate_NamespacesList_564118, base: "", url: url_NamespacesList_564119,
    schemes: {Scheme.Https})
type
  Call_NamespacesListByResourceGroup_564126 = ref object of OpenApiRestCall_563555
proc url_NamespacesListByResourceGroup_564128(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListByResourceGroup_564127(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available namespaces within the ResourceGroup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564129 = path.getOrDefault("subscriptionId")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "subscriptionId", valid_564129
  var valid_564130 = path.getOrDefault("resourceGroupName")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "resourceGroupName", valid_564130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564131 = query.getOrDefault("api-version")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "api-version", valid_564131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564132: Call_NamespacesListByResourceGroup_564126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available namespaces within the ResourceGroup.
  ## 
  let valid = call_564132.validator(path, query, header, formData, body)
  let scheme = call_564132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564132.url(scheme.get, call_564132.host, call_564132.base,
                         call_564132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564132, url, valid)

proc call*(call_564133: Call_NamespacesListByResourceGroup_564126;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesListByResourceGroup
  ## Lists all the available namespaces within the ResourceGroup.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564134 = newJObject()
  var query_564135 = newJObject()
  add(query_564135, "api-version", newJString(apiVersion))
  add(path_564134, "subscriptionId", newJString(subscriptionId))
  add(path_564134, "resourceGroupName", newJString(resourceGroupName))
  result = call_564133.call(path_564134, query_564135, nil, nil, nil)

var namespacesListByResourceGroup* = Call_NamespacesListByResourceGroup_564126(
    name: "namespacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces",
    validator: validate_NamespacesListByResourceGroup_564127, base: "",
    url: url_NamespacesListByResourceGroup_564128, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdate_564147 = ref object of OpenApiRestCall_563555
proc url_NamespacesCreateOrUpdate_564149(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdate_564148(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create Azure Relay namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
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
  ##              : Client API version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a namespace resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564155: Call_NamespacesCreateOrUpdate_564147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create Azure Relay namespace.
  ## 
  let valid = call_564155.validator(path, query, header, formData, body)
  let scheme = call_564155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564155.url(scheme.get, call_564155.host, call_564155.base,
                         call_564155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564155, url, valid)

proc call*(call_564156: Call_NamespacesCreateOrUpdate_564147; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdate
  ## Create Azure Relay namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a namespace resource.
  var path_564157 = newJObject()
  var query_564158 = newJObject()
  var body_564159 = newJObject()
  add(query_564158, "api-version", newJString(apiVersion))
  add(path_564157, "namespaceName", newJString(namespaceName))
  add(path_564157, "subscriptionId", newJString(subscriptionId))
  add(path_564157, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564159 = parameters
  result = call_564156.call(path_564157, query_564158, nil, nil, body_564159)

var namespacesCreateOrUpdate* = Call_NamespacesCreateOrUpdate_564147(
    name: "namespacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}",
    validator: validate_NamespacesCreateOrUpdate_564148, base: "",
    url: url_NamespacesCreateOrUpdate_564149, schemes: {Scheme.Https})
type
  Call_NamespacesGet_564136 = ref object of OpenApiRestCall_563555
proc url_NamespacesGet_564138(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGet_564137(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the description for the specified namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564139 = path.getOrDefault("namespaceName")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "namespaceName", valid_564139
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
  ##              : Client API version.
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

proc call*(call_564143: Call_NamespacesGet_564136; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the description for the specified namespace.
  ## 
  let valid = call_564143.validator(path, query, header, formData, body)
  let scheme = call_564143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564143.url(scheme.get, call_564143.host, call_564143.base,
                         call_564143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564143, url, valid)

proc call*(call_564144: Call_NamespacesGet_564136; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesGet
  ## Returns the description for the specified namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564145 = newJObject()
  var query_564146 = newJObject()
  add(query_564146, "api-version", newJString(apiVersion))
  add(path_564145, "namespaceName", newJString(namespaceName))
  add(path_564145, "subscriptionId", newJString(subscriptionId))
  add(path_564145, "resourceGroupName", newJString(resourceGroupName))
  result = call_564144.call(path_564145, query_564146, nil, nil, nil)

var namespacesGet* = Call_NamespacesGet_564136(name: "namespacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}",
    validator: validate_NamespacesGet_564137, base: "", url: url_NamespacesGet_564138,
    schemes: {Scheme.Https})
type
  Call_NamespacesUpdate_564171 = ref object of OpenApiRestCall_563555
proc url_NamespacesUpdate_564173(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesUpdate_564172(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564174 = path.getOrDefault("namespaceName")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "namespaceName", valid_564174
  var valid_564175 = path.getOrDefault("subscriptionId")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "subscriptionId", valid_564175
  var valid_564176 = path.getOrDefault("resourceGroupName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "resourceGroupName", valid_564176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564177 = query.getOrDefault("api-version")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "api-version", valid_564177
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

proc call*(call_564179: Call_NamespacesUpdate_564171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  let valid = call_564179.validator(path, query, header, formData, body)
  let scheme = call_564179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564179.url(scheme.get, call_564179.host, call_564179.base,
                         call_564179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564179, url, valid)

proc call*(call_564180: Call_NamespacesUpdate_564171; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## namespacesUpdate
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for updating a namespace resource.
  var path_564181 = newJObject()
  var query_564182 = newJObject()
  var body_564183 = newJObject()
  add(query_564182, "api-version", newJString(apiVersion))
  add(path_564181, "namespaceName", newJString(namespaceName))
  add(path_564181, "subscriptionId", newJString(subscriptionId))
  add(path_564181, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564183 = parameters
  result = call_564180.call(path_564181, query_564182, nil, nil, body_564183)

var namespacesUpdate* = Call_NamespacesUpdate_564171(name: "namespacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}",
    validator: validate_NamespacesUpdate_564172, base: "",
    url: url_NamespacesUpdate_564173, schemes: {Scheme.Https})
type
  Call_NamespacesDelete_564160 = ref object of OpenApiRestCall_563555
proc url_NamespacesDelete_564162(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDelete_564161(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564163 = path.getOrDefault("namespaceName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "namespaceName", valid_564163
  var valid_564164 = path.getOrDefault("subscriptionId")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "subscriptionId", valid_564164
  var valid_564165 = path.getOrDefault("resourceGroupName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "resourceGroupName", valid_564165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564166 = query.getOrDefault("api-version")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "api-version", valid_564166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564167: Call_NamespacesDelete_564160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  let valid = call_564167.validator(path, query, header, formData, body)
  let scheme = call_564167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564167.url(scheme.get, call_564167.host, call_564167.base,
                         call_564167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564167, url, valid)

proc call*(call_564168: Call_NamespacesDelete_564160; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesDelete
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564169 = newJObject()
  var query_564170 = newJObject()
  add(query_564170, "api-version", newJString(apiVersion))
  add(path_564169, "namespaceName", newJString(namespaceName))
  add(path_564169, "subscriptionId", newJString(subscriptionId))
  add(path_564169, "resourceGroupName", newJString(resourceGroupName))
  result = call_564168.call(path_564169, query_564170, nil, nil, nil)

var namespacesDelete* = Call_NamespacesDelete_564160(name: "namespacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}",
    validator: validate_NamespacesDelete_564161, base: "",
    url: url_NamespacesDelete_564162, schemes: {Scheme.Https})
type
  Call_NamespacesListAuthorizationRules_564184 = ref object of OpenApiRestCall_563555
proc url_NamespacesListAuthorizationRules_564186(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/authorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListAuthorizationRules_564185(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rules for a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564187 = path.getOrDefault("namespaceName")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "namespaceName", valid_564187
  var valid_564188 = path.getOrDefault("subscriptionId")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "subscriptionId", valid_564188
  var valid_564189 = path.getOrDefault("resourceGroupName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "resourceGroupName", valid_564189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564190 = query.getOrDefault("api-version")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "api-version", valid_564190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564191: Call_NamespacesListAuthorizationRules_564184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rules for a namespace.
  ## 
  let valid = call_564191.validator(path, query, header, formData, body)
  let scheme = call_564191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564191.url(scheme.get, call_564191.host, call_564191.base,
                         call_564191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564191, url, valid)

proc call*(call_564192: Call_NamespacesListAuthorizationRules_564184;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## namespacesListAuthorizationRules
  ## Authorization rules for a namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564193 = newJObject()
  var query_564194 = newJObject()
  add(query_564194, "api-version", newJString(apiVersion))
  add(path_564193, "namespaceName", newJString(namespaceName))
  add(path_564193, "subscriptionId", newJString(subscriptionId))
  add(path_564193, "resourceGroupName", newJString(resourceGroupName))
  result = call_564192.call(path_564193, query_564194, nil, nil, nil)

var namespacesListAuthorizationRules* = Call_NamespacesListAuthorizationRules_564184(
    name: "namespacesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/authorizationRules",
    validator: validate_NamespacesListAuthorizationRules_564185, base: "",
    url: url_NamespacesListAuthorizationRules_564186, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateAuthorizationRule_564207 = ref object of OpenApiRestCall_563555
proc url_NamespacesCreateOrUpdateAuthorizationRule_564209(protocol: Scheme;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdateAuthorizationRule_564208(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an authorization rule for a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564210 = path.getOrDefault("namespaceName")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "namespaceName", valid_564210
  var valid_564211 = path.getOrDefault("subscriptionId")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "subscriptionId", valid_564211
  var valid_564212 = path.getOrDefault("authorizationRuleName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "authorizationRuleName", valid_564212
  var valid_564213 = path.getOrDefault("resourceGroupName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "resourceGroupName", valid_564213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564214 = query.getOrDefault("api-version")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "api-version", valid_564214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564216: Call_NamespacesCreateOrUpdateAuthorizationRule_564207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an authorization rule for a namespace.
  ## 
  let valid = call_564216.validator(path, query, header, formData, body)
  let scheme = call_564216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564216.url(scheme.get, call_564216.host, call_564216.base,
                         call_564216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564216, url, valid)

proc call*(call_564217: Call_NamespacesCreateOrUpdateAuthorizationRule_564207;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateAuthorizationRule
  ## Creates or updates an authorization rule for a namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters.
  var path_564218 = newJObject()
  var query_564219 = newJObject()
  var body_564220 = newJObject()
  add(query_564219, "api-version", newJString(apiVersion))
  add(path_564218, "namespaceName", newJString(namespaceName))
  add(path_564218, "subscriptionId", newJString(subscriptionId))
  add(path_564218, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564218, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564220 = parameters
  result = call_564217.call(path_564218, query_564219, nil, nil, body_564220)

var namespacesCreateOrUpdateAuthorizationRule* = Call_NamespacesCreateOrUpdateAuthorizationRule_564207(
    name: "namespacesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/authorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesCreateOrUpdateAuthorizationRule_564208,
    base: "", url: url_NamespacesCreateOrUpdateAuthorizationRule_564209,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetAuthorizationRule_564195 = ref object of OpenApiRestCall_563555
proc url_NamespacesGetAuthorizationRule_564197(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGetAuthorizationRule_564196(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rule for a namespace by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564198 = path.getOrDefault("namespaceName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "namespaceName", valid_564198
  var valid_564199 = path.getOrDefault("subscriptionId")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "subscriptionId", valid_564199
  var valid_564200 = path.getOrDefault("authorizationRuleName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "authorizationRuleName", valid_564200
  var valid_564201 = path.getOrDefault("resourceGroupName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "resourceGroupName", valid_564201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564202 = query.getOrDefault("api-version")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "api-version", valid_564202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564203: Call_NamespacesGetAuthorizationRule_564195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Authorization rule for a namespace by name.
  ## 
  let valid = call_564203.validator(path, query, header, formData, body)
  let scheme = call_564203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564203.url(scheme.get, call_564203.host, call_564203.base,
                         call_564203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564203, url, valid)

proc call*(call_564204: Call_NamespacesGetAuthorizationRule_564195;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string): Recallable =
  ## namespacesGetAuthorizationRule
  ## Authorization rule for a namespace by name.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564205 = newJObject()
  var query_564206 = newJObject()
  add(query_564206, "api-version", newJString(apiVersion))
  add(path_564205, "namespaceName", newJString(namespaceName))
  add(path_564205, "subscriptionId", newJString(subscriptionId))
  add(path_564205, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564205, "resourceGroupName", newJString(resourceGroupName))
  result = call_564204.call(path_564205, query_564206, nil, nil, nil)

var namespacesGetAuthorizationRule* = Call_NamespacesGetAuthorizationRule_564195(
    name: "namespacesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/authorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesGetAuthorizationRule_564196, base: "",
    url: url_NamespacesGetAuthorizationRule_564197, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteAuthorizationRule_564221 = ref object of OpenApiRestCall_563555
proc url_NamespacesDeleteAuthorizationRule_564223(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDeleteAuthorizationRule_564222(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a namespace authorization rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564224 = path.getOrDefault("namespaceName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "namespaceName", valid_564224
  var valid_564225 = path.getOrDefault("subscriptionId")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "subscriptionId", valid_564225
  var valid_564226 = path.getOrDefault("authorizationRuleName")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "authorizationRuleName", valid_564226
  var valid_564227 = path.getOrDefault("resourceGroupName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "resourceGroupName", valid_564227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564228 = query.getOrDefault("api-version")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "api-version", valid_564228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564229: Call_NamespacesDeleteAuthorizationRule_564221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a namespace authorization rule.
  ## 
  let valid = call_564229.validator(path, query, header, formData, body)
  let scheme = call_564229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564229.url(scheme.get, call_564229.host, call_564229.base,
                         call_564229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564229, url, valid)

proc call*(call_564230: Call_NamespacesDeleteAuthorizationRule_564221;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string): Recallable =
  ## namespacesDeleteAuthorizationRule
  ## Deletes a namespace authorization rule.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564231 = newJObject()
  var query_564232 = newJObject()
  add(query_564232, "api-version", newJString(apiVersion))
  add(path_564231, "namespaceName", newJString(namespaceName))
  add(path_564231, "subscriptionId", newJString(subscriptionId))
  add(path_564231, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564231, "resourceGroupName", newJString(resourceGroupName))
  result = call_564230.call(path_564231, query_564232, nil, nil, nil)

var namespacesDeleteAuthorizationRule* = Call_NamespacesDeleteAuthorizationRule_564221(
    name: "namespacesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/authorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesDeleteAuthorizationRule_564222, base: "",
    url: url_NamespacesDeleteAuthorizationRule_564223, schemes: {Scheme.Https})
type
  Call_NamespacesListKeys_564233 = ref object of OpenApiRestCall_563555
proc url_NamespacesListKeys_564235(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListKeys_564234(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Primary and secondary connection strings to the namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564236 = path.getOrDefault("namespaceName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "namespaceName", valid_564236
  var valid_564237 = path.getOrDefault("subscriptionId")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "subscriptionId", valid_564237
  var valid_564238 = path.getOrDefault("authorizationRuleName")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "authorizationRuleName", valid_564238
  var valid_564239 = path.getOrDefault("resourceGroupName")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "resourceGroupName", valid_564239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564240 = query.getOrDefault("api-version")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "api-version", valid_564240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564241: Call_NamespacesListKeys_564233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Primary and secondary connection strings to the namespace.
  ## 
  let valid = call_564241.validator(path, query, header, formData, body)
  let scheme = call_564241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564241.url(scheme.get, call_564241.host, call_564241.base,
                         call_564241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564241, url, valid)

proc call*(call_564242: Call_NamespacesListKeys_564233; apiVersion: string;
          namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string): Recallable =
  ## namespacesListKeys
  ## Primary and secondary connection strings to the namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564243 = newJObject()
  var query_564244 = newJObject()
  add(query_564244, "api-version", newJString(apiVersion))
  add(path_564243, "namespaceName", newJString(namespaceName))
  add(path_564243, "subscriptionId", newJString(subscriptionId))
  add(path_564243, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564243, "resourceGroupName", newJString(resourceGroupName))
  result = call_564242.call(path_564243, query_564244, nil, nil, nil)

var namespacesListKeys* = Call_NamespacesListKeys_564233(
    name: "namespacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/authorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_NamespacesListKeys_564234, base: "",
    url: url_NamespacesListKeys_564235, schemes: {Scheme.Https})
type
  Call_NamespacesRegenerateKeys_564245 = ref object of OpenApiRestCall_563555
proc url_NamespacesRegenerateKeys_564247(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesRegenerateKeys_564246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary or secondary connection strings to the namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564248 = path.getOrDefault("namespaceName")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "namespaceName", valid_564248
  var valid_564249 = path.getOrDefault("subscriptionId")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "subscriptionId", valid_564249
  var valid_564250 = path.getOrDefault("authorizationRuleName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "authorizationRuleName", valid_564250
  var valid_564251 = path.getOrDefault("resourceGroupName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "resourceGroupName", valid_564251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564252 = query.getOrDefault("api-version")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "api-version", valid_564252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564254: Call_NamespacesRegenerateKeys_564245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the primary or secondary connection strings to the namespace.
  ## 
  let valid = call_564254.validator(path, query, header, formData, body)
  let scheme = call_564254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564254.url(scheme.get, call_564254.host, call_564254.base,
                         call_564254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564254, url, valid)

proc call*(call_564255: Call_NamespacesRegenerateKeys_564245; apiVersion: string;
          namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## namespacesRegenerateKeys
  ## Regenerates the primary or secondary connection strings to the namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate authorization rule.
  var path_564256 = newJObject()
  var query_564257 = newJObject()
  var body_564258 = newJObject()
  add(query_564257, "api-version", newJString(apiVersion))
  add(path_564256, "namespaceName", newJString(namespaceName))
  add(path_564256, "subscriptionId", newJString(subscriptionId))
  add(path_564256, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564256, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564258 = parameters
  result = call_564255.call(path_564256, query_564257, nil, nil, body_564258)

var namespacesRegenerateKeys* = Call_NamespacesRegenerateKeys_564245(
    name: "namespacesRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_NamespacesRegenerateKeys_564246, base: "",
    url: url_NamespacesRegenerateKeys_564247, schemes: {Scheme.Https})
type
  Call_HybridConnectionsListByNamespace_564259 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsListByNamespace_564261(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/hybridConnections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsListByNamespace_564260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the hybrid connection within the namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564262 = path.getOrDefault("namespaceName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "namespaceName", valid_564262
  var valid_564263 = path.getOrDefault("subscriptionId")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "subscriptionId", valid_564263
  var valid_564264 = path.getOrDefault("resourceGroupName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "resourceGroupName", valid_564264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564265 = query.getOrDefault("api-version")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "api-version", valid_564265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564266: Call_HybridConnectionsListByNamespace_564259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the hybrid connection within the namespace.
  ## 
  let valid = call_564266.validator(path, query, header, formData, body)
  let scheme = call_564266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564266.url(scheme.get, call_564266.host, call_564266.base,
                         call_564266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564266, url, valid)

proc call*(call_564267: Call_HybridConnectionsListByNamespace_564259;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## hybridConnectionsListByNamespace
  ## Lists the hybrid connection within the namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564268 = newJObject()
  var query_564269 = newJObject()
  add(query_564269, "api-version", newJString(apiVersion))
  add(path_564268, "namespaceName", newJString(namespaceName))
  add(path_564268, "subscriptionId", newJString(subscriptionId))
  add(path_564268, "resourceGroupName", newJString(resourceGroupName))
  result = call_564267.call(path_564268, query_564269, nil, nil, nil)

var hybridConnectionsListByNamespace* = Call_HybridConnectionsListByNamespace_564259(
    name: "hybridConnectionsListByNamespace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections",
    validator: validate_HybridConnectionsListByNamespace_564260, base: "",
    url: url_HybridConnectionsListByNamespace_564261, schemes: {Scheme.Https})
type
  Call_HybridConnectionsCreateOrUpdate_564282 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsCreateOrUpdate_564284(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "hybridConnectionName" in path,
        "`hybridConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/hybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsCreateOrUpdate_564283(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a service hybrid connection. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564295 = path.getOrDefault("namespaceName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "namespaceName", valid_564295
  var valid_564296 = path.getOrDefault("hybridConnectionName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "hybridConnectionName", valid_564296
  var valid_564297 = path.getOrDefault("subscriptionId")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "subscriptionId", valid_564297
  var valid_564298 = path.getOrDefault("resourceGroupName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "resourceGroupName", valid_564298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564299 = query.getOrDefault("api-version")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "api-version", valid_564299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a hybrid connection.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564301: Call_HybridConnectionsCreateOrUpdate_564282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a service hybrid connection. This operation is idempotent.
  ## 
  let valid = call_564301.validator(path, query, header, formData, body)
  let scheme = call_564301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564301.url(scheme.get, call_564301.host, call_564301.base,
                         call_564301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564301, url, valid)

proc call*(call_564302: Call_HybridConnectionsCreateOrUpdate_564282;
          apiVersion: string; namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## hybridConnectionsCreateOrUpdate
  ## Creates or updates a service hybrid connection. This operation is idempotent.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a hybrid connection.
  var path_564303 = newJObject()
  var query_564304 = newJObject()
  var body_564305 = newJObject()
  add(query_564304, "api-version", newJString(apiVersion))
  add(path_564303, "namespaceName", newJString(namespaceName))
  add(path_564303, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564303, "subscriptionId", newJString(subscriptionId))
  add(path_564303, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564305 = parameters
  result = call_564302.call(path_564303, query_564304, nil, nil, body_564305)

var hybridConnectionsCreateOrUpdate* = Call_HybridConnectionsCreateOrUpdate_564282(
    name: "hybridConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}",
    validator: validate_HybridConnectionsCreateOrUpdate_564283, base: "",
    url: url_HybridConnectionsCreateOrUpdate_564284, schemes: {Scheme.Https})
type
  Call_HybridConnectionsGet_564270 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsGet_564272(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "hybridConnectionName" in path,
        "`hybridConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/hybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsGet_564271(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the description for the specified hybrid connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564273 = path.getOrDefault("namespaceName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "namespaceName", valid_564273
  var valid_564274 = path.getOrDefault("hybridConnectionName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "hybridConnectionName", valid_564274
  var valid_564275 = path.getOrDefault("subscriptionId")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "subscriptionId", valid_564275
  var valid_564276 = path.getOrDefault("resourceGroupName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "resourceGroupName", valid_564276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564277 = query.getOrDefault("api-version")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "api-version", valid_564277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564278: Call_HybridConnectionsGet_564270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the description for the specified hybrid connection.
  ## 
  let valid = call_564278.validator(path, query, header, formData, body)
  let scheme = call_564278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564278.url(scheme.get, call_564278.host, call_564278.base,
                         call_564278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564278, url, valid)

proc call*(call_564279: Call_HybridConnectionsGet_564270; apiVersion: string;
          namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## hybridConnectionsGet
  ## Returns the description for the specified hybrid connection.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564280 = newJObject()
  var query_564281 = newJObject()
  add(query_564281, "api-version", newJString(apiVersion))
  add(path_564280, "namespaceName", newJString(namespaceName))
  add(path_564280, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564280, "subscriptionId", newJString(subscriptionId))
  add(path_564280, "resourceGroupName", newJString(resourceGroupName))
  result = call_564279.call(path_564280, query_564281, nil, nil, nil)

var hybridConnectionsGet* = Call_HybridConnectionsGet_564270(
    name: "hybridConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}",
    validator: validate_HybridConnectionsGet_564271, base: "",
    url: url_HybridConnectionsGet_564272, schemes: {Scheme.Https})
type
  Call_HybridConnectionsDelete_564306 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsDelete_564308(protocol: Scheme; host: string; base: string;
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
  assert "hybridConnectionName" in path,
        "`hybridConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/hybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsDelete_564307(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a hybrid connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564309 = path.getOrDefault("namespaceName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "namespaceName", valid_564309
  var valid_564310 = path.getOrDefault("hybridConnectionName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "hybridConnectionName", valid_564310
  var valid_564311 = path.getOrDefault("subscriptionId")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "subscriptionId", valid_564311
  var valid_564312 = path.getOrDefault("resourceGroupName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "resourceGroupName", valid_564312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564313 = query.getOrDefault("api-version")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "api-version", valid_564313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564314: Call_HybridConnectionsDelete_564306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a hybrid connection.
  ## 
  let valid = call_564314.validator(path, query, header, formData, body)
  let scheme = call_564314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564314.url(scheme.get, call_564314.host, call_564314.base,
                         call_564314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564314, url, valid)

proc call*(call_564315: Call_HybridConnectionsDelete_564306; apiVersion: string;
          namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## hybridConnectionsDelete
  ## Deletes a hybrid connection.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564316 = newJObject()
  var query_564317 = newJObject()
  add(query_564317, "api-version", newJString(apiVersion))
  add(path_564316, "namespaceName", newJString(namespaceName))
  add(path_564316, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564316, "subscriptionId", newJString(subscriptionId))
  add(path_564316, "resourceGroupName", newJString(resourceGroupName))
  result = call_564315.call(path_564316, query_564317, nil, nil, nil)

var hybridConnectionsDelete* = Call_HybridConnectionsDelete_564306(
    name: "hybridConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}",
    validator: validate_HybridConnectionsDelete_564307, base: "",
    url: url_HybridConnectionsDelete_564308, schemes: {Scheme.Https})
type
  Call_HybridConnectionsListAuthorizationRules_564318 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsListAuthorizationRules_564320(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "hybridConnectionName" in path,
        "`hybridConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/hybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName"),
               (kind: ConstantSegment, value: "/authorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsListAuthorizationRules_564319(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rules for a hybrid connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564321 = path.getOrDefault("namespaceName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "namespaceName", valid_564321
  var valid_564322 = path.getOrDefault("hybridConnectionName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "hybridConnectionName", valid_564322
  var valid_564323 = path.getOrDefault("subscriptionId")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "subscriptionId", valid_564323
  var valid_564324 = path.getOrDefault("resourceGroupName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "resourceGroupName", valid_564324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564325 = query.getOrDefault("api-version")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "api-version", valid_564325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564326: Call_HybridConnectionsListAuthorizationRules_564318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rules for a hybrid connection.
  ## 
  let valid = call_564326.validator(path, query, header, formData, body)
  let scheme = call_564326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564326.url(scheme.get, call_564326.host, call_564326.base,
                         call_564326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564326, url, valid)

proc call*(call_564327: Call_HybridConnectionsListAuthorizationRules_564318;
          apiVersion: string; namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## hybridConnectionsListAuthorizationRules
  ## Authorization rules for a hybrid connection.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564328 = newJObject()
  var query_564329 = newJObject()
  add(query_564329, "api-version", newJString(apiVersion))
  add(path_564328, "namespaceName", newJString(namespaceName))
  add(path_564328, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564328, "subscriptionId", newJString(subscriptionId))
  add(path_564328, "resourceGroupName", newJString(resourceGroupName))
  result = call_564327.call(path_564328, query_564329, nil, nil, nil)

var hybridConnectionsListAuthorizationRules* = Call_HybridConnectionsListAuthorizationRules_564318(
    name: "hybridConnectionsListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}/authorizationRules",
    validator: validate_HybridConnectionsListAuthorizationRules_564319, base: "",
    url: url_HybridConnectionsListAuthorizationRules_564320,
    schemes: {Scheme.Https})
type
  Call_HybridConnectionsCreateOrUpdateAuthorizationRule_564343 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsCreateOrUpdateAuthorizationRule_564345(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "hybridConnectionName" in path,
        "`hybridConnectionName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/hybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsCreateOrUpdateAuthorizationRule_564344(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates an authorization rule for a hybrid connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564346 = path.getOrDefault("namespaceName")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "namespaceName", valid_564346
  var valid_564347 = path.getOrDefault("hybridConnectionName")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "hybridConnectionName", valid_564347
  var valid_564348 = path.getOrDefault("subscriptionId")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "subscriptionId", valid_564348
  var valid_564349 = path.getOrDefault("authorizationRuleName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "authorizationRuleName", valid_564349
  var valid_564350 = path.getOrDefault("resourceGroupName")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "resourceGroupName", valid_564350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564351 = query.getOrDefault("api-version")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "api-version", valid_564351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564353: Call_HybridConnectionsCreateOrUpdateAuthorizationRule_564343;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an authorization rule for a hybrid connection.
  ## 
  let valid = call_564353.validator(path, query, header, formData, body)
  let scheme = call_564353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564353.url(scheme.get, call_564353.host, call_564353.base,
                         call_564353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564353, url, valid)

proc call*(call_564354: Call_HybridConnectionsCreateOrUpdateAuthorizationRule_564343;
          apiVersion: string; namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## hybridConnectionsCreateOrUpdateAuthorizationRule
  ## Creates or updates an authorization rule for a hybrid connection.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters.
  var path_564355 = newJObject()
  var query_564356 = newJObject()
  var body_564357 = newJObject()
  add(query_564356, "api-version", newJString(apiVersion))
  add(path_564355, "namespaceName", newJString(namespaceName))
  add(path_564355, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564355, "subscriptionId", newJString(subscriptionId))
  add(path_564355, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564355, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564357 = parameters
  result = call_564354.call(path_564355, query_564356, nil, nil, body_564357)

var hybridConnectionsCreateOrUpdateAuthorizationRule* = Call_HybridConnectionsCreateOrUpdateAuthorizationRule_564343(
    name: "hybridConnectionsCreateOrUpdateAuthorizationRule",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}",
    validator: validate_HybridConnectionsCreateOrUpdateAuthorizationRule_564344,
    base: "", url: url_HybridConnectionsCreateOrUpdateAuthorizationRule_564345,
    schemes: {Scheme.Https})
type
  Call_HybridConnectionsGetAuthorizationRule_564330 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsGetAuthorizationRule_564332(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "hybridConnectionName" in path,
        "`hybridConnectionName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/hybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsGetAuthorizationRule_564331(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Hybrid connection authorization rule for a hybrid connection by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564333 = path.getOrDefault("namespaceName")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "namespaceName", valid_564333
  var valid_564334 = path.getOrDefault("hybridConnectionName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "hybridConnectionName", valid_564334
  var valid_564335 = path.getOrDefault("subscriptionId")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "subscriptionId", valid_564335
  var valid_564336 = path.getOrDefault("authorizationRuleName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "authorizationRuleName", valid_564336
  var valid_564337 = path.getOrDefault("resourceGroupName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "resourceGroupName", valid_564337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564338 = query.getOrDefault("api-version")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "api-version", valid_564338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564339: Call_HybridConnectionsGetAuthorizationRule_564330;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Hybrid connection authorization rule for a hybrid connection by name.
  ## 
  let valid = call_564339.validator(path, query, header, formData, body)
  let scheme = call_564339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564339.url(scheme.get, call_564339.host, call_564339.base,
                         call_564339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564339, url, valid)

proc call*(call_564340: Call_HybridConnectionsGetAuthorizationRule_564330;
          apiVersion: string; namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string): Recallable =
  ## hybridConnectionsGetAuthorizationRule
  ## Hybrid connection authorization rule for a hybrid connection by name.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564341 = newJObject()
  var query_564342 = newJObject()
  add(query_564342, "api-version", newJString(apiVersion))
  add(path_564341, "namespaceName", newJString(namespaceName))
  add(path_564341, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564341, "subscriptionId", newJString(subscriptionId))
  add(path_564341, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564341, "resourceGroupName", newJString(resourceGroupName))
  result = call_564340.call(path_564341, query_564342, nil, nil, nil)

var hybridConnectionsGetAuthorizationRule* = Call_HybridConnectionsGetAuthorizationRule_564330(
    name: "hybridConnectionsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}",
    validator: validate_HybridConnectionsGetAuthorizationRule_564331, base: "",
    url: url_HybridConnectionsGetAuthorizationRule_564332, schemes: {Scheme.Https})
type
  Call_HybridConnectionsDeleteAuthorizationRule_564358 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsDeleteAuthorizationRule_564360(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "hybridConnectionName" in path,
        "`hybridConnectionName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/hybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsDeleteAuthorizationRule_564359(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a hybrid connection authorization rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564361 = path.getOrDefault("namespaceName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "namespaceName", valid_564361
  var valid_564362 = path.getOrDefault("hybridConnectionName")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "hybridConnectionName", valid_564362
  var valid_564363 = path.getOrDefault("subscriptionId")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "subscriptionId", valid_564363
  var valid_564364 = path.getOrDefault("authorizationRuleName")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "authorizationRuleName", valid_564364
  var valid_564365 = path.getOrDefault("resourceGroupName")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "resourceGroupName", valid_564365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564366 = query.getOrDefault("api-version")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "api-version", valid_564366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564367: Call_HybridConnectionsDeleteAuthorizationRule_564358;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a hybrid connection authorization rule.
  ## 
  let valid = call_564367.validator(path, query, header, formData, body)
  let scheme = call_564367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564367.url(scheme.get, call_564367.host, call_564367.base,
                         call_564367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564367, url, valid)

proc call*(call_564368: Call_HybridConnectionsDeleteAuthorizationRule_564358;
          apiVersion: string; namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string): Recallable =
  ## hybridConnectionsDeleteAuthorizationRule
  ## Deletes a hybrid connection authorization rule.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564369 = newJObject()
  var query_564370 = newJObject()
  add(query_564370, "api-version", newJString(apiVersion))
  add(path_564369, "namespaceName", newJString(namespaceName))
  add(path_564369, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564369, "subscriptionId", newJString(subscriptionId))
  add(path_564369, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564369, "resourceGroupName", newJString(resourceGroupName))
  result = call_564368.call(path_564369, query_564370, nil, nil, nil)

var hybridConnectionsDeleteAuthorizationRule* = Call_HybridConnectionsDeleteAuthorizationRule_564358(
    name: "hybridConnectionsDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}",
    validator: validate_HybridConnectionsDeleteAuthorizationRule_564359, base: "",
    url: url_HybridConnectionsDeleteAuthorizationRule_564360,
    schemes: {Scheme.Https})
type
  Call_HybridConnectionsListKeys_564371 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsListKeys_564373(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "hybridConnectionName" in path,
        "`hybridConnectionName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/hybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsListKeys_564372(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Primary and secondary connection strings to the hybrid connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564374 = path.getOrDefault("namespaceName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "namespaceName", valid_564374
  var valid_564375 = path.getOrDefault("hybridConnectionName")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "hybridConnectionName", valid_564375
  var valid_564376 = path.getOrDefault("subscriptionId")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "subscriptionId", valid_564376
  var valid_564377 = path.getOrDefault("authorizationRuleName")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "authorizationRuleName", valid_564377
  var valid_564378 = path.getOrDefault("resourceGroupName")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "resourceGroupName", valid_564378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564379 = query.getOrDefault("api-version")
  valid_564379 = validateParameter(valid_564379, JString, required = true,
                                 default = nil)
  if valid_564379 != nil:
    section.add "api-version", valid_564379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564380: Call_HybridConnectionsListKeys_564371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Primary and secondary connection strings to the hybrid connection.
  ## 
  let valid = call_564380.validator(path, query, header, formData, body)
  let scheme = call_564380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564380.url(scheme.get, call_564380.host, call_564380.base,
                         call_564380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564380, url, valid)

proc call*(call_564381: Call_HybridConnectionsListKeys_564371; apiVersion: string;
          namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string): Recallable =
  ## hybridConnectionsListKeys
  ## Primary and secondary connection strings to the hybrid connection.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564382 = newJObject()
  var query_564383 = newJObject()
  add(query_564383, "api-version", newJString(apiVersion))
  add(path_564382, "namespaceName", newJString(namespaceName))
  add(path_564382, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564382, "subscriptionId", newJString(subscriptionId))
  add(path_564382, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564382, "resourceGroupName", newJString(resourceGroupName))
  result = call_564381.call(path_564382, query_564383, nil, nil, nil)

var hybridConnectionsListKeys* = Call_HybridConnectionsListKeys_564371(
    name: "hybridConnectionsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_HybridConnectionsListKeys_564372, base: "",
    url: url_HybridConnectionsListKeys_564373, schemes: {Scheme.Https})
type
  Call_HybridConnectionsRegenerateKeys_564384 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsRegenerateKeys_564386(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "hybridConnectionName" in path,
        "`hybridConnectionName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/hybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsRegenerateKeys_564385(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary or secondary connection strings to the hybrid connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564387 = path.getOrDefault("namespaceName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "namespaceName", valid_564387
  var valid_564388 = path.getOrDefault("hybridConnectionName")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "hybridConnectionName", valid_564388
  var valid_564389 = path.getOrDefault("subscriptionId")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "subscriptionId", valid_564389
  var valid_564390 = path.getOrDefault("authorizationRuleName")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "authorizationRuleName", valid_564390
  var valid_564391 = path.getOrDefault("resourceGroupName")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "resourceGroupName", valid_564391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564392 = query.getOrDefault("api-version")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "api-version", valid_564392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564394: Call_HybridConnectionsRegenerateKeys_564384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the primary or secondary connection strings to the hybrid connection.
  ## 
  let valid = call_564394.validator(path, query, header, formData, body)
  let scheme = call_564394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564394.url(scheme.get, call_564394.host, call_564394.base,
                         call_564394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564394, url, valid)

proc call*(call_564395: Call_HybridConnectionsRegenerateKeys_564384;
          apiVersion: string; namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## hybridConnectionsRegenerateKeys
  ## Regenerates the primary or secondary connection strings to the hybrid connection.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate authorization rule.
  var path_564396 = newJObject()
  var query_564397 = newJObject()
  var body_564398 = newJObject()
  add(query_564397, "api-version", newJString(apiVersion))
  add(path_564396, "namespaceName", newJString(namespaceName))
  add(path_564396, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564396, "subscriptionId", newJString(subscriptionId))
  add(path_564396, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564396, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564398 = parameters
  result = call_564395.call(path_564396, query_564397, nil, nil, body_564398)

var hybridConnectionsRegenerateKeys* = Call_HybridConnectionsRegenerateKeys_564384(
    name: "hybridConnectionsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_HybridConnectionsRegenerateKeys_564385, base: "",
    url: url_HybridConnectionsRegenerateKeys_564386, schemes: {Scheme.Https})
type
  Call_WcfrelaysListByNamespace_564399 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysListByNamespace_564401(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/wcfRelays")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysListByNamespace_564400(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the WCF relays within the namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564402 = path.getOrDefault("namespaceName")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "namespaceName", valid_564402
  var valid_564403 = path.getOrDefault("subscriptionId")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "subscriptionId", valid_564403
  var valid_564404 = path.getOrDefault("resourceGroupName")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "resourceGroupName", valid_564404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564405 = query.getOrDefault("api-version")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "api-version", valid_564405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564406: Call_WcfrelaysListByNamespace_564399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the WCF relays within the namespace.
  ## 
  let valid = call_564406.validator(path, query, header, formData, body)
  let scheme = call_564406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564406.url(scheme.get, call_564406.host, call_564406.base,
                         call_564406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564406, url, valid)

proc call*(call_564407: Call_WcfrelaysListByNamespace_564399; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## wcfrelaysListByNamespace
  ## Lists the WCF relays within the namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564408 = newJObject()
  var query_564409 = newJObject()
  add(query_564409, "api-version", newJString(apiVersion))
  add(path_564408, "namespaceName", newJString(namespaceName))
  add(path_564408, "subscriptionId", newJString(subscriptionId))
  add(path_564408, "resourceGroupName", newJString(resourceGroupName))
  result = call_564407.call(path_564408, query_564409, nil, nil, nil)

var wcfrelaysListByNamespace* = Call_WcfrelaysListByNamespace_564399(
    name: "wcfrelaysListByNamespace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays",
    validator: validate_WcfrelaysListByNamespace_564400, base: "",
    url: url_WcfrelaysListByNamespace_564401, schemes: {Scheme.Https})
type
  Call_WcfrelaysCreateOrUpdate_564422 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysCreateOrUpdate_564424(protocol: Scheme; host: string; base: string;
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
  assert "relayName" in path, "`relayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/wcfRelays/"),
               (kind: VariableSegment, value: "relayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysCreateOrUpdate_564423(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a WCF relay. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564425 = path.getOrDefault("namespaceName")
  valid_564425 = validateParameter(valid_564425, JString, required = true,
                                 default = nil)
  if valid_564425 != nil:
    section.add "namespaceName", valid_564425
  var valid_564426 = path.getOrDefault("subscriptionId")
  valid_564426 = validateParameter(valid_564426, JString, required = true,
                                 default = nil)
  if valid_564426 != nil:
    section.add "subscriptionId", valid_564426
  var valid_564427 = path.getOrDefault("resourceGroupName")
  valid_564427 = validateParameter(valid_564427, JString, required = true,
                                 default = nil)
  if valid_564427 != nil:
    section.add "resourceGroupName", valid_564427
  var valid_564428 = path.getOrDefault("relayName")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "relayName", valid_564428
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564429 = query.getOrDefault("api-version")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "api-version", valid_564429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a WCF relay.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564431: Call_WcfrelaysCreateOrUpdate_564422; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a WCF relay. This operation is idempotent.
  ## 
  let valid = call_564431.validator(path, query, header, formData, body)
  let scheme = call_564431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564431.url(scheme.get, call_564431.host, call_564431.base,
                         call_564431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564431, url, valid)

proc call*(call_564432: Call_WcfrelaysCreateOrUpdate_564422; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode; relayName: string): Recallable =
  ## wcfrelaysCreateOrUpdate
  ## Creates or updates a WCF relay. This operation is idempotent.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a WCF relay.
  ##   relayName: string (required)
  ##            : The relay name.
  var path_564433 = newJObject()
  var query_564434 = newJObject()
  var body_564435 = newJObject()
  add(query_564434, "api-version", newJString(apiVersion))
  add(path_564433, "namespaceName", newJString(namespaceName))
  add(path_564433, "subscriptionId", newJString(subscriptionId))
  add(path_564433, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564435 = parameters
  add(path_564433, "relayName", newJString(relayName))
  result = call_564432.call(path_564433, query_564434, nil, nil, body_564435)

var wcfrelaysCreateOrUpdate* = Call_WcfrelaysCreateOrUpdate_564422(
    name: "wcfrelaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}",
    validator: validate_WcfrelaysCreateOrUpdate_564423, base: "",
    url: url_WcfrelaysCreateOrUpdate_564424, schemes: {Scheme.Https})
type
  Call_WcfrelaysGet_564410 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysGet_564412(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "relayName" in path, "`relayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/wcfRelays/"),
               (kind: VariableSegment, value: "relayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysGet_564411(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the description for the specified WCF relay.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564413 = path.getOrDefault("namespaceName")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "namespaceName", valid_564413
  var valid_564414 = path.getOrDefault("subscriptionId")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "subscriptionId", valid_564414
  var valid_564415 = path.getOrDefault("resourceGroupName")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "resourceGroupName", valid_564415
  var valid_564416 = path.getOrDefault("relayName")
  valid_564416 = validateParameter(valid_564416, JString, required = true,
                                 default = nil)
  if valid_564416 != nil:
    section.add "relayName", valid_564416
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564417 = query.getOrDefault("api-version")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "api-version", valid_564417
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564418: Call_WcfrelaysGet_564410; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the description for the specified WCF relay.
  ## 
  let valid = call_564418.validator(path, query, header, formData, body)
  let scheme = call_564418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564418.url(scheme.get, call_564418.host, call_564418.base,
                         call_564418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564418, url, valid)

proc call*(call_564419: Call_WcfrelaysGet_564410; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string;
          relayName: string): Recallable =
  ## wcfrelaysGet
  ## Returns the description for the specified WCF relay.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: string (required)
  ##            : The relay name.
  var path_564420 = newJObject()
  var query_564421 = newJObject()
  add(query_564421, "api-version", newJString(apiVersion))
  add(path_564420, "namespaceName", newJString(namespaceName))
  add(path_564420, "subscriptionId", newJString(subscriptionId))
  add(path_564420, "resourceGroupName", newJString(resourceGroupName))
  add(path_564420, "relayName", newJString(relayName))
  result = call_564419.call(path_564420, query_564421, nil, nil, nil)

var wcfrelaysGet* = Call_WcfrelaysGet_564410(name: "wcfrelaysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}",
    validator: validate_WcfrelaysGet_564411, base: "", url: url_WcfrelaysGet_564412,
    schemes: {Scheme.Https})
type
  Call_WcfrelaysDelete_564436 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysDelete_564438(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "relayName" in path, "`relayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/wcfRelays/"),
               (kind: VariableSegment, value: "relayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysDelete_564437(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a WCF relay.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564439 = path.getOrDefault("namespaceName")
  valid_564439 = validateParameter(valid_564439, JString, required = true,
                                 default = nil)
  if valid_564439 != nil:
    section.add "namespaceName", valid_564439
  var valid_564440 = path.getOrDefault("subscriptionId")
  valid_564440 = validateParameter(valid_564440, JString, required = true,
                                 default = nil)
  if valid_564440 != nil:
    section.add "subscriptionId", valid_564440
  var valid_564441 = path.getOrDefault("resourceGroupName")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = nil)
  if valid_564441 != nil:
    section.add "resourceGroupName", valid_564441
  var valid_564442 = path.getOrDefault("relayName")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "relayName", valid_564442
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564443 = query.getOrDefault("api-version")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "api-version", valid_564443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564444: Call_WcfrelaysDelete_564436; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a WCF relay.
  ## 
  let valid = call_564444.validator(path, query, header, formData, body)
  let scheme = call_564444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564444.url(scheme.get, call_564444.host, call_564444.base,
                         call_564444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564444, url, valid)

proc call*(call_564445: Call_WcfrelaysDelete_564436; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string;
          relayName: string): Recallable =
  ## wcfrelaysDelete
  ## Deletes a WCF relay.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: string (required)
  ##            : The relay name.
  var path_564446 = newJObject()
  var query_564447 = newJObject()
  add(query_564447, "api-version", newJString(apiVersion))
  add(path_564446, "namespaceName", newJString(namespaceName))
  add(path_564446, "subscriptionId", newJString(subscriptionId))
  add(path_564446, "resourceGroupName", newJString(resourceGroupName))
  add(path_564446, "relayName", newJString(relayName))
  result = call_564445.call(path_564446, query_564447, nil, nil, nil)

var wcfrelaysDelete* = Call_WcfrelaysDelete_564436(name: "wcfrelaysDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}",
    validator: validate_WcfrelaysDelete_564437, base: "", url: url_WcfrelaysDelete_564438,
    schemes: {Scheme.Https})
type
  Call_WcfrelaysListAuthorizationRules_564448 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysListAuthorizationRules_564450(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "relayName" in path, "`relayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/wcfRelays/"),
               (kind: VariableSegment, value: "relayName"),
               (kind: ConstantSegment, value: "/authorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysListAuthorizationRules_564449(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rules for a WCF relay.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564451 = path.getOrDefault("namespaceName")
  valid_564451 = validateParameter(valid_564451, JString, required = true,
                                 default = nil)
  if valid_564451 != nil:
    section.add "namespaceName", valid_564451
  var valid_564452 = path.getOrDefault("subscriptionId")
  valid_564452 = validateParameter(valid_564452, JString, required = true,
                                 default = nil)
  if valid_564452 != nil:
    section.add "subscriptionId", valid_564452
  var valid_564453 = path.getOrDefault("resourceGroupName")
  valid_564453 = validateParameter(valid_564453, JString, required = true,
                                 default = nil)
  if valid_564453 != nil:
    section.add "resourceGroupName", valid_564453
  var valid_564454 = path.getOrDefault("relayName")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "relayName", valid_564454
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564455 = query.getOrDefault("api-version")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "api-version", valid_564455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564456: Call_WcfrelaysListAuthorizationRules_564448;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rules for a WCF relay.
  ## 
  let valid = call_564456.validator(path, query, header, formData, body)
  let scheme = call_564456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564456.url(scheme.get, call_564456.host, call_564456.base,
                         call_564456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564456, url, valid)

proc call*(call_564457: Call_WcfrelaysListAuthorizationRules_564448;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string; relayName: string): Recallable =
  ## wcfrelaysListAuthorizationRules
  ## Authorization rules for a WCF relay.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: string (required)
  ##            : The relay name.
  var path_564458 = newJObject()
  var query_564459 = newJObject()
  add(query_564459, "api-version", newJString(apiVersion))
  add(path_564458, "namespaceName", newJString(namespaceName))
  add(path_564458, "subscriptionId", newJString(subscriptionId))
  add(path_564458, "resourceGroupName", newJString(resourceGroupName))
  add(path_564458, "relayName", newJString(relayName))
  result = call_564457.call(path_564458, query_564459, nil, nil, nil)

var wcfrelaysListAuthorizationRules* = Call_WcfrelaysListAuthorizationRules_564448(
    name: "wcfrelaysListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}/authorizationRules",
    validator: validate_WcfrelaysListAuthorizationRules_564449, base: "",
    url: url_WcfrelaysListAuthorizationRules_564450, schemes: {Scheme.Https})
type
  Call_WcfrelaysCreateOrUpdateAuthorizationRule_564473 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysCreateOrUpdateAuthorizationRule_564475(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "relayName" in path, "`relayName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/wcfRelays/"),
               (kind: VariableSegment, value: "relayName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysCreateOrUpdateAuthorizationRule_564474(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an authorization rule for a WCF relay.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564476 = path.getOrDefault("namespaceName")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = nil)
  if valid_564476 != nil:
    section.add "namespaceName", valid_564476
  var valid_564477 = path.getOrDefault("subscriptionId")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "subscriptionId", valid_564477
  var valid_564478 = path.getOrDefault("authorizationRuleName")
  valid_564478 = validateParameter(valid_564478, JString, required = true,
                                 default = nil)
  if valid_564478 != nil:
    section.add "authorizationRuleName", valid_564478
  var valid_564479 = path.getOrDefault("resourceGroupName")
  valid_564479 = validateParameter(valid_564479, JString, required = true,
                                 default = nil)
  if valid_564479 != nil:
    section.add "resourceGroupName", valid_564479
  var valid_564480 = path.getOrDefault("relayName")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "relayName", valid_564480
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564481 = query.getOrDefault("api-version")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "api-version", valid_564481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564483: Call_WcfrelaysCreateOrUpdateAuthorizationRule_564473;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an authorization rule for a WCF relay.
  ## 
  let valid = call_564483.validator(path, query, header, formData, body)
  let scheme = call_564483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564483.url(scheme.get, call_564483.host, call_564483.base,
                         call_564483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564483, url, valid)

proc call*(call_564484: Call_WcfrelaysCreateOrUpdateAuthorizationRule_564473;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          parameters: JsonNode; relayName: string): Recallable =
  ## wcfrelaysCreateOrUpdateAuthorizationRule
  ## Creates or updates an authorization rule for a WCF relay.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters.
  ##   relayName: string (required)
  ##            : The relay name.
  var path_564485 = newJObject()
  var query_564486 = newJObject()
  var body_564487 = newJObject()
  add(query_564486, "api-version", newJString(apiVersion))
  add(path_564485, "namespaceName", newJString(namespaceName))
  add(path_564485, "subscriptionId", newJString(subscriptionId))
  add(path_564485, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564485, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564487 = parameters
  add(path_564485, "relayName", newJString(relayName))
  result = call_564484.call(path_564485, query_564486, nil, nil, body_564487)

var wcfrelaysCreateOrUpdateAuthorizationRule* = Call_WcfrelaysCreateOrUpdateAuthorizationRule_564473(
    name: "wcfrelaysCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}/authorizationRules/{authorizationRuleName}",
    validator: validate_WcfrelaysCreateOrUpdateAuthorizationRule_564474, base: "",
    url: url_WcfrelaysCreateOrUpdateAuthorizationRule_564475,
    schemes: {Scheme.Https})
type
  Call_WcfrelaysGetAuthorizationRule_564460 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysGetAuthorizationRule_564462(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "relayName" in path, "`relayName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/wcfRelays/"),
               (kind: VariableSegment, value: "relayName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysGetAuthorizationRule_564461(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get authorizationRule for a WCF relay by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564463 = path.getOrDefault("namespaceName")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "namespaceName", valid_564463
  var valid_564464 = path.getOrDefault("subscriptionId")
  valid_564464 = validateParameter(valid_564464, JString, required = true,
                                 default = nil)
  if valid_564464 != nil:
    section.add "subscriptionId", valid_564464
  var valid_564465 = path.getOrDefault("authorizationRuleName")
  valid_564465 = validateParameter(valid_564465, JString, required = true,
                                 default = nil)
  if valid_564465 != nil:
    section.add "authorizationRuleName", valid_564465
  var valid_564466 = path.getOrDefault("resourceGroupName")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "resourceGroupName", valid_564466
  var valid_564467 = path.getOrDefault("relayName")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "relayName", valid_564467
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564468 = query.getOrDefault("api-version")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "api-version", valid_564468
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564469: Call_WcfrelaysGetAuthorizationRule_564460; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get authorizationRule for a WCF relay by name.
  ## 
  let valid = call_564469.validator(path, query, header, formData, body)
  let scheme = call_564469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564469.url(scheme.get, call_564469.host, call_564469.base,
                         call_564469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564469, url, valid)

proc call*(call_564470: Call_WcfrelaysGetAuthorizationRule_564460;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          relayName: string): Recallable =
  ## wcfrelaysGetAuthorizationRule
  ## Get authorizationRule for a WCF relay by name.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: string (required)
  ##            : The relay name.
  var path_564471 = newJObject()
  var query_564472 = newJObject()
  add(query_564472, "api-version", newJString(apiVersion))
  add(path_564471, "namespaceName", newJString(namespaceName))
  add(path_564471, "subscriptionId", newJString(subscriptionId))
  add(path_564471, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564471, "resourceGroupName", newJString(resourceGroupName))
  add(path_564471, "relayName", newJString(relayName))
  result = call_564470.call(path_564471, query_564472, nil, nil, nil)

var wcfrelaysGetAuthorizationRule* = Call_WcfrelaysGetAuthorizationRule_564460(
    name: "wcfrelaysGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}/authorizationRules/{authorizationRuleName}",
    validator: validate_WcfrelaysGetAuthorizationRule_564461, base: "",
    url: url_WcfrelaysGetAuthorizationRule_564462, schemes: {Scheme.Https})
type
  Call_WcfrelaysDeleteAuthorizationRule_564488 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysDeleteAuthorizationRule_564490(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "relayName" in path, "`relayName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/wcfRelays/"),
               (kind: VariableSegment, value: "relayName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysDeleteAuthorizationRule_564489(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a WCF relay authorization rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564491 = path.getOrDefault("namespaceName")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "namespaceName", valid_564491
  var valid_564492 = path.getOrDefault("subscriptionId")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "subscriptionId", valid_564492
  var valid_564493 = path.getOrDefault("authorizationRuleName")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "authorizationRuleName", valid_564493
  var valid_564494 = path.getOrDefault("resourceGroupName")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "resourceGroupName", valid_564494
  var valid_564495 = path.getOrDefault("relayName")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "relayName", valid_564495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564496 = query.getOrDefault("api-version")
  valid_564496 = validateParameter(valid_564496, JString, required = true,
                                 default = nil)
  if valid_564496 != nil:
    section.add "api-version", valid_564496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564497: Call_WcfrelaysDeleteAuthorizationRule_564488;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a WCF relay authorization rule.
  ## 
  let valid = call_564497.validator(path, query, header, formData, body)
  let scheme = call_564497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564497.url(scheme.get, call_564497.host, call_564497.base,
                         call_564497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564497, url, valid)

proc call*(call_564498: Call_WcfrelaysDeleteAuthorizationRule_564488;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          relayName: string): Recallable =
  ## wcfrelaysDeleteAuthorizationRule
  ## Deletes a WCF relay authorization rule.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: string (required)
  ##            : The relay name.
  var path_564499 = newJObject()
  var query_564500 = newJObject()
  add(query_564500, "api-version", newJString(apiVersion))
  add(path_564499, "namespaceName", newJString(namespaceName))
  add(path_564499, "subscriptionId", newJString(subscriptionId))
  add(path_564499, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564499, "resourceGroupName", newJString(resourceGroupName))
  add(path_564499, "relayName", newJString(relayName))
  result = call_564498.call(path_564499, query_564500, nil, nil, nil)

var wcfrelaysDeleteAuthorizationRule* = Call_WcfrelaysDeleteAuthorizationRule_564488(
    name: "wcfrelaysDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}/authorizationRules/{authorizationRuleName}",
    validator: validate_WcfrelaysDeleteAuthorizationRule_564489, base: "",
    url: url_WcfrelaysDeleteAuthorizationRule_564490, schemes: {Scheme.Https})
type
  Call_WcfrelaysListKeys_564501 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysListKeys_564503(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "relayName" in path, "`relayName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/wcfRelays/"),
               (kind: VariableSegment, value: "relayName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysListKeys_564502(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Primary and secondary connection strings to the WCF relay.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564504 = path.getOrDefault("namespaceName")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "namespaceName", valid_564504
  var valid_564505 = path.getOrDefault("subscriptionId")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "subscriptionId", valid_564505
  var valid_564506 = path.getOrDefault("authorizationRuleName")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "authorizationRuleName", valid_564506
  var valid_564507 = path.getOrDefault("resourceGroupName")
  valid_564507 = validateParameter(valid_564507, JString, required = true,
                                 default = nil)
  if valid_564507 != nil:
    section.add "resourceGroupName", valid_564507
  var valid_564508 = path.getOrDefault("relayName")
  valid_564508 = validateParameter(valid_564508, JString, required = true,
                                 default = nil)
  if valid_564508 != nil:
    section.add "relayName", valid_564508
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564509 = query.getOrDefault("api-version")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = nil)
  if valid_564509 != nil:
    section.add "api-version", valid_564509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564510: Call_WcfrelaysListKeys_564501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Primary and secondary connection strings to the WCF relay.
  ## 
  let valid = call_564510.validator(path, query, header, formData, body)
  let scheme = call_564510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564510.url(scheme.get, call_564510.host, call_564510.base,
                         call_564510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564510, url, valid)

proc call*(call_564511: Call_WcfrelaysListKeys_564501; apiVersion: string;
          namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          relayName: string): Recallable =
  ## wcfrelaysListKeys
  ## Primary and secondary connection strings to the WCF relay.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: string (required)
  ##            : The relay name.
  var path_564512 = newJObject()
  var query_564513 = newJObject()
  add(query_564513, "api-version", newJString(apiVersion))
  add(path_564512, "namespaceName", newJString(namespaceName))
  add(path_564512, "subscriptionId", newJString(subscriptionId))
  add(path_564512, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564512, "resourceGroupName", newJString(resourceGroupName))
  add(path_564512, "relayName", newJString(relayName))
  result = call_564511.call(path_564512, query_564513, nil, nil, nil)

var wcfrelaysListKeys* = Call_WcfrelaysListKeys_564501(name: "wcfrelaysListKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}/authorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_WcfrelaysListKeys_564502, base: "",
    url: url_WcfrelaysListKeys_564503, schemes: {Scheme.Https})
type
  Call_WcfrelaysRegenerateKeys_564514 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysRegenerateKeys_564516(protocol: Scheme; host: string; base: string;
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
  assert "relayName" in path, "`relayName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/wcfRelays/"),
               (kind: VariableSegment, value: "relayName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysRegenerateKeys_564515(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary or secondary connection strings to the WCF relay.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564517 = path.getOrDefault("namespaceName")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "namespaceName", valid_564517
  var valid_564518 = path.getOrDefault("subscriptionId")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "subscriptionId", valid_564518
  var valid_564519 = path.getOrDefault("authorizationRuleName")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "authorizationRuleName", valid_564519
  var valid_564520 = path.getOrDefault("resourceGroupName")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = nil)
  if valid_564520 != nil:
    section.add "resourceGroupName", valid_564520
  var valid_564521 = path.getOrDefault("relayName")
  valid_564521 = validateParameter(valid_564521, JString, required = true,
                                 default = nil)
  if valid_564521 != nil:
    section.add "relayName", valid_564521
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564522 = query.getOrDefault("api-version")
  valid_564522 = validateParameter(valid_564522, JString, required = true,
                                 default = nil)
  if valid_564522 != nil:
    section.add "api-version", valid_564522
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564524: Call_WcfrelaysRegenerateKeys_564514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the primary or secondary connection strings to the WCF relay.
  ## 
  let valid = call_564524.validator(path, query, header, formData, body)
  let scheme = call_564524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564524.url(scheme.get, call_564524.host, call_564524.base,
                         call_564524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564524, url, valid)

proc call*(call_564525: Call_WcfrelaysRegenerateKeys_564514; apiVersion: string;
          namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          parameters: JsonNode; relayName: string): Recallable =
  ## wcfrelaysRegenerateKeys
  ## Regenerates the primary or secondary connection strings to the WCF relay.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate authorization rule.
  ##   relayName: string (required)
  ##            : The relay name.
  var path_564526 = newJObject()
  var query_564527 = newJObject()
  var body_564528 = newJObject()
  add(query_564527, "api-version", newJString(apiVersion))
  add(path_564526, "namespaceName", newJString(namespaceName))
  add(path_564526, "subscriptionId", newJString(subscriptionId))
  add(path_564526, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564526, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564528 = parameters
  add(path_564526, "relayName", newJString(relayName))
  result = call_564525.call(path_564526, query_564527, nil, nil, body_564528)

var wcfrelaysRegenerateKeys* = Call_WcfrelaysRegenerateKeys_564514(
    name: "wcfrelaysRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_WcfrelaysRegenerateKeys_564515, base: "",
    url: url_WcfrelaysRegenerateKeys_564516, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
