
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ContainerRegistryManagementClient
## version: 2018-09-01
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
  macServiceName = "containerregistry-containerregistry_build"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RegistriesGetBuildSourceUploadUrl_567888 = ref object of OpenApiRestCall_567666
proc url_RegistriesGetBuildSourceUploadUrl_567890(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/listBuildSourceUploadUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesGetBuildSourceUploadUrl_567889(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the upload location for the user to be able to upload the source.
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
  var valid_568063 = path.getOrDefault("resourceGroupName")
  valid_568063 = validateParameter(valid_568063, JString, required = true,
                                 default = nil)
  if valid_568063 != nil:
    section.add "resourceGroupName", valid_568063
  var valid_568064 = path.getOrDefault("subscriptionId")
  valid_568064 = validateParameter(valid_568064, JString, required = true,
                                 default = nil)
  if valid_568064 != nil:
    section.add "subscriptionId", valid_568064
  var valid_568065 = path.getOrDefault("registryName")
  valid_568065 = validateParameter(valid_568065, JString, required = true,
                                 default = nil)
  if valid_568065 != nil:
    section.add "registryName", valid_568065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568066 = query.getOrDefault("api-version")
  valid_568066 = validateParameter(valid_568066, JString, required = true,
                                 default = nil)
  if valid_568066 != nil:
    section.add "api-version", valid_568066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568089: Call_RegistriesGetBuildSourceUploadUrl_567888;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the upload location for the user to be able to upload the source.
  ## 
  let valid = call_568089.validator(path, query, header, formData, body)
  let scheme = call_568089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568089.url(scheme.get, call_568089.host, call_568089.base,
                         call_568089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568089, url, valid)

proc call*(call_568160: Call_RegistriesGetBuildSourceUploadUrl_567888;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          registryName: string): Recallable =
  ## registriesGetBuildSourceUploadUrl
  ## Get the upload location for the user to be able to upload the source.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568161 = newJObject()
  var query_568163 = newJObject()
  add(path_568161, "resourceGroupName", newJString(resourceGroupName))
  add(query_568163, "api-version", newJString(apiVersion))
  add(path_568161, "subscriptionId", newJString(subscriptionId))
  add(path_568161, "registryName", newJString(registryName))
  result = call_568160.call(path_568161, query_568163, nil, nil, nil)

var registriesGetBuildSourceUploadUrl* = Call_RegistriesGetBuildSourceUploadUrl_567888(
    name: "registriesGetBuildSourceUploadUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/listBuildSourceUploadUrl",
    validator: validate_RegistriesGetBuildSourceUploadUrl_567889, base: "/",
    url: url_RegistriesGetBuildSourceUploadUrl_567890, schemes: {Scheme.Https})
type
  Call_RunsList_568202 = ref object of OpenApiRestCall_567666
proc url_RunsList_568204(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/runs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunsList_568203(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the runs for a registry.
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
  var valid_568206 = path.getOrDefault("resourceGroupName")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "resourceGroupName", valid_568206
  var valid_568207 = path.getOrDefault("subscriptionId")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "subscriptionId", valid_568207
  var valid_568208 = path.getOrDefault("registryName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "registryName", valid_568208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  ##   $top: JInt
  ##       : $top is supported for get list of runs, which limits the maximum number of runs to return.
  ##   $filter: JString
  ##          : The runs filter to apply on the operation. Arithmetic operators are not supported. The allowed string function is 'contains'. All logical operators except 'Not', 'Has', 'All' are allowed.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568209 = query.getOrDefault("api-version")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "api-version", valid_568209
  var valid_568210 = query.getOrDefault("$top")
  valid_568210 = validateParameter(valid_568210, JInt, required = false, default = nil)
  if valid_568210 != nil:
    section.add "$top", valid_568210
  var valid_568211 = query.getOrDefault("$filter")
  valid_568211 = validateParameter(valid_568211, JString, required = false,
                                 default = nil)
  if valid_568211 != nil:
    section.add "$filter", valid_568211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568212: Call_RunsList_568202; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the runs for a registry.
  ## 
  let valid = call_568212.validator(path, query, header, formData, body)
  let scheme = call_568212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568212.url(scheme.get, call_568212.host, call_568212.base,
                         call_568212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568212, url, valid)

proc call*(call_568213: Call_RunsList_568202; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## runsList
  ## Gets all the runs for a registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   Top: int
  ##      : $top is supported for get list of runs, which limits the maximum number of runs to return.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   Filter: string
  ##         : The runs filter to apply on the operation. Arithmetic operators are not supported. The allowed string function is 'contains'. All logical operators except 'Not', 'Has', 'All' are allowed.
  var path_568214 = newJObject()
  var query_568215 = newJObject()
  add(path_568214, "resourceGroupName", newJString(resourceGroupName))
  add(query_568215, "api-version", newJString(apiVersion))
  add(path_568214, "subscriptionId", newJString(subscriptionId))
  add(query_568215, "$top", newJInt(Top))
  add(path_568214, "registryName", newJString(registryName))
  add(query_568215, "$filter", newJString(Filter))
  result = call_568213.call(path_568214, query_568215, nil, nil, nil)

var runsList* = Call_RunsList_568202(name: "runsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/runs",
                                  validator: validate_RunsList_568203, base: "/",
                                  url: url_RunsList_568204,
                                  schemes: {Scheme.Https})
type
  Call_RunsGet_568216 = ref object of OpenApiRestCall_567666
proc url_RunsGet_568218(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunsGet_568217(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the detailed information for a given run.
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
  ##   runId: JString (required)
  ##        : The run ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568219 = path.getOrDefault("resourceGroupName")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "resourceGroupName", valid_568219
  var valid_568220 = path.getOrDefault("subscriptionId")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "subscriptionId", valid_568220
  var valid_568221 = path.getOrDefault("registryName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "registryName", valid_568221
  var valid_568222 = path.getOrDefault("runId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "runId", valid_568222
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

proc call*(call_568224: Call_RunsGet_568216; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the detailed information for a given run.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_RunsGet_568216; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string;
          runId: string): Recallable =
  ## runsGet
  ## Gets the detailed information for a given run.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   runId: string (required)
  ##        : The run ID.
  var path_568226 = newJObject()
  var query_568227 = newJObject()
  add(path_568226, "resourceGroupName", newJString(resourceGroupName))
  add(query_568227, "api-version", newJString(apiVersion))
  add(path_568226, "subscriptionId", newJString(subscriptionId))
  add(path_568226, "registryName", newJString(registryName))
  add(path_568226, "runId", newJString(runId))
  result = call_568225.call(path_568226, query_568227, nil, nil, nil)

var runsGet* = Call_RunsGet_568216(name: "runsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/runs/{runId}",
                                validator: validate_RunsGet_568217, base: "/",
                                url: url_RunsGet_568218, schemes: {Scheme.Https})
type
  Call_RunsUpdate_568228 = ref object of OpenApiRestCall_567666
proc url_RunsUpdate_568230(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunsUpdate_568229(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch the run properties.
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
  ##   runId: JString (required)
  ##        : The run ID.
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
  var valid_568234 = path.getOrDefault("runId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "runId", valid_568234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568235 = query.getOrDefault("api-version")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "api-version", valid_568235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   runUpdateParameters: JObject (required)
  ##                      : The run update properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568237: Call_RunsUpdate_568228; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch the run properties.
  ## 
  let valid = call_568237.validator(path, query, header, formData, body)
  let scheme = call_568237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568237.url(scheme.get, call_568237.host, call_568237.base,
                         call_568237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568237, url, valid)

proc call*(call_568238: Call_RunsUpdate_568228; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string;
          runId: string; runUpdateParameters: JsonNode): Recallable =
  ## runsUpdate
  ## Patch the run properties.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   runId: string (required)
  ##        : The run ID.
  ##   runUpdateParameters: JObject (required)
  ##                      : The run update properties.
  var path_568239 = newJObject()
  var query_568240 = newJObject()
  var body_568241 = newJObject()
  add(path_568239, "resourceGroupName", newJString(resourceGroupName))
  add(query_568240, "api-version", newJString(apiVersion))
  add(path_568239, "subscriptionId", newJString(subscriptionId))
  add(path_568239, "registryName", newJString(registryName))
  add(path_568239, "runId", newJString(runId))
  if runUpdateParameters != nil:
    body_568241 = runUpdateParameters
  result = call_568238.call(path_568239, query_568240, nil, nil, body_568241)

var runsUpdate* = Call_RunsUpdate_568228(name: "runsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/runs/{runId}",
                                      validator: validate_RunsUpdate_568229,
                                      base: "/", url: url_RunsUpdate_568230,
                                      schemes: {Scheme.Https})
type
  Call_RunsCancel_568242 = ref object of OpenApiRestCall_567666
proc url_RunsCancel_568244(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunsCancel_568243(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel an existing run.
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
  ##   runId: JString (required)
  ##        : The run ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568245 = path.getOrDefault("resourceGroupName")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "resourceGroupName", valid_568245
  var valid_568246 = path.getOrDefault("subscriptionId")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "subscriptionId", valid_568246
  var valid_568247 = path.getOrDefault("registryName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "registryName", valid_568247
  var valid_568248 = path.getOrDefault("runId")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "runId", valid_568248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_568250: Call_RunsCancel_568242; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel an existing run.
  ## 
  let valid = call_568250.validator(path, query, header, formData, body)
  let scheme = call_568250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568250.url(scheme.get, call_568250.host, call_568250.base,
                         call_568250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568250, url, valid)

proc call*(call_568251: Call_RunsCancel_568242; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string;
          runId: string): Recallable =
  ## runsCancel
  ## Cancel an existing run.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   runId: string (required)
  ##        : The run ID.
  var path_568252 = newJObject()
  var query_568253 = newJObject()
  add(path_568252, "resourceGroupName", newJString(resourceGroupName))
  add(query_568253, "api-version", newJString(apiVersion))
  add(path_568252, "subscriptionId", newJString(subscriptionId))
  add(path_568252, "registryName", newJString(registryName))
  add(path_568252, "runId", newJString(runId))
  result = call_568251.call(path_568252, query_568253, nil, nil, nil)

var runsCancel* = Call_RunsCancel_568242(name: "runsCancel",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/runs/{runId}/cancel",
                                      validator: validate_RunsCancel_568243,
                                      base: "/", url: url_RunsCancel_568244,
                                      schemes: {Scheme.Https})
type
  Call_RunsGetLogSasUrl_568254 = ref object of OpenApiRestCall_567666
proc url_RunsGetLogSasUrl_568256(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/listLogSasUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunsGetLogSasUrl_568255(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a link to download the run logs.
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
  ##   runId: JString (required)
  ##        : The run ID.
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
  var valid_568259 = path.getOrDefault("registryName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "registryName", valid_568259
  var valid_568260 = path.getOrDefault("runId")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "runId", valid_568260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568261 = query.getOrDefault("api-version")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "api-version", valid_568261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568262: Call_RunsGetLogSasUrl_568254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a link to download the run logs.
  ## 
  let valid = call_568262.validator(path, query, header, formData, body)
  let scheme = call_568262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568262.url(scheme.get, call_568262.host, call_568262.base,
                         call_568262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568262, url, valid)

proc call*(call_568263: Call_RunsGetLogSasUrl_568254; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string;
          runId: string): Recallable =
  ## runsGetLogSasUrl
  ## Gets a link to download the run logs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   runId: string (required)
  ##        : The run ID.
  var path_568264 = newJObject()
  var query_568265 = newJObject()
  add(path_568264, "resourceGroupName", newJString(resourceGroupName))
  add(query_568265, "api-version", newJString(apiVersion))
  add(path_568264, "subscriptionId", newJString(subscriptionId))
  add(path_568264, "registryName", newJString(registryName))
  add(path_568264, "runId", newJString(runId))
  result = call_568263.call(path_568264, query_568265, nil, nil, nil)

var runsGetLogSasUrl* = Call_RunsGetLogSasUrl_568254(name: "runsGetLogSasUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/runs/{runId}/listLogSasUrl",
    validator: validate_RunsGetLogSasUrl_568255, base: "/",
    url: url_RunsGetLogSasUrl_568256, schemes: {Scheme.Https})
type
  Call_RegistriesScheduleRun_568266 = ref object of OpenApiRestCall_567666
proc url_RegistriesScheduleRun_568268(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/scheduleRun")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesScheduleRun_568267(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Schedules a new run based on the request parameters and add it to the run queue.
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
  var valid_568269 = path.getOrDefault("resourceGroupName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "resourceGroupName", valid_568269
  var valid_568270 = path.getOrDefault("subscriptionId")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "subscriptionId", valid_568270
  var valid_568271 = path.getOrDefault("registryName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "registryName", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568272 = query.getOrDefault("api-version")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "api-version", valid_568272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   runRequest: JObject (required)
  ##             : The parameters of a run that needs to scheduled.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568274: Call_RegistriesScheduleRun_568266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Schedules a new run based on the request parameters and add it to the run queue.
  ## 
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_RegistriesScheduleRun_568266;
          resourceGroupName: string; apiVersion: string; runRequest: JsonNode;
          subscriptionId: string; registryName: string): Recallable =
  ## registriesScheduleRun
  ## Schedules a new run based on the request parameters and add it to the run queue.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   runRequest: JObject (required)
  ##             : The parameters of a run that needs to scheduled.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568276 = newJObject()
  var query_568277 = newJObject()
  var body_568278 = newJObject()
  add(path_568276, "resourceGroupName", newJString(resourceGroupName))
  add(query_568277, "api-version", newJString(apiVersion))
  if runRequest != nil:
    body_568278 = runRequest
  add(path_568276, "subscriptionId", newJString(subscriptionId))
  add(path_568276, "registryName", newJString(registryName))
  result = call_568275.call(path_568276, query_568277, nil, nil, body_568278)

var registriesScheduleRun* = Call_RegistriesScheduleRun_568266(
    name: "registriesScheduleRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/scheduleRun",
    validator: validate_RegistriesScheduleRun_568267, base: "/",
    url: url_RegistriesScheduleRun_568268, schemes: {Scheme.Https})
type
  Call_TasksList_568279 = ref object of OpenApiRestCall_567666
proc url_TasksList_568281(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksList_568280(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the tasks for a specified container registry.
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
  var valid_568282 = path.getOrDefault("resourceGroupName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "resourceGroupName", valid_568282
  var valid_568283 = path.getOrDefault("subscriptionId")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "subscriptionId", valid_568283
  var valid_568284 = path.getOrDefault("registryName")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "registryName", valid_568284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568285 = query.getOrDefault("api-version")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "api-version", valid_568285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568286: Call_TasksList_568279; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the tasks for a specified container registry.
  ## 
  let valid = call_568286.validator(path, query, header, formData, body)
  let scheme = call_568286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568286.url(scheme.get, call_568286.host, call_568286.base,
                         call_568286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568286, url, valid)

proc call*(call_568287: Call_TasksList_568279; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string): Recallable =
  ## tasksList
  ## Lists all the tasks for a specified container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568288 = newJObject()
  var query_568289 = newJObject()
  add(path_568288, "resourceGroupName", newJString(resourceGroupName))
  add(query_568289, "api-version", newJString(apiVersion))
  add(path_568288, "subscriptionId", newJString(subscriptionId))
  add(path_568288, "registryName", newJString(registryName))
  result = call_568287.call(path_568288, query_568289, nil, nil, nil)

var tasksList* = Call_TasksList_568279(name: "tasksList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/tasks",
                                    validator: validate_TasksList_568280,
                                    base: "/", url: url_TasksList_568281,
                                    schemes: {Scheme.Https})
type
  Call_TasksCreate_568302 = ref object of OpenApiRestCall_567666
proc url_TasksCreate_568304(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksCreate_568303(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task for a container registry with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   taskName: JString (required)
  ##           : The name of the container registry task.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568305 = path.getOrDefault("resourceGroupName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "resourceGroupName", valid_568305
  var valid_568306 = path.getOrDefault("subscriptionId")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "subscriptionId", valid_568306
  var valid_568307 = path.getOrDefault("taskName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "taskName", valid_568307
  var valid_568308 = path.getOrDefault("registryName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "registryName", valid_568308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568309 = query.getOrDefault("api-version")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "api-version", valid_568309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   taskCreateParameters: JObject (required)
  ##                       : The parameters for creating a task.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568311: Call_TasksCreate_568302; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task for a container registry with the specified parameters.
  ## 
  let valid = call_568311.validator(path, query, header, formData, body)
  let scheme = call_568311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568311.url(scheme.get, call_568311.host, call_568311.base,
                         call_568311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568311, url, valid)

proc call*(call_568312: Call_TasksCreate_568302; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; taskName: string;
          taskCreateParameters: JsonNode; registryName: string): Recallable =
  ## tasksCreate
  ## Creates a task for a container registry with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   taskName: string (required)
  ##           : The name of the container registry task.
  ##   taskCreateParameters: JObject (required)
  ##                       : The parameters for creating a task.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568313 = newJObject()
  var query_568314 = newJObject()
  var body_568315 = newJObject()
  add(path_568313, "resourceGroupName", newJString(resourceGroupName))
  add(query_568314, "api-version", newJString(apiVersion))
  add(path_568313, "subscriptionId", newJString(subscriptionId))
  add(path_568313, "taskName", newJString(taskName))
  if taskCreateParameters != nil:
    body_568315 = taskCreateParameters
  add(path_568313, "registryName", newJString(registryName))
  result = call_568312.call(path_568313, query_568314, nil, nil, body_568315)

var tasksCreate* = Call_TasksCreate_568302(name: "tasksCreate",
                                        meth: HttpMethod.HttpPut,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/tasks/{taskName}",
                                        validator: validate_TasksCreate_568303,
                                        base: "/", url: url_TasksCreate_568304,
                                        schemes: {Scheme.Https})
type
  Call_TasksGet_568290 = ref object of OpenApiRestCall_567666
proc url_TasksGet_568292(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksGet_568291(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the properties of a specified task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   taskName: JString (required)
  ##           : The name of the container registry task.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568293 = path.getOrDefault("resourceGroupName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "resourceGroupName", valid_568293
  var valid_568294 = path.getOrDefault("subscriptionId")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "subscriptionId", valid_568294
  var valid_568295 = path.getOrDefault("taskName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "taskName", valid_568295
  var valid_568296 = path.getOrDefault("registryName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "registryName", valid_568296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568297 = query.getOrDefault("api-version")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "api-version", valid_568297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568298: Call_TasksGet_568290; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the properties of a specified task.
  ## 
  let valid = call_568298.validator(path, query, header, formData, body)
  let scheme = call_568298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568298.url(scheme.get, call_568298.host, call_568298.base,
                         call_568298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568298, url, valid)

proc call*(call_568299: Call_TasksGet_568290; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; taskName: string;
          registryName: string): Recallable =
  ## tasksGet
  ## Get the properties of a specified task.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   taskName: string (required)
  ##           : The name of the container registry task.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568300 = newJObject()
  var query_568301 = newJObject()
  add(path_568300, "resourceGroupName", newJString(resourceGroupName))
  add(query_568301, "api-version", newJString(apiVersion))
  add(path_568300, "subscriptionId", newJString(subscriptionId))
  add(path_568300, "taskName", newJString(taskName))
  add(path_568300, "registryName", newJString(registryName))
  result = call_568299.call(path_568300, query_568301, nil, nil, nil)

var tasksGet* = Call_TasksGet_568290(name: "tasksGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/tasks/{taskName}",
                                  validator: validate_TasksGet_568291, base: "/",
                                  url: url_TasksGet_568292,
                                  schemes: {Scheme.Https})
type
  Call_TasksUpdate_568328 = ref object of OpenApiRestCall_567666
proc url_TasksUpdate_568330(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksUpdate_568329(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a task with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   taskName: JString (required)
  ##           : The name of the container registry task.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568331 = path.getOrDefault("resourceGroupName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "resourceGroupName", valid_568331
  var valid_568332 = path.getOrDefault("subscriptionId")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "subscriptionId", valid_568332
  var valid_568333 = path.getOrDefault("taskName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "taskName", valid_568333
  var valid_568334 = path.getOrDefault("registryName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "registryName", valid_568334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  ##   taskUpdateParameters: JObject (required)
  ##                       : The parameters for updating a task.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568337: Call_TasksUpdate_568328; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a task with the specified parameters.
  ## 
  let valid = call_568337.validator(path, query, header, formData, body)
  let scheme = call_568337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568337.url(scheme.get, call_568337.host, call_568337.base,
                         call_568337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568337, url, valid)

proc call*(call_568338: Call_TasksUpdate_568328; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; taskName: string;
          registryName: string; taskUpdateParameters: JsonNode): Recallable =
  ## tasksUpdate
  ## Updates a task with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   taskName: string (required)
  ##           : The name of the container registry task.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   taskUpdateParameters: JObject (required)
  ##                       : The parameters for updating a task.
  var path_568339 = newJObject()
  var query_568340 = newJObject()
  var body_568341 = newJObject()
  add(path_568339, "resourceGroupName", newJString(resourceGroupName))
  add(query_568340, "api-version", newJString(apiVersion))
  add(path_568339, "subscriptionId", newJString(subscriptionId))
  add(path_568339, "taskName", newJString(taskName))
  add(path_568339, "registryName", newJString(registryName))
  if taskUpdateParameters != nil:
    body_568341 = taskUpdateParameters
  result = call_568338.call(path_568339, query_568340, nil, nil, body_568341)

var tasksUpdate* = Call_TasksUpdate_568328(name: "tasksUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/tasks/{taskName}",
                                        validator: validate_TasksUpdate_568329,
                                        base: "/", url: url_TasksUpdate_568330,
                                        schemes: {Scheme.Https})
type
  Call_TasksDelete_568316 = ref object of OpenApiRestCall_567666
proc url_TasksDelete_568318(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksDelete_568317(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a specified task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   taskName: JString (required)
  ##           : The name of the container registry task.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568319 = path.getOrDefault("resourceGroupName")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "resourceGroupName", valid_568319
  var valid_568320 = path.getOrDefault("subscriptionId")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "subscriptionId", valid_568320
  var valid_568321 = path.getOrDefault("taskName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "taskName", valid_568321
  var valid_568322 = path.getOrDefault("registryName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "registryName", valid_568322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_568324: Call_TasksDelete_568316; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a specified task.
  ## 
  let valid = call_568324.validator(path, query, header, formData, body)
  let scheme = call_568324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568324.url(scheme.get, call_568324.host, call_568324.base,
                         call_568324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568324, url, valid)

proc call*(call_568325: Call_TasksDelete_568316; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; taskName: string;
          registryName: string): Recallable =
  ## tasksDelete
  ## Deletes a specified task.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   taskName: string (required)
  ##           : The name of the container registry task.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568326 = newJObject()
  var query_568327 = newJObject()
  add(path_568326, "resourceGroupName", newJString(resourceGroupName))
  add(query_568327, "api-version", newJString(apiVersion))
  add(path_568326, "subscriptionId", newJString(subscriptionId))
  add(path_568326, "taskName", newJString(taskName))
  add(path_568326, "registryName", newJString(registryName))
  result = call_568325.call(path_568326, query_568327, nil, nil, nil)

var tasksDelete* = Call_TasksDelete_568316(name: "tasksDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/tasks/{taskName}",
                                        validator: validate_TasksDelete_568317,
                                        base: "/", url: url_TasksDelete_568318,
                                        schemes: {Scheme.Https})
type
  Call_TasksGetDetails_568342 = ref object of OpenApiRestCall_567666
proc url_TasksGetDetails_568344(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName"),
               (kind: ConstantSegment, value: "/listDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksGetDetails_568343(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns a task with extended information that includes all secrets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   taskName: JString (required)
  ##           : The name of the container registry task.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568345 = path.getOrDefault("resourceGroupName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "resourceGroupName", valid_568345
  var valid_568346 = path.getOrDefault("subscriptionId")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "subscriptionId", valid_568346
  var valid_568347 = path.getOrDefault("taskName")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "taskName", valid_568347
  var valid_568348 = path.getOrDefault("registryName")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "registryName", valid_568348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_568350: Call_TasksGetDetails_568342; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a task with extended information that includes all secrets.
  ## 
  let valid = call_568350.validator(path, query, header, formData, body)
  let scheme = call_568350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568350.url(scheme.get, call_568350.host, call_568350.base,
                         call_568350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568350, url, valid)

proc call*(call_568351: Call_TasksGetDetails_568342; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; taskName: string;
          registryName: string): Recallable =
  ## tasksGetDetails
  ## Returns a task with extended information that includes all secrets.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   taskName: string (required)
  ##           : The name of the container registry task.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568352 = newJObject()
  var query_568353 = newJObject()
  add(path_568352, "resourceGroupName", newJString(resourceGroupName))
  add(query_568353, "api-version", newJString(apiVersion))
  add(path_568352, "subscriptionId", newJString(subscriptionId))
  add(path_568352, "taskName", newJString(taskName))
  add(path_568352, "registryName", newJString(registryName))
  result = call_568351.call(path_568352, query_568353, nil, nil, nil)

var tasksGetDetails* = Call_TasksGetDetails_568342(name: "tasksGetDetails",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/tasks/{taskName}/listDetails",
    validator: validate_TasksGetDetails_568343, base: "/", url: url_TasksGetDetails_568344,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
