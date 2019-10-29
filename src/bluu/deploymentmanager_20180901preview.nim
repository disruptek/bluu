
import
  json, options, hashes, uri, rest, os, uri, httpcore

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
  macServiceName = "deploymentmanager"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsGet_563777 = ref object of OpenApiRestCall_563555
proc url_OperationsGet_563779(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsGet_563778(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563954 = path.getOrDefault("subscriptionId")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = nil)
  if valid_563954 != nil:
    section.add "subscriptionId", valid_563954
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563955 = query.getOrDefault("api-version")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "api-version", valid_563955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563978: Call_OperationsGet_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_563978.validator(path, query, header, formData, body)
  let scheme = call_563978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563978.url(scheme.get, call_563978.host, call_563978.base,
                         call_563978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563978, url, valid)

proc call*(call_564049: Call_OperationsGet_563777; apiVersion: string;
          subscriptionId: string): Recallable =
  ## operationsGet
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564050 = newJObject()
  var query_564052 = newJObject()
  add(query_564052, "api-version", newJString(apiVersion))
  add(path_564050, "subscriptionId", newJString(subscriptionId))
  result = call_564049.call(path_564050, query_564052, nil, nil, nil)

var operationsGet* = Call_OperationsGet_563777(name: "operationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DeploymentManager/operations",
    validator: validate_OperationsGet_563778, base: "", url: url_OperationsGet_563779,
    schemes: {Scheme.Https})
type
  Call_ArtifactSourcesCreateOrUpdate_564102 = ref object of OpenApiRestCall_563555
proc url_ArtifactSourcesCreateOrUpdate_564104(protocol: Scheme; host: string;
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

proc validate_ArtifactSourcesCreateOrUpdate_564103(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Synchronously creates a new artifact source or updates an existing artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564122 = path.getOrDefault("subscriptionId")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "subscriptionId", valid_564122
  var valid_564123 = path.getOrDefault("resourceGroupName")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "resourceGroupName", valid_564123
  var valid_564124 = path.getOrDefault("artifactSourceName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "artifactSourceName", valid_564124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564125 = query.getOrDefault("api-version")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "api-version", valid_564125
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

proc call*(call_564127: Call_ArtifactSourcesCreateOrUpdate_564102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Synchronously creates a new artifact source or updates an existing artifact source.
  ## 
  let valid = call_564127.validator(path, query, header, formData, body)
  let scheme = call_564127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564127.url(scheme.get, call_564127.host, call_564127.base,
                         call_564127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564127, url, valid)

proc call*(call_564128: Call_ArtifactSourcesCreateOrUpdate_564102;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          artifactSourceName: string; artifactSourceInfo: JsonNode = nil): Recallable =
  ## artifactSourcesCreateOrUpdate
  ## Synchronously creates a new artifact source or updates an existing artifact source.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   artifactSourceInfo: JObject
  ##                     : Source object that defines the resource.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  var path_564129 = newJObject()
  var query_564130 = newJObject()
  var body_564131 = newJObject()
  add(query_564130, "api-version", newJString(apiVersion))
  if artifactSourceInfo != nil:
    body_564131 = artifactSourceInfo
  add(path_564129, "subscriptionId", newJString(subscriptionId))
  add(path_564129, "resourceGroupName", newJString(resourceGroupName))
  add(path_564129, "artifactSourceName", newJString(artifactSourceName))
  result = call_564128.call(path_564129, query_564130, nil, nil, body_564131)

var artifactSourcesCreateOrUpdate* = Call_ArtifactSourcesCreateOrUpdate_564102(
    name: "artifactSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/artifactSources/{artifactSourceName}",
    validator: validate_ArtifactSourcesCreateOrUpdate_564103, base: "",
    url: url_ArtifactSourcesCreateOrUpdate_564104, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesGet_564091 = ref object of OpenApiRestCall_563555
proc url_ArtifactSourcesGet_564093(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesGet_564092(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564094 = path.getOrDefault("subscriptionId")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "subscriptionId", valid_564094
  var valid_564095 = path.getOrDefault("resourceGroupName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "resourceGroupName", valid_564095
  var valid_564096 = path.getOrDefault("artifactSourceName")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "artifactSourceName", valid_564096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564097 = query.getOrDefault("api-version")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "api-version", valid_564097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564098: Call_ArtifactSourcesGet_564091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564098.validator(path, query, header, formData, body)
  let scheme = call_564098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564098.url(scheme.get, call_564098.host, call_564098.base,
                         call_564098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564098, url, valid)

proc call*(call_564099: Call_ArtifactSourcesGet_564091; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          artifactSourceName: string): Recallable =
  ## artifactSourcesGet
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  var path_564100 = newJObject()
  var query_564101 = newJObject()
  add(query_564101, "api-version", newJString(apiVersion))
  add(path_564100, "subscriptionId", newJString(subscriptionId))
  add(path_564100, "resourceGroupName", newJString(resourceGroupName))
  add(path_564100, "artifactSourceName", newJString(artifactSourceName))
  result = call_564099.call(path_564100, query_564101, nil, nil, nil)

var artifactSourcesGet* = Call_ArtifactSourcesGet_564091(
    name: "artifactSourcesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/artifactSources/{artifactSourceName}",
    validator: validate_ArtifactSourcesGet_564092, base: "",
    url: url_ArtifactSourcesGet_564093, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesDelete_564132 = ref object of OpenApiRestCall_563555
proc url_ArtifactSourcesDelete_564134(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesDelete_564133(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564135 = path.getOrDefault("subscriptionId")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "subscriptionId", valid_564135
  var valid_564136 = path.getOrDefault("resourceGroupName")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "resourceGroupName", valid_564136
  var valid_564137 = path.getOrDefault("artifactSourceName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "artifactSourceName", valid_564137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564138 = query.getOrDefault("api-version")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "api-version", valid_564138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564139: Call_ArtifactSourcesDelete_564132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564139.validator(path, query, header, formData, body)
  let scheme = call_564139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564139.url(scheme.get, call_564139.host, call_564139.base,
                         call_564139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564139, url, valid)

proc call*(call_564140: Call_ArtifactSourcesDelete_564132; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          artifactSourceName: string): Recallable =
  ## artifactSourcesDelete
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  var path_564141 = newJObject()
  var query_564142 = newJObject()
  add(query_564142, "api-version", newJString(apiVersion))
  add(path_564141, "subscriptionId", newJString(subscriptionId))
  add(path_564141, "resourceGroupName", newJString(resourceGroupName))
  add(path_564141, "artifactSourceName", newJString(artifactSourceName))
  result = call_564140.call(path_564141, query_564142, nil, nil, nil)

var artifactSourcesDelete* = Call_ArtifactSourcesDelete_564132(
    name: "artifactSourcesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/artifactSources/{artifactSourceName}",
    validator: validate_ArtifactSourcesDelete_564133, base: "",
    url: url_ArtifactSourcesDelete_564134, schemes: {Scheme.Https})
type
  Call_RolloutsCreateOrUpdate_564155 = ref object of OpenApiRestCall_563555
proc url_RolloutsCreateOrUpdate_564157(protocol: Scheme; host: string; base: string;
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

proc validate_RolloutsCreateOrUpdate_564156(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This is an asynchronous operation and can be polled to completion using the location header returned by this operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rolloutName: JString (required)
  ##              : The rollout name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rolloutName` field"
  var valid_564158 = path.getOrDefault("rolloutName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "rolloutName", valid_564158
  var valid_564159 = path.getOrDefault("subscriptionId")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "subscriptionId", valid_564159
  var valid_564160 = path.getOrDefault("resourceGroupName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "resourceGroupName", valid_564160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564161 = query.getOrDefault("api-version")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "api-version", valid_564161
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

proc call*(call_564163: Call_RolloutsCreateOrUpdate_564155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This is an asynchronous operation and can be polled to completion using the location header returned by this operation.
  ## 
  let valid = call_564163.validator(path, query, header, formData, body)
  let scheme = call_564163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564163.url(scheme.get, call_564163.host, call_564163.base,
                         call_564163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564163, url, valid)

proc call*(call_564164: Call_RolloutsCreateOrUpdate_564155; apiVersion: string;
          rolloutName: string; subscriptionId: string; resourceGroupName: string;
          rolloutRequest: JsonNode = nil): Recallable =
  ## rolloutsCreateOrUpdate
  ## This is an asynchronous operation and can be polled to completion using the location header returned by this operation.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   rolloutName: string (required)
  ##              : The rollout name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   rolloutRequest: JObject
  ##                 : Source rollout request object that defines the rollout.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564165 = newJObject()
  var query_564166 = newJObject()
  var body_564167 = newJObject()
  add(query_564166, "api-version", newJString(apiVersion))
  add(path_564165, "rolloutName", newJString(rolloutName))
  add(path_564165, "subscriptionId", newJString(subscriptionId))
  if rolloutRequest != nil:
    body_564167 = rolloutRequest
  add(path_564165, "resourceGroupName", newJString(resourceGroupName))
  result = call_564164.call(path_564165, query_564166, nil, nil, body_564167)

var rolloutsCreateOrUpdate* = Call_RolloutsCreateOrUpdate_564155(
    name: "rolloutsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/rollouts/{rolloutName}",
    validator: validate_RolloutsCreateOrUpdate_564156, base: "",
    url: url_RolloutsCreateOrUpdate_564157, schemes: {Scheme.Https})
type
  Call_RolloutsGet_564143 = ref object of OpenApiRestCall_563555
proc url_RolloutsGet_564145(protocol: Scheme; host: string; base: string;
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

proc validate_RolloutsGet_564144(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rolloutName: JString (required)
  ##              : The rollout name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rolloutName` field"
  var valid_564146 = path.getOrDefault("rolloutName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "rolloutName", valid_564146
  var valid_564147 = path.getOrDefault("subscriptionId")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "subscriptionId", valid_564147
  var valid_564148 = path.getOrDefault("resourceGroupName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "resourceGroupName", valid_564148
  result.add "path", section
  ## parameters in `query` object:
  ##   retryAttempt: JInt
  ##               : Rollout retry attempt ordinal to get the result of. If not specified, result of the latest attempt will be returned.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_564149 = query.getOrDefault("retryAttempt")
  valid_564149 = validateParameter(valid_564149, JInt, required = false, default = nil)
  if valid_564149 != nil:
    section.add "retryAttempt", valid_564149
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564150 = query.getOrDefault("api-version")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "api-version", valid_564150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564151: Call_RolloutsGet_564143; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564151.validator(path, query, header, formData, body)
  let scheme = call_564151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564151.url(scheme.get, call_564151.host, call_564151.base,
                         call_564151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564151, url, valid)

proc call*(call_564152: Call_RolloutsGet_564143; apiVersion: string;
          rolloutName: string; subscriptionId: string; resourceGroupName: string;
          retryAttempt: int = 0): Recallable =
  ## rolloutsGet
  ##   retryAttempt: int
  ##               : Rollout retry attempt ordinal to get the result of. If not specified, result of the latest attempt will be returned.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   rolloutName: string (required)
  ##              : The rollout name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564153 = newJObject()
  var query_564154 = newJObject()
  add(query_564154, "retryAttempt", newJInt(retryAttempt))
  add(query_564154, "api-version", newJString(apiVersion))
  add(path_564153, "rolloutName", newJString(rolloutName))
  add(path_564153, "subscriptionId", newJString(subscriptionId))
  add(path_564153, "resourceGroupName", newJString(resourceGroupName))
  result = call_564152.call(path_564153, query_564154, nil, nil, nil)

var rolloutsGet* = Call_RolloutsGet_564143(name: "rolloutsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/rollouts/{rolloutName}",
                                        validator: validate_RolloutsGet_564144,
                                        base: "", url: url_RolloutsGet_564145,
                                        schemes: {Scheme.Https})
type
  Call_RolloutsDelete_564168 = ref object of OpenApiRestCall_563555
proc url_RolloutsDelete_564170(protocol: Scheme; host: string; base: string;
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

proc validate_RolloutsDelete_564169(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Only rollouts in terminal state can be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rolloutName: JString (required)
  ##              : The rollout name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rolloutName` field"
  var valid_564171 = path.getOrDefault("rolloutName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "rolloutName", valid_564171
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
  ##              : The API version to use for this operation.
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
  if body != nil:
    result.add "body", body

proc call*(call_564175: Call_RolloutsDelete_564168; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Only rollouts in terminal state can be deleted.
  ## 
  let valid = call_564175.validator(path, query, header, formData, body)
  let scheme = call_564175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564175.url(scheme.get, call_564175.host, call_564175.base,
                         call_564175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564175, url, valid)

proc call*(call_564176: Call_RolloutsDelete_564168; apiVersion: string;
          rolloutName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## rolloutsDelete
  ## Only rollouts in terminal state can be deleted.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   rolloutName: string (required)
  ##              : The rollout name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564177 = newJObject()
  var query_564178 = newJObject()
  add(query_564178, "api-version", newJString(apiVersion))
  add(path_564177, "rolloutName", newJString(rolloutName))
  add(path_564177, "subscriptionId", newJString(subscriptionId))
  add(path_564177, "resourceGroupName", newJString(resourceGroupName))
  result = call_564176.call(path_564177, query_564178, nil, nil, nil)

var rolloutsDelete* = Call_RolloutsDelete_564168(name: "rolloutsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/rollouts/{rolloutName}",
    validator: validate_RolloutsDelete_564169, base: "", url: url_RolloutsDelete_564170,
    schemes: {Scheme.Https})
type
  Call_RolloutsCancel_564179 = ref object of OpenApiRestCall_563555
proc url_RolloutsCancel_564181(protocol: Scheme; host: string; base: string;
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

proc validate_RolloutsCancel_564180(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Only running rollouts can be canceled.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rolloutName: JString (required)
  ##              : The rollout name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rolloutName` field"
  var valid_564182 = path.getOrDefault("rolloutName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "rolloutName", valid_564182
  var valid_564183 = path.getOrDefault("subscriptionId")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "subscriptionId", valid_564183
  var valid_564184 = path.getOrDefault("resourceGroupName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "resourceGroupName", valid_564184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564185 = query.getOrDefault("api-version")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "api-version", valid_564185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564186: Call_RolloutsCancel_564179; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Only running rollouts can be canceled.
  ## 
  let valid = call_564186.validator(path, query, header, formData, body)
  let scheme = call_564186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564186.url(scheme.get, call_564186.host, call_564186.base,
                         call_564186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564186, url, valid)

proc call*(call_564187: Call_RolloutsCancel_564179; apiVersion: string;
          rolloutName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## rolloutsCancel
  ## Only running rollouts can be canceled.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   rolloutName: string (required)
  ##              : The rollout name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564188 = newJObject()
  var query_564189 = newJObject()
  add(query_564189, "api-version", newJString(apiVersion))
  add(path_564188, "rolloutName", newJString(rolloutName))
  add(path_564188, "subscriptionId", newJString(subscriptionId))
  add(path_564188, "resourceGroupName", newJString(resourceGroupName))
  result = call_564187.call(path_564188, query_564189, nil, nil, nil)

var rolloutsCancel* = Call_RolloutsCancel_564179(name: "rolloutsCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/rollouts/{rolloutName}/cancel",
    validator: validate_RolloutsCancel_564180, base: "", url: url_RolloutsCancel_564181,
    schemes: {Scheme.Https})
type
  Call_RolloutsRestart_564190 = ref object of OpenApiRestCall_563555
proc url_RolloutsRestart_564192(protocol: Scheme; host: string; base: string;
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

proc validate_RolloutsRestart_564191(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Only failed rollouts can be restarted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rolloutName: JString (required)
  ##              : The rollout name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rolloutName` field"
  var valid_564193 = path.getOrDefault("rolloutName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "rolloutName", valid_564193
  var valid_564194 = path.getOrDefault("subscriptionId")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "subscriptionId", valid_564194
  var valid_564195 = path.getOrDefault("resourceGroupName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "resourceGroupName", valid_564195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   skipSucceeded: JBool
  ##                : If true, will skip all succeeded steps so far in the rollout. If false, will execute the entire rollout again regardless of the current state of individual resources. Defaults to false if not specified.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564196 = query.getOrDefault("api-version")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "api-version", valid_564196
  var valid_564197 = query.getOrDefault("skipSucceeded")
  valid_564197 = validateParameter(valid_564197, JBool, required = false, default = nil)
  if valid_564197 != nil:
    section.add "skipSucceeded", valid_564197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564198: Call_RolloutsRestart_564190; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Only failed rollouts can be restarted.
  ## 
  let valid = call_564198.validator(path, query, header, formData, body)
  let scheme = call_564198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564198.url(scheme.get, call_564198.host, call_564198.base,
                         call_564198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564198, url, valid)

proc call*(call_564199: Call_RolloutsRestart_564190; apiVersion: string;
          rolloutName: string; subscriptionId: string; resourceGroupName: string;
          skipSucceeded: bool = false): Recallable =
  ## rolloutsRestart
  ## Only failed rollouts can be restarted.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   rolloutName: string (required)
  ##              : The rollout name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   skipSucceeded: bool
  ##                : If true, will skip all succeeded steps so far in the rollout. If false, will execute the entire rollout again regardless of the current state of individual resources. Defaults to false if not specified.
  var path_564200 = newJObject()
  var query_564201 = newJObject()
  add(query_564201, "api-version", newJString(apiVersion))
  add(path_564200, "rolloutName", newJString(rolloutName))
  add(path_564200, "subscriptionId", newJString(subscriptionId))
  add(path_564200, "resourceGroupName", newJString(resourceGroupName))
  add(query_564201, "skipSucceeded", newJBool(skipSucceeded))
  result = call_564199.call(path_564200, query_564201, nil, nil, nil)

var rolloutsRestart* = Call_RolloutsRestart_564190(name: "rolloutsRestart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/rollouts/{rolloutName}/restart",
    validator: validate_RolloutsRestart_564191, base: "", url: url_RolloutsRestart_564192,
    schemes: {Scheme.Https})
type
  Call_ServiceTopologiesCreateOrUpdate_564213 = ref object of OpenApiRestCall_563555
proc url_ServiceTopologiesCreateOrUpdate_564215(protocol: Scheme; host: string;
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

proc validate_ServiceTopologiesCreateOrUpdate_564214(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Synchronously creates a new service topology or updates an existing service topology.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564216 = path.getOrDefault("subscriptionId")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "subscriptionId", valid_564216
  var valid_564217 = path.getOrDefault("serviceTopologyName")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "serviceTopologyName", valid_564217
  var valid_564218 = path.getOrDefault("resourceGroupName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "resourceGroupName", valid_564218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564219 = query.getOrDefault("api-version")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "api-version", valid_564219
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

proc call*(call_564221: Call_ServiceTopologiesCreateOrUpdate_564213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Synchronously creates a new service topology or updates an existing service topology.
  ## 
  let valid = call_564221.validator(path, query, header, formData, body)
  let scheme = call_564221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564221.url(scheme.get, call_564221.host, call_564221.base,
                         call_564221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564221, url, valid)

proc call*(call_564222: Call_ServiceTopologiesCreateOrUpdate_564213;
          apiVersion: string; subscriptionId: string; serviceTopologyName: string;
          resourceGroupName: string; serviceTopologyInfo: JsonNode): Recallable =
  ## serviceTopologiesCreateOrUpdate
  ## Synchronously creates a new service topology or updates an existing service topology.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   serviceTopologyInfo: JObject (required)
  ##                      : Source topology object defines the resource.
  var path_564223 = newJObject()
  var query_564224 = newJObject()
  var body_564225 = newJObject()
  add(query_564224, "api-version", newJString(apiVersion))
  add(path_564223, "subscriptionId", newJString(subscriptionId))
  add(path_564223, "serviceTopologyName", newJString(serviceTopologyName))
  add(path_564223, "resourceGroupName", newJString(resourceGroupName))
  if serviceTopologyInfo != nil:
    body_564225 = serviceTopologyInfo
  result = call_564222.call(path_564223, query_564224, nil, nil, body_564225)

var serviceTopologiesCreateOrUpdate* = Call_ServiceTopologiesCreateOrUpdate_564213(
    name: "serviceTopologiesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}",
    validator: validate_ServiceTopologiesCreateOrUpdate_564214, base: "",
    url: url_ServiceTopologiesCreateOrUpdate_564215, schemes: {Scheme.Https})
type
  Call_ServiceTopologiesGet_564202 = ref object of OpenApiRestCall_563555
proc url_ServiceTopologiesGet_564204(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceTopologiesGet_564203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564205 = path.getOrDefault("subscriptionId")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "subscriptionId", valid_564205
  var valid_564206 = path.getOrDefault("serviceTopologyName")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "serviceTopologyName", valid_564206
  var valid_564207 = path.getOrDefault("resourceGroupName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "resourceGroupName", valid_564207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564208 = query.getOrDefault("api-version")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "api-version", valid_564208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564209: Call_ServiceTopologiesGet_564202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564209.validator(path, query, header, formData, body)
  let scheme = call_564209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564209.url(scheme.get, call_564209.host, call_564209.base,
                         call_564209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564209, url, valid)

proc call*(call_564210: Call_ServiceTopologiesGet_564202; apiVersion: string;
          subscriptionId: string; serviceTopologyName: string;
          resourceGroupName: string): Recallable =
  ## serviceTopologiesGet
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564211 = newJObject()
  var query_564212 = newJObject()
  add(query_564212, "api-version", newJString(apiVersion))
  add(path_564211, "subscriptionId", newJString(subscriptionId))
  add(path_564211, "serviceTopologyName", newJString(serviceTopologyName))
  add(path_564211, "resourceGroupName", newJString(resourceGroupName))
  result = call_564210.call(path_564211, query_564212, nil, nil, nil)

var serviceTopologiesGet* = Call_ServiceTopologiesGet_564202(
    name: "serviceTopologiesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}",
    validator: validate_ServiceTopologiesGet_564203, base: "",
    url: url_ServiceTopologiesGet_564204, schemes: {Scheme.Https})
type
  Call_ServiceTopologiesDelete_564226 = ref object of OpenApiRestCall_563555
proc url_ServiceTopologiesDelete_564228(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceTopologiesDelete_564227(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564229 = path.getOrDefault("subscriptionId")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "subscriptionId", valid_564229
  var valid_564230 = path.getOrDefault("serviceTopologyName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "serviceTopologyName", valid_564230
  var valid_564231 = path.getOrDefault("resourceGroupName")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "resourceGroupName", valid_564231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564232 = query.getOrDefault("api-version")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "api-version", valid_564232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564233: Call_ServiceTopologiesDelete_564226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564233.validator(path, query, header, formData, body)
  let scheme = call_564233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564233.url(scheme.get, call_564233.host, call_564233.base,
                         call_564233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564233, url, valid)

proc call*(call_564234: Call_ServiceTopologiesDelete_564226; apiVersion: string;
          subscriptionId: string; serviceTopologyName: string;
          resourceGroupName: string): Recallable =
  ## serviceTopologiesDelete
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564235 = newJObject()
  var query_564236 = newJObject()
  add(query_564236, "api-version", newJString(apiVersion))
  add(path_564235, "subscriptionId", newJString(subscriptionId))
  add(path_564235, "serviceTopologyName", newJString(serviceTopologyName))
  add(path_564235, "resourceGroupName", newJString(resourceGroupName))
  result = call_564234.call(path_564235, query_564236, nil, nil, nil)

var serviceTopologiesDelete* = Call_ServiceTopologiesDelete_564226(
    name: "serviceTopologiesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}",
    validator: validate_ServiceTopologiesDelete_564227, base: "",
    url: url_ServiceTopologiesDelete_564228, schemes: {Scheme.Https})
type
  Call_ServicesCreateOrUpdate_564249 = ref object of OpenApiRestCall_563555
proc url_ServicesCreateOrUpdate_564251(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesCreateOrUpdate_564250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Synchronously creates a new service or updates an existing service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service resource.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564252 = path.getOrDefault("serviceName")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "serviceName", valid_564252
  var valid_564253 = path.getOrDefault("subscriptionId")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "subscriptionId", valid_564253
  var valid_564254 = path.getOrDefault("serviceTopologyName")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "serviceTopologyName", valid_564254
  var valid_564255 = path.getOrDefault("resourceGroupName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "resourceGroupName", valid_564255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564256 = query.getOrDefault("api-version")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "api-version", valid_564256
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

proc call*(call_564258: Call_ServicesCreateOrUpdate_564249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Synchronously creates a new service or updates an existing service.
  ## 
  let valid = call_564258.validator(path, query, header, formData, body)
  let scheme = call_564258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564258.url(scheme.get, call_564258.host, call_564258.base,
                         call_564258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564258, url, valid)

proc call*(call_564259: Call_ServicesCreateOrUpdate_564249; serviceName: string;
          apiVersion: string; subscriptionId: string; serviceTopologyName: string;
          serviceInfo: JsonNode; resourceGroupName: string): Recallable =
  ## servicesCreateOrUpdate
  ## Synchronously creates a new service or updates an existing service.
  ##   serviceName: string (required)
  ##              : The name of the service resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  ##   serviceInfo: JObject (required)
  ##              : The service object
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564260 = newJObject()
  var query_564261 = newJObject()
  var body_564262 = newJObject()
  add(path_564260, "serviceName", newJString(serviceName))
  add(query_564261, "api-version", newJString(apiVersion))
  add(path_564260, "subscriptionId", newJString(subscriptionId))
  add(path_564260, "serviceTopologyName", newJString(serviceTopologyName))
  if serviceInfo != nil:
    body_564262 = serviceInfo
  add(path_564260, "resourceGroupName", newJString(resourceGroupName))
  result = call_564259.call(path_564260, query_564261, nil, nil, body_564262)

var servicesCreateOrUpdate* = Call_ServicesCreateOrUpdate_564249(
    name: "servicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}/services/{serviceName}",
    validator: validate_ServicesCreateOrUpdate_564250, base: "",
    url: url_ServicesCreateOrUpdate_564251, schemes: {Scheme.Https})
type
  Call_ServicesGet_564237 = ref object of OpenApiRestCall_563555
proc url_ServicesGet_564239(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesGet_564238(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service resource.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564240 = path.getOrDefault("serviceName")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "serviceName", valid_564240
  var valid_564241 = path.getOrDefault("subscriptionId")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "subscriptionId", valid_564241
  var valid_564242 = path.getOrDefault("serviceTopologyName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "serviceTopologyName", valid_564242
  var valid_564243 = path.getOrDefault("resourceGroupName")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "resourceGroupName", valid_564243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564244 = query.getOrDefault("api-version")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "api-version", valid_564244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564245: Call_ServicesGet_564237; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564245.validator(path, query, header, formData, body)
  let scheme = call_564245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564245.url(scheme.get, call_564245.host, call_564245.base,
                         call_564245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564245, url, valid)

proc call*(call_564246: Call_ServicesGet_564237; serviceName: string;
          apiVersion: string; subscriptionId: string; serviceTopologyName: string;
          resourceGroupName: string): Recallable =
  ## servicesGet
  ##   serviceName: string (required)
  ##              : The name of the service resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564247 = newJObject()
  var query_564248 = newJObject()
  add(path_564247, "serviceName", newJString(serviceName))
  add(query_564248, "api-version", newJString(apiVersion))
  add(path_564247, "subscriptionId", newJString(subscriptionId))
  add(path_564247, "serviceTopologyName", newJString(serviceTopologyName))
  add(path_564247, "resourceGroupName", newJString(resourceGroupName))
  result = call_564246.call(path_564247, query_564248, nil, nil, nil)

var servicesGet* = Call_ServicesGet_564237(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}/services/{serviceName}",
                                        validator: validate_ServicesGet_564238,
                                        base: "", url: url_ServicesGet_564239,
                                        schemes: {Scheme.Https})
type
  Call_ServicesDelete_564263 = ref object of OpenApiRestCall_563555
proc url_ServicesDelete_564265(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesDelete_564264(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service resource.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564266 = path.getOrDefault("serviceName")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "serviceName", valid_564266
  var valid_564267 = path.getOrDefault("subscriptionId")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "subscriptionId", valid_564267
  var valid_564268 = path.getOrDefault("serviceTopologyName")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "serviceTopologyName", valid_564268
  var valid_564269 = path.getOrDefault("resourceGroupName")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "resourceGroupName", valid_564269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564270 = query.getOrDefault("api-version")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "api-version", valid_564270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564271: Call_ServicesDelete_564263; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564271.validator(path, query, header, formData, body)
  let scheme = call_564271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564271.url(scheme.get, call_564271.host, call_564271.base,
                         call_564271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564271, url, valid)

proc call*(call_564272: Call_ServicesDelete_564263; serviceName: string;
          apiVersion: string; subscriptionId: string; serviceTopologyName: string;
          resourceGroupName: string): Recallable =
  ## servicesDelete
  ##   serviceName: string (required)
  ##              : The name of the service resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564273 = newJObject()
  var query_564274 = newJObject()
  add(path_564273, "serviceName", newJString(serviceName))
  add(query_564274, "api-version", newJString(apiVersion))
  add(path_564273, "subscriptionId", newJString(subscriptionId))
  add(path_564273, "serviceTopologyName", newJString(serviceTopologyName))
  add(path_564273, "resourceGroupName", newJString(resourceGroupName))
  result = call_564272.call(path_564273, query_564274, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_564263(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}/services/{serviceName}",
    validator: validate_ServicesDelete_564264, base: "", url: url_ServicesDelete_564265,
    schemes: {Scheme.Https})
type
  Call_ServiceUnitsCreateOrUpdate_564288 = ref object of OpenApiRestCall_563555
proc url_ServiceUnitsCreateOrUpdate_564290(protocol: Scheme; host: string;
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

proc validate_ServiceUnitsCreateOrUpdate_564289(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This is an asynchronous operation and can be polled to completion using the operation resource returned by this operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service resource.
  ##   serviceUnitName: JString (required)
  ##                  : The name of the service unit resource.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564291 = path.getOrDefault("serviceName")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "serviceName", valid_564291
  var valid_564292 = path.getOrDefault("serviceUnitName")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "serviceUnitName", valid_564292
  var valid_564293 = path.getOrDefault("subscriptionId")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "subscriptionId", valid_564293
  var valid_564294 = path.getOrDefault("serviceTopologyName")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "serviceTopologyName", valid_564294
  var valid_564295 = path.getOrDefault("resourceGroupName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "resourceGroupName", valid_564295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564296 = query.getOrDefault("api-version")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "api-version", valid_564296
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

proc call*(call_564298: Call_ServiceUnitsCreateOrUpdate_564288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This is an asynchronous operation and can be polled to completion using the operation resource returned by this operation.
  ## 
  let valid = call_564298.validator(path, query, header, formData, body)
  let scheme = call_564298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564298.url(scheme.get, call_564298.host, call_564298.base,
                         call_564298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564298, url, valid)

proc call*(call_564299: Call_ServiceUnitsCreateOrUpdate_564288;
          serviceName: string; serviceUnitName: string; apiVersion: string;
          serviceUnitInfo: JsonNode; subscriptionId: string;
          serviceTopologyName: string; resourceGroupName: string): Recallable =
  ## serviceUnitsCreateOrUpdate
  ## This is an asynchronous operation and can be polled to completion using the operation resource returned by this operation.
  ##   serviceName: string (required)
  ##              : The name of the service resource.
  ##   serviceUnitName: string (required)
  ##                  : The name of the service unit resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   serviceUnitInfo: JObject (required)
  ##                  : The service unit resource object.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564300 = newJObject()
  var query_564301 = newJObject()
  var body_564302 = newJObject()
  add(path_564300, "serviceName", newJString(serviceName))
  add(path_564300, "serviceUnitName", newJString(serviceUnitName))
  add(query_564301, "api-version", newJString(apiVersion))
  if serviceUnitInfo != nil:
    body_564302 = serviceUnitInfo
  add(path_564300, "subscriptionId", newJString(subscriptionId))
  add(path_564300, "serviceTopologyName", newJString(serviceTopologyName))
  add(path_564300, "resourceGroupName", newJString(resourceGroupName))
  result = call_564299.call(path_564300, query_564301, nil, nil, body_564302)

var serviceUnitsCreateOrUpdate* = Call_ServiceUnitsCreateOrUpdate_564288(
    name: "serviceUnitsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}/services/{serviceName}/serviceUnits/{serviceUnitName}",
    validator: validate_ServiceUnitsCreateOrUpdate_564289, base: "",
    url: url_ServiceUnitsCreateOrUpdate_564290, schemes: {Scheme.Https})
type
  Call_ServiceUnitsGet_564275 = ref object of OpenApiRestCall_563555
proc url_ServiceUnitsGet_564277(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceUnitsGet_564276(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service resource.
  ##   serviceUnitName: JString (required)
  ##                  : The name of the service unit resource.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564278 = path.getOrDefault("serviceName")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "serviceName", valid_564278
  var valid_564279 = path.getOrDefault("serviceUnitName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "serviceUnitName", valid_564279
  var valid_564280 = path.getOrDefault("subscriptionId")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "subscriptionId", valid_564280
  var valid_564281 = path.getOrDefault("serviceTopologyName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "serviceTopologyName", valid_564281
  var valid_564282 = path.getOrDefault("resourceGroupName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "resourceGroupName", valid_564282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564283 = query.getOrDefault("api-version")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "api-version", valid_564283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564284: Call_ServiceUnitsGet_564275; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564284.validator(path, query, header, formData, body)
  let scheme = call_564284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564284.url(scheme.get, call_564284.host, call_564284.base,
                         call_564284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564284, url, valid)

proc call*(call_564285: Call_ServiceUnitsGet_564275; serviceName: string;
          serviceUnitName: string; apiVersion: string; subscriptionId: string;
          serviceTopologyName: string; resourceGroupName: string): Recallable =
  ## serviceUnitsGet
  ##   serviceName: string (required)
  ##              : The name of the service resource.
  ##   serviceUnitName: string (required)
  ##                  : The name of the service unit resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564286 = newJObject()
  var query_564287 = newJObject()
  add(path_564286, "serviceName", newJString(serviceName))
  add(path_564286, "serviceUnitName", newJString(serviceUnitName))
  add(query_564287, "api-version", newJString(apiVersion))
  add(path_564286, "subscriptionId", newJString(subscriptionId))
  add(path_564286, "serviceTopologyName", newJString(serviceTopologyName))
  add(path_564286, "resourceGroupName", newJString(resourceGroupName))
  result = call_564285.call(path_564286, query_564287, nil, nil, nil)

var serviceUnitsGet* = Call_ServiceUnitsGet_564275(name: "serviceUnitsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}/services/{serviceName}/serviceUnits/{serviceUnitName}",
    validator: validate_ServiceUnitsGet_564276, base: "", url: url_ServiceUnitsGet_564277,
    schemes: {Scheme.Https})
type
  Call_ServiceUnitsDelete_564303 = ref object of OpenApiRestCall_563555
proc url_ServiceUnitsDelete_564305(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceUnitsDelete_564304(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service resource.
  ##   serviceUnitName: JString (required)
  ##                  : The name of the service unit resource.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: JString (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564306 = path.getOrDefault("serviceName")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "serviceName", valid_564306
  var valid_564307 = path.getOrDefault("serviceUnitName")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "serviceUnitName", valid_564307
  var valid_564308 = path.getOrDefault("subscriptionId")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "subscriptionId", valid_564308
  var valid_564309 = path.getOrDefault("serviceTopologyName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "serviceTopologyName", valid_564309
  var valid_564310 = path.getOrDefault("resourceGroupName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "resourceGroupName", valid_564310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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

proc call*(call_564312: Call_ServiceUnitsDelete_564303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564312.validator(path, query, header, formData, body)
  let scheme = call_564312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564312.url(scheme.get, call_564312.host, call_564312.base,
                         call_564312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564312, url, valid)

proc call*(call_564313: Call_ServiceUnitsDelete_564303; serviceName: string;
          serviceUnitName: string; apiVersion: string; subscriptionId: string;
          serviceTopologyName: string; resourceGroupName: string): Recallable =
  ## serviceUnitsDelete
  ##   serviceName: string (required)
  ##              : The name of the service resource.
  ##   serviceUnitName: string (required)
  ##                  : The name of the service unit resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceTopologyName: string (required)
  ##                      : The name of the service topology .
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564314 = newJObject()
  var query_564315 = newJObject()
  add(path_564314, "serviceName", newJString(serviceName))
  add(path_564314, "serviceUnitName", newJString(serviceUnitName))
  add(query_564315, "api-version", newJString(apiVersion))
  add(path_564314, "subscriptionId", newJString(subscriptionId))
  add(path_564314, "serviceTopologyName", newJString(serviceTopologyName))
  add(path_564314, "resourceGroupName", newJString(resourceGroupName))
  result = call_564313.call(path_564314, query_564315, nil, nil, nil)

var serviceUnitsDelete* = Call_ServiceUnitsDelete_564303(
    name: "serviceUnitsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/serviceTopologies/{serviceTopologyName}/services/{serviceName}/serviceUnits/{serviceUnitName}",
    validator: validate_ServiceUnitsDelete_564304, base: "",
    url: url_ServiceUnitsDelete_564305, schemes: {Scheme.Https})
type
  Call_StepsCreateOrUpdate_564327 = ref object of OpenApiRestCall_563555
proc url_StepsCreateOrUpdate_564329(protocol: Scheme; host: string; base: string;
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

proc validate_StepsCreateOrUpdate_564328(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Synchronously creates a new step or updates an existing step.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   stepName: JString (required)
  ##           : The name of the deployment step.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564330 = path.getOrDefault("subscriptionId")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "subscriptionId", valid_564330
  var valid_564331 = path.getOrDefault("resourceGroupName")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "resourceGroupName", valid_564331
  var valid_564332 = path.getOrDefault("stepName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "stepName", valid_564332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564333 = query.getOrDefault("api-version")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "api-version", valid_564333
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

proc call*(call_564335: Call_StepsCreateOrUpdate_564327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Synchronously creates a new step or updates an existing step.
  ## 
  let valid = call_564335.validator(path, query, header, formData, body)
  let scheme = call_564335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564335.url(scheme.get, call_564335.host, call_564335.base,
                         call_564335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564335, url, valid)

proc call*(call_564336: Call_StepsCreateOrUpdate_564327; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; stepName: string;
          stepInfo: JsonNode = nil): Recallable =
  ## stepsCreateOrUpdate
  ## Synchronously creates a new step or updates an existing step.
  ##   stepInfo: JObject
  ##           : The step object.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   stepName: string (required)
  ##           : The name of the deployment step.
  var path_564337 = newJObject()
  var query_564338 = newJObject()
  var body_564339 = newJObject()
  if stepInfo != nil:
    body_564339 = stepInfo
  add(query_564338, "api-version", newJString(apiVersion))
  add(path_564337, "subscriptionId", newJString(subscriptionId))
  add(path_564337, "resourceGroupName", newJString(resourceGroupName))
  add(path_564337, "stepName", newJString(stepName))
  result = call_564336.call(path_564337, query_564338, nil, nil, body_564339)

var stepsCreateOrUpdate* = Call_StepsCreateOrUpdate_564327(
    name: "stepsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/steps/{stepName}",
    validator: validate_StepsCreateOrUpdate_564328, base: "",
    url: url_StepsCreateOrUpdate_564329, schemes: {Scheme.Https})
type
  Call_StepsGet_564316 = ref object of OpenApiRestCall_563555
proc url_StepsGet_564318(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_StepsGet_564317(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   stepName: JString (required)
  ##           : The name of the deployment step.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564319 = path.getOrDefault("subscriptionId")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "subscriptionId", valid_564319
  var valid_564320 = path.getOrDefault("resourceGroupName")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "resourceGroupName", valid_564320
  var valid_564321 = path.getOrDefault("stepName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "stepName", valid_564321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564322 = query.getOrDefault("api-version")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "api-version", valid_564322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564323: Call_StepsGet_564316; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564323.validator(path, query, header, formData, body)
  let scheme = call_564323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564323.url(scheme.get, call_564323.host, call_564323.base,
                         call_564323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564323, url, valid)

proc call*(call_564324: Call_StepsGet_564316; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; stepName: string): Recallable =
  ## stepsGet
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   stepName: string (required)
  ##           : The name of the deployment step.
  var path_564325 = newJObject()
  var query_564326 = newJObject()
  add(query_564326, "api-version", newJString(apiVersion))
  add(path_564325, "subscriptionId", newJString(subscriptionId))
  add(path_564325, "resourceGroupName", newJString(resourceGroupName))
  add(path_564325, "stepName", newJString(stepName))
  result = call_564324.call(path_564325, query_564326, nil, nil, nil)

var stepsGet* = Call_StepsGet_564316(name: "stepsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/steps/{stepName}",
                                  validator: validate_StepsGet_564317, base: "",
                                  url: url_StepsGet_564318,
                                  schemes: {Scheme.Https})
type
  Call_StepsDelete_564340 = ref object of OpenApiRestCall_563555
proc url_StepsDelete_564342(protocol: Scheme; host: string; base: string;
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

proc validate_StepsDelete_564341(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   stepName: JString (required)
  ##           : The name of the deployment step.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564343 = path.getOrDefault("subscriptionId")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "subscriptionId", valid_564343
  var valid_564344 = path.getOrDefault("resourceGroupName")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "resourceGroupName", valid_564344
  var valid_564345 = path.getOrDefault("stepName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "stepName", valid_564345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564346 = query.getOrDefault("api-version")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "api-version", valid_564346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564347: Call_StepsDelete_564340; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564347.validator(path, query, header, formData, body)
  let scheme = call_564347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564347.url(scheme.get, call_564347.host, call_564347.base,
                         call_564347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564347, url, valid)

proc call*(call_564348: Call_StepsDelete_564340; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; stepName: string): Recallable =
  ## stepsDelete
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   stepName: string (required)
  ##           : The name of the deployment step.
  var path_564349 = newJObject()
  var query_564350 = newJObject()
  add(query_564350, "api-version", newJString(apiVersion))
  add(path_564349, "subscriptionId", newJString(subscriptionId))
  add(path_564349, "resourceGroupName", newJString(resourceGroupName))
  add(path_564349, "stepName", newJString(stepName))
  result = call_564348.call(path_564349, query_564350, nil, nil, nil)

var stepsDelete* = Call_StepsDelete_564340(name: "stepsDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DeploymentManager/steps/{stepName}",
                                        validator: validate_StepsDelete_564341,
                                        base: "", url: url_StepsDelete_564342,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
