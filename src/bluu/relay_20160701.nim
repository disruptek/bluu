
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  macServiceName = "relay"
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
  ## Lists all of the available Relay REST API operations.
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
  ## Lists all of the available Relay REST API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var operationsList* = Call_OperationsList_567879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Relay/operations",
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
        value: "/providers/Microsoft.Relay/CheckNameAvailability")]
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
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client Api Version.
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
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Relay/CheckNameAvailability",
    validator: validate_NamespacesCheckNameAvailability_568176, base: "",
    url: url_NamespacesCheckNameAvailability_568177, schemes: {Scheme.Https})
type
  Call_NamespacesList_568217 = ref object of OpenApiRestCall_567657
proc url_NamespacesList_568219(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesList_568218(path: JsonNode; query: JsonNode;
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
  var valid_568220 = path.getOrDefault("subscriptionId")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "subscriptionId", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_NamespacesList_568217; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available namespaces within the subscription irrespective of the resourceGroups.
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_NamespacesList_568217; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesList
  ## Lists all the available namespaces within the subscription irrespective of the resourceGroups.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  add(query_568225, "api-version", newJString(apiVersion))
  add(path_568224, "subscriptionId", newJString(subscriptionId))
  result = call_568223.call(path_568224, query_568225, nil, nil, nil)

var namespacesList* = Call_NamespacesList_568217(name: "namespacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Relay/Namespaces",
    validator: validate_NamespacesList_568218, base: "", url: url_NamespacesList_568219,
    schemes: {Scheme.Https})
type
  Call_NamespacesListByResourceGroup_568226 = ref object of OpenApiRestCall_567657
proc url_NamespacesListByResourceGroup_568228(protocol: Scheme; host: string;
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

proc validate_NamespacesListByResourceGroup_568227(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available namespaces within the ResourceGroup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568229 = path.getOrDefault("resourceGroupName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "resourceGroupName", valid_568229
  var valid_568230 = path.getOrDefault("subscriptionId")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "subscriptionId", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "api-version", valid_568231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568232: Call_NamespacesListByResourceGroup_568226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available namespaces within the ResourceGroup.
  ## 
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_NamespacesListByResourceGroup_568226;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesListByResourceGroup
  ## Lists all the available namespaces within the ResourceGroup.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  add(path_568234, "resourceGroupName", newJString(resourceGroupName))
  add(query_568235, "api-version", newJString(apiVersion))
  add(path_568234, "subscriptionId", newJString(subscriptionId))
  result = call_568233.call(path_568234, query_568235, nil, nil, nil)

var namespacesListByResourceGroup* = Call_NamespacesListByResourceGroup_568226(
    name: "namespacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/Namespaces",
    validator: validate_NamespacesListByResourceGroup_568227, base: "",
    url: url_NamespacesListByResourceGroup_568228, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdate_568247 = ref object of OpenApiRestCall_567657
proc url_NamespacesCreateOrUpdate_568249(protocol: Scheme; host: string;
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

proc validate_NamespacesCreateOrUpdate_568248(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create Azure Relay namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client Api Version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a Namespace Resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568255: Call_NamespacesCreateOrUpdate_568247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create Azure Relay namespace.
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_NamespacesCreateOrUpdate_568247;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdate
  ## Create Azure Relay namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a Namespace Resource.
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  var body_568259 = newJObject()
  add(path_568257, "namespaceName", newJString(namespaceName))
  add(path_568257, "resourceGroupName", newJString(resourceGroupName))
  add(query_568258, "api-version", newJString(apiVersion))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568259 = parameters
  result = call_568256.call(path_568257, query_568258, nil, nil, body_568259)

var namespacesCreateOrUpdate* = Call_NamespacesCreateOrUpdate_568247(
    name: "namespacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}",
    validator: validate_NamespacesCreateOrUpdate_568248, base: "",
    url: url_NamespacesCreateOrUpdate_568249, schemes: {Scheme.Https})
type
  Call_NamespacesGet_568236 = ref object of OpenApiRestCall_567657
proc url_NamespacesGet_568238(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesGet_568237(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the description for the specified namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568239 = path.getOrDefault("namespaceName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "namespaceName", valid_568239
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
  ##              : Client Api Version.
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

proc call*(call_568243: Call_NamespacesGet_568236; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the description for the specified namespace.
  ## 
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_NamespacesGet_568236; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesGet
  ## Returns the description for the specified namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  add(path_568245, "namespaceName", newJString(namespaceName))
  add(path_568245, "resourceGroupName", newJString(resourceGroupName))
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "subscriptionId", newJString(subscriptionId))
  result = call_568244.call(path_568245, query_568246, nil, nil, nil)

var namespacesGet* = Call_NamespacesGet_568236(name: "namespacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}",
    validator: validate_NamespacesGet_568237, base: "", url: url_NamespacesGet_568238,
    schemes: {Scheme.Https})
type
  Call_NamespacesUpdate_568271 = ref object of OpenApiRestCall_567657
proc url_NamespacesUpdate_568273(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesUpdate_568272(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client Api Version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for updating a namespace resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568279: Call_NamespacesUpdate_568271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_NamespacesUpdate_568271; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesUpdate
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters for updating a namespace resource.
  var path_568281 = newJObject()
  var query_568282 = newJObject()
  var body_568283 = newJObject()
  add(path_568281, "namespaceName", newJString(namespaceName))
  add(path_568281, "resourceGroupName", newJString(resourceGroupName))
  add(query_568282, "api-version", newJString(apiVersion))
  add(path_568281, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568283 = parameters
  result = call_568280.call(path_568281, query_568282, nil, nil, body_568283)

var namespacesUpdate* = Call_NamespacesUpdate_568271(name: "namespacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}",
    validator: validate_NamespacesUpdate_568272, base: "",
    url: url_NamespacesUpdate_568273, schemes: {Scheme.Https})
type
  Call_NamespacesDelete_568260 = ref object of OpenApiRestCall_567657
proc url_NamespacesDelete_568262(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesDelete_568261(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568263 = path.getOrDefault("namespaceName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "namespaceName", valid_568263
  var valid_568264 = path.getOrDefault("resourceGroupName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "resourceGroupName", valid_568264
  var valid_568265 = path.getOrDefault("subscriptionId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "subscriptionId", valid_568265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568266 = query.getOrDefault("api-version")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "api-version", valid_568266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568267: Call_NamespacesDelete_568260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  let valid = call_568267.validator(path, query, header, formData, body)
  let scheme = call_568267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568267.url(scheme.get, call_568267.host, call_568267.base,
                         call_568267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568267, url, valid)

proc call*(call_568268: Call_NamespacesDelete_568260; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesDelete
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568269 = newJObject()
  var query_568270 = newJObject()
  add(path_568269, "namespaceName", newJString(namespaceName))
  add(path_568269, "resourceGroupName", newJString(resourceGroupName))
  add(query_568270, "api-version", newJString(apiVersion))
  add(path_568269, "subscriptionId", newJString(subscriptionId))
  result = call_568268.call(path_568269, query_568270, nil, nil, nil)

var namespacesDelete* = Call_NamespacesDelete_568260(name: "namespacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}",
    validator: validate_NamespacesDelete_568261, base: "",
    url: url_NamespacesDelete_568262, schemes: {Scheme.Https})
type
  Call_NamespacesListPostAuthorizationRules_568295 = ref object of OpenApiRestCall_567657
proc url_NamespacesListPostAuthorizationRules_568297(protocol: Scheme;
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

proc validate_NamespacesListPostAuthorizationRules_568296(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rules for a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client Api Version.
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

proc call*(call_568302: Call_NamespacesListPostAuthorizationRules_568295;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rules for a namespace.
  ## 
  let valid = call_568302.validator(path, query, header, formData, body)
  let scheme = call_568302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568302.url(scheme.get, call_568302.host, call_568302.base,
                         call_568302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568302, url, valid)

proc call*(call_568303: Call_NamespacesListPostAuthorizationRules_568295;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesListPostAuthorizationRules
  ## Authorization rules for a namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568304 = newJObject()
  var query_568305 = newJObject()
  add(path_568304, "namespaceName", newJString(namespaceName))
  add(path_568304, "resourceGroupName", newJString(resourceGroupName))
  add(query_568305, "api-version", newJString(apiVersion))
  add(path_568304, "subscriptionId", newJString(subscriptionId))
  result = call_568303.call(path_568304, query_568305, nil, nil, nil)

var namespacesListPostAuthorizationRules* = Call_NamespacesListPostAuthorizationRules_568295(
    name: "namespacesListPostAuthorizationRules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListPostAuthorizationRules_568296, base: "",
    url: url_NamespacesListPostAuthorizationRules_568297, schemes: {Scheme.Https})
type
  Call_NamespacesListAuthorizationRules_568284 = ref object of OpenApiRestCall_567657
proc url_NamespacesListAuthorizationRules_568286(protocol: Scheme; host: string;
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

proc validate_NamespacesListAuthorizationRules_568285(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rules for a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568287 = path.getOrDefault("namespaceName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "namespaceName", valid_568287
  var valid_568288 = path.getOrDefault("resourceGroupName")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "resourceGroupName", valid_568288
  var valid_568289 = path.getOrDefault("subscriptionId")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "subscriptionId", valid_568289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568290 = query.getOrDefault("api-version")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "api-version", valid_568290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568291: Call_NamespacesListAuthorizationRules_568284;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rules for a namespace.
  ## 
  let valid = call_568291.validator(path, query, header, formData, body)
  let scheme = call_568291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568291.url(scheme.get, call_568291.host, call_568291.base,
                         call_568291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568291, url, valid)

proc call*(call_568292: Call_NamespacesListAuthorizationRules_568284;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesListAuthorizationRules
  ## Authorization rules for a namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568293 = newJObject()
  var query_568294 = newJObject()
  add(path_568293, "namespaceName", newJString(namespaceName))
  add(path_568293, "resourceGroupName", newJString(resourceGroupName))
  add(query_568294, "api-version", newJString(apiVersion))
  add(path_568293, "subscriptionId", newJString(subscriptionId))
  result = call_568292.call(path_568293, query_568294, nil, nil, nil)

var namespacesListAuthorizationRules* = Call_NamespacesListAuthorizationRules_568284(
    name: "namespacesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListAuthorizationRules_568285, base: "",
    url: url_NamespacesListAuthorizationRules_568286, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateAuthorizationRule_568318 = ref object of OpenApiRestCall_567657
proc url_NamespacesCreateOrUpdateAuthorizationRule_568320(protocol: Scheme;
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

proc validate_NamespacesCreateOrUpdateAuthorizationRule_568319(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates an authorization rule for a namespace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568321 = path.getOrDefault("namespaceName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "namespaceName", valid_568321
  var valid_568322 = path.getOrDefault("resourceGroupName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "resourceGroupName", valid_568322
  var valid_568323 = path.getOrDefault("authorizationRuleName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "authorizationRuleName", valid_568323
  var valid_568324 = path.getOrDefault("subscriptionId")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "subscriptionId", valid_568324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568325 = query.getOrDefault("api-version")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "api-version", valid_568325
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

proc call*(call_568327: Call_NamespacesCreateOrUpdateAuthorizationRule_568318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or Updates an authorization rule for a namespace
  ## 
  let valid = call_568327.validator(path, query, header, formData, body)
  let scheme = call_568327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568327.url(scheme.get, call_568327.host, call_568327.base,
                         call_568327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568327, url, valid)

proc call*(call_568328: Call_NamespacesCreateOrUpdateAuthorizationRule_568318;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateAuthorizationRule
  ## Creates or Updates an authorization rule for a namespace
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters
  var path_568329 = newJObject()
  var query_568330 = newJObject()
  var body_568331 = newJObject()
  add(path_568329, "namespaceName", newJString(namespaceName))
  add(path_568329, "resourceGroupName", newJString(resourceGroupName))
  add(query_568330, "api-version", newJString(apiVersion))
  add(path_568329, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568329, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568331 = parameters
  result = call_568328.call(path_568329, query_568330, nil, nil, body_568331)

var namespacesCreateOrUpdateAuthorizationRule* = Call_NamespacesCreateOrUpdateAuthorizationRule_568318(
    name: "namespacesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesCreateOrUpdateAuthorizationRule_568319,
    base: "", url: url_NamespacesCreateOrUpdateAuthorizationRule_568320,
    schemes: {Scheme.Https})
type
  Call_NamespacesPostAuthorizationRule_568332 = ref object of OpenApiRestCall_567657
proc url_NamespacesPostAuthorizationRule_568334(protocol: Scheme; host: string;
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

proc validate_NamespacesPostAuthorizationRule_568333(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rule for a namespace by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568335 = path.getOrDefault("namespaceName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "namespaceName", valid_568335
  var valid_568336 = path.getOrDefault("resourceGroupName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "resourceGroupName", valid_568336
  var valid_568337 = path.getOrDefault("authorizationRuleName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "authorizationRuleName", valid_568337
  var valid_568338 = path.getOrDefault("subscriptionId")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "subscriptionId", valid_568338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568339 = query.getOrDefault("api-version")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "api-version", valid_568339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568340: Call_NamespacesPostAuthorizationRule_568332;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rule for a namespace by name.
  ## 
  let valid = call_568340.validator(path, query, header, formData, body)
  let scheme = call_568340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568340.url(scheme.get, call_568340.host, call_568340.base,
                         call_568340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568340, url, valid)

proc call*(call_568341: Call_NamespacesPostAuthorizationRule_568332;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesPostAuthorizationRule
  ## Authorization rule for a namespace by name.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568342 = newJObject()
  var query_568343 = newJObject()
  add(path_568342, "namespaceName", newJString(namespaceName))
  add(path_568342, "resourceGroupName", newJString(resourceGroupName))
  add(query_568343, "api-version", newJString(apiVersion))
  add(path_568342, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568342, "subscriptionId", newJString(subscriptionId))
  result = call_568341.call(path_568342, query_568343, nil, nil, nil)

var namespacesPostAuthorizationRule* = Call_NamespacesPostAuthorizationRule_568332(
    name: "namespacesPostAuthorizationRule", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesPostAuthorizationRule_568333, base: "",
    url: url_NamespacesPostAuthorizationRule_568334, schemes: {Scheme.Https})
type
  Call_NamespacesGetAuthorizationRule_568306 = ref object of OpenApiRestCall_567657
proc url_NamespacesGetAuthorizationRule_568308(protocol: Scheme; host: string;
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

proc validate_NamespacesGetAuthorizationRule_568307(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rule for a namespace by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  var valid_568311 = path.getOrDefault("authorizationRuleName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "authorizationRuleName", valid_568311
  var valid_568312 = path.getOrDefault("subscriptionId")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "subscriptionId", valid_568312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568313 = query.getOrDefault("api-version")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "api-version", valid_568313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568314: Call_NamespacesGetAuthorizationRule_568306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Authorization rule for a namespace by name.
  ## 
  let valid = call_568314.validator(path, query, header, formData, body)
  let scheme = call_568314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568314.url(scheme.get, call_568314.host, call_568314.base,
                         call_568314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568314, url, valid)

proc call*(call_568315: Call_NamespacesGetAuthorizationRule_568306;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesGetAuthorizationRule
  ## Authorization rule for a namespace by name.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568316 = newJObject()
  var query_568317 = newJObject()
  add(path_568316, "namespaceName", newJString(namespaceName))
  add(path_568316, "resourceGroupName", newJString(resourceGroupName))
  add(query_568317, "api-version", newJString(apiVersion))
  add(path_568316, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568316, "subscriptionId", newJString(subscriptionId))
  result = call_568315.call(path_568316, query_568317, nil, nil, nil)

var namespacesGetAuthorizationRule* = Call_NamespacesGetAuthorizationRule_568306(
    name: "namespacesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesGetAuthorizationRule_568307, base: "",
    url: url_NamespacesGetAuthorizationRule_568308, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteAuthorizationRule_568344 = ref object of OpenApiRestCall_567657
proc url_NamespacesDeleteAuthorizationRule_568346(protocol: Scheme; host: string;
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

proc validate_NamespacesDeleteAuthorizationRule_568345(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a namespace authorization rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568347 = path.getOrDefault("namespaceName")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "namespaceName", valid_568347
  var valid_568348 = path.getOrDefault("resourceGroupName")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "resourceGroupName", valid_568348
  var valid_568349 = path.getOrDefault("authorizationRuleName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "authorizationRuleName", valid_568349
  var valid_568350 = path.getOrDefault("subscriptionId")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "subscriptionId", valid_568350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568351 = query.getOrDefault("api-version")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "api-version", valid_568351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568352: Call_NamespacesDeleteAuthorizationRule_568344;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a namespace authorization rule
  ## 
  let valid = call_568352.validator(path, query, header, formData, body)
  let scheme = call_568352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568352.url(scheme.get, call_568352.host, call_568352.base,
                         call_568352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568352, url, valid)

proc call*(call_568353: Call_NamespacesDeleteAuthorizationRule_568344;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesDeleteAuthorizationRule
  ## Deletes a namespace authorization rule
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568354 = newJObject()
  var query_568355 = newJObject()
  add(path_568354, "namespaceName", newJString(namespaceName))
  add(path_568354, "resourceGroupName", newJString(resourceGroupName))
  add(query_568355, "api-version", newJString(apiVersion))
  add(path_568354, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568354, "subscriptionId", newJString(subscriptionId))
  result = call_568353.call(path_568354, query_568355, nil, nil, nil)

var namespacesDeleteAuthorizationRule* = Call_NamespacesDeleteAuthorizationRule_568344(
    name: "namespacesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesDeleteAuthorizationRule_568345, base: "",
    url: url_NamespacesDeleteAuthorizationRule_568346, schemes: {Scheme.Https})
type
  Call_NamespacesListKeys_568356 = ref object of OpenApiRestCall_567657
proc url_NamespacesListKeys_568358(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesListKeys_568357(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Primary and Secondary ConnectionStrings to the namespace 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568359 = path.getOrDefault("namespaceName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "namespaceName", valid_568359
  var valid_568360 = path.getOrDefault("resourceGroupName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "resourceGroupName", valid_568360
  var valid_568361 = path.getOrDefault("authorizationRuleName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "authorizationRuleName", valid_568361
  var valid_568362 = path.getOrDefault("subscriptionId")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "subscriptionId", valid_568362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568363 = query.getOrDefault("api-version")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "api-version", valid_568363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568364: Call_NamespacesListKeys_568356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Primary and Secondary ConnectionStrings to the namespace 
  ## 
  let valid = call_568364.validator(path, query, header, formData, body)
  let scheme = call_568364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568364.url(scheme.get, call_568364.host, call_568364.base,
                         call_568364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568364, url, valid)

proc call*(call_568365: Call_NamespacesListKeys_568356; namespaceName: string;
          resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesListKeys
  ## Primary and Secondary ConnectionStrings to the namespace 
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568366 = newJObject()
  var query_568367 = newJObject()
  add(path_568366, "namespaceName", newJString(namespaceName))
  add(path_568366, "resourceGroupName", newJString(resourceGroupName))
  add(query_568367, "api-version", newJString(apiVersion))
  add(path_568366, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568366, "subscriptionId", newJString(subscriptionId))
  result = call_568365.call(path_568366, query_568367, nil, nil, nil)

var namespacesListKeys* = Call_NamespacesListKeys_568356(
    name: "namespacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_NamespacesListKeys_568357, base: "",
    url: url_NamespacesListKeys_568358, schemes: {Scheme.Https})
type
  Call_NamespacesRegenerateKeys_568368 = ref object of OpenApiRestCall_567657
proc url_NamespacesRegenerateKeys_568370(protocol: Scheme; host: string;
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

proc validate_NamespacesRegenerateKeys_568369(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the Primary or Secondary ConnectionStrings to the namespace 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568371 = path.getOrDefault("namespaceName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "namespaceName", valid_568371
  var valid_568372 = path.getOrDefault("resourceGroupName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "resourceGroupName", valid_568372
  var valid_568373 = path.getOrDefault("authorizationRuleName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "authorizationRuleName", valid_568373
  var valid_568374 = path.getOrDefault("subscriptionId")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "subscriptionId", valid_568374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568375 = query.getOrDefault("api-version")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "api-version", valid_568375
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

proc call*(call_568377: Call_NamespacesRegenerateKeys_568368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the Primary or Secondary ConnectionStrings to the namespace 
  ## 
  let valid = call_568377.validator(path, query, header, formData, body)
  let scheme = call_568377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568377.url(scheme.get, call_568377.host, call_568377.base,
                         call_568377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568377, url, valid)

proc call*(call_568378: Call_NamespacesRegenerateKeys_568368;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesRegenerateKeys
  ## Regenerates the Primary or Secondary ConnectionStrings to the namespace 
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate Auth Rule.
  var path_568379 = newJObject()
  var query_568380 = newJObject()
  var body_568381 = newJObject()
  add(path_568379, "namespaceName", newJString(namespaceName))
  add(path_568379, "resourceGroupName", newJString(resourceGroupName))
  add(query_568380, "api-version", newJString(apiVersion))
  add(path_568379, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568379, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568381 = parameters
  result = call_568378.call(path_568379, query_568380, nil, nil, body_568381)

var namespacesRegenerateKeys* = Call_NamespacesRegenerateKeys_568368(
    name: "namespacesRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_NamespacesRegenerateKeys_568369, base: "",
    url: url_NamespacesRegenerateKeys_568370, schemes: {Scheme.Https})
type
  Call_HybridConnectionsListByNamespace_568382 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsListByNamespace_568384(protocol: Scheme; host: string;
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

proc validate_HybridConnectionsListByNamespace_568383(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the HybridConnection within the namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568385 = path.getOrDefault("namespaceName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "namespaceName", valid_568385
  var valid_568386 = path.getOrDefault("resourceGroupName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "resourceGroupName", valid_568386
  var valid_568387 = path.getOrDefault("subscriptionId")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "subscriptionId", valid_568387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568388 = query.getOrDefault("api-version")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "api-version", valid_568388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568389: Call_HybridConnectionsListByNamespace_568382;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the HybridConnection within the namespace.
  ## 
  let valid = call_568389.validator(path, query, header, formData, body)
  let scheme = call_568389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568389.url(scheme.get, call_568389.host, call_568389.base,
                         call_568389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568389, url, valid)

proc call*(call_568390: Call_HybridConnectionsListByNamespace_568382;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## hybridConnectionsListByNamespace
  ## Lists the HybridConnection within the namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568391 = newJObject()
  var query_568392 = newJObject()
  add(path_568391, "namespaceName", newJString(namespaceName))
  add(path_568391, "resourceGroupName", newJString(resourceGroupName))
  add(query_568392, "api-version", newJString(apiVersion))
  add(path_568391, "subscriptionId", newJString(subscriptionId))
  result = call_568390.call(path_568391, query_568392, nil, nil, nil)

var hybridConnectionsListByNamespace* = Call_HybridConnectionsListByNamespace_568382(
    name: "hybridConnectionsListByNamespace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections",
    validator: validate_HybridConnectionsListByNamespace_568383, base: "",
    url: url_HybridConnectionsListByNamespace_568384, schemes: {Scheme.Https})
type
  Call_HybridConnectionsCreateOrUpdate_568405 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsCreateOrUpdate_568407(protocol: Scheme; host: string;
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

proc validate_HybridConnectionsCreateOrUpdate_568406(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a service HybridConnection. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568408 = path.getOrDefault("namespaceName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "namespaceName", valid_568408
  var valid_568409 = path.getOrDefault("resourceGroupName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "resourceGroupName", valid_568409
  var valid_568410 = path.getOrDefault("subscriptionId")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "subscriptionId", valid_568410
  var valid_568411 = path.getOrDefault("hybridConnectionName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "hybridConnectionName", valid_568411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568412 = query.getOrDefault("api-version")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "api-version", valid_568412
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

proc call*(call_568414: Call_HybridConnectionsCreateOrUpdate_568405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or Updates a service HybridConnection. This operation is idempotent.
  ## 
  let valid = call_568414.validator(path, query, header, formData, body)
  let scheme = call_568414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568414.url(scheme.get, call_568414.host, call_568414.base,
                         call_568414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568414, url, valid)

proc call*(call_568415: Call_HybridConnectionsCreateOrUpdate_568405;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; hybridConnectionName: string; parameters: JsonNode): Recallable =
  ## hybridConnectionsCreateOrUpdate
  ## Creates or Updates a service HybridConnection. This operation is idempotent.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a HybridConnection.
  var path_568416 = newJObject()
  var query_568417 = newJObject()
  var body_568418 = newJObject()
  add(path_568416, "namespaceName", newJString(namespaceName))
  add(path_568416, "resourceGroupName", newJString(resourceGroupName))
  add(query_568417, "api-version", newJString(apiVersion))
  add(path_568416, "subscriptionId", newJString(subscriptionId))
  add(path_568416, "hybridConnectionName", newJString(hybridConnectionName))
  if parameters != nil:
    body_568418 = parameters
  result = call_568415.call(path_568416, query_568417, nil, nil, body_568418)

var hybridConnectionsCreateOrUpdate* = Call_HybridConnectionsCreateOrUpdate_568405(
    name: "hybridConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}",
    validator: validate_HybridConnectionsCreateOrUpdate_568406, base: "",
    url: url_HybridConnectionsCreateOrUpdate_568407, schemes: {Scheme.Https})
type
  Call_HybridConnectionsGet_568393 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsGet_568395(protocol: Scheme; host: string; base: string;
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

proc validate_HybridConnectionsGet_568394(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the description for the specified HybridConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568396 = path.getOrDefault("namespaceName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "namespaceName", valid_568396
  var valid_568397 = path.getOrDefault("resourceGroupName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "resourceGroupName", valid_568397
  var valid_568398 = path.getOrDefault("subscriptionId")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "subscriptionId", valid_568398
  var valid_568399 = path.getOrDefault("hybridConnectionName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "hybridConnectionName", valid_568399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568400 = query.getOrDefault("api-version")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "api-version", valid_568400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568401: Call_HybridConnectionsGet_568393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the description for the specified HybridConnection.
  ## 
  let valid = call_568401.validator(path, query, header, formData, body)
  let scheme = call_568401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568401.url(scheme.get, call_568401.host, call_568401.base,
                         call_568401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568401, url, valid)

proc call*(call_568402: Call_HybridConnectionsGet_568393; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          hybridConnectionName: string): Recallable =
  ## hybridConnectionsGet
  ## Returns the description for the specified HybridConnection.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  var path_568403 = newJObject()
  var query_568404 = newJObject()
  add(path_568403, "namespaceName", newJString(namespaceName))
  add(path_568403, "resourceGroupName", newJString(resourceGroupName))
  add(query_568404, "api-version", newJString(apiVersion))
  add(path_568403, "subscriptionId", newJString(subscriptionId))
  add(path_568403, "hybridConnectionName", newJString(hybridConnectionName))
  result = call_568402.call(path_568403, query_568404, nil, nil, nil)

var hybridConnectionsGet* = Call_HybridConnectionsGet_568393(
    name: "hybridConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}",
    validator: validate_HybridConnectionsGet_568394, base: "",
    url: url_HybridConnectionsGet_568395, schemes: {Scheme.Https})
type
  Call_HybridConnectionsDelete_568419 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsDelete_568421(protocol: Scheme; host: string; base: string;
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

proc validate_HybridConnectionsDelete_568420(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a HybridConnection .
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568422 = path.getOrDefault("namespaceName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "namespaceName", valid_568422
  var valid_568423 = path.getOrDefault("resourceGroupName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "resourceGroupName", valid_568423
  var valid_568424 = path.getOrDefault("subscriptionId")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "subscriptionId", valid_568424
  var valid_568425 = path.getOrDefault("hybridConnectionName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "hybridConnectionName", valid_568425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568426 = query.getOrDefault("api-version")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "api-version", valid_568426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568427: Call_HybridConnectionsDelete_568419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a HybridConnection .
  ## 
  let valid = call_568427.validator(path, query, header, formData, body)
  let scheme = call_568427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568427.url(scheme.get, call_568427.host, call_568427.base,
                         call_568427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568427, url, valid)

proc call*(call_568428: Call_HybridConnectionsDelete_568419; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          hybridConnectionName: string): Recallable =
  ## hybridConnectionsDelete
  ## Deletes a HybridConnection .
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  var path_568429 = newJObject()
  var query_568430 = newJObject()
  add(path_568429, "namespaceName", newJString(namespaceName))
  add(path_568429, "resourceGroupName", newJString(resourceGroupName))
  add(query_568430, "api-version", newJString(apiVersion))
  add(path_568429, "subscriptionId", newJString(subscriptionId))
  add(path_568429, "hybridConnectionName", newJString(hybridConnectionName))
  result = call_568428.call(path_568429, query_568430, nil, nil, nil)

var hybridConnectionsDelete* = Call_HybridConnectionsDelete_568419(
    name: "hybridConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}",
    validator: validate_HybridConnectionsDelete_568420, base: "",
    url: url_HybridConnectionsDelete_568421, schemes: {Scheme.Https})
type
  Call_HybridConnectionsListPostAuthorizationRules_568443 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsListPostAuthorizationRules_568445(protocol: Scheme;
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

proc validate_HybridConnectionsListPostAuthorizationRules_568444(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rules for a HybridConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568446 = path.getOrDefault("namespaceName")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "namespaceName", valid_568446
  var valid_568447 = path.getOrDefault("resourceGroupName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "resourceGroupName", valid_568447
  var valid_568448 = path.getOrDefault("subscriptionId")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "subscriptionId", valid_568448
  var valid_568449 = path.getOrDefault("hybridConnectionName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "hybridConnectionName", valid_568449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568450 = query.getOrDefault("api-version")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "api-version", valid_568450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568451: Call_HybridConnectionsListPostAuthorizationRules_568443;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rules for a HybridConnection.
  ## 
  let valid = call_568451.validator(path, query, header, formData, body)
  let scheme = call_568451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568451.url(scheme.get, call_568451.host, call_568451.base,
                         call_568451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568451, url, valid)

proc call*(call_568452: Call_HybridConnectionsListPostAuthorizationRules_568443;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; hybridConnectionName: string): Recallable =
  ## hybridConnectionsListPostAuthorizationRules
  ## Authorization rules for a HybridConnection.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  var path_568453 = newJObject()
  var query_568454 = newJObject()
  add(path_568453, "namespaceName", newJString(namespaceName))
  add(path_568453, "resourceGroupName", newJString(resourceGroupName))
  add(query_568454, "api-version", newJString(apiVersion))
  add(path_568453, "subscriptionId", newJString(subscriptionId))
  add(path_568453, "hybridConnectionName", newJString(hybridConnectionName))
  result = call_568452.call(path_568453, query_568454, nil, nil, nil)

var hybridConnectionsListPostAuthorizationRules* = Call_HybridConnectionsListPostAuthorizationRules_568443(
    name: "hybridConnectionsListPostAuthorizationRules",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}/authorizationRules",
    validator: validate_HybridConnectionsListPostAuthorizationRules_568444,
    base: "", url: url_HybridConnectionsListPostAuthorizationRules_568445,
    schemes: {Scheme.Https})
type
  Call_HybridConnectionsListAuthorizationRules_568431 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsListAuthorizationRules_568433(protocol: Scheme;
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

proc validate_HybridConnectionsListAuthorizationRules_568432(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rules for a HybridConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568434 = path.getOrDefault("namespaceName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "namespaceName", valid_568434
  var valid_568435 = path.getOrDefault("resourceGroupName")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "resourceGroupName", valid_568435
  var valid_568436 = path.getOrDefault("subscriptionId")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "subscriptionId", valid_568436
  var valid_568437 = path.getOrDefault("hybridConnectionName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "hybridConnectionName", valid_568437
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568438 = query.getOrDefault("api-version")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "api-version", valid_568438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568439: Call_HybridConnectionsListAuthorizationRules_568431;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rules for a HybridConnection.
  ## 
  let valid = call_568439.validator(path, query, header, formData, body)
  let scheme = call_568439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568439.url(scheme.get, call_568439.host, call_568439.base,
                         call_568439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568439, url, valid)

proc call*(call_568440: Call_HybridConnectionsListAuthorizationRules_568431;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; hybridConnectionName: string): Recallable =
  ## hybridConnectionsListAuthorizationRules
  ## Authorization rules for a HybridConnection.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  var path_568441 = newJObject()
  var query_568442 = newJObject()
  add(path_568441, "namespaceName", newJString(namespaceName))
  add(path_568441, "resourceGroupName", newJString(resourceGroupName))
  add(query_568442, "api-version", newJString(apiVersion))
  add(path_568441, "subscriptionId", newJString(subscriptionId))
  add(path_568441, "hybridConnectionName", newJString(hybridConnectionName))
  result = call_568440.call(path_568441, query_568442, nil, nil, nil)

var hybridConnectionsListAuthorizationRules* = Call_HybridConnectionsListAuthorizationRules_568431(
    name: "hybridConnectionsListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}/authorizationRules",
    validator: validate_HybridConnectionsListAuthorizationRules_568432, base: "",
    url: url_HybridConnectionsListAuthorizationRules_568433,
    schemes: {Scheme.Https})
type
  Call_HybridConnectionsCreateOrUpdateAuthorizationRule_568468 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsCreateOrUpdateAuthorizationRule_568470(
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

proc validate_HybridConnectionsCreateOrUpdateAuthorizationRule_568469(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or Updates an authorization rule for a HybridConnection
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568471 = path.getOrDefault("namespaceName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "namespaceName", valid_568471
  var valid_568472 = path.getOrDefault("resourceGroupName")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "resourceGroupName", valid_568472
  var valid_568473 = path.getOrDefault("authorizationRuleName")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "authorizationRuleName", valid_568473
  var valid_568474 = path.getOrDefault("subscriptionId")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "subscriptionId", valid_568474
  var valid_568475 = path.getOrDefault("hybridConnectionName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "hybridConnectionName", valid_568475
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568476 = query.getOrDefault("api-version")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "api-version", valid_568476
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

proc call*(call_568478: Call_HybridConnectionsCreateOrUpdateAuthorizationRule_568468;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or Updates an authorization rule for a HybridConnection
  ## 
  let valid = call_568478.validator(path, query, header, formData, body)
  let scheme = call_568478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568478.url(scheme.get, call_568478.host, call_568478.base,
                         call_568478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568478, url, valid)

proc call*(call_568479: Call_HybridConnectionsCreateOrUpdateAuthorizationRule_568468;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          hybridConnectionName: string; parameters: JsonNode): Recallable =
  ## hybridConnectionsCreateOrUpdateAuthorizationRule
  ## Creates or Updates an authorization rule for a HybridConnection
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters
  var path_568480 = newJObject()
  var query_568481 = newJObject()
  var body_568482 = newJObject()
  add(path_568480, "namespaceName", newJString(namespaceName))
  add(path_568480, "resourceGroupName", newJString(resourceGroupName))
  add(query_568481, "api-version", newJString(apiVersion))
  add(path_568480, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568480, "subscriptionId", newJString(subscriptionId))
  add(path_568480, "hybridConnectionName", newJString(hybridConnectionName))
  if parameters != nil:
    body_568482 = parameters
  result = call_568479.call(path_568480, query_568481, nil, nil, body_568482)

var hybridConnectionsCreateOrUpdateAuthorizationRule* = Call_HybridConnectionsCreateOrUpdateAuthorizationRule_568468(
    name: "hybridConnectionsCreateOrUpdateAuthorizationRule",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}",
    validator: validate_HybridConnectionsCreateOrUpdateAuthorizationRule_568469,
    base: "", url: url_HybridConnectionsCreateOrUpdateAuthorizationRule_568470,
    schemes: {Scheme.Https})
type
  Call_HybridConnectionsPostAuthorizationRule_568483 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsPostAuthorizationRule_568485(protocol: Scheme;
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

proc validate_HybridConnectionsPostAuthorizationRule_568484(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## HybridConnection authorizationRule for a HybridConnection by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568486 = path.getOrDefault("namespaceName")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "namespaceName", valid_568486
  var valid_568487 = path.getOrDefault("resourceGroupName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "resourceGroupName", valid_568487
  var valid_568488 = path.getOrDefault("authorizationRuleName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "authorizationRuleName", valid_568488
  var valid_568489 = path.getOrDefault("subscriptionId")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "subscriptionId", valid_568489
  var valid_568490 = path.getOrDefault("hybridConnectionName")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "hybridConnectionName", valid_568490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568491 = query.getOrDefault("api-version")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "api-version", valid_568491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568492: Call_HybridConnectionsPostAuthorizationRule_568483;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## HybridConnection authorizationRule for a HybridConnection by name.
  ## 
  let valid = call_568492.validator(path, query, header, formData, body)
  let scheme = call_568492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568492.url(scheme.get, call_568492.host, call_568492.base,
                         call_568492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568492, url, valid)

proc call*(call_568493: Call_HybridConnectionsPostAuthorizationRule_568483;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          hybridConnectionName: string): Recallable =
  ## hybridConnectionsPostAuthorizationRule
  ## HybridConnection authorizationRule for a HybridConnection by name.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  var path_568494 = newJObject()
  var query_568495 = newJObject()
  add(path_568494, "namespaceName", newJString(namespaceName))
  add(path_568494, "resourceGroupName", newJString(resourceGroupName))
  add(query_568495, "api-version", newJString(apiVersion))
  add(path_568494, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568494, "subscriptionId", newJString(subscriptionId))
  add(path_568494, "hybridConnectionName", newJString(hybridConnectionName))
  result = call_568493.call(path_568494, query_568495, nil, nil, nil)

var hybridConnectionsPostAuthorizationRule* = Call_HybridConnectionsPostAuthorizationRule_568483(
    name: "hybridConnectionsPostAuthorizationRule", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}",
    validator: validate_HybridConnectionsPostAuthorizationRule_568484, base: "",
    url: url_HybridConnectionsPostAuthorizationRule_568485,
    schemes: {Scheme.Https})
type
  Call_HybridConnectionsGetAuthorizationRule_568455 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsGetAuthorizationRule_568457(protocol: Scheme;
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

proc validate_HybridConnectionsGetAuthorizationRule_568456(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## HybridConnection authorizationRule for a HybridConnection by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568458 = path.getOrDefault("namespaceName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "namespaceName", valid_568458
  var valid_568459 = path.getOrDefault("resourceGroupName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "resourceGroupName", valid_568459
  var valid_568460 = path.getOrDefault("authorizationRuleName")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "authorizationRuleName", valid_568460
  var valid_568461 = path.getOrDefault("subscriptionId")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "subscriptionId", valid_568461
  var valid_568462 = path.getOrDefault("hybridConnectionName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "hybridConnectionName", valid_568462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568463 = query.getOrDefault("api-version")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "api-version", valid_568463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568464: Call_HybridConnectionsGetAuthorizationRule_568455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## HybridConnection authorizationRule for a HybridConnection by name.
  ## 
  let valid = call_568464.validator(path, query, header, formData, body)
  let scheme = call_568464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568464.url(scheme.get, call_568464.host, call_568464.base,
                         call_568464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568464, url, valid)

proc call*(call_568465: Call_HybridConnectionsGetAuthorizationRule_568455;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          hybridConnectionName: string): Recallable =
  ## hybridConnectionsGetAuthorizationRule
  ## HybridConnection authorizationRule for a HybridConnection by name.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  var path_568466 = newJObject()
  var query_568467 = newJObject()
  add(path_568466, "namespaceName", newJString(namespaceName))
  add(path_568466, "resourceGroupName", newJString(resourceGroupName))
  add(query_568467, "api-version", newJString(apiVersion))
  add(path_568466, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568466, "subscriptionId", newJString(subscriptionId))
  add(path_568466, "hybridConnectionName", newJString(hybridConnectionName))
  result = call_568465.call(path_568466, query_568467, nil, nil, nil)

var hybridConnectionsGetAuthorizationRule* = Call_HybridConnectionsGetAuthorizationRule_568455(
    name: "hybridConnectionsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}",
    validator: validate_HybridConnectionsGetAuthorizationRule_568456, base: "",
    url: url_HybridConnectionsGetAuthorizationRule_568457, schemes: {Scheme.Https})
type
  Call_HybridConnectionsDeleteAuthorizationRule_568496 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsDeleteAuthorizationRule_568498(protocol: Scheme;
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

proc validate_HybridConnectionsDeleteAuthorizationRule_568497(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a HybridConnection authorization rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568499 = path.getOrDefault("namespaceName")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "namespaceName", valid_568499
  var valid_568500 = path.getOrDefault("resourceGroupName")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "resourceGroupName", valid_568500
  var valid_568501 = path.getOrDefault("authorizationRuleName")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "authorizationRuleName", valid_568501
  var valid_568502 = path.getOrDefault("subscriptionId")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "subscriptionId", valid_568502
  var valid_568503 = path.getOrDefault("hybridConnectionName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "hybridConnectionName", valid_568503
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568504 = query.getOrDefault("api-version")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "api-version", valid_568504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568505: Call_HybridConnectionsDeleteAuthorizationRule_568496;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a HybridConnection authorization rule
  ## 
  let valid = call_568505.validator(path, query, header, formData, body)
  let scheme = call_568505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568505.url(scheme.get, call_568505.host, call_568505.base,
                         call_568505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568505, url, valid)

proc call*(call_568506: Call_HybridConnectionsDeleteAuthorizationRule_568496;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          hybridConnectionName: string): Recallable =
  ## hybridConnectionsDeleteAuthorizationRule
  ## Deletes a HybridConnection authorization rule
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  var path_568507 = newJObject()
  var query_568508 = newJObject()
  add(path_568507, "namespaceName", newJString(namespaceName))
  add(path_568507, "resourceGroupName", newJString(resourceGroupName))
  add(query_568508, "api-version", newJString(apiVersion))
  add(path_568507, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568507, "subscriptionId", newJString(subscriptionId))
  add(path_568507, "hybridConnectionName", newJString(hybridConnectionName))
  result = call_568506.call(path_568507, query_568508, nil, nil, nil)

var hybridConnectionsDeleteAuthorizationRule* = Call_HybridConnectionsDeleteAuthorizationRule_568496(
    name: "hybridConnectionsDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}",
    validator: validate_HybridConnectionsDeleteAuthorizationRule_568497, base: "",
    url: url_HybridConnectionsDeleteAuthorizationRule_568498,
    schemes: {Scheme.Https})
type
  Call_HybridConnectionsListKeys_568509 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsListKeys_568511(protocol: Scheme; host: string;
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

proc validate_HybridConnectionsListKeys_568510(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Primary and Secondary ConnectionStrings to the HybridConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568512 = path.getOrDefault("namespaceName")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "namespaceName", valid_568512
  var valid_568513 = path.getOrDefault("resourceGroupName")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "resourceGroupName", valid_568513
  var valid_568514 = path.getOrDefault("authorizationRuleName")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "authorizationRuleName", valid_568514
  var valid_568515 = path.getOrDefault("subscriptionId")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "subscriptionId", valid_568515
  var valid_568516 = path.getOrDefault("hybridConnectionName")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "hybridConnectionName", valid_568516
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_568518: Call_HybridConnectionsListKeys_568509; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Primary and Secondary ConnectionStrings to the HybridConnection.
  ## 
  let valid = call_568518.validator(path, query, header, formData, body)
  let scheme = call_568518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568518.url(scheme.get, call_568518.host, call_568518.base,
                         call_568518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568518, url, valid)

proc call*(call_568519: Call_HybridConnectionsListKeys_568509;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          hybridConnectionName: string): Recallable =
  ## hybridConnectionsListKeys
  ## Primary and Secondary ConnectionStrings to the HybridConnection.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  var path_568520 = newJObject()
  var query_568521 = newJObject()
  add(path_568520, "namespaceName", newJString(namespaceName))
  add(path_568520, "resourceGroupName", newJString(resourceGroupName))
  add(query_568521, "api-version", newJString(apiVersion))
  add(path_568520, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568520, "subscriptionId", newJString(subscriptionId))
  add(path_568520, "hybridConnectionName", newJString(hybridConnectionName))
  result = call_568519.call(path_568520, query_568521, nil, nil, nil)

var hybridConnectionsListKeys* = Call_HybridConnectionsListKeys_568509(
    name: "hybridConnectionsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}/ListKeys",
    validator: validate_HybridConnectionsListKeys_568510, base: "",
    url: url_HybridConnectionsListKeys_568511, schemes: {Scheme.Https})
type
  Call_HybridConnectionsRegenerateKeys_568522 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsRegenerateKeys_568524(protocol: Scheme; host: string;
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

proc validate_HybridConnectionsRegenerateKeys_568523(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the Primary or Secondary ConnectionStrings to the HybridConnection
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
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
  var valid_568527 = path.getOrDefault("authorizationRuleName")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "authorizationRuleName", valid_568527
  var valid_568528 = path.getOrDefault("subscriptionId")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "subscriptionId", valid_568528
  var valid_568529 = path.getOrDefault("hybridConnectionName")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "hybridConnectionName", valid_568529
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568530 = query.getOrDefault("api-version")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "api-version", valid_568530
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

proc call*(call_568532: Call_HybridConnectionsRegenerateKeys_568522;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the Primary or Secondary ConnectionStrings to the HybridConnection
  ## 
  let valid = call_568532.validator(path, query, header, formData, body)
  let scheme = call_568532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568532.url(scheme.get, call_568532.host, call_568532.base,
                         call_568532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568532, url, valid)

proc call*(call_568533: Call_HybridConnectionsRegenerateKeys_568522;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          hybridConnectionName: string; parameters: JsonNode): Recallable =
  ## hybridConnectionsRegenerateKeys
  ## Regenerates the Primary or Secondary ConnectionStrings to the HybridConnection
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate Auth Rule.
  var path_568534 = newJObject()
  var query_568535 = newJObject()
  var body_568536 = newJObject()
  add(path_568534, "namespaceName", newJString(namespaceName))
  add(path_568534, "resourceGroupName", newJString(resourceGroupName))
  add(query_568535, "api-version", newJString(apiVersion))
  add(path_568534, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568534, "subscriptionId", newJString(subscriptionId))
  add(path_568534, "hybridConnectionName", newJString(hybridConnectionName))
  if parameters != nil:
    body_568536 = parameters
  result = call_568533.call(path_568534, query_568535, nil, nil, body_568536)

var hybridConnectionsRegenerateKeys* = Call_HybridConnectionsRegenerateKeys_568522(
    name: "hybridConnectionsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/HybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_HybridConnectionsRegenerateKeys_568523, base: "",
    url: url_HybridConnectionsRegenerateKeys_568524, schemes: {Scheme.Https})
type
  Call_WcfrelaysListByNamespace_568537 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysListByNamespace_568539(protocol: Scheme; host: string;
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

proc validate_WcfrelaysListByNamespace_568538(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the WCFRelays within the namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568540 = path.getOrDefault("namespaceName")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "namespaceName", valid_568540
  var valid_568541 = path.getOrDefault("resourceGroupName")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "resourceGroupName", valid_568541
  var valid_568542 = path.getOrDefault("subscriptionId")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "subscriptionId", valid_568542
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568543 = query.getOrDefault("api-version")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "api-version", valid_568543
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568544: Call_WcfrelaysListByNamespace_568537; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the WCFRelays within the namespace.
  ## 
  let valid = call_568544.validator(path, query, header, formData, body)
  let scheme = call_568544.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568544.url(scheme.get, call_568544.host, call_568544.base,
                         call_568544.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568544, url, valid)

proc call*(call_568545: Call_WcfrelaysListByNamespace_568537;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## wcfrelaysListByNamespace
  ## Lists the WCFRelays within the namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568546 = newJObject()
  var query_568547 = newJObject()
  add(path_568546, "namespaceName", newJString(namespaceName))
  add(path_568546, "resourceGroupName", newJString(resourceGroupName))
  add(query_568547, "api-version", newJString(apiVersion))
  add(path_568546, "subscriptionId", newJString(subscriptionId))
  result = call_568545.call(path_568546, query_568547, nil, nil, nil)

var wcfrelaysListByNamespace* = Call_WcfrelaysListByNamespace_568537(
    name: "wcfrelaysListByNamespace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays",
    validator: validate_WcfrelaysListByNamespace_568538, base: "",
    url: url_WcfrelaysListByNamespace_568539, schemes: {Scheme.Https})
type
  Call_WcfrelaysCreateOrUpdate_568560 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysCreateOrUpdate_568562(protocol: Scheme; host: string; base: string;
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

proc validate_WcfrelaysCreateOrUpdate_568561(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a WCFRelay. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568563 = path.getOrDefault("namespaceName")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "namespaceName", valid_568563
  var valid_568564 = path.getOrDefault("resourceGroupName")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "resourceGroupName", valid_568564
  var valid_568565 = path.getOrDefault("subscriptionId")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "subscriptionId", valid_568565
  var valid_568566 = path.getOrDefault("relayName")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "relayName", valid_568566
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568567 = query.getOrDefault("api-version")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "api-version", valid_568567
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

proc call*(call_568569: Call_WcfrelaysCreateOrUpdate_568560; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a WCFRelay. This operation is idempotent.
  ## 
  let valid = call_568569.validator(path, query, header, formData, body)
  let scheme = call_568569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568569.url(scheme.get, call_568569.host, call_568569.base,
                         call_568569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568569, url, valid)

proc call*(call_568570: Call_WcfrelaysCreateOrUpdate_568560; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          relayName: string; parameters: JsonNode): Recallable =
  ## wcfrelaysCreateOrUpdate
  ## Creates or Updates a WCFRelay. This operation is idempotent.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a WCFRelays.
  var path_568571 = newJObject()
  var query_568572 = newJObject()
  var body_568573 = newJObject()
  add(path_568571, "namespaceName", newJString(namespaceName))
  add(path_568571, "resourceGroupName", newJString(resourceGroupName))
  add(query_568572, "api-version", newJString(apiVersion))
  add(path_568571, "subscriptionId", newJString(subscriptionId))
  add(path_568571, "relayName", newJString(relayName))
  if parameters != nil:
    body_568573 = parameters
  result = call_568570.call(path_568571, query_568572, nil, nil, body_568573)

var wcfrelaysCreateOrUpdate* = Call_WcfrelaysCreateOrUpdate_568560(
    name: "wcfrelaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}",
    validator: validate_WcfrelaysCreateOrUpdate_568561, base: "",
    url: url_WcfrelaysCreateOrUpdate_568562, schemes: {Scheme.Https})
type
  Call_WcfrelaysGet_568548 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysGet_568550(protocol: Scheme; host: string; base: string;
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

proc validate_WcfrelaysGet_568549(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the description for the specified WCFRelays.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568551 = path.getOrDefault("namespaceName")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "namespaceName", valid_568551
  var valid_568552 = path.getOrDefault("resourceGroupName")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "resourceGroupName", valid_568552
  var valid_568553 = path.getOrDefault("subscriptionId")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "subscriptionId", valid_568553
  var valid_568554 = path.getOrDefault("relayName")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "relayName", valid_568554
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568555 = query.getOrDefault("api-version")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "api-version", valid_568555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568556: Call_WcfrelaysGet_568548; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the description for the specified WCFRelays.
  ## 
  let valid = call_568556.validator(path, query, header, formData, body)
  let scheme = call_568556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568556.url(scheme.get, call_568556.host, call_568556.base,
                         call_568556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568556, url, valid)

proc call*(call_568557: Call_WcfrelaysGet_568548; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          relayName: string): Recallable =
  ## wcfrelaysGet
  ## Returns the description for the specified WCFRelays.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name
  var path_568558 = newJObject()
  var query_568559 = newJObject()
  add(path_568558, "namespaceName", newJString(namespaceName))
  add(path_568558, "resourceGroupName", newJString(resourceGroupName))
  add(query_568559, "api-version", newJString(apiVersion))
  add(path_568558, "subscriptionId", newJString(subscriptionId))
  add(path_568558, "relayName", newJString(relayName))
  result = call_568557.call(path_568558, query_568559, nil, nil, nil)

var wcfrelaysGet* = Call_WcfrelaysGet_568548(name: "wcfrelaysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}",
    validator: validate_WcfrelaysGet_568549, base: "", url: url_WcfrelaysGet_568550,
    schemes: {Scheme.Https})
type
  Call_WcfrelaysDelete_568574 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysDelete_568576(protocol: Scheme; host: string; base: string;
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

proc validate_WcfrelaysDelete_568575(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a WCFRelays .
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568577 = path.getOrDefault("namespaceName")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "namespaceName", valid_568577
  var valid_568578 = path.getOrDefault("resourceGroupName")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "resourceGroupName", valid_568578
  var valid_568579 = path.getOrDefault("subscriptionId")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "subscriptionId", valid_568579
  var valid_568580 = path.getOrDefault("relayName")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "relayName", valid_568580
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568581 = query.getOrDefault("api-version")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "api-version", valid_568581
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568582: Call_WcfrelaysDelete_568574; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a WCFRelays .
  ## 
  let valid = call_568582.validator(path, query, header, formData, body)
  let scheme = call_568582.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568582.url(scheme.get, call_568582.host, call_568582.base,
                         call_568582.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568582, url, valid)

proc call*(call_568583: Call_WcfrelaysDelete_568574; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          relayName: string): Recallable =
  ## wcfrelaysDelete
  ## Deletes a WCFRelays .
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name
  var path_568584 = newJObject()
  var query_568585 = newJObject()
  add(path_568584, "namespaceName", newJString(namespaceName))
  add(path_568584, "resourceGroupName", newJString(resourceGroupName))
  add(query_568585, "api-version", newJString(apiVersion))
  add(path_568584, "subscriptionId", newJString(subscriptionId))
  add(path_568584, "relayName", newJString(relayName))
  result = call_568583.call(path_568584, query_568585, nil, nil, nil)

var wcfrelaysDelete* = Call_WcfrelaysDelete_568574(name: "wcfrelaysDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}",
    validator: validate_WcfrelaysDelete_568575, base: "", url: url_WcfrelaysDelete_568576,
    schemes: {Scheme.Https})
type
  Call_WcfrelaysListPostAuthorizationRules_568598 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysListPostAuthorizationRules_568600(protocol: Scheme; host: string;
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

proc validate_WcfrelaysListPostAuthorizationRules_568599(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rules for a WCFRelays.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568601 = path.getOrDefault("namespaceName")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "namespaceName", valid_568601
  var valid_568602 = path.getOrDefault("resourceGroupName")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "resourceGroupName", valid_568602
  var valid_568603 = path.getOrDefault("subscriptionId")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "subscriptionId", valid_568603
  var valid_568604 = path.getOrDefault("relayName")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "relayName", valid_568604
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568605 = query.getOrDefault("api-version")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "api-version", valid_568605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568606: Call_WcfrelaysListPostAuthorizationRules_568598;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rules for a WCFRelays.
  ## 
  let valid = call_568606.validator(path, query, header, formData, body)
  let scheme = call_568606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568606.url(scheme.get, call_568606.host, call_568606.base,
                         call_568606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568606, url, valid)

proc call*(call_568607: Call_WcfrelaysListPostAuthorizationRules_568598;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; relayName: string): Recallable =
  ## wcfrelaysListPostAuthorizationRules
  ## Authorization rules for a WCFRelays.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name
  var path_568608 = newJObject()
  var query_568609 = newJObject()
  add(path_568608, "namespaceName", newJString(namespaceName))
  add(path_568608, "resourceGroupName", newJString(resourceGroupName))
  add(query_568609, "api-version", newJString(apiVersion))
  add(path_568608, "subscriptionId", newJString(subscriptionId))
  add(path_568608, "relayName", newJString(relayName))
  result = call_568607.call(path_568608, query_568609, nil, nil, nil)

var wcfrelaysListPostAuthorizationRules* = Call_WcfrelaysListPostAuthorizationRules_568598(
    name: "wcfrelaysListPostAuthorizationRules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}/authorizationRules",
    validator: validate_WcfrelaysListPostAuthorizationRules_568599, base: "",
    url: url_WcfrelaysListPostAuthorizationRules_568600, schemes: {Scheme.Https})
type
  Call_WcfrelaysListAuthorizationRules_568586 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysListAuthorizationRules_568588(protocol: Scheme; host: string;
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

proc validate_WcfrelaysListAuthorizationRules_568587(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rules for a WCFRelays.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568589 = path.getOrDefault("namespaceName")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "namespaceName", valid_568589
  var valid_568590 = path.getOrDefault("resourceGroupName")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "resourceGroupName", valid_568590
  var valid_568591 = path.getOrDefault("subscriptionId")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "subscriptionId", valid_568591
  var valid_568592 = path.getOrDefault("relayName")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "relayName", valid_568592
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568593 = query.getOrDefault("api-version")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "api-version", valid_568593
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568594: Call_WcfrelaysListAuthorizationRules_568586;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rules for a WCFRelays.
  ## 
  let valid = call_568594.validator(path, query, header, formData, body)
  let scheme = call_568594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568594.url(scheme.get, call_568594.host, call_568594.base,
                         call_568594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568594, url, valid)

proc call*(call_568595: Call_WcfrelaysListAuthorizationRules_568586;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; relayName: string): Recallable =
  ## wcfrelaysListAuthorizationRules
  ## Authorization rules for a WCFRelays.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name
  var path_568596 = newJObject()
  var query_568597 = newJObject()
  add(path_568596, "namespaceName", newJString(namespaceName))
  add(path_568596, "resourceGroupName", newJString(resourceGroupName))
  add(query_568597, "api-version", newJString(apiVersion))
  add(path_568596, "subscriptionId", newJString(subscriptionId))
  add(path_568596, "relayName", newJString(relayName))
  result = call_568595.call(path_568596, query_568597, nil, nil, nil)

var wcfrelaysListAuthorizationRules* = Call_WcfrelaysListAuthorizationRules_568586(
    name: "wcfrelaysListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}/authorizationRules",
    validator: validate_WcfrelaysListAuthorizationRules_568587, base: "",
    url: url_WcfrelaysListAuthorizationRules_568588, schemes: {Scheme.Https})
type
  Call_WcfrelaysCreateOrUpdateAuthorizationRule_568623 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysCreateOrUpdateAuthorizationRule_568625(protocol: Scheme;
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

proc validate_WcfrelaysCreateOrUpdateAuthorizationRule_568624(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates an authorization rule for a WCFRelays
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568626 = path.getOrDefault("namespaceName")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "namespaceName", valid_568626
  var valid_568627 = path.getOrDefault("resourceGroupName")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "resourceGroupName", valid_568627
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
  var valid_568630 = path.getOrDefault("relayName")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "relayName", valid_568630
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568631 = query.getOrDefault("api-version")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "api-version", valid_568631
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

proc call*(call_568633: Call_WcfrelaysCreateOrUpdateAuthorizationRule_568623;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or Updates an authorization rule for a WCFRelays
  ## 
  let valid = call_568633.validator(path, query, header, formData, body)
  let scheme = call_568633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568633.url(scheme.get, call_568633.host, call_568633.base,
                         call_568633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568633, url, valid)

proc call*(call_568634: Call_WcfrelaysCreateOrUpdateAuthorizationRule_568623;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; relayName: string;
          parameters: JsonNode): Recallable =
  ## wcfrelaysCreateOrUpdateAuthorizationRule
  ## Creates or Updates an authorization rule for a WCFRelays
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters.
  var path_568635 = newJObject()
  var query_568636 = newJObject()
  var body_568637 = newJObject()
  add(path_568635, "namespaceName", newJString(namespaceName))
  add(path_568635, "resourceGroupName", newJString(resourceGroupName))
  add(query_568636, "api-version", newJString(apiVersion))
  add(path_568635, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568635, "subscriptionId", newJString(subscriptionId))
  add(path_568635, "relayName", newJString(relayName))
  if parameters != nil:
    body_568637 = parameters
  result = call_568634.call(path_568635, query_568636, nil, nil, body_568637)

var wcfrelaysCreateOrUpdateAuthorizationRule* = Call_WcfrelaysCreateOrUpdateAuthorizationRule_568623(
    name: "wcfrelaysCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}/authorizationRules/{authorizationRuleName}",
    validator: validate_WcfrelaysCreateOrUpdateAuthorizationRule_568624, base: "",
    url: url_WcfrelaysCreateOrUpdateAuthorizationRule_568625,
    schemes: {Scheme.Https})
type
  Call_WcfrelaysPostAuthorizationRule_568638 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysPostAuthorizationRule_568640(protocol: Scheme; host: string;
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

proc validate_WcfrelaysPostAuthorizationRule_568639(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get authorizationRule for a WCFRelays by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568641 = path.getOrDefault("namespaceName")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "namespaceName", valid_568641
  var valid_568642 = path.getOrDefault("resourceGroupName")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "resourceGroupName", valid_568642
  var valid_568643 = path.getOrDefault("authorizationRuleName")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "authorizationRuleName", valid_568643
  var valid_568644 = path.getOrDefault("subscriptionId")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "subscriptionId", valid_568644
  var valid_568645 = path.getOrDefault("relayName")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "relayName", valid_568645
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568646 = query.getOrDefault("api-version")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "api-version", valid_568646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568647: Call_WcfrelaysPostAuthorizationRule_568638; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get authorizationRule for a WCFRelays by name.
  ## 
  let valid = call_568647.validator(path, query, header, formData, body)
  let scheme = call_568647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568647.url(scheme.get, call_568647.host, call_568647.base,
                         call_568647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568647, url, valid)

proc call*(call_568648: Call_WcfrelaysPostAuthorizationRule_568638;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; relayName: string): Recallable =
  ## wcfrelaysPostAuthorizationRule
  ## Get authorizationRule for a WCFRelays by name.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name
  var path_568649 = newJObject()
  var query_568650 = newJObject()
  add(path_568649, "namespaceName", newJString(namespaceName))
  add(path_568649, "resourceGroupName", newJString(resourceGroupName))
  add(query_568650, "api-version", newJString(apiVersion))
  add(path_568649, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568649, "subscriptionId", newJString(subscriptionId))
  add(path_568649, "relayName", newJString(relayName))
  result = call_568648.call(path_568649, query_568650, nil, nil, nil)

var wcfrelaysPostAuthorizationRule* = Call_WcfrelaysPostAuthorizationRule_568638(
    name: "wcfrelaysPostAuthorizationRule", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}/authorizationRules/{authorizationRuleName}",
    validator: validate_WcfrelaysPostAuthorizationRule_568639, base: "",
    url: url_WcfrelaysPostAuthorizationRule_568640, schemes: {Scheme.Https})
type
  Call_WcfrelaysGetAuthorizationRule_568610 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysGetAuthorizationRule_568612(protocol: Scheme; host: string;
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

proc validate_WcfrelaysGetAuthorizationRule_568611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get authorizationRule for a WCFRelays by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568613 = path.getOrDefault("namespaceName")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "namespaceName", valid_568613
  var valid_568614 = path.getOrDefault("resourceGroupName")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "resourceGroupName", valid_568614
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
  var valid_568617 = path.getOrDefault("relayName")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "relayName", valid_568617
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568618 = query.getOrDefault("api-version")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "api-version", valid_568618
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568619: Call_WcfrelaysGetAuthorizationRule_568610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get authorizationRule for a WCFRelays by name.
  ## 
  let valid = call_568619.validator(path, query, header, formData, body)
  let scheme = call_568619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568619.url(scheme.get, call_568619.host, call_568619.base,
                         call_568619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568619, url, valid)

proc call*(call_568620: Call_WcfrelaysGetAuthorizationRule_568610;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; relayName: string): Recallable =
  ## wcfrelaysGetAuthorizationRule
  ## Get authorizationRule for a WCFRelays by name.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name
  var path_568621 = newJObject()
  var query_568622 = newJObject()
  add(path_568621, "namespaceName", newJString(namespaceName))
  add(path_568621, "resourceGroupName", newJString(resourceGroupName))
  add(query_568622, "api-version", newJString(apiVersion))
  add(path_568621, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568621, "subscriptionId", newJString(subscriptionId))
  add(path_568621, "relayName", newJString(relayName))
  result = call_568620.call(path_568621, query_568622, nil, nil, nil)

var wcfrelaysGetAuthorizationRule* = Call_WcfrelaysGetAuthorizationRule_568610(
    name: "wcfrelaysGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}/authorizationRules/{authorizationRuleName}",
    validator: validate_WcfrelaysGetAuthorizationRule_568611, base: "",
    url: url_WcfrelaysGetAuthorizationRule_568612, schemes: {Scheme.Https})
type
  Call_WcfrelaysDeleteAuthorizationRule_568651 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysDeleteAuthorizationRule_568653(protocol: Scheme; host: string;
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

proc validate_WcfrelaysDeleteAuthorizationRule_568652(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a WCFRelays authorization rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name
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
  var valid_568656 = path.getOrDefault("authorizationRuleName")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "authorizationRuleName", valid_568656
  var valid_568657 = path.getOrDefault("subscriptionId")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "subscriptionId", valid_568657
  var valid_568658 = path.getOrDefault("relayName")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "relayName", valid_568658
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_568660: Call_WcfrelaysDeleteAuthorizationRule_568651;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a WCFRelays authorization rule
  ## 
  let valid = call_568660.validator(path, query, header, formData, body)
  let scheme = call_568660.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568660.url(scheme.get, call_568660.host, call_568660.base,
                         call_568660.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568660, url, valid)

proc call*(call_568661: Call_WcfrelaysDeleteAuthorizationRule_568651;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; relayName: string): Recallable =
  ## wcfrelaysDeleteAuthorizationRule
  ## Deletes a WCFRelays authorization rule
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name
  var path_568662 = newJObject()
  var query_568663 = newJObject()
  add(path_568662, "namespaceName", newJString(namespaceName))
  add(path_568662, "resourceGroupName", newJString(resourceGroupName))
  add(query_568663, "api-version", newJString(apiVersion))
  add(path_568662, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568662, "subscriptionId", newJString(subscriptionId))
  add(path_568662, "relayName", newJString(relayName))
  result = call_568661.call(path_568662, query_568663, nil, nil, nil)

var wcfrelaysDeleteAuthorizationRule* = Call_WcfrelaysDeleteAuthorizationRule_568651(
    name: "wcfrelaysDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}/authorizationRules/{authorizationRuleName}",
    validator: validate_WcfrelaysDeleteAuthorizationRule_568652, base: "",
    url: url_WcfrelaysDeleteAuthorizationRule_568653, schemes: {Scheme.Https})
type
  Call_WcfrelaysListKeys_568664 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysListKeys_568666(protocol: Scheme; host: string; base: string;
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

proc validate_WcfrelaysListKeys_568665(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Primary and Secondary ConnectionStrings to the WCFRelays.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name
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
  var valid_568669 = path.getOrDefault("authorizationRuleName")
  valid_568669 = validateParameter(valid_568669, JString, required = true,
                                 default = nil)
  if valid_568669 != nil:
    section.add "authorizationRuleName", valid_568669
  var valid_568670 = path.getOrDefault("subscriptionId")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "subscriptionId", valid_568670
  var valid_568671 = path.getOrDefault("relayName")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "relayName", valid_568671
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568673: Call_WcfrelaysListKeys_568664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Primary and Secondary ConnectionStrings to the WCFRelays.
  ## 
  let valid = call_568673.validator(path, query, header, formData, body)
  let scheme = call_568673.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568673.url(scheme.get, call_568673.host, call_568673.base,
                         call_568673.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568673, url, valid)

proc call*(call_568674: Call_WcfrelaysListKeys_568664; namespaceName: string;
          resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; relayName: string): Recallable =
  ## wcfrelaysListKeys
  ## Primary and Secondary ConnectionStrings to the WCFRelays.
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name
  var path_568675 = newJObject()
  var query_568676 = newJObject()
  add(path_568675, "namespaceName", newJString(namespaceName))
  add(path_568675, "resourceGroupName", newJString(resourceGroupName))
  add(query_568676, "api-version", newJString(apiVersion))
  add(path_568675, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568675, "subscriptionId", newJString(subscriptionId))
  add(path_568675, "relayName", newJString(relayName))
  result = call_568674.call(path_568675, query_568676, nil, nil, nil)

var wcfrelaysListKeys* = Call_WcfrelaysListKeys_568664(name: "wcfrelaysListKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}/authorizationRules/{authorizationRuleName}/ListKeys",
    validator: validate_WcfrelaysListKeys_568665, base: "",
    url: url_WcfrelaysListKeys_568666, schemes: {Scheme.Https})
type
  Call_WcfrelaysRegenerateKeys_568677 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysRegenerateKeys_568679(protocol: Scheme; host: string; base: string;
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

proc validate_WcfrelaysRegenerateKeys_568678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the Primary or Secondary ConnectionStrings to the WCFRelays
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568680 = path.getOrDefault("namespaceName")
  valid_568680 = validateParameter(valid_568680, JString, required = true,
                                 default = nil)
  if valid_568680 != nil:
    section.add "namespaceName", valid_568680
  var valid_568681 = path.getOrDefault("resourceGroupName")
  valid_568681 = validateParameter(valid_568681, JString, required = true,
                                 default = nil)
  if valid_568681 != nil:
    section.add "resourceGroupName", valid_568681
  var valid_568682 = path.getOrDefault("authorizationRuleName")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "authorizationRuleName", valid_568682
  var valid_568683 = path.getOrDefault("subscriptionId")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "subscriptionId", valid_568683
  var valid_568684 = path.getOrDefault("relayName")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "relayName", valid_568684
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568685 = query.getOrDefault("api-version")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "api-version", valid_568685
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

proc call*(call_568687: Call_WcfrelaysRegenerateKeys_568677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the Primary or Secondary ConnectionStrings to the WCFRelays
  ## 
  let valid = call_568687.validator(path, query, header, formData, body)
  let scheme = call_568687.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568687.url(scheme.get, call_568687.host, call_568687.base,
                         call_568687.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568687, url, valid)

proc call*(call_568688: Call_WcfrelaysRegenerateKeys_568677; namespaceName: string;
          resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; relayName: string;
          parameters: JsonNode): Recallable =
  ## wcfrelaysRegenerateKeys
  ## Regenerates the Primary or Secondary ConnectionStrings to the WCFRelays
  ##   namespaceName: string (required)
  ##                : The Namespace Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorizationRule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate Auth Rule.
  var path_568689 = newJObject()
  var query_568690 = newJObject()
  var body_568691 = newJObject()
  add(path_568689, "namespaceName", newJString(namespaceName))
  add(path_568689, "resourceGroupName", newJString(resourceGroupName))
  add(query_568690, "api-version", newJString(apiVersion))
  add(path_568689, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568689, "subscriptionId", newJString(subscriptionId))
  add(path_568689, "relayName", newJString(relayName))
  if parameters != nil:
    body_568691 = parameters
  result = call_568688.call(path_568689, query_568690, nil, nil, body_568691)

var wcfrelaysRegenerateKeys* = Call_WcfrelaysRegenerateKeys_568677(
    name: "wcfrelaysRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/WcfRelays/{relayName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_WcfrelaysRegenerateKeys_568678, base: "",
    url: url_WcfrelaysRegenerateKeys_568679, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
