
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ContainerServiceClient
## version: 2015-11-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Container Service Client.
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
  macServiceName = "compute-containerService"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContainerServiceListByResourceGroup_563778 = ref object of OpenApiRestCall_563556
proc url_ContainerServiceListByResourceGroup_563780(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/containerServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerServiceListByResourceGroup_563779(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to list container services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563955 = path.getOrDefault("subscriptionId")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "subscriptionId", valid_563955
  var valid_563956 = path.getOrDefault("resourceGroupName")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "resourceGroupName", valid_563956
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563957 = query.getOrDefault("api-version")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "api-version", valid_563957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563980: Call_ContainerServiceListByResourceGroup_563778;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to list container services.
  ## 
  let valid = call_563980.validator(path, query, header, formData, body)
  let scheme = call_563980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563980.url(scheme.get, call_563980.host, call_563980.base,
                         call_563980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563980, url, valid)

proc call*(call_564051: Call_ContainerServiceListByResourceGroup_563778;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## containerServiceListByResourceGroup
  ## The operation to list container services.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564052 = newJObject()
  var query_564054 = newJObject()
  add(query_564054, "api-version", newJString(apiVersion))
  add(path_564052, "subscriptionId", newJString(subscriptionId))
  add(path_564052, "resourceGroupName", newJString(resourceGroupName))
  result = call_564051.call(path_564052, query_564054, nil, nil, nil)

var containerServiceListByResourceGroup* = Call_ContainerServiceListByResourceGroup_563778(
    name: "containerServiceListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/containerServices",
    validator: validate_ContainerServiceListByResourceGroup_563779, base: "",
    url: url_ContainerServiceListByResourceGroup_563780, schemes: {Scheme.Https})
type
  Call_ContainerServiceCreateOrUpdate_564104 = ref object of OpenApiRestCall_563556
proc url_ContainerServiceCreateOrUpdate_564106(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "containerServiceName" in path,
        "`containerServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/containerServices/"),
               (kind: VariableSegment, value: "containerServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerServiceCreateOrUpdate_564105(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a container service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerServiceName: JString (required)
  ##                       : The name of the container service within the given subscription and resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `containerServiceName` field"
  var valid_564124 = path.getOrDefault("containerServiceName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "containerServiceName", valid_564124
  var valid_564125 = path.getOrDefault("subscriptionId")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "subscriptionId", valid_564125
  var valid_564126 = path.getOrDefault("resourceGroupName")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "resourceGroupName", valid_564126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564127 = query.getOrDefault("api-version")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "api-version", valid_564127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Container Service operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564129: Call_ContainerServiceCreateOrUpdate_564104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a container service.
  ## 
  let valid = call_564129.validator(path, query, header, formData, body)
  let scheme = call_564129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564129.url(scheme.get, call_564129.host, call_564129.base,
                         call_564129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564129, url, valid)

proc call*(call_564130: Call_ContainerServiceCreateOrUpdate_564104;
          apiVersion: string; containerServiceName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## containerServiceCreateOrUpdate
  ## The operation to create or update a container service.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerServiceName: string (required)
  ##                       : The name of the container service within the given subscription and resource group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Container Service operation.
  var path_564131 = newJObject()
  var query_564132 = newJObject()
  var body_564133 = newJObject()
  add(query_564132, "api-version", newJString(apiVersion))
  add(path_564131, "containerServiceName", newJString(containerServiceName))
  add(path_564131, "subscriptionId", newJString(subscriptionId))
  add(path_564131, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564133 = parameters
  result = call_564130.call(path_564131, query_564132, nil, nil, body_564133)

var containerServiceCreateOrUpdate* = Call_ContainerServiceCreateOrUpdate_564104(
    name: "containerServiceCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/containerServices/{containerServiceName}",
    validator: validate_ContainerServiceCreateOrUpdate_564105, base: "",
    url: url_ContainerServiceCreateOrUpdate_564106, schemes: {Scheme.Https})
type
  Call_ContainerServiceGet_564093 = ref object of OpenApiRestCall_563556
proc url_ContainerServiceGet_564095(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "containerServiceName" in path,
        "`containerServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/containerServices/"),
               (kind: VariableSegment, value: "containerServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerServiceGet_564094(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The operation to get a container service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerServiceName: JString (required)
  ##                       : The name of the container service within the given subscription and resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `containerServiceName` field"
  var valid_564096 = path.getOrDefault("containerServiceName")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "containerServiceName", valid_564096
  var valid_564097 = path.getOrDefault("subscriptionId")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "subscriptionId", valid_564097
  var valid_564098 = path.getOrDefault("resourceGroupName")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "resourceGroupName", valid_564098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564099 = query.getOrDefault("api-version")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "api-version", valid_564099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564100: Call_ContainerServiceGet_564093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get a container service.
  ## 
  let valid = call_564100.validator(path, query, header, formData, body)
  let scheme = call_564100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564100.url(scheme.get, call_564100.host, call_564100.base,
                         call_564100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564100, url, valid)

proc call*(call_564101: Call_ContainerServiceGet_564093; apiVersion: string;
          containerServiceName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## containerServiceGet
  ## The operation to get a container service.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerServiceName: string (required)
  ##                       : The name of the container service within the given subscription and resource group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564102 = newJObject()
  var query_564103 = newJObject()
  add(query_564103, "api-version", newJString(apiVersion))
  add(path_564102, "containerServiceName", newJString(containerServiceName))
  add(path_564102, "subscriptionId", newJString(subscriptionId))
  add(path_564102, "resourceGroupName", newJString(resourceGroupName))
  result = call_564101.call(path_564102, query_564103, nil, nil, nil)

var containerServiceGet* = Call_ContainerServiceGet_564093(
    name: "containerServiceGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/containerServices/{containerServiceName}",
    validator: validate_ContainerServiceGet_564094, base: "",
    url: url_ContainerServiceGet_564095, schemes: {Scheme.Https})
type
  Call_ContainerServiceDelete_564134 = ref object of OpenApiRestCall_563556
proc url_ContainerServiceDelete_564136(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "containerServiceName" in path,
        "`containerServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/containerServices/"),
               (kind: VariableSegment, value: "containerServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerServiceDelete_564135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a container service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   containerServiceName: JString (required)
  ##                       : The name of the container service within the given subscription and resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `containerServiceName` field"
  var valid_564137 = path.getOrDefault("containerServiceName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "containerServiceName", valid_564137
  var valid_564138 = path.getOrDefault("subscriptionId")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "subscriptionId", valid_564138
  var valid_564139 = path.getOrDefault("resourceGroupName")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "resourceGroupName", valid_564139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564140 = query.getOrDefault("api-version")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "api-version", valid_564140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564141: Call_ContainerServiceDelete_564134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a container service.
  ## 
  let valid = call_564141.validator(path, query, header, formData, body)
  let scheme = call_564141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564141.url(scheme.get, call_564141.host, call_564141.base,
                         call_564141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564141, url, valid)

proc call*(call_564142: Call_ContainerServiceDelete_564134; apiVersion: string;
          containerServiceName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## containerServiceDelete
  ## The operation to delete a container service.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerServiceName: string (required)
  ##                       : The name of the container service within the given subscription and resource group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564143 = newJObject()
  var query_564144 = newJObject()
  add(query_564144, "api-version", newJString(apiVersion))
  add(path_564143, "containerServiceName", newJString(containerServiceName))
  add(path_564143, "subscriptionId", newJString(subscriptionId))
  add(path_564143, "resourceGroupName", newJString(resourceGroupName))
  result = call_564142.call(path_564143, query_564144, nil, nil, nil)

var containerServiceDelete* = Call_ContainerServiceDelete_564134(
    name: "containerServiceDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/containerServices/{containerServiceName}",
    validator: validate_ContainerServiceDelete_564135, base: "",
    url: url_ContainerServiceDelete_564136, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
