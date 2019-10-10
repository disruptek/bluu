
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Machine Learning Model Management Service
## version: 2019-08-01
## termsOfService: (not provided)
## license: (not provided)
## 
## These APIs allow end users to manage Azure Machine Learning Models, Images, Profiles, and Services.
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

  OpenApiRestCall_573650 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573650](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573650): Option[Scheme] {.used.} =
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
  macServiceName = "machinelearningservices-modelManagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AssetsCreate_574206 = ref object of OpenApiRestCall_573650
proc url_AssetsCreate_574208(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/assets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssetsCreate_574207(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Create an Asset from the provided payload.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574209 = path.getOrDefault("workspace")
  valid_574209 = validateParameter(valid_574209, JString, required = true,
                                 default = nil)
  if valid_574209 != nil:
    section.add "workspace", valid_574209
  var valid_574210 = path.getOrDefault("subscriptionId")
  valid_574210 = validateParameter(valid_574210, JString, required = true,
                                 default = nil)
  if valid_574210 != nil:
    section.add "subscriptionId", valid_574210
  var valid_574211 = path.getOrDefault("resourceGroup")
  valid_574211 = validateParameter(valid_574211, JString, required = true,
                                 default = nil)
  if valid_574211 != nil:
    section.add "resourceGroup", valid_574211
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   asset: JObject
  ##        : The Asset to be created.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574213: Call_AssetsCreate_574206; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an Asset from the provided payload.
  ## 
  let valid = call_574213.validator(path, query, header, formData, body)
  let scheme = call_574213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574213.url(scheme.get, call_574213.host, call_574213.base,
                         call_574213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574213, url, valid)

proc call*(call_574214: Call_AssetsCreate_574206; workspace: string;
          subscriptionId: string; resourceGroup: string; asset: JsonNode = nil): Recallable =
  ## assetsCreate
  ## Create an Asset from the provided payload.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   asset: JObject
  ##        : The Asset to be created.
  var path_574215 = newJObject()
  var body_574216 = newJObject()
  add(path_574215, "workspace", newJString(workspace))
  add(path_574215, "subscriptionId", newJString(subscriptionId))
  add(path_574215, "resourceGroup", newJString(resourceGroup))
  if asset != nil:
    body_574216 = asset
  result = call_574214.call(path_574215, nil, nil, nil, body_574216)

var assetsCreate* = Call_AssetsCreate_574206(name: "assetsCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/assets",
    validator: validate_AssetsCreate_574207, base: "", url: url_AssetsCreate_574208,
    schemes: {Scheme.Https})
type
  Call_AssetsListQuery_573872 = ref object of OpenApiRestCall_573650
proc url_AssetsListQuery_573874(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/assets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssetsListQuery_573873(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## If no filter is passed, the query lists all the Assets in the given workspace. The returned list is paginated and the count of items in each page is an optional parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574048 = path.getOrDefault("workspace")
  valid_574048 = validateParameter(valid_574048, JString, required = true,
                                 default = nil)
  if valid_574048 != nil:
    section.add "workspace", valid_574048
  var valid_574049 = path.getOrDefault("subscriptionId")
  valid_574049 = validateParameter(valid_574049, JString, required = true,
                                 default = nil)
  if valid_574049 != nil:
    section.add "subscriptionId", valid_574049
  var valid_574050 = path.getOrDefault("resourceGroup")
  valid_574050 = validateParameter(valid_574050, JString, required = true,
                                 default = nil)
  if valid_574050 != nil:
    section.add "resourceGroup", valid_574050
  result.add "path", section
  ## parameters in `query` object:
  ##   runId: JString
  ##        : The run Id associated with the Assets.
  ##   orderby: JString
  ##          : An option for specifying how to order the list.
  ##   name: JString
  ##       : The object name.
  ##   properties: JString
  ##             : A set of properties with which to filter the returned models.
  ##             It is a comma separated string of properties key and/or properties key=value
  ##             Example: propKey1,propKey2,propKey3=value3
  ##   tags: JString
  ##       : A set of tags with which to filter the returned models.
  ##             It is a comma separated string of tags key or tags key=value
  ##             Example: tagKey1,tagKey2,tagKey3=value3
  ##   $skipToken: JString
  ##             : The continuation token to retrieve the next page.
  ##   count: JInt
  ##        : The number of items to retrieve in a page.
  section = newJObject()
  var valid_574051 = query.getOrDefault("runId")
  valid_574051 = validateParameter(valid_574051, JString, required = false,
                                 default = nil)
  if valid_574051 != nil:
    section.add "runId", valid_574051
  var valid_574065 = query.getOrDefault("orderby")
  valid_574065 = validateParameter(valid_574065, JString, required = false,
                                 default = newJString("CreatedAtDesc"))
  if valid_574065 != nil:
    section.add "orderby", valid_574065
  var valid_574066 = query.getOrDefault("name")
  valid_574066 = validateParameter(valid_574066, JString, required = false,
                                 default = nil)
  if valid_574066 != nil:
    section.add "name", valid_574066
  var valid_574067 = query.getOrDefault("properties")
  valid_574067 = validateParameter(valid_574067, JString, required = false,
                                 default = nil)
  if valid_574067 != nil:
    section.add "properties", valid_574067
  var valid_574068 = query.getOrDefault("tags")
  valid_574068 = validateParameter(valid_574068, JString, required = false,
                                 default = nil)
  if valid_574068 != nil:
    section.add "tags", valid_574068
  var valid_574069 = query.getOrDefault("$skipToken")
  valid_574069 = validateParameter(valid_574069, JString, required = false,
                                 default = nil)
  if valid_574069 != nil:
    section.add "$skipToken", valid_574069
  var valid_574070 = query.getOrDefault("count")
  valid_574070 = validateParameter(valid_574070, JInt, required = false, default = nil)
  if valid_574070 != nil:
    section.add "count", valid_574070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574093: Call_AssetsListQuery_573872; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If no filter is passed, the query lists all the Assets in the given workspace. The returned list is paginated and the count of items in each page is an optional parameter.
  ## 
  let valid = call_574093.validator(path, query, header, formData, body)
  let scheme = call_574093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574093.url(scheme.get, call_574093.host, call_574093.base,
                         call_574093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574093, url, valid)

proc call*(call_574164: Call_AssetsListQuery_573872; workspace: string;
          subscriptionId: string; resourceGroup: string; runId: string = "";
          orderby: string = "CreatedAtDesc"; name: string = ""; properties: string = "";
          tags: string = ""; SkipToken: string = ""; count: int = 0): Recallable =
  ## assetsListQuery
  ## If no filter is passed, the query lists all the Assets in the given workspace. The returned list is paginated and the count of items in each page is an optional parameter.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   runId: string
  ##        : The run Id associated with the Assets.
  ##   orderby: string
  ##          : An option for specifying how to order the list.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   name: string
  ##       : The object name.
  ##   properties: string
  ##             : A set of properties with which to filter the returned models.
  ##             It is a comma separated string of properties key and/or properties key=value
  ##             Example: propKey1,propKey2,propKey3=value3
  ##   tags: string
  ##       : A set of tags with which to filter the returned models.
  ##             It is a comma separated string of tags key or tags key=value
  ##             Example: tagKey1,tagKey2,tagKey3=value3
  ##   SkipToken: string
  ##            : The continuation token to retrieve the next page.
  ##   count: int
  ##        : The number of items to retrieve in a page.
  var path_574165 = newJObject()
  var query_574167 = newJObject()
  add(path_574165, "workspace", newJString(workspace))
  add(query_574167, "runId", newJString(runId))
  add(query_574167, "orderby", newJString(orderby))
  add(path_574165, "subscriptionId", newJString(subscriptionId))
  add(path_574165, "resourceGroup", newJString(resourceGroup))
  add(query_574167, "name", newJString(name))
  add(query_574167, "properties", newJString(properties))
  add(query_574167, "tags", newJString(tags))
  add(query_574167, "$skipToken", newJString(SkipToken))
  add(query_574167, "count", newJInt(count))
  result = call_574164.call(path_574165, query_574167, nil, nil, nil)

var assetsListQuery* = Call_AssetsListQuery_573872(name: "assetsListQuery",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/assets",
    validator: validate_AssetsListQuery_573873, base: "", url: url_AssetsListQuery_573874,
    schemes: {Scheme.Https})
type
  Call_AssetsQueryById_574217 = ref object of OpenApiRestCall_573650
proc url_AssetsQueryById_574219(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/assets/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssetsQueryById_574218(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get an Asset by Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Asset Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574220 = path.getOrDefault("workspace")
  valid_574220 = validateParameter(valid_574220, JString, required = true,
                                 default = nil)
  if valid_574220 != nil:
    section.add "workspace", valid_574220
  var valid_574221 = path.getOrDefault("subscriptionId")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "subscriptionId", valid_574221
  var valid_574222 = path.getOrDefault("resourceGroup")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "resourceGroup", valid_574222
  var valid_574223 = path.getOrDefault("id")
  valid_574223 = validateParameter(valid_574223, JString, required = true,
                                 default = nil)
  if valid_574223 != nil:
    section.add "id", valid_574223
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574224: Call_AssetsQueryById_574217; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an Asset by Id.
  ## 
  let valid = call_574224.validator(path, query, header, formData, body)
  let scheme = call_574224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574224.url(scheme.get, call_574224.host, call_574224.base,
                         call_574224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574224, url, valid)

proc call*(call_574225: Call_AssetsQueryById_574217; workspace: string;
          subscriptionId: string; resourceGroup: string; id: string): Recallable =
  ## assetsQueryById
  ## Get an Asset by Id.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Asset Id.
  var path_574226 = newJObject()
  add(path_574226, "workspace", newJString(workspace))
  add(path_574226, "subscriptionId", newJString(subscriptionId))
  add(path_574226, "resourceGroup", newJString(resourceGroup))
  add(path_574226, "id", newJString(id))
  result = call_574225.call(path_574226, nil, nil, nil, nil)

var assetsQueryById* = Call_AssetsQueryById_574217(name: "assetsQueryById",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/assets/{id}",
    validator: validate_AssetsQueryById_574218, base: "", url: url_AssetsQueryById_574219,
    schemes: {Scheme.Https})
type
  Call_AssetsPatch_574237 = ref object of OpenApiRestCall_573650
proc url_AssetsPatch_574239(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/assets/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssetsPatch_574238(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch a specific Asset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Id of the Asset to patch.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574240 = path.getOrDefault("workspace")
  valid_574240 = validateParameter(valid_574240, JString, required = true,
                                 default = nil)
  if valid_574240 != nil:
    section.add "workspace", valid_574240
  var valid_574241 = path.getOrDefault("subscriptionId")
  valid_574241 = validateParameter(valid_574241, JString, required = true,
                                 default = nil)
  if valid_574241 != nil:
    section.add "subscriptionId", valid_574241
  var valid_574242 = path.getOrDefault("resourceGroup")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "resourceGroup", valid_574242
  var valid_574243 = path.getOrDefault("id")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "id", valid_574243
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patch: JArray (required)
  ##        : The payload that is used to patch an Asset.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574245: Call_AssetsPatch_574237; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a specific Asset.
  ## 
  let valid = call_574245.validator(path, query, header, formData, body)
  let scheme = call_574245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574245.url(scheme.get, call_574245.host, call_574245.base,
                         call_574245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574245, url, valid)

proc call*(call_574246: Call_AssetsPatch_574237; workspace: string; patch: JsonNode;
          subscriptionId: string; resourceGroup: string; id: string): Recallable =
  ## assetsPatch
  ## Patch a specific Asset.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   patch: JArray (required)
  ##        : The payload that is used to patch an Asset.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Id of the Asset to patch.
  var path_574247 = newJObject()
  var body_574248 = newJObject()
  add(path_574247, "workspace", newJString(workspace))
  if patch != nil:
    body_574248 = patch
  add(path_574247, "subscriptionId", newJString(subscriptionId))
  add(path_574247, "resourceGroup", newJString(resourceGroup))
  add(path_574247, "id", newJString(id))
  result = call_574246.call(path_574247, nil, nil, nil, body_574248)

var assetsPatch* = Call_AssetsPatch_574237(name: "assetsPatch",
                                        meth: HttpMethod.HttpPatch,
                                        host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/assets/{id}",
                                        validator: validate_AssetsPatch_574238,
                                        base: "", url: url_AssetsPatch_574239,
                                        schemes: {Scheme.Https})
type
  Call_AssetsDelete_574227 = ref object of OpenApiRestCall_573650
proc url_AssetsDelete_574229(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/assets/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssetsDelete_574228(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the specified Asset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Id of the Asset to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574230 = path.getOrDefault("workspace")
  valid_574230 = validateParameter(valid_574230, JString, required = true,
                                 default = nil)
  if valid_574230 != nil:
    section.add "workspace", valid_574230
  var valid_574231 = path.getOrDefault("subscriptionId")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "subscriptionId", valid_574231
  var valid_574232 = path.getOrDefault("resourceGroup")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "resourceGroup", valid_574232
  var valid_574233 = path.getOrDefault("id")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "id", valid_574233
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574234: Call_AssetsDelete_574227; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the specified Asset.
  ## 
  let valid = call_574234.validator(path, query, header, formData, body)
  let scheme = call_574234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574234.url(scheme.get, call_574234.host, call_574234.base,
                         call_574234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574234, url, valid)

proc call*(call_574235: Call_AssetsDelete_574227; workspace: string;
          subscriptionId: string; resourceGroup: string; id: string): Recallable =
  ## assetsDelete
  ## Delete the specified Asset.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Id of the Asset to delete.
  var path_574236 = newJObject()
  add(path_574236, "workspace", newJString(workspace))
  add(path_574236, "subscriptionId", newJString(subscriptionId))
  add(path_574236, "resourceGroup", newJString(resourceGroup))
  add(path_574236, "id", newJString(id))
  result = call_574235.call(path_574236, nil, nil, nil, nil)

var assetsDelete* = Call_AssetsDelete_574227(name: "assetsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/assets/{id}",
    validator: validate_AssetsDelete_574228, base: "", url: url_AssetsDelete_574229,
    schemes: {Scheme.Https})
type
  Call_ProfilesCreate_574267 = ref object of OpenApiRestCall_573650
proc url_ProfilesCreate_574269(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "imageId" in path, "`imageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/images/"),
               (kind: VariableSegment, value: "imageId"),
               (kind: ConstantSegment, value: "/profiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesCreate_574268(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create a Profile for an Image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageId: JString (required)
  ##          : The Image Id.
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `imageId` field"
  var valid_574270 = path.getOrDefault("imageId")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "imageId", valid_574270
  var valid_574271 = path.getOrDefault("workspace")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "workspace", valid_574271
  var valid_574272 = path.getOrDefault("subscriptionId")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "subscriptionId", valid_574272
  var valid_574273 = path.getOrDefault("resourceGroup")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "resourceGroup", valid_574273
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   inputRequest: JObject (required)
  ##               : The payload that is used to create the Profile.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574275: Call_ProfilesCreate_574267; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a Profile for an Image.
  ## 
  let valid = call_574275.validator(path, query, header, formData, body)
  let scheme = call_574275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574275.url(scheme.get, call_574275.host, call_574275.base,
                         call_574275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574275, url, valid)

proc call*(call_574276: Call_ProfilesCreate_574267; imageId: string;
          inputRequest: JsonNode; workspace: string; subscriptionId: string;
          resourceGroup: string): Recallable =
  ## profilesCreate
  ## Create a Profile for an Image.
  ##   imageId: string (required)
  ##          : The Image Id.
  ##   inputRequest: JObject (required)
  ##               : The payload that is used to create the Profile.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  var path_574277 = newJObject()
  var body_574278 = newJObject()
  add(path_574277, "imageId", newJString(imageId))
  if inputRequest != nil:
    body_574278 = inputRequest
  add(path_574277, "workspace", newJString(workspace))
  add(path_574277, "subscriptionId", newJString(subscriptionId))
  add(path_574277, "resourceGroup", newJString(resourceGroup))
  result = call_574276.call(path_574277, nil, nil, nil, body_574278)

var profilesCreate* = Call_ProfilesCreate_574267(name: "profilesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/images/{imageId}/profiles",
    validator: validate_ProfilesCreate_574268, base: "", url: url_ProfilesCreate_574269,
    schemes: {Scheme.Https})
type
  Call_ProfilesListQuery_574249 = ref object of OpenApiRestCall_573650
proc url_ProfilesListQuery_574251(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "imageId" in path, "`imageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/images/"),
               (kind: VariableSegment, value: "imageId"),
               (kind: ConstantSegment, value: "/profiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesListQuery_574250(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## If no filter is passed, the query lists all Profiles for the Image. The returned list is paginated and the count of items in each page is an optional parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageId: JString (required)
  ##          : The Image Id.
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `imageId` field"
  var valid_574252 = path.getOrDefault("imageId")
  valid_574252 = validateParameter(valid_574252, JString, required = true,
                                 default = nil)
  if valid_574252 != nil:
    section.add "imageId", valid_574252
  var valid_574253 = path.getOrDefault("workspace")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = nil)
  if valid_574253 != nil:
    section.add "workspace", valid_574253
  var valid_574254 = path.getOrDefault("subscriptionId")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "subscriptionId", valid_574254
  var valid_574255 = path.getOrDefault("resourceGroup")
  valid_574255 = validateParameter(valid_574255, JString, required = true,
                                 default = nil)
  if valid_574255 != nil:
    section.add "resourceGroup", valid_574255
  result.add "path", section
  ## parameters in `query` object:
  ##   orderBy: JString
  ##          : The option to order the response.
  ##   name: JString
  ##       : The Profile name.
  ##   description: JString
  ##              : The Profile description.
  ##   properties: JString
  ##             : A set of properties with which to filter the returned models.
  ##             It is a comma separated string of properties key and/or properties key=value
  ##             Example: propKey1,propKey2,propKey3=value3
  ##   tags: JString
  ##       : A set of tags with which to filter the returned models.
  ##             It is a comma separated string of tags key or tags key=value
  ##             Example: tagKey1,tagKey2,tagKey3=value3
  ##   $skipToken: JString
  ##             : The continuation token to retrieve the next page.
  ##   count: JInt
  ##        : The number of items to retrieve in a page.
  section = newJObject()
  var valid_574256 = query.getOrDefault("orderBy")
  valid_574256 = validateParameter(valid_574256, JString, required = false,
                                 default = newJString("CreatedAtDesc"))
  if valid_574256 != nil:
    section.add "orderBy", valid_574256
  var valid_574257 = query.getOrDefault("name")
  valid_574257 = validateParameter(valid_574257, JString, required = false,
                                 default = nil)
  if valid_574257 != nil:
    section.add "name", valid_574257
  var valid_574258 = query.getOrDefault("description")
  valid_574258 = validateParameter(valid_574258, JString, required = false,
                                 default = nil)
  if valid_574258 != nil:
    section.add "description", valid_574258
  var valid_574259 = query.getOrDefault("properties")
  valid_574259 = validateParameter(valid_574259, JString, required = false,
                                 default = nil)
  if valid_574259 != nil:
    section.add "properties", valid_574259
  var valid_574260 = query.getOrDefault("tags")
  valid_574260 = validateParameter(valid_574260, JString, required = false,
                                 default = nil)
  if valid_574260 != nil:
    section.add "tags", valid_574260
  var valid_574261 = query.getOrDefault("$skipToken")
  valid_574261 = validateParameter(valid_574261, JString, required = false,
                                 default = nil)
  if valid_574261 != nil:
    section.add "$skipToken", valid_574261
  var valid_574262 = query.getOrDefault("count")
  valid_574262 = validateParameter(valid_574262, JInt, required = false, default = nil)
  if valid_574262 != nil:
    section.add "count", valid_574262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574263: Call_ProfilesListQuery_574249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If no filter is passed, the query lists all Profiles for the Image. The returned list is paginated and the count of items in each page is an optional parameter.
  ## 
  let valid = call_574263.validator(path, query, header, formData, body)
  let scheme = call_574263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574263.url(scheme.get, call_574263.host, call_574263.base,
                         call_574263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574263, url, valid)

proc call*(call_574264: Call_ProfilesListQuery_574249; imageId: string;
          workspace: string; subscriptionId: string; resourceGroup: string;
          orderBy: string = "CreatedAtDesc"; name: string = "";
          description: string = ""; properties: string = ""; tags: string = "";
          SkipToken: string = ""; count: int = 0): Recallable =
  ## profilesListQuery
  ## If no filter is passed, the query lists all Profiles for the Image. The returned list is paginated and the count of items in each page is an optional parameter.
  ##   imageId: string (required)
  ##          : The Image Id.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   orderBy: string
  ##          : The option to order the response.
  ##   name: string
  ##       : The Profile name.
  ##   description: string
  ##              : The Profile description.
  ##   properties: string
  ##             : A set of properties with which to filter the returned models.
  ##             It is a comma separated string of properties key and/or properties key=value
  ##             Example: propKey1,propKey2,propKey3=value3
  ##   tags: string
  ##       : A set of tags with which to filter the returned models.
  ##             It is a comma separated string of tags key or tags key=value
  ##             Example: tagKey1,tagKey2,tagKey3=value3
  ##   SkipToken: string
  ##            : The continuation token to retrieve the next page.
  ##   count: int
  ##        : The number of items to retrieve in a page.
  var path_574265 = newJObject()
  var query_574266 = newJObject()
  add(path_574265, "imageId", newJString(imageId))
  add(path_574265, "workspace", newJString(workspace))
  add(path_574265, "subscriptionId", newJString(subscriptionId))
  add(path_574265, "resourceGroup", newJString(resourceGroup))
  add(query_574266, "orderBy", newJString(orderBy))
  add(query_574266, "name", newJString(name))
  add(query_574266, "description", newJString(description))
  add(query_574266, "properties", newJString(properties))
  add(query_574266, "tags", newJString(tags))
  add(query_574266, "$skipToken", newJString(SkipToken))
  add(query_574266, "count", newJInt(count))
  result = call_574264.call(path_574265, query_574266, nil, nil, nil)

var profilesListQuery* = Call_ProfilesListQuery_574249(name: "profilesListQuery",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/images/{imageId}/profiles",
    validator: validate_ProfilesListQuery_574250, base: "",
    url: url_ProfilesListQuery_574251, schemes: {Scheme.Https})
type
  Call_ProfilesQueryById_574279 = ref object of OpenApiRestCall_573650
proc url_ProfilesQueryById_574281(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "imageId" in path, "`imageId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/images/"),
               (kind: VariableSegment, value: "imageId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesQueryById_574280(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get the Profile for an Image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageId: JString (required)
  ##          : The Image Id.
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Profile Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `imageId` field"
  var valid_574282 = path.getOrDefault("imageId")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "imageId", valid_574282
  var valid_574283 = path.getOrDefault("workspace")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "workspace", valid_574283
  var valid_574284 = path.getOrDefault("subscriptionId")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = nil)
  if valid_574284 != nil:
    section.add "subscriptionId", valid_574284
  var valid_574285 = path.getOrDefault("resourceGroup")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = nil)
  if valid_574285 != nil:
    section.add "resourceGroup", valid_574285
  var valid_574286 = path.getOrDefault("id")
  valid_574286 = validateParameter(valid_574286, JString, required = true,
                                 default = nil)
  if valid_574286 != nil:
    section.add "id", valid_574286
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574287: Call_ProfilesQueryById_574279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the Profile for an Image.
  ## 
  let valid = call_574287.validator(path, query, header, formData, body)
  let scheme = call_574287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574287.url(scheme.get, call_574287.host, call_574287.base,
                         call_574287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574287, url, valid)

proc call*(call_574288: Call_ProfilesQueryById_574279; imageId: string;
          workspace: string; subscriptionId: string; resourceGroup: string; id: string): Recallable =
  ## profilesQueryById
  ## Get the Profile for an Image.
  ##   imageId: string (required)
  ##          : The Image Id.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Profile Id.
  var path_574289 = newJObject()
  add(path_574289, "imageId", newJString(imageId))
  add(path_574289, "workspace", newJString(workspace))
  add(path_574289, "subscriptionId", newJString(subscriptionId))
  add(path_574289, "resourceGroup", newJString(resourceGroup))
  add(path_574289, "id", newJString(id))
  result = call_574288.call(path_574289, nil, nil, nil, nil)

var profilesQueryById* = Call_ProfilesQueryById_574279(name: "profilesQueryById",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/images/{imageId}/profiles/{id}",
    validator: validate_ProfilesQueryById_574280, base: "",
    url: url_ProfilesQueryById_574281, schemes: {Scheme.Https})
type
  Call_MlmodelsRegister_574309 = ref object of OpenApiRestCall_573650
proc url_MlmodelsRegister_574311(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/models")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlmodelsRegister_574310(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Register the model provided.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574312 = path.getOrDefault("workspace")
  valid_574312 = validateParameter(valid_574312, JString, required = true,
                                 default = nil)
  if valid_574312 != nil:
    section.add "workspace", valid_574312
  var valid_574313 = path.getOrDefault("subscriptionId")
  valid_574313 = validateParameter(valid_574313, JString, required = true,
                                 default = nil)
  if valid_574313 != nil:
    section.add "subscriptionId", valid_574313
  var valid_574314 = path.getOrDefault("resourceGroup")
  valid_574314 = validateParameter(valid_574314, JString, required = true,
                                 default = nil)
  if valid_574314 != nil:
    section.add "resourceGroup", valid_574314
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   model: JObject (required)
  ##        : The payload that is used to register the model.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574316: Call_MlmodelsRegister_574309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register the model provided.
  ## 
  let valid = call_574316.validator(path, query, header, formData, body)
  let scheme = call_574316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574316.url(scheme.get, call_574316.host, call_574316.base,
                         call_574316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574316, url, valid)

proc call*(call_574317: Call_MlmodelsRegister_574309; workspace: string;
          model: JsonNode; subscriptionId: string; resourceGroup: string): Recallable =
  ## mlmodelsRegister
  ## Register the model provided.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   model: JObject (required)
  ##        : The payload that is used to register the model.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  var path_574318 = newJObject()
  var body_574319 = newJObject()
  add(path_574318, "workspace", newJString(workspace))
  if model != nil:
    body_574319 = model
  add(path_574318, "subscriptionId", newJString(subscriptionId))
  add(path_574318, "resourceGroup", newJString(resourceGroup))
  result = call_574317.call(path_574318, nil, nil, nil, body_574319)

var mlmodelsRegister* = Call_MlmodelsRegister_574309(name: "mlmodelsRegister",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/models",
    validator: validate_MlmodelsRegister_574310, base: "",
    url: url_MlmodelsRegister_574311, schemes: {Scheme.Https})
type
  Call_MlmodelsListQuery_574290 = ref object of OpenApiRestCall_573650
proc url_MlmodelsListQuery_574292(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/models")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlmodelsListQuery_574291(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## The result list can be filtered using tag and name. If no filter is passed, the query lists all the Models in the given workspace. The returned list is paginated and the count of items in each page is an optional parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574293 = path.getOrDefault("workspace")
  valid_574293 = validateParameter(valid_574293, JString, required = true,
                                 default = nil)
  if valid_574293 != nil:
    section.add "workspace", valid_574293
  var valid_574294 = path.getOrDefault("subscriptionId")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "subscriptionId", valid_574294
  var valid_574295 = path.getOrDefault("resourceGroup")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "resourceGroup", valid_574295
  result.add "path", section
  ## parameters in `query` object:
  ##   framework: JString
  ##            : The framework.
  ##   runId: JString
  ##        : The runId which created the model.
  ##   orderBy: JString
  ##          : An option to specify how the models are ordered in the response.
  ##   name: JString
  ##       : The object name.
  ##   description: JString
  ##              : The object description.
  ##   properties: JString
  ##             : A set of properties with which to filter the returned models.
  ##             It is a comma separated string of properties key and/or properties key=value
  ##             Example: propKey1,propKey2,propKey3=value3
  ##   tags: JString
  ##       : A set of tags with which to filter the returned models.
  ##             It is a comma separated string of tags key or tags key=value
  ##             Example: tagKey1,tagKey2,tagKey3=value3
  ##   $skipToken: JString
  ##             : The continuation token to retrieve the next page.
  ##   count: JInt
  ##        : The number of items to retrieve in a page.
  section = newJObject()
  var valid_574296 = query.getOrDefault("framework")
  valid_574296 = validateParameter(valid_574296, JString, required = false,
                                 default = nil)
  if valid_574296 != nil:
    section.add "framework", valid_574296
  var valid_574297 = query.getOrDefault("runId")
  valid_574297 = validateParameter(valid_574297, JString, required = false,
                                 default = nil)
  if valid_574297 != nil:
    section.add "runId", valid_574297
  var valid_574298 = query.getOrDefault("orderBy")
  valid_574298 = validateParameter(valid_574298, JString, required = false,
                                 default = newJString("CreatedAtDesc"))
  if valid_574298 != nil:
    section.add "orderBy", valid_574298
  var valid_574299 = query.getOrDefault("name")
  valid_574299 = validateParameter(valid_574299, JString, required = false,
                                 default = nil)
  if valid_574299 != nil:
    section.add "name", valid_574299
  var valid_574300 = query.getOrDefault("description")
  valid_574300 = validateParameter(valid_574300, JString, required = false,
                                 default = nil)
  if valid_574300 != nil:
    section.add "description", valid_574300
  var valid_574301 = query.getOrDefault("properties")
  valid_574301 = validateParameter(valid_574301, JString, required = false,
                                 default = nil)
  if valid_574301 != nil:
    section.add "properties", valid_574301
  var valid_574302 = query.getOrDefault("tags")
  valid_574302 = validateParameter(valid_574302, JString, required = false,
                                 default = nil)
  if valid_574302 != nil:
    section.add "tags", valid_574302
  var valid_574303 = query.getOrDefault("$skipToken")
  valid_574303 = validateParameter(valid_574303, JString, required = false,
                                 default = nil)
  if valid_574303 != nil:
    section.add "$skipToken", valid_574303
  var valid_574304 = query.getOrDefault("count")
  valid_574304 = validateParameter(valid_574304, JInt, required = false, default = nil)
  if valid_574304 != nil:
    section.add "count", valid_574304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574305: Call_MlmodelsListQuery_574290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The result list can be filtered using tag and name. If no filter is passed, the query lists all the Models in the given workspace. The returned list is paginated and the count of items in each page is an optional parameter.
  ## 
  let valid = call_574305.validator(path, query, header, formData, body)
  let scheme = call_574305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574305.url(scheme.get, call_574305.host, call_574305.base,
                         call_574305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574305, url, valid)

proc call*(call_574306: Call_MlmodelsListQuery_574290; workspace: string;
          subscriptionId: string; resourceGroup: string; framework: string = "";
          runId: string = ""; orderBy: string = "CreatedAtDesc"; name: string = "";
          description: string = ""; properties: string = ""; tags: string = "";
          SkipToken: string = ""; count: int = 0): Recallable =
  ## mlmodelsListQuery
  ## The result list can be filtered using tag and name. If no filter is passed, the query lists all the Models in the given workspace. The returned list is paginated and the count of items in each page is an optional parameter.
  ##   framework: string
  ##            : The framework.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   runId: string
  ##        : The runId which created the model.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   orderBy: string
  ##          : An option to specify how the models are ordered in the response.
  ##   name: string
  ##       : The object name.
  ##   description: string
  ##              : The object description.
  ##   properties: string
  ##             : A set of properties with which to filter the returned models.
  ##             It is a comma separated string of properties key and/or properties key=value
  ##             Example: propKey1,propKey2,propKey3=value3
  ##   tags: string
  ##       : A set of tags with which to filter the returned models.
  ##             It is a comma separated string of tags key or tags key=value
  ##             Example: tagKey1,tagKey2,tagKey3=value3
  ##   SkipToken: string
  ##            : The continuation token to retrieve the next page.
  ##   count: int
  ##        : The number of items to retrieve in a page.
  var path_574307 = newJObject()
  var query_574308 = newJObject()
  add(query_574308, "framework", newJString(framework))
  add(path_574307, "workspace", newJString(workspace))
  add(query_574308, "runId", newJString(runId))
  add(path_574307, "subscriptionId", newJString(subscriptionId))
  add(path_574307, "resourceGroup", newJString(resourceGroup))
  add(query_574308, "orderBy", newJString(orderBy))
  add(query_574308, "name", newJString(name))
  add(query_574308, "description", newJString(description))
  add(query_574308, "properties", newJString(properties))
  add(query_574308, "tags", newJString(tags))
  add(query_574308, "$skipToken", newJString(SkipToken))
  add(query_574308, "count", newJInt(count))
  result = call_574306.call(path_574307, query_574308, nil, nil, nil)

var mlmodelsListQuery* = Call_MlmodelsListQuery_574290(name: "mlmodelsListQuery",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/models",
    validator: validate_MlmodelsListQuery_574291, base: "",
    url: url_MlmodelsListQuery_574292, schemes: {Scheme.Https})
type
  Call_MlmodelsQueryById_574320 = ref object of OpenApiRestCall_573650
proc url_MlmodelsQueryById_574322(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/models/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlmodelsQueryById_574321(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a model by model id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The model id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574323 = path.getOrDefault("workspace")
  valid_574323 = validateParameter(valid_574323, JString, required = true,
                                 default = nil)
  if valid_574323 != nil:
    section.add "workspace", valid_574323
  var valid_574324 = path.getOrDefault("subscriptionId")
  valid_574324 = validateParameter(valid_574324, JString, required = true,
                                 default = nil)
  if valid_574324 != nil:
    section.add "subscriptionId", valid_574324
  var valid_574325 = path.getOrDefault("resourceGroup")
  valid_574325 = validateParameter(valid_574325, JString, required = true,
                                 default = nil)
  if valid_574325 != nil:
    section.add "resourceGroup", valid_574325
  var valid_574326 = path.getOrDefault("id")
  valid_574326 = validateParameter(valid_574326, JString, required = true,
                                 default = nil)
  if valid_574326 != nil:
    section.add "id", valid_574326
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574327: Call_MlmodelsQueryById_574320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a model by model id.
  ## 
  let valid = call_574327.validator(path, query, header, formData, body)
  let scheme = call_574327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574327.url(scheme.get, call_574327.host, call_574327.base,
                         call_574327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574327, url, valid)

proc call*(call_574328: Call_MlmodelsQueryById_574320; workspace: string;
          subscriptionId: string; resourceGroup: string; id: string): Recallable =
  ## mlmodelsQueryById
  ## Gets a model by model id.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The model id.
  var path_574329 = newJObject()
  add(path_574329, "workspace", newJString(workspace))
  add(path_574329, "subscriptionId", newJString(subscriptionId))
  add(path_574329, "resourceGroup", newJString(resourceGroup))
  add(path_574329, "id", newJString(id))
  result = call_574328.call(path_574329, nil, nil, nil, nil)

var mlmodelsQueryById* = Call_MlmodelsQueryById_574320(name: "mlmodelsQueryById",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/models/{id}",
    validator: validate_MlmodelsQueryById_574321, base: "",
    url: url_MlmodelsQueryById_574322, schemes: {Scheme.Https})
type
  Call_MlmodelsPatch_574340 = ref object of OpenApiRestCall_573650
proc url_MlmodelsPatch_574342(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/models/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlmodelsPatch_574341(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing model with the specified patch.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The model id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574343 = path.getOrDefault("workspace")
  valid_574343 = validateParameter(valid_574343, JString, required = true,
                                 default = nil)
  if valid_574343 != nil:
    section.add "workspace", valid_574343
  var valid_574344 = path.getOrDefault("subscriptionId")
  valid_574344 = validateParameter(valid_574344, JString, required = true,
                                 default = nil)
  if valid_574344 != nil:
    section.add "subscriptionId", valid_574344
  var valid_574345 = path.getOrDefault("resourceGroup")
  valid_574345 = validateParameter(valid_574345, JString, required = true,
                                 default = nil)
  if valid_574345 != nil:
    section.add "resourceGroup", valid_574345
  var valid_574346 = path.getOrDefault("id")
  valid_574346 = validateParameter(valid_574346, JString, required = true,
                                 default = nil)
  if valid_574346 != nil:
    section.add "id", valid_574346
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patch: JArray (required)
  ##        : The payload that is used to patch the model.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574348: Call_MlmodelsPatch_574340; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing model with the specified patch.
  ## 
  let valid = call_574348.validator(path, query, header, formData, body)
  let scheme = call_574348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574348.url(scheme.get, call_574348.host, call_574348.base,
                         call_574348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574348, url, valid)

proc call*(call_574349: Call_MlmodelsPatch_574340; workspace: string;
          patch: JsonNode; subscriptionId: string; resourceGroup: string; id: string): Recallable =
  ## mlmodelsPatch
  ## Updates an existing model with the specified patch.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   patch: JArray (required)
  ##        : The payload that is used to patch the model.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The model id.
  var path_574350 = newJObject()
  var body_574351 = newJObject()
  add(path_574350, "workspace", newJString(workspace))
  if patch != nil:
    body_574351 = patch
  add(path_574350, "subscriptionId", newJString(subscriptionId))
  add(path_574350, "resourceGroup", newJString(resourceGroup))
  add(path_574350, "id", newJString(id))
  result = call_574349.call(path_574350, nil, nil, nil, body_574351)

var mlmodelsPatch* = Call_MlmodelsPatch_574340(name: "mlmodelsPatch",
    meth: HttpMethod.HttpPatch, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/models/{id}",
    validator: validate_MlmodelsPatch_574341, base: "", url: url_MlmodelsPatch_574342,
    schemes: {Scheme.Https})
type
  Call_MlmodelsDelete_574330 = ref object of OpenApiRestCall_573650
proc url_MlmodelsDelete_574332(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/models/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlmodelsDelete_574331(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a model if it exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The model id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574333 = path.getOrDefault("workspace")
  valid_574333 = validateParameter(valid_574333, JString, required = true,
                                 default = nil)
  if valid_574333 != nil:
    section.add "workspace", valid_574333
  var valid_574334 = path.getOrDefault("subscriptionId")
  valid_574334 = validateParameter(valid_574334, JString, required = true,
                                 default = nil)
  if valid_574334 != nil:
    section.add "subscriptionId", valid_574334
  var valid_574335 = path.getOrDefault("resourceGroup")
  valid_574335 = validateParameter(valid_574335, JString, required = true,
                                 default = nil)
  if valid_574335 != nil:
    section.add "resourceGroup", valid_574335
  var valid_574336 = path.getOrDefault("id")
  valid_574336 = validateParameter(valid_574336, JString, required = true,
                                 default = nil)
  if valid_574336 != nil:
    section.add "id", valid_574336
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574337: Call_MlmodelsDelete_574330; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a model if it exists.
  ## 
  let valid = call_574337.validator(path, query, header, formData, body)
  let scheme = call_574337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574337.url(scheme.get, call_574337.host, call_574337.base,
                         call_574337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574337, url, valid)

proc call*(call_574338: Call_MlmodelsDelete_574330; workspace: string;
          subscriptionId: string; resourceGroup: string; id: string): Recallable =
  ## mlmodelsDelete
  ## Deletes a model if it exists.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The model id.
  var path_574339 = newJObject()
  add(path_574339, "workspace", newJString(workspace))
  add(path_574339, "subscriptionId", newJString(subscriptionId))
  add(path_574339, "resourceGroup", newJString(resourceGroup))
  add(path_574339, "id", newJString(id))
  result = call_574338.call(path_574339, nil, nil, nil, nil)

var mlmodelsDelete* = Call_MlmodelsDelete_574330(name: "mlmodelsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/models/{id}",
    validator: validate_MlmodelsDelete_574331, base: "", url: url_MlmodelsDelete_574332,
    schemes: {Scheme.Https})
type
  Call_MlmodelsGetMetrics_574352 = ref object of OpenApiRestCall_573650
proc url_MlmodelsGetMetrics_574354(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/models/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlmodelsGetMetrics_574353(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The operational events collected for the Model are returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Model Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574355 = path.getOrDefault("workspace")
  valid_574355 = validateParameter(valid_574355, JString, required = true,
                                 default = nil)
  if valid_574355 != nil:
    section.add "workspace", valid_574355
  var valid_574356 = path.getOrDefault("subscriptionId")
  valid_574356 = validateParameter(valid_574356, JString, required = true,
                                 default = nil)
  if valid_574356 != nil:
    section.add "subscriptionId", valid_574356
  var valid_574357 = path.getOrDefault("resourceGroup")
  valid_574357 = validateParameter(valid_574357, JString, required = true,
                                 default = nil)
  if valid_574357 != nil:
    section.add "resourceGroup", valid_574357
  var valid_574358 = path.getOrDefault("id")
  valid_574358 = validateParameter(valid_574358, JString, required = true,
                                 default = nil)
  if valid_574358 != nil:
    section.add "id", valid_574358
  result.add "path", section
  ## parameters in `query` object:
  ##   endDate: JString
  ##          : The end date from which to retrieve metrics, ISO 8601 literal format.
  ##   startDate: JString
  ##            : The start date from which to retrieve metrics, ISO 8601 literal format.
  section = newJObject()
  var valid_574359 = query.getOrDefault("endDate")
  valid_574359 = validateParameter(valid_574359, JString, required = false,
                                 default = nil)
  if valid_574359 != nil:
    section.add "endDate", valid_574359
  var valid_574360 = query.getOrDefault("startDate")
  valid_574360 = validateParameter(valid_574360, JString, required = false,
                                 default = nil)
  if valid_574360 != nil:
    section.add "startDate", valid_574360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574361: Call_MlmodelsGetMetrics_574352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operational events collected for the Model are returned.
  ## 
  let valid = call_574361.validator(path, query, header, formData, body)
  let scheme = call_574361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574361.url(scheme.get, call_574361.host, call_574361.base,
                         call_574361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574361, url, valid)

proc call*(call_574362: Call_MlmodelsGetMetrics_574352; workspace: string;
          subscriptionId: string; resourceGroup: string; id: string;
          endDate: string = ""; startDate: string = ""): Recallable =
  ## mlmodelsGetMetrics
  ## The operational events collected for the Model are returned.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   endDate: string
  ##          : The end date from which to retrieve metrics, ISO 8601 literal format.
  ##   startDate: string
  ##            : The start date from which to retrieve metrics, ISO 8601 literal format.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Model Id.
  var path_574363 = newJObject()
  var query_574364 = newJObject()
  add(path_574363, "workspace", newJString(workspace))
  add(query_574364, "endDate", newJString(endDate))
  add(query_574364, "startDate", newJString(startDate))
  add(path_574363, "subscriptionId", newJString(subscriptionId))
  add(path_574363, "resourceGroup", newJString(resourceGroup))
  add(path_574363, "id", newJString(id))
  result = call_574362.call(path_574363, query_574364, nil, nil, nil)

var mlmodelsGetMetrics* = Call_MlmodelsGetMetrics_574352(
    name: "mlmodelsGetMetrics", meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/models/{id}/metrics",
    validator: validate_MlmodelsGetMetrics_574353, base: "",
    url: url_MlmodelsGetMetrics_574354, schemes: {Scheme.Https})
type
  Call_OperationsGet_574365 = ref object of OpenApiRestCall_573650
proc url_OperationsGet_574367(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationsGet_574366(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the status of an async operation by operation id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The operation id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574368 = path.getOrDefault("workspace")
  valid_574368 = validateParameter(valid_574368, JString, required = true,
                                 default = nil)
  if valid_574368 != nil:
    section.add "workspace", valid_574368
  var valid_574369 = path.getOrDefault("subscriptionId")
  valid_574369 = validateParameter(valid_574369, JString, required = true,
                                 default = nil)
  if valid_574369 != nil:
    section.add "subscriptionId", valid_574369
  var valid_574370 = path.getOrDefault("resourceGroup")
  valid_574370 = validateParameter(valid_574370, JString, required = true,
                                 default = nil)
  if valid_574370 != nil:
    section.add "resourceGroup", valid_574370
  var valid_574371 = path.getOrDefault("id")
  valid_574371 = validateParameter(valid_574371, JString, required = true,
                                 default = nil)
  if valid_574371 != nil:
    section.add "id", valid_574371
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574372: Call_OperationsGet_574365; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the status of an async operation by operation id.
  ## 
  let valid = call_574372.validator(path, query, header, formData, body)
  let scheme = call_574372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574372.url(scheme.get, call_574372.host, call_574372.base,
                         call_574372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574372, url, valid)

proc call*(call_574373: Call_OperationsGet_574365; workspace: string;
          subscriptionId: string; resourceGroup: string; id: string): Recallable =
  ## operationsGet
  ## Get the status of an async operation by operation id.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The operation id.
  var path_574374 = newJObject()
  add(path_574374, "workspace", newJString(workspace))
  add(path_574374, "subscriptionId", newJString(subscriptionId))
  add(path_574374, "resourceGroup", newJString(resourceGroup))
  add(path_574374, "id", newJString(id))
  result = call_574373.call(path_574374, nil, nil, nil, nil)

var operationsGet* = Call_OperationsGet_574365(name: "operationsGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/operations/{id}",
    validator: validate_OperationsGet_574366, base: "", url: url_OperationsGet_574367,
    schemes: {Scheme.Https})
type
  Call_ServicesCreate_574397 = ref object of OpenApiRestCall_573650
proc url_ServicesCreate_574399(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCreate_574398(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create a Service with the specified payload.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574400 = path.getOrDefault("workspace")
  valid_574400 = validateParameter(valid_574400, JString, required = true,
                                 default = nil)
  if valid_574400 != nil:
    section.add "workspace", valid_574400
  var valid_574401 = path.getOrDefault("subscriptionId")
  valid_574401 = validateParameter(valid_574401, JString, required = true,
                                 default = nil)
  if valid_574401 != nil:
    section.add "subscriptionId", valid_574401
  var valid_574402 = path.getOrDefault("resourceGroup")
  valid_574402 = validateParameter(valid_574402, JString, required = true,
                                 default = nil)
  if valid_574402 != nil:
    section.add "resourceGroup", valid_574402
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : The payload that is used to create the Service.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574404: Call_ServicesCreate_574397; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a Service with the specified payload.
  ## 
  let valid = call_574404.validator(path, query, header, formData, body)
  let scheme = call_574404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574404.url(scheme.get, call_574404.host, call_574404.base,
                         call_574404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574404, url, valid)

proc call*(call_574405: Call_ServicesCreate_574397; workspace: string;
          subscriptionId: string; resourceGroup: string; request: JsonNode): Recallable =
  ## servicesCreate
  ## Create a Service with the specified payload.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   request: JObject (required)
  ##          : The payload that is used to create the Service.
  var path_574406 = newJObject()
  var body_574407 = newJObject()
  add(path_574406, "workspace", newJString(workspace))
  add(path_574406, "subscriptionId", newJString(subscriptionId))
  add(path_574406, "resourceGroup", newJString(resourceGroup))
  if request != nil:
    body_574407 = request
  result = call_574405.call(path_574406, nil, nil, nil, body_574407)

var servicesCreate* = Call_ServicesCreate_574397(name: "servicesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/services",
    validator: validate_ServicesCreate_574398, base: "", url: url_ServicesCreate_574399,
    schemes: {Scheme.Https})
type
  Call_ServicesListQuery_574375 = ref object of OpenApiRestCall_573650
proc url_ServicesListQuery_574377(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListQuery_574376(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## If no filter is passed, the query lists all Services in the Workspace. The returned list is paginated and the count of item in each page is an optional parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574378 = path.getOrDefault("workspace")
  valid_574378 = validateParameter(valid_574378, JString, required = true,
                                 default = nil)
  if valid_574378 != nil:
    section.add "workspace", valid_574378
  var valid_574379 = path.getOrDefault("subscriptionId")
  valid_574379 = validateParameter(valid_574379, JString, required = true,
                                 default = nil)
  if valid_574379 != nil:
    section.add "subscriptionId", valid_574379
  var valid_574380 = path.getOrDefault("resourceGroup")
  valid_574380 = validateParameter(valid_574380, JString, required = true,
                                 default = nil)
  if valid_574380 != nil:
    section.add "resourceGroup", valid_574380
  result.add "path", section
  ## parameters in `query` object:
  ##   imageName: JString
  ##            : The Image name.
  ##   computeType: JString
  ##              : The compute environment type.
  ##   expand: JBool
  ##         : Set to True to include Model details.
  ##   modelId: JString
  ##          : The Model Id.
  ##   orderby: JString
  ##          : The option to order the response.
  ##   imageId: JString
  ##          : The Image Id.
  ##   modelName: JString
  ##            : The Model name.
  ##   name: JString
  ##       : The object name.
  ##   properties: JString
  ##             : A set of properties with which to filter the returned models.
  ##             It is a comma separated string of properties key and/or properties key=value
  ##             Example: propKey1,propKey2,propKey3=value3
  ##   tags: JString
  ##       : A set of tags with which to filter the returned models.
  ##             It is a comma separated string of tags key or tags key=value
  ##             Example: tagKey1,tagKey2,tagKey3=value3
  ##   $skipToken: JString
  ##             : The continuation token to retrieve the next page.
  ##   count: JInt
  ##        : The number of items to retrieve in a page.
  section = newJObject()
  var valid_574381 = query.getOrDefault("imageName")
  valid_574381 = validateParameter(valid_574381, JString, required = false,
                                 default = nil)
  if valid_574381 != nil:
    section.add "imageName", valid_574381
  var valid_574382 = query.getOrDefault("computeType")
  valid_574382 = validateParameter(valid_574382, JString, required = false,
                                 default = nil)
  if valid_574382 != nil:
    section.add "computeType", valid_574382
  var valid_574383 = query.getOrDefault("expand")
  valid_574383 = validateParameter(valid_574383, JBool, required = false,
                                 default = newJBool(false))
  if valid_574383 != nil:
    section.add "expand", valid_574383
  var valid_574384 = query.getOrDefault("modelId")
  valid_574384 = validateParameter(valid_574384, JString, required = false,
                                 default = nil)
  if valid_574384 != nil:
    section.add "modelId", valid_574384
  var valid_574385 = query.getOrDefault("orderby")
  valid_574385 = validateParameter(valid_574385, JString, required = false,
                                 default = newJString("UpdatedAtDesc"))
  if valid_574385 != nil:
    section.add "orderby", valid_574385
  var valid_574386 = query.getOrDefault("imageId")
  valid_574386 = validateParameter(valid_574386, JString, required = false,
                                 default = nil)
  if valid_574386 != nil:
    section.add "imageId", valid_574386
  var valid_574387 = query.getOrDefault("modelName")
  valid_574387 = validateParameter(valid_574387, JString, required = false,
                                 default = nil)
  if valid_574387 != nil:
    section.add "modelName", valid_574387
  var valid_574388 = query.getOrDefault("name")
  valid_574388 = validateParameter(valid_574388, JString, required = false,
                                 default = nil)
  if valid_574388 != nil:
    section.add "name", valid_574388
  var valid_574389 = query.getOrDefault("properties")
  valid_574389 = validateParameter(valid_574389, JString, required = false,
                                 default = nil)
  if valid_574389 != nil:
    section.add "properties", valid_574389
  var valid_574390 = query.getOrDefault("tags")
  valid_574390 = validateParameter(valid_574390, JString, required = false,
                                 default = nil)
  if valid_574390 != nil:
    section.add "tags", valid_574390
  var valid_574391 = query.getOrDefault("$skipToken")
  valid_574391 = validateParameter(valid_574391, JString, required = false,
                                 default = nil)
  if valid_574391 != nil:
    section.add "$skipToken", valid_574391
  var valid_574392 = query.getOrDefault("count")
  valid_574392 = validateParameter(valid_574392, JInt, required = false, default = nil)
  if valid_574392 != nil:
    section.add "count", valid_574392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574393: Call_ServicesListQuery_574375; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If no filter is passed, the query lists all Services in the Workspace. The returned list is paginated and the count of item in each page is an optional parameter.
  ## 
  let valid = call_574393.validator(path, query, header, formData, body)
  let scheme = call_574393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574393.url(scheme.get, call_574393.host, call_574393.base,
                         call_574393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574393, url, valid)

proc call*(call_574394: Call_ServicesListQuery_574375; workspace: string;
          subscriptionId: string; resourceGroup: string; imageName: string = "";
          computeType: string = ""; expand: bool = false; modelId: string = "";
          orderby: string = "UpdatedAtDesc"; imageId: string = "";
          modelName: string = ""; name: string = ""; properties: string = "";
          tags: string = ""; SkipToken: string = ""; count: int = 0): Recallable =
  ## servicesListQuery
  ## If no filter is passed, the query lists all Services in the Workspace. The returned list is paginated and the count of item in each page is an optional parameter.
  ##   imageName: string
  ##            : The Image name.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   computeType: string
  ##              : The compute environment type.
  ##   expand: bool
  ##         : Set to True to include Model details.
  ##   modelId: string
  ##          : The Model Id.
  ##   orderby: string
  ##          : The option to order the response.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   imageId: string
  ##          : The Image Id.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   modelName: string
  ##            : The Model name.
  ##   name: string
  ##       : The object name.
  ##   properties: string
  ##             : A set of properties with which to filter the returned models.
  ##             It is a comma separated string of properties key and/or properties key=value
  ##             Example: propKey1,propKey2,propKey3=value3
  ##   tags: string
  ##       : A set of tags with which to filter the returned models.
  ##             It is a comma separated string of tags key or tags key=value
  ##             Example: tagKey1,tagKey2,tagKey3=value3
  ##   SkipToken: string
  ##            : The continuation token to retrieve the next page.
  ##   count: int
  ##        : The number of items to retrieve in a page.
  var path_574395 = newJObject()
  var query_574396 = newJObject()
  add(query_574396, "imageName", newJString(imageName))
  add(path_574395, "workspace", newJString(workspace))
  add(query_574396, "computeType", newJString(computeType))
  add(query_574396, "expand", newJBool(expand))
  add(query_574396, "modelId", newJString(modelId))
  add(query_574396, "orderby", newJString(orderby))
  add(path_574395, "subscriptionId", newJString(subscriptionId))
  add(query_574396, "imageId", newJString(imageId))
  add(path_574395, "resourceGroup", newJString(resourceGroup))
  add(query_574396, "modelName", newJString(modelName))
  add(query_574396, "name", newJString(name))
  add(query_574396, "properties", newJString(properties))
  add(query_574396, "tags", newJString(tags))
  add(query_574396, "$skipToken", newJString(SkipToken))
  add(query_574396, "count", newJInt(count))
  result = call_574394.call(path_574395, query_574396, nil, nil, nil)

var servicesListQuery* = Call_ServicesListQuery_574375(name: "servicesListQuery",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/services",
    validator: validate_ServicesListQuery_574376, base: "",
    url: url_ServicesListQuery_574377, schemes: {Scheme.Https})
type
  Call_ServicesQueryById_574408 = ref object of OpenApiRestCall_573650
proc url_ServicesQueryById_574410(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesQueryById_574409(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get a Service by Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Service Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574411 = path.getOrDefault("workspace")
  valid_574411 = validateParameter(valid_574411, JString, required = true,
                                 default = nil)
  if valid_574411 != nil:
    section.add "workspace", valid_574411
  var valid_574412 = path.getOrDefault("subscriptionId")
  valid_574412 = validateParameter(valid_574412, JString, required = true,
                                 default = nil)
  if valid_574412 != nil:
    section.add "subscriptionId", valid_574412
  var valid_574413 = path.getOrDefault("resourceGroup")
  valid_574413 = validateParameter(valid_574413, JString, required = true,
                                 default = nil)
  if valid_574413 != nil:
    section.add "resourceGroup", valid_574413
  var valid_574414 = path.getOrDefault("id")
  valid_574414 = validateParameter(valid_574414, JString, required = true,
                                 default = nil)
  if valid_574414 != nil:
    section.add "id", valid_574414
  result.add "path", section
  ## parameters in `query` object:
  ##   expand: JBool
  ##         : Set to True to include Model details.
  section = newJObject()
  var valid_574415 = query.getOrDefault("expand")
  valid_574415 = validateParameter(valid_574415, JBool, required = false,
                                 default = newJBool(false))
  if valid_574415 != nil:
    section.add "expand", valid_574415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574416: Call_ServicesQueryById_574408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service by Id.
  ## 
  let valid = call_574416.validator(path, query, header, formData, body)
  let scheme = call_574416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574416.url(scheme.get, call_574416.host, call_574416.base,
                         call_574416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574416, url, valid)

proc call*(call_574417: Call_ServicesQueryById_574408; workspace: string;
          subscriptionId: string; resourceGroup: string; id: string;
          expand: bool = false): Recallable =
  ## servicesQueryById
  ## Get a Service by Id.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   expand: bool
  ##         : Set to True to include Model details.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Service Id.
  var path_574418 = newJObject()
  var query_574419 = newJObject()
  add(path_574418, "workspace", newJString(workspace))
  add(query_574419, "expand", newJBool(expand))
  add(path_574418, "subscriptionId", newJString(subscriptionId))
  add(path_574418, "resourceGroup", newJString(resourceGroup))
  add(path_574418, "id", newJString(id))
  result = call_574417.call(path_574418, query_574419, nil, nil, nil)

var servicesQueryById* = Call_ServicesQueryById_574408(name: "servicesQueryById",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/services/{id}",
    validator: validate_ServicesQueryById_574409, base: "",
    url: url_ServicesQueryById_574410, schemes: {Scheme.Https})
type
  Call_ServicesPatch_574430 = ref object of OpenApiRestCall_573650
proc url_ServicesPatch_574432(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesPatch_574431(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch a specific Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Service Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574433 = path.getOrDefault("workspace")
  valid_574433 = validateParameter(valid_574433, JString, required = true,
                                 default = nil)
  if valid_574433 != nil:
    section.add "workspace", valid_574433
  var valid_574434 = path.getOrDefault("subscriptionId")
  valid_574434 = validateParameter(valid_574434, JString, required = true,
                                 default = nil)
  if valid_574434 != nil:
    section.add "subscriptionId", valid_574434
  var valid_574435 = path.getOrDefault("resourceGroup")
  valid_574435 = validateParameter(valid_574435, JString, required = true,
                                 default = nil)
  if valid_574435 != nil:
    section.add "resourceGroup", valid_574435
  var valid_574436 = path.getOrDefault("id")
  valid_574436 = validateParameter(valid_574436, JString, required = true,
                                 default = nil)
  if valid_574436 != nil:
    section.add "id", valid_574436
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patch: JArray (required)
  ##        : The payload that is used to patch the Service.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574438: Call_ServicesPatch_574430; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a specific Service.
  ## 
  let valid = call_574438.validator(path, query, header, formData, body)
  let scheme = call_574438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574438.url(scheme.get, call_574438.host, call_574438.base,
                         call_574438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574438, url, valid)

proc call*(call_574439: Call_ServicesPatch_574430; workspace: string;
          patch: JsonNode; subscriptionId: string; resourceGroup: string; id: string): Recallable =
  ## servicesPatch
  ## Patch a specific Service.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   patch: JArray (required)
  ##        : The payload that is used to patch the Service.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Service Id.
  var path_574440 = newJObject()
  var body_574441 = newJObject()
  add(path_574440, "workspace", newJString(workspace))
  if patch != nil:
    body_574441 = patch
  add(path_574440, "subscriptionId", newJString(subscriptionId))
  add(path_574440, "resourceGroup", newJString(resourceGroup))
  add(path_574440, "id", newJString(id))
  result = call_574439.call(path_574440, nil, nil, nil, body_574441)

var servicesPatch* = Call_ServicesPatch_574430(name: "servicesPatch",
    meth: HttpMethod.HttpPatch, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/services/{id}",
    validator: validate_ServicesPatch_574431, base: "", url: url_ServicesPatch_574432,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_574420 = ref object of OpenApiRestCall_573650
proc url_ServicesDelete_574422(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesDelete_574421(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a specific Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Service Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574423 = path.getOrDefault("workspace")
  valid_574423 = validateParameter(valid_574423, JString, required = true,
                                 default = nil)
  if valid_574423 != nil:
    section.add "workspace", valid_574423
  var valid_574424 = path.getOrDefault("subscriptionId")
  valid_574424 = validateParameter(valid_574424, JString, required = true,
                                 default = nil)
  if valid_574424 != nil:
    section.add "subscriptionId", valid_574424
  var valid_574425 = path.getOrDefault("resourceGroup")
  valid_574425 = validateParameter(valid_574425, JString, required = true,
                                 default = nil)
  if valid_574425 != nil:
    section.add "resourceGroup", valid_574425
  var valid_574426 = path.getOrDefault("id")
  valid_574426 = validateParameter(valid_574426, JString, required = true,
                                 default = nil)
  if valid_574426 != nil:
    section.add "id", valid_574426
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574427: Call_ServicesDelete_574420; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a specific Service.
  ## 
  let valid = call_574427.validator(path, query, header, formData, body)
  let scheme = call_574427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574427.url(scheme.get, call_574427.host, call_574427.base,
                         call_574427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574427, url, valid)

proc call*(call_574428: Call_ServicesDelete_574420; workspace: string;
          subscriptionId: string; resourceGroup: string; id: string): Recallable =
  ## servicesDelete
  ## Delete a specific Service.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Service Id.
  var path_574429 = newJObject()
  add(path_574429, "workspace", newJString(workspace))
  add(path_574429, "subscriptionId", newJString(subscriptionId))
  add(path_574429, "resourceGroup", newJString(resourceGroup))
  add(path_574429, "id", newJString(id))
  result = call_574428.call(path_574429, nil, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_574420(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/services/{id}",
    validator: validate_ServicesDelete_574421, base: "", url: url_ServicesDelete_574422,
    schemes: {Scheme.Https})
type
  Call_ServicesListServiceKeys_574442 = ref object of OpenApiRestCall_573650
proc url_ServicesListServiceKeys_574444(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/listkeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListServiceKeys_574443(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of Service keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Service Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574445 = path.getOrDefault("workspace")
  valid_574445 = validateParameter(valid_574445, JString, required = true,
                                 default = nil)
  if valid_574445 != nil:
    section.add "workspace", valid_574445
  var valid_574446 = path.getOrDefault("subscriptionId")
  valid_574446 = validateParameter(valid_574446, JString, required = true,
                                 default = nil)
  if valid_574446 != nil:
    section.add "subscriptionId", valid_574446
  var valid_574447 = path.getOrDefault("resourceGroup")
  valid_574447 = validateParameter(valid_574447, JString, required = true,
                                 default = nil)
  if valid_574447 != nil:
    section.add "resourceGroup", valid_574447
  var valid_574448 = path.getOrDefault("id")
  valid_574448 = validateParameter(valid_574448, JString, required = true,
                                 default = nil)
  if valid_574448 != nil:
    section.add "id", valid_574448
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574449: Call_ServicesListServiceKeys_574442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of Service keys.
  ## 
  let valid = call_574449.validator(path, query, header, formData, body)
  let scheme = call_574449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574449.url(scheme.get, call_574449.host, call_574449.base,
                         call_574449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574449, url, valid)

proc call*(call_574450: Call_ServicesListServiceKeys_574442; workspace: string;
          subscriptionId: string; resourceGroup: string; id: string): Recallable =
  ## servicesListServiceKeys
  ## Gets a list of Service keys.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Service Id.
  var path_574451 = newJObject()
  add(path_574451, "workspace", newJString(workspace))
  add(path_574451, "subscriptionId", newJString(subscriptionId))
  add(path_574451, "resourceGroup", newJString(resourceGroup))
  add(path_574451, "id", newJString(id))
  result = call_574450.call(path_574451, nil, nil, nil, nil)

var servicesListServiceKeys* = Call_ServicesListServiceKeys_574442(
    name: "servicesListServiceKeys", meth: HttpMethod.HttpPost, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/services/{id}/listkeys",
    validator: validate_ServicesListServiceKeys_574443, base: "",
    url: url_ServicesListServiceKeys_574444, schemes: {Scheme.Https})
type
  Call_ServicesRegenerateServiceKeys_574452 = ref object of OpenApiRestCall_573650
proc url_ServicesRegenerateServiceKeys_574454(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesRegenerateServiceKeys_574453(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate and return the Service keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Service Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574455 = path.getOrDefault("workspace")
  valid_574455 = validateParameter(valid_574455, JString, required = true,
                                 default = nil)
  if valid_574455 != nil:
    section.add "workspace", valid_574455
  var valid_574456 = path.getOrDefault("subscriptionId")
  valid_574456 = validateParameter(valid_574456, JString, required = true,
                                 default = nil)
  if valid_574456 != nil:
    section.add "subscriptionId", valid_574456
  var valid_574457 = path.getOrDefault("resourceGroup")
  valid_574457 = validateParameter(valid_574457, JString, required = true,
                                 default = nil)
  if valid_574457 != nil:
    section.add "resourceGroup", valid_574457
  var valid_574458 = path.getOrDefault("id")
  valid_574458 = validateParameter(valid_574458, JString, required = true,
                                 default = nil)
  if valid_574458 != nil:
    section.add "id", valid_574458
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : The payload that is used to regenerate keys.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574460: Call_ServicesRegenerateServiceKeys_574452; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerate and return the Service keys.
  ## 
  let valid = call_574460.validator(path, query, header, formData, body)
  let scheme = call_574460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574460.url(scheme.get, call_574460.host, call_574460.base,
                         call_574460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574460, url, valid)

proc call*(call_574461: Call_ServicesRegenerateServiceKeys_574452;
          workspace: string; subscriptionId: string; resourceGroup: string;
          id: string; request: JsonNode): Recallable =
  ## servicesRegenerateServiceKeys
  ## Regenerate and return the Service keys.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Service Id.
  ##   request: JObject (required)
  ##          : The payload that is used to regenerate keys.
  var path_574462 = newJObject()
  var body_574463 = newJObject()
  add(path_574462, "workspace", newJString(workspace))
  add(path_574462, "subscriptionId", newJString(subscriptionId))
  add(path_574462, "resourceGroup", newJString(resourceGroup))
  add(path_574462, "id", newJString(id))
  if request != nil:
    body_574463 = request
  result = call_574461.call(path_574462, nil, nil, nil, body_574463)

var servicesRegenerateServiceKeys* = Call_ServicesRegenerateServiceKeys_574452(
    name: "servicesRegenerateServiceKeys", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/services/{id}/regenerateKeys",
    validator: validate_ServicesRegenerateServiceKeys_574453, base: "",
    url: url_ServicesRegenerateServiceKeys_574454, schemes: {Scheme.Https})
type
  Call_ServicesGetServiceToken_574464 = ref object of OpenApiRestCall_573650
proc url_ServicesGetServiceToken_574466(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/token")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesGetServiceToken_574465(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets access token that can be used for calling service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Service Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_574467 = path.getOrDefault("workspace")
  valid_574467 = validateParameter(valid_574467, JString, required = true,
                                 default = nil)
  if valid_574467 != nil:
    section.add "workspace", valid_574467
  var valid_574468 = path.getOrDefault("subscriptionId")
  valid_574468 = validateParameter(valid_574468, JString, required = true,
                                 default = nil)
  if valid_574468 != nil:
    section.add "subscriptionId", valid_574468
  var valid_574469 = path.getOrDefault("resourceGroup")
  valid_574469 = validateParameter(valid_574469, JString, required = true,
                                 default = nil)
  if valid_574469 != nil:
    section.add "resourceGroup", valid_574469
  var valid_574470 = path.getOrDefault("id")
  valid_574470 = validateParameter(valid_574470, JString, required = true,
                                 default = nil)
  if valid_574470 != nil:
    section.add "id", valid_574470
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574471: Call_ServicesGetServiceToken_574464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets access token that can be used for calling service.
  ## 
  let valid = call_574471.validator(path, query, header, formData, body)
  let scheme = call_574471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574471.url(scheme.get, call_574471.host, call_574471.base,
                         call_574471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574471, url, valid)

proc call*(call_574472: Call_ServicesGetServiceToken_574464; workspace: string;
          subscriptionId: string; resourceGroup: string; id: string): Recallable =
  ## servicesGetServiceToken
  ## Gets access token that can be used for calling service.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Service Id.
  var path_574473 = newJObject()
  add(path_574473, "workspace", newJString(workspace))
  add(path_574473, "subscriptionId", newJString(subscriptionId))
  add(path_574473, "resourceGroup", newJString(resourceGroup))
  add(path_574473, "id", newJString(id))
  result = call_574472.call(path_574473, nil, nil, nil, nil)

var servicesGetServiceToken* = Call_ServicesGetServiceToken_574464(
    name: "servicesGetServiceToken", meth: HttpMethod.HttpPost, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/services/{id}/token",
    validator: validate_ServicesGetServiceToken_574465, base: "",
    url: url_ServicesGetServiceToken_574466, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
