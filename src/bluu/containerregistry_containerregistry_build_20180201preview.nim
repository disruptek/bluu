
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ContainerRegistryManagementClient
## version: 2018-02-01-preview
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
  macServiceName = "containerregistry-containerregistry_build"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BuildTasksList_567879 = ref object of OpenApiRestCall_567657
proc url_BuildTasksList_567881(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/buildTasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildTasksList_567880(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the build tasks for a specified container registry.
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
  var valid_568055 = path.getOrDefault("resourceGroupName")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "resourceGroupName", valid_568055
  var valid_568056 = path.getOrDefault("subscriptionId")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "subscriptionId", valid_568056
  var valid_568057 = path.getOrDefault("registryName")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "registryName", valid_568057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  ##   $skipToken: JString
  ##             : $skipToken is supported on get list of build tasks, which provides the next page in the list of tasks.
  ##   $filter: JString
  ##          : The build task filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568058 = query.getOrDefault("api-version")
  valid_568058 = validateParameter(valid_568058, JString, required = true,
                                 default = nil)
  if valid_568058 != nil:
    section.add "api-version", valid_568058
  var valid_568059 = query.getOrDefault("$skipToken")
  valid_568059 = validateParameter(valid_568059, JString, required = false,
                                 default = nil)
  if valid_568059 != nil:
    section.add "$skipToken", valid_568059
  var valid_568060 = query.getOrDefault("$filter")
  valid_568060 = validateParameter(valid_568060, JString, required = false,
                                 default = nil)
  if valid_568060 != nil:
    section.add "$filter", valid_568060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568083: Call_BuildTasksList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the build tasks for a specified container registry.
  ## 
  let valid = call_568083.validator(path, query, header, formData, body)
  let scheme = call_568083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568083.url(scheme.get, call_568083.host, call_568083.base,
                         call_568083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568083, url, valid)

proc call*(call_568154: Call_BuildTasksList_567879; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## buildTasksList
  ## Lists all the build tasks for a specified container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   SkipToken: string
  ##            : $skipToken is supported on get list of build tasks, which provides the next page in the list of tasks.
  ##   Filter: string
  ##         : The build task filter to apply on the operation.
  var path_568155 = newJObject()
  var query_568157 = newJObject()
  add(path_568155, "resourceGroupName", newJString(resourceGroupName))
  add(query_568157, "api-version", newJString(apiVersion))
  add(path_568155, "subscriptionId", newJString(subscriptionId))
  add(path_568155, "registryName", newJString(registryName))
  add(query_568157, "$skipToken", newJString(SkipToken))
  add(query_568157, "$filter", newJString(Filter))
  result = call_568154.call(path_568155, query_568157, nil, nil, nil)

var buildTasksList* = Call_BuildTasksList_567879(name: "buildTasksList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/buildTasks",
    validator: validate_BuildTasksList_567880, base: "/", url: url_BuildTasksList_567881,
    schemes: {Scheme.Https})
type
  Call_BuildTasksCreate_568208 = ref object of OpenApiRestCall_567657
proc url_BuildTasksCreate_568210(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "buildTaskName" in path, "`buildTaskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/buildTasks/"),
               (kind: VariableSegment, value: "buildTaskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildTasksCreate_568209(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates a build task for a container registry with the specified parameters.
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
  ##   buildTaskName: JString (required)
  ##                : The name of the container registry build task.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568211 = path.getOrDefault("resourceGroupName")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "resourceGroupName", valid_568211
  var valid_568212 = path.getOrDefault("subscriptionId")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "subscriptionId", valid_568212
  var valid_568213 = path.getOrDefault("registryName")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "registryName", valid_568213
  var valid_568214 = path.getOrDefault("buildTaskName")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "buildTaskName", valid_568214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568215 = query.getOrDefault("api-version")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "api-version", valid_568215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   buildTaskCreateParameters: JObject (required)
  ##                            : The parameters for creating a build task.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568217: Call_BuildTasksCreate_568208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a build task for a container registry with the specified parameters.
  ## 
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_BuildTasksCreate_568208; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          buildTaskCreateParameters: JsonNode; registryName: string;
          buildTaskName: string): Recallable =
  ## buildTasksCreate
  ## Creates a build task for a container registry with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   buildTaskCreateParameters: JObject (required)
  ##                            : The parameters for creating a build task.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   buildTaskName: string (required)
  ##                : The name of the container registry build task.
  var path_568219 = newJObject()
  var query_568220 = newJObject()
  var body_568221 = newJObject()
  add(path_568219, "resourceGroupName", newJString(resourceGroupName))
  add(query_568220, "api-version", newJString(apiVersion))
  add(path_568219, "subscriptionId", newJString(subscriptionId))
  if buildTaskCreateParameters != nil:
    body_568221 = buildTaskCreateParameters
  add(path_568219, "registryName", newJString(registryName))
  add(path_568219, "buildTaskName", newJString(buildTaskName))
  result = call_568218.call(path_568219, query_568220, nil, nil, body_568221)

var buildTasksCreate* = Call_BuildTasksCreate_568208(name: "buildTasksCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/buildTasks/{buildTaskName}",
    validator: validate_BuildTasksCreate_568209, base: "/",
    url: url_BuildTasksCreate_568210, schemes: {Scheme.Https})
type
  Call_BuildTasksGet_568196 = ref object of OpenApiRestCall_567657
proc url_BuildTasksGet_568198(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "buildTaskName" in path, "`buildTaskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/buildTasks/"),
               (kind: VariableSegment, value: "buildTaskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildTasksGet_568197(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the properties of a specified build task.
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
  ##   buildTaskName: JString (required)
  ##                : The name of the container registry build task.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568199 = path.getOrDefault("resourceGroupName")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "resourceGroupName", valid_568199
  var valid_568200 = path.getOrDefault("subscriptionId")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "subscriptionId", valid_568200
  var valid_568201 = path.getOrDefault("registryName")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "registryName", valid_568201
  var valid_568202 = path.getOrDefault("buildTaskName")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "buildTaskName", valid_568202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568203 = query.getOrDefault("api-version")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "api-version", valid_568203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568204: Call_BuildTasksGet_568196; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the properties of a specified build task.
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_BuildTasksGet_568196; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string;
          buildTaskName: string): Recallable =
  ## buildTasksGet
  ## Get the properties of a specified build task.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   buildTaskName: string (required)
  ##                : The name of the container registry build task.
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  add(path_568206, "resourceGroupName", newJString(resourceGroupName))
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "subscriptionId", newJString(subscriptionId))
  add(path_568206, "registryName", newJString(registryName))
  add(path_568206, "buildTaskName", newJString(buildTaskName))
  result = call_568205.call(path_568206, query_568207, nil, nil, nil)

var buildTasksGet* = Call_BuildTasksGet_568196(name: "buildTasksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/buildTasks/{buildTaskName}",
    validator: validate_BuildTasksGet_568197, base: "/", url: url_BuildTasksGet_568198,
    schemes: {Scheme.Https})
type
  Call_BuildTasksUpdate_568234 = ref object of OpenApiRestCall_567657
proc url_BuildTasksUpdate_568236(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "buildTaskName" in path, "`buildTaskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/buildTasks/"),
               (kind: VariableSegment, value: "buildTaskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildTasksUpdate_568235(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a build task with the specified parameters.
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
  ##   buildTaskName: JString (required)
  ##                : The name of the container registry build task.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568237 = path.getOrDefault("resourceGroupName")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "resourceGroupName", valid_568237
  var valid_568238 = path.getOrDefault("subscriptionId")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "subscriptionId", valid_568238
  var valid_568239 = path.getOrDefault("registryName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "registryName", valid_568239
  var valid_568240 = path.getOrDefault("buildTaskName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "buildTaskName", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568241 = query.getOrDefault("api-version")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "api-version", valid_568241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   buildTaskUpdateParameters: JObject (required)
  ##                            : The parameters for updating a build task.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568243: Call_BuildTasksUpdate_568234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a build task with the specified parameters.
  ## 
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_BuildTasksUpdate_568234; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string;
          buildTaskName: string; buildTaskUpdateParameters: JsonNode): Recallable =
  ## buildTasksUpdate
  ## Updates a build task with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   buildTaskName: string (required)
  ##                : The name of the container registry build task.
  ##   buildTaskUpdateParameters: JObject (required)
  ##                            : The parameters for updating a build task.
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  var body_568247 = newJObject()
  add(path_568245, "resourceGroupName", newJString(resourceGroupName))
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "subscriptionId", newJString(subscriptionId))
  add(path_568245, "registryName", newJString(registryName))
  add(path_568245, "buildTaskName", newJString(buildTaskName))
  if buildTaskUpdateParameters != nil:
    body_568247 = buildTaskUpdateParameters
  result = call_568244.call(path_568245, query_568246, nil, nil, body_568247)

var buildTasksUpdate* = Call_BuildTasksUpdate_568234(name: "buildTasksUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/buildTasks/{buildTaskName}",
    validator: validate_BuildTasksUpdate_568235, base: "/",
    url: url_BuildTasksUpdate_568236, schemes: {Scheme.Https})
type
  Call_BuildTasksDelete_568222 = ref object of OpenApiRestCall_567657
proc url_BuildTasksDelete_568224(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "buildTaskName" in path, "`buildTaskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/buildTasks/"),
               (kind: VariableSegment, value: "buildTaskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildTasksDelete_568223(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a specified build task.
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
  ##   buildTaskName: JString (required)
  ##                : The name of the container registry build task.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568225 = path.getOrDefault("resourceGroupName")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "resourceGroupName", valid_568225
  var valid_568226 = path.getOrDefault("subscriptionId")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "subscriptionId", valid_568226
  var valid_568227 = path.getOrDefault("registryName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "registryName", valid_568227
  var valid_568228 = path.getOrDefault("buildTaskName")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "buildTaskName", valid_568228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568229 = query.getOrDefault("api-version")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "api-version", valid_568229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568230: Call_BuildTasksDelete_568222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a specified build task.
  ## 
  let valid = call_568230.validator(path, query, header, formData, body)
  let scheme = call_568230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568230.url(scheme.get, call_568230.host, call_568230.base,
                         call_568230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568230, url, valid)

proc call*(call_568231: Call_BuildTasksDelete_568222; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string;
          buildTaskName: string): Recallable =
  ## buildTasksDelete
  ## Deletes a specified build task.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   buildTaskName: string (required)
  ##                : The name of the container registry build task.
  var path_568232 = newJObject()
  var query_568233 = newJObject()
  add(path_568232, "resourceGroupName", newJString(resourceGroupName))
  add(query_568233, "api-version", newJString(apiVersion))
  add(path_568232, "subscriptionId", newJString(subscriptionId))
  add(path_568232, "registryName", newJString(registryName))
  add(path_568232, "buildTaskName", newJString(buildTaskName))
  result = call_568231.call(path_568232, query_568233, nil, nil, nil)

var buildTasksDelete* = Call_BuildTasksDelete_568222(name: "buildTasksDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/buildTasks/{buildTaskName}",
    validator: validate_BuildTasksDelete_568223, base: "/",
    url: url_BuildTasksDelete_568224, schemes: {Scheme.Https})
type
  Call_BuildTasksListSourceRepositoryProperties_568248 = ref object of OpenApiRestCall_567657
proc url_BuildTasksListSourceRepositoryProperties_568250(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "buildTaskName" in path, "`buildTaskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/buildTasks/"),
               (kind: VariableSegment, value: "buildTaskName"), (
        kind: ConstantSegment, value: "/listSourceRepositoryProperties")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildTasksListSourceRepositoryProperties_568249(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the source control properties for a build task.
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
  ##   buildTaskName: JString (required)
  ##                : The name of the container registry build task.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  var valid_568253 = path.getOrDefault("registryName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "registryName", valid_568253
  var valid_568254 = path.getOrDefault("buildTaskName")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "buildTaskName", valid_568254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568255 = query.getOrDefault("api-version")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "api-version", valid_568255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568256: Call_BuildTasksListSourceRepositoryProperties_568248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the source control properties for a build task.
  ## 
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_BuildTasksListSourceRepositoryProperties_568248;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          registryName: string; buildTaskName: string): Recallable =
  ## buildTasksListSourceRepositoryProperties
  ## Get the source control properties for a build task.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   buildTaskName: string (required)
  ##                : The name of the container registry build task.
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  add(path_568258, "resourceGroupName", newJString(resourceGroupName))
  add(query_568259, "api-version", newJString(apiVersion))
  add(path_568258, "subscriptionId", newJString(subscriptionId))
  add(path_568258, "registryName", newJString(registryName))
  add(path_568258, "buildTaskName", newJString(buildTaskName))
  result = call_568257.call(path_568258, query_568259, nil, nil, nil)

var buildTasksListSourceRepositoryProperties* = Call_BuildTasksListSourceRepositoryProperties_568248(
    name: "buildTasksListSourceRepositoryProperties", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/buildTasks/{buildTaskName}/listSourceRepositoryProperties",
    validator: validate_BuildTasksListSourceRepositoryProperties_568249,
    base: "/", url: url_BuildTasksListSourceRepositoryProperties_568250,
    schemes: {Scheme.Https})
type
  Call_BuildStepsList_568260 = ref object of OpenApiRestCall_567657
proc url_BuildStepsList_568262(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "buildTaskName" in path, "`buildTaskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/buildTasks/"),
               (kind: VariableSegment, value: "buildTaskName"),
               (kind: ConstantSegment, value: "/steps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildStepsList_568261(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List all the build steps for a given build task.
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
  ##   buildTaskName: JString (required)
  ##                : The name of the container registry build task.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568263 = path.getOrDefault("resourceGroupName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "resourceGroupName", valid_568263
  var valid_568264 = path.getOrDefault("subscriptionId")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "subscriptionId", valid_568264
  var valid_568265 = path.getOrDefault("registryName")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "registryName", valid_568265
  var valid_568266 = path.getOrDefault("buildTaskName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "buildTaskName", valid_568266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568267 = query.getOrDefault("api-version")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "api-version", valid_568267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568268: Call_BuildStepsList_568260; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the build steps for a given build task.
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_BuildStepsList_568260; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string;
          buildTaskName: string): Recallable =
  ## buildStepsList
  ## List all the build steps for a given build task.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   buildTaskName: string (required)
  ##                : The name of the container registry build task.
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  add(path_568270, "resourceGroupName", newJString(resourceGroupName))
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "subscriptionId", newJString(subscriptionId))
  add(path_568270, "registryName", newJString(registryName))
  add(path_568270, "buildTaskName", newJString(buildTaskName))
  result = call_568269.call(path_568270, query_568271, nil, nil, nil)

var buildStepsList* = Call_BuildStepsList_568260(name: "buildStepsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/buildTasks/{buildTaskName}/steps",
    validator: validate_BuildStepsList_568261, base: "/", url: url_BuildStepsList_568262,
    schemes: {Scheme.Https})
type
  Call_BuildStepsCreate_568285 = ref object of OpenApiRestCall_567657
proc url_BuildStepsCreate_568287(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "buildTaskName" in path, "`buildTaskName` is a required path parameter"
  assert "stepName" in path, "`stepName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/buildTasks/"),
               (kind: VariableSegment, value: "buildTaskName"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildStepsCreate_568286(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates a build step for a build task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   stepName: JString (required)
  ##           : The name of a build step for a container registry build task.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  ##   buildTaskName: JString (required)
  ##                : The name of the container registry build task.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568288 = path.getOrDefault("resourceGroupName")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "resourceGroupName", valid_568288
  var valid_568289 = path.getOrDefault("stepName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "stepName", valid_568289
  var valid_568290 = path.getOrDefault("subscriptionId")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "subscriptionId", valid_568290
  var valid_568291 = path.getOrDefault("registryName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "registryName", valid_568291
  var valid_568292 = path.getOrDefault("buildTaskName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "buildTaskName", valid_568292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568293 = query.getOrDefault("api-version")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "api-version", valid_568293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   buildStepCreateParameters: JObject (required)
  ##                            : The parameters for creating a build step.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568295: Call_BuildStepsCreate_568285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a build step for a build task.
  ## 
  let valid = call_568295.validator(path, query, header, formData, body)
  let scheme = call_568295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568295.url(scheme.get, call_568295.host, call_568295.base,
                         call_568295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568295, url, valid)

proc call*(call_568296: Call_BuildStepsCreate_568285; resourceGroupName: string;
          apiVersion: string; stepName: string; subscriptionId: string;
          buildStepCreateParameters: JsonNode; registryName: string;
          buildTaskName: string): Recallable =
  ## buildStepsCreate
  ## Creates a build step for a build task.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   stepName: string (required)
  ##           : The name of a build step for a container registry build task.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   buildStepCreateParameters: JObject (required)
  ##                            : The parameters for creating a build step.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   buildTaskName: string (required)
  ##                : The name of the container registry build task.
  var path_568297 = newJObject()
  var query_568298 = newJObject()
  var body_568299 = newJObject()
  add(path_568297, "resourceGroupName", newJString(resourceGroupName))
  add(query_568298, "api-version", newJString(apiVersion))
  add(path_568297, "stepName", newJString(stepName))
  add(path_568297, "subscriptionId", newJString(subscriptionId))
  if buildStepCreateParameters != nil:
    body_568299 = buildStepCreateParameters
  add(path_568297, "registryName", newJString(registryName))
  add(path_568297, "buildTaskName", newJString(buildTaskName))
  result = call_568296.call(path_568297, query_568298, nil, nil, body_568299)

var buildStepsCreate* = Call_BuildStepsCreate_568285(name: "buildStepsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/buildTasks/{buildTaskName}/steps/{stepName}",
    validator: validate_BuildStepsCreate_568286, base: "/",
    url: url_BuildStepsCreate_568287, schemes: {Scheme.Https})
type
  Call_BuildStepsGet_568272 = ref object of OpenApiRestCall_567657
proc url_BuildStepsGet_568274(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "buildTaskName" in path, "`buildTaskName` is a required path parameter"
  assert "stepName" in path, "`stepName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/buildTasks/"),
               (kind: VariableSegment, value: "buildTaskName"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildStepsGet_568273(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the build step for a build task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   stepName: JString (required)
  ##           : The name of a build step for a container registry build task.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  ##   buildTaskName: JString (required)
  ##                : The name of the container registry build task.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568275 = path.getOrDefault("resourceGroupName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "resourceGroupName", valid_568275
  var valid_568276 = path.getOrDefault("stepName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "stepName", valid_568276
  var valid_568277 = path.getOrDefault("subscriptionId")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "subscriptionId", valid_568277
  var valid_568278 = path.getOrDefault("registryName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "registryName", valid_568278
  var valid_568279 = path.getOrDefault("buildTaskName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "buildTaskName", valid_568279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568280 = query.getOrDefault("api-version")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "api-version", valid_568280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568281: Call_BuildStepsGet_568272; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the build step for a build task.
  ## 
  let valid = call_568281.validator(path, query, header, formData, body)
  let scheme = call_568281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568281.url(scheme.get, call_568281.host, call_568281.base,
                         call_568281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568281, url, valid)

proc call*(call_568282: Call_BuildStepsGet_568272; resourceGroupName: string;
          apiVersion: string; stepName: string; subscriptionId: string;
          registryName: string; buildTaskName: string): Recallable =
  ## buildStepsGet
  ## Gets the build step for a build task.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   stepName: string (required)
  ##           : The name of a build step for a container registry build task.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   buildTaskName: string (required)
  ##                : The name of the container registry build task.
  var path_568283 = newJObject()
  var query_568284 = newJObject()
  add(path_568283, "resourceGroupName", newJString(resourceGroupName))
  add(query_568284, "api-version", newJString(apiVersion))
  add(path_568283, "stepName", newJString(stepName))
  add(path_568283, "subscriptionId", newJString(subscriptionId))
  add(path_568283, "registryName", newJString(registryName))
  add(path_568283, "buildTaskName", newJString(buildTaskName))
  result = call_568282.call(path_568283, query_568284, nil, nil, nil)

var buildStepsGet* = Call_BuildStepsGet_568272(name: "buildStepsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/buildTasks/{buildTaskName}/steps/{stepName}",
    validator: validate_BuildStepsGet_568273, base: "/", url: url_BuildStepsGet_568274,
    schemes: {Scheme.Https})
type
  Call_BuildStepsUpdate_568313 = ref object of OpenApiRestCall_567657
proc url_BuildStepsUpdate_568315(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "buildTaskName" in path, "`buildTaskName` is a required path parameter"
  assert "stepName" in path, "`stepName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/buildTasks/"),
               (kind: VariableSegment, value: "buildTaskName"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildStepsUpdate_568314(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a build step in a build task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   stepName: JString (required)
  ##           : The name of a build step for a container registry build task.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  ##   buildTaskName: JString (required)
  ##                : The name of the container registry build task.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568316 = path.getOrDefault("resourceGroupName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "resourceGroupName", valid_568316
  var valid_568317 = path.getOrDefault("stepName")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "stepName", valid_568317
  var valid_568318 = path.getOrDefault("subscriptionId")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "subscriptionId", valid_568318
  var valid_568319 = path.getOrDefault("registryName")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "registryName", valid_568319
  var valid_568320 = path.getOrDefault("buildTaskName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "buildTaskName", valid_568320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568321 = query.getOrDefault("api-version")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "api-version", valid_568321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   buildStepUpdateParameters: JObject (required)
  ##                            : The parameters for updating a build step.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568323: Call_BuildStepsUpdate_568313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a build step in a build task.
  ## 
  let valid = call_568323.validator(path, query, header, formData, body)
  let scheme = call_568323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568323.url(scheme.get, call_568323.host, call_568323.base,
                         call_568323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568323, url, valid)

proc call*(call_568324: Call_BuildStepsUpdate_568313; resourceGroupName: string;
          apiVersion: string; stepName: string; subscriptionId: string;
          registryName: string; buildTaskName: string;
          buildStepUpdateParameters: JsonNode): Recallable =
  ## buildStepsUpdate
  ## Updates a build step in a build task.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   stepName: string (required)
  ##           : The name of a build step for a container registry build task.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   buildTaskName: string (required)
  ##                : The name of the container registry build task.
  ##   buildStepUpdateParameters: JObject (required)
  ##                            : The parameters for updating a build step.
  var path_568325 = newJObject()
  var query_568326 = newJObject()
  var body_568327 = newJObject()
  add(path_568325, "resourceGroupName", newJString(resourceGroupName))
  add(query_568326, "api-version", newJString(apiVersion))
  add(path_568325, "stepName", newJString(stepName))
  add(path_568325, "subscriptionId", newJString(subscriptionId))
  add(path_568325, "registryName", newJString(registryName))
  add(path_568325, "buildTaskName", newJString(buildTaskName))
  if buildStepUpdateParameters != nil:
    body_568327 = buildStepUpdateParameters
  result = call_568324.call(path_568325, query_568326, nil, nil, body_568327)

var buildStepsUpdate* = Call_BuildStepsUpdate_568313(name: "buildStepsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/buildTasks/{buildTaskName}/steps/{stepName}",
    validator: validate_BuildStepsUpdate_568314, base: "/",
    url: url_BuildStepsUpdate_568315, schemes: {Scheme.Https})
type
  Call_BuildStepsDelete_568300 = ref object of OpenApiRestCall_567657
proc url_BuildStepsDelete_568302(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "buildTaskName" in path, "`buildTaskName` is a required path parameter"
  assert "stepName" in path, "`stepName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/buildTasks/"),
               (kind: VariableSegment, value: "buildTaskName"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildStepsDelete_568301(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a build step from the build task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   stepName: JString (required)
  ##           : The name of a build step for a container registry build task.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  ##   buildTaskName: JString (required)
  ##                : The name of the container registry build task.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568303 = path.getOrDefault("resourceGroupName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "resourceGroupName", valid_568303
  var valid_568304 = path.getOrDefault("stepName")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "stepName", valid_568304
  var valid_568305 = path.getOrDefault("subscriptionId")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "subscriptionId", valid_568305
  var valid_568306 = path.getOrDefault("registryName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "registryName", valid_568306
  var valid_568307 = path.getOrDefault("buildTaskName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "buildTaskName", valid_568307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568308 = query.getOrDefault("api-version")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "api-version", valid_568308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568309: Call_BuildStepsDelete_568300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a build step from the build task.
  ## 
  let valid = call_568309.validator(path, query, header, formData, body)
  let scheme = call_568309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568309.url(scheme.get, call_568309.host, call_568309.base,
                         call_568309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568309, url, valid)

proc call*(call_568310: Call_BuildStepsDelete_568300; resourceGroupName: string;
          apiVersion: string; stepName: string; subscriptionId: string;
          registryName: string; buildTaskName: string): Recallable =
  ## buildStepsDelete
  ## Deletes a build step from the build task.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   stepName: string (required)
  ##           : The name of a build step for a container registry build task.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   buildTaskName: string (required)
  ##                : The name of the container registry build task.
  var path_568311 = newJObject()
  var query_568312 = newJObject()
  add(path_568311, "resourceGroupName", newJString(resourceGroupName))
  add(query_568312, "api-version", newJString(apiVersion))
  add(path_568311, "stepName", newJString(stepName))
  add(path_568311, "subscriptionId", newJString(subscriptionId))
  add(path_568311, "registryName", newJString(registryName))
  add(path_568311, "buildTaskName", newJString(buildTaskName))
  result = call_568310.call(path_568311, query_568312, nil, nil, nil)

var buildStepsDelete* = Call_BuildStepsDelete_568300(name: "buildStepsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/buildTasks/{buildTaskName}/steps/{stepName}",
    validator: validate_BuildStepsDelete_568301, base: "/",
    url: url_BuildStepsDelete_568302, schemes: {Scheme.Https})
type
  Call_BuildStepsListBuildArguments_568328 = ref object of OpenApiRestCall_567657
proc url_BuildStepsListBuildArguments_568330(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "buildTaskName" in path, "`buildTaskName` is a required path parameter"
  assert "stepName" in path, "`stepName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/buildTasks/"),
               (kind: VariableSegment, value: "buildTaskName"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepName"),
               (kind: ConstantSegment, value: "/listBuildArguments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildStepsListBuildArguments_568329(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the build arguments for a step including the secret arguments.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   stepName: JString (required)
  ##           : The name of a build step for a container registry build task.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  ##   buildTaskName: JString (required)
  ##                : The name of the container registry build task.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568331 = path.getOrDefault("resourceGroupName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "resourceGroupName", valid_568331
  var valid_568332 = path.getOrDefault("stepName")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "stepName", valid_568332
  var valid_568333 = path.getOrDefault("subscriptionId")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "subscriptionId", valid_568333
  var valid_568334 = path.getOrDefault("registryName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "registryName", valid_568334
  var valid_568335 = path.getOrDefault("buildTaskName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "buildTaskName", valid_568335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568336 = query.getOrDefault("api-version")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "api-version", valid_568336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568337: Call_BuildStepsListBuildArguments_568328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the build arguments for a step including the secret arguments.
  ## 
  let valid = call_568337.validator(path, query, header, formData, body)
  let scheme = call_568337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568337.url(scheme.get, call_568337.host, call_568337.base,
                         call_568337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568337, url, valid)

proc call*(call_568338: Call_BuildStepsListBuildArguments_568328;
          resourceGroupName: string; apiVersion: string; stepName: string;
          subscriptionId: string; registryName: string; buildTaskName: string): Recallable =
  ## buildStepsListBuildArguments
  ## List the build arguments for a step including the secret arguments.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   stepName: string (required)
  ##           : The name of a build step for a container registry build task.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   buildTaskName: string (required)
  ##                : The name of the container registry build task.
  var path_568339 = newJObject()
  var query_568340 = newJObject()
  add(path_568339, "resourceGroupName", newJString(resourceGroupName))
  add(query_568340, "api-version", newJString(apiVersion))
  add(path_568339, "stepName", newJString(stepName))
  add(path_568339, "subscriptionId", newJString(subscriptionId))
  add(path_568339, "registryName", newJString(registryName))
  add(path_568339, "buildTaskName", newJString(buildTaskName))
  result = call_568338.call(path_568339, query_568340, nil, nil, nil)

var buildStepsListBuildArguments* = Call_BuildStepsListBuildArguments_568328(
    name: "buildStepsListBuildArguments", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/buildTasks/{buildTaskName}/steps/{stepName}/listBuildArguments",
    validator: validate_BuildStepsListBuildArguments_568329, base: "/",
    url: url_BuildStepsListBuildArguments_568330, schemes: {Scheme.Https})
type
  Call_BuildsList_568341 = ref object of OpenApiRestCall_567657
proc url_BuildsList_568343(protocol: Scheme; host: string; base: string; route: string;
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
               (kind: ConstantSegment, value: "/builds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildsList_568342(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the builds for a registry.
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
  var valid_568344 = path.getOrDefault("resourceGroupName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "resourceGroupName", valid_568344
  var valid_568345 = path.getOrDefault("subscriptionId")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "subscriptionId", valid_568345
  var valid_568346 = path.getOrDefault("registryName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "registryName", valid_568346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  ##   $top: JInt
  ##       : $top is supported for get list of builds, which limits the maximum number of builds to return.
  ##   $skipToken: JString
  ##             : $skipToken is supported on get list of builds, which provides the next page in the list of builds.
  ##   $filter: JString
  ##          : The builds filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568347 = query.getOrDefault("api-version")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "api-version", valid_568347
  var valid_568348 = query.getOrDefault("$top")
  valid_568348 = validateParameter(valid_568348, JInt, required = false, default = nil)
  if valid_568348 != nil:
    section.add "$top", valid_568348
  var valid_568349 = query.getOrDefault("$skipToken")
  valid_568349 = validateParameter(valid_568349, JString, required = false,
                                 default = nil)
  if valid_568349 != nil:
    section.add "$skipToken", valid_568349
  var valid_568350 = query.getOrDefault("$filter")
  valid_568350 = validateParameter(valid_568350, JString, required = false,
                                 default = nil)
  if valid_568350 != nil:
    section.add "$filter", valid_568350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568351: Call_BuildsList_568341; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the builds for a registry.
  ## 
  let valid = call_568351.validator(path, query, header, formData, body)
  let scheme = call_568351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568351.url(scheme.get, call_568351.host, call_568351.base,
                         call_568351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568351, url, valid)

proc call*(call_568352: Call_BuildsList_568341; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string;
          Top: int = 0; SkipToken: string = ""; Filter: string = ""): Recallable =
  ## buildsList
  ## Gets all the builds for a registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   Top: int
  ##      : $top is supported for get list of builds, which limits the maximum number of builds to return.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   SkipToken: string
  ##            : $skipToken is supported on get list of builds, which provides the next page in the list of builds.
  ##   Filter: string
  ##         : The builds filter to apply on the operation.
  var path_568353 = newJObject()
  var query_568354 = newJObject()
  add(path_568353, "resourceGroupName", newJString(resourceGroupName))
  add(query_568354, "api-version", newJString(apiVersion))
  add(path_568353, "subscriptionId", newJString(subscriptionId))
  add(query_568354, "$top", newJInt(Top))
  add(path_568353, "registryName", newJString(registryName))
  add(query_568354, "$skipToken", newJString(SkipToken))
  add(query_568354, "$filter", newJString(Filter))
  result = call_568352.call(path_568353, query_568354, nil, nil, nil)

var buildsList* = Call_BuildsList_568341(name: "buildsList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/builds",
                                      validator: validate_BuildsList_568342,
                                      base: "/", url: url_BuildsList_568343,
                                      schemes: {Scheme.Https})
type
  Call_BuildsGet_568355 = ref object of OpenApiRestCall_567657
proc url_BuildsGet_568357(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "buildId" in path, "`buildId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/builds/"),
               (kind: VariableSegment, value: "buildId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildsGet_568356(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the detailed information for a given build.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   buildId: JString (required)
  ##          : The build ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568358 = path.getOrDefault("resourceGroupName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "resourceGroupName", valid_568358
  var valid_568359 = path.getOrDefault("subscriptionId")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "subscriptionId", valid_568359
  var valid_568360 = path.getOrDefault("buildId")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "buildId", valid_568360
  var valid_568361 = path.getOrDefault("registryName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "registryName", valid_568361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568362 = query.getOrDefault("api-version")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "api-version", valid_568362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568363: Call_BuildsGet_568355; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the detailed information for a given build.
  ## 
  let valid = call_568363.validator(path, query, header, formData, body)
  let scheme = call_568363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568363.url(scheme.get, call_568363.host, call_568363.base,
                         call_568363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568363, url, valid)

proc call*(call_568364: Call_BuildsGet_568355; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; buildId: string;
          registryName: string): Recallable =
  ## buildsGet
  ## Gets the detailed information for a given build.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   buildId: string (required)
  ##          : The build ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568365 = newJObject()
  var query_568366 = newJObject()
  add(path_568365, "resourceGroupName", newJString(resourceGroupName))
  add(query_568366, "api-version", newJString(apiVersion))
  add(path_568365, "subscriptionId", newJString(subscriptionId))
  add(path_568365, "buildId", newJString(buildId))
  add(path_568365, "registryName", newJString(registryName))
  result = call_568364.call(path_568365, query_568366, nil, nil, nil)

var buildsGet* = Call_BuildsGet_568355(name: "buildsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/builds/{buildId}",
                                    validator: validate_BuildsGet_568356,
                                    base: "/", url: url_BuildsGet_568357,
                                    schemes: {Scheme.Https})
type
  Call_BuildsUpdate_568367 = ref object of OpenApiRestCall_567657
proc url_BuildsUpdate_568369(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "buildId" in path, "`buildId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/builds/"),
               (kind: VariableSegment, value: "buildId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildsUpdate_568368(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch the build properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   buildId: JString (required)
  ##          : The build ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568370 = path.getOrDefault("resourceGroupName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "resourceGroupName", valid_568370
  var valid_568371 = path.getOrDefault("subscriptionId")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "subscriptionId", valid_568371
  var valid_568372 = path.getOrDefault("buildId")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "buildId", valid_568372
  var valid_568373 = path.getOrDefault("registryName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "registryName", valid_568373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568374 = query.getOrDefault("api-version")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "api-version", valid_568374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   buildUpdateParameters: JObject (required)
  ##                        : The build update properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568376: Call_BuildsUpdate_568367; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch the build properties.
  ## 
  let valid = call_568376.validator(path, query, header, formData, body)
  let scheme = call_568376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568376.url(scheme.get, call_568376.host, call_568376.base,
                         call_568376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568376, url, valid)

proc call*(call_568377: Call_BuildsUpdate_568367; resourceGroupName: string;
          apiVersion: string; buildUpdateParameters: JsonNode;
          subscriptionId: string; buildId: string; registryName: string): Recallable =
  ## buildsUpdate
  ## Patch the build properties.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   buildUpdateParameters: JObject (required)
  ##                        : The build update properties.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   buildId: string (required)
  ##          : The build ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568378 = newJObject()
  var query_568379 = newJObject()
  var body_568380 = newJObject()
  add(path_568378, "resourceGroupName", newJString(resourceGroupName))
  add(query_568379, "api-version", newJString(apiVersion))
  if buildUpdateParameters != nil:
    body_568380 = buildUpdateParameters
  add(path_568378, "subscriptionId", newJString(subscriptionId))
  add(path_568378, "buildId", newJString(buildId))
  add(path_568378, "registryName", newJString(registryName))
  result = call_568377.call(path_568378, query_568379, nil, nil, body_568380)

var buildsUpdate* = Call_BuildsUpdate_568367(name: "buildsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/builds/{buildId}",
    validator: validate_BuildsUpdate_568368, base: "/", url: url_BuildsUpdate_568369,
    schemes: {Scheme.Https})
type
  Call_BuildsCancel_568381 = ref object of OpenApiRestCall_567657
proc url_BuildsCancel_568383(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "buildId" in path, "`buildId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/builds/"),
               (kind: VariableSegment, value: "buildId"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildsCancel_568382(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel an existing build.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   buildId: JString (required)
  ##          : The build ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  var valid_568386 = path.getOrDefault("buildId")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "buildId", valid_568386
  var valid_568387 = path.getOrDefault("registryName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "registryName", valid_568387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_568389: Call_BuildsCancel_568381; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel an existing build.
  ## 
  let valid = call_568389.validator(path, query, header, formData, body)
  let scheme = call_568389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568389.url(scheme.get, call_568389.host, call_568389.base,
                         call_568389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568389, url, valid)

proc call*(call_568390: Call_BuildsCancel_568381; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; buildId: string;
          registryName: string): Recallable =
  ## buildsCancel
  ## Cancel an existing build.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   buildId: string (required)
  ##          : The build ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568391 = newJObject()
  var query_568392 = newJObject()
  add(path_568391, "resourceGroupName", newJString(resourceGroupName))
  add(query_568392, "api-version", newJString(apiVersion))
  add(path_568391, "subscriptionId", newJString(subscriptionId))
  add(path_568391, "buildId", newJString(buildId))
  add(path_568391, "registryName", newJString(registryName))
  result = call_568390.call(path_568391, query_568392, nil, nil, nil)

var buildsCancel* = Call_BuildsCancel_568381(name: "buildsCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/builds/{buildId}/cancel",
    validator: validate_BuildsCancel_568382, base: "/", url: url_BuildsCancel_568383,
    schemes: {Scheme.Https})
type
  Call_BuildsGetLogLink_568393 = ref object of OpenApiRestCall_567657
proc url_BuildsGetLogLink_568395(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "buildId" in path, "`buildId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/builds/"),
               (kind: VariableSegment, value: "buildId"),
               (kind: ConstantSegment, value: "/getLogLink")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BuildsGetLogLink_568394(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a link to download the build logs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   buildId: JString (required)
  ##          : The build ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  var valid_568398 = path.getOrDefault("buildId")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "buildId", valid_568398
  var valid_568399 = path.getOrDefault("registryName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "registryName", valid_568399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_568401: Call_BuildsGetLogLink_568393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a link to download the build logs.
  ## 
  let valid = call_568401.validator(path, query, header, formData, body)
  let scheme = call_568401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568401.url(scheme.get, call_568401.host, call_568401.base,
                         call_568401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568401, url, valid)

proc call*(call_568402: Call_BuildsGetLogLink_568393; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; buildId: string;
          registryName: string): Recallable =
  ## buildsGetLogLink
  ## Gets a link to download the build logs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   buildId: string (required)
  ##          : The build ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568403 = newJObject()
  var query_568404 = newJObject()
  add(path_568403, "resourceGroupName", newJString(resourceGroupName))
  add(query_568404, "api-version", newJString(apiVersion))
  add(path_568403, "subscriptionId", newJString(subscriptionId))
  add(path_568403, "buildId", newJString(buildId))
  add(path_568403, "registryName", newJString(registryName))
  result = call_568402.call(path_568403, query_568404, nil, nil, nil)

var buildsGetLogLink* = Call_BuildsGetLogLink_568393(name: "buildsGetLogLink",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/builds/{buildId}/getLogLink",
    validator: validate_BuildsGetLogLink_568394, base: "/",
    url: url_BuildsGetLogLink_568395, schemes: {Scheme.Https})
type
  Call_RegistriesGetBuildSourceUploadUrl_568405 = ref object of OpenApiRestCall_567657
proc url_RegistriesGetBuildSourceUploadUrl_568407(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/getBuildSourceUploadUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesGetBuildSourceUploadUrl_568406(path: JsonNode;
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
  var valid_568410 = path.getOrDefault("registryName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "registryName", valid_568410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_568412: Call_RegistriesGetBuildSourceUploadUrl_568405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the upload location for the user to be able to upload the source.
  ## 
  let valid = call_568412.validator(path, query, header, formData, body)
  let scheme = call_568412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568412.url(scheme.get, call_568412.host, call_568412.base,
                         call_568412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568412, url, valid)

proc call*(call_568413: Call_RegistriesGetBuildSourceUploadUrl_568405;
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
  var path_568414 = newJObject()
  var query_568415 = newJObject()
  add(path_568414, "resourceGroupName", newJString(resourceGroupName))
  add(query_568415, "api-version", newJString(apiVersion))
  add(path_568414, "subscriptionId", newJString(subscriptionId))
  add(path_568414, "registryName", newJString(registryName))
  result = call_568413.call(path_568414, query_568415, nil, nil, nil)

var registriesGetBuildSourceUploadUrl* = Call_RegistriesGetBuildSourceUploadUrl_568405(
    name: "registriesGetBuildSourceUploadUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/getBuildSourceUploadUrl",
    validator: validate_RegistriesGetBuildSourceUploadUrl_568406, base: "/",
    url: url_RegistriesGetBuildSourceUploadUrl_568407, schemes: {Scheme.Https})
type
  Call_RegistriesQueueBuild_568416 = ref object of OpenApiRestCall_567657
proc url_RegistriesQueueBuild_568418(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/queueBuild")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesQueueBuild_568417(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new build based on the request parameters and add it to the build queue.
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
  var valid_568419 = path.getOrDefault("resourceGroupName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "resourceGroupName", valid_568419
  var valid_568420 = path.getOrDefault("subscriptionId")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "subscriptionId", valid_568420
  var valid_568421 = path.getOrDefault("registryName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "registryName", valid_568421
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568422 = query.getOrDefault("api-version")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "api-version", valid_568422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   buildRequest: JObject (required)
  ##               : The parameters of a build that needs to queued.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568424: Call_RegistriesQueueBuild_568416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new build based on the request parameters and add it to the build queue.
  ## 
  let valid = call_568424.validator(path, query, header, formData, body)
  let scheme = call_568424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568424.url(scheme.get, call_568424.host, call_568424.base,
                         call_568424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568424, url, valid)

proc call*(call_568425: Call_RegistriesQueueBuild_568416; buildRequest: JsonNode;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          registryName: string): Recallable =
  ## registriesQueueBuild
  ## Creates a new build based on the request parameters and add it to the build queue.
  ##   buildRequest: JObject (required)
  ##               : The parameters of a build that needs to queued.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_568426 = newJObject()
  var query_568427 = newJObject()
  var body_568428 = newJObject()
  if buildRequest != nil:
    body_568428 = buildRequest
  add(path_568426, "resourceGroupName", newJString(resourceGroupName))
  add(query_568427, "api-version", newJString(apiVersion))
  add(path_568426, "subscriptionId", newJString(subscriptionId))
  add(path_568426, "registryName", newJString(registryName))
  result = call_568425.call(path_568426, query_568427, nil, nil, body_568428)

var registriesQueueBuild* = Call_RegistriesQueueBuild_568416(
    name: "registriesQueueBuild", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/queueBuild",
    validator: validate_RegistriesQueueBuild_568417, base: "/",
    url: url_RegistriesQueueBuild_568418, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
