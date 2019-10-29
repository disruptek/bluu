
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
  macServiceName = "machinelearningservices-datastore"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_Create_564110 = ref object of OpenApiRestCall_563555
proc url_Create_564112(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Create_564111(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Datastore in the given workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564113 = path.getOrDefault("subscriptionId")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "subscriptionId", valid_564113
  var valid_564114 = path.getOrDefault("resourceGroupName")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "resourceGroupName", valid_564114
  var valid_564115 = path.getOrDefault("workspaceName")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "workspaceName", valid_564115
  result.add "path", section
  ## parameters in `query` object:
  ##   skipValidation: JBool
  ##                 : If set to true, the call will skip Datastore validation.
  ##   createIfNotExists: JBool
  ##                    : If set to true, the call will create an Datastore if it doesn't exist.
  section = newJObject()
  var valid_564116 = query.getOrDefault("skipValidation")
  valid_564116 = validateParameter(valid_564116, JBool, required = false,
                                 default = newJBool(false))
  if valid_564116 != nil:
    section.add "skipValidation", valid_564116
  var valid_564117 = query.getOrDefault("createIfNotExists")
  valid_564117 = validateParameter(valid_564117, JBool, required = false,
                                 default = newJBool(false))
  if valid_564117 != nil:
    section.add "createIfNotExists", valid_564117
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

proc call*(call_564119: Call_Create_564110; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Datastore in the given workspace.
  ## 
  let valid = call_564119.validator(path, query, header, formData, body)
  let scheme = call_564119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564119.url(scheme.get, call_564119.host, call_564119.base,
                         call_564119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564119, url, valid)

proc call*(call_564120: Call_Create_564110; subscriptionId: string;
          resourceGroupName: string; workspaceName: string;
          skipValidation: bool = false; dto: JsonNode = nil;
          createIfNotExists: bool = false): Recallable =
  ## create
  ## Create or update a Datastore in the given workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   skipValidation: bool
  ##                 : If set to true, the call will skip Datastore validation.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   dto: JObject
  ##      : The Datastore details.
  ##   createIfNotExists: bool
  ##                    : If set to true, the call will create an Datastore if it doesn't exist.
  var path_564121 = newJObject()
  var query_564122 = newJObject()
  var body_564123 = newJObject()
  add(path_564121, "subscriptionId", newJString(subscriptionId))
  add(query_564122, "skipValidation", newJBool(skipValidation))
  add(path_564121, "resourceGroupName", newJString(resourceGroupName))
  add(path_564121, "workspaceName", newJString(workspaceName))
  if dto != nil:
    body_564123 = dto
  add(query_564122, "createIfNotExists", newJBool(createIfNotExists))
  result = call_564120.call(path_564121, query_564122, nil, nil, body_564123)

var create* = Call_Create_564110(name: "create", meth: HttpMethod.HttpPost,
                              host: "azure.local", route: "/datastore/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/datastores",
                              validator: validate_Create_564111, base: "",
                              url: url_Create_564112, schemes: {Scheme.Https})
type
  Call_List_563777 = ref object of OpenApiRestCall_563555
proc url_List_563779(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_List_563778(path: JsonNode; query: JsonNode; header: JsonNode;
                         formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of Datastores attached to the workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563954 = path.getOrDefault("subscriptionId")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = nil)
  if valid_563954 != nil:
    section.add "subscriptionId", valid_563954
  var valid_563955 = path.getOrDefault("resourceGroupName")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "resourceGroupName", valid_563955
  var valid_563956 = path.getOrDefault("workspaceName")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "workspaceName", valid_563956
  result.add "path", section
  ## parameters in `query` object:
  ##   dataStoreNames: JArray
  ##                 : List of Datastore names.
  ##   count: JInt
  ##        : Count of Datastores to be returned.
  ##   continuationToken: JString
  ##                    : The Continuation Token.
  ##   includeSecret: JBool
  ##                : Whether to include the datastore secret in the response.
  section = newJObject()
  var valid_563957 = query.getOrDefault("dataStoreNames")
  valid_563957 = validateParameter(valid_563957, JArray, required = false,
                                 default = nil)
  if valid_563957 != nil:
    section.add "dataStoreNames", valid_563957
  var valid_563972 = query.getOrDefault("count")
  valid_563972 = validateParameter(valid_563972, JInt, required = false,
                                 default = newJInt(30))
  if valid_563972 != nil:
    section.add "count", valid_563972
  var valid_563973 = query.getOrDefault("continuationToken")
  valid_563973 = validateParameter(valid_563973, JString, required = false,
                                 default = nil)
  if valid_563973 != nil:
    section.add "continuationToken", valid_563973
  var valid_563974 = query.getOrDefault("includeSecret")
  valid_563974 = validateParameter(valid_563974, JBool, required = false,
                                 default = newJBool(true))
  if valid_563974 != nil:
    section.add "includeSecret", valid_563974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563997: Call_List_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of Datastores attached to the workspace.
  ## 
  let valid = call_563997.validator(path, query, header, formData, body)
  let scheme = call_563997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563997.url(scheme.get, call_563997.host, call_563997.base,
                         call_563997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563997, url, valid)

proc call*(call_564068: Call_List_563777; subscriptionId: string;
          resourceGroupName: string; workspaceName: string;
          dataStoreNames: JsonNode = nil; count: int = 30;
          continuationToken: string = ""; includeSecret: bool = true): Recallable =
  ## list
  ## Get the list of Datastores attached to the workspace.
  ##   dataStoreNames: JArray
  ##                 : List of Datastore names.
  ##   count: int
  ##        : Count of Datastores to be returned.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   continuationToken: string
  ##                    : The Continuation Token.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   includeSecret: bool
  ##                : Whether to include the datastore secret in the response.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564069 = newJObject()
  var query_564071 = newJObject()
  if dataStoreNames != nil:
    query_564071.add "dataStoreNames", dataStoreNames
  add(query_564071, "count", newJInt(count))
  add(path_564069, "subscriptionId", newJString(subscriptionId))
  add(query_564071, "continuationToken", newJString(continuationToken))
  add(path_564069, "resourceGroupName", newJString(resourceGroupName))
  add(query_564071, "includeSecret", newJBool(includeSecret))
  add(path_564069, "workspaceName", newJString(workspaceName))
  result = call_564068.call(path_564069, query_564071, nil, nil, nil)

var list* = Call_List_563777(name: "list", meth: HttpMethod.HttpGet,
                          host: "azure.local", route: "/datastore/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/datastores",
                          validator: validate_List_563778, base: "", url: url_List_563779,
                          schemes: {Scheme.Https})
type
  Call_DeleteAll_564124 = ref object of OpenApiRestCall_563555
proc url_DeleteAll_564126(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DeleteAll_564125(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete all Datastores in the workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564127 = path.getOrDefault("subscriptionId")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "subscriptionId", valid_564127
  var valid_564128 = path.getOrDefault("resourceGroupName")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "resourceGroupName", valid_564128
  var valid_564129 = path.getOrDefault("workspaceName")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "workspaceName", valid_564129
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564130: Call_DeleteAll_564124; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete all Datastores in the workspace.
  ## 
  let valid = call_564130.validator(path, query, header, formData, body)
  let scheme = call_564130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564130.url(scheme.get, call_564130.host, call_564130.base,
                         call_564130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564130, url, valid)

proc call*(call_564131: Call_DeleteAll_564124; subscriptionId: string;
          resourceGroupName: string; workspaceName: string): Recallable =
  ## deleteAll
  ## Delete all Datastores in the workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564132 = newJObject()
  add(path_564132, "subscriptionId", newJString(subscriptionId))
  add(path_564132, "resourceGroupName", newJString(resourceGroupName))
  add(path_564132, "workspaceName", newJString(workspaceName))
  result = call_564131.call(path_564132, nil, nil, nil, nil)

var deleteAll* = Call_DeleteAll_564124(name: "deleteAll",
                                    meth: HttpMethod.HttpDelete,
                                    host: "azure.local", route: "/datastore/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/datastores",
                                    validator: validate_DeleteAll_564125,
                                    base: "", url: url_DeleteAll_564126,
                                    schemes: {Scheme.Https})
type
  Call_Update_564143 = ref object of OpenApiRestCall_563555
proc url_Update_564145(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Update_564144(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Update or create a Datastore in the given workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The Datastore name.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564146 = path.getOrDefault("name")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "name", valid_564146
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
  var valid_564149 = path.getOrDefault("workspaceName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "workspaceName", valid_564149
  result.add "path", section
  ## parameters in `query` object:
  ##   skipValidation: JBool
  ##                 : If set to true, the call will skip Datastore validation.
  ##   createIfNotExists: JBool
  ##                    : If set to true, the call will create an Datastore if it doesn't exist.
  section = newJObject()
  var valid_564150 = query.getOrDefault("skipValidation")
  valid_564150 = validateParameter(valid_564150, JBool, required = false,
                                 default = newJBool(false))
  if valid_564150 != nil:
    section.add "skipValidation", valid_564150
  var valid_564151 = query.getOrDefault("createIfNotExists")
  valid_564151 = validateParameter(valid_564151, JBool, required = false,
                                 default = newJBool(false))
  if valid_564151 != nil:
    section.add "createIfNotExists", valid_564151
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

proc call*(call_564153: Call_Update_564143; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update or create a Datastore in the given workspace.
  ## 
  let valid = call_564153.validator(path, query, header, formData, body)
  let scheme = call_564153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564153.url(scheme.get, call_564153.host, call_564153.base,
                         call_564153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564153, url, valid)

proc call*(call_564154: Call_Update_564143; name: string; subscriptionId: string;
          resourceGroupName: string; workspaceName: string;
          skipValidation: bool = false; dto: JsonNode = nil;
          createIfNotExists: bool = false): Recallable =
  ## update
  ## Update or create a Datastore in the given workspace.
  ##   name: string (required)
  ##       : The Datastore name.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   skipValidation: bool
  ##                 : If set to true, the call will skip Datastore validation.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   dto: JObject
  ##      : The Datastore details.
  ##   createIfNotExists: bool
  ##                    : If set to true, the call will create an Datastore if it doesn't exist.
  var path_564155 = newJObject()
  var query_564156 = newJObject()
  var body_564157 = newJObject()
  add(path_564155, "name", newJString(name))
  add(path_564155, "subscriptionId", newJString(subscriptionId))
  add(query_564156, "skipValidation", newJBool(skipValidation))
  add(path_564155, "resourceGroupName", newJString(resourceGroupName))
  add(path_564155, "workspaceName", newJString(workspaceName))
  if dto != nil:
    body_564157 = dto
  add(query_564156, "createIfNotExists", newJBool(createIfNotExists))
  result = call_564154.call(path_564155, query_564156, nil, nil, body_564157)

var update* = Call_Update_564143(name: "update", meth: HttpMethod.HttpPut,
                              host: "azure.local", route: "/datastore/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/datastores/{name}",
                              validator: validate_Update_564144, base: "",
                              url: url_Update_564145, schemes: {Scheme.Https})
type
  Call_Get_564133 = ref object of OpenApiRestCall_563555
proc url_Get_564135(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Get_564134(path: JsonNode; query: JsonNode; header: JsonNode;
                        formData: JsonNode; body: JsonNode): JsonNode =
  ## Get details of a Datastore with a specific name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The Datastore name.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564136 = path.getOrDefault("name")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "name", valid_564136
  var valid_564137 = path.getOrDefault("subscriptionId")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "subscriptionId", valid_564137
  var valid_564138 = path.getOrDefault("resourceGroupName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "resourceGroupName", valid_564138
  var valid_564139 = path.getOrDefault("workspaceName")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "workspaceName", valid_564139
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564140: Call_Get_564133; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of a Datastore with a specific name.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_Get_564133; name: string; subscriptionId: string;
          resourceGroupName: string; workspaceName: string): Recallable =
  ## get
  ## Get details of a Datastore with a specific name.
  ##   name: string (required)
  ##       : The Datastore name.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564142 = newJObject()
  add(path_564142, "name", newJString(name))
  add(path_564142, "subscriptionId", newJString(subscriptionId))
  add(path_564142, "resourceGroupName", newJString(resourceGroupName))
  add(path_564142, "workspaceName", newJString(workspaceName))
  result = call_564141.call(path_564142, nil, nil, nil, nil)

var get* = Call_Get_564133(name: "get", meth: HttpMethod.HttpGet, host: "azure.local", route: "/datastore/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/datastores/{name}",
                        validator: validate_Get_564134, base: "", url: url_Get_564135,
                        schemes: {Scheme.Https})
type
  Call_Delete_564158 = ref object of OpenApiRestCall_563555
proc url_Delete_564160(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Delete_564159(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Datastore with a specific name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The Datastore name.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564161 = path.getOrDefault("name")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "name", valid_564161
  var valid_564162 = path.getOrDefault("subscriptionId")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "subscriptionId", valid_564162
  var valid_564163 = path.getOrDefault("resourceGroupName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "resourceGroupName", valid_564163
  var valid_564164 = path.getOrDefault("workspaceName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "workspaceName", valid_564164
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564165: Call_Delete_564158; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Datastore with a specific name.
  ## 
  let valid = call_564165.validator(path, query, header, formData, body)
  let scheme = call_564165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564165.url(scheme.get, call_564165.host, call_564165.base,
                         call_564165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564165, url, valid)

proc call*(call_564166: Call_Delete_564158; name: string; subscriptionId: string;
          resourceGroupName: string; workspaceName: string): Recallable =
  ## delete
  ## Delete a Datastore with a specific name.
  ##   name: string (required)
  ##       : The Datastore name.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564167 = newJObject()
  add(path_564167, "name", newJString(name))
  add(path_564167, "subscriptionId", newJString(subscriptionId))
  add(path_564167, "resourceGroupName", newJString(resourceGroupName))
  add(path_564167, "workspaceName", newJString(workspaceName))
  result = call_564166.call(path_564167, nil, nil, nil, nil)

var delete* = Call_Delete_564158(name: "delete", meth: HttpMethod.HttpDelete,
                              host: "azure.local", route: "/datastore/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/datastores/{name}",
                              validator: validate_Delete_564159, base: "",
                              url: url_Delete_564160, schemes: {Scheme.Https})
type
  Call_GetDefault_564168 = ref object of OpenApiRestCall_563555
proc url_GetDefault_564170(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetDefault_564169(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the default Datastore in the workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564171 = path.getOrDefault("subscriptionId")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "subscriptionId", valid_564171
  var valid_564172 = path.getOrDefault("resourceGroupName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "resourceGroupName", valid_564172
  var valid_564173 = path.getOrDefault("workspaceName")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "workspaceName", valid_564173
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564174: Call_GetDefault_564168; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the default Datastore in the workspace.
  ## 
  let valid = call_564174.validator(path, query, header, formData, body)
  let scheme = call_564174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564174.url(scheme.get, call_564174.host, call_564174.base,
                         call_564174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564174, url, valid)

proc call*(call_564175: Call_GetDefault_564168; subscriptionId: string;
          resourceGroupName: string; workspaceName: string): Recallable =
  ## getDefault
  ## Get the default Datastore in the workspace.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564176 = newJObject()
  add(path_564176, "subscriptionId", newJString(subscriptionId))
  add(path_564176, "resourceGroupName", newJString(resourceGroupName))
  add(path_564176, "workspaceName", newJString(workspaceName))
  result = call_564175.call(path_564176, nil, nil, nil, nil)

var getDefault* = Call_GetDefault_564168(name: "getDefault",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local", route: "/datastore/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/default",
                                      validator: validate_GetDefault_564169,
                                      base: "", url: url_GetDefault_564170,
                                      schemes: {Scheme.Https})
type
  Call_SetDefault_564177 = ref object of OpenApiRestCall_563555
proc url_SetDefault_564179(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SetDefault_564178(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Set a default Datastore in the workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The Datastore name.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564180 = path.getOrDefault("name")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "name", valid_564180
  var valid_564181 = path.getOrDefault("subscriptionId")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "subscriptionId", valid_564181
  var valid_564182 = path.getOrDefault("resourceGroupName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "resourceGroupName", valid_564182
  var valid_564183 = path.getOrDefault("workspaceName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "workspaceName", valid_564183
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564184: Call_SetDefault_564177; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set a default Datastore in the workspace.
  ## 
  let valid = call_564184.validator(path, query, header, formData, body)
  let scheme = call_564184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564184.url(scheme.get, call_564184.host, call_564184.base,
                         call_564184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564184, url, valid)

proc call*(call_564185: Call_SetDefault_564177; name: string; subscriptionId: string;
          resourceGroupName: string; workspaceName: string): Recallable =
  ## setDefault
  ## Set a default Datastore in the workspace.
  ##   name: string (required)
  ##       : The Datastore name.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564186 = newJObject()
  add(path_564186, "name", newJString(name))
  add(path_564186, "subscriptionId", newJString(subscriptionId))
  add(path_564186, "resourceGroupName", newJString(resourceGroupName))
  add(path_564186, "workspaceName", newJString(workspaceName))
  result = call_564185.call(path_564186, nil, nil, nil, nil)

var setDefault* = Call_SetDefault_564177(name: "setDefault",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local", route: "/datastore/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/default/{name}",
                                      validator: validate_SetDefault_564178,
                                      base: "", url: url_SetDefault_564179,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
