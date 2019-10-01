
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ContainerRegistryManagementClient
## version: 2019-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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
  macServiceName = "containerregistry"
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
  ## Lists all of the available Azure Container Registry REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  ## Lists all of the available Azure Container Registry REST API operations.
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
  ## Lists all of the available Azure Container Registry REST API operations.
  ##   apiVersion: string (required)
  ##             : The client API version.
  var query_568144 = newJObject()
  add(query_568144, "api-version", newJString(apiVersion))
  result = call_568143.call(nil, query_568144, nil, nil, nil)

var operationsList* = Call_OperationsList_567888(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ContainerRegistry/operations",
    validator: validate_OperationsList_567889, base: "", url: url_OperationsList_567890,
    schemes: {Scheme.Https})
type
  Call_RegistriesCheckNameAvailability_568184 = ref object of OpenApiRestCall_567666
proc url_RegistriesCheckNameAvailability_568186(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ContainerRegistry/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesCheckNameAvailability_568185(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the container registry name is available for use. The name must contain only alphanumeric characters, be globally unique, and between 5 and 50 characters in length.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568201 = path.getOrDefault("subscriptionId")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "subscriptionId", valid_568201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568202 = query.getOrDefault("api-version")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "api-version", valid_568202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   registryNameCheckRequest: JObject (required)
  ##                           : The object containing information for the availability request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568204: Call_RegistriesCheckNameAvailability_568184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the container registry name is available for use. The name must contain only alphanumeric characters, be globally unique, and between 5 and 50 characters in length.
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_RegistriesCheckNameAvailability_568184;
          apiVersion: string; subscriptionId: string;
          registryNameCheckRequest: JsonNode): Recallable =
  ## registriesCheckNameAvailability
  ## Checks whether the container registry name is available for use. The name must contain only alphanumeric characters, be globally unique, and between 5 and 50 characters in length.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryNameCheckRequest: JObject (required)
  ##                           : The object containing information for the availability request.
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  var body_568208 = newJObject()
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "subscriptionId", newJString(subscriptionId))
  if registryNameCheckRequest != nil:
    body_568208 = registryNameCheckRequest
  result = call_568205.call(path_568206, query_568207, nil, nil, body_568208)

var registriesCheckNameAvailability* = Call_RegistriesCheckNameAvailability_568184(
    name: "registriesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ContainerRegistry/checkNameAvailability",
    validator: validate_RegistriesCheckNameAvailability_568185, base: "",
    url: url_RegistriesCheckNameAvailability_568186, schemes: {Scheme.Https})
type
  Call_RegistriesList_568209 = ref object of OpenApiRestCall_567666
proc url_RegistriesList_568211(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesList_568210(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the container registries under the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568212 = path.getOrDefault("subscriptionId")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "subscriptionId", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568214: Call_RegistriesList_568209; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the container registries under the specified subscription.
  ## 
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_RegistriesList_568209; apiVersion: string;
          subscriptionId: string): Recallable =
  ## registriesList
  ## Lists all the container registries under the specified subscription.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  add(query_568217, "api-version", newJString(apiVersion))
  add(path_568216, "subscriptionId", newJString(subscriptionId))
  result = call_568215.call(path_568216, query_568217, nil, nil, nil)

var registriesList* = Call_RegistriesList_568209(name: "registriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ContainerRegistry/registries",
    validator: validate_RegistriesList_568210, base: "", url: url_RegistriesList_568211,
    schemes: {Scheme.Https})
type
  Call_RegistriesListByResourceGroup_568218 = ref object of OpenApiRestCall_567666
proc url_RegistriesListByResourceGroup_568220(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ContainerRegistry/registries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesListByResourceGroup_568219(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the container registries under the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568221 = path.getOrDefault("resourceGroupName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "resourceGroupName", valid_568221
  var valid_568222 = path.getOrDefault("subscriptionId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "subscriptionId", valid_568222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568223 = query.getOrDefault("api-version")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "api-version", valid_568223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568224: Call_RegistriesListByResourceGroup_568218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the container registries under the specified resource group.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_RegistriesListByResourceGroup_568218;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## registriesListByResourceGroup
  ## Lists all the container registries under the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  var path_568226 = newJObject()
  var query_568227 = newJObject()
  add(path_568226, "resourceGroupName", newJString(resourceGroupName))
  add(query_568227, "api-version", newJString(apiVersion))
  add(path_568226, "subscriptionId", newJString(subscriptionId))
  result = call_568225.call(path_568226, query_568227, nil, nil, nil)

var registriesListByResourceGroup* = Call_RegistriesListByResourceGroup_568218(
    name: "registriesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries",
    validator: validate_RegistriesListByResourceGroup_568219, base: "",
    url: url_RegistriesListByResourceGroup_568220, schemes: {Scheme.Https})
type
  Call_RegistriesCreate_568239 = ref object of OpenApiRestCall_567666
proc url_RegistriesCreate_568241(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesCreate_568240(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates a container registry with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568242 = path.getOrDefault("resourceGroupName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "resourceGroupName", valid_568242
  var valid_568243 = path.getOrDefault("subscriptionId")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "subscriptionId", valid_568243
  var valid_568244 = path.getOrDefault("registryName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "registryName", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "api-version", valid_568245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   registry: JObject (required)
  ##           : The parameters for creating a container registry.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568247: Call_RegistriesCreate_568239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a container registry with the specified parameters.
  ## 
  let valid = call_568247.validator(path, query, header, formData, body)
  let scheme = call_568247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568247.url(scheme.get, call_568247.host, call_568247.base,
                         call_568247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568247, url, valid)

proc call*(call_568248: Call_RegistriesCreate_568239; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registry: JsonNode;
          registryName: string): Recallable =
  ## registriesCreate
  ## Creates a container registry with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registry: JObject (required)
  ##           : The parameters for creating a container registry.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568249 = newJObject()
  var query_568250 = newJObject()
  var body_568251 = newJObject()
  add(path_568249, "resourceGroupName", newJString(resourceGroupName))
  add(query_568250, "api-version", newJString(apiVersion))
  add(path_568249, "subscriptionId", newJString(subscriptionId))
  if registry != nil:
    body_568251 = registry
  add(path_568249, "registryName", newJString(registryName))
  result = call_568248.call(path_568249, query_568250, nil, nil, body_568251)

var registriesCreate* = Call_RegistriesCreate_568239(name: "registriesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}",
    validator: validate_RegistriesCreate_568240, base: "",
    url: url_RegistriesCreate_568241, schemes: {Scheme.Https})
type
  Call_RegistriesGet_568228 = ref object of OpenApiRestCall_567666
proc url_RegistriesGet_568230(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesGet_568229(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568231 = path.getOrDefault("resourceGroupName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "resourceGroupName", valid_568231
  var valid_568232 = path.getOrDefault("subscriptionId")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "subscriptionId", valid_568232
  var valid_568233 = path.getOrDefault("registryName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "registryName", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568235: Call_RegistriesGet_568228; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified container registry.
  ## 
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_RegistriesGet_568228; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string): Recallable =
  ## registriesGet
  ## Gets the properties of the specified container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568237 = newJObject()
  var query_568238 = newJObject()
  add(path_568237, "resourceGroupName", newJString(resourceGroupName))
  add(query_568238, "api-version", newJString(apiVersion))
  add(path_568237, "subscriptionId", newJString(subscriptionId))
  add(path_568237, "registryName", newJString(registryName))
  result = call_568236.call(path_568237, query_568238, nil, nil, nil)

var registriesGet* = Call_RegistriesGet_568228(name: "registriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}",
    validator: validate_RegistriesGet_568229, base: "", url: url_RegistriesGet_568230,
    schemes: {Scheme.Https})
type
  Call_RegistriesUpdate_568263 = ref object of OpenApiRestCall_567666
proc url_RegistriesUpdate_568265(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesUpdate_568264(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a container registry with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568266 = path.getOrDefault("resourceGroupName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "resourceGroupName", valid_568266
  var valid_568267 = path.getOrDefault("subscriptionId")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "subscriptionId", valid_568267
  var valid_568268 = path.getOrDefault("registryName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "registryName", valid_568268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568269 = query.getOrDefault("api-version")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "api-version", valid_568269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   registryUpdateParameters: JObject (required)
  ##                           : The parameters for updating a container registry.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568271: Call_RegistriesUpdate_568263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a container registry with the specified parameters.
  ## 
  let valid = call_568271.validator(path, query, header, formData, body)
  let scheme = call_568271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568271.url(scheme.get, call_568271.host, call_568271.base,
                         call_568271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568271, url, valid)

proc call*(call_568272: Call_RegistriesUpdate_568263; resourceGroupName: string;
          registryUpdateParameters: JsonNode; apiVersion: string;
          subscriptionId: string; registryName: string): Recallable =
  ## registriesUpdate
  ## Updates a container registry with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   registryUpdateParameters: JObject (required)
  ##                           : The parameters for updating a container registry.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568273 = newJObject()
  var query_568274 = newJObject()
  var body_568275 = newJObject()
  add(path_568273, "resourceGroupName", newJString(resourceGroupName))
  if registryUpdateParameters != nil:
    body_568275 = registryUpdateParameters
  add(query_568274, "api-version", newJString(apiVersion))
  add(path_568273, "subscriptionId", newJString(subscriptionId))
  add(path_568273, "registryName", newJString(registryName))
  result = call_568272.call(path_568273, query_568274, nil, nil, body_568275)

var registriesUpdate* = Call_RegistriesUpdate_568263(name: "registriesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}",
    validator: validate_RegistriesUpdate_568264, base: "",
    url: url_RegistriesUpdate_568265, schemes: {Scheme.Https})
type
  Call_RegistriesDelete_568252 = ref object of OpenApiRestCall_567666
proc url_RegistriesDelete_568254(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesDelete_568253(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568255 = path.getOrDefault("resourceGroupName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "resourceGroupName", valid_568255
  var valid_568256 = path.getOrDefault("subscriptionId")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "subscriptionId", valid_568256
  var valid_568257 = path.getOrDefault("registryName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "registryName", valid_568257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568258 = query.getOrDefault("api-version")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "api-version", valid_568258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568259: Call_RegistriesDelete_568252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a container registry.
  ## 
  let valid = call_568259.validator(path, query, header, formData, body)
  let scheme = call_568259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568259.url(scheme.get, call_568259.host, call_568259.base,
                         call_568259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568259, url, valid)

proc call*(call_568260: Call_RegistriesDelete_568252; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string): Recallable =
  ## registriesDelete
  ## Deletes a container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568261 = newJObject()
  var query_568262 = newJObject()
  add(path_568261, "resourceGroupName", newJString(resourceGroupName))
  add(query_568262, "api-version", newJString(apiVersion))
  add(path_568261, "subscriptionId", newJString(subscriptionId))
  add(path_568261, "registryName", newJString(registryName))
  result = call_568260.call(path_568261, query_568262, nil, nil, nil)

var registriesDelete* = Call_RegistriesDelete_568252(name: "registriesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}",
    validator: validate_RegistriesDelete_568253, base: "",
    url: url_RegistriesDelete_568254, schemes: {Scheme.Https})
type
  Call_RegistriesImportImage_568276 = ref object of OpenApiRestCall_567666
proc url_RegistriesImportImage_568278(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/importImage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesImportImage_568277(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Copies an image to this container registry from the specified container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  var valid_568281 = path.getOrDefault("registryName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "registryName", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "api-version", valid_568282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters specifying the image to copy and the source container registry.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568284: Call_RegistriesImportImage_568276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies an image to this container registry from the specified container registry.
  ## 
  let valid = call_568284.validator(path, query, header, formData, body)
  let scheme = call_568284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568284.url(scheme.get, call_568284.host, call_568284.base,
                         call_568284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568284, url, valid)

proc call*(call_568285: Call_RegistriesImportImage_568276;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          registryName: string; parameters: JsonNode): Recallable =
  ## registriesImportImage
  ## Copies an image to this container registry from the specified container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   parameters: JObject (required)
  ##             : The parameters specifying the image to copy and the source container registry.
  var path_568286 = newJObject()
  var query_568287 = newJObject()
  var body_568288 = newJObject()
  add(path_568286, "resourceGroupName", newJString(resourceGroupName))
  add(query_568287, "api-version", newJString(apiVersion))
  add(path_568286, "subscriptionId", newJString(subscriptionId))
  add(path_568286, "registryName", newJString(registryName))
  if parameters != nil:
    body_568288 = parameters
  result = call_568285.call(path_568286, query_568287, nil, nil, body_568288)

var registriesImportImage* = Call_RegistriesImportImage_568276(
    name: "registriesImportImage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/importImage",
    validator: validate_RegistriesImportImage_568277, base: "",
    url: url_RegistriesImportImage_568278, schemes: {Scheme.Https})
type
  Call_RegistriesListCredentials_568289 = ref object of OpenApiRestCall_567666
proc url_RegistriesListCredentials_568291(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/listCredentials")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesListCredentials_568290(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the login credentials for the specified container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  var valid_568294 = path.getOrDefault("registryName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "registryName", valid_568294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568295 = query.getOrDefault("api-version")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "api-version", valid_568295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568296: Call_RegistriesListCredentials_568289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the login credentials for the specified container registry.
  ## 
  let valid = call_568296.validator(path, query, header, formData, body)
  let scheme = call_568296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568296.url(scheme.get, call_568296.host, call_568296.base,
                         call_568296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568296, url, valid)

proc call*(call_568297: Call_RegistriesListCredentials_568289;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          registryName: string): Recallable =
  ## registriesListCredentials
  ## Lists the login credentials for the specified container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568298 = newJObject()
  var query_568299 = newJObject()
  add(path_568298, "resourceGroupName", newJString(resourceGroupName))
  add(query_568299, "api-version", newJString(apiVersion))
  add(path_568298, "subscriptionId", newJString(subscriptionId))
  add(path_568298, "registryName", newJString(registryName))
  result = call_568297.call(path_568298, query_568299, nil, nil, nil)

var registriesListCredentials* = Call_RegistriesListCredentials_568289(
    name: "registriesListCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/listCredentials",
    validator: validate_RegistriesListCredentials_568290, base: "",
    url: url_RegistriesListCredentials_568291, schemes: {Scheme.Https})
type
  Call_RegistriesListUsages_568300 = ref object of OpenApiRestCall_567666
proc url_RegistriesListUsages_568302(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/listUsages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesListUsages_568301(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the quota usages for the specified container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  var valid_568305 = path.getOrDefault("registryName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "registryName", valid_568305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568306 = query.getOrDefault("api-version")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "api-version", valid_568306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568307: Call_RegistriesListUsages_568300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the quota usages for the specified container registry.
  ## 
  let valid = call_568307.validator(path, query, header, formData, body)
  let scheme = call_568307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568307.url(scheme.get, call_568307.host, call_568307.base,
                         call_568307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568307, url, valid)

proc call*(call_568308: Call_RegistriesListUsages_568300;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          registryName: string): Recallable =
  ## registriesListUsages
  ## Gets the quota usages for the specified container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568309 = newJObject()
  var query_568310 = newJObject()
  add(path_568309, "resourceGroupName", newJString(resourceGroupName))
  add(query_568310, "api-version", newJString(apiVersion))
  add(path_568309, "subscriptionId", newJString(subscriptionId))
  add(path_568309, "registryName", newJString(registryName))
  result = call_568308.call(path_568309, query_568310, nil, nil, nil)

var registriesListUsages* = Call_RegistriesListUsages_568300(
    name: "registriesListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/listUsages",
    validator: validate_RegistriesListUsages_568301, base: "",
    url: url_RegistriesListUsages_568302, schemes: {Scheme.Https})
type
  Call_RegistriesRegenerateCredential_568311 = ref object of OpenApiRestCall_567666
proc url_RegistriesRegenerateCredential_568313(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/regenerateCredential")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesRegenerateCredential_568312(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates one of the login credentials for the specified container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568314 = path.getOrDefault("resourceGroupName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "resourceGroupName", valid_568314
  var valid_568315 = path.getOrDefault("subscriptionId")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "subscriptionId", valid_568315
  var valid_568316 = path.getOrDefault("registryName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "registryName", valid_568316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568317 = query.getOrDefault("api-version")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "api-version", valid_568317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regenerateCredentialParameters: JObject (required)
  ##                                 : Specifies name of the password which should be regenerated -- password or password2.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568319: Call_RegistriesRegenerateCredential_568311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates one of the login credentials for the specified container registry.
  ## 
  let valid = call_568319.validator(path, query, header, formData, body)
  let scheme = call_568319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568319.url(scheme.get, call_568319.host, call_568319.base,
                         call_568319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568319, url, valid)

proc call*(call_568320: Call_RegistriesRegenerateCredential_568311;
          regenerateCredentialParameters: JsonNode; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string): Recallable =
  ## registriesRegenerateCredential
  ## Regenerates one of the login credentials for the specified container registry.
  ##   regenerateCredentialParameters: JObject (required)
  ##                                 : Specifies name of the password which should be regenerated -- password or password2.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568321 = newJObject()
  var query_568322 = newJObject()
  var body_568323 = newJObject()
  if regenerateCredentialParameters != nil:
    body_568323 = regenerateCredentialParameters
  add(path_568321, "resourceGroupName", newJString(resourceGroupName))
  add(query_568322, "api-version", newJString(apiVersion))
  add(path_568321, "subscriptionId", newJString(subscriptionId))
  add(path_568321, "registryName", newJString(registryName))
  result = call_568320.call(path_568321, query_568322, nil, nil, body_568323)

var registriesRegenerateCredential* = Call_RegistriesRegenerateCredential_568311(
    name: "registriesRegenerateCredential", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/regenerateCredential",
    validator: validate_RegistriesRegenerateCredential_568312, base: "",
    url: url_RegistriesRegenerateCredential_568313, schemes: {Scheme.Https})
type
  Call_ReplicationsList_568324 = ref object of OpenApiRestCall_567666
proc url_ReplicationsList_568326(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/replications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationsList_568325(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all the replications for the specified container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568327 = path.getOrDefault("resourceGroupName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "resourceGroupName", valid_568327
  var valid_568328 = path.getOrDefault("subscriptionId")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "subscriptionId", valid_568328
  var valid_568329 = path.getOrDefault("registryName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "registryName", valid_568329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_568331: Call_ReplicationsList_568324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the replications for the specified container registry.
  ## 
  let valid = call_568331.validator(path, query, header, formData, body)
  let scheme = call_568331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568331.url(scheme.get, call_568331.host, call_568331.base,
                         call_568331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568331, url, valid)

proc call*(call_568332: Call_ReplicationsList_568324; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string): Recallable =
  ## replicationsList
  ## Lists all the replications for the specified container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568333 = newJObject()
  var query_568334 = newJObject()
  add(path_568333, "resourceGroupName", newJString(resourceGroupName))
  add(query_568334, "api-version", newJString(apiVersion))
  add(path_568333, "subscriptionId", newJString(subscriptionId))
  add(path_568333, "registryName", newJString(registryName))
  result = call_568332.call(path_568333, query_568334, nil, nil, nil)

var replicationsList* = Call_ReplicationsList_568324(name: "replicationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/replications",
    validator: validate_ReplicationsList_568325, base: "",
    url: url_ReplicationsList_568326, schemes: {Scheme.Https})
type
  Call_ReplicationsCreate_568347 = ref object of OpenApiRestCall_567666
proc url_ReplicationsCreate_568349(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "replicationName" in path, "`replicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/replications/"),
               (kind: VariableSegment, value: "replicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationsCreate_568348(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a replication for a container registry with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   replicationName: JString (required)
  ##                  : The name of the replication.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568350 = path.getOrDefault("resourceGroupName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "resourceGroupName", valid_568350
  var valid_568351 = path.getOrDefault("subscriptionId")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "subscriptionId", valid_568351
  var valid_568352 = path.getOrDefault("replicationName")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "replicationName", valid_568352
  var valid_568353 = path.getOrDefault("registryName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "registryName", valid_568353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568354 = query.getOrDefault("api-version")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "api-version", valid_568354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   replication: JObject (required)
  ##              : The parameters for creating a replication.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568356: Call_ReplicationsCreate_568347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a replication for a container registry with the specified parameters.
  ## 
  let valid = call_568356.validator(path, query, header, formData, body)
  let scheme = call_568356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568356.url(scheme.get, call_568356.host, call_568356.base,
                         call_568356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568356, url, valid)

proc call*(call_568357: Call_ReplicationsCreate_568347; replication: JsonNode;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          replicationName: string; registryName: string): Recallable =
  ## replicationsCreate
  ## Creates a replication for a container registry with the specified parameters.
  ##   replication: JObject (required)
  ##              : The parameters for creating a replication.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   replicationName: string (required)
  ##                  : The name of the replication.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568358 = newJObject()
  var query_568359 = newJObject()
  var body_568360 = newJObject()
  if replication != nil:
    body_568360 = replication
  add(path_568358, "resourceGroupName", newJString(resourceGroupName))
  add(query_568359, "api-version", newJString(apiVersion))
  add(path_568358, "subscriptionId", newJString(subscriptionId))
  add(path_568358, "replicationName", newJString(replicationName))
  add(path_568358, "registryName", newJString(registryName))
  result = call_568357.call(path_568358, query_568359, nil, nil, body_568360)

var replicationsCreate* = Call_ReplicationsCreate_568347(
    name: "replicationsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/replications/{replicationName}",
    validator: validate_ReplicationsCreate_568348, base: "",
    url: url_ReplicationsCreate_568349, schemes: {Scheme.Https})
type
  Call_ReplicationsGet_568335 = ref object of OpenApiRestCall_567666
proc url_ReplicationsGet_568337(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "replicationName" in path, "`replicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/replications/"),
               (kind: VariableSegment, value: "replicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationsGet_568336(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the properties of the specified replication.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   replicationName: JString (required)
  ##                  : The name of the replication.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568338 = path.getOrDefault("resourceGroupName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "resourceGroupName", valid_568338
  var valid_568339 = path.getOrDefault("subscriptionId")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "subscriptionId", valid_568339
  var valid_568340 = path.getOrDefault("replicationName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "replicationName", valid_568340
  var valid_568341 = path.getOrDefault("registryName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "registryName", valid_568341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568343: Call_ReplicationsGet_568335; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified replication.
  ## 
  let valid = call_568343.validator(path, query, header, formData, body)
  let scheme = call_568343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568343.url(scheme.get, call_568343.host, call_568343.base,
                         call_568343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568343, url, valid)

proc call*(call_568344: Call_ReplicationsGet_568335; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; replicationName: string;
          registryName: string): Recallable =
  ## replicationsGet
  ## Gets the properties of the specified replication.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   replicationName: string (required)
  ##                  : The name of the replication.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568345 = newJObject()
  var query_568346 = newJObject()
  add(path_568345, "resourceGroupName", newJString(resourceGroupName))
  add(query_568346, "api-version", newJString(apiVersion))
  add(path_568345, "subscriptionId", newJString(subscriptionId))
  add(path_568345, "replicationName", newJString(replicationName))
  add(path_568345, "registryName", newJString(registryName))
  result = call_568344.call(path_568345, query_568346, nil, nil, nil)

var replicationsGet* = Call_ReplicationsGet_568335(name: "replicationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/replications/{replicationName}",
    validator: validate_ReplicationsGet_568336, base: "", url: url_ReplicationsGet_568337,
    schemes: {Scheme.Https})
type
  Call_ReplicationsUpdate_568373 = ref object of OpenApiRestCall_567666
proc url_ReplicationsUpdate_568375(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "replicationName" in path, "`replicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/replications/"),
               (kind: VariableSegment, value: "replicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationsUpdate_568374(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates a replication for a container registry with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   replicationName: JString (required)
  ##                  : The name of the replication.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568376 = path.getOrDefault("resourceGroupName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "resourceGroupName", valid_568376
  var valid_568377 = path.getOrDefault("subscriptionId")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "subscriptionId", valid_568377
  var valid_568378 = path.getOrDefault("replicationName")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "replicationName", valid_568378
  var valid_568379 = path.getOrDefault("registryName")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "registryName", valid_568379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  ##   replicationUpdateParameters: JObject (required)
  ##                              : The parameters for updating a replication.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568382: Call_ReplicationsUpdate_568373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a replication for a container registry with the specified parameters.
  ## 
  let valid = call_568382.validator(path, query, header, formData, body)
  let scheme = call_568382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568382.url(scheme.get, call_568382.host, call_568382.base,
                         call_568382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568382, url, valid)

proc call*(call_568383: Call_ReplicationsUpdate_568373; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; replicationName: string;
          registryName: string; replicationUpdateParameters: JsonNode): Recallable =
  ## replicationsUpdate
  ## Updates a replication for a container registry with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   replicationName: string (required)
  ##                  : The name of the replication.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   replicationUpdateParameters: JObject (required)
  ##                              : The parameters for updating a replication.
  var path_568384 = newJObject()
  var query_568385 = newJObject()
  var body_568386 = newJObject()
  add(path_568384, "resourceGroupName", newJString(resourceGroupName))
  add(query_568385, "api-version", newJString(apiVersion))
  add(path_568384, "subscriptionId", newJString(subscriptionId))
  add(path_568384, "replicationName", newJString(replicationName))
  add(path_568384, "registryName", newJString(registryName))
  if replicationUpdateParameters != nil:
    body_568386 = replicationUpdateParameters
  result = call_568383.call(path_568384, query_568385, nil, nil, body_568386)

var replicationsUpdate* = Call_ReplicationsUpdate_568373(
    name: "replicationsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/replications/{replicationName}",
    validator: validate_ReplicationsUpdate_568374, base: "",
    url: url_ReplicationsUpdate_568375, schemes: {Scheme.Https})
type
  Call_ReplicationsDelete_568361 = ref object of OpenApiRestCall_567666
proc url_ReplicationsDelete_568363(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "replicationName" in path, "`replicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/replications/"),
               (kind: VariableSegment, value: "replicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationsDelete_568362(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a replication from a container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   replicationName: JString (required)
  ##                  : The name of the replication.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  var valid_568366 = path.getOrDefault("replicationName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "replicationName", valid_568366
  var valid_568367 = path.getOrDefault("registryName")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "registryName", valid_568367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_568369: Call_ReplicationsDelete_568361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a replication from a container registry.
  ## 
  let valid = call_568369.validator(path, query, header, formData, body)
  let scheme = call_568369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568369.url(scheme.get, call_568369.host, call_568369.base,
                         call_568369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568369, url, valid)

proc call*(call_568370: Call_ReplicationsDelete_568361; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; replicationName: string;
          registryName: string): Recallable =
  ## replicationsDelete
  ## Deletes a replication from a container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   replicationName: string (required)
  ##                  : The name of the replication.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568371 = newJObject()
  var query_568372 = newJObject()
  add(path_568371, "resourceGroupName", newJString(resourceGroupName))
  add(query_568372, "api-version", newJString(apiVersion))
  add(path_568371, "subscriptionId", newJString(subscriptionId))
  add(path_568371, "replicationName", newJString(replicationName))
  add(path_568371, "registryName", newJString(registryName))
  result = call_568370.call(path_568371, query_568372, nil, nil, nil)

var replicationsDelete* = Call_ReplicationsDelete_568361(
    name: "replicationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/replications/{replicationName}",
    validator: validate_ReplicationsDelete_568362, base: "",
    url: url_ReplicationsDelete_568363, schemes: {Scheme.Https})
type
  Call_WebhooksList_568387 = ref object of OpenApiRestCall_567666
proc url_WebhooksList_568389(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/webhooks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhooksList_568388(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the webhooks for the specified container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568390 = path.getOrDefault("resourceGroupName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "resourceGroupName", valid_568390
  var valid_568391 = path.getOrDefault("subscriptionId")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "subscriptionId", valid_568391
  var valid_568392 = path.getOrDefault("registryName")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "registryName", valid_568392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_568394: Call_WebhooksList_568387; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the webhooks for the specified container registry.
  ## 
  let valid = call_568394.validator(path, query, header, formData, body)
  let scheme = call_568394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568394.url(scheme.get, call_568394.host, call_568394.base,
                         call_568394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568394, url, valid)

proc call*(call_568395: Call_WebhooksList_568387; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string): Recallable =
  ## webhooksList
  ## Lists all the webhooks for the specified container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568396 = newJObject()
  var query_568397 = newJObject()
  add(path_568396, "resourceGroupName", newJString(resourceGroupName))
  add(query_568397, "api-version", newJString(apiVersion))
  add(path_568396, "subscriptionId", newJString(subscriptionId))
  add(path_568396, "registryName", newJString(registryName))
  result = call_568395.call(path_568396, query_568397, nil, nil, nil)

var webhooksList* = Call_WebhooksList_568387(name: "webhooksList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/webhooks",
    validator: validate_WebhooksList_568388, base: "", url: url_WebhooksList_568389,
    schemes: {Scheme.Https})
type
  Call_WebhooksCreate_568410 = ref object of OpenApiRestCall_567666
proc url_WebhooksCreate_568412(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhooksCreate_568411(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a webhook for a container registry with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   webhookName: JString (required)
  ##              : The name of the webhook.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568413 = path.getOrDefault("resourceGroupName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "resourceGroupName", valid_568413
  var valid_568414 = path.getOrDefault("webhookName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "webhookName", valid_568414
  var valid_568415 = path.getOrDefault("subscriptionId")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "subscriptionId", valid_568415
  var valid_568416 = path.getOrDefault("registryName")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "registryName", valid_568416
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568417 = query.getOrDefault("api-version")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "api-version", valid_568417
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   webhookCreateParameters: JObject (required)
  ##                          : The parameters for creating a webhook.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568419: Call_WebhooksCreate_568410; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a webhook for a container registry with the specified parameters.
  ## 
  let valid = call_568419.validator(path, query, header, formData, body)
  let scheme = call_568419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568419.url(scheme.get, call_568419.host, call_568419.base,
                         call_568419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568419, url, valid)

proc call*(call_568420: Call_WebhooksCreate_568410; resourceGroupName: string;
          apiVersion: string; webhookName: string; subscriptionId: string;
          webhookCreateParameters: JsonNode; registryName: string): Recallable =
  ## webhooksCreate
  ## Creates a webhook for a container registry with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   webhookName: string (required)
  ##              : The name of the webhook.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   webhookCreateParameters: JObject (required)
  ##                          : The parameters for creating a webhook.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568421 = newJObject()
  var query_568422 = newJObject()
  var body_568423 = newJObject()
  add(path_568421, "resourceGroupName", newJString(resourceGroupName))
  add(query_568422, "api-version", newJString(apiVersion))
  add(path_568421, "webhookName", newJString(webhookName))
  add(path_568421, "subscriptionId", newJString(subscriptionId))
  if webhookCreateParameters != nil:
    body_568423 = webhookCreateParameters
  add(path_568421, "registryName", newJString(registryName))
  result = call_568420.call(path_568421, query_568422, nil, nil, body_568423)

var webhooksCreate* = Call_WebhooksCreate_568410(name: "webhooksCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/webhooks/{webhookName}",
    validator: validate_WebhooksCreate_568411, base: "", url: url_WebhooksCreate_568412,
    schemes: {Scheme.Https})
type
  Call_WebhooksGet_568398 = ref object of OpenApiRestCall_567666
proc url_WebhooksGet_568400(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhooksGet_568399(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified webhook.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   webhookName: JString (required)
  ##              : The name of the webhook.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568401 = path.getOrDefault("resourceGroupName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "resourceGroupName", valid_568401
  var valid_568402 = path.getOrDefault("webhookName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "webhookName", valid_568402
  var valid_568403 = path.getOrDefault("subscriptionId")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "subscriptionId", valid_568403
  var valid_568404 = path.getOrDefault("registryName")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "registryName", valid_568404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568405 = query.getOrDefault("api-version")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "api-version", valid_568405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568406: Call_WebhooksGet_568398; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified webhook.
  ## 
  let valid = call_568406.validator(path, query, header, formData, body)
  let scheme = call_568406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568406.url(scheme.get, call_568406.host, call_568406.base,
                         call_568406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568406, url, valid)

proc call*(call_568407: Call_WebhooksGet_568398; resourceGroupName: string;
          apiVersion: string; webhookName: string; subscriptionId: string;
          registryName: string): Recallable =
  ## webhooksGet
  ## Gets the properties of the specified webhook.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   webhookName: string (required)
  ##              : The name of the webhook.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568408 = newJObject()
  var query_568409 = newJObject()
  add(path_568408, "resourceGroupName", newJString(resourceGroupName))
  add(query_568409, "api-version", newJString(apiVersion))
  add(path_568408, "webhookName", newJString(webhookName))
  add(path_568408, "subscriptionId", newJString(subscriptionId))
  add(path_568408, "registryName", newJString(registryName))
  result = call_568407.call(path_568408, query_568409, nil, nil, nil)

var webhooksGet* = Call_WebhooksGet_568398(name: "webhooksGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/webhooks/{webhookName}",
                                        validator: validate_WebhooksGet_568399,
                                        base: "", url: url_WebhooksGet_568400,
                                        schemes: {Scheme.Https})
type
  Call_WebhooksUpdate_568436 = ref object of OpenApiRestCall_567666
proc url_WebhooksUpdate_568438(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhooksUpdate_568437(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates a webhook with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   webhookName: JString (required)
  ##              : The name of the webhook.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568439 = path.getOrDefault("resourceGroupName")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "resourceGroupName", valid_568439
  var valid_568440 = path.getOrDefault("webhookName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "webhookName", valid_568440
  var valid_568441 = path.getOrDefault("subscriptionId")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "subscriptionId", valid_568441
  var valid_568442 = path.getOrDefault("registryName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "registryName", valid_568442
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568443 = query.getOrDefault("api-version")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "api-version", valid_568443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   webhookUpdateParameters: JObject (required)
  ##                          : The parameters for updating a webhook.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568445: Call_WebhooksUpdate_568436; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a webhook with the specified parameters.
  ## 
  let valid = call_568445.validator(path, query, header, formData, body)
  let scheme = call_568445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568445.url(scheme.get, call_568445.host, call_568445.base,
                         call_568445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568445, url, valid)

proc call*(call_568446: Call_WebhooksUpdate_568436; resourceGroupName: string;
          webhookUpdateParameters: JsonNode; apiVersion: string;
          webhookName: string; subscriptionId: string; registryName: string): Recallable =
  ## webhooksUpdate
  ## Updates a webhook with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   webhookUpdateParameters: JObject (required)
  ##                          : The parameters for updating a webhook.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   webhookName: string (required)
  ##              : The name of the webhook.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568447 = newJObject()
  var query_568448 = newJObject()
  var body_568449 = newJObject()
  add(path_568447, "resourceGroupName", newJString(resourceGroupName))
  if webhookUpdateParameters != nil:
    body_568449 = webhookUpdateParameters
  add(query_568448, "api-version", newJString(apiVersion))
  add(path_568447, "webhookName", newJString(webhookName))
  add(path_568447, "subscriptionId", newJString(subscriptionId))
  add(path_568447, "registryName", newJString(registryName))
  result = call_568446.call(path_568447, query_568448, nil, nil, body_568449)

var webhooksUpdate* = Call_WebhooksUpdate_568436(name: "webhooksUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/webhooks/{webhookName}",
    validator: validate_WebhooksUpdate_568437, base: "", url: url_WebhooksUpdate_568438,
    schemes: {Scheme.Https})
type
  Call_WebhooksDelete_568424 = ref object of OpenApiRestCall_567666
proc url_WebhooksDelete_568426(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhooksDelete_568425(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a webhook from a container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   webhookName: JString (required)
  ##              : The name of the webhook.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568427 = path.getOrDefault("resourceGroupName")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "resourceGroupName", valid_568427
  var valid_568428 = path.getOrDefault("webhookName")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "webhookName", valid_568428
  var valid_568429 = path.getOrDefault("subscriptionId")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "subscriptionId", valid_568429
  var valid_568430 = path.getOrDefault("registryName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "registryName", valid_568430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568431 = query.getOrDefault("api-version")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "api-version", valid_568431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568432: Call_WebhooksDelete_568424; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a webhook from a container registry.
  ## 
  let valid = call_568432.validator(path, query, header, formData, body)
  let scheme = call_568432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568432.url(scheme.get, call_568432.host, call_568432.base,
                         call_568432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568432, url, valid)

proc call*(call_568433: Call_WebhooksDelete_568424; resourceGroupName: string;
          apiVersion: string; webhookName: string; subscriptionId: string;
          registryName: string): Recallable =
  ## webhooksDelete
  ## Deletes a webhook from a container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   webhookName: string (required)
  ##              : The name of the webhook.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568434 = newJObject()
  var query_568435 = newJObject()
  add(path_568434, "resourceGroupName", newJString(resourceGroupName))
  add(query_568435, "api-version", newJString(apiVersion))
  add(path_568434, "webhookName", newJString(webhookName))
  add(path_568434, "subscriptionId", newJString(subscriptionId))
  add(path_568434, "registryName", newJString(registryName))
  result = call_568433.call(path_568434, query_568435, nil, nil, nil)

var webhooksDelete* = Call_WebhooksDelete_568424(name: "webhooksDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/webhooks/{webhookName}",
    validator: validate_WebhooksDelete_568425, base: "", url: url_WebhooksDelete_568426,
    schemes: {Scheme.Https})
type
  Call_WebhooksGetCallbackConfig_568450 = ref object of OpenApiRestCall_567666
proc url_WebhooksGetCallbackConfig_568452(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName"),
               (kind: ConstantSegment, value: "/getCallbackConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhooksGetCallbackConfig_568451(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the configuration of service URI and custom headers for the webhook.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   webhookName: JString (required)
  ##              : The name of the webhook.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568453 = path.getOrDefault("resourceGroupName")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "resourceGroupName", valid_568453
  var valid_568454 = path.getOrDefault("webhookName")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "webhookName", valid_568454
  var valid_568455 = path.getOrDefault("subscriptionId")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "subscriptionId", valid_568455
  var valid_568456 = path.getOrDefault("registryName")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "registryName", valid_568456
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_568458: Call_WebhooksGetCallbackConfig_568450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration of service URI and custom headers for the webhook.
  ## 
  let valid = call_568458.validator(path, query, header, formData, body)
  let scheme = call_568458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568458.url(scheme.get, call_568458.host, call_568458.base,
                         call_568458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568458, url, valid)

proc call*(call_568459: Call_WebhooksGetCallbackConfig_568450;
          resourceGroupName: string; apiVersion: string; webhookName: string;
          subscriptionId: string; registryName: string): Recallable =
  ## webhooksGetCallbackConfig
  ## Gets the configuration of service URI and custom headers for the webhook.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   webhookName: string (required)
  ##              : The name of the webhook.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568460 = newJObject()
  var query_568461 = newJObject()
  add(path_568460, "resourceGroupName", newJString(resourceGroupName))
  add(query_568461, "api-version", newJString(apiVersion))
  add(path_568460, "webhookName", newJString(webhookName))
  add(path_568460, "subscriptionId", newJString(subscriptionId))
  add(path_568460, "registryName", newJString(registryName))
  result = call_568459.call(path_568460, query_568461, nil, nil, nil)

var webhooksGetCallbackConfig* = Call_WebhooksGetCallbackConfig_568450(
    name: "webhooksGetCallbackConfig", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/webhooks/{webhookName}/getCallbackConfig",
    validator: validate_WebhooksGetCallbackConfig_568451, base: "",
    url: url_WebhooksGetCallbackConfig_568452, schemes: {Scheme.Https})
type
  Call_WebhooksListEvents_568462 = ref object of OpenApiRestCall_567666
proc url_WebhooksListEvents_568464(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName"),
               (kind: ConstantSegment, value: "/listEvents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhooksListEvents_568463(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists recent events for the specified webhook.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   webhookName: JString (required)
  ##              : The name of the webhook.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568465 = path.getOrDefault("resourceGroupName")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "resourceGroupName", valid_568465
  var valid_568466 = path.getOrDefault("webhookName")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "webhookName", valid_568466
  var valid_568467 = path.getOrDefault("subscriptionId")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "subscriptionId", valid_568467
  var valid_568468 = path.getOrDefault("registryName")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "registryName", valid_568468
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_568470: Call_WebhooksListEvents_568462; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists recent events for the specified webhook.
  ## 
  let valid = call_568470.validator(path, query, header, formData, body)
  let scheme = call_568470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568470.url(scheme.get, call_568470.host, call_568470.base,
                         call_568470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568470, url, valid)

proc call*(call_568471: Call_WebhooksListEvents_568462; resourceGroupName: string;
          apiVersion: string; webhookName: string; subscriptionId: string;
          registryName: string): Recallable =
  ## webhooksListEvents
  ## Lists recent events for the specified webhook.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   webhookName: string (required)
  ##              : The name of the webhook.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568472 = newJObject()
  var query_568473 = newJObject()
  add(path_568472, "resourceGroupName", newJString(resourceGroupName))
  add(query_568473, "api-version", newJString(apiVersion))
  add(path_568472, "webhookName", newJString(webhookName))
  add(path_568472, "subscriptionId", newJString(subscriptionId))
  add(path_568472, "registryName", newJString(registryName))
  result = call_568471.call(path_568472, query_568473, nil, nil, nil)

var webhooksListEvents* = Call_WebhooksListEvents_568462(
    name: "webhooksListEvents", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/webhooks/{webhookName}/listEvents",
    validator: validate_WebhooksListEvents_568463, base: "",
    url: url_WebhooksListEvents_568464, schemes: {Scheme.Https})
type
  Call_WebhooksPing_568474 = ref object of OpenApiRestCall_567666
proc url_WebhooksPing_568476(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName"),
               (kind: ConstantSegment, value: "/ping")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhooksPing_568475(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Triggers a ping event to be sent to the webhook.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   webhookName: JString (required)
  ##              : The name of the webhook.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568477 = path.getOrDefault("resourceGroupName")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "resourceGroupName", valid_568477
  var valid_568478 = path.getOrDefault("webhookName")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "webhookName", valid_568478
  var valid_568479 = path.getOrDefault("subscriptionId")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "subscriptionId", valid_568479
  var valid_568480 = path.getOrDefault("registryName")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "registryName", valid_568480
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568481 = query.getOrDefault("api-version")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "api-version", valid_568481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568482: Call_WebhooksPing_568474; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Triggers a ping event to be sent to the webhook.
  ## 
  let valid = call_568482.validator(path, query, header, formData, body)
  let scheme = call_568482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568482.url(scheme.get, call_568482.host, call_568482.base,
                         call_568482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568482, url, valid)

proc call*(call_568483: Call_WebhooksPing_568474; resourceGroupName: string;
          apiVersion: string; webhookName: string; subscriptionId: string;
          registryName: string): Recallable =
  ## webhooksPing
  ## Triggers a ping event to be sent to the webhook.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   webhookName: string (required)
  ##              : The name of the webhook.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568484 = newJObject()
  var query_568485 = newJObject()
  add(path_568484, "resourceGroupName", newJString(resourceGroupName))
  add(query_568485, "api-version", newJString(apiVersion))
  add(path_568484, "webhookName", newJString(webhookName))
  add(path_568484, "subscriptionId", newJString(subscriptionId))
  add(path_568484, "registryName", newJString(registryName))
  result = call_568483.call(path_568484, query_568485, nil, nil, nil)

var webhooksPing* = Call_WebhooksPing_568474(name: "webhooksPing",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/webhooks/{webhookName}/ping",
    validator: validate_WebhooksPing_568475, base: "", url: url_WebhooksPing_568476,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
