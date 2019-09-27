
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Machine Learning Workspaces Management Client
## version: 2016-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## These APIs allow end users to operate on Azure Machine Learning Workspace resources. They support CRUD operations for Azure Machine Learning Workspaces.
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

  OpenApiRestCall_593409 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593409](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593409): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  macServiceName = "machinelearning-workspaces"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593631 = ref object of OpenApiRestCall_593409
proc url_OperationsList_593633(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593632(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Azure Machine Learning Studio REST API operations.
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
  var valid_593792 = query.getOrDefault("api-version")
  valid_593792 = validateParameter(valid_593792, JString, required = true,
                                 default = nil)
  if valid_593792 != nil:
    section.add "api-version", valid_593792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593815: Call_OperationsList_593631; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Azure Machine Learning Studio REST API operations.
  ## 
  let valid = call_593815.validator(path, query, header, formData, body)
  let scheme = call_593815.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593815.url(scheme.get, call_593815.host, call_593815.base,
                         call_593815.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593815, url, valid)

proc call*(call_593886: Call_OperationsList_593631; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Azure Machine Learning Studio REST API operations.
  ##   apiVersion: string (required)
  ##             : The client API version.
  var query_593887 = newJObject()
  add(query_593887, "api-version", newJString(apiVersion))
  result = call_593886.call(nil, query_593887, nil, nil, nil)

var operationsList* = Call_OperationsList_593631(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MachineLearning/operations",
    validator: validate_OperationsList_593632, base: "", url: url_OperationsList_593633,
    schemes: {Scheme.Https})
type
  Call_WorkspacesList_593927 = ref object of OpenApiRestCall_593409
proc url_WorkspacesList_593929(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.MachineLearning/workspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesList_593928(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the available machine learning workspaces under the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593944 = path.getOrDefault("subscriptionId")
  valid_593944 = validateParameter(valid_593944, JString, required = true,
                                 default = nil)
  if valid_593944 != nil:
    section.add "subscriptionId", valid_593944
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593945 = query.getOrDefault("api-version")
  valid_593945 = validateParameter(valid_593945, JString, required = true,
                                 default = nil)
  if valid_593945 != nil:
    section.add "api-version", valid_593945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593946: Call_WorkspacesList_593927; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available machine learning workspaces under the specified subscription.
  ## 
  let valid = call_593946.validator(path, query, header, formData, body)
  let scheme = call_593946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593946.url(scheme.get, call_593946.host, call_593946.base,
                         call_593946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593946, url, valid)

proc call*(call_593947: Call_WorkspacesList_593927; apiVersion: string;
          subscriptionId: string): Recallable =
  ## workspacesList
  ## Lists all the available machine learning workspaces under the specified subscription.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  var path_593948 = newJObject()
  var query_593949 = newJObject()
  add(query_593949, "api-version", newJString(apiVersion))
  add(path_593948, "subscriptionId", newJString(subscriptionId))
  result = call_593947.call(path_593948, query_593949, nil, nil, nil)

var workspacesList* = Call_WorkspacesList_593927(name: "workspacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearning/workspaces",
    validator: validate_WorkspacesList_593928, base: "", url: url_WorkspacesList_593929,
    schemes: {Scheme.Https})
type
  Call_WorkspacesListByResourceGroup_593950 = ref object of OpenApiRestCall_593409
proc url_WorkspacesListByResourceGroup_593952(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.MachineLearning/workspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListByResourceGroup_593951(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available machine learning workspaces under the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning workspace belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593953 = path.getOrDefault("resourceGroupName")
  valid_593953 = validateParameter(valid_593953, JString, required = true,
                                 default = nil)
  if valid_593953 != nil:
    section.add "resourceGroupName", valid_593953
  var valid_593954 = path.getOrDefault("subscriptionId")
  valid_593954 = validateParameter(valid_593954, JString, required = true,
                                 default = nil)
  if valid_593954 != nil:
    section.add "subscriptionId", valid_593954
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593955 = query.getOrDefault("api-version")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "api-version", valid_593955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593956: Call_WorkspacesListByResourceGroup_593950; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available machine learning workspaces under the specified resource group.
  ## 
  let valid = call_593956.validator(path, query, header, formData, body)
  let scheme = call_593956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593956.url(scheme.get, call_593956.host, call_593956.base,
                         call_593956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593956, url, valid)

proc call*(call_593957: Call_WorkspacesListByResourceGroup_593950;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## workspacesListByResourceGroup
  ## Lists all the available machine learning workspaces under the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning workspace belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  var path_593958 = newJObject()
  var query_593959 = newJObject()
  add(path_593958, "resourceGroupName", newJString(resourceGroupName))
  add(query_593959, "api-version", newJString(apiVersion))
  add(path_593958, "subscriptionId", newJString(subscriptionId))
  result = call_593957.call(path_593958, query_593959, nil, nil, nil)

var workspacesListByResourceGroup* = Call_WorkspacesListByResourceGroup_593950(
    name: "workspacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/workspaces",
    validator: validate_WorkspacesListByResourceGroup_593951, base: "",
    url: url_WorkspacesListByResourceGroup_593952, schemes: {Scheme.Https})
type
  Call_WorkspacesCreateOrUpdate_593971 = ref object of OpenApiRestCall_593409
proc url_WorkspacesCreateOrUpdate_593973(protocol: Scheme; host: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesCreateOrUpdate_593972(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a workspace with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning workspace belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the machine learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593974 = path.getOrDefault("resourceGroupName")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "resourceGroupName", valid_593974
  var valid_593975 = path.getOrDefault("subscriptionId")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "subscriptionId", valid_593975
  var valid_593976 = path.getOrDefault("workspaceName")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "workspaceName", valid_593976
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593977 = query.getOrDefault("api-version")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "api-version", valid_593977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for creating or updating a machine learning workspace.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593979: Call_WorkspacesCreateOrUpdate_593971; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a workspace with the specified parameters.
  ## 
  let valid = call_593979.validator(path, query, header, formData, body)
  let scheme = call_593979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593979.url(scheme.get, call_593979.host, call_593979.base,
                         call_593979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593979, url, valid)

proc call*(call_593980: Call_WorkspacesCreateOrUpdate_593971;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; workspaceName: string): Recallable =
  ## workspacesCreateOrUpdate
  ## Creates or updates a workspace with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning workspace belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   parameters: JObject (required)
  ##             : The parameters for creating or updating a machine learning workspace.
  ##   workspaceName: string (required)
  ##                : The name of the machine learning workspace.
  var path_593981 = newJObject()
  var query_593982 = newJObject()
  var body_593983 = newJObject()
  add(path_593981, "resourceGroupName", newJString(resourceGroupName))
  add(query_593982, "api-version", newJString(apiVersion))
  add(path_593981, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593983 = parameters
  add(path_593981, "workspaceName", newJString(workspaceName))
  result = call_593980.call(path_593981, query_593982, nil, nil, body_593983)

var workspacesCreateOrUpdate* = Call_WorkspacesCreateOrUpdate_593971(
    name: "workspacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/workspaces/{workspaceName}",
    validator: validate_WorkspacesCreateOrUpdate_593972, base: "",
    url: url_WorkspacesCreateOrUpdate_593973, schemes: {Scheme.Https})
type
  Call_WorkspacesGet_593960 = ref object of OpenApiRestCall_593409
proc url_WorkspacesGet_593962(protocol: Scheme; host: string; base: string;
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
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesGet_593961(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified machine learning workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning workspace belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the machine learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593963 = path.getOrDefault("resourceGroupName")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "resourceGroupName", valid_593963
  var valid_593964 = path.getOrDefault("subscriptionId")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "subscriptionId", valid_593964
  var valid_593965 = path.getOrDefault("workspaceName")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "workspaceName", valid_593965
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593966 = query.getOrDefault("api-version")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "api-version", valid_593966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593967: Call_WorkspacesGet_593960; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified machine learning workspace.
  ## 
  let valid = call_593967.validator(path, query, header, formData, body)
  let scheme = call_593967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593967.url(scheme.get, call_593967.host, call_593967.base,
                         call_593967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593967, url, valid)

proc call*(call_593968: Call_WorkspacesGet_593960; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesGet
  ## Gets the properties of the specified machine learning workspace.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning workspace belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the machine learning workspace.
  var path_593969 = newJObject()
  var query_593970 = newJObject()
  add(path_593969, "resourceGroupName", newJString(resourceGroupName))
  add(query_593970, "api-version", newJString(apiVersion))
  add(path_593969, "subscriptionId", newJString(subscriptionId))
  add(path_593969, "workspaceName", newJString(workspaceName))
  result = call_593968.call(path_593969, query_593970, nil, nil, nil)

var workspacesGet* = Call_WorkspacesGet_593960(name: "workspacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/workspaces/{workspaceName}",
    validator: validate_WorkspacesGet_593961, base: "", url: url_WorkspacesGet_593962,
    schemes: {Scheme.Https})
type
  Call_WorkspacesUpdate_593995 = ref object of OpenApiRestCall_593409
proc url_WorkspacesUpdate_593997(protocol: Scheme; host: string; base: string;
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
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesUpdate_593996(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a machine learning workspace with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning workspace belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the machine learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594015 = path.getOrDefault("resourceGroupName")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "resourceGroupName", valid_594015
  var valid_594016 = path.getOrDefault("subscriptionId")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "subscriptionId", valid_594016
  var valid_594017 = path.getOrDefault("workspaceName")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "workspaceName", valid_594017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594018 = query.getOrDefault("api-version")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "api-version", valid_594018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for updating a machine learning workspace.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594020: Call_WorkspacesUpdate_593995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a machine learning workspace with the specified parameters.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_WorkspacesUpdate_593995; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          workspaceName: string): Recallable =
  ## workspacesUpdate
  ## Updates a machine learning workspace with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning workspace belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   parameters: JObject (required)
  ##             : The parameters for updating a machine learning workspace.
  ##   workspaceName: string (required)
  ##                : The name of the machine learning workspace.
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  var body_594024 = newJObject()
  add(path_594022, "resourceGroupName", newJString(resourceGroupName))
  add(query_594023, "api-version", newJString(apiVersion))
  add(path_594022, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594024 = parameters
  add(path_594022, "workspaceName", newJString(workspaceName))
  result = call_594021.call(path_594022, query_594023, nil, nil, body_594024)

var workspacesUpdate* = Call_WorkspacesUpdate_593995(name: "workspacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/workspaces/{workspaceName}",
    validator: validate_WorkspacesUpdate_593996, base: "",
    url: url_WorkspacesUpdate_593997, schemes: {Scheme.Https})
type
  Call_WorkspacesDelete_593984 = ref object of OpenApiRestCall_593409
proc url_WorkspacesDelete_593986(protocol: Scheme; host: string; base: string;
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
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesDelete_593985(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a machine learning workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning workspace belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the machine learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593987 = path.getOrDefault("resourceGroupName")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "resourceGroupName", valid_593987
  var valid_593988 = path.getOrDefault("subscriptionId")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "subscriptionId", valid_593988
  var valid_593989 = path.getOrDefault("workspaceName")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "workspaceName", valid_593989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593990 = query.getOrDefault("api-version")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "api-version", valid_593990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593991: Call_WorkspacesDelete_593984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a machine learning workspace.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_WorkspacesDelete_593984; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesDelete
  ## Deletes a machine learning workspace.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning workspace belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the machine learning workspace.
  var path_593993 = newJObject()
  var query_593994 = newJObject()
  add(path_593993, "resourceGroupName", newJString(resourceGroupName))
  add(query_593994, "api-version", newJString(apiVersion))
  add(path_593993, "subscriptionId", newJString(subscriptionId))
  add(path_593993, "workspaceName", newJString(workspaceName))
  result = call_593992.call(path_593993, query_593994, nil, nil, nil)

var workspacesDelete* = Call_WorkspacesDelete_593984(name: "workspacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/workspaces/{workspaceName}",
    validator: validate_WorkspacesDelete_593985, base: "",
    url: url_WorkspacesDelete_593986, schemes: {Scheme.Https})
type
  Call_WorkspacesListWorkspaceKeys_594025 = ref object of OpenApiRestCall_593409
proc url_WorkspacesListWorkspaceKeys_594027(protocol: Scheme; host: string;
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
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/listWorkspaceKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListWorkspaceKeys_594026(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the authorization keys associated with this workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning workspace belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the machine learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594028 = path.getOrDefault("resourceGroupName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "resourceGroupName", valid_594028
  var valid_594029 = path.getOrDefault("subscriptionId")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "subscriptionId", valid_594029
  var valid_594030 = path.getOrDefault("workspaceName")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "workspaceName", valid_594030
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594031 = query.getOrDefault("api-version")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "api-version", valid_594031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594032: Call_WorkspacesListWorkspaceKeys_594025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the authorization keys associated with this workspace.
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_WorkspacesListWorkspaceKeys_594025;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string): Recallable =
  ## workspacesListWorkspaceKeys
  ## List the authorization keys associated with this workspace.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning workspace belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the machine learning workspace.
  var path_594034 = newJObject()
  var query_594035 = newJObject()
  add(path_594034, "resourceGroupName", newJString(resourceGroupName))
  add(query_594035, "api-version", newJString(apiVersion))
  add(path_594034, "subscriptionId", newJString(subscriptionId))
  add(path_594034, "workspaceName", newJString(workspaceName))
  result = call_594033.call(path_594034, query_594035, nil, nil, nil)

var workspacesListWorkspaceKeys* = Call_WorkspacesListWorkspaceKeys_594025(
    name: "workspacesListWorkspaceKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/workspaces/{workspaceName}/listWorkspaceKeys",
    validator: validate_WorkspacesListWorkspaceKeys_594026, base: "",
    url: url_WorkspacesListWorkspaceKeys_594027, schemes: {Scheme.Https})
type
  Call_WorkspacesResyncStorageKeys_594036 = ref object of OpenApiRestCall_593409
proc url_WorkspacesResyncStorageKeys_594038(protocol: Scheme; host: string;
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
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/resyncStorageKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesResyncStorageKeys_594037(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resync storage keys associated with this workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning workspace belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the machine learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594039 = path.getOrDefault("resourceGroupName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "resourceGroupName", valid_594039
  var valid_594040 = path.getOrDefault("subscriptionId")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "subscriptionId", valid_594040
  var valid_594041 = path.getOrDefault("workspaceName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "workspaceName", valid_594041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594042 = query.getOrDefault("api-version")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "api-version", valid_594042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594043: Call_WorkspacesResyncStorageKeys_594036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resync storage keys associated with this workspace.
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_WorkspacesResyncStorageKeys_594036;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string): Recallable =
  ## workspacesResyncStorageKeys
  ## Resync storage keys associated with this workspace.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning workspace belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the machine learning workspace.
  var path_594045 = newJObject()
  var query_594046 = newJObject()
  add(path_594045, "resourceGroupName", newJString(resourceGroupName))
  add(query_594046, "api-version", newJString(apiVersion))
  add(path_594045, "subscriptionId", newJString(subscriptionId))
  add(path_594045, "workspaceName", newJString(workspaceName))
  result = call_594044.call(path_594045, query_594046, nil, nil, nil)

var workspacesResyncStorageKeys* = Call_WorkspacesResyncStorageKeys_594036(
    name: "workspacesResyncStorageKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/workspaces/{workspaceName}/resyncStorageKeys",
    validator: validate_WorkspacesResyncStorageKeys_594037, base: "",
    url: url_WorkspacesResyncStorageKeys_594038, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
