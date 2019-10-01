
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AzureDeploymentManager
## version: 2018-09-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## REST APIs for orchestrating deployments using the Azure Deployment Manager (ADM). See https://docs.microsoft.com/en-us/azure/azure-resource-manager/deployment-manager-overview for more information.
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
  macServiceName = "deploymentmanager"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsGet_567879 = ref object of OpenApiRestCall_567657
proc url_OperationsGet_567881(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DeploymentManager/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationsGet_567880(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568054 = path.getOrDefault("subscriptionId")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "subscriptionId", valid_568054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568055 = query.getOrDefault("api-version")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "api-version", valid_568055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568078: Call_OperationsGet_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568078.validator(path, query, header, formData, body)
  let scheme = call_568078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568078.url(scheme.get, call_568078.host, call_568078.base,
                         call_568078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568078, url, valid)

proc call*(call_568149: Call_OperationsGet_567879; apiVersion: string;
          subscriptionId: string): Recallable =
  ## operationsGet
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568150 = newJObject()
  var query_568152 = newJObject()
  add(query_568152, "api-version", newJString(apiVersion))
  add(path_568150, "subscriptionId", newJString(subscriptionId))
  result = call_568149.call(path_568150, query_568152, nil, nil, nil)

var operationsGet* = Call_OperationsGet_567879(name: "operationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DeploymentManager/operations",
    validator: validate_OperationsGet_567880, base: "", url: url_OperationsGet_567881,
    schemes: {Scheme.Https})
type
  Call_ArtifactSourcesCreateOrUpdate_568202 = ref object of OpenApiRestCall_567657
proc url_ArtifactSourcesCreateOrUpdate_568204(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/artifactSources/"),
               (kind: VariableSegment, value: "artifactSourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourcesCreateOrUpdate_568203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Synchronously creates a new artifact source or updates an existing artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568222 = path.getOrDefault("resourceGroupName")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "resourceGroupName", valid_568222
  var valid_568223 = path.getOrDefault("subscriptionId")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "subscriptionId", valid_568223
  var valid_568224 = path.getOrDefault("artifactSourceName")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "artifactSourceName", valid_568224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568225 = query.getOrDefault("api-version")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "api-version", valid_568225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactSourceInfo: JObject
  ##                     : Source object that defines the resource.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568227: Call_ArtifactSourcesCreateOrUpdate_568202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Synchronously creates a new artifact source or updates an existing artifact source.
  ## 
  let valid = call_568227.validator(path, query, header, formData, body)
  let scheme = call_568227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568227.url(scheme.get, call_568227.host, call_568227.base,
                         call_568227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568227, url, valid)

proc call*(call_568228: Call_ArtifactSourcesCreateOrUpdate_568202;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          artifactSourceName: string; artifactSourceInfo: JsonNode = nil): Recallable =
  ## artifactSourcesCreateOrUpdate
  ## Synchronously creates a new artifact source or updates an existing artifact source.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   artifactSourceInfo: JObject
  ##                     : Source object that defines the resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  var path_568229 = newJObject()
  var query_568230 = newJObject()
  var body_568231 = newJObject()
  add(path_568229, "resourceGroupName", newJString(resourceGroupName))
  if artifactSourceInfo != nil:
    body_568231 = artifactSourceInfo
  add(query_568230, "api-version", newJString(apiVersion))
  add(path_568229, "subscriptionId", newJString(subscriptionId))
  add(path_568229, "artifactSourceName", newJString(artifactSourceName))
  result = call_568228.call(path_568229, query_568230, nil, nil, body_568231)

var artifactSourcesCreateOrUpdate* = Call_ArtifactSourcesCreateOrUpdate_568202(
    name: "artifactSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/artifactSources/{artifactSourceName}",
    validator: validate_ArtifactSourcesCreateOrUpdate_568203, base: "",
    url: url_ArtifactSourcesCreateOrUpdate_568204, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesGet_568191 = ref object of OpenApiRestCall_567657
proc url_ArtifactSourcesGet_568193(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/artifactSources/"),
               (kind: VariableSegment, value: "artifactSourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourcesGet_568192(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568194 = path.getOrDefault("resourceGroupName")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "resourceGroupName", valid_568194
  var valid_568195 = path.getOrDefault("subscriptionId")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "subscriptionId", valid_568195
  var valid_568196 = path.getOrDefault("artifactSourceName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "artifactSourceName", valid_568196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568197 = query.getOrDefault("api-version")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "api-version", valid_568197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568198: Call_ArtifactSourcesGet_568191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568198.validator(path, query, header, formData, body)
  let scheme = call_568198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568198.url(scheme.get, call_568198.host, call_568198.base,
                         call_568198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568198, url, valid)

proc call*(call_568199: Call_ArtifactSourcesGet_568191; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; artifactSourceName: string): Recallable =
  ## artifactSourcesGet
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  var path_568200 = newJObject()
  var query_568201 = newJObject()
  add(path_568200, "resourceGroupName", newJString(resourceGroupName))
  add(query_568201, "api-version", newJString(apiVersion))
  add(path_568200, "subscriptionId", newJString(subscriptionId))
  add(path_568200, "artifactSourceName", newJString(artifactSourceName))
  result = call_568199.call(path_568200, query_568201, nil, nil, nil)

var artifactSourcesGet* = Call_ArtifactSourcesGet_568191(
    name: "artifactSourcesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/artifactSources/{artifactSourceName}",
    validator: validate_ArtifactSourcesGet_568192, base: "",
    url: url_ArtifactSourcesGet_568193, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesDelete_568232 = ref object of OpenApiRestCall_567657
proc url_ArtifactSourcesDelete_568234(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/artifactSources/"),
               (kind: VariableSegment, value: "artifactSourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourcesDelete_568233(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568235 = path.getOrDefault("resourceGroupName")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "resourceGroupName", valid_568235
  var valid_568236 = path.getOrDefault("subscriptionId")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "subscriptionId", valid_568236
  var valid_568237 = path.getOrDefault("artifactSourceName")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "artifactSourceName", valid_568237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568238 = query.getOrDefault("api-version")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "api-version", valid_568238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568239: Call_ArtifactSourcesDelete_568232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568239.validator(path, query, header, formData, body)
  let scheme = call_568239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568239.url(scheme.get, call_568239.host, call_568239.base,
                         call_568239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568239, url, valid)

proc call*(call_568240: Call_ArtifactSourcesDelete_568232;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          artifactSourceName: string): Recallable =
  ## artifactSourcesDelete
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  var path_568241 = newJObject()
  var query_568242 = newJObject()
  add(path_568241, "resourceGroupName", newJString(resourceGroupName))
  add(query_568242, "api-version", newJString(apiVersion))
  add(path_568241, "subscriptionId", newJString(subscriptionId))
  add(path_568241, "artifactSourceName", newJString(artifactSourceName))
  result = call_568240.call(path_568241, query_568242, nil, nil, nil)

var artifactSourcesDelete* = Call_ArtifactSourcesDelete_568232(
    name: "artifactSourcesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/artifactSources/{artifactSourceName}",
    validator: validate_ArtifactSourcesDelete_568233, base: "",
    url: url_ArtifactSourcesDelete_568234, schemes: {Scheme.Https})
type
  Call_RolloutsCreateOrUpdate_568255 = ref object of OpenApiRestCall_567657
proc url_RolloutsCreateOrUpdate_568257(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "rolloutName" in path, "`rolloutName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/rollouts/"),
               (kind: VariableSegment, value: "rolloutName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RolloutsCreateOrUpdate_568256(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This is an asynchronous operation and can be polled to completion using the location header returned by this operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rolloutName: JString (required)
  ##              : The rollout name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rolloutName` field"
  var valid_568258 = path.getOrDefault("rolloutName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "rolloutName", valid_568258
  var valid_568259 = path.getOrDefault("resourceGroupName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "resourceGroupName", valid_568259
  var valid_568260 = path.getOrDefault("subscriptionId")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "subscriptionId", valid_568260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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
  ## parameters in `body` object:
  ##   rolloutRequest: JObject
  ##                 : Source rollout request object that defines the rollout.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568263: Call_RolloutsCreateOrUpdate_568255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This is an asynchronous operation and can be polled to completion using the location header returned by this operation.
  ## 
  let valid = call_568263.validator(path, query, header, formData, body)
  let scheme = call_568263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568263.url(scheme.get, call_568263.host, call_568263.base,
                         call_568263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568263, url, valid)

proc call*(call_568264: Call_RolloutsCreateOrUpdate_568255; rolloutName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          rolloutRequest: JsonNode = nil): Recallable =
  ## rolloutsCreateOrUpdate
  ## This is an asynchronous operation and can be polled to completion using the location header returned by this operation.
  ##   rolloutName: string (required)
  ##              : The rollout name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   rolloutRequest: JObject
  ##                 : Source rollout request object that defines the rollout.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568265 = newJObject()
  var query_568266 = newJObject()
  var body_568267 = newJObject()
  add(path_568265, "rolloutName", newJString(rolloutName))
  add(path_568265, "resourceGroupName", newJString(resourceGroupName))
  add(query_568266, "api-version", newJString(apiVersion))
  if rolloutRequest != nil:
    body_568267 = rolloutRequest
  add(path_568265, "subscriptionId", newJString(subscriptionId))
  result = call_568264.call(path_568265, query_568266, nil, nil, body_568267)

var rolloutsCreateOrUpdate* = Call_RolloutsCreateOrUpdate_568255(
    name: "rolloutsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/rollouts/{rolloutName}",
    validator: validate_RolloutsCreateOrUpdate_568256, base: "",
    url: url_RolloutsCreateOrUpdate_568257, schemes: {Scheme.Https})
type
  Call_RolloutsGet_568243 = ref object of OpenApiRestCall_567657
proc url_RolloutsGet_568245(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "rolloutName" in path, "`rolloutName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/rollouts/"),
               (kind: VariableSegment, value: "rolloutName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RolloutsGet_568244(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rolloutName: JString (required)
  ##              : The rollout name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rolloutName` field"
  var valid_568246 = path.getOrDefault("rolloutName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "rolloutName", valid_568246
  var valid_568247 = path.getOrDefault("resourceGroupName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "resourceGroupName", valid_568247
  var valid_568248 = path.getOrDefault("subscriptionId")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "subscriptionId", valid_568248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   retryAttempt: JInt
  ##               : Rollout retry attempt ordinal to get the result of. If not specified, result of the latest attempt will be returned.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568249 = query.getOrDefault("api-version")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "api-version", valid_568249
  var valid_568250 = query.getOrDefault("retryAttempt")
  valid_568250 = validateParameter(valid_568250, JInt, required = false, default = nil)
  if valid_568250 != nil:
    section.add "retryAttempt", valid_568250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568251: Call_RolloutsGet_568243; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568251.validator(path, query, header, formData, body)
  let scheme = call_568251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568251.url(scheme.get, call_568251.host, call_568251.base,
                         call_568251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568251, url, valid)

proc call*(call_568252: Call_RolloutsGet_568243; rolloutName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          retryAttempt: int = 0): Recallable =
  ## rolloutsGet
  ##   rolloutName: string (required)
  ##              : The rollout name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   retryAttempt: int
  ##               : Rollout retry attempt ordinal to get the result of. If not specified, result of the latest attempt will be returned.
  var path_568253 = newJObject()
  var query_568254 = newJObject()
  add(path_568253, "rolloutName", newJString(rolloutName))
  add(path_568253, "resourceGroupName", newJString(resourceGroupName))
  add(query_568254, "api-version", newJString(apiVersion))
  add(path_568253, "subscriptionId", newJString(subscriptionId))
  add(query_568254, "retryAttempt", newJInt(retryAttempt))
  result = call_568252.call(path_568253, query_568254, nil, nil, nil)

var rolloutsGet* = Call_RolloutsGet_568243(name: "rolloutsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/rollouts/{rolloutName}",
                                        validator: validate_RolloutsGet_568244,
                                        base: "", url: url_RolloutsGet_568245,
                                        schemes: {Scheme.Https})
type
  Call_RolloutsDelete_568268 = ref object of OpenApiRestCall_567657
proc url_RolloutsDelete_568270(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "rolloutName" in path, "`rolloutName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/rollouts/"),
               (kind: VariableSegment, value: "rolloutName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RolloutsDelete_568269(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Only rollouts in terminal state can be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rolloutName: JString (required)
  ##              : The rollout name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rolloutName` field"
  var valid_568271 = path.getOrDefault("rolloutName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "rolloutName", valid_568271
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
  ##              : The API version to use for this operation.
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
  if body != nil:
    result.add "body", body

proc call*(call_568275: Call_RolloutsDelete_568268; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Only rollouts in terminal state can be deleted.
  ## 
  let valid = call_568275.validator(path, query, header, formData, body)
  let scheme = call_568275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568275.url(scheme.get, call_568275.host, call_568275.base,
                         call_568275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568275, url, valid)

proc call*(call_568276: Call_RolloutsDelete_568268; rolloutName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## rolloutsDelete
  ## Only rollouts in terminal state can be deleted.
  ##   rolloutName: string (required)
  ##              : The rollout name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568277 = newJObject()
  var query_568278 = newJObject()
  add(path_568277, "rolloutName", newJString(rolloutName))
  add(path_568277, "resourceGroupName", newJString(resourceGroupName))
  add(query_568278, "api-version", newJString(apiVersion))
  add(path_568277, "subscriptionId", newJString(subscriptionId))
  result = call_568276.call(path_568277, query_568278, nil, nil, nil)

var rolloutsDelete* = Call_RolloutsDelete_568268(name: "rolloutsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/rollouts/{rolloutName}",
    validator: validate_RolloutsDelete_568269, base: "", url: url_RolloutsDelete_568270,
    schemes: {Scheme.Https})
type
  Call_RolloutsCancel_568279 = ref object of OpenApiRestCall_567657
proc url_RolloutsCancel_568281(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "rolloutName" in path, "`rolloutName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/rollouts/"),
               (kind: VariableSegment, value: "rolloutName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RolloutsCancel_568280(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Only running rollouts can be canceled.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rolloutName: JString (required)
  ##              : The rollout name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rolloutName` field"
  var valid_568282 = path.getOrDefault("rolloutName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "rolloutName", valid_568282
  var valid_568283 = path.getOrDefault("resourceGroupName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "resourceGroupName", valid_568283
  var valid_568284 = path.getOrDefault("subscriptionId")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "subscriptionId", valid_568284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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

proc call*(call_568286: Call_RolloutsCancel_568279; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Only running rollouts can be canceled.
  ## 
  let valid = call_568286.validator(path, query, header, formData, body)
  let scheme = call_568286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568286.url(scheme.get, call_568286.host, call_568286.base,
                         call_568286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568286, url, valid)

proc call*(call_568287: Call_RolloutsCancel_568279; rolloutName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## rolloutsCancel
  ## Only running rollouts can be canceled.
  ##   rolloutName: string (required)
  ##              : The rollout name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568288 = newJObject()
  var query_568289 = newJObject()
  add(path_568288, "rolloutName", newJString(rolloutName))
  add(path_568288, "resourceGroupName", newJString(resourceGroupName))
  add(query_568289, "api-version", newJString(apiVersion))
  add(path_568288, "subscriptionId", newJString(subscriptionId))
  result = call_568287.call(path_568288, query_568289, nil, nil, nil)

var rolloutsCancel* = Call_RolloutsCancel_568279(name: "rolloutsCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/rollouts/{rolloutName}/cancel",
    validator: validate_RolloutsCancel_568280, base: "", url: url_RolloutsCancel_568281,
    schemes: {Scheme.Https})
type
  Call_RolloutsRestart_568290 = ref object of OpenApiRestCall_567657
proc url_RolloutsRestart_568292(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "rolloutName" in path, "`rolloutName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/rollouts/"),
               (kind: VariableSegment, value: "rolloutName"),
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RolloutsRestart_568291(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Only failed rollouts can be restarted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rolloutName: JString (required)
  ##              : The rollout name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rolloutName` field"
  var valid_568293 = path.getOrDefault("rolloutName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "rolloutName", valid_568293
  var valid_568294 = path.getOrDefault("resourceGroupName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "resourceGroupName", valid_568294
  var valid_568295 = path.getOrDefault("subscriptionId")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "subscriptionId", valid_568295
  result.add "path", section
  ## parameters in `query` object:
  ##   skipSucceeded: JBool
  ##                : If true, will skip all succeeded steps so far in the rollout. If false, will execute the entire rollout again regardless of the current state of individual resources. Defaults to false if not specified.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_568296 = query.getOrDefault("skipSucceeded")
  valid_568296 = validateParameter(valid_568296, JBool, required = false, default = nil)
  if valid_568296 != nil:
    section.add "skipSucceeded", valid_568296
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

proc call*(call_568298: Call_RolloutsRestart_568290; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Only failed rollouts can be restarted.
  ## 
  let valid = call_568298.validator(path, query, header, formData, body)
  let scheme = call_568298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568298.url(scheme.get, call_568298.host, call_568298.base,
                         call_568298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568298, url, valid)

proc call*(call_568299: Call_RolloutsRestart_568290; rolloutName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          skipSucceeded: bool = false): Recallable =
  ## rolloutsRestart
  ## Only failed rollouts can be restarted.
  ##   rolloutName: string (required)
  ##              : The rollout name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   skipSucceeded: bool
  ##                : If true, will skip all succeeded steps so far in the rollout. If false, will execute the entire rollout again regardless of the current state of individual resources. Defaults to false if not specified.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568300 = newJObject()
  var query_568301 = newJObject()
  add(path_568300, "rolloutName", newJString(rolloutName))
  add(path_568300, "resourceGroupName", newJString(resourceGroupName))
  add(query_568301, "skipSucceeded", newJBool(skipSucceeded))
  add(query_568301, "api-version", newJString(apiVersion))
  add(path_568300, "subscriptionId", newJString(subscriptionId))
  result = call_568299.call(path_568300, query_568301, nil, nil, nil)

var rolloutsRestart* = Call_RolloutsRestart_568290(name: "rolloutsRestart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/rollouts/{rolloutName}/restart",
    validator: validate_RolloutsRestart_568291, base: "", url: url_RolloutsRestart_568292,
    schemes: {Scheme.Https})
type
  Call_ServiceTopologiesCreateOrUpdate_568313 = ref object of OpenApiRestCall_567657
proc url_ServiceTopologiesCreateOrUpdate_568315(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceTopologyName" in path,
        "`serviceTopologyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/serviceTopologies/"),
               (kind: VariableSegment, value: "serviceTopologyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceTopologiesCreateOrUpdate_568314(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Synchronously creates a new service topology or updates an existing service topology.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568316 = path.getOrDefault("resourceGroupName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "resourceGroupName", valid_568316
  var valid_568317 = path.getOrDefault("subscriptionId")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "subscriptionId", valid_568317
  var valid_568318 = path.getOrDefault("serviceTopologyName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "serviceTopologyName", valid_568318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568319 = query.getOrDefault("api-version")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "api-version", valid_568319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serviceTopologyInfo: JObject (required)
  ##                      : Source topology object defines the resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568321: Call_ServiceTopologiesCreateOrUpdate_568313;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Synchronously creates a new service topology or updates an existing service topology.
  ## 
  let valid = call_568321.validator(path, query, header, formData, body)
  let scheme = call_568321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568321.url(scheme.get, call_568321.host, call_568321.base,
                         call_568321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568321, url, valid)

proc call*(call_568322: Call_ServiceTopologiesCreateOrUpdate_568313;
          serviceTopologyInfo: JsonNode; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceTopologyName: string): Recallable =
  ## serviceTopologiesCreateOrUpdate
  ## Synchronously creates a new service topology or updates an existing service topology.
  ##   serviceTopologyInfo: JObject (required)
  ##                      : Source topology object defines the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  var path_568323 = newJObject()
  var query_568324 = newJObject()
  var body_568325 = newJObject()
  if serviceTopologyInfo != nil:
    body_568325 = serviceTopologyInfo
  add(path_568323, "resourceGroupName", newJString(resourceGroupName))
  add(query_568324, "api-version", newJString(apiVersion))
  add(path_568323, "subscriptionId", newJString(subscriptionId))
  add(path_568323, "serviceTopologyName", newJString(serviceTopologyName))
  result = call_568322.call(path_568323, query_568324, nil, nil, body_568325)

var serviceTopologiesCreateOrUpdate* = Call_ServiceTopologiesCreateOrUpdate_568313(
    name: "serviceTopologiesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}",
    validator: validate_ServiceTopologiesCreateOrUpdate_568314, base: "",
    url: url_ServiceTopologiesCreateOrUpdate_568315, schemes: {Scheme.Https})
type
  Call_ServiceTopologiesGet_568302 = ref object of OpenApiRestCall_567657
proc url_ServiceTopologiesGet_568304(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceTopologyName" in path,
        "`serviceTopologyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/serviceTopologies/"),
               (kind: VariableSegment, value: "serviceTopologyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceTopologiesGet_568303(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
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
  var valid_568307 = path.getOrDefault("serviceTopologyName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "serviceTopologyName", valid_568307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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

proc call*(call_568309: Call_ServiceTopologiesGet_568302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568309.validator(path, query, header, formData, body)
  let scheme = call_568309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568309.url(scheme.get, call_568309.host, call_568309.base,
                         call_568309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568309, url, valid)

proc call*(call_568310: Call_ServiceTopologiesGet_568302;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceTopologyName: string): Recallable =
  ## serviceTopologiesGet
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  var path_568311 = newJObject()
  var query_568312 = newJObject()
  add(path_568311, "resourceGroupName", newJString(resourceGroupName))
  add(query_568312, "api-version", newJString(apiVersion))
  add(path_568311, "subscriptionId", newJString(subscriptionId))
  add(path_568311, "serviceTopologyName", newJString(serviceTopologyName))
  result = call_568310.call(path_568311, query_568312, nil, nil, nil)

var serviceTopologiesGet* = Call_ServiceTopologiesGet_568302(
    name: "serviceTopologiesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}",
    validator: validate_ServiceTopologiesGet_568303, base: "",
    url: url_ServiceTopologiesGet_568304, schemes: {Scheme.Https})
type
  Call_ServiceTopologiesDelete_568326 = ref object of OpenApiRestCall_567657
proc url_ServiceTopologiesDelete_568328(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceTopologyName" in path,
        "`serviceTopologyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/serviceTopologies/"),
               (kind: VariableSegment, value: "serviceTopologyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceTopologiesDelete_568327(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568329 = path.getOrDefault("resourceGroupName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "resourceGroupName", valid_568329
  var valid_568330 = path.getOrDefault("subscriptionId")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "subscriptionId", valid_568330
  var valid_568331 = path.getOrDefault("serviceTopologyName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "serviceTopologyName", valid_568331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568332 = query.getOrDefault("api-version")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "api-version", valid_568332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568333: Call_ServiceTopologiesDelete_568326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568333.validator(path, query, header, formData, body)
  let scheme = call_568333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568333.url(scheme.get, call_568333.host, call_568333.base,
                         call_568333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568333, url, valid)

proc call*(call_568334: Call_ServiceTopologiesDelete_568326;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceTopologyName: string): Recallable =
  ## serviceTopologiesDelete
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  var path_568335 = newJObject()
  var query_568336 = newJObject()
  add(path_568335, "resourceGroupName", newJString(resourceGroupName))
  add(query_568336, "api-version", newJString(apiVersion))
  add(path_568335, "subscriptionId", newJString(subscriptionId))
  add(path_568335, "serviceTopologyName", newJString(serviceTopologyName))
  result = call_568334.call(path_568335, query_568336, nil, nil, nil)

var serviceTopologiesDelete* = Call_ServiceTopologiesDelete_568326(
    name: "serviceTopologiesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}",
    validator: validate_ServiceTopologiesDelete_568327, base: "",
    url: url_ServiceTopologiesDelete_568328, schemes: {Scheme.Https})
type
  Call_ServicesCreateOrUpdate_568349 = ref object of OpenApiRestCall_567657
proc url_ServicesCreateOrUpdate_568351(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceTopologyName" in path,
        "`serviceTopologyName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/serviceTopologies/"),
               (kind: VariableSegment, value: "serviceTopologyName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCreateOrUpdate_568350(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Synchronously creates a new service or updates an existing service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  ##   serviceName: JString (required)
  ##              : The name of the service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568352 = path.getOrDefault("resourceGroupName")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "resourceGroupName", valid_568352
  var valid_568353 = path.getOrDefault("subscriptionId")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "subscriptionId", valid_568353
  var valid_568354 = path.getOrDefault("serviceTopologyName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "serviceTopologyName", valid_568354
  var valid_568355 = path.getOrDefault("serviceName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "serviceName", valid_568355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568356 = query.getOrDefault("api-version")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "api-version", valid_568356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serviceInfo: JObject (required)
  ##              : The service object
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568358: Call_ServicesCreateOrUpdate_568349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Synchronously creates a new service or updates an existing service.
  ## 
  let valid = call_568358.validator(path, query, header, formData, body)
  let scheme = call_568358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568358.url(scheme.get, call_568358.host, call_568358.base,
                         call_568358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568358, url, valid)

proc call*(call_568359: Call_ServicesCreateOrUpdate_568349;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceTopologyName: string; serviceInfo: JsonNode; serviceName: string): Recallable =
  ## servicesCreateOrUpdate
  ## Synchronously creates a new service or updates an existing service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  ##   serviceInfo: JObject (required)
  ##              : The service object
  ##   serviceName: string (required)
  ##              : The name of the service resource.
  var path_568360 = newJObject()
  var query_568361 = newJObject()
  var body_568362 = newJObject()
  add(path_568360, "resourceGroupName", newJString(resourceGroupName))
  add(query_568361, "api-version", newJString(apiVersion))
  add(path_568360, "subscriptionId", newJString(subscriptionId))
  add(path_568360, "serviceTopologyName", newJString(serviceTopologyName))
  if serviceInfo != nil:
    body_568362 = serviceInfo
  add(path_568360, "serviceName", newJString(serviceName))
  result = call_568359.call(path_568360, query_568361, nil, nil, body_568362)

var servicesCreateOrUpdate* = Call_ServicesCreateOrUpdate_568349(
    name: "servicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}/services/{serviceName}",
    validator: validate_ServicesCreateOrUpdate_568350, base: "",
    url: url_ServicesCreateOrUpdate_568351, schemes: {Scheme.Https})
type
  Call_ServicesGet_568337 = ref object of OpenApiRestCall_567657
proc url_ServicesGet_568339(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceTopologyName" in path,
        "`serviceTopologyName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/serviceTopologies/"),
               (kind: VariableSegment, value: "serviceTopologyName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesGet_568338(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  ##   serviceName: JString (required)
  ##              : The name of the service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568340 = path.getOrDefault("resourceGroupName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "resourceGroupName", valid_568340
  var valid_568341 = path.getOrDefault("subscriptionId")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "subscriptionId", valid_568341
  var valid_568342 = path.getOrDefault("serviceTopologyName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "serviceTopologyName", valid_568342
  var valid_568343 = path.getOrDefault("serviceName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "serviceName", valid_568343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568344 = query.getOrDefault("api-version")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "api-version", valid_568344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568345: Call_ServicesGet_568337; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568345.validator(path, query, header, formData, body)
  let scheme = call_568345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568345.url(scheme.get, call_568345.host, call_568345.base,
                         call_568345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568345, url, valid)

proc call*(call_568346: Call_ServicesGet_568337; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceTopologyName: string;
          serviceName: string): Recallable =
  ## servicesGet
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  ##   serviceName: string (required)
  ##              : The name of the service resource.
  var path_568347 = newJObject()
  var query_568348 = newJObject()
  add(path_568347, "resourceGroupName", newJString(resourceGroupName))
  add(query_568348, "api-version", newJString(apiVersion))
  add(path_568347, "subscriptionId", newJString(subscriptionId))
  add(path_568347, "serviceTopologyName", newJString(serviceTopologyName))
  add(path_568347, "serviceName", newJString(serviceName))
  result = call_568346.call(path_568347, query_568348, nil, nil, nil)

var servicesGet* = Call_ServicesGet_568337(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}/services/{serviceName}",
                                        validator: validate_ServicesGet_568338,
                                        base: "", url: url_ServicesGet_568339,
                                        schemes: {Scheme.Https})
type
  Call_ServicesDelete_568363 = ref object of OpenApiRestCall_567657
proc url_ServicesDelete_568365(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceTopologyName" in path,
        "`serviceTopologyName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/serviceTopologies/"),
               (kind: VariableSegment, value: "serviceTopologyName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesDelete_568364(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  ##   serviceName: JString (required)
  ##              : The name of the service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568366 = path.getOrDefault("resourceGroupName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "resourceGroupName", valid_568366
  var valid_568367 = path.getOrDefault("subscriptionId")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "subscriptionId", valid_568367
  var valid_568368 = path.getOrDefault("serviceTopologyName")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "serviceTopologyName", valid_568368
  var valid_568369 = path.getOrDefault("serviceName")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "serviceName", valid_568369
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568370 = query.getOrDefault("api-version")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "api-version", valid_568370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568371: Call_ServicesDelete_568363; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568371.validator(path, query, header, formData, body)
  let scheme = call_568371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568371.url(scheme.get, call_568371.host, call_568371.base,
                         call_568371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568371, url, valid)

proc call*(call_568372: Call_ServicesDelete_568363; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceTopologyName: string;
          serviceName: string): Recallable =
  ## servicesDelete
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  ##   serviceName: string (required)
  ##              : The name of the service resource.
  var path_568373 = newJObject()
  var query_568374 = newJObject()
  add(path_568373, "resourceGroupName", newJString(resourceGroupName))
  add(query_568374, "api-version", newJString(apiVersion))
  add(path_568373, "subscriptionId", newJString(subscriptionId))
  add(path_568373, "serviceTopologyName", newJString(serviceTopologyName))
  add(path_568373, "serviceName", newJString(serviceName))
  result = call_568372.call(path_568373, query_568374, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_568363(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}/services/{serviceName}",
    validator: validate_ServicesDelete_568364, base: "", url: url_ServicesDelete_568365,
    schemes: {Scheme.Https})
type
  Call_ServiceUnitsCreateOrUpdate_568388 = ref object of OpenApiRestCall_567657
proc url_ServiceUnitsCreateOrUpdate_568390(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceTopologyName" in path,
        "`serviceTopologyName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceUnitName" in path, "`serviceUnitName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/serviceTopologies/"),
               (kind: VariableSegment, value: "serviceTopologyName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/serviceUnits/"),
               (kind: VariableSegment, value: "serviceUnitName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceUnitsCreateOrUpdate_568389(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This is an asynchronous operation and can be polled to completion using the operation resource returned by this operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  ##   serviceUnitName: JString (required)
  ##                  : The name of the service unit resource.
  ##   serviceName: JString (required)
  ##              : The name of the service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568391 = path.getOrDefault("resourceGroupName")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "resourceGroupName", valid_568391
  var valid_568392 = path.getOrDefault("subscriptionId")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "subscriptionId", valid_568392
  var valid_568393 = path.getOrDefault("serviceTopologyName")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "serviceTopologyName", valid_568393
  var valid_568394 = path.getOrDefault("serviceUnitName")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "serviceUnitName", valid_568394
  var valid_568395 = path.getOrDefault("serviceName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "serviceName", valid_568395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568396 = query.getOrDefault("api-version")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "api-version", valid_568396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serviceUnitInfo: JObject (required)
  ##                  : The service unit resource object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568398: Call_ServiceUnitsCreateOrUpdate_568388; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This is an asynchronous operation and can be polled to completion using the operation resource returned by this operation.
  ## 
  let valid = call_568398.validator(path, query, header, formData, body)
  let scheme = call_568398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568398.url(scheme.get, call_568398.host, call_568398.base,
                         call_568398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568398, url, valid)

proc call*(call_568399: Call_ServiceUnitsCreateOrUpdate_568388;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceTopologyName: string; serviceUnitInfo: JsonNode;
          serviceUnitName: string; serviceName: string): Recallable =
  ## serviceUnitsCreateOrUpdate
  ## This is an asynchronous operation and can be polled to completion using the operation resource returned by this operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  ##   serviceUnitInfo: JObject (required)
  ##                  : The service unit resource object.
  ##   serviceUnitName: string (required)
  ##                  : The name of the service unit resource.
  ##   serviceName: string (required)
  ##              : The name of the service resource.
  var path_568400 = newJObject()
  var query_568401 = newJObject()
  var body_568402 = newJObject()
  add(path_568400, "resourceGroupName", newJString(resourceGroupName))
  add(query_568401, "api-version", newJString(apiVersion))
  add(path_568400, "subscriptionId", newJString(subscriptionId))
  add(path_568400, "serviceTopologyName", newJString(serviceTopologyName))
  if serviceUnitInfo != nil:
    body_568402 = serviceUnitInfo
  add(path_568400, "serviceUnitName", newJString(serviceUnitName))
  add(path_568400, "serviceName", newJString(serviceName))
  result = call_568399.call(path_568400, query_568401, nil, nil, body_568402)

var serviceUnitsCreateOrUpdate* = Call_ServiceUnitsCreateOrUpdate_568388(
    name: "serviceUnitsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}/services/{serviceName}/serviceUnits/{serviceUnitName}",
    validator: validate_ServiceUnitsCreateOrUpdate_568389, base: "",
    url: url_ServiceUnitsCreateOrUpdate_568390, schemes: {Scheme.Https})
type
  Call_ServiceUnitsGet_568375 = ref object of OpenApiRestCall_567657
proc url_ServiceUnitsGet_568377(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceTopologyName" in path,
        "`serviceTopologyName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceUnitName" in path, "`serviceUnitName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/serviceTopologies/"),
               (kind: VariableSegment, value: "serviceTopologyName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/serviceUnits/"),
               (kind: VariableSegment, value: "serviceUnitName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceUnitsGet_568376(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  ##   serviceUnitName: JString (required)
  ##                  : The name of the service unit resource.
  ##   serviceName: JString (required)
  ##              : The name of the service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568378 = path.getOrDefault("resourceGroupName")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "resourceGroupName", valid_568378
  var valid_568379 = path.getOrDefault("subscriptionId")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "subscriptionId", valid_568379
  var valid_568380 = path.getOrDefault("serviceTopologyName")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "serviceTopologyName", valid_568380
  var valid_568381 = path.getOrDefault("serviceUnitName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "serviceUnitName", valid_568381
  var valid_568382 = path.getOrDefault("serviceName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "serviceName", valid_568382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568383 = query.getOrDefault("api-version")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "api-version", valid_568383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568384: Call_ServiceUnitsGet_568375; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568384.validator(path, query, header, formData, body)
  let scheme = call_568384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568384.url(scheme.get, call_568384.host, call_568384.base,
                         call_568384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568384, url, valid)

proc call*(call_568385: Call_ServiceUnitsGet_568375; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceTopologyName: string;
          serviceUnitName: string; serviceName: string): Recallable =
  ## serviceUnitsGet
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  ##   serviceUnitName: string (required)
  ##                  : The name of the service unit resource.
  ##   serviceName: string (required)
  ##              : The name of the service resource.
  var path_568386 = newJObject()
  var query_568387 = newJObject()
  add(path_568386, "resourceGroupName", newJString(resourceGroupName))
  add(query_568387, "api-version", newJString(apiVersion))
  add(path_568386, "subscriptionId", newJString(subscriptionId))
  add(path_568386, "serviceTopologyName", newJString(serviceTopologyName))
  add(path_568386, "serviceUnitName", newJString(serviceUnitName))
  add(path_568386, "serviceName", newJString(serviceName))
  result = call_568385.call(path_568386, query_568387, nil, nil, nil)

var serviceUnitsGet* = Call_ServiceUnitsGet_568375(name: "serviceUnitsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}/services/{serviceName}/serviceUnits/{serviceUnitName}",
    validator: validate_ServiceUnitsGet_568376, base: "", url: url_ServiceUnitsGet_568377,
    schemes: {Scheme.Https})
type
  Call_ServiceUnitsDelete_568403 = ref object of OpenApiRestCall_567657
proc url_ServiceUnitsDelete_568405(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceTopologyName" in path,
        "`serviceTopologyName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceUnitName" in path, "`serviceUnitName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/serviceTopologies/"),
               (kind: VariableSegment, value: "serviceTopologyName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/serviceUnits/"),
               (kind: VariableSegment, value: "serviceUnitName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceUnitsDelete_568404(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  ##   serviceUnitName: JString (required)
  ##                  : The name of the service unit resource.
  ##   serviceName: JString (required)
  ##              : The name of the service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568406 = path.getOrDefault("resourceGroupName")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "resourceGroupName", valid_568406
  var valid_568407 = path.getOrDefault("subscriptionId")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "subscriptionId", valid_568407
  var valid_568408 = path.getOrDefault("serviceTopologyName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "serviceTopologyName", valid_568408
  var valid_568409 = path.getOrDefault("serviceUnitName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "serviceUnitName", valid_568409
  var valid_568410 = path.getOrDefault("serviceName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "serviceName", valid_568410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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

proc call*(call_568412: Call_ServiceUnitsDelete_568403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568412.validator(path, query, header, formData, body)
  let scheme = call_568412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568412.url(scheme.get, call_568412.host, call_568412.base,
                         call_568412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568412, url, valid)

proc call*(call_568413: Call_ServiceUnitsDelete_568403; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceTopologyName: string;
          serviceUnitName: string; serviceName: string): Recallable =
  ## serviceUnitsDelete
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  ##   serviceUnitName: string (required)
  ##                  : The name of the service unit resource.
  ##   serviceName: string (required)
  ##              : The name of the service resource.
  var path_568414 = newJObject()
  var query_568415 = newJObject()
  add(path_568414, "resourceGroupName", newJString(resourceGroupName))
  add(query_568415, "api-version", newJString(apiVersion))
  add(path_568414, "subscriptionId", newJString(subscriptionId))
  add(path_568414, "serviceTopologyName", newJString(serviceTopologyName))
  add(path_568414, "serviceUnitName", newJString(serviceUnitName))
  add(path_568414, "serviceName", newJString(serviceName))
  result = call_568413.call(path_568414, query_568415, nil, nil, nil)

var serviceUnitsDelete* = Call_ServiceUnitsDelete_568403(
    name: "serviceUnitsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}/services/{serviceName}/serviceUnits/{serviceUnitName}",
    validator: validate_ServiceUnitsDelete_568404, base: "",
    url: url_ServiceUnitsDelete_568405, schemes: {Scheme.Https})
type
  Call_StepsCreateOrUpdate_568427 = ref object of OpenApiRestCall_567657
proc url_StepsCreateOrUpdate_568429(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "stepName" in path, "`stepName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/steps/"),
               (kind: VariableSegment, value: "stepName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StepsCreateOrUpdate_568428(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Synchronously creates a new step or updates an existing step.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   stepName: JString (required)
  ##           : The name of the deployment step.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568430 = path.getOrDefault("resourceGroupName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "resourceGroupName", valid_568430
  var valid_568431 = path.getOrDefault("stepName")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "stepName", valid_568431
  var valid_568432 = path.getOrDefault("subscriptionId")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "subscriptionId", valid_568432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568433 = query.getOrDefault("api-version")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "api-version", valid_568433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   stepInfo: JObject
  ##           : The step object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568435: Call_StepsCreateOrUpdate_568427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Synchronously creates a new step or updates an existing step.
  ## 
  let valid = call_568435.validator(path, query, header, formData, body)
  let scheme = call_568435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568435.url(scheme.get, call_568435.host, call_568435.base,
                         call_568435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568435, url, valid)

proc call*(call_568436: Call_StepsCreateOrUpdate_568427; resourceGroupName: string;
          apiVersion: string; stepName: string; subscriptionId: string;
          stepInfo: JsonNode = nil): Recallable =
  ## stepsCreateOrUpdate
  ## Synchronously creates a new step or updates an existing step.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   stepName: string (required)
  ##           : The name of the deployment step.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   stepInfo: JObject
  ##           : The step object.
  var path_568437 = newJObject()
  var query_568438 = newJObject()
  var body_568439 = newJObject()
  add(path_568437, "resourceGroupName", newJString(resourceGroupName))
  add(query_568438, "api-version", newJString(apiVersion))
  add(path_568437, "stepName", newJString(stepName))
  add(path_568437, "subscriptionId", newJString(subscriptionId))
  if stepInfo != nil:
    body_568439 = stepInfo
  result = call_568436.call(path_568437, query_568438, nil, nil, body_568439)

var stepsCreateOrUpdate* = Call_StepsCreateOrUpdate_568427(
    name: "stepsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/steps/{stepName}",
    validator: validate_StepsCreateOrUpdate_568428, base: "",
    url: url_StepsCreateOrUpdate_568429, schemes: {Scheme.Https})
type
  Call_StepsGet_568416 = ref object of OpenApiRestCall_567657
proc url_StepsGet_568418(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "stepName" in path, "`stepName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/steps/"),
               (kind: VariableSegment, value: "stepName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StepsGet_568417(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   stepName: JString (required)
  ##           : The name of the deployment step.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568419 = path.getOrDefault("resourceGroupName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "resourceGroupName", valid_568419
  var valid_568420 = path.getOrDefault("stepName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "stepName", valid_568420
  var valid_568421 = path.getOrDefault("subscriptionId")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "subscriptionId", valid_568421
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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
  if body != nil:
    result.add "body", body

proc call*(call_568423: Call_StepsGet_568416; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568423.validator(path, query, header, formData, body)
  let scheme = call_568423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568423.url(scheme.get, call_568423.host, call_568423.base,
                         call_568423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568423, url, valid)

proc call*(call_568424: Call_StepsGet_568416; resourceGroupName: string;
          apiVersion: string; stepName: string; subscriptionId: string): Recallable =
  ## stepsGet
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   stepName: string (required)
  ##           : The name of the deployment step.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568425 = newJObject()
  var query_568426 = newJObject()
  add(path_568425, "resourceGroupName", newJString(resourceGroupName))
  add(query_568426, "api-version", newJString(apiVersion))
  add(path_568425, "stepName", newJString(stepName))
  add(path_568425, "subscriptionId", newJString(subscriptionId))
  result = call_568424.call(path_568425, query_568426, nil, nil, nil)

var stepsGet* = Call_StepsGet_568416(name: "stepsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/steps/{stepName}",
                                  validator: validate_StepsGet_568417, base: "",
                                  url: url_StepsGet_568418,
                                  schemes: {Scheme.Https})
type
  Call_StepsDelete_568440 = ref object of OpenApiRestCall_567657
proc url_StepsDelete_568442(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "stepName" in path, "`stepName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DeploymentManager/steps/"),
               (kind: VariableSegment, value: "stepName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StepsDelete_568441(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   stepName: JString (required)
  ##           : The name of the deployment step.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568443 = path.getOrDefault("resourceGroupName")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "resourceGroupName", valid_568443
  var valid_568444 = path.getOrDefault("stepName")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "stepName", valid_568444
  var valid_568445 = path.getOrDefault("subscriptionId")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "subscriptionId", valid_568445
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568446 = query.getOrDefault("api-version")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "api-version", valid_568446
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568447: Call_StepsDelete_568440; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568447.validator(path, query, header, formData, body)
  let scheme = call_568447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568447.url(scheme.get, call_568447.host, call_568447.base,
                         call_568447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568447, url, valid)

proc call*(call_568448: Call_StepsDelete_568440; resourceGroupName: string;
          apiVersion: string; stepName: string; subscriptionId: string): Recallable =
  ## stepsDelete
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   stepName: string (required)
  ##           : The name of the deployment step.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568449 = newJObject()
  var query_568450 = newJObject()
  add(path_568449, "resourceGroupName", newJString(resourceGroupName))
  add(query_568450, "api-version", newJString(apiVersion))
  add(path_568449, "stepName", newJString(stepName))
  add(path_568449, "subscriptionId", newJString(subscriptionId))
  result = call_568448.call(path_568449, query_568450, nil, nil, nil)

var stepsDelete* = Call_StepsDelete_568440(name: "stepsDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/steps/{stepName}",
                                        validator: validate_StepsDelete_568441,
                                        base: "", url: url_StepsDelete_568442,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
