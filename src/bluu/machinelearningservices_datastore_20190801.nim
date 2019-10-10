
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Machine Learning Datastore Management Client
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "machinelearningservices-datastore"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_Create_574210 = ref object of OpenApiRestCall_573657
proc url_Create_574212(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/datastore/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/datastores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Create_574211(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Datastore in the given workspace.
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
  var valid_574213 = path.getOrDefault("resourceGroupName")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "resourceGroupName", valid_574213
  var valid_574214 = path.getOrDefault("subscriptionId")
  valid_574214 = validateParameter(valid_574214, JString, required = true,
                                 default = nil)
  if valid_574214 != nil:
    section.add "subscriptionId", valid_574214
  var valid_574215 = path.getOrDefault("workspaceName")
  valid_574215 = validateParameter(valid_574215, JString, required = true,
                                 default = nil)
  if valid_574215 != nil:
    section.add "workspaceName", valid_574215
  result.add "path", section
  ## parameters in `query` object:
  ##   skipValidation: JBool
  ##                 : If set to true, the call will skip Datastore validation.
  ##   createIfNotExists: JBool
  ##                    : If set to true, the call will create an Datastore if it doesn't exist.
  section = newJObject()
  var valid_574216 = query.getOrDefault("skipValidation")
  valid_574216 = validateParameter(valid_574216, JBool, required = false,
                                 default = newJBool(false))
  if valid_574216 != nil:
    section.add "skipValidation", valid_574216
  var valid_574217 = query.getOrDefault("createIfNotExists")
  valid_574217 = validateParameter(valid_574217, JBool, required = false,
                                 default = newJBool(false))
  if valid_574217 != nil:
    section.add "createIfNotExists", valid_574217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dto: JObject
  ##      : The Datastore details.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574219: Call_Create_574210; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Datastore in the given workspace.
  ## 
  let valid = call_574219.validator(path, query, header, formData, body)
  let scheme = call_574219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574219.url(scheme.get, call_574219.host, call_574219.base,
                         call_574219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574219, url, valid)

proc call*(call_574220: Call_Create_574210; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          skipValidation: bool = false; dto: JsonNode = nil;
          createIfNotExists: bool = false): Recallable =
  ## create
  ## Create or update a Datastore in the given workspace.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   skipValidation: bool
  ##                 : If set to true, the call will skip Datastore validation.
  ##   dto: JObject
  ##      : The Datastore details.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   createIfNotExists: bool
  ##                    : If set to true, the call will create an Datastore if it doesn't exist.
  var path_574221 = newJObject()
  var query_574222 = newJObject()
  var body_574223 = newJObject()
  add(path_574221, "resourceGroupName", newJString(resourceGroupName))
  add(path_574221, "subscriptionId", newJString(subscriptionId))
  add(query_574222, "skipValidation", newJBool(skipValidation))
  if dto != nil:
    body_574223 = dto
  add(path_574221, "workspaceName", newJString(workspaceName))
  add(query_574222, "createIfNotExists", newJBool(createIfNotExists))
  result = call_574220.call(path_574221, query_574222, nil, nil, body_574223)

var create* = Call_Create_574210(name: "create", meth: HttpMethod.HttpPost,
                              host: "azure.local", route: "/datastore/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/datastores",
                              validator: validate_Create_574211, base: "",
                              url: url_Create_574212, schemes: {Scheme.Https})
type
  Call_List_573879 = ref object of OpenApiRestCall_573657
proc url_List_573881(protocol: Scheme; host: string; base: string; route: string;
                    path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/datastore/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/datastores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_List_573880(path: JsonNode; query: JsonNode; header: JsonNode;
                         formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of Datastores attached to the workspace.
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
  var valid_574054 = path.getOrDefault("resourceGroupName")
  valid_574054 = validateParameter(valid_574054, JString, required = true,
                                 default = nil)
  if valid_574054 != nil:
    section.add "resourceGroupName", valid_574054
  var valid_574055 = path.getOrDefault("subscriptionId")
  valid_574055 = validateParameter(valid_574055, JString, required = true,
                                 default = nil)
  if valid_574055 != nil:
    section.add "subscriptionId", valid_574055
  var valid_574056 = path.getOrDefault("workspaceName")
  valid_574056 = validateParameter(valid_574056, JString, required = true,
                                 default = nil)
  if valid_574056 != nil:
    section.add "workspaceName", valid_574056
  result.add "path", section
  ## parameters in `query` object:
  ##   includeSecret: JBool
  ##                : Whether to include the datastore secret in the response.
  ##   dataStoreNames: JArray
  ##                 : List of Datastore names.
  ##   continuationToken: JString
  ##                    : The Continuation Token.
  ##   count: JInt
  ##        : Count of Datastores to be returned.
  section = newJObject()
  var valid_574070 = query.getOrDefault("includeSecret")
  valid_574070 = validateParameter(valid_574070, JBool, required = false,
                                 default = newJBool(true))
  if valid_574070 != nil:
    section.add "includeSecret", valid_574070
  var valid_574071 = query.getOrDefault("dataStoreNames")
  valid_574071 = validateParameter(valid_574071, JArray, required = false,
                                 default = nil)
  if valid_574071 != nil:
    section.add "dataStoreNames", valid_574071
  var valid_574072 = query.getOrDefault("continuationToken")
  valid_574072 = validateParameter(valid_574072, JString, required = false,
                                 default = nil)
  if valid_574072 != nil:
    section.add "continuationToken", valid_574072
  var valid_574074 = query.getOrDefault("count")
  valid_574074 = validateParameter(valid_574074, JInt, required = false,
                                 default = newJInt(30))
  if valid_574074 != nil:
    section.add "count", valid_574074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574097: Call_List_573879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of Datastores attached to the workspace.
  ## 
  let valid = call_574097.validator(path, query, header, formData, body)
  let scheme = call_574097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574097.url(scheme.get, call_574097.host, call_574097.base,
                         call_574097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574097, url, valid)

proc call*(call_574168: Call_List_573879; resourceGroupName: string;
          subscriptionId: string; workspaceName: string; includeSecret: bool = true;
          dataStoreNames: JsonNode = nil; continuationToken: string = "";
          count: int = 30): Recallable =
  ## list
  ## Get the list of Datastores attached to the workspace.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   includeSecret: bool
  ##                : Whether to include the datastore secret in the response.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   dataStoreNames: JArray
  ##                 : List of Datastore names.
  ##   continuationToken: string
  ##                    : The Continuation Token.
  ##   count: int
  ##        : Count of Datastores to be returned.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574169 = newJObject()
  var query_574171 = newJObject()
  add(path_574169, "resourceGroupName", newJString(resourceGroupName))
  add(query_574171, "includeSecret", newJBool(includeSecret))
  add(path_574169, "subscriptionId", newJString(subscriptionId))
  if dataStoreNames != nil:
    query_574171.add "dataStoreNames", dataStoreNames
  add(query_574171, "continuationToken", newJString(continuationToken))
  add(query_574171, "count", newJInt(count))
  add(path_574169, "workspaceName", newJString(workspaceName))
  result = call_574168.call(path_574169, query_574171, nil, nil, nil)

var list* = Call_List_573879(name: "list", meth: HttpMethod.HttpGet,
                          host: "azure.local", route: "/datastore/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/datastores",
                          validator: validate_List_573880, base: "", url: url_List_573881,
                          schemes: {Scheme.Https})
type
  Call_DeleteAll_574224 = ref object of OpenApiRestCall_573657
proc url_DeleteAll_574226(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/datastore/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/datastores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeleteAll_574225(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete all Datastores in the workspace.
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
  var valid_574227 = path.getOrDefault("resourceGroupName")
  valid_574227 = validateParameter(valid_574227, JString, required = true,
                                 default = nil)
  if valid_574227 != nil:
    section.add "resourceGroupName", valid_574227
  var valid_574228 = path.getOrDefault("subscriptionId")
  valid_574228 = validateParameter(valid_574228, JString, required = true,
                                 default = nil)
  if valid_574228 != nil:
    section.add "subscriptionId", valid_574228
  var valid_574229 = path.getOrDefault("workspaceName")
  valid_574229 = validateParameter(valid_574229, JString, required = true,
                                 default = nil)
  if valid_574229 != nil:
    section.add "workspaceName", valid_574229
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574230: Call_DeleteAll_574224; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete all Datastores in the workspace.
  ## 
  let valid = call_574230.validator(path, query, header, formData, body)
  let scheme = call_574230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574230.url(scheme.get, call_574230.host, call_574230.base,
                         call_574230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574230, url, valid)

proc call*(call_574231: Call_DeleteAll_574224; resourceGroupName: string;
          subscriptionId: string; workspaceName: string): Recallable =
  ## deleteAll
  ## Delete all Datastores in the workspace.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574232 = newJObject()
  add(path_574232, "resourceGroupName", newJString(resourceGroupName))
  add(path_574232, "subscriptionId", newJString(subscriptionId))
  add(path_574232, "workspaceName", newJString(workspaceName))
  result = call_574231.call(path_574232, nil, nil, nil, nil)

var deleteAll* = Call_DeleteAll_574224(name: "deleteAll",
                                    meth: HttpMethod.HttpDelete,
                                    host: "azure.local", route: "/datastore/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/datastores",
                                    validator: validate_DeleteAll_574225,
                                    base: "", url: url_DeleteAll_574226,
                                    schemes: {Scheme.Https})
type
  Call_Update_574243 = ref object of OpenApiRestCall_573657
proc url_Update_574245(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/datastore/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/datastores/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Update_574244(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Update or create a Datastore in the given workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   name: JString (required)
  ##       : The Datastore name.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574246 = path.getOrDefault("resourceGroupName")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "resourceGroupName", valid_574246
  var valid_574247 = path.getOrDefault("name")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "name", valid_574247
  var valid_574248 = path.getOrDefault("subscriptionId")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "subscriptionId", valid_574248
  var valid_574249 = path.getOrDefault("workspaceName")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "workspaceName", valid_574249
  result.add "path", section
  ## parameters in `query` object:
  ##   skipValidation: JBool
  ##                 : If set to true, the call will skip Datastore validation.
  ##   createIfNotExists: JBool
  ##                    : If set to true, the call will create an Datastore if it doesn't exist.
  section = newJObject()
  var valid_574250 = query.getOrDefault("skipValidation")
  valid_574250 = validateParameter(valid_574250, JBool, required = false,
                                 default = newJBool(false))
  if valid_574250 != nil:
    section.add "skipValidation", valid_574250
  var valid_574251 = query.getOrDefault("createIfNotExists")
  valid_574251 = validateParameter(valid_574251, JBool, required = false,
                                 default = newJBool(false))
  if valid_574251 != nil:
    section.add "createIfNotExists", valid_574251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dto: JObject
  ##      : The Datastore details.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574253: Call_Update_574243; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update or create a Datastore in the given workspace.
  ## 
  let valid = call_574253.validator(path, query, header, formData, body)
  let scheme = call_574253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574253.url(scheme.get, call_574253.host, call_574253.base,
                         call_574253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574253, url, valid)

proc call*(call_574254: Call_Update_574243; resourceGroupName: string; name: string;
          subscriptionId: string; workspaceName: string;
          skipValidation: bool = false; dto: JsonNode = nil;
          createIfNotExists: bool = false): Recallable =
  ## update
  ## Update or create a Datastore in the given workspace.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   name: string (required)
  ##       : The Datastore name.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   skipValidation: bool
  ##                 : If set to true, the call will skip Datastore validation.
  ##   dto: JObject
  ##      : The Datastore details.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   createIfNotExists: bool
  ##                    : If set to true, the call will create an Datastore if it doesn't exist.
  var path_574255 = newJObject()
  var query_574256 = newJObject()
  var body_574257 = newJObject()
  add(path_574255, "resourceGroupName", newJString(resourceGroupName))
  add(path_574255, "name", newJString(name))
  add(path_574255, "subscriptionId", newJString(subscriptionId))
  add(query_574256, "skipValidation", newJBool(skipValidation))
  if dto != nil:
    body_574257 = dto
  add(path_574255, "workspaceName", newJString(workspaceName))
  add(query_574256, "createIfNotExists", newJBool(createIfNotExists))
  result = call_574254.call(path_574255, query_574256, nil, nil, body_574257)

var update* = Call_Update_574243(name: "update", meth: HttpMethod.HttpPut,
                              host: "azure.local", route: "/datastore/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/datastores/{name}",
                              validator: validate_Update_574244, base: "",
                              url: url_Update_574245, schemes: {Scheme.Https})
type
  Call_Get_574233 = ref object of OpenApiRestCall_573657
proc url_Get_574235(protocol: Scheme; host: string; base: string; route: string;
                   path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/datastore/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/datastores/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Get_574234(path: JsonNode; query: JsonNode; header: JsonNode;
                        formData: JsonNode; body: JsonNode): JsonNode =
  ## Get details of a Datastore with a specific name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   name: JString (required)
  ##       : The Datastore name.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574236 = path.getOrDefault("resourceGroupName")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "resourceGroupName", valid_574236
  var valid_574237 = path.getOrDefault("name")
  valid_574237 = validateParameter(valid_574237, JString, required = true,
                                 default = nil)
  if valid_574237 != nil:
    section.add "name", valid_574237
  var valid_574238 = path.getOrDefault("subscriptionId")
  valid_574238 = validateParameter(valid_574238, JString, required = true,
                                 default = nil)
  if valid_574238 != nil:
    section.add "subscriptionId", valid_574238
  var valid_574239 = path.getOrDefault("workspaceName")
  valid_574239 = validateParameter(valid_574239, JString, required = true,
                                 default = nil)
  if valid_574239 != nil:
    section.add "workspaceName", valid_574239
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574240: Call_Get_574233; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of a Datastore with a specific name.
  ## 
  let valid = call_574240.validator(path, query, header, formData, body)
  let scheme = call_574240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574240.url(scheme.get, call_574240.host, call_574240.base,
                         call_574240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574240, url, valid)

proc call*(call_574241: Call_Get_574233; resourceGroupName: string; name: string;
          subscriptionId: string; workspaceName: string): Recallable =
  ## get
  ## Get details of a Datastore with a specific name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   name: string (required)
  ##       : The Datastore name.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574242 = newJObject()
  add(path_574242, "resourceGroupName", newJString(resourceGroupName))
  add(path_574242, "name", newJString(name))
  add(path_574242, "subscriptionId", newJString(subscriptionId))
  add(path_574242, "workspaceName", newJString(workspaceName))
  result = call_574241.call(path_574242, nil, nil, nil, nil)

var get* = Call_Get_574233(name: "get", meth: HttpMethod.HttpGet, host: "azure.local", route: "/datastore/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/datastores/{name}",
                        validator: validate_Get_574234, base: "", url: url_Get_574235,
                        schemes: {Scheme.Https})
type
  Call_Delete_574258 = ref object of OpenApiRestCall_573657
proc url_Delete_574260(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/datastore/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/datastores/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Delete_574259(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Datastore with a specific name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   name: JString (required)
  ##       : The Datastore name.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574261 = path.getOrDefault("resourceGroupName")
  valid_574261 = validateParameter(valid_574261, JString, required = true,
                                 default = nil)
  if valid_574261 != nil:
    section.add "resourceGroupName", valid_574261
  var valid_574262 = path.getOrDefault("name")
  valid_574262 = validateParameter(valid_574262, JString, required = true,
                                 default = nil)
  if valid_574262 != nil:
    section.add "name", valid_574262
  var valid_574263 = path.getOrDefault("subscriptionId")
  valid_574263 = validateParameter(valid_574263, JString, required = true,
                                 default = nil)
  if valid_574263 != nil:
    section.add "subscriptionId", valid_574263
  var valid_574264 = path.getOrDefault("workspaceName")
  valid_574264 = validateParameter(valid_574264, JString, required = true,
                                 default = nil)
  if valid_574264 != nil:
    section.add "workspaceName", valid_574264
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574265: Call_Delete_574258; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Datastore with a specific name.
  ## 
  let valid = call_574265.validator(path, query, header, formData, body)
  let scheme = call_574265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574265.url(scheme.get, call_574265.host, call_574265.base,
                         call_574265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574265, url, valid)

proc call*(call_574266: Call_Delete_574258; resourceGroupName: string; name: string;
          subscriptionId: string; workspaceName: string): Recallable =
  ## delete
  ## Delete a Datastore with a specific name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   name: string (required)
  ##       : The Datastore name.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574267 = newJObject()
  add(path_574267, "resourceGroupName", newJString(resourceGroupName))
  add(path_574267, "name", newJString(name))
  add(path_574267, "subscriptionId", newJString(subscriptionId))
  add(path_574267, "workspaceName", newJString(workspaceName))
  result = call_574266.call(path_574267, nil, nil, nil, nil)

var delete* = Call_Delete_574258(name: "delete", meth: HttpMethod.HttpDelete,
                              host: "azure.local", route: "/datastore/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/datastores/{name}",
                              validator: validate_Delete_574259, base: "",
                              url: url_Delete_574260, schemes: {Scheme.Https})
type
  Call_GetDefault_574268 = ref object of OpenApiRestCall_573657
proc url_GetDefault_574270(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/datastore/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDefault_574269(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the default Datastore in the workspace.
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
  var valid_574271 = path.getOrDefault("resourceGroupName")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "resourceGroupName", valid_574271
  var valid_574272 = path.getOrDefault("subscriptionId")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "subscriptionId", valid_574272
  var valid_574273 = path.getOrDefault("workspaceName")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "workspaceName", valid_574273
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574274: Call_GetDefault_574268; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the default Datastore in the workspace.
  ## 
  let valid = call_574274.validator(path, query, header, formData, body)
  let scheme = call_574274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574274.url(scheme.get, call_574274.host, call_574274.base,
                         call_574274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574274, url, valid)

proc call*(call_574275: Call_GetDefault_574268; resourceGroupName: string;
          subscriptionId: string; workspaceName: string): Recallable =
  ## getDefault
  ## Get the default Datastore in the workspace.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574276 = newJObject()
  add(path_574276, "resourceGroupName", newJString(resourceGroupName))
  add(path_574276, "subscriptionId", newJString(subscriptionId))
  add(path_574276, "workspaceName", newJString(workspaceName))
  result = call_574275.call(path_574276, nil, nil, nil, nil)

var getDefault* = Call_GetDefault_574268(name: "getDefault",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local", route: "/datastore/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/default",
                                      validator: validate_GetDefault_574269,
                                      base: "", url: url_GetDefault_574270,
                                      schemes: {Scheme.Https})
type
  Call_SetDefault_574277 = ref object of OpenApiRestCall_573657
proc url_SetDefault_574279(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/datastore/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/default/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SetDefault_574278(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Set a default Datastore in the workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   name: JString (required)
  ##       : The Datastore name.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574280 = path.getOrDefault("resourceGroupName")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "resourceGroupName", valid_574280
  var valid_574281 = path.getOrDefault("name")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "name", valid_574281
  var valid_574282 = path.getOrDefault("subscriptionId")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "subscriptionId", valid_574282
  var valid_574283 = path.getOrDefault("workspaceName")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "workspaceName", valid_574283
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574284: Call_SetDefault_574277; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set a default Datastore in the workspace.
  ## 
  let valid = call_574284.validator(path, query, header, formData, body)
  let scheme = call_574284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574284.url(scheme.get, call_574284.host, call_574284.base,
                         call_574284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574284, url, valid)

proc call*(call_574285: Call_SetDefault_574277; resourceGroupName: string;
          name: string; subscriptionId: string; workspaceName: string): Recallable =
  ## setDefault
  ## Set a default Datastore in the workspace.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   name: string (required)
  ##       : The Datastore name.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574286 = newJObject()
  add(path_574286, "resourceGroupName", newJString(resourceGroupName))
  add(path_574286, "name", newJString(name))
  add(path_574286, "subscriptionId", newJString(subscriptionId))
  add(path_574286, "workspaceName", newJString(workspaceName))
  result = call_574285.call(path_574286, nil, nil, nil, nil)

var setDefault* = Call_SetDefault_574277(name: "setDefault",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local", route: "/datastore/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/default/{name}",
                                      validator: validate_SetDefault_574278,
                                      base: "", url: url_SetDefault_574279,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
