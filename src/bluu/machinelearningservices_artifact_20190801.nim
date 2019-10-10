
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Artifact
## version: 2019-08-01
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

  OpenApiRestCall_573641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573641): Option[Scheme] {.used.} =
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
  macServiceName = "machinelearningservices-artifact"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ArtifactsBatchGetById_573863 = ref object of OpenApiRestCall_573641
proc url_ArtifactsBatchGetById_573865(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/batch/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsBatchGetById_573864(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Batch Artifacts by the specific Ids.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574038 = path.getOrDefault("resourceGroupName")
  valid_574038 = validateParameter(valid_574038, JString, required = true,
                                 default = nil)
  if valid_574038 != nil:
    section.add "resourceGroupName", valid_574038
  var valid_574039 = path.getOrDefault("subscriptionId")
  valid_574039 = validateParameter(valid_574039, JString, required = true,
                                 default = nil)
  if valid_574039 != nil:
    section.add "subscriptionId", valid_574039
  var valid_574040 = path.getOrDefault("workspaceName")
  valid_574040 = validateParameter(valid_574040, JString, required = true,
                                 default = nil)
  if valid_574040 != nil:
    section.add "workspaceName", valid_574040
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactIds: JObject (required)
  ##              : The command for Batch Artifact get request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574064: Call_ArtifactsBatchGetById_573863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Batch Artifacts by the specific Ids.
  ## 
  let valid = call_574064.validator(path, query, header, formData, body)
  let scheme = call_574064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574064.url(scheme.get, call_574064.host, call_574064.base,
                         call_574064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574064, url, valid)

proc call*(call_574135: Call_ArtifactsBatchGetById_573863;
          resourceGroupName: string; artifactIds: JsonNode; subscriptionId: string;
          workspaceName: string): Recallable =
  ## artifactsBatchGetById
  ## Get Batch Artifacts by the specific Ids.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   artifactIds: JObject (required)
  ##              : The command for Batch Artifact get request.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574136 = newJObject()
  var body_574138 = newJObject()
  add(path_574136, "resourceGroupName", newJString(resourceGroupName))
  if artifactIds != nil:
    body_574138 = artifactIds
  add(path_574136, "subscriptionId", newJString(subscriptionId))
  add(path_574136, "workspaceName", newJString(workspaceName))
  result = call_574135.call(path_574136, nil, nil, nil, body_574138)

var artifactsBatchGetById* = Call_ArtifactsBatchGetById_573863(
    name: "artifactsBatchGetById", meth: HttpMethod.HttpPost, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/batch/metadata",
    validator: validate_ArtifactsBatchGetById_573864, base: "",
    url: url_ArtifactsBatchGetById_573865, schemes: {Scheme.Https})
type
  Call_ArtifactsCreate_574177 = ref object of OpenApiRestCall_573641
proc url_ArtifactsCreate_574179(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsCreate_574178(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Create an Artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574180 = path.getOrDefault("resourceGroupName")
  valid_574180 = validateParameter(valid_574180, JString, required = true,
                                 default = nil)
  if valid_574180 != nil:
    section.add "resourceGroupName", valid_574180
  var valid_574181 = path.getOrDefault("subscriptionId")
  valid_574181 = validateParameter(valid_574181, JString, required = true,
                                 default = nil)
  if valid_574181 != nil:
    section.add "subscriptionId", valid_574181
  var valid_574182 = path.getOrDefault("workspaceName")
  valid_574182 = validateParameter(valid_574182, JString, required = true,
                                 default = nil)
  if valid_574182 != nil:
    section.add "workspaceName", valid_574182
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifact: JObject (required)
  ##           : The Artifact details.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574184: Call_ArtifactsCreate_574177; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an Artifact.
  ## 
  let valid = call_574184.validator(path, query, header, formData, body)
  let scheme = call_574184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574184.url(scheme.get, call_574184.host, call_574184.base,
                         call_574184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574184, url, valid)

proc call*(call_574185: Call_ArtifactsCreate_574177; artifact: JsonNode;
          resourceGroupName: string; subscriptionId: string; workspaceName: string): Recallable =
  ## artifactsCreate
  ## Create an Artifact.
  ##   artifact: JObject (required)
  ##           : The Artifact details.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574186 = newJObject()
  var body_574187 = newJObject()
  if artifact != nil:
    body_574187 = artifact
  add(path_574186, "resourceGroupName", newJString(resourceGroupName))
  add(path_574186, "subscriptionId", newJString(subscriptionId))
  add(path_574186, "workspaceName", newJString(workspaceName))
  result = call_574185.call(path_574186, nil, nil, nil, body_574187)

var artifactsCreate* = Call_ArtifactsCreate_574177(name: "artifactsCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/metadata",
    validator: validate_ArtifactsCreate_574178, base: "", url: url_ArtifactsCreate_574179,
    schemes: {Scheme.Https})
type
  Call_ArtifactsRegister_574188 = ref object of OpenApiRestCall_573641
proc url_ArtifactsRegister_574190(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/register")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsRegister_574189(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Create an Artifact for an existing dataPath.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574191 = path.getOrDefault("resourceGroupName")
  valid_574191 = validateParameter(valid_574191, JString, required = true,
                                 default = nil)
  if valid_574191 != nil:
    section.add "resourceGroupName", valid_574191
  var valid_574192 = path.getOrDefault("subscriptionId")
  valid_574192 = validateParameter(valid_574192, JString, required = true,
                                 default = nil)
  if valid_574192 != nil:
    section.add "subscriptionId", valid_574192
  var valid_574193 = path.getOrDefault("workspaceName")
  valid_574193 = validateParameter(valid_574193, JString, required = true,
                                 default = nil)
  if valid_574193 != nil:
    section.add "workspaceName", valid_574193
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifact: JObject (required)
  ##           : The Artifact creation details.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574195: Call_ArtifactsRegister_574188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an Artifact for an existing dataPath.
  ## 
  let valid = call_574195.validator(path, query, header, formData, body)
  let scheme = call_574195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574195.url(scheme.get, call_574195.host, call_574195.base,
                         call_574195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574195, url, valid)

proc call*(call_574196: Call_ArtifactsRegister_574188; artifact: JsonNode;
          resourceGroupName: string; subscriptionId: string; workspaceName: string): Recallable =
  ## artifactsRegister
  ## Create an Artifact for an existing dataPath.
  ##   artifact: JObject (required)
  ##           : The Artifact creation details.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574197 = newJObject()
  var body_574198 = newJObject()
  if artifact != nil:
    body_574198 = artifact
  add(path_574197, "resourceGroupName", newJString(resourceGroupName))
  add(path_574197, "subscriptionId", newJString(subscriptionId))
  add(path_574197, "workspaceName", newJString(workspaceName))
  result = call_574196.call(path_574197, nil, nil, nil, body_574198)

var artifactsRegister* = Call_ArtifactsRegister_574188(name: "artifactsRegister",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/register",
    validator: validate_ArtifactsRegister_574189, base: "",
    url: url_ArtifactsRegister_574190, schemes: {Scheme.Https})
type
  Call_ArtifactsBatchGetStorageById_574199 = ref object of OpenApiRestCall_573641
proc url_ArtifactsBatchGetStorageById_574201(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/artifacts/storageuri/batch/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsBatchGetStorageById_574200(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Batch Artifacts storage by specific Ids.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574202 = path.getOrDefault("resourceGroupName")
  valid_574202 = validateParameter(valid_574202, JString, required = true,
                                 default = nil)
  if valid_574202 != nil:
    section.add "resourceGroupName", valid_574202
  var valid_574203 = path.getOrDefault("subscriptionId")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "subscriptionId", valid_574203
  var valid_574204 = path.getOrDefault("workspaceName")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "workspaceName", valid_574204
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactIds: JObject (required)
  ##              : The list of artifactIds to get.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574206: Call_ArtifactsBatchGetStorageById_574199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Batch Artifacts storage by specific Ids.
  ## 
  let valid = call_574206.validator(path, query, header, formData, body)
  let scheme = call_574206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574206.url(scheme.get, call_574206.host, call_574206.base,
                         call_574206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574206, url, valid)

proc call*(call_574207: Call_ArtifactsBatchGetStorageById_574199;
          resourceGroupName: string; artifactIds: JsonNode; subscriptionId: string;
          workspaceName: string): Recallable =
  ## artifactsBatchGetStorageById
  ## Get Batch Artifacts storage by specific Ids.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   artifactIds: JObject (required)
  ##              : The list of artifactIds to get.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574208 = newJObject()
  var body_574209 = newJObject()
  add(path_574208, "resourceGroupName", newJString(resourceGroupName))
  if artifactIds != nil:
    body_574209 = artifactIds
  add(path_574208, "subscriptionId", newJString(subscriptionId))
  add(path_574208, "workspaceName", newJString(workspaceName))
  result = call_574207.call(path_574208, nil, nil, nil, body_574209)

var artifactsBatchGetStorageById* = Call_ArtifactsBatchGetStorageById_574199(
    name: "artifactsBatchGetStorageById", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/storageuri/batch/metadata",
    validator: validate_ArtifactsBatchGetStorageById_574200, base: "",
    url: url_ArtifactsBatchGetStorageById_574201, schemes: {Scheme.Https})
type
  Call_ArtifactsListInContainer_574210 = ref object of OpenApiRestCall_573641
proc url_ArtifactsListInContainer_574212(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsListInContainer_574211(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Artifacts metadata in a specific container or path.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574213 = path.getOrDefault("resourceGroupName")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "resourceGroupName", valid_574213
  var valid_574214 = path.getOrDefault("origin")
  valid_574214 = validateParameter(valid_574214, JString, required = true,
                                 default = nil)
  if valid_574214 != nil:
    section.add "origin", valid_574214
  var valid_574215 = path.getOrDefault("subscriptionId")
  valid_574215 = validateParameter(valid_574215, JString, required = true,
                                 default = nil)
  if valid_574215 != nil:
    section.add "subscriptionId", valid_574215
  var valid_574216 = path.getOrDefault("container")
  valid_574216 = validateParameter(valid_574216, JString, required = true,
                                 default = nil)
  if valid_574216 != nil:
    section.add "container", valid_574216
  var valid_574217 = path.getOrDefault("workspaceName")
  valid_574217 = validateParameter(valid_574217, JString, required = true,
                                 default = nil)
  if valid_574217 != nil:
    section.add "workspaceName", valid_574217
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  ##   continuationToken: JString
  ##                    : The continuation token.
  section = newJObject()
  var valid_574218 = query.getOrDefault("path")
  valid_574218 = validateParameter(valid_574218, JString, required = false,
                                 default = nil)
  if valid_574218 != nil:
    section.add "path", valid_574218
  var valid_574219 = query.getOrDefault("continuationToken")
  valid_574219 = validateParameter(valid_574219, JString, required = false,
                                 default = nil)
  if valid_574219 != nil:
    section.add "continuationToken", valid_574219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574220: Call_ArtifactsListInContainer_574210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Artifacts metadata in a specific container or path.
  ## 
  let valid = call_574220.validator(path, query, header, formData, body)
  let scheme = call_574220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574220.url(scheme.get, call_574220.host, call_574220.base,
                         call_574220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574220, url, valid)

proc call*(call_574221: Call_ArtifactsListInContainer_574210;
          resourceGroupName: string; origin: string; subscriptionId: string;
          container: string; workspaceName: string; path: string = "";
          continuationToken: string = ""): Recallable =
  ## artifactsListInContainer
  ## Get Artifacts metadata in a specific container or path.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   path: string
  ##       : The Artifact Path.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574222 = newJObject()
  var query_574223 = newJObject()
  add(path_574222, "resourceGroupName", newJString(resourceGroupName))
  add(path_574222, "origin", newJString(origin))
  add(path_574222, "subscriptionId", newJString(subscriptionId))
  add(path_574222, "container", newJString(container))
  add(query_574223, "path", newJString(path))
  add(query_574223, "continuationToken", newJString(continuationToken))
  add(path_574222, "workspaceName", newJString(workspaceName))
  result = call_574221.call(path_574222, query_574223, nil, nil, nil)

var artifactsListInContainer* = Call_ArtifactsListInContainer_574210(
    name: "artifactsListInContainer", meth: HttpMethod.HttpGet, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}",
    validator: validate_ArtifactsListInContainer_574211, base: "",
    url: url_ArtifactsListInContainer_574212, schemes: {Scheme.Https})
type
  Call_ArtifactsDeleteMetaDataInContainer_574224 = ref object of OpenApiRestCall_573641
proc url_ArtifactsDeleteMetaDataInContainer_574226(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/batch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsDeleteMetaDataInContainer_574225(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete Artifact Metadata in a specific container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574227 = path.getOrDefault("resourceGroupName")
  valid_574227 = validateParameter(valid_574227, JString, required = true,
                                 default = nil)
  if valid_574227 != nil:
    section.add "resourceGroupName", valid_574227
  var valid_574228 = path.getOrDefault("origin")
  valid_574228 = validateParameter(valid_574228, JString, required = true,
                                 default = nil)
  if valid_574228 != nil:
    section.add "origin", valid_574228
  var valid_574229 = path.getOrDefault("subscriptionId")
  valid_574229 = validateParameter(valid_574229, JString, required = true,
                                 default = nil)
  if valid_574229 != nil:
    section.add "subscriptionId", valid_574229
  var valid_574230 = path.getOrDefault("container")
  valid_574230 = validateParameter(valid_574230, JString, required = true,
                                 default = nil)
  if valid_574230 != nil:
    section.add "container", valid_574230
  var valid_574231 = path.getOrDefault("workspaceName")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "workspaceName", valid_574231
  result.add "path", section
  ## parameters in `query` object:
  ##   hardDelete: JBool
  ##             : If set to true. The delete cannot be revert at later time.
  section = newJObject()
  var valid_574245 = query.getOrDefault("hardDelete")
  valid_574245 = validateParameter(valid_574245, JBool, required = false,
                                 default = newJBool(false))
  if valid_574245 != nil:
    section.add "hardDelete", valid_574245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574246: Call_ArtifactsDeleteMetaDataInContainer_574224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete Artifact Metadata in a specific container.
  ## 
  let valid = call_574246.validator(path, query, header, formData, body)
  let scheme = call_574246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574246.url(scheme.get, call_574246.host, call_574246.base,
                         call_574246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574246, url, valid)

proc call*(call_574247: Call_ArtifactsDeleteMetaDataInContainer_574224;
          resourceGroupName: string; origin: string; subscriptionId: string;
          container: string; workspaceName: string; hardDelete: bool = false): Recallable =
  ## artifactsDeleteMetaDataInContainer
  ## Delete Artifact Metadata in a specific container.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   hardDelete: bool
  ##             : If set to true. The delete cannot be revert at later time.
  ##   container: string (required)
  ##            : The container name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574248 = newJObject()
  var query_574249 = newJObject()
  add(path_574248, "resourceGroupName", newJString(resourceGroupName))
  add(path_574248, "origin", newJString(origin))
  add(path_574248, "subscriptionId", newJString(subscriptionId))
  add(query_574249, "hardDelete", newJBool(hardDelete))
  add(path_574248, "container", newJString(container))
  add(path_574248, "workspaceName", newJString(workspaceName))
  result = call_574247.call(path_574248, query_574249, nil, nil, nil)

var artifactsDeleteMetaDataInContainer* = Call_ArtifactsDeleteMetaDataInContainer_574224(
    name: "artifactsDeleteMetaDataInContainer", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/batch",
    validator: validate_ArtifactsDeleteMetaDataInContainer_574225, base: "",
    url: url_ArtifactsDeleteMetaDataInContainer_574226, schemes: {Scheme.Https})
type
  Call_ArtifactsBatchIngestFromSas_574250 = ref object of OpenApiRestCall_573641
proc url_ArtifactsBatchIngestFromSas_574252(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/batch/ingest/containersas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsBatchIngestFromSas_574251(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Ingest Batch Artifacts using shared access signature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574253 = path.getOrDefault("resourceGroupName")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = nil)
  if valid_574253 != nil:
    section.add "resourceGroupName", valid_574253
  var valid_574254 = path.getOrDefault("origin")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "origin", valid_574254
  var valid_574255 = path.getOrDefault("subscriptionId")
  valid_574255 = validateParameter(valid_574255, JString, required = true,
                                 default = nil)
  if valid_574255 != nil:
    section.add "subscriptionId", valid_574255
  var valid_574256 = path.getOrDefault("container")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = nil)
  if valid_574256 != nil:
    section.add "container", valid_574256
  var valid_574257 = path.getOrDefault("workspaceName")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "workspaceName", valid_574257
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactContainerSas: JObject (required)
  ##                       : The artifact container shared access signature to use for batch ingest.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574259: Call_ArtifactsBatchIngestFromSas_574250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Ingest Batch Artifacts using shared access signature.
  ## 
  let valid = call_574259.validator(path, query, header, formData, body)
  let scheme = call_574259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574259.url(scheme.get, call_574259.host, call_574259.base,
                         call_574259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574259, url, valid)

proc call*(call_574260: Call_ArtifactsBatchIngestFromSas_574250;
          resourceGroupName: string; origin: string; subscriptionId: string;
          container: string; workspaceName: string; artifactContainerSas: JsonNode): Recallable =
  ## artifactsBatchIngestFromSas
  ## Ingest Batch Artifacts using shared access signature.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   artifactContainerSas: JObject (required)
  ##                       : The artifact container shared access signature to use for batch ingest.
  var path_574261 = newJObject()
  var body_574262 = newJObject()
  add(path_574261, "resourceGroupName", newJString(resourceGroupName))
  add(path_574261, "origin", newJString(origin))
  add(path_574261, "subscriptionId", newJString(subscriptionId))
  add(path_574261, "container", newJString(container))
  add(path_574261, "workspaceName", newJString(workspaceName))
  if artifactContainerSas != nil:
    body_574262 = artifactContainerSas
  result = call_574260.call(path_574261, nil, nil, nil, body_574262)

var artifactsBatchIngestFromSas* = Call_ArtifactsBatchIngestFromSas_574250(
    name: "artifactsBatchIngestFromSas", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/batch/ingest/containersas",
    validator: validate_ArtifactsBatchIngestFromSas_574251, base: "",
    url: url_ArtifactsBatchIngestFromSas_574252, schemes: {Scheme.Https})
type
  Call_ArtifactsBatchCreateEmptyArtifacts_574263 = ref object of OpenApiRestCall_573641
proc url_ArtifactsBatchCreateEmptyArtifacts_574265(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/batch/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsBatchCreateEmptyArtifacts_574264(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a Batch of empty Artifacts from the supplied paths.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574266 = path.getOrDefault("resourceGroupName")
  valid_574266 = validateParameter(valid_574266, JString, required = true,
                                 default = nil)
  if valid_574266 != nil:
    section.add "resourceGroupName", valid_574266
  var valid_574267 = path.getOrDefault("origin")
  valid_574267 = validateParameter(valid_574267, JString, required = true,
                                 default = nil)
  if valid_574267 != nil:
    section.add "origin", valid_574267
  var valid_574268 = path.getOrDefault("subscriptionId")
  valid_574268 = validateParameter(valid_574268, JString, required = true,
                                 default = nil)
  if valid_574268 != nil:
    section.add "subscriptionId", valid_574268
  var valid_574269 = path.getOrDefault("container")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "container", valid_574269
  var valid_574270 = path.getOrDefault("workspaceName")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "workspaceName", valid_574270
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactPaths: JObject (required)
  ##                : The list of Artifact paths to create.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574272: Call_ArtifactsBatchCreateEmptyArtifacts_574263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a Batch of empty Artifacts from the supplied paths.
  ## 
  let valid = call_574272.validator(path, query, header, formData, body)
  let scheme = call_574272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574272.url(scheme.get, call_574272.host, call_574272.base,
                         call_574272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574272, url, valid)

proc call*(call_574273: Call_ArtifactsBatchCreateEmptyArtifacts_574263;
          resourceGroupName: string; origin: string; subscriptionId: string;
          container: string; artifactPaths: JsonNode; workspaceName: string): Recallable =
  ## artifactsBatchCreateEmptyArtifacts
  ## Create a Batch of empty Artifacts from the supplied paths.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   artifactPaths: JObject (required)
  ##                : The list of Artifact paths to create.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574274 = newJObject()
  var body_574275 = newJObject()
  add(path_574274, "resourceGroupName", newJString(resourceGroupName))
  add(path_574274, "origin", newJString(origin))
  add(path_574274, "subscriptionId", newJString(subscriptionId))
  add(path_574274, "container", newJString(container))
  if artifactPaths != nil:
    body_574275 = artifactPaths
  add(path_574274, "workspaceName", newJString(workspaceName))
  result = call_574273.call(path_574274, nil, nil, nil, body_574275)

var artifactsBatchCreateEmptyArtifacts* = Call_ArtifactsBatchCreateEmptyArtifacts_574263(
    name: "artifactsBatchCreateEmptyArtifacts", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/batch/metadata",
    validator: validate_ArtifactsBatchCreateEmptyArtifacts_574264, base: "",
    url: url_ArtifactsBatchCreateEmptyArtifacts_574265, schemes: {Scheme.Https})
type
  Call_ArtifactsDeleteBatchMetaData_574276 = ref object of OpenApiRestCall_573641
proc url_ArtifactsDeleteBatchMetaData_574278(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/batch/metadata:delete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsDeleteBatchMetaData_574277(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Batch of Artifact Metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574279 = path.getOrDefault("resourceGroupName")
  valid_574279 = validateParameter(valid_574279, JString, required = true,
                                 default = nil)
  if valid_574279 != nil:
    section.add "resourceGroupName", valid_574279
  var valid_574280 = path.getOrDefault("origin")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "origin", valid_574280
  var valid_574281 = path.getOrDefault("subscriptionId")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "subscriptionId", valid_574281
  var valid_574282 = path.getOrDefault("container")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "container", valid_574282
  var valid_574283 = path.getOrDefault("workspaceName")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "workspaceName", valid_574283
  result.add "path", section
  ## parameters in `query` object:
  ##   hardDelete: JBool
  ##             : If set to true, the delete cannot be reverted at a later time.
  section = newJObject()
  var valid_574284 = query.getOrDefault("hardDelete")
  valid_574284 = validateParameter(valid_574284, JBool, required = false,
                                 default = newJBool(false))
  if valid_574284 != nil:
    section.add "hardDelete", valid_574284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactPaths: JObject (required)
  ##                : The list of Artifact paths to delete.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574286: Call_ArtifactsDeleteBatchMetaData_574276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Batch of Artifact Metadata.
  ## 
  let valid = call_574286.validator(path, query, header, formData, body)
  let scheme = call_574286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574286.url(scheme.get, call_574286.host, call_574286.base,
                         call_574286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574286, url, valid)

proc call*(call_574287: Call_ArtifactsDeleteBatchMetaData_574276;
          resourceGroupName: string; origin: string; subscriptionId: string;
          container: string; artifactPaths: JsonNode; workspaceName: string;
          hardDelete: bool = false): Recallable =
  ## artifactsDeleteBatchMetaData
  ## Delete a Batch of Artifact Metadata.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   hardDelete: bool
  ##             : If set to true, the delete cannot be reverted at a later time.
  ##   container: string (required)
  ##            : The container name.
  ##   artifactPaths: JObject (required)
  ##                : The list of Artifact paths to delete.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574288 = newJObject()
  var query_574289 = newJObject()
  var body_574290 = newJObject()
  add(path_574288, "resourceGroupName", newJString(resourceGroupName))
  add(path_574288, "origin", newJString(origin))
  add(path_574288, "subscriptionId", newJString(subscriptionId))
  add(query_574289, "hardDelete", newJBool(hardDelete))
  add(path_574288, "container", newJString(container))
  if artifactPaths != nil:
    body_574290 = artifactPaths
  add(path_574288, "workspaceName", newJString(workspaceName))
  result = call_574287.call(path_574288, query_574289, nil, nil, body_574290)

var artifactsDeleteBatchMetaData* = Call_ArtifactsDeleteBatchMetaData_574276(
    name: "artifactsDeleteBatchMetaData", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/batch/metadata:delete",
    validator: validate_ArtifactsDeleteBatchMetaData_574277, base: "",
    url: url_ArtifactsDeleteBatchMetaData_574278, schemes: {Scheme.Https})
type
  Call_ArtifactsUpload_574304 = ref object of OpenApiRestCall_573641
proc url_ArtifactsUpload_574306(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/content")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsUpload_574305(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Upload content to an Artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574307 = path.getOrDefault("resourceGroupName")
  valid_574307 = validateParameter(valid_574307, JString, required = true,
                                 default = nil)
  if valid_574307 != nil:
    section.add "resourceGroupName", valid_574307
  var valid_574308 = path.getOrDefault("origin")
  valid_574308 = validateParameter(valid_574308, JString, required = true,
                                 default = nil)
  if valid_574308 != nil:
    section.add "origin", valid_574308
  var valid_574309 = path.getOrDefault("subscriptionId")
  valid_574309 = validateParameter(valid_574309, JString, required = true,
                                 default = nil)
  if valid_574309 != nil:
    section.add "subscriptionId", valid_574309
  var valid_574310 = path.getOrDefault("container")
  valid_574310 = validateParameter(valid_574310, JString, required = true,
                                 default = nil)
  if valid_574310 != nil:
    section.add "container", valid_574310
  var valid_574311 = path.getOrDefault("workspaceName")
  valid_574311 = validateParameter(valid_574311, JString, required = true,
                                 default = nil)
  if valid_574311 != nil:
    section.add "workspaceName", valid_574311
  result.add "path", section
  ## parameters in `query` object:
  ##   index: JInt
  ##        : The index.
  ##   append: JBool
  ##         : Whether or not to append the content or replace it.
  ##   path: JString
  ##       : The Artifact Path.
  ##   allowOverwrite: JBool
  ##                 : whether to allow overwrite if Artifact Content exist already. when set to true, Overwrite happens if Artifact Content already exists
  section = newJObject()
  var valid_574312 = query.getOrDefault("index")
  valid_574312 = validateParameter(valid_574312, JInt, required = false, default = nil)
  if valid_574312 != nil:
    section.add "index", valid_574312
  var valid_574313 = query.getOrDefault("append")
  valid_574313 = validateParameter(valid_574313, JBool, required = false,
                                 default = newJBool(false))
  if valid_574313 != nil:
    section.add "append", valid_574313
  var valid_574314 = query.getOrDefault("path")
  valid_574314 = validateParameter(valid_574314, JString, required = false,
                                 default = nil)
  if valid_574314 != nil:
    section.add "path", valid_574314
  var valid_574315 = query.getOrDefault("allowOverwrite")
  valid_574315 = validateParameter(valid_574315, JBool, required = false,
                                 default = newJBool(false))
  if valid_574315 != nil:
    section.add "allowOverwrite", valid_574315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   content: JString (required)
  ##          : The file upload.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JString, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574317: Call_ArtifactsUpload_574304; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Upload content to an Artifact.
  ## 
  let valid = call_574317.validator(path, query, header, formData, body)
  let scheme = call_574317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574317.url(scheme.get, call_574317.host, call_574317.base,
                         call_574317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574317, url, valid)

proc call*(call_574318: Call_ArtifactsUpload_574304; resourceGroupName: string;
          origin: string; subscriptionId: string; container: string;
          content: JsonNode; workspaceName: string; index: int = 0;
          append: bool = false; path: string = ""; allowOverwrite: bool = false): Recallable =
  ## artifactsUpload
  ## Upload content to an Artifact.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   index: int
  ##        : The index.
  ##   append: bool
  ##         : Whether or not to append the content or replace it.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   content: JString (required)
  ##          : The file upload.
  ##   path: string
  ##       : The Artifact Path.
  ##   allowOverwrite: bool
  ##                 : whether to allow overwrite if Artifact Content exist already. when set to true, Overwrite happens if Artifact Content already exists
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574319 = newJObject()
  var query_574320 = newJObject()
  var body_574321 = newJObject()
  add(path_574319, "resourceGroupName", newJString(resourceGroupName))
  add(path_574319, "origin", newJString(origin))
  add(query_574320, "index", newJInt(index))
  add(query_574320, "append", newJBool(append))
  add(path_574319, "subscriptionId", newJString(subscriptionId))
  add(path_574319, "container", newJString(container))
  if content != nil:
    body_574321 = content
  add(query_574320, "path", newJString(path))
  add(query_574320, "allowOverwrite", newJBool(allowOverwrite))
  add(path_574319, "workspaceName", newJString(workspaceName))
  result = call_574318.call(path_574319, query_574320, nil, nil, body_574321)

var artifactsUpload* = Call_ArtifactsUpload_574304(name: "artifactsUpload",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/content",
    validator: validate_ArtifactsUpload_574305, base: "", url: url_ArtifactsUpload_574306,
    schemes: {Scheme.Https})
type
  Call_ArtifactsDownload_574291 = ref object of OpenApiRestCall_573641
proc url_ArtifactsDownload_574293(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/content")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsDownload_574292(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get Artifact content of a specific Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574294 = path.getOrDefault("resourceGroupName")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "resourceGroupName", valid_574294
  var valid_574295 = path.getOrDefault("origin")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "origin", valid_574295
  var valid_574296 = path.getOrDefault("subscriptionId")
  valid_574296 = validateParameter(valid_574296, JString, required = true,
                                 default = nil)
  if valid_574296 != nil:
    section.add "subscriptionId", valid_574296
  var valid_574297 = path.getOrDefault("container")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = nil)
  if valid_574297 != nil:
    section.add "container", valid_574297
  var valid_574298 = path.getOrDefault("workspaceName")
  valid_574298 = validateParameter(valid_574298, JString, required = true,
                                 default = nil)
  if valid_574298 != nil:
    section.add "workspaceName", valid_574298
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  section = newJObject()
  var valid_574299 = query.getOrDefault("path")
  valid_574299 = validateParameter(valid_574299, JString, required = false,
                                 default = nil)
  if valid_574299 != nil:
    section.add "path", valid_574299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574300: Call_ArtifactsDownload_574291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Artifact content of a specific Id.
  ## 
  let valid = call_574300.validator(path, query, header, formData, body)
  let scheme = call_574300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574300.url(scheme.get, call_574300.host, call_574300.base,
                         call_574300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574300, url, valid)

proc call*(call_574301: Call_ArtifactsDownload_574291; resourceGroupName: string;
          origin: string; subscriptionId: string; container: string;
          workspaceName: string; path: string = ""): Recallable =
  ## artifactsDownload
  ## Get Artifact content of a specific Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   path: string
  ##       : The Artifact Path.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574302 = newJObject()
  var query_574303 = newJObject()
  add(path_574302, "resourceGroupName", newJString(resourceGroupName))
  add(path_574302, "origin", newJString(origin))
  add(path_574302, "subscriptionId", newJString(subscriptionId))
  add(path_574302, "container", newJString(container))
  add(query_574303, "path", newJString(path))
  add(path_574302, "workspaceName", newJString(workspaceName))
  result = call_574301.call(path_574302, query_574303, nil, nil, nil)

var artifactsDownload* = Call_ArtifactsDownload_574291(name: "artifactsDownload",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/content",
    validator: validate_ArtifactsDownload_574292, base: "",
    url: url_ArtifactsDownload_574293, schemes: {Scheme.Https})
type
  Call_ArtifactsGetContentInformation_574322 = ref object of OpenApiRestCall_573641
proc url_ArtifactsGetContentInformation_574324(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/contentinfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsGetContentInformation_574323(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get content information of an Artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574325 = path.getOrDefault("resourceGroupName")
  valid_574325 = validateParameter(valid_574325, JString, required = true,
                                 default = nil)
  if valid_574325 != nil:
    section.add "resourceGroupName", valid_574325
  var valid_574326 = path.getOrDefault("origin")
  valid_574326 = validateParameter(valid_574326, JString, required = true,
                                 default = nil)
  if valid_574326 != nil:
    section.add "origin", valid_574326
  var valid_574327 = path.getOrDefault("subscriptionId")
  valid_574327 = validateParameter(valid_574327, JString, required = true,
                                 default = nil)
  if valid_574327 != nil:
    section.add "subscriptionId", valid_574327
  var valid_574328 = path.getOrDefault("container")
  valid_574328 = validateParameter(valid_574328, JString, required = true,
                                 default = nil)
  if valid_574328 != nil:
    section.add "container", valid_574328
  var valid_574329 = path.getOrDefault("workspaceName")
  valid_574329 = validateParameter(valid_574329, JString, required = true,
                                 default = nil)
  if valid_574329 != nil:
    section.add "workspaceName", valid_574329
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  section = newJObject()
  var valid_574330 = query.getOrDefault("path")
  valid_574330 = validateParameter(valid_574330, JString, required = false,
                                 default = nil)
  if valid_574330 != nil:
    section.add "path", valid_574330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574331: Call_ArtifactsGetContentInformation_574322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get content information of an Artifact.
  ## 
  let valid = call_574331.validator(path, query, header, formData, body)
  let scheme = call_574331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574331.url(scheme.get, call_574331.host, call_574331.base,
                         call_574331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574331, url, valid)

proc call*(call_574332: Call_ArtifactsGetContentInformation_574322;
          resourceGroupName: string; origin: string; subscriptionId: string;
          container: string; workspaceName: string; path: string = ""): Recallable =
  ## artifactsGetContentInformation
  ## Get content information of an Artifact.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   path: string
  ##       : The Artifact Path.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574333 = newJObject()
  var query_574334 = newJObject()
  add(path_574333, "resourceGroupName", newJString(resourceGroupName))
  add(path_574333, "origin", newJString(origin))
  add(path_574333, "subscriptionId", newJString(subscriptionId))
  add(path_574333, "container", newJString(container))
  add(query_574334, "path", newJString(path))
  add(path_574333, "workspaceName", newJString(workspaceName))
  result = call_574332.call(path_574333, query_574334, nil, nil, nil)

var artifactsGetContentInformation* = Call_ArtifactsGetContentInformation_574322(
    name: "artifactsGetContentInformation", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/contentinfo",
    validator: validate_ArtifactsGetContentInformation_574323, base: "",
    url: url_ArtifactsGetContentInformation_574324, schemes: {Scheme.Https})
type
  Call_ArtifactsGetStorageContentInformation_574335 = ref object of OpenApiRestCall_573641
proc url_ArtifactsGetStorageContentInformation_574337(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/contentinfo/storageuri")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsGetStorageContentInformation_574336(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get storage content information of an Artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574338 = path.getOrDefault("resourceGroupName")
  valid_574338 = validateParameter(valid_574338, JString, required = true,
                                 default = nil)
  if valid_574338 != nil:
    section.add "resourceGroupName", valid_574338
  var valid_574339 = path.getOrDefault("origin")
  valid_574339 = validateParameter(valid_574339, JString, required = true,
                                 default = nil)
  if valid_574339 != nil:
    section.add "origin", valid_574339
  var valid_574340 = path.getOrDefault("subscriptionId")
  valid_574340 = validateParameter(valid_574340, JString, required = true,
                                 default = nil)
  if valid_574340 != nil:
    section.add "subscriptionId", valid_574340
  var valid_574341 = path.getOrDefault("container")
  valid_574341 = validateParameter(valid_574341, JString, required = true,
                                 default = nil)
  if valid_574341 != nil:
    section.add "container", valid_574341
  var valid_574342 = path.getOrDefault("workspaceName")
  valid_574342 = validateParameter(valid_574342, JString, required = true,
                                 default = nil)
  if valid_574342 != nil:
    section.add "workspaceName", valid_574342
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  section = newJObject()
  var valid_574343 = query.getOrDefault("path")
  valid_574343 = validateParameter(valid_574343, JString, required = false,
                                 default = nil)
  if valid_574343 != nil:
    section.add "path", valid_574343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574344: Call_ArtifactsGetStorageContentInformation_574335;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get storage content information of an Artifact.
  ## 
  let valid = call_574344.validator(path, query, header, formData, body)
  let scheme = call_574344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574344.url(scheme.get, call_574344.host, call_574344.base,
                         call_574344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574344, url, valid)

proc call*(call_574345: Call_ArtifactsGetStorageContentInformation_574335;
          resourceGroupName: string; origin: string; subscriptionId: string;
          container: string; workspaceName: string; path: string = ""): Recallable =
  ## artifactsGetStorageContentInformation
  ## Get storage content information of an Artifact.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   path: string
  ##       : The Artifact Path.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574346 = newJObject()
  var query_574347 = newJObject()
  add(path_574346, "resourceGroupName", newJString(resourceGroupName))
  add(path_574346, "origin", newJString(origin))
  add(path_574346, "subscriptionId", newJString(subscriptionId))
  add(path_574346, "container", newJString(container))
  add(query_574347, "path", newJString(path))
  add(path_574346, "workspaceName", newJString(workspaceName))
  result = call_574345.call(path_574346, query_574347, nil, nil, nil)

var artifactsGetStorageContentInformation* = Call_ArtifactsGetStorageContentInformation_574335(
    name: "artifactsGetStorageContentInformation", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/contentinfo/storageuri",
    validator: validate_ArtifactsGetStorageContentInformation_574336, base: "",
    url: url_ArtifactsGetStorageContentInformation_574337, schemes: {Scheme.Https})
type
  Call_ArtifactsGet_574348 = ref object of OpenApiRestCall_573641
proc url_ArtifactsGet_574350(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsGet_574349(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Artifact metadata for a specific Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574351 = path.getOrDefault("resourceGroupName")
  valid_574351 = validateParameter(valid_574351, JString, required = true,
                                 default = nil)
  if valid_574351 != nil:
    section.add "resourceGroupName", valid_574351
  var valid_574352 = path.getOrDefault("origin")
  valid_574352 = validateParameter(valid_574352, JString, required = true,
                                 default = nil)
  if valid_574352 != nil:
    section.add "origin", valid_574352
  var valid_574353 = path.getOrDefault("subscriptionId")
  valid_574353 = validateParameter(valid_574353, JString, required = true,
                                 default = nil)
  if valid_574353 != nil:
    section.add "subscriptionId", valid_574353
  var valid_574354 = path.getOrDefault("container")
  valid_574354 = validateParameter(valid_574354, JString, required = true,
                                 default = nil)
  if valid_574354 != nil:
    section.add "container", valid_574354
  var valid_574355 = path.getOrDefault("workspaceName")
  valid_574355 = validateParameter(valid_574355, JString, required = true,
                                 default = nil)
  if valid_574355 != nil:
    section.add "workspaceName", valid_574355
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString (required)
  ##       : The Artifact Path.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `path` field"
  var valid_574356 = query.getOrDefault("path")
  valid_574356 = validateParameter(valid_574356, JString, required = true,
                                 default = nil)
  if valid_574356 != nil:
    section.add "path", valid_574356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574357: Call_ArtifactsGet_574348; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Artifact metadata for a specific Id.
  ## 
  let valid = call_574357.validator(path, query, header, formData, body)
  let scheme = call_574357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574357.url(scheme.get, call_574357.host, call_574357.base,
                         call_574357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574357, url, valid)

proc call*(call_574358: Call_ArtifactsGet_574348; resourceGroupName: string;
          origin: string; subscriptionId: string; container: string; path: string;
          workspaceName: string): Recallable =
  ## artifactsGet
  ## Get Artifact metadata for a specific Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   path: string (required)
  ##       : The Artifact Path.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574359 = newJObject()
  var query_574360 = newJObject()
  add(path_574359, "resourceGroupName", newJString(resourceGroupName))
  add(path_574359, "origin", newJString(origin))
  add(path_574359, "subscriptionId", newJString(subscriptionId))
  add(path_574359, "container", newJString(container))
  add(query_574360, "path", newJString(path))
  add(path_574359, "workspaceName", newJString(workspaceName))
  result = call_574358.call(path_574359, query_574360, nil, nil, nil)

var artifactsGet* = Call_ArtifactsGet_574348(name: "artifactsGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/metadata",
    validator: validate_ArtifactsGet_574349, base: "", url: url_ArtifactsGet_574350,
    schemes: {Scheme.Https})
type
  Call_ArtifactsDeleteMetaData_574361 = ref object of OpenApiRestCall_573641
proc url_ArtifactsDeleteMetaData_574363(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsDeleteMetaData_574362(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an Artifact Metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574364 = path.getOrDefault("resourceGroupName")
  valid_574364 = validateParameter(valid_574364, JString, required = true,
                                 default = nil)
  if valid_574364 != nil:
    section.add "resourceGroupName", valid_574364
  var valid_574365 = path.getOrDefault("origin")
  valid_574365 = validateParameter(valid_574365, JString, required = true,
                                 default = nil)
  if valid_574365 != nil:
    section.add "origin", valid_574365
  var valid_574366 = path.getOrDefault("subscriptionId")
  valid_574366 = validateParameter(valid_574366, JString, required = true,
                                 default = nil)
  if valid_574366 != nil:
    section.add "subscriptionId", valid_574366
  var valid_574367 = path.getOrDefault("container")
  valid_574367 = validateParameter(valid_574367, JString, required = true,
                                 default = nil)
  if valid_574367 != nil:
    section.add "container", valid_574367
  var valid_574368 = path.getOrDefault("workspaceName")
  valid_574368 = validateParameter(valid_574368, JString, required = true,
                                 default = nil)
  if valid_574368 != nil:
    section.add "workspaceName", valid_574368
  result.add "path", section
  ## parameters in `query` object:
  ##   hardDelete: JBool
  ##             : If set to true. The delete cannot be revert at later time.
  ##   path: JString
  ##       : The Artifact Path.
  section = newJObject()
  var valid_574369 = query.getOrDefault("hardDelete")
  valid_574369 = validateParameter(valid_574369, JBool, required = false,
                                 default = newJBool(false))
  if valid_574369 != nil:
    section.add "hardDelete", valid_574369
  var valid_574370 = query.getOrDefault("path")
  valid_574370 = validateParameter(valid_574370, JString, required = false,
                                 default = nil)
  if valid_574370 != nil:
    section.add "path", valid_574370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574371: Call_ArtifactsDeleteMetaData_574361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an Artifact Metadata.
  ## 
  let valid = call_574371.validator(path, query, header, formData, body)
  let scheme = call_574371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574371.url(scheme.get, call_574371.host, call_574371.base,
                         call_574371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574371, url, valid)

proc call*(call_574372: Call_ArtifactsDeleteMetaData_574361;
          resourceGroupName: string; origin: string; subscriptionId: string;
          container: string; workspaceName: string; hardDelete: bool = false;
          path: string = ""): Recallable =
  ## artifactsDeleteMetaData
  ## Delete an Artifact Metadata.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   hardDelete: bool
  ##             : If set to true. The delete cannot be revert at later time.
  ##   container: string (required)
  ##            : The container name.
  ##   path: string
  ##       : The Artifact Path.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574373 = newJObject()
  var query_574374 = newJObject()
  add(path_574373, "resourceGroupName", newJString(resourceGroupName))
  add(path_574373, "origin", newJString(origin))
  add(path_574373, "subscriptionId", newJString(subscriptionId))
  add(query_574374, "hardDelete", newJBool(hardDelete))
  add(path_574373, "container", newJString(container))
  add(query_574374, "path", newJString(path))
  add(path_574373, "workspaceName", newJString(workspaceName))
  result = call_574372.call(path_574373, query_574374, nil, nil, nil)

var artifactsDeleteMetaData* = Call_ArtifactsDeleteMetaData_574361(
    name: "artifactsDeleteMetaData", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/metadata",
    validator: validate_ArtifactsDeleteMetaData_574362, base: "",
    url: url_ArtifactsDeleteMetaData_574363, schemes: {Scheme.Https})
type
  Call_ArtifactsListSasByPrefix_574375 = ref object of OpenApiRestCall_573641
proc url_ArtifactsListSasByPrefix_574377(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/prefix/contentinfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsListSasByPrefix_574376(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get shared access signature for an Artifact in specific path.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574378 = path.getOrDefault("resourceGroupName")
  valid_574378 = validateParameter(valid_574378, JString, required = true,
                                 default = nil)
  if valid_574378 != nil:
    section.add "resourceGroupName", valid_574378
  var valid_574379 = path.getOrDefault("origin")
  valid_574379 = validateParameter(valid_574379, JString, required = true,
                                 default = nil)
  if valid_574379 != nil:
    section.add "origin", valid_574379
  var valid_574380 = path.getOrDefault("subscriptionId")
  valid_574380 = validateParameter(valid_574380, JString, required = true,
                                 default = nil)
  if valid_574380 != nil:
    section.add "subscriptionId", valid_574380
  var valid_574381 = path.getOrDefault("container")
  valid_574381 = validateParameter(valid_574381, JString, required = true,
                                 default = nil)
  if valid_574381 != nil:
    section.add "container", valid_574381
  var valid_574382 = path.getOrDefault("workspaceName")
  valid_574382 = validateParameter(valid_574382, JString, required = true,
                                 default = nil)
  if valid_574382 != nil:
    section.add "workspaceName", valid_574382
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  ##   continuationToken: JString
  ##                    : The continuation token.
  section = newJObject()
  var valid_574383 = query.getOrDefault("path")
  valid_574383 = validateParameter(valid_574383, JString, required = false,
                                 default = nil)
  if valid_574383 != nil:
    section.add "path", valid_574383
  var valid_574384 = query.getOrDefault("continuationToken")
  valid_574384 = validateParameter(valid_574384, JString, required = false,
                                 default = nil)
  if valid_574384 != nil:
    section.add "continuationToken", valid_574384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574385: Call_ArtifactsListSasByPrefix_574375; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get shared access signature for an Artifact in specific path.
  ## 
  let valid = call_574385.validator(path, query, header, formData, body)
  let scheme = call_574385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574385.url(scheme.get, call_574385.host, call_574385.base,
                         call_574385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574385, url, valid)

proc call*(call_574386: Call_ArtifactsListSasByPrefix_574375;
          resourceGroupName: string; origin: string; subscriptionId: string;
          container: string; workspaceName: string; path: string = "";
          continuationToken: string = ""): Recallable =
  ## artifactsListSasByPrefix
  ## Get shared access signature for an Artifact in specific path.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   path: string
  ##       : The Artifact Path.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574387 = newJObject()
  var query_574388 = newJObject()
  add(path_574387, "resourceGroupName", newJString(resourceGroupName))
  add(path_574387, "origin", newJString(origin))
  add(path_574387, "subscriptionId", newJString(subscriptionId))
  add(path_574387, "container", newJString(container))
  add(query_574388, "path", newJString(path))
  add(query_574388, "continuationToken", newJString(continuationToken))
  add(path_574387, "workspaceName", newJString(workspaceName))
  result = call_574386.call(path_574387, query_574388, nil, nil, nil)

var artifactsListSasByPrefix* = Call_ArtifactsListSasByPrefix_574375(
    name: "artifactsListSasByPrefix", meth: HttpMethod.HttpGet, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/prefix/contentinfo",
    validator: validate_ArtifactsListSasByPrefix_574376, base: "",
    url: url_ArtifactsListSasByPrefix_574377, schemes: {Scheme.Https})
type
  Call_ArtifactsListStorageUriByPrefix_574389 = ref object of OpenApiRestCall_573641
proc url_ArtifactsListStorageUriByPrefix_574391(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/prefix/contentinfo/storageuri")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsListStorageUriByPrefix_574390(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get storage Uri for Artifacts in a specific path.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574392 = path.getOrDefault("resourceGroupName")
  valid_574392 = validateParameter(valid_574392, JString, required = true,
                                 default = nil)
  if valid_574392 != nil:
    section.add "resourceGroupName", valid_574392
  var valid_574393 = path.getOrDefault("origin")
  valid_574393 = validateParameter(valid_574393, JString, required = true,
                                 default = nil)
  if valid_574393 != nil:
    section.add "origin", valid_574393
  var valid_574394 = path.getOrDefault("subscriptionId")
  valid_574394 = validateParameter(valid_574394, JString, required = true,
                                 default = nil)
  if valid_574394 != nil:
    section.add "subscriptionId", valid_574394
  var valid_574395 = path.getOrDefault("container")
  valid_574395 = validateParameter(valid_574395, JString, required = true,
                                 default = nil)
  if valid_574395 != nil:
    section.add "container", valid_574395
  var valid_574396 = path.getOrDefault("workspaceName")
  valid_574396 = validateParameter(valid_574396, JString, required = true,
                                 default = nil)
  if valid_574396 != nil:
    section.add "workspaceName", valid_574396
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  ##   continuationToken: JString
  ##                    : The continuation token.
  section = newJObject()
  var valid_574397 = query.getOrDefault("path")
  valid_574397 = validateParameter(valid_574397, JString, required = false,
                                 default = nil)
  if valid_574397 != nil:
    section.add "path", valid_574397
  var valid_574398 = query.getOrDefault("continuationToken")
  valid_574398 = validateParameter(valid_574398, JString, required = false,
                                 default = nil)
  if valid_574398 != nil:
    section.add "continuationToken", valid_574398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574399: Call_ArtifactsListStorageUriByPrefix_574389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get storage Uri for Artifacts in a specific path.
  ## 
  let valid = call_574399.validator(path, query, header, formData, body)
  let scheme = call_574399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574399.url(scheme.get, call_574399.host, call_574399.base,
                         call_574399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574399, url, valid)

proc call*(call_574400: Call_ArtifactsListStorageUriByPrefix_574389;
          resourceGroupName: string; origin: string; subscriptionId: string;
          container: string; workspaceName: string; path: string = "";
          continuationToken: string = ""): Recallable =
  ## artifactsListStorageUriByPrefix
  ## Get storage Uri for Artifacts in a specific path.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   path: string
  ##       : The Artifact Path.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574401 = newJObject()
  var query_574402 = newJObject()
  add(path_574401, "resourceGroupName", newJString(resourceGroupName))
  add(path_574401, "origin", newJString(origin))
  add(path_574401, "subscriptionId", newJString(subscriptionId))
  add(path_574401, "container", newJString(container))
  add(query_574402, "path", newJString(path))
  add(query_574402, "continuationToken", newJString(continuationToken))
  add(path_574401, "workspaceName", newJString(workspaceName))
  result = call_574400.call(path_574401, query_574402, nil, nil, nil)

var artifactsListStorageUriByPrefix* = Call_ArtifactsListStorageUriByPrefix_574389(
    name: "artifactsListStorageUriByPrefix", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/prefix/contentinfo/storageuri",
    validator: validate_ArtifactsListStorageUriByPrefix_574390, base: "",
    url: url_ArtifactsListStorageUriByPrefix_574391, schemes: {Scheme.Https})
type
  Call_ArtifactsGetSas_574403 = ref object of OpenApiRestCall_573641
proc url_ArtifactsGetSas_574405(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/write")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsGetSas_574404(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get writable shared access signature for a specific Artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574406 = path.getOrDefault("resourceGroupName")
  valid_574406 = validateParameter(valid_574406, JString, required = true,
                                 default = nil)
  if valid_574406 != nil:
    section.add "resourceGroupName", valid_574406
  var valid_574407 = path.getOrDefault("origin")
  valid_574407 = validateParameter(valid_574407, JString, required = true,
                                 default = nil)
  if valid_574407 != nil:
    section.add "origin", valid_574407
  var valid_574408 = path.getOrDefault("subscriptionId")
  valid_574408 = validateParameter(valid_574408, JString, required = true,
                                 default = nil)
  if valid_574408 != nil:
    section.add "subscriptionId", valid_574408
  var valid_574409 = path.getOrDefault("container")
  valid_574409 = validateParameter(valid_574409, JString, required = true,
                                 default = nil)
  if valid_574409 != nil:
    section.add "container", valid_574409
  var valid_574410 = path.getOrDefault("workspaceName")
  valid_574410 = validateParameter(valid_574410, JString, required = true,
                                 default = nil)
  if valid_574410 != nil:
    section.add "workspaceName", valid_574410
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  section = newJObject()
  var valid_574411 = query.getOrDefault("path")
  valid_574411 = validateParameter(valid_574411, JString, required = false,
                                 default = nil)
  if valid_574411 != nil:
    section.add "path", valid_574411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574412: Call_ArtifactsGetSas_574403; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get writable shared access signature for a specific Artifact.
  ## 
  let valid = call_574412.validator(path, query, header, formData, body)
  let scheme = call_574412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574412.url(scheme.get, call_574412.host, call_574412.base,
                         call_574412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574412, url, valid)

proc call*(call_574413: Call_ArtifactsGetSas_574403; resourceGroupName: string;
          origin: string; subscriptionId: string; container: string;
          workspaceName: string; path: string = ""): Recallable =
  ## artifactsGetSas
  ## Get writable shared access signature for a specific Artifact.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   path: string
  ##       : The Artifact Path.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574414 = newJObject()
  var query_574415 = newJObject()
  add(path_574414, "resourceGroupName", newJString(resourceGroupName))
  add(path_574414, "origin", newJString(origin))
  add(path_574414, "subscriptionId", newJString(subscriptionId))
  add(path_574414, "container", newJString(container))
  add(query_574415, "path", newJString(path))
  add(path_574414, "workspaceName", newJString(workspaceName))
  result = call_574413.call(path_574414, query_574415, nil, nil, nil)

var artifactsGetSas* = Call_ArtifactsGetSas_574403(name: "artifactsGetSas",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/write",
    validator: validate_ArtifactsGetSas_574404, base: "", url: url_ArtifactsGetSas_574405,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
