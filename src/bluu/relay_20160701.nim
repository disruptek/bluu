
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Relay
## version: 2016-07-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these API to manage Azure Relay resources through Azure Resources Manager.
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
  ## Lists all of the available Relay REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ## Lists all of the available Relay REST API operations.
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
  ## Lists all of the available Relay REST API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
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
        value: "/providers/Microsoft.Relay/CheckNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCheckNameAvailability_564076(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the give namespace name availability.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client Api Version.
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
  ##             : Parameters to check availability of the given namespace name
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564112: Call_NamespacesCheckNameAvailability_564075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give namespace name availability.
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
  ## Check the give namespace name availability.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given namespace name
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
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Relay/CheckNameAvailability",
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/Namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesList_564118(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the available namespaces within the subscription irrespective of the resourceGroups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client Api Version.
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
  ## Lists all the available namespaces within the subscription irrespective of the resourceGroups.
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
  ## Lists all the available namespaces within the subscription irrespective of the resourceGroups.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564124 = newJObject()
  var query_564125 = newJObject()
  add(query_564125, "api-version", newJString(apiVersion))
  add(path_564124, "subscriptionId", newJString(subscriptionId))
  result = call_564123.call(path_564124, query_564125, nil, nil, nil)

var namespacesList* = Call_NamespacesList_564117(name: "namespacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Relay/Namespaces",
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/Namespaces")]
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
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client Api Version.
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
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/Namespaces",
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
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client Api Version.
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
  ##             : Parameters supplied to create a Namespace Resource.
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
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a Namespace Resource.
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
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client Api Version.
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
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client Api Version.
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
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client Api Version.
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
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  Call_NamespacesListPostAuthorizationRules_564195 = ref object of OpenApiRestCall_563555
proc url_NamespacesListPostAuthorizationRules_564197(protocol: Scheme;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListPostAuthorizationRules_564196(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rules for a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  var valid_564200 = path.getOrDefault("resourceGroupName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "resourceGroupName", valid_564200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564201 = query.getOrDefault("api-version")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "api-version", valid_564201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564202: Call_NamespacesListPostAuthorizationRules_564195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rules for a namespace.
  ## 
  let valid = call_564202.validator(path, query, header, formData, body)
  let scheme = call_564202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564202.url(scheme.get, call_564202.host, call_564202.base,
                         call_564202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564202, url, valid)

proc call*(call_564203: Call_NamespacesListPostAuthorizationRules_564195;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## namespacesListPostAuthorizationRules
  ## Authorization rules for a namespace.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564204 = newJObject()
  var query_564205 = newJObject()
  add(query_564205, "api-version", newJString(apiVersion))
  add(path_564204, "namespaceName", newJString(namespaceName))
  add(path_564204, "subscriptionId", newJString(subscriptionId))
  add(path_564204, "resourceGroupName", newJString(resourceGroupName))
  result = call_564203.call(path_564204, query_564205, nil, nil, nil)

var namespacesListPostAuthorizationRules* = Call_NamespacesListPostAuthorizationRules_564195(
    name: "namespacesListPostAuthorizationRules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListPostAuthorizationRules_564196, base: "",
    url: url_NamespacesListPostAuthorizationRules_564197, schemes: {Scheme.Https})
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
               (kind: ConstantSegment, value: "/AuthorizationRules")]
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
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client Api Version.
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
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListAuthorizationRules_564185, base: "",
    url: url_NamespacesListAuthorizationRules_564186, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateAuthorizationRule_564218 = ref object of OpenApiRestCall_563555
proc url_NamespacesCreateOrUpdateAuthorizationRule_564220(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdateAuthorizationRule_564219(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates an authorization rule for a namespace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564221 = path.getOrDefault("namespaceName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "namespaceName", valid_564221
  var valid_564222 = path.getOrDefault("subscriptionId")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "subscriptionId", valid_564222
  var valid_564223 = path.getOrDefault("authorizationRuleName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "authorizationRuleName", valid_564223
  var valid_564224 = path.getOrDefault("resourceGroupName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "resourceGroupName", valid_564224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564225 = query.getOrDefault("api-version")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "api-version", valid_564225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564227: Call_NamespacesCreateOrUpdateAuthorizationRule_564218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or Updates an authorization rule for a namespace
  ## 
  let valid = call_564227.validator(path, query, header, formData, body)
  let scheme = call_564227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564227.url(scheme.get, call_564227.host, call_564227.base,
                         call_564227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564227, url, valid)

proc call*(call_564228: Call_NamespacesCreateOrUpdateAuthorizationRule_564218;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateAuthorizationRule
  ## Creates or Updates an authorization rule for a namespace
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters
  var path_564229 = newJObject()
  var query_564230 = newJObject()
  var body_564231 = newJObject()
  add(query_564230, "api-version", newJString(apiVersion))
  add(path_564229, "namespaceName", newJString(namespaceName))
  add(path_564229, "subscriptionId", newJString(subscriptionId))
  add(path_564229, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564229, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564231 = parameters
  result = call_564228.call(path_564229, query_564230, nil, nil, body_564231)

var namespacesCreateOrUpdateAuthorizationRule* = Call_NamespacesCreateOrUpdateAuthorizationRule_564218(
    name: "namespacesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesCreateOrUpdateAuthorizationRule_564219,
    base: "", url: url_NamespacesCreateOrUpdateAuthorizationRule_564220,
    schemes: {Scheme.Https})
type
  Call_NamespacesPostAuthorizationRule_564232 = ref object of OpenApiRestCall_563555
proc url_NamespacesPostAuthorizationRule_564234(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesPostAuthorizationRule_564233(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rule for a namespace by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564235 = path.getOrDefault("namespaceName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "namespaceName", valid_564235
  var valid_564236 = path.getOrDefault("subscriptionId")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "subscriptionId", valid_564236
  var valid_564237 = path.getOrDefault("authorizationRuleName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "authorizationRuleName", valid_564237
  var valid_564238 = path.getOrDefault("resourceGroupName")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "resourceGroupName", valid_564238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564239 = query.getOrDefault("api-version")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "api-version", valid_564239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564240: Call_NamespacesPostAuthorizationRule_564232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rule for a namespace by name.
  ## 
  let valid = call_564240.validator(path, query, header, formData, body)
  let scheme = call_564240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564240.url(scheme.get, call_564240.host, call_564240.base,
                         call_564240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564240, url, valid)

proc call*(call_564241: Call_NamespacesPostAuthorizationRule_564232;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string): Recallable =
  ## namespacesPostAuthorizationRule
  ## Authorization rule for a namespace by name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564242 = newJObject()
  var query_564243 = newJObject()
  add(query_564243, "api-version", newJString(apiVersion))
  add(path_564242, "namespaceName", newJString(namespaceName))
  add(path_564242, "subscriptionId", newJString(subscriptionId))
  add(path_564242, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564242, "resourceGroupName", newJString(resourceGroupName))
  result = call_564241.call(path_564242, query_564243, nil, nil, nil)

var namespacesPostAuthorizationRule* = Call_NamespacesPostAuthorizationRule_564232(
    name: "namespacesPostAuthorizationRule", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesPostAuthorizationRule_564233, base: "",
    url: url_NamespacesPostAuthorizationRule_564234, schemes: {Scheme.Https})
type
  Call_NamespacesGetAuthorizationRule_564206 = ref object of OpenApiRestCall_563555
proc url_NamespacesGetAuthorizationRule_564208(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGetAuthorizationRule_564207(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rule for a namespace by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564209 = path.getOrDefault("namespaceName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "namespaceName", valid_564209
  var valid_564210 = path.getOrDefault("subscriptionId")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "subscriptionId", valid_564210
  var valid_564211 = path.getOrDefault("authorizationRuleName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "authorizationRuleName", valid_564211
  var valid_564212 = path.getOrDefault("resourceGroupName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "resourceGroupName", valid_564212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564213 = query.getOrDefault("api-version")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "api-version", valid_564213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564214: Call_NamespacesGetAuthorizationRule_564206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Authorization rule for a namespace by name.
  ## 
  let valid = call_564214.validator(path, query, header, formData, body)
  let scheme = call_564214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564214.url(scheme.get, call_564214.host, call_564214.base,
                         call_564214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564214, url, valid)

proc call*(call_564215: Call_NamespacesGetAuthorizationRule_564206;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string): Recallable =
  ## namespacesGetAuthorizationRule
  ## Authorization rule for a namespace by name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564216 = newJObject()
  var query_564217 = newJObject()
  add(query_564217, "api-version", newJString(apiVersion))
  add(path_564216, "namespaceName", newJString(namespaceName))
  add(path_564216, "subscriptionId", newJString(subscriptionId))
  add(path_564216, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564216, "resourceGroupName", newJString(resourceGroupName))
  result = call_564215.call(path_564216, query_564217, nil, nil, nil)

var namespacesGetAuthorizationRule* = Call_NamespacesGetAuthorizationRule_564206(
    name: "namespacesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesGetAuthorizationRule_564207, base: "",
    url: url_NamespacesGetAuthorizationRule_564208, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteAuthorizationRule_564244 = ref object of OpenApiRestCall_563555
proc url_NamespacesDeleteAuthorizationRule_564246(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDeleteAuthorizationRule_564245(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a namespace authorization rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564247 = path.getOrDefault("namespaceName")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "namespaceName", valid_564247
  var valid_564248 = path.getOrDefault("subscriptionId")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "subscriptionId", valid_564248
  var valid_564249 = path.getOrDefault("authorizationRuleName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "authorizationRuleName", valid_564249
  var valid_564250 = path.getOrDefault("resourceGroupName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "resourceGroupName", valid_564250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564251 = query.getOrDefault("api-version")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "api-version", valid_564251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564252: Call_NamespacesDeleteAuthorizationRule_564244;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a namespace authorization rule
  ## 
  let valid = call_564252.validator(path, query, header, formData, body)
  let scheme = call_564252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564252.url(scheme.get, call_564252.host, call_564252.base,
                         call_564252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564252, url, valid)

proc call*(call_564253: Call_NamespacesDeleteAuthorizationRule_564244;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string): Recallable =
  ## namespacesDeleteAuthorizationRule
  ## Deletes a namespace authorization rule
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564254 = newJObject()
  var query_564255 = newJObject()
  add(query_564255, "api-version", newJString(apiVersion))
  add(path_564254, "namespaceName", newJString(namespaceName))
  add(path_564254, "subscriptionId", newJString(subscriptionId))
  add(path_564254, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564254, "resourceGroupName", newJString(resourceGroupName))
  result = call_564253.call(path_564254, query_564255, nil, nil, nil)

var namespacesDeleteAuthorizationRule* = Call_NamespacesDeleteAuthorizationRule_564244(
    name: "namespacesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesDeleteAuthorizationRule_564245, base: "",
    url: url_NamespacesDeleteAuthorizationRule_564246, schemes: {Scheme.Https})
type
  Call_NamespacesListKeys_564256 = ref object of OpenApiRestCall_563555
proc url_NamespacesListKeys_564258(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListKeys_564257(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Primary and Secondary ConnectionStrings to the namespace 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564259 = path.getOrDefault("namespaceName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "namespaceName", valid_564259
  var valid_564260 = path.getOrDefault("subscriptionId")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "subscriptionId", valid_564260
  var valid_564261 = path.getOrDefault("authorizationRuleName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "authorizationRuleName", valid_564261
  var valid_564262 = path.getOrDefault("resourceGroupName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "resourceGroupName", valid_564262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564263 = query.getOrDefault("api-version")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "api-version", valid_564263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564264: Call_NamespacesListKeys_564256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Primary and Secondary ConnectionStrings to the namespace 
  ## 
  let valid = call_564264.validator(path, query, header, formData, body)
  let scheme = call_564264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564264.url(scheme.get, call_564264.host, call_564264.base,
                         call_564264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564264, url, valid)

proc call*(call_564265: Call_NamespacesListKeys_564256; apiVersion: string;
          namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string): Recallable =
  ## namespacesListKeys
  ## Primary and Secondary ConnectionStrings to the namespace 
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564266 = newJObject()
  var query_564267 = newJObject()
  add(query_564267, "api-version", newJString(apiVersion))
  add(path_564266, "namespaceName", newJString(namespaceName))
  add(path_564266, "subscriptionId", newJString(subscriptionId))
  add(path_564266, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564266, "resourceGroupName", newJString(resourceGroupName))
  result = call_564265.call(path_564266, query_564267, nil, nil, nil)

var namespacesListKeys* = Call_NamespacesListKeys_564256(
    name: "namespacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_NamespacesListKeys_564257, base: "",
    url: url_NamespacesListKeys_564258, schemes: {Scheme.Https})
type
  Call_NamespacesRegenerateKeys_564268 = ref object of OpenApiRestCall_563555
proc url_NamespacesRegenerateKeys_564270(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesRegenerateKeys_564269(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the Primary or Secondary ConnectionStrings to the namespace 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564271 = path.getOrDefault("namespaceName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "namespaceName", valid_564271
  var valid_564272 = path.getOrDefault("subscriptionId")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "subscriptionId", valid_564272
  var valid_564273 = path.getOrDefault("authorizationRuleName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "authorizationRuleName", valid_564273
  var valid_564274 = path.getOrDefault("resourceGroupName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "resourceGroupName", valid_564274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564275 = query.getOrDefault("api-version")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "api-version", valid_564275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate Auth Rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564277: Call_NamespacesRegenerateKeys_564268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the Primary or Secondary ConnectionStrings to the namespace 
  ## 
  let valid = call_564277.validator(path, query, header, formData, body)
  let scheme = call_564277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564277.url(scheme.get, call_564277.host, call_564277.base,
                         call_564277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564277, url, valid)

proc call*(call_564278: Call_NamespacesRegenerateKeys_564268; apiVersion: string;
          namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## namespacesRegenerateKeys
  ## Regenerates the Primary or Secondary ConnectionStrings to the namespace 
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate Auth Rule.
  var path_564279 = newJObject()
  var query_564280 = newJObject()
  var body_564281 = newJObject()
  add(query_564280, "api-version", newJString(apiVersion))
  add(path_564279, "namespaceName", newJString(namespaceName))
  add(path_564279, "subscriptionId", newJString(subscriptionId))
  add(path_564279, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564279, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564281 = parameters
  result = call_564278.call(path_564279, query_564280, nil, nil, body_564281)

var namespacesRegenerateKeys* = Call_NamespacesRegenerateKeys_564268(
    name: "namespacesRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_NamespacesRegenerateKeys_564269, base: "",
    url: url_NamespacesRegenerateKeys_564270, schemes: {Scheme.Https})
type
  Call_HybridConnectionsListByNamespace_564282 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsListByNamespace_564284(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/HybridConnections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsListByNamespace_564283(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the HybridConnection within the namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564285 = path.getOrDefault("namespaceName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "namespaceName", valid_564285
  var valid_564286 = path.getOrDefault("subscriptionId")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "subscriptionId", valid_564286
  var valid_564287 = path.getOrDefault("resourceGroupName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "resourceGroupName", valid_564287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564288 = query.getOrDefault("api-version")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "api-version", valid_564288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564289: Call_HybridConnectionsListByNamespace_564282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the HybridConnection within the namespace.
  ## 
  let valid = call_564289.validator(path, query, header, formData, body)
  let scheme = call_564289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564289.url(scheme.get, call_564289.host, call_564289.base,
                         call_564289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564289, url, valid)

proc call*(call_564290: Call_HybridConnectionsListByNamespace_564282;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## hybridConnectionsListByNamespace
  ## Lists the HybridConnection within the namespace.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564291 = newJObject()
  var query_564292 = newJObject()
  add(query_564292, "api-version", newJString(apiVersion))
  add(path_564291, "namespaceName", newJString(namespaceName))
  add(path_564291, "subscriptionId", newJString(subscriptionId))
  add(path_564291, "resourceGroupName", newJString(resourceGroupName))
  result = call_564290.call(path_564291, query_564292, nil, nil, nil)

var hybridConnectionsListByNamespace* = Call_HybridConnectionsListByNamespace_564282(
    name: "hybridConnectionsListByNamespace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections",
    validator: validate_HybridConnectionsListByNamespace_564283, base: "",
    url: url_HybridConnectionsListByNamespace_564284, schemes: {Scheme.Https})
type
  Call_HybridConnectionsCreateOrUpdate_564305 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsCreateOrUpdate_564307(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/HybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsCreateOrUpdate_564306(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a service HybridConnection. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564308 = path.getOrDefault("namespaceName")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "namespaceName", valid_564308
  var valid_564309 = path.getOrDefault("hybridConnectionName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "hybridConnectionName", valid_564309
  var valid_564310 = path.getOrDefault("subscriptionId")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "subscriptionId", valid_564310
  var valid_564311 = path.getOrDefault("resourceGroupName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "resourceGroupName", valid_564311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564312 = query.getOrDefault("api-version")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "api-version", valid_564312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a HybridConnection.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564314: Call_HybridConnectionsCreateOrUpdate_564305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or Updates a service HybridConnection. This operation is idempotent.
  ## 
  let valid = call_564314.validator(path, query, header, formData, body)
  let scheme = call_564314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564314.url(scheme.get, call_564314.host, call_564314.base,
                         call_564314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564314, url, valid)

proc call*(call_564315: Call_HybridConnectionsCreateOrUpdate_564305;
          apiVersion: string; namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## hybridConnectionsCreateOrUpdate
  ## Creates or Updates a service HybridConnection. This operation is idempotent.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a HybridConnection.
  var path_564316 = newJObject()
  var query_564317 = newJObject()
  var body_564318 = newJObject()
  add(query_564317, "api-version", newJString(apiVersion))
  add(path_564316, "namespaceName", newJString(namespaceName))
  add(path_564316, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564316, "subscriptionId", newJString(subscriptionId))
  add(path_564316, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564318 = parameters
  result = call_564315.call(path_564316, query_564317, nil, nil, body_564318)

var hybridConnectionsCreateOrUpdate* = Call_HybridConnectionsCreateOrUpdate_564305(
    name: "hybridConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}",
    validator: validate_HybridConnectionsCreateOrUpdate_564306, base: "",
    url: url_HybridConnectionsCreateOrUpdate_564307, schemes: {Scheme.Https})
type
  Call_HybridConnectionsGet_564293 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsGet_564295(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/HybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsGet_564294(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the description for the specified HybridConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564296 = path.getOrDefault("namespaceName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "namespaceName", valid_564296
  var valid_564297 = path.getOrDefault("hybridConnectionName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "hybridConnectionName", valid_564297
  var valid_564298 = path.getOrDefault("subscriptionId")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "subscriptionId", valid_564298
  var valid_564299 = path.getOrDefault("resourceGroupName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "resourceGroupName", valid_564299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564300 = query.getOrDefault("api-version")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "api-version", valid_564300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564301: Call_HybridConnectionsGet_564293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the description for the specified HybridConnection.
  ## 
  let valid = call_564301.validator(path, query, header, formData, body)
  let scheme = call_564301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564301.url(scheme.get, call_564301.host, call_564301.base,
                         call_564301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564301, url, valid)

proc call*(call_564302: Call_HybridConnectionsGet_564293; apiVersion: string;
          namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## hybridConnectionsGet
  ## Returns the description for the specified HybridConnection.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564303 = newJObject()
  var query_564304 = newJObject()
  add(query_564304, "api-version", newJString(apiVersion))
  add(path_564303, "namespaceName", newJString(namespaceName))
  add(path_564303, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564303, "subscriptionId", newJString(subscriptionId))
  add(path_564303, "resourceGroupName", newJString(resourceGroupName))
  result = call_564302.call(path_564303, query_564304, nil, nil, nil)

var hybridConnectionsGet* = Call_HybridConnectionsGet_564293(
    name: "hybridConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}",
    validator: validate_HybridConnectionsGet_564294, base: "",
    url: url_HybridConnectionsGet_564295, schemes: {Scheme.Https})
type
  Call_HybridConnectionsDelete_564319 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsDelete_564321(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/HybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsDelete_564320(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a HybridConnection .
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564322 = path.getOrDefault("namespaceName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "namespaceName", valid_564322
  var valid_564323 = path.getOrDefault("hybridConnectionName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "hybridConnectionName", valid_564323
  var valid_564324 = path.getOrDefault("subscriptionId")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "subscriptionId", valid_564324
  var valid_564325 = path.getOrDefault("resourceGroupName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "resourceGroupName", valid_564325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564326 = query.getOrDefault("api-version")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "api-version", valid_564326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564327: Call_HybridConnectionsDelete_564319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a HybridConnection .
  ## 
  let valid = call_564327.validator(path, query, header, formData, body)
  let scheme = call_564327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564327.url(scheme.get, call_564327.host, call_564327.base,
                         call_564327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564327, url, valid)

proc call*(call_564328: Call_HybridConnectionsDelete_564319; apiVersion: string;
          namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## hybridConnectionsDelete
  ## Deletes a HybridConnection .
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564329 = newJObject()
  var query_564330 = newJObject()
  add(query_564330, "api-version", newJString(apiVersion))
  add(path_564329, "namespaceName", newJString(namespaceName))
  add(path_564329, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564329, "subscriptionId", newJString(subscriptionId))
  add(path_564329, "resourceGroupName", newJString(resourceGroupName))
  result = call_564328.call(path_564329, query_564330, nil, nil, nil)

var hybridConnectionsDelete* = Call_HybridConnectionsDelete_564319(
    name: "hybridConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}",
    validator: validate_HybridConnectionsDelete_564320, base: "",
    url: url_HybridConnectionsDelete_564321, schemes: {Scheme.Https})
type
  Call_HybridConnectionsListPostAuthorizationRules_564343 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsListPostAuthorizationRules_564345(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/HybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName"),
               (kind: ConstantSegment, value: "/authorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsListPostAuthorizationRules_564344(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rules for a HybridConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  var valid_564349 = path.getOrDefault("resourceGroupName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "resourceGroupName", valid_564349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564350 = query.getOrDefault("api-version")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "api-version", valid_564350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564351: Call_HybridConnectionsListPostAuthorizationRules_564343;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rules for a HybridConnection.
  ## 
  let valid = call_564351.validator(path, query, header, formData, body)
  let scheme = call_564351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564351.url(scheme.get, call_564351.host, call_564351.base,
                         call_564351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564351, url, valid)

proc call*(call_564352: Call_HybridConnectionsListPostAuthorizationRules_564343;
          apiVersion: string; namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## hybridConnectionsListPostAuthorizationRules
  ## Authorization rules for a HybridConnection.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564353 = newJObject()
  var query_564354 = newJObject()
  add(query_564354, "api-version", newJString(apiVersion))
  add(path_564353, "namespaceName", newJString(namespaceName))
  add(path_564353, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564353, "subscriptionId", newJString(subscriptionId))
  add(path_564353, "resourceGroupName", newJString(resourceGroupName))
  result = call_564352.call(path_564353, query_564354, nil, nil, nil)

var hybridConnectionsListPostAuthorizationRules* = Call_HybridConnectionsListPostAuthorizationRules_564343(
    name: "hybridConnectionsListPostAuthorizationRules",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}/authorizationRules",
    validator: validate_HybridConnectionsListPostAuthorizationRules_564344,
    base: "", url: url_HybridConnectionsListPostAuthorizationRules_564345,
    schemes: {Scheme.Https})
type
  Call_HybridConnectionsListAuthorizationRules_564331 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsListAuthorizationRules_564333(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/HybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName"),
               (kind: ConstantSegment, value: "/authorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsListAuthorizationRules_564332(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rules for a HybridConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564334 = path.getOrDefault("namespaceName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "namespaceName", valid_564334
  var valid_564335 = path.getOrDefault("hybridConnectionName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "hybridConnectionName", valid_564335
  var valid_564336 = path.getOrDefault("subscriptionId")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "subscriptionId", valid_564336
  var valid_564337 = path.getOrDefault("resourceGroupName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "resourceGroupName", valid_564337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_564339: Call_HybridConnectionsListAuthorizationRules_564331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rules for a HybridConnection.
  ## 
  let valid = call_564339.validator(path, query, header, formData, body)
  let scheme = call_564339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564339.url(scheme.get, call_564339.host, call_564339.base,
                         call_564339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564339, url, valid)

proc call*(call_564340: Call_HybridConnectionsListAuthorizationRules_564331;
          apiVersion: string; namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## hybridConnectionsListAuthorizationRules
  ## Authorization rules for a HybridConnection.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564341 = newJObject()
  var query_564342 = newJObject()
  add(query_564342, "api-version", newJString(apiVersion))
  add(path_564341, "namespaceName", newJString(namespaceName))
  add(path_564341, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564341, "subscriptionId", newJString(subscriptionId))
  add(path_564341, "resourceGroupName", newJString(resourceGroupName))
  result = call_564340.call(path_564341, query_564342, nil, nil, nil)

var hybridConnectionsListAuthorizationRules* = Call_HybridConnectionsListAuthorizationRules_564331(
    name: "hybridConnectionsListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}/authorizationRules",
    validator: validate_HybridConnectionsListAuthorizationRules_564332, base: "",
    url: url_HybridConnectionsListAuthorizationRules_564333,
    schemes: {Scheme.Https})
type
  Call_HybridConnectionsCreateOrUpdateAuthorizationRule_564368 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsCreateOrUpdateAuthorizationRule_564370(
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
               (kind: ConstantSegment, value: "/HybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsCreateOrUpdateAuthorizationRule_564369(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or Updates an authorization rule for a HybridConnection
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564371 = path.getOrDefault("namespaceName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "namespaceName", valid_564371
  var valid_564372 = path.getOrDefault("hybridConnectionName")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "hybridConnectionName", valid_564372
  var valid_564373 = path.getOrDefault("subscriptionId")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "subscriptionId", valid_564373
  var valid_564374 = path.getOrDefault("authorizationRuleName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "authorizationRuleName", valid_564374
  var valid_564375 = path.getOrDefault("resourceGroupName")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "resourceGroupName", valid_564375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564376 = query.getOrDefault("api-version")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "api-version", valid_564376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564378: Call_HybridConnectionsCreateOrUpdateAuthorizationRule_564368;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or Updates an authorization rule for a HybridConnection
  ## 
  let valid = call_564378.validator(path, query, header, formData, body)
  let scheme = call_564378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564378.url(scheme.get, call_564378.host, call_564378.base,
                         call_564378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564378, url, valid)

proc call*(call_564379: Call_HybridConnectionsCreateOrUpdateAuthorizationRule_564368;
          apiVersion: string; namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## hybridConnectionsCreateOrUpdateAuthorizationRule
  ## Creates or Updates an authorization rule for a HybridConnection
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters
  var path_564380 = newJObject()
  var query_564381 = newJObject()
  var body_564382 = newJObject()
  add(query_564381, "api-version", newJString(apiVersion))
  add(path_564380, "namespaceName", newJString(namespaceName))
  add(path_564380, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564380, "subscriptionId", newJString(subscriptionId))
  add(path_564380, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564380, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564382 = parameters
  result = call_564379.call(path_564380, query_564381, nil, nil, body_564382)

var hybridConnectionsCreateOrUpdateAuthorizationRule* = Call_HybridConnectionsCreateOrUpdateAuthorizationRule_564368(
    name: "hybridConnectionsCreateOrUpdateAuthorizationRule",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}",
    validator: validate_HybridConnectionsCreateOrUpdateAuthorizationRule_564369,
    base: "", url: url_HybridConnectionsCreateOrUpdateAuthorizationRule_564370,
    schemes: {Scheme.Https})
type
  Call_HybridConnectionsPostAuthorizationRule_564383 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsPostAuthorizationRule_564385(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/HybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsPostAuthorizationRule_564384(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## HybridConnection authorizationRule for a HybridConnection by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564386 = path.getOrDefault("namespaceName")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "namespaceName", valid_564386
  var valid_564387 = path.getOrDefault("hybridConnectionName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "hybridConnectionName", valid_564387
  var valid_564388 = path.getOrDefault("subscriptionId")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "subscriptionId", valid_564388
  var valid_564389 = path.getOrDefault("authorizationRuleName")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "authorizationRuleName", valid_564389
  var valid_564390 = path.getOrDefault("resourceGroupName")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "resourceGroupName", valid_564390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564391 = query.getOrDefault("api-version")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "api-version", valid_564391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564392: Call_HybridConnectionsPostAuthorizationRule_564383;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## HybridConnection authorizationRule for a HybridConnection by name.
  ## 
  let valid = call_564392.validator(path, query, header, formData, body)
  let scheme = call_564392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564392.url(scheme.get, call_564392.host, call_564392.base,
                         call_564392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564392, url, valid)

proc call*(call_564393: Call_HybridConnectionsPostAuthorizationRule_564383;
          apiVersion: string; namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string): Recallable =
  ## hybridConnectionsPostAuthorizationRule
  ## HybridConnection authorizationRule for a HybridConnection by name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564394 = newJObject()
  var query_564395 = newJObject()
  add(query_564395, "api-version", newJString(apiVersion))
  add(path_564394, "namespaceName", newJString(namespaceName))
  add(path_564394, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564394, "subscriptionId", newJString(subscriptionId))
  add(path_564394, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564394, "resourceGroupName", newJString(resourceGroupName))
  result = call_564393.call(path_564394, query_564395, nil, nil, nil)

var hybridConnectionsPostAuthorizationRule* = Call_HybridConnectionsPostAuthorizationRule_564383(
    name: "hybridConnectionsPostAuthorizationRule", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}",
    validator: validate_HybridConnectionsPostAuthorizationRule_564384, base: "",
    url: url_HybridConnectionsPostAuthorizationRule_564385,
    schemes: {Scheme.Https})
type
  Call_HybridConnectionsGetAuthorizationRule_564355 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsGetAuthorizationRule_564357(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/HybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsGetAuthorizationRule_564356(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## HybridConnection authorizationRule for a HybridConnection by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564358 = path.getOrDefault("namespaceName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "namespaceName", valid_564358
  var valid_564359 = path.getOrDefault("hybridConnectionName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "hybridConnectionName", valid_564359
  var valid_564360 = path.getOrDefault("subscriptionId")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "subscriptionId", valid_564360
  var valid_564361 = path.getOrDefault("authorizationRuleName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "authorizationRuleName", valid_564361
  var valid_564362 = path.getOrDefault("resourceGroupName")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "resourceGroupName", valid_564362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564363 = query.getOrDefault("api-version")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "api-version", valid_564363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564364: Call_HybridConnectionsGetAuthorizationRule_564355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## HybridConnection authorizationRule for a HybridConnection by name.
  ## 
  let valid = call_564364.validator(path, query, header, formData, body)
  let scheme = call_564364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564364.url(scheme.get, call_564364.host, call_564364.base,
                         call_564364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564364, url, valid)

proc call*(call_564365: Call_HybridConnectionsGetAuthorizationRule_564355;
          apiVersion: string; namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string): Recallable =
  ## hybridConnectionsGetAuthorizationRule
  ## HybridConnection authorizationRule for a HybridConnection by name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564366 = newJObject()
  var query_564367 = newJObject()
  add(query_564367, "api-version", newJString(apiVersion))
  add(path_564366, "namespaceName", newJString(namespaceName))
  add(path_564366, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564366, "subscriptionId", newJString(subscriptionId))
  add(path_564366, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564366, "resourceGroupName", newJString(resourceGroupName))
  result = call_564365.call(path_564366, query_564367, nil, nil, nil)

var hybridConnectionsGetAuthorizationRule* = Call_HybridConnectionsGetAuthorizationRule_564355(
    name: "hybridConnectionsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}",
    validator: validate_HybridConnectionsGetAuthorizationRule_564356, base: "",
    url: url_HybridConnectionsGetAuthorizationRule_564357, schemes: {Scheme.Https})
type
  Call_HybridConnectionsDeleteAuthorizationRule_564396 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsDeleteAuthorizationRule_564398(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/HybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsDeleteAuthorizationRule_564397(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a HybridConnection authorization rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564399 = path.getOrDefault("namespaceName")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "namespaceName", valid_564399
  var valid_564400 = path.getOrDefault("hybridConnectionName")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "hybridConnectionName", valid_564400
  var valid_564401 = path.getOrDefault("subscriptionId")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "subscriptionId", valid_564401
  var valid_564402 = path.getOrDefault("authorizationRuleName")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "authorizationRuleName", valid_564402
  var valid_564403 = path.getOrDefault("resourceGroupName")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "resourceGroupName", valid_564403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564404 = query.getOrDefault("api-version")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "api-version", valid_564404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564405: Call_HybridConnectionsDeleteAuthorizationRule_564396;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a HybridConnection authorization rule
  ## 
  let valid = call_564405.validator(path, query, header, formData, body)
  let scheme = call_564405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564405.url(scheme.get, call_564405.host, call_564405.base,
                         call_564405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564405, url, valid)

proc call*(call_564406: Call_HybridConnectionsDeleteAuthorizationRule_564396;
          apiVersion: string; namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string): Recallable =
  ## hybridConnectionsDeleteAuthorizationRule
  ## Deletes a HybridConnection authorization rule
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564407 = newJObject()
  var query_564408 = newJObject()
  add(query_564408, "api-version", newJString(apiVersion))
  add(path_564407, "namespaceName", newJString(namespaceName))
  add(path_564407, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564407, "subscriptionId", newJString(subscriptionId))
  add(path_564407, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564407, "resourceGroupName", newJString(resourceGroupName))
  result = call_564406.call(path_564407, query_564408, nil, nil, nil)

var hybridConnectionsDeleteAuthorizationRule* = Call_HybridConnectionsDeleteAuthorizationRule_564396(
    name: "hybridConnectionsDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}",
    validator: validate_HybridConnectionsDeleteAuthorizationRule_564397, base: "",
    url: url_HybridConnectionsDeleteAuthorizationRule_564398,
    schemes: {Scheme.Https})
type
  Call_HybridConnectionsListKeys_564409 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsListKeys_564411(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/HybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/ListKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsListKeys_564410(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Primary and Secondary ConnectionStrings to the HybridConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564412 = path.getOrDefault("namespaceName")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "namespaceName", valid_564412
  var valid_564413 = path.getOrDefault("hybridConnectionName")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "hybridConnectionName", valid_564413
  var valid_564414 = path.getOrDefault("subscriptionId")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "subscriptionId", valid_564414
  var valid_564415 = path.getOrDefault("authorizationRuleName")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "authorizationRuleName", valid_564415
  var valid_564416 = path.getOrDefault("resourceGroupName")
  valid_564416 = validateParameter(valid_564416, JString, required = true,
                                 default = nil)
  if valid_564416 != nil:
    section.add "resourceGroupName", valid_564416
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_564418: Call_HybridConnectionsListKeys_564409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Primary and Secondary ConnectionStrings to the HybridConnection.
  ## 
  let valid = call_564418.validator(path, query, header, formData, body)
  let scheme = call_564418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564418.url(scheme.get, call_564418.host, call_564418.base,
                         call_564418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564418, url, valid)

proc call*(call_564419: Call_HybridConnectionsListKeys_564409; apiVersion: string;
          namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string): Recallable =
  ## hybridConnectionsListKeys
  ## Primary and Secondary ConnectionStrings to the HybridConnection.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564420 = newJObject()
  var query_564421 = newJObject()
  add(query_564421, "api-version", newJString(apiVersion))
  add(path_564420, "namespaceName", newJString(namespaceName))
  add(path_564420, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564420, "subscriptionId", newJString(subscriptionId))
  add(path_564420, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564420, "resourceGroupName", newJString(resourceGroupName))
  result = call_564419.call(path_564420, query_564421, nil, nil, nil)

var hybridConnectionsListKeys* = Call_HybridConnectionsListKeys_564409(
    name: "hybridConnectionsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}/ListKeys",
    validator: validate_HybridConnectionsListKeys_564410, base: "",
    url: url_HybridConnectionsListKeys_564411, schemes: {Scheme.Https})
type
  Call_HybridConnectionsRegenerateKeys_564422 = ref object of OpenApiRestCall_563555
proc url_HybridConnectionsRegenerateKeys_564424(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/HybridConnections/"),
               (kind: VariableSegment, value: "hybridConnectionName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridConnectionsRegenerateKeys_564423(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the Primary or Secondary ConnectionStrings to the HybridConnection
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564425 = path.getOrDefault("namespaceName")
  valid_564425 = validateParameter(valid_564425, JString, required = true,
                                 default = nil)
  if valid_564425 != nil:
    section.add "namespaceName", valid_564425
  var valid_564426 = path.getOrDefault("hybridConnectionName")
  valid_564426 = validateParameter(valid_564426, JString, required = true,
                                 default = nil)
  if valid_564426 != nil:
    section.add "hybridConnectionName", valid_564426
  var valid_564427 = path.getOrDefault("subscriptionId")
  valid_564427 = validateParameter(valid_564427, JString, required = true,
                                 default = nil)
  if valid_564427 != nil:
    section.add "subscriptionId", valid_564427
  var valid_564428 = path.getOrDefault("authorizationRuleName")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "authorizationRuleName", valid_564428
  var valid_564429 = path.getOrDefault("resourceGroupName")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "resourceGroupName", valid_564429
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564430 = query.getOrDefault("api-version")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "api-version", valid_564430
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate Auth Rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564432: Call_HybridConnectionsRegenerateKeys_564422;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the Primary or Secondary ConnectionStrings to the HybridConnection
  ## 
  let valid = call_564432.validator(path, query, header, formData, body)
  let scheme = call_564432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564432.url(scheme.get, call_564432.host, call_564432.base,
                         call_564432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564432, url, valid)

proc call*(call_564433: Call_HybridConnectionsRegenerateKeys_564422;
          apiVersion: string; namespaceName: string; hybridConnectionName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## hybridConnectionsRegenerateKeys
  ## Regenerates the Primary or Secondary ConnectionStrings to the HybridConnection
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate Auth Rule.
  var path_564434 = newJObject()
  var query_564435 = newJObject()
  var body_564436 = newJObject()
  add(query_564435, "api-version", newJString(apiVersion))
  add(path_564434, "namespaceName", newJString(namespaceName))
  add(path_564434, "hybridConnectionName", newJString(hybridConnectionName))
  add(path_564434, "subscriptionId", newJString(subscriptionId))
  add(path_564434, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564434, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564436 = parameters
  result = call_564433.call(path_564434, query_564435, nil, nil, body_564436)

var hybridConnectionsRegenerateKeys* = Call_HybridConnectionsRegenerateKeys_564422(
    name: "hybridConnectionsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_HybridConnectionsRegenerateKeys_564423, base: "",
    url: url_HybridConnectionsRegenerateKeys_564424, schemes: {Scheme.Https})
type
  Call_WcfrelaysListByNamespace_564437 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysListByNamespace_564439(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/WcfRelays")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysListByNamespace_564438(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the WCFRelays within the namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564440 = path.getOrDefault("namespaceName")
  valid_564440 = validateParameter(valid_564440, JString, required = true,
                                 default = nil)
  if valid_564440 != nil:
    section.add "namespaceName", valid_564440
  var valid_564441 = path.getOrDefault("subscriptionId")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = nil)
  if valid_564441 != nil:
    section.add "subscriptionId", valid_564441
  var valid_564442 = path.getOrDefault("resourceGroupName")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "resourceGroupName", valid_564442
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_564444: Call_WcfrelaysListByNamespace_564437; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the WCFRelays within the namespace.
  ## 
  let valid = call_564444.validator(path, query, header, formData, body)
  let scheme = call_564444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564444.url(scheme.get, call_564444.host, call_564444.base,
                         call_564444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564444, url, valid)

proc call*(call_564445: Call_WcfrelaysListByNamespace_564437; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## wcfrelaysListByNamespace
  ## Lists the WCFRelays within the namespace.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564446 = newJObject()
  var query_564447 = newJObject()
  add(query_564447, "api-version", newJString(apiVersion))
  add(path_564446, "namespaceName", newJString(namespaceName))
  add(path_564446, "subscriptionId", newJString(subscriptionId))
  add(path_564446, "resourceGroupName", newJString(resourceGroupName))
  result = call_564445.call(path_564446, query_564447, nil, nil, nil)

var wcfrelaysListByNamespace* = Call_WcfrelaysListByNamespace_564437(
    name: "wcfrelaysListByNamespace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays",
    validator: validate_WcfrelaysListByNamespace_564438, base: "",
    url: url_WcfrelaysListByNamespace_564439, schemes: {Scheme.Https})
type
  Call_WcfrelaysCreateOrUpdate_564460 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysCreateOrUpdate_564462(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/WcfRelays/"),
               (kind: VariableSegment, value: "relayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysCreateOrUpdate_564461(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a WCFRelay. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name
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
  var valid_564465 = path.getOrDefault("resourceGroupName")
  valid_564465 = validateParameter(valid_564465, JString, required = true,
                                 default = nil)
  if valid_564465 != nil:
    section.add "resourceGroupName", valid_564465
  var valid_564466 = path.getOrDefault("relayName")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "relayName", valid_564466
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564467 = query.getOrDefault("api-version")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "api-version", valid_564467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a WCFRelays.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564469: Call_WcfrelaysCreateOrUpdate_564460; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a WCFRelay. This operation is idempotent.
  ## 
  let valid = call_564469.validator(path, query, header, formData, body)
  let scheme = call_564469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564469.url(scheme.get, call_564469.host, call_564469.base,
                         call_564469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564469, url, valid)

proc call*(call_564470: Call_WcfrelaysCreateOrUpdate_564460; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode; relayName: string): Recallable =
  ## wcfrelaysCreateOrUpdate
  ## Creates or Updates a WCFRelay. This operation is idempotent.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a WCFRelays.
  ##   relayName: string (required)
  ##            : The relay name
  var path_564471 = newJObject()
  var query_564472 = newJObject()
  var body_564473 = newJObject()
  add(query_564472, "api-version", newJString(apiVersion))
  add(path_564471, "namespaceName", newJString(namespaceName))
  add(path_564471, "subscriptionId", newJString(subscriptionId))
  add(path_564471, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564473 = parameters
  add(path_564471, "relayName", newJString(relayName))
  result = call_564470.call(path_564471, query_564472, nil, nil, body_564473)

var wcfrelaysCreateOrUpdate* = Call_WcfrelaysCreateOrUpdate_564460(
    name: "wcfrelaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}",
    validator: validate_WcfrelaysCreateOrUpdate_564461, base: "",
    url: url_WcfrelaysCreateOrUpdate_564462, schemes: {Scheme.Https})
type
  Call_WcfrelaysGet_564448 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysGet_564450(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/WcfRelays/"),
               (kind: VariableSegment, value: "relayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysGet_564449(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the description for the specified WCFRelays.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name
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
  ##              : Client Api Version.
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

proc call*(call_564456: Call_WcfrelaysGet_564448; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the description for the specified WCFRelays.
  ## 
  let valid = call_564456.validator(path, query, header, formData, body)
  let scheme = call_564456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564456.url(scheme.get, call_564456.host, call_564456.base,
                         call_564456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564456, url, valid)

proc call*(call_564457: Call_WcfrelaysGet_564448; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string;
          relayName: string): Recallable =
  ## wcfrelaysGet
  ## Returns the description for the specified WCFRelays.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: string (required)
  ##            : The relay name
  var path_564458 = newJObject()
  var query_564459 = newJObject()
  add(query_564459, "api-version", newJString(apiVersion))
  add(path_564458, "namespaceName", newJString(namespaceName))
  add(path_564458, "subscriptionId", newJString(subscriptionId))
  add(path_564458, "resourceGroupName", newJString(resourceGroupName))
  add(path_564458, "relayName", newJString(relayName))
  result = call_564457.call(path_564458, query_564459, nil, nil, nil)

var wcfrelaysGet* = Call_WcfrelaysGet_564448(name: "wcfrelaysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}",
    validator: validate_WcfrelaysGet_564449, base: "", url: url_WcfrelaysGet_564450,
    schemes: {Scheme.Https})
type
  Call_WcfrelaysDelete_564474 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysDelete_564476(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/WcfRelays/"),
               (kind: VariableSegment, value: "relayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysDelete_564475(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a WCFRelays .
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564477 = path.getOrDefault("namespaceName")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "namespaceName", valid_564477
  var valid_564478 = path.getOrDefault("subscriptionId")
  valid_564478 = validateParameter(valid_564478, JString, required = true,
                                 default = nil)
  if valid_564478 != nil:
    section.add "subscriptionId", valid_564478
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
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564482: Call_WcfrelaysDelete_564474; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a WCFRelays .
  ## 
  let valid = call_564482.validator(path, query, header, formData, body)
  let scheme = call_564482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564482.url(scheme.get, call_564482.host, call_564482.base,
                         call_564482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564482, url, valid)

proc call*(call_564483: Call_WcfrelaysDelete_564474; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string;
          relayName: string): Recallable =
  ## wcfrelaysDelete
  ## Deletes a WCFRelays .
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: string (required)
  ##            : The relay name
  var path_564484 = newJObject()
  var query_564485 = newJObject()
  add(query_564485, "api-version", newJString(apiVersion))
  add(path_564484, "namespaceName", newJString(namespaceName))
  add(path_564484, "subscriptionId", newJString(subscriptionId))
  add(path_564484, "resourceGroupName", newJString(resourceGroupName))
  add(path_564484, "relayName", newJString(relayName))
  result = call_564483.call(path_564484, query_564485, nil, nil, nil)

var wcfrelaysDelete* = Call_WcfrelaysDelete_564474(name: "wcfrelaysDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}",
    validator: validate_WcfrelaysDelete_564475, base: "", url: url_WcfrelaysDelete_564476,
    schemes: {Scheme.Https})
type
  Call_WcfrelaysListPostAuthorizationRules_564498 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysListPostAuthorizationRules_564500(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/WcfRelays/"),
               (kind: VariableSegment, value: "relayName"),
               (kind: ConstantSegment, value: "/authorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysListPostAuthorizationRules_564499(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rules for a WCFRelays.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564501 = path.getOrDefault("namespaceName")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "namespaceName", valid_564501
  var valid_564502 = path.getOrDefault("subscriptionId")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "subscriptionId", valid_564502
  var valid_564503 = path.getOrDefault("resourceGroupName")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "resourceGroupName", valid_564503
  var valid_564504 = path.getOrDefault("relayName")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "relayName", valid_564504
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564505 = query.getOrDefault("api-version")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "api-version", valid_564505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564506: Call_WcfrelaysListPostAuthorizationRules_564498;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rules for a WCFRelays.
  ## 
  let valid = call_564506.validator(path, query, header, formData, body)
  let scheme = call_564506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564506.url(scheme.get, call_564506.host, call_564506.base,
                         call_564506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564506, url, valid)

proc call*(call_564507: Call_WcfrelaysListPostAuthorizationRules_564498;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string; relayName: string): Recallable =
  ## wcfrelaysListPostAuthorizationRules
  ## Authorization rules for a WCFRelays.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: string (required)
  ##            : The relay name
  var path_564508 = newJObject()
  var query_564509 = newJObject()
  add(query_564509, "api-version", newJString(apiVersion))
  add(path_564508, "namespaceName", newJString(namespaceName))
  add(path_564508, "subscriptionId", newJString(subscriptionId))
  add(path_564508, "resourceGroupName", newJString(resourceGroupName))
  add(path_564508, "relayName", newJString(relayName))
  result = call_564507.call(path_564508, query_564509, nil, nil, nil)

var wcfrelaysListPostAuthorizationRules* = Call_WcfrelaysListPostAuthorizationRules_564498(
    name: "wcfrelaysListPostAuthorizationRules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}/authorizationRules",
    validator: validate_WcfrelaysListPostAuthorizationRules_564499, base: "",
    url: url_WcfrelaysListPostAuthorizationRules_564500, schemes: {Scheme.Https})
type
  Call_WcfrelaysListAuthorizationRules_564486 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysListAuthorizationRules_564488(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/WcfRelays/"),
               (kind: VariableSegment, value: "relayName"),
               (kind: ConstantSegment, value: "/authorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysListAuthorizationRules_564487(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rules for a WCFRelays.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564489 = path.getOrDefault("namespaceName")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = nil)
  if valid_564489 != nil:
    section.add "namespaceName", valid_564489
  var valid_564490 = path.getOrDefault("subscriptionId")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "subscriptionId", valid_564490
  var valid_564491 = path.getOrDefault("resourceGroupName")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "resourceGroupName", valid_564491
  var valid_564492 = path.getOrDefault("relayName")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "relayName", valid_564492
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564493 = query.getOrDefault("api-version")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "api-version", valid_564493
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564494: Call_WcfrelaysListAuthorizationRules_564486;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rules for a WCFRelays.
  ## 
  let valid = call_564494.validator(path, query, header, formData, body)
  let scheme = call_564494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564494.url(scheme.get, call_564494.host, call_564494.base,
                         call_564494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564494, url, valid)

proc call*(call_564495: Call_WcfrelaysListAuthorizationRules_564486;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string; relayName: string): Recallable =
  ## wcfrelaysListAuthorizationRules
  ## Authorization rules for a WCFRelays.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: string (required)
  ##            : The relay name
  var path_564496 = newJObject()
  var query_564497 = newJObject()
  add(query_564497, "api-version", newJString(apiVersion))
  add(path_564496, "namespaceName", newJString(namespaceName))
  add(path_564496, "subscriptionId", newJString(subscriptionId))
  add(path_564496, "resourceGroupName", newJString(resourceGroupName))
  add(path_564496, "relayName", newJString(relayName))
  result = call_564495.call(path_564496, query_564497, nil, nil, nil)

var wcfrelaysListAuthorizationRules* = Call_WcfrelaysListAuthorizationRules_564486(
    name: "wcfrelaysListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}/authorizationRules",
    validator: validate_WcfrelaysListAuthorizationRules_564487, base: "",
    url: url_WcfrelaysListAuthorizationRules_564488, schemes: {Scheme.Https})
type
  Call_WcfrelaysCreateOrUpdateAuthorizationRule_564523 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysCreateOrUpdateAuthorizationRule_564525(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/WcfRelays/"),
               (kind: VariableSegment, value: "relayName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysCreateOrUpdateAuthorizationRule_564524(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates an authorization rule for a WCFRelays
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564526 = path.getOrDefault("namespaceName")
  valid_564526 = validateParameter(valid_564526, JString, required = true,
                                 default = nil)
  if valid_564526 != nil:
    section.add "namespaceName", valid_564526
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
  var valid_564530 = path.getOrDefault("relayName")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "relayName", valid_564530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564531 = query.getOrDefault("api-version")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "api-version", valid_564531
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

proc call*(call_564533: Call_WcfrelaysCreateOrUpdateAuthorizationRule_564523;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or Updates an authorization rule for a WCFRelays
  ## 
  let valid = call_564533.validator(path, query, header, formData, body)
  let scheme = call_564533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564533.url(scheme.get, call_564533.host, call_564533.base,
                         call_564533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564533, url, valid)

proc call*(call_564534: Call_WcfrelaysCreateOrUpdateAuthorizationRule_564523;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          parameters: JsonNode; relayName: string): Recallable =
  ## wcfrelaysCreateOrUpdateAuthorizationRule
  ## Creates or Updates an authorization rule for a WCFRelays
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters.
  ##   relayName: string (required)
  ##            : The relay name
  var path_564535 = newJObject()
  var query_564536 = newJObject()
  var body_564537 = newJObject()
  add(query_564536, "api-version", newJString(apiVersion))
  add(path_564535, "namespaceName", newJString(namespaceName))
  add(path_564535, "subscriptionId", newJString(subscriptionId))
  add(path_564535, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564535, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564537 = parameters
  add(path_564535, "relayName", newJString(relayName))
  result = call_564534.call(path_564535, query_564536, nil, nil, body_564537)

var wcfrelaysCreateOrUpdateAuthorizationRule* = Call_WcfrelaysCreateOrUpdateAuthorizationRule_564523(
    name: "wcfrelaysCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}/authorizationRules/{authorizationRuleName}",
    validator: validate_WcfrelaysCreateOrUpdateAuthorizationRule_564524, base: "",
    url: url_WcfrelaysCreateOrUpdateAuthorizationRule_564525,
    schemes: {Scheme.Https})
type
  Call_WcfrelaysPostAuthorizationRule_564538 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysPostAuthorizationRule_564540(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/WcfRelays/"),
               (kind: VariableSegment, value: "relayName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysPostAuthorizationRule_564539(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get authorizationRule for a WCFRelays by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564541 = path.getOrDefault("namespaceName")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "namespaceName", valid_564541
  var valid_564542 = path.getOrDefault("subscriptionId")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "subscriptionId", valid_564542
  var valid_564543 = path.getOrDefault("authorizationRuleName")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "authorizationRuleName", valid_564543
  var valid_564544 = path.getOrDefault("resourceGroupName")
  valid_564544 = validateParameter(valid_564544, JString, required = true,
                                 default = nil)
  if valid_564544 != nil:
    section.add "resourceGroupName", valid_564544
  var valid_564545 = path.getOrDefault("relayName")
  valid_564545 = validateParameter(valid_564545, JString, required = true,
                                 default = nil)
  if valid_564545 != nil:
    section.add "relayName", valid_564545
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564546 = query.getOrDefault("api-version")
  valid_564546 = validateParameter(valid_564546, JString, required = true,
                                 default = nil)
  if valid_564546 != nil:
    section.add "api-version", valid_564546
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564547: Call_WcfrelaysPostAuthorizationRule_564538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get authorizationRule for a WCFRelays by name.
  ## 
  let valid = call_564547.validator(path, query, header, formData, body)
  let scheme = call_564547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564547.url(scheme.get, call_564547.host, call_564547.base,
                         call_564547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564547, url, valid)

proc call*(call_564548: Call_WcfrelaysPostAuthorizationRule_564538;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          relayName: string): Recallable =
  ## wcfrelaysPostAuthorizationRule
  ## Get authorizationRule for a WCFRelays by name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: string (required)
  ##            : The relay name
  var path_564549 = newJObject()
  var query_564550 = newJObject()
  add(query_564550, "api-version", newJString(apiVersion))
  add(path_564549, "namespaceName", newJString(namespaceName))
  add(path_564549, "subscriptionId", newJString(subscriptionId))
  add(path_564549, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564549, "resourceGroupName", newJString(resourceGroupName))
  add(path_564549, "relayName", newJString(relayName))
  result = call_564548.call(path_564549, query_564550, nil, nil, nil)

var wcfrelaysPostAuthorizationRule* = Call_WcfrelaysPostAuthorizationRule_564538(
    name: "wcfrelaysPostAuthorizationRule", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}/authorizationRules/{authorizationRuleName}",
    validator: validate_WcfrelaysPostAuthorizationRule_564539, base: "",
    url: url_WcfrelaysPostAuthorizationRule_564540, schemes: {Scheme.Https})
type
  Call_WcfrelaysGetAuthorizationRule_564510 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysGetAuthorizationRule_564512(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/WcfRelays/"),
               (kind: VariableSegment, value: "relayName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysGetAuthorizationRule_564511(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get authorizationRule for a WCFRelays by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564513 = path.getOrDefault("namespaceName")
  valid_564513 = validateParameter(valid_564513, JString, required = true,
                                 default = nil)
  if valid_564513 != nil:
    section.add "namespaceName", valid_564513
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
  var valid_564517 = path.getOrDefault("relayName")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "relayName", valid_564517
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564518 = query.getOrDefault("api-version")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "api-version", valid_564518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564519: Call_WcfrelaysGetAuthorizationRule_564510; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get authorizationRule for a WCFRelays by name.
  ## 
  let valid = call_564519.validator(path, query, header, formData, body)
  let scheme = call_564519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564519.url(scheme.get, call_564519.host, call_564519.base,
                         call_564519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564519, url, valid)

proc call*(call_564520: Call_WcfrelaysGetAuthorizationRule_564510;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          relayName: string): Recallable =
  ## wcfrelaysGetAuthorizationRule
  ## Get authorizationRule for a WCFRelays by name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: string (required)
  ##            : The relay name
  var path_564521 = newJObject()
  var query_564522 = newJObject()
  add(query_564522, "api-version", newJString(apiVersion))
  add(path_564521, "namespaceName", newJString(namespaceName))
  add(path_564521, "subscriptionId", newJString(subscriptionId))
  add(path_564521, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564521, "resourceGroupName", newJString(resourceGroupName))
  add(path_564521, "relayName", newJString(relayName))
  result = call_564520.call(path_564521, query_564522, nil, nil, nil)

var wcfrelaysGetAuthorizationRule* = Call_WcfrelaysGetAuthorizationRule_564510(
    name: "wcfrelaysGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}/authorizationRules/{authorizationRuleName}",
    validator: validate_WcfrelaysGetAuthorizationRule_564511, base: "",
    url: url_WcfrelaysGetAuthorizationRule_564512, schemes: {Scheme.Https})
type
  Call_WcfrelaysDeleteAuthorizationRule_564551 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysDeleteAuthorizationRule_564553(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/WcfRelays/"),
               (kind: VariableSegment, value: "relayName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysDeleteAuthorizationRule_564552(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a WCFRelays authorization rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564554 = path.getOrDefault("namespaceName")
  valid_564554 = validateParameter(valid_564554, JString, required = true,
                                 default = nil)
  if valid_564554 != nil:
    section.add "namespaceName", valid_564554
  var valid_564555 = path.getOrDefault("subscriptionId")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "subscriptionId", valid_564555
  var valid_564556 = path.getOrDefault("authorizationRuleName")
  valid_564556 = validateParameter(valid_564556, JString, required = true,
                                 default = nil)
  if valid_564556 != nil:
    section.add "authorizationRuleName", valid_564556
  var valid_564557 = path.getOrDefault("resourceGroupName")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "resourceGroupName", valid_564557
  var valid_564558 = path.getOrDefault("relayName")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "relayName", valid_564558
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_564560: Call_WcfrelaysDeleteAuthorizationRule_564551;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a WCFRelays authorization rule
  ## 
  let valid = call_564560.validator(path, query, header, formData, body)
  let scheme = call_564560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564560.url(scheme.get, call_564560.host, call_564560.base,
                         call_564560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564560, url, valid)

proc call*(call_564561: Call_WcfrelaysDeleteAuthorizationRule_564551;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          relayName: string): Recallable =
  ## wcfrelaysDeleteAuthorizationRule
  ## Deletes a WCFRelays authorization rule
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: string (required)
  ##            : The relay name
  var path_564562 = newJObject()
  var query_564563 = newJObject()
  add(query_564563, "api-version", newJString(apiVersion))
  add(path_564562, "namespaceName", newJString(namespaceName))
  add(path_564562, "subscriptionId", newJString(subscriptionId))
  add(path_564562, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564562, "resourceGroupName", newJString(resourceGroupName))
  add(path_564562, "relayName", newJString(relayName))
  result = call_564561.call(path_564562, query_564563, nil, nil, nil)

var wcfrelaysDeleteAuthorizationRule* = Call_WcfrelaysDeleteAuthorizationRule_564551(
    name: "wcfrelaysDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}/authorizationRules/{authorizationRuleName}",
    validator: validate_WcfrelaysDeleteAuthorizationRule_564552, base: "",
    url: url_WcfrelaysDeleteAuthorizationRule_564553, schemes: {Scheme.Https})
type
  Call_WcfrelaysListKeys_564564 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysListKeys_564566(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/WcfRelays/"),
               (kind: VariableSegment, value: "relayName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/ListKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysListKeys_564565(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Primary and Secondary ConnectionStrings to the WCFRelays.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564567 = path.getOrDefault("namespaceName")
  valid_564567 = validateParameter(valid_564567, JString, required = true,
                                 default = nil)
  if valid_564567 != nil:
    section.add "namespaceName", valid_564567
  var valid_564568 = path.getOrDefault("subscriptionId")
  valid_564568 = validateParameter(valid_564568, JString, required = true,
                                 default = nil)
  if valid_564568 != nil:
    section.add "subscriptionId", valid_564568
  var valid_564569 = path.getOrDefault("authorizationRuleName")
  valid_564569 = validateParameter(valid_564569, JString, required = true,
                                 default = nil)
  if valid_564569 != nil:
    section.add "authorizationRuleName", valid_564569
  var valid_564570 = path.getOrDefault("resourceGroupName")
  valid_564570 = validateParameter(valid_564570, JString, required = true,
                                 default = nil)
  if valid_564570 != nil:
    section.add "resourceGroupName", valid_564570
  var valid_564571 = path.getOrDefault("relayName")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "relayName", valid_564571
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564573: Call_WcfrelaysListKeys_564564; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Primary and Secondary ConnectionStrings to the WCFRelays.
  ## 
  let valid = call_564573.validator(path, query, header, formData, body)
  let scheme = call_564573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564573.url(scheme.get, call_564573.host, call_564573.base,
                         call_564573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564573, url, valid)

proc call*(call_564574: Call_WcfrelaysListKeys_564564; apiVersion: string;
          namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          relayName: string): Recallable =
  ## wcfrelaysListKeys
  ## Primary and Secondary ConnectionStrings to the WCFRelays.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: string (required)
  ##            : The relay name
  var path_564575 = newJObject()
  var query_564576 = newJObject()
  add(query_564576, "api-version", newJString(apiVersion))
  add(path_564575, "namespaceName", newJString(namespaceName))
  add(path_564575, "subscriptionId", newJString(subscriptionId))
  add(path_564575, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564575, "resourceGroupName", newJString(resourceGroupName))
  add(path_564575, "relayName", newJString(relayName))
  result = call_564574.call(path_564575, query_564576, nil, nil, nil)

var wcfrelaysListKeys* = Call_WcfrelaysListKeys_564564(name: "wcfrelaysListKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}/authorizationRules/{authorizationRuleName}/ListKeys",
    validator: validate_WcfrelaysListKeys_564565, base: "",
    url: url_WcfrelaysListKeys_564566, schemes: {Scheme.Https})
type
  Call_WcfrelaysRegenerateKeys_564577 = ref object of OpenApiRestCall_563555
proc url_WcfrelaysRegenerateKeys_564579(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/WcfRelays/"),
               (kind: VariableSegment, value: "relayName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WcfrelaysRegenerateKeys_564578(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the Primary or Secondary ConnectionStrings to the WCFRelays
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564580 = path.getOrDefault("namespaceName")
  valid_564580 = validateParameter(valid_564580, JString, required = true,
                                 default = nil)
  if valid_564580 != nil:
    section.add "namespaceName", valid_564580
  var valid_564581 = path.getOrDefault("subscriptionId")
  valid_564581 = validateParameter(valid_564581, JString, required = true,
                                 default = nil)
  if valid_564581 != nil:
    section.add "subscriptionId", valid_564581
  var valid_564582 = path.getOrDefault("authorizationRuleName")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "authorizationRuleName", valid_564582
  var valid_564583 = path.getOrDefault("resourceGroupName")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "resourceGroupName", valid_564583
  var valid_564584 = path.getOrDefault("relayName")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "relayName", valid_564584
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564585 = query.getOrDefault("api-version")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "api-version", valid_564585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate Auth Rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564587: Call_WcfrelaysRegenerateKeys_564577; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the Primary or Secondary ConnectionStrings to the WCFRelays
  ## 
  let valid = call_564587.validator(path, query, header, formData, body)
  let scheme = call_564587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564587.url(scheme.get, call_564587.host, call_564587.base,
                         call_564587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564587, url, valid)

proc call*(call_564588: Call_WcfrelaysRegenerateKeys_564577; apiVersion: string;
          namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          parameters: JsonNode; relayName: string): Recallable =
  ## wcfrelaysRegenerateKeys
  ## Regenerates the Primary or Secondary ConnectionStrings to the WCFRelays
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate Auth Rule.
  ##   relayName: string (required)
  ##            : The relay name
  var path_564589 = newJObject()
  var query_564590 = newJObject()
  var body_564591 = newJObject()
  add(query_564590, "api-version", newJString(apiVersion))
  add(path_564589, "namespaceName", newJString(namespaceName))
  add(path_564589, "subscriptionId", newJString(subscriptionId))
  add(path_564589, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564589, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564591 = parameters
  add(path_564589, "relayName", newJString(relayName))
  result = call_564588.call(path_564589, query_564590, nil, nil, body_564591)

var wcfrelaysRegenerateKeys* = Call_WcfrelaysRegenerateKeys_564577(
    name: "wcfrelaysRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_WcfrelaysRegenerateKeys_564578, base: "",
    url: url_WcfrelaysRegenerateKeys_564579, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
