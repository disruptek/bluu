
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  ## Lists all available Relay REST API operations.
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
  ## Lists all available Relay REST API operations.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
        value: "/providers/Microsoft.Relay/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCheckNameAvailability_568176(path: JsonNode;
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
  ##             : Parameters to check availability of the specified namespace name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568212: Call_NamespacesCheckNameAvailability_568175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the specified namespace name availability.
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
  ## Check the specified namespace name availability.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the specified namespace name.
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
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Relay/checkNameAvailability",
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesList_568218(path: JsonNode; query: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_NamespacesList_568217; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available namespaces within the subscription regardless of the resourceGroups.
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
  ## Lists all the available namespaces within the subscription regardless of the resourceGroups.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  add(query_568225, "api-version", newJString(apiVersion))
  add(path_568224, "subscriptionId", newJString(subscriptionId))
  result = call_568223.call(path_568224, query_568225, nil, nil, nil)

var namespacesList* = Call_NamespacesList_568217(name: "namespacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Relay/namespaces",
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
        kind: ConstantSegment, value: "/providers/Microsoft.Relay/namespaces")]
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
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client API version.
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
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  add(path_568234, "resourceGroupName", newJString(resourceGroupName))
  add(query_568235, "api-version", newJString(apiVersion))
  add(path_568234, "subscriptionId", newJString(subscriptionId))
  result = call_568233.call(path_568234, query_568235, nil, nil, nil)

var namespacesListByResourceGroup* = Call_NamespacesListByResourceGroup_568226(
    name: "namespacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces",
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
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a namespace resource.
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
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a namespace resource.
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
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client API version.
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
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
               (kind: ConstantSegment, value: "/authorizationRules")]
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
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client API version.
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
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568293 = newJObject()
  var query_568294 = newJObject()
  add(path_568293, "namespaceName", newJString(namespaceName))
  add(path_568293, "resourceGroupName", newJString(resourceGroupName))
  add(query_568294, "api-version", newJString(apiVersion))
  add(path_568293, "subscriptionId", newJString(subscriptionId))
  result = call_568292.call(path_568293, query_568294, nil, nil, nil)

var namespacesListAuthorizationRules* = Call_NamespacesListAuthorizationRules_568284(
    name: "namespacesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/authorizationRules",
    validator: validate_NamespacesListAuthorizationRules_568285, base: "",
    url: url_NamespacesListAuthorizationRules_568286, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateAuthorizationRule_568307 = ref object of OpenApiRestCall_567657
proc url_NamespacesCreateOrUpdateAuthorizationRule_568309(protocol: Scheme;
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

proc validate_NamespacesCreateOrUpdateAuthorizationRule_568308(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an authorization rule for a namespace.
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
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568310 = path.getOrDefault("namespaceName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "namespaceName", valid_568310
  var valid_568311 = path.getOrDefault("resourceGroupName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "resourceGroupName", valid_568311
  var valid_568312 = path.getOrDefault("authorizationRuleName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "authorizationRuleName", valid_568312
  var valid_568313 = path.getOrDefault("subscriptionId")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "subscriptionId", valid_568313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568314 = query.getOrDefault("api-version")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "api-version", valid_568314
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

proc call*(call_568316: Call_NamespacesCreateOrUpdateAuthorizationRule_568307;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an authorization rule for a namespace.
  ## 
  let valid = call_568316.validator(path, query, header, formData, body)
  let scheme = call_568316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568316.url(scheme.get, call_568316.host, call_568316.base,
                         call_568316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568316, url, valid)

proc call*(call_568317: Call_NamespacesCreateOrUpdateAuthorizationRule_568307;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateAuthorizationRule
  ## Creates or updates an authorization rule for a namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters.
  var path_568318 = newJObject()
  var query_568319 = newJObject()
  var body_568320 = newJObject()
  add(path_568318, "namespaceName", newJString(namespaceName))
  add(path_568318, "resourceGroupName", newJString(resourceGroupName))
  add(query_568319, "api-version", newJString(apiVersion))
  add(path_568318, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568318, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568320 = parameters
  result = call_568317.call(path_568318, query_568319, nil, nil, body_568320)

var namespacesCreateOrUpdateAuthorizationRule* = Call_NamespacesCreateOrUpdateAuthorizationRule_568307(
    name: "namespacesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/authorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesCreateOrUpdateAuthorizationRule_568308,
    base: "", url: url_NamespacesCreateOrUpdateAuthorizationRule_568309,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetAuthorizationRule_568295 = ref object of OpenApiRestCall_567657
proc url_NamespacesGetAuthorizationRule_568297(protocol: Scheme; host: string;
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

proc validate_NamespacesGetAuthorizationRule_568296(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rule for a namespace by name.
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
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  var valid_568300 = path.getOrDefault("authorizationRuleName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "authorizationRuleName", valid_568300
  var valid_568301 = path.getOrDefault("subscriptionId")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "subscriptionId", valid_568301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568302 = query.getOrDefault("api-version")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "api-version", valid_568302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568303: Call_NamespacesGetAuthorizationRule_568295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Authorization rule for a namespace by name.
  ## 
  let valid = call_568303.validator(path, query, header, formData, body)
  let scheme = call_568303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568303.url(scheme.get, call_568303.host, call_568303.base,
                         call_568303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568303, url, valid)

proc call*(call_568304: Call_NamespacesGetAuthorizationRule_568295;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesGetAuthorizationRule
  ## Authorization rule for a namespace by name.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568305 = newJObject()
  var query_568306 = newJObject()
  add(path_568305, "namespaceName", newJString(namespaceName))
  add(path_568305, "resourceGroupName", newJString(resourceGroupName))
  add(query_568306, "api-version", newJString(apiVersion))
  add(path_568305, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568305, "subscriptionId", newJString(subscriptionId))
  result = call_568304.call(path_568305, query_568306, nil, nil, nil)

var namespacesGetAuthorizationRule* = Call_NamespacesGetAuthorizationRule_568295(
    name: "namespacesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/authorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesGetAuthorizationRule_568296, base: "",
    url: url_NamespacesGetAuthorizationRule_568297, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteAuthorizationRule_568321 = ref object of OpenApiRestCall_567657
proc url_NamespacesDeleteAuthorizationRule_568323(protocol: Scheme; host: string;
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

proc validate_NamespacesDeleteAuthorizationRule_568322(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a namespace authorization rule.
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
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568324 = path.getOrDefault("namespaceName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "namespaceName", valid_568324
  var valid_568325 = path.getOrDefault("resourceGroupName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "resourceGroupName", valid_568325
  var valid_568326 = path.getOrDefault("authorizationRuleName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "authorizationRuleName", valid_568326
  var valid_568327 = path.getOrDefault("subscriptionId")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "subscriptionId", valid_568327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568328 = query.getOrDefault("api-version")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "api-version", valid_568328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568329: Call_NamespacesDeleteAuthorizationRule_568321;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a namespace authorization rule.
  ## 
  let valid = call_568329.validator(path, query, header, formData, body)
  let scheme = call_568329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568329.url(scheme.get, call_568329.host, call_568329.base,
                         call_568329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568329, url, valid)

proc call*(call_568330: Call_NamespacesDeleteAuthorizationRule_568321;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesDeleteAuthorizationRule
  ## Deletes a namespace authorization rule.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568331 = newJObject()
  var query_568332 = newJObject()
  add(path_568331, "namespaceName", newJString(namespaceName))
  add(path_568331, "resourceGroupName", newJString(resourceGroupName))
  add(query_568332, "api-version", newJString(apiVersion))
  add(path_568331, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568331, "subscriptionId", newJString(subscriptionId))
  result = call_568330.call(path_568331, query_568332, nil, nil, nil)

var namespacesDeleteAuthorizationRule* = Call_NamespacesDeleteAuthorizationRule_568321(
    name: "namespacesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/authorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesDeleteAuthorizationRule_568322, base: "",
    url: url_NamespacesDeleteAuthorizationRule_568323, schemes: {Scheme.Https})
type
  Call_NamespacesListKeys_568333 = ref object of OpenApiRestCall_567657
proc url_NamespacesListKeys_568335(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesListKeys_568334(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Primary and secondary connection strings to the namespace.
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
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568336 = path.getOrDefault("namespaceName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "namespaceName", valid_568336
  var valid_568337 = path.getOrDefault("resourceGroupName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "resourceGroupName", valid_568337
  var valid_568338 = path.getOrDefault("authorizationRuleName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "authorizationRuleName", valid_568338
  var valid_568339 = path.getOrDefault("subscriptionId")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "subscriptionId", valid_568339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568340 = query.getOrDefault("api-version")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "api-version", valid_568340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568341: Call_NamespacesListKeys_568333; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Primary and secondary connection strings to the namespace.
  ## 
  let valid = call_568341.validator(path, query, header, formData, body)
  let scheme = call_568341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568341.url(scheme.get, call_568341.host, call_568341.base,
                         call_568341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568341, url, valid)

proc call*(call_568342: Call_NamespacesListKeys_568333; namespaceName: string;
          resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesListKeys
  ## Primary and secondary connection strings to the namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568343 = newJObject()
  var query_568344 = newJObject()
  add(path_568343, "namespaceName", newJString(namespaceName))
  add(path_568343, "resourceGroupName", newJString(resourceGroupName))
  add(query_568344, "api-version", newJString(apiVersion))
  add(path_568343, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568343, "subscriptionId", newJString(subscriptionId))
  result = call_568342.call(path_568343, query_568344, nil, nil, nil)

var namespacesListKeys* = Call_NamespacesListKeys_568333(
    name: "namespacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/authorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_NamespacesListKeys_568334, base: "",
    url: url_NamespacesListKeys_568335, schemes: {Scheme.Https})
type
  Call_NamespacesRegenerateKeys_568345 = ref object of OpenApiRestCall_567657
proc url_NamespacesRegenerateKeys_568347(protocol: Scheme; host: string;
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

proc validate_NamespacesRegenerateKeys_568346(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary or secondary connection strings to the namespace.
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
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568348 = path.getOrDefault("namespaceName")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "namespaceName", valid_568348
  var valid_568349 = path.getOrDefault("resourceGroupName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "resourceGroupName", valid_568349
  var valid_568350 = path.getOrDefault("authorizationRuleName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "authorizationRuleName", valid_568350
  var valid_568351 = path.getOrDefault("subscriptionId")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "subscriptionId", valid_568351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568352 = query.getOrDefault("api-version")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "api-version", valid_568352
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

proc call*(call_568354: Call_NamespacesRegenerateKeys_568345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the primary or secondary connection strings to the namespace.
  ## 
  let valid = call_568354.validator(path, query, header, formData, body)
  let scheme = call_568354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568354.url(scheme.get, call_568354.host, call_568354.base,
                         call_568354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568354, url, valid)

proc call*(call_568355: Call_NamespacesRegenerateKeys_568345;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesRegenerateKeys
  ## Regenerates the primary or secondary connection strings to the namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate authorization rule.
  var path_568356 = newJObject()
  var query_568357 = newJObject()
  var body_568358 = newJObject()
  add(path_568356, "namespaceName", newJString(namespaceName))
  add(path_568356, "resourceGroupName", newJString(resourceGroupName))
  add(query_568357, "api-version", newJString(apiVersion))
  add(path_568356, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568356, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568358 = parameters
  result = call_568355.call(path_568356, query_568357, nil, nil, body_568358)

var namespacesRegenerateKeys* = Call_NamespacesRegenerateKeys_568345(
    name: "namespacesRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_NamespacesRegenerateKeys_568346, base: "",
    url: url_NamespacesRegenerateKeys_568347, schemes: {Scheme.Https})
type
  Call_HybridConnectionsListByNamespace_568359 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsListByNamespace_568361(protocol: Scheme; host: string;
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

proc validate_HybridConnectionsListByNamespace_568360(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the hybrid connection within the namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568362 = path.getOrDefault("namespaceName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "namespaceName", valid_568362
  var valid_568363 = path.getOrDefault("resourceGroupName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "resourceGroupName", valid_568363
  var valid_568364 = path.getOrDefault("subscriptionId")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "subscriptionId", valid_568364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568365 = query.getOrDefault("api-version")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "api-version", valid_568365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568366: Call_HybridConnectionsListByNamespace_568359;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the hybrid connection within the namespace.
  ## 
  let valid = call_568366.validator(path, query, header, formData, body)
  let scheme = call_568366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568366.url(scheme.get, call_568366.host, call_568366.base,
                         call_568366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568366, url, valid)

proc call*(call_568367: Call_HybridConnectionsListByNamespace_568359;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## hybridConnectionsListByNamespace
  ## Lists the hybrid connection within the namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568368 = newJObject()
  var query_568369 = newJObject()
  add(path_568368, "namespaceName", newJString(namespaceName))
  add(path_568368, "resourceGroupName", newJString(resourceGroupName))
  add(query_568369, "api-version", newJString(apiVersion))
  add(path_568368, "subscriptionId", newJString(subscriptionId))
  result = call_568367.call(path_568368, query_568369, nil, nil, nil)

var hybridConnectionsListByNamespace* = Call_HybridConnectionsListByNamespace_568359(
    name: "hybridConnectionsListByNamespace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections",
    validator: validate_HybridConnectionsListByNamespace_568360, base: "",
    url: url_HybridConnectionsListByNamespace_568361, schemes: {Scheme.Https})
type
  Call_HybridConnectionsCreateOrUpdate_568382 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsCreateOrUpdate_568384(protocol: Scheme; host: string;
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

proc validate_HybridConnectionsCreateOrUpdate_568383(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a service hybrid connection. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
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
  var valid_568398 = path.getOrDefault("hybridConnectionName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "hybridConnectionName", valid_568398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568399 = query.getOrDefault("api-version")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "api-version", valid_568399
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

proc call*(call_568401: Call_HybridConnectionsCreateOrUpdate_568382;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a service hybrid connection. This operation is idempotent.
  ## 
  let valid = call_568401.validator(path, query, header, formData, body)
  let scheme = call_568401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568401.url(scheme.get, call_568401.host, call_568401.base,
                         call_568401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568401, url, valid)

proc call*(call_568402: Call_HybridConnectionsCreateOrUpdate_568382;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; hybridConnectionName: string; parameters: JsonNode): Recallable =
  ## hybridConnectionsCreateOrUpdate
  ## Creates or updates a service hybrid connection. This operation is idempotent.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a hybrid connection.
  var path_568403 = newJObject()
  var query_568404 = newJObject()
  var body_568405 = newJObject()
  add(path_568403, "namespaceName", newJString(namespaceName))
  add(path_568403, "resourceGroupName", newJString(resourceGroupName))
  add(query_568404, "api-version", newJString(apiVersion))
  add(path_568403, "subscriptionId", newJString(subscriptionId))
  add(path_568403, "hybridConnectionName", newJString(hybridConnectionName))
  if parameters != nil:
    body_568405 = parameters
  result = call_568402.call(path_568403, query_568404, nil, nil, body_568405)

var hybridConnectionsCreateOrUpdate* = Call_HybridConnectionsCreateOrUpdate_568382(
    name: "hybridConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}",
    validator: validate_HybridConnectionsCreateOrUpdate_568383, base: "",
    url: url_HybridConnectionsCreateOrUpdate_568384, schemes: {Scheme.Https})
type
  Call_HybridConnectionsGet_568370 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsGet_568372(protocol: Scheme; host: string; base: string;
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

proc validate_HybridConnectionsGet_568371(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the description for the specified hybrid connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568373 = path.getOrDefault("namespaceName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "namespaceName", valid_568373
  var valid_568374 = path.getOrDefault("resourceGroupName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "resourceGroupName", valid_568374
  var valid_568375 = path.getOrDefault("subscriptionId")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "subscriptionId", valid_568375
  var valid_568376 = path.getOrDefault("hybridConnectionName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "hybridConnectionName", valid_568376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568377 = query.getOrDefault("api-version")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "api-version", valid_568377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568378: Call_HybridConnectionsGet_568370; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the description for the specified hybrid connection.
  ## 
  let valid = call_568378.validator(path, query, header, formData, body)
  let scheme = call_568378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568378.url(scheme.get, call_568378.host, call_568378.base,
                         call_568378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568378, url, valid)

proc call*(call_568379: Call_HybridConnectionsGet_568370; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          hybridConnectionName: string): Recallable =
  ## hybridConnectionsGet
  ## Returns the description for the specified hybrid connection.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  var path_568380 = newJObject()
  var query_568381 = newJObject()
  add(path_568380, "namespaceName", newJString(namespaceName))
  add(path_568380, "resourceGroupName", newJString(resourceGroupName))
  add(query_568381, "api-version", newJString(apiVersion))
  add(path_568380, "subscriptionId", newJString(subscriptionId))
  add(path_568380, "hybridConnectionName", newJString(hybridConnectionName))
  result = call_568379.call(path_568380, query_568381, nil, nil, nil)

var hybridConnectionsGet* = Call_HybridConnectionsGet_568370(
    name: "hybridConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}",
    validator: validate_HybridConnectionsGet_568371, base: "",
    url: url_HybridConnectionsGet_568372, schemes: {Scheme.Https})
type
  Call_HybridConnectionsDelete_568406 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsDelete_568408(protocol: Scheme; host: string; base: string;
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

proc validate_HybridConnectionsDelete_568407(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a hybrid connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568409 = path.getOrDefault("namespaceName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "namespaceName", valid_568409
  var valid_568410 = path.getOrDefault("resourceGroupName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "resourceGroupName", valid_568410
  var valid_568411 = path.getOrDefault("subscriptionId")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "subscriptionId", valid_568411
  var valid_568412 = path.getOrDefault("hybridConnectionName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "hybridConnectionName", valid_568412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568413 = query.getOrDefault("api-version")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "api-version", valid_568413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568414: Call_HybridConnectionsDelete_568406; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a hybrid connection.
  ## 
  let valid = call_568414.validator(path, query, header, formData, body)
  let scheme = call_568414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568414.url(scheme.get, call_568414.host, call_568414.base,
                         call_568414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568414, url, valid)

proc call*(call_568415: Call_HybridConnectionsDelete_568406; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          hybridConnectionName: string): Recallable =
  ## hybridConnectionsDelete
  ## Deletes a hybrid connection.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  var path_568416 = newJObject()
  var query_568417 = newJObject()
  add(path_568416, "namespaceName", newJString(namespaceName))
  add(path_568416, "resourceGroupName", newJString(resourceGroupName))
  add(query_568417, "api-version", newJString(apiVersion))
  add(path_568416, "subscriptionId", newJString(subscriptionId))
  add(path_568416, "hybridConnectionName", newJString(hybridConnectionName))
  result = call_568415.call(path_568416, query_568417, nil, nil, nil)

var hybridConnectionsDelete* = Call_HybridConnectionsDelete_568406(
    name: "hybridConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}",
    validator: validate_HybridConnectionsDelete_568407, base: "",
    url: url_HybridConnectionsDelete_568408, schemes: {Scheme.Https})
type
  Call_HybridConnectionsListAuthorizationRules_568418 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsListAuthorizationRules_568420(protocol: Scheme;
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

proc validate_HybridConnectionsListAuthorizationRules_568419(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rules for a hybrid connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568421 = path.getOrDefault("namespaceName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "namespaceName", valid_568421
  var valid_568422 = path.getOrDefault("resourceGroupName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "resourceGroupName", valid_568422
  var valid_568423 = path.getOrDefault("subscriptionId")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "subscriptionId", valid_568423
  var valid_568424 = path.getOrDefault("hybridConnectionName")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "hybridConnectionName", valid_568424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568425 = query.getOrDefault("api-version")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "api-version", valid_568425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568426: Call_HybridConnectionsListAuthorizationRules_568418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rules for a hybrid connection.
  ## 
  let valid = call_568426.validator(path, query, header, formData, body)
  let scheme = call_568426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568426.url(scheme.get, call_568426.host, call_568426.base,
                         call_568426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568426, url, valid)

proc call*(call_568427: Call_HybridConnectionsListAuthorizationRules_568418;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; hybridConnectionName: string): Recallable =
  ## hybridConnectionsListAuthorizationRules
  ## Authorization rules for a hybrid connection.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  var path_568428 = newJObject()
  var query_568429 = newJObject()
  add(path_568428, "namespaceName", newJString(namespaceName))
  add(path_568428, "resourceGroupName", newJString(resourceGroupName))
  add(query_568429, "api-version", newJString(apiVersion))
  add(path_568428, "subscriptionId", newJString(subscriptionId))
  add(path_568428, "hybridConnectionName", newJString(hybridConnectionName))
  result = call_568427.call(path_568428, query_568429, nil, nil, nil)

var hybridConnectionsListAuthorizationRules* = Call_HybridConnectionsListAuthorizationRules_568418(
    name: "hybridConnectionsListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}/authorizationRules",
    validator: validate_HybridConnectionsListAuthorizationRules_568419, base: "",
    url: url_HybridConnectionsListAuthorizationRules_568420,
    schemes: {Scheme.Https})
type
  Call_HybridConnectionsCreateOrUpdateAuthorizationRule_568443 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsCreateOrUpdateAuthorizationRule_568445(
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

proc validate_HybridConnectionsCreateOrUpdateAuthorizationRule_568444(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates an authorization rule for a hybrid connection.
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
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  var valid_568448 = path.getOrDefault("authorizationRuleName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "authorizationRuleName", valid_568448
  var valid_568449 = path.getOrDefault("subscriptionId")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "subscriptionId", valid_568449
  var valid_568450 = path.getOrDefault("hybridConnectionName")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "hybridConnectionName", valid_568450
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568451 = query.getOrDefault("api-version")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "api-version", valid_568451
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

proc call*(call_568453: Call_HybridConnectionsCreateOrUpdateAuthorizationRule_568443;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an authorization rule for a hybrid connection.
  ## 
  let valid = call_568453.validator(path, query, header, formData, body)
  let scheme = call_568453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568453.url(scheme.get, call_568453.host, call_568453.base,
                         call_568453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568453, url, valid)

proc call*(call_568454: Call_HybridConnectionsCreateOrUpdateAuthorizationRule_568443;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          hybridConnectionName: string; parameters: JsonNode): Recallable =
  ## hybridConnectionsCreateOrUpdateAuthorizationRule
  ## Creates or updates an authorization rule for a hybrid connection.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters.
  var path_568455 = newJObject()
  var query_568456 = newJObject()
  var body_568457 = newJObject()
  add(path_568455, "namespaceName", newJString(namespaceName))
  add(path_568455, "resourceGroupName", newJString(resourceGroupName))
  add(query_568456, "api-version", newJString(apiVersion))
  add(path_568455, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568455, "subscriptionId", newJString(subscriptionId))
  add(path_568455, "hybridConnectionName", newJString(hybridConnectionName))
  if parameters != nil:
    body_568457 = parameters
  result = call_568454.call(path_568455, query_568456, nil, nil, body_568457)

var hybridConnectionsCreateOrUpdateAuthorizationRule* = Call_HybridConnectionsCreateOrUpdateAuthorizationRule_568443(
    name: "hybridConnectionsCreateOrUpdateAuthorizationRule",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}",
    validator: validate_HybridConnectionsCreateOrUpdateAuthorizationRule_568444,
    base: "", url: url_HybridConnectionsCreateOrUpdateAuthorizationRule_568445,
    schemes: {Scheme.Https})
type
  Call_HybridConnectionsGetAuthorizationRule_568430 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsGetAuthorizationRule_568432(protocol: Scheme;
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

proc validate_HybridConnectionsGetAuthorizationRule_568431(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Hybrid connection authorization rule for a hybrid connection by name.
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
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
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
  var valid_568435 = path.getOrDefault("authorizationRuleName")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "authorizationRuleName", valid_568435
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
  ##              : Client API version.
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

proc call*(call_568439: Call_HybridConnectionsGetAuthorizationRule_568430;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Hybrid connection authorization rule for a hybrid connection by name.
  ## 
  let valid = call_568439.validator(path, query, header, formData, body)
  let scheme = call_568439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568439.url(scheme.get, call_568439.host, call_568439.base,
                         call_568439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568439, url, valid)

proc call*(call_568440: Call_HybridConnectionsGetAuthorizationRule_568430;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          hybridConnectionName: string): Recallable =
  ## hybridConnectionsGetAuthorizationRule
  ## Hybrid connection authorization rule for a hybrid connection by name.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  var path_568441 = newJObject()
  var query_568442 = newJObject()
  add(path_568441, "namespaceName", newJString(namespaceName))
  add(path_568441, "resourceGroupName", newJString(resourceGroupName))
  add(query_568442, "api-version", newJString(apiVersion))
  add(path_568441, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568441, "subscriptionId", newJString(subscriptionId))
  add(path_568441, "hybridConnectionName", newJString(hybridConnectionName))
  result = call_568440.call(path_568441, query_568442, nil, nil, nil)

var hybridConnectionsGetAuthorizationRule* = Call_HybridConnectionsGetAuthorizationRule_568430(
    name: "hybridConnectionsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}",
    validator: validate_HybridConnectionsGetAuthorizationRule_568431, base: "",
    url: url_HybridConnectionsGetAuthorizationRule_568432, schemes: {Scheme.Https})
type
  Call_HybridConnectionsDeleteAuthorizationRule_568458 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsDeleteAuthorizationRule_568460(protocol: Scheme;
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

proc validate_HybridConnectionsDeleteAuthorizationRule_568459(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a hybrid connection authorization rule.
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
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568461 = path.getOrDefault("namespaceName")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "namespaceName", valid_568461
  var valid_568462 = path.getOrDefault("resourceGroupName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "resourceGroupName", valid_568462
  var valid_568463 = path.getOrDefault("authorizationRuleName")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "authorizationRuleName", valid_568463
  var valid_568464 = path.getOrDefault("subscriptionId")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "subscriptionId", valid_568464
  var valid_568465 = path.getOrDefault("hybridConnectionName")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "hybridConnectionName", valid_568465
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568466 = query.getOrDefault("api-version")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "api-version", valid_568466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568467: Call_HybridConnectionsDeleteAuthorizationRule_568458;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a hybrid connection authorization rule.
  ## 
  let valid = call_568467.validator(path, query, header, formData, body)
  let scheme = call_568467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568467.url(scheme.get, call_568467.host, call_568467.base,
                         call_568467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568467, url, valid)

proc call*(call_568468: Call_HybridConnectionsDeleteAuthorizationRule_568458;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          hybridConnectionName: string): Recallable =
  ## hybridConnectionsDeleteAuthorizationRule
  ## Deletes a hybrid connection authorization rule.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  var path_568469 = newJObject()
  var query_568470 = newJObject()
  add(path_568469, "namespaceName", newJString(namespaceName))
  add(path_568469, "resourceGroupName", newJString(resourceGroupName))
  add(query_568470, "api-version", newJString(apiVersion))
  add(path_568469, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568469, "subscriptionId", newJString(subscriptionId))
  add(path_568469, "hybridConnectionName", newJString(hybridConnectionName))
  result = call_568468.call(path_568469, query_568470, nil, nil, nil)

var hybridConnectionsDeleteAuthorizationRule* = Call_HybridConnectionsDeleteAuthorizationRule_568458(
    name: "hybridConnectionsDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}",
    validator: validate_HybridConnectionsDeleteAuthorizationRule_568459, base: "",
    url: url_HybridConnectionsDeleteAuthorizationRule_568460,
    schemes: {Scheme.Https})
type
  Call_HybridConnectionsListKeys_568471 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsListKeys_568473(protocol: Scheme; host: string;
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

proc validate_HybridConnectionsListKeys_568472(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Primary and secondary connection strings to the hybrid connection.
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
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568474 = path.getOrDefault("namespaceName")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "namespaceName", valid_568474
  var valid_568475 = path.getOrDefault("resourceGroupName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "resourceGroupName", valid_568475
  var valid_568476 = path.getOrDefault("authorizationRuleName")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "authorizationRuleName", valid_568476
  var valid_568477 = path.getOrDefault("subscriptionId")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "subscriptionId", valid_568477
  var valid_568478 = path.getOrDefault("hybridConnectionName")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "hybridConnectionName", valid_568478
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568479 = query.getOrDefault("api-version")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "api-version", valid_568479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568480: Call_HybridConnectionsListKeys_568471; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Primary and secondary connection strings to the hybrid connection.
  ## 
  let valid = call_568480.validator(path, query, header, formData, body)
  let scheme = call_568480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568480.url(scheme.get, call_568480.host, call_568480.base,
                         call_568480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568480, url, valid)

proc call*(call_568481: Call_HybridConnectionsListKeys_568471;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          hybridConnectionName: string): Recallable =
  ## hybridConnectionsListKeys
  ## Primary and secondary connection strings to the hybrid connection.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  var path_568482 = newJObject()
  var query_568483 = newJObject()
  add(path_568482, "namespaceName", newJString(namespaceName))
  add(path_568482, "resourceGroupName", newJString(resourceGroupName))
  add(query_568483, "api-version", newJString(apiVersion))
  add(path_568482, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568482, "subscriptionId", newJString(subscriptionId))
  add(path_568482, "hybridConnectionName", newJString(hybridConnectionName))
  result = call_568481.call(path_568482, query_568483, nil, nil, nil)

var hybridConnectionsListKeys* = Call_HybridConnectionsListKeys_568471(
    name: "hybridConnectionsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_HybridConnectionsListKeys_568472, base: "",
    url: url_HybridConnectionsListKeys_568473, schemes: {Scheme.Https})
type
  Call_HybridConnectionsRegenerateKeys_568484 = ref object of OpenApiRestCall_567657
proc url_HybridConnectionsRegenerateKeys_568486(protocol: Scheme; host: string;
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

proc validate_HybridConnectionsRegenerateKeys_568485(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary or secondary connection strings to the hybrid connection.
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
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: JString (required)
  ##                       : The hybrid connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568487 = path.getOrDefault("namespaceName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "namespaceName", valid_568487
  var valid_568488 = path.getOrDefault("resourceGroupName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "resourceGroupName", valid_568488
  var valid_568489 = path.getOrDefault("authorizationRuleName")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "authorizationRuleName", valid_568489
  var valid_568490 = path.getOrDefault("subscriptionId")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "subscriptionId", valid_568490
  var valid_568491 = path.getOrDefault("hybridConnectionName")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "hybridConnectionName", valid_568491
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568492 = query.getOrDefault("api-version")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "api-version", valid_568492
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

proc call*(call_568494: Call_HybridConnectionsRegenerateKeys_568484;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the primary or secondary connection strings to the hybrid connection.
  ## 
  let valid = call_568494.validator(path, query, header, formData, body)
  let scheme = call_568494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568494.url(scheme.get, call_568494.host, call_568494.base,
                         call_568494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568494, url, valid)

proc call*(call_568495: Call_HybridConnectionsRegenerateKeys_568484;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          hybridConnectionName: string; parameters: JsonNode): Recallable =
  ## hybridConnectionsRegenerateKeys
  ## Regenerates the primary or secondary connection strings to the hybrid connection.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridConnectionName: string (required)
  ##                       : The hybrid connection name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate authorization rule.
  var path_568496 = newJObject()
  var query_568497 = newJObject()
  var body_568498 = newJObject()
  add(path_568496, "namespaceName", newJString(namespaceName))
  add(path_568496, "resourceGroupName", newJString(resourceGroupName))
  add(query_568497, "api-version", newJString(apiVersion))
  add(path_568496, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568496, "subscriptionId", newJString(subscriptionId))
  add(path_568496, "hybridConnectionName", newJString(hybridConnectionName))
  if parameters != nil:
    body_568498 = parameters
  result = call_568495.call(path_568496, query_568497, nil, nil, body_568498)

var hybridConnectionsRegenerateKeys* = Call_HybridConnectionsRegenerateKeys_568484(
    name: "hybridConnectionsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/hybridConnections/{hybridConnectionName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_HybridConnectionsRegenerateKeys_568485, base: "",
    url: url_HybridConnectionsRegenerateKeys_568486, schemes: {Scheme.Https})
type
  Call_WcfrelaysListByNamespace_568499 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysListByNamespace_568501(protocol: Scheme; host: string;
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

proc validate_WcfrelaysListByNamespace_568500(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the WCF relays within the namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568505 = query.getOrDefault("api-version")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "api-version", valid_568505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568506: Call_WcfrelaysListByNamespace_568499; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the WCF relays within the namespace.
  ## 
  let valid = call_568506.validator(path, query, header, formData, body)
  let scheme = call_568506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568506.url(scheme.get, call_568506.host, call_568506.base,
                         call_568506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568506, url, valid)

proc call*(call_568507: Call_WcfrelaysListByNamespace_568499;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## wcfrelaysListByNamespace
  ## Lists the WCF relays within the namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568508 = newJObject()
  var query_568509 = newJObject()
  add(path_568508, "namespaceName", newJString(namespaceName))
  add(path_568508, "resourceGroupName", newJString(resourceGroupName))
  add(query_568509, "api-version", newJString(apiVersion))
  add(path_568508, "subscriptionId", newJString(subscriptionId))
  result = call_568507.call(path_568508, query_568509, nil, nil, nil)

var wcfrelaysListByNamespace* = Call_WcfrelaysListByNamespace_568499(
    name: "wcfrelaysListByNamespace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays",
    validator: validate_WcfrelaysListByNamespace_568500, base: "",
    url: url_WcfrelaysListByNamespace_568501, schemes: {Scheme.Https})
type
  Call_WcfrelaysCreateOrUpdate_568522 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysCreateOrUpdate_568524(protocol: Scheme; host: string; base: string;
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

proc validate_WcfrelaysCreateOrUpdate_568523(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a WCF relay. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name.
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
  var valid_568528 = path.getOrDefault("relayName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "relayName", valid_568528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568529 = query.getOrDefault("api-version")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "api-version", valid_568529
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

proc call*(call_568531: Call_WcfrelaysCreateOrUpdate_568522; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a WCF relay. This operation is idempotent.
  ## 
  let valid = call_568531.validator(path, query, header, formData, body)
  let scheme = call_568531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568531.url(scheme.get, call_568531.host, call_568531.base,
                         call_568531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568531, url, valid)

proc call*(call_568532: Call_WcfrelaysCreateOrUpdate_568522; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          relayName: string; parameters: JsonNode): Recallable =
  ## wcfrelaysCreateOrUpdate
  ## Creates or updates a WCF relay. This operation is idempotent.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a WCF relay.
  var path_568533 = newJObject()
  var query_568534 = newJObject()
  var body_568535 = newJObject()
  add(path_568533, "namespaceName", newJString(namespaceName))
  add(path_568533, "resourceGroupName", newJString(resourceGroupName))
  add(query_568534, "api-version", newJString(apiVersion))
  add(path_568533, "subscriptionId", newJString(subscriptionId))
  add(path_568533, "relayName", newJString(relayName))
  if parameters != nil:
    body_568535 = parameters
  result = call_568532.call(path_568533, query_568534, nil, nil, body_568535)

var wcfrelaysCreateOrUpdate* = Call_WcfrelaysCreateOrUpdate_568522(
    name: "wcfrelaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}",
    validator: validate_WcfrelaysCreateOrUpdate_568523, base: "",
    url: url_WcfrelaysCreateOrUpdate_568524, schemes: {Scheme.Https})
type
  Call_WcfrelaysGet_568510 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysGet_568512(protocol: Scheme; host: string; base: string;
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

proc validate_WcfrelaysGet_568511(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the description for the specified WCF relay.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568513 = path.getOrDefault("namespaceName")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "namespaceName", valid_568513
  var valid_568514 = path.getOrDefault("resourceGroupName")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "resourceGroupName", valid_568514
  var valid_568515 = path.getOrDefault("subscriptionId")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "subscriptionId", valid_568515
  var valid_568516 = path.getOrDefault("relayName")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "relayName", valid_568516
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

proc call*(call_568518: Call_WcfrelaysGet_568510; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the description for the specified WCF relay.
  ## 
  let valid = call_568518.validator(path, query, header, formData, body)
  let scheme = call_568518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568518.url(scheme.get, call_568518.host, call_568518.base,
                         call_568518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568518, url, valid)

proc call*(call_568519: Call_WcfrelaysGet_568510; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          relayName: string): Recallable =
  ## wcfrelaysGet
  ## Returns the description for the specified WCF relay.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name.
  var path_568520 = newJObject()
  var query_568521 = newJObject()
  add(path_568520, "namespaceName", newJString(namespaceName))
  add(path_568520, "resourceGroupName", newJString(resourceGroupName))
  add(query_568521, "api-version", newJString(apiVersion))
  add(path_568520, "subscriptionId", newJString(subscriptionId))
  add(path_568520, "relayName", newJString(relayName))
  result = call_568519.call(path_568520, query_568521, nil, nil, nil)

var wcfrelaysGet* = Call_WcfrelaysGet_568510(name: "wcfrelaysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}",
    validator: validate_WcfrelaysGet_568511, base: "", url: url_WcfrelaysGet_568512,
    schemes: {Scheme.Https})
type
  Call_WcfrelaysDelete_568536 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysDelete_568538(protocol: Scheme; host: string; base: string;
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

proc validate_WcfrelaysDelete_568537(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a WCF relay.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568539 = path.getOrDefault("namespaceName")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "namespaceName", valid_568539
  var valid_568540 = path.getOrDefault("resourceGroupName")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "resourceGroupName", valid_568540
  var valid_568541 = path.getOrDefault("subscriptionId")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "subscriptionId", valid_568541
  var valid_568542 = path.getOrDefault("relayName")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "relayName", valid_568542
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_568544: Call_WcfrelaysDelete_568536; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a WCF relay.
  ## 
  let valid = call_568544.validator(path, query, header, formData, body)
  let scheme = call_568544.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568544.url(scheme.get, call_568544.host, call_568544.base,
                         call_568544.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568544, url, valid)

proc call*(call_568545: Call_WcfrelaysDelete_568536; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          relayName: string): Recallable =
  ## wcfrelaysDelete
  ## Deletes a WCF relay.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name.
  var path_568546 = newJObject()
  var query_568547 = newJObject()
  add(path_568546, "namespaceName", newJString(namespaceName))
  add(path_568546, "resourceGroupName", newJString(resourceGroupName))
  add(query_568547, "api-version", newJString(apiVersion))
  add(path_568546, "subscriptionId", newJString(subscriptionId))
  add(path_568546, "relayName", newJString(relayName))
  result = call_568545.call(path_568546, query_568547, nil, nil, nil)

var wcfrelaysDelete* = Call_WcfrelaysDelete_568536(name: "wcfrelaysDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}",
    validator: validate_WcfrelaysDelete_568537, base: "", url: url_WcfrelaysDelete_568538,
    schemes: {Scheme.Https})
type
  Call_WcfrelaysListAuthorizationRules_568548 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysListAuthorizationRules_568550(protocol: Scheme; host: string;
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

proc validate_WcfrelaysListAuthorizationRules_568549(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Authorization rules for a WCF relay.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name.
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
  ##              : Client API version.
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

proc call*(call_568556: Call_WcfrelaysListAuthorizationRules_568548;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorization rules for a WCF relay.
  ## 
  let valid = call_568556.validator(path, query, header, formData, body)
  let scheme = call_568556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568556.url(scheme.get, call_568556.host, call_568556.base,
                         call_568556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568556, url, valid)

proc call*(call_568557: Call_WcfrelaysListAuthorizationRules_568548;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; relayName: string): Recallable =
  ## wcfrelaysListAuthorizationRules
  ## Authorization rules for a WCF relay.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name.
  var path_568558 = newJObject()
  var query_568559 = newJObject()
  add(path_568558, "namespaceName", newJString(namespaceName))
  add(path_568558, "resourceGroupName", newJString(resourceGroupName))
  add(query_568559, "api-version", newJString(apiVersion))
  add(path_568558, "subscriptionId", newJString(subscriptionId))
  add(path_568558, "relayName", newJString(relayName))
  result = call_568557.call(path_568558, query_568559, nil, nil, nil)

var wcfrelaysListAuthorizationRules* = Call_WcfrelaysListAuthorizationRules_568548(
    name: "wcfrelaysListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}/authorizationRules",
    validator: validate_WcfrelaysListAuthorizationRules_568549, base: "",
    url: url_WcfrelaysListAuthorizationRules_568550, schemes: {Scheme.Https})
type
  Call_WcfrelaysCreateOrUpdateAuthorizationRule_568573 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysCreateOrUpdateAuthorizationRule_568575(protocol: Scheme;
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

proc validate_WcfrelaysCreateOrUpdateAuthorizationRule_568574(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an authorization rule for a WCF relay.
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
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568576 = path.getOrDefault("namespaceName")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "namespaceName", valid_568576
  var valid_568577 = path.getOrDefault("resourceGroupName")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "resourceGroupName", valid_568577
  var valid_568578 = path.getOrDefault("authorizationRuleName")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "authorizationRuleName", valid_568578
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
  ##              : Client API version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568583: Call_WcfrelaysCreateOrUpdateAuthorizationRule_568573;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an authorization rule for a WCF relay.
  ## 
  let valid = call_568583.validator(path, query, header, formData, body)
  let scheme = call_568583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568583.url(scheme.get, call_568583.host, call_568583.base,
                         call_568583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568583, url, valid)

proc call*(call_568584: Call_WcfrelaysCreateOrUpdateAuthorizationRule_568573;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; relayName: string;
          parameters: JsonNode): Recallable =
  ## wcfrelaysCreateOrUpdateAuthorizationRule
  ## Creates or updates an authorization rule for a WCF relay.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name.
  ##   parameters: JObject (required)
  ##             : The authorization rule parameters.
  var path_568585 = newJObject()
  var query_568586 = newJObject()
  var body_568587 = newJObject()
  add(path_568585, "namespaceName", newJString(namespaceName))
  add(path_568585, "resourceGroupName", newJString(resourceGroupName))
  add(query_568586, "api-version", newJString(apiVersion))
  add(path_568585, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568585, "subscriptionId", newJString(subscriptionId))
  add(path_568585, "relayName", newJString(relayName))
  if parameters != nil:
    body_568587 = parameters
  result = call_568584.call(path_568585, query_568586, nil, nil, body_568587)

var wcfrelaysCreateOrUpdateAuthorizationRule* = Call_WcfrelaysCreateOrUpdateAuthorizationRule_568573(
    name: "wcfrelaysCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}/authorizationRules/{authorizationRuleName}",
    validator: validate_WcfrelaysCreateOrUpdateAuthorizationRule_568574, base: "",
    url: url_WcfrelaysCreateOrUpdateAuthorizationRule_568575,
    schemes: {Scheme.Https})
type
  Call_WcfrelaysGetAuthorizationRule_568560 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysGetAuthorizationRule_568562(protocol: Scheme; host: string;
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

proc validate_WcfrelaysGetAuthorizationRule_568561(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get authorizationRule for a WCF relay by name.
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
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name.
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
  var valid_568565 = path.getOrDefault("authorizationRuleName")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "authorizationRuleName", valid_568565
  var valid_568566 = path.getOrDefault("subscriptionId")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "subscriptionId", valid_568566
  var valid_568567 = path.getOrDefault("relayName")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "relayName", valid_568567
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568568 = query.getOrDefault("api-version")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "api-version", valid_568568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568569: Call_WcfrelaysGetAuthorizationRule_568560; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get authorizationRule for a WCF relay by name.
  ## 
  let valid = call_568569.validator(path, query, header, formData, body)
  let scheme = call_568569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568569.url(scheme.get, call_568569.host, call_568569.base,
                         call_568569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568569, url, valid)

proc call*(call_568570: Call_WcfrelaysGetAuthorizationRule_568560;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; relayName: string): Recallable =
  ## wcfrelaysGetAuthorizationRule
  ## Get authorizationRule for a WCF relay by name.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name.
  var path_568571 = newJObject()
  var query_568572 = newJObject()
  add(path_568571, "namespaceName", newJString(namespaceName))
  add(path_568571, "resourceGroupName", newJString(resourceGroupName))
  add(query_568572, "api-version", newJString(apiVersion))
  add(path_568571, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568571, "subscriptionId", newJString(subscriptionId))
  add(path_568571, "relayName", newJString(relayName))
  result = call_568570.call(path_568571, query_568572, nil, nil, nil)

var wcfrelaysGetAuthorizationRule* = Call_WcfrelaysGetAuthorizationRule_568560(
    name: "wcfrelaysGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}/authorizationRules/{authorizationRuleName}",
    validator: validate_WcfrelaysGetAuthorizationRule_568561, base: "",
    url: url_WcfrelaysGetAuthorizationRule_568562, schemes: {Scheme.Https})
type
  Call_WcfrelaysDeleteAuthorizationRule_568588 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysDeleteAuthorizationRule_568590(protocol: Scheme; host: string;
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

proc validate_WcfrelaysDeleteAuthorizationRule_568589(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a WCF relay authorization rule.
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
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568591 = path.getOrDefault("namespaceName")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "namespaceName", valid_568591
  var valid_568592 = path.getOrDefault("resourceGroupName")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "resourceGroupName", valid_568592
  var valid_568593 = path.getOrDefault("authorizationRuleName")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "authorizationRuleName", valid_568593
  var valid_568594 = path.getOrDefault("subscriptionId")
  valid_568594 = validateParameter(valid_568594, JString, required = true,
                                 default = nil)
  if valid_568594 != nil:
    section.add "subscriptionId", valid_568594
  var valid_568595 = path.getOrDefault("relayName")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = nil)
  if valid_568595 != nil:
    section.add "relayName", valid_568595
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568596 = query.getOrDefault("api-version")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "api-version", valid_568596
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568597: Call_WcfrelaysDeleteAuthorizationRule_568588;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a WCF relay authorization rule.
  ## 
  let valid = call_568597.validator(path, query, header, formData, body)
  let scheme = call_568597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568597.url(scheme.get, call_568597.host, call_568597.base,
                         call_568597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568597, url, valid)

proc call*(call_568598: Call_WcfrelaysDeleteAuthorizationRule_568588;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; relayName: string): Recallable =
  ## wcfrelaysDeleteAuthorizationRule
  ## Deletes a WCF relay authorization rule.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name.
  var path_568599 = newJObject()
  var query_568600 = newJObject()
  add(path_568599, "namespaceName", newJString(namespaceName))
  add(path_568599, "resourceGroupName", newJString(resourceGroupName))
  add(query_568600, "api-version", newJString(apiVersion))
  add(path_568599, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568599, "subscriptionId", newJString(subscriptionId))
  add(path_568599, "relayName", newJString(relayName))
  result = call_568598.call(path_568599, query_568600, nil, nil, nil)

var wcfrelaysDeleteAuthorizationRule* = Call_WcfrelaysDeleteAuthorizationRule_568588(
    name: "wcfrelaysDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}/authorizationRules/{authorizationRuleName}",
    validator: validate_WcfrelaysDeleteAuthorizationRule_568589, base: "",
    url: url_WcfrelaysDeleteAuthorizationRule_568590, schemes: {Scheme.Https})
type
  Call_WcfrelaysListKeys_568601 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysListKeys_568603(protocol: Scheme; host: string; base: string;
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

proc validate_WcfrelaysListKeys_568602(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Primary and secondary connection strings to the WCF relay.
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
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568604 = path.getOrDefault("namespaceName")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "namespaceName", valid_568604
  var valid_568605 = path.getOrDefault("resourceGroupName")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "resourceGroupName", valid_568605
  var valid_568606 = path.getOrDefault("authorizationRuleName")
  valid_568606 = validateParameter(valid_568606, JString, required = true,
                                 default = nil)
  if valid_568606 != nil:
    section.add "authorizationRuleName", valid_568606
  var valid_568607 = path.getOrDefault("subscriptionId")
  valid_568607 = validateParameter(valid_568607, JString, required = true,
                                 default = nil)
  if valid_568607 != nil:
    section.add "subscriptionId", valid_568607
  var valid_568608 = path.getOrDefault("relayName")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "relayName", valid_568608
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568609 = query.getOrDefault("api-version")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "api-version", valid_568609
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568610: Call_WcfrelaysListKeys_568601; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Primary and secondary connection strings to the WCF relay.
  ## 
  let valid = call_568610.validator(path, query, header, formData, body)
  let scheme = call_568610.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568610.url(scheme.get, call_568610.host, call_568610.base,
                         call_568610.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568610, url, valid)

proc call*(call_568611: Call_WcfrelaysListKeys_568601; namespaceName: string;
          resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; relayName: string): Recallable =
  ## wcfrelaysListKeys
  ## Primary and secondary connection strings to the WCF relay.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name.
  var path_568612 = newJObject()
  var query_568613 = newJObject()
  add(path_568612, "namespaceName", newJString(namespaceName))
  add(path_568612, "resourceGroupName", newJString(resourceGroupName))
  add(query_568613, "api-version", newJString(apiVersion))
  add(path_568612, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568612, "subscriptionId", newJString(subscriptionId))
  add(path_568612, "relayName", newJString(relayName))
  result = call_568611.call(path_568612, query_568613, nil, nil, nil)

var wcfrelaysListKeys* = Call_WcfrelaysListKeys_568601(name: "wcfrelaysListKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}/authorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_WcfrelaysListKeys_568602, base: "",
    url: url_WcfrelaysListKeys_568603, schemes: {Scheme.Https})
type
  Call_WcfrelaysRegenerateKeys_568614 = ref object of OpenApiRestCall_567657
proc url_WcfrelaysRegenerateKeys_568616(protocol: Scheme; host: string; base: string;
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

proc validate_WcfrelaysRegenerateKeys_568615(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary or secondary connection strings to the WCF relay.
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
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: JString (required)
  ##            : The relay name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568617 = path.getOrDefault("namespaceName")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "namespaceName", valid_568617
  var valid_568618 = path.getOrDefault("resourceGroupName")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "resourceGroupName", valid_568618
  var valid_568619 = path.getOrDefault("authorizationRuleName")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "authorizationRuleName", valid_568619
  var valid_568620 = path.getOrDefault("subscriptionId")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "subscriptionId", valid_568620
  var valid_568621 = path.getOrDefault("relayName")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "relayName", valid_568621
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568622 = query.getOrDefault("api-version")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "api-version", valid_568622
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

proc call*(call_568624: Call_WcfrelaysRegenerateKeys_568614; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the primary or secondary connection strings to the WCF relay.
  ## 
  let valid = call_568624.validator(path, query, header, formData, body)
  let scheme = call_568624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568624.url(scheme.get, call_568624.host, call_568624.base,
                         call_568624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568624, url, valid)

proc call*(call_568625: Call_WcfrelaysRegenerateKeys_568614; namespaceName: string;
          resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; relayName: string;
          parameters: JsonNode): Recallable =
  ## wcfrelaysRegenerateKeys
  ## Regenerates the primary or secondary connection strings to the WCF relay.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relayName: string (required)
  ##            : The relay name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate authorization rule.
  var path_568626 = newJObject()
  var query_568627 = newJObject()
  var body_568628 = newJObject()
  add(path_568626, "namespaceName", newJString(namespaceName))
  add(path_568626, "resourceGroupName", newJString(resourceGroupName))
  add(query_568627, "api-version", newJString(apiVersion))
  add(path_568626, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568626, "subscriptionId", newJString(subscriptionId))
  add(path_568626, "relayName", newJString(relayName))
  if parameters != nil:
    body_568628 = parameters
  result = call_568625.call(path_568626, query_568627, nil, nil, body_568628)

var wcfrelaysRegenerateKeys* = Call_WcfrelaysRegenerateKeys_568614(
    name: "wcfrelaysRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relay/namespaces/{namespaceName}/wcfRelays/{relayName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_WcfrelaysRegenerateKeys_568615, base: "",
    url: url_WcfrelaysRegenerateKeys_568616, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
