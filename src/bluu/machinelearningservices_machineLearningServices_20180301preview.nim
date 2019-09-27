
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Machine Learning Workspaces
## version: 2018-03-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## These APIs allow end users to operate on Azure Machine Learning Workspace resources.
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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "machinelearningservices-machineLearningServices"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593647 = ref object of OpenApiRestCall_593425
proc url_OperationsList_593649(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593648(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Azure Machine Learning Workspaces REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593808 = query.getOrDefault("api-version")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "api-version", valid_593808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593831: Call_OperationsList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Azure Machine Learning Workspaces REST API operations.
  ## 
  let valid = call_593831.validator(path, query, header, formData, body)
  let scheme = call_593831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593831.url(scheme.get, call_593831.host, call_593831.base,
                         call_593831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593831, url, valid)

proc call*(call_593902: Call_OperationsList_593647; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Azure Machine Learning Workspaces REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  var query_593903 = newJObject()
  add(query_593903, "api-version", newJString(apiVersion))
  result = call_593902.call(nil, query_593903, nil, nil, nil)

var operationsList* = Call_OperationsList_593647(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MachineLearningServices/operations",
    validator: validate_OperationsList_593648, base: "", url: url_OperationsList_593649,
    schemes: {Scheme.Https})
type
  Call_WorkspacesListBySubscription_593943 = ref object of OpenApiRestCall_593425
proc url_WorkspacesListBySubscription_593945(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.MachineLearningServices/workspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListBySubscription_593944(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available machine learning workspaces under the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593961 = path.getOrDefault("subscriptionId")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "subscriptionId", valid_593961
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593962 = query.getOrDefault("api-version")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "api-version", valid_593962
  var valid_593963 = query.getOrDefault("$skiptoken")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "$skiptoken", valid_593963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593964: Call_WorkspacesListBySubscription_593943; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available machine learning workspaces under the specified subscription.
  ## 
  let valid = call_593964.validator(path, query, header, formData, body)
  let scheme = call_593964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593964.url(scheme.get, call_593964.host, call_593964.base,
                         call_593964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593964, url, valid)

proc call*(call_593965: Call_WorkspacesListBySubscription_593943;
          apiVersion: string; subscriptionId: string; Skiptoken: string = ""): Recallable =
  ## workspacesListBySubscription
  ## Lists all the available machine learning workspaces under the specified subscription.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  var path_593966 = newJObject()
  var query_593967 = newJObject()
  add(query_593967, "api-version", newJString(apiVersion))
  add(path_593966, "subscriptionId", newJString(subscriptionId))
  add(query_593967, "$skiptoken", newJString(Skiptoken))
  result = call_593965.call(path_593966, query_593967, nil, nil, nil)

var workspacesListBySubscription* = Call_WorkspacesListBySubscription_593943(
    name: "workspacesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/workspaces",
    validator: validate_WorkspacesListBySubscription_593944, base: "",
    url: url_WorkspacesListBySubscription_593945, schemes: {Scheme.Https})
type
  Call_WorkspacesListByResourceGroup_593968 = ref object of OpenApiRestCall_593425
proc url_WorkspacesListByResourceGroup_593970(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.MachineLearningServices/workspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListByResourceGroup_593969(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available machine learning workspaces under the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593971 = path.getOrDefault("resourceGroupName")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "resourceGroupName", valid_593971
  var valid_593972 = path.getOrDefault("subscriptionId")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "subscriptionId", valid_593972
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593973 = query.getOrDefault("api-version")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "api-version", valid_593973
  var valid_593974 = query.getOrDefault("$skiptoken")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "$skiptoken", valid_593974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_WorkspacesListByResourceGroup_593968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available machine learning workspaces under the specified resource group.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_WorkspacesListByResourceGroup_593968;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Skiptoken: string = ""): Recallable =
  ## workspacesListByResourceGroup
  ## Lists all the available machine learning workspaces under the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  var path_593977 = newJObject()
  var query_593978 = newJObject()
  add(path_593977, "resourceGroupName", newJString(resourceGroupName))
  add(query_593978, "api-version", newJString(apiVersion))
  add(path_593977, "subscriptionId", newJString(subscriptionId))
  add(query_593978, "$skiptoken", newJString(Skiptoken))
  result = call_593976.call(path_593977, query_593978, nil, nil, nil)

var workspacesListByResourceGroup* = Call_WorkspacesListByResourceGroup_593968(
    name: "workspacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces",
    validator: validate_WorkspacesListByResourceGroup_593969, base: "",
    url: url_WorkspacesListByResourceGroup_593970, schemes: {Scheme.Https})
type
  Call_WorkspacesCreateOrUpdate_593990 = ref object of OpenApiRestCall_593425
proc url_WorkspacesCreateOrUpdate_593992(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesCreateOrUpdate_593991(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a workspace with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593993 = path.getOrDefault("resourceGroupName")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "resourceGroupName", valid_593993
  var valid_593994 = path.getOrDefault("subscriptionId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "subscriptionId", valid_593994
  var valid_593995 = path.getOrDefault("workspaceName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "workspaceName", valid_593995
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593996 = query.getOrDefault("api-version")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "api-version", valid_593996
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

proc call*(call_593998: Call_WorkspacesCreateOrUpdate_593990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a workspace with the specified parameters.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_WorkspacesCreateOrUpdate_593990;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; workspaceName: string): Recallable =
  ## workspacesCreateOrUpdate
  ## Creates or updates a workspace with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   parameters: JObject (required)
  ##             : The parameters for creating or updating a machine learning workspace.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594000 = newJObject()
  var query_594001 = newJObject()
  var body_594002 = newJObject()
  add(path_594000, "resourceGroupName", newJString(resourceGroupName))
  add(query_594001, "api-version", newJString(apiVersion))
  add(path_594000, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594002 = parameters
  add(path_594000, "workspaceName", newJString(workspaceName))
  result = call_593999.call(path_594000, query_594001, nil, nil, body_594002)

var workspacesCreateOrUpdate* = Call_WorkspacesCreateOrUpdate_593990(
    name: "workspacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}",
    validator: validate_WorkspacesCreateOrUpdate_593991, base: "",
    url: url_WorkspacesCreateOrUpdate_593992, schemes: {Scheme.Https})
type
  Call_WorkspacesGet_593979 = ref object of OpenApiRestCall_593425
proc url_WorkspacesGet_593981(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesGet_593980(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified machine learning workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593982 = path.getOrDefault("resourceGroupName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "resourceGroupName", valid_593982
  var valid_593983 = path.getOrDefault("subscriptionId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "subscriptionId", valid_593983
  var valid_593984 = path.getOrDefault("workspaceName")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "workspaceName", valid_593984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593985 = query.getOrDefault("api-version")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "api-version", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593986: Call_WorkspacesGet_593979; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified machine learning workspace.
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_WorkspacesGet_593979; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesGet
  ## Gets the properties of the specified machine learning workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_593988 = newJObject()
  var query_593989 = newJObject()
  add(path_593988, "resourceGroupName", newJString(resourceGroupName))
  add(query_593989, "api-version", newJString(apiVersion))
  add(path_593988, "subscriptionId", newJString(subscriptionId))
  add(path_593988, "workspaceName", newJString(workspaceName))
  result = call_593987.call(path_593988, query_593989, nil, nil, nil)

var workspacesGet* = Call_WorkspacesGet_593979(name: "workspacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}",
    validator: validate_WorkspacesGet_593980, base: "", url: url_WorkspacesGet_593981,
    schemes: {Scheme.Https})
type
  Call_WorkspacesUpdate_594014 = ref object of OpenApiRestCall_593425
proc url_WorkspacesUpdate_594016(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesUpdate_594015(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a machine learning workspace with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594034 = path.getOrDefault("resourceGroupName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "resourceGroupName", valid_594034
  var valid_594035 = path.getOrDefault("subscriptionId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "subscriptionId", valid_594035
  var valid_594036 = path.getOrDefault("workspaceName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "workspaceName", valid_594036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594037 = query.getOrDefault("api-version")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "api-version", valid_594037
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

proc call*(call_594039: Call_WorkspacesUpdate_594014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a machine learning workspace with the specified parameters.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_WorkspacesUpdate_594014; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          workspaceName: string): Recallable =
  ## workspacesUpdate
  ## Updates a machine learning workspace with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   parameters: JObject (required)
  ##             : The parameters for updating a machine learning workspace.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594041 = newJObject()
  var query_594042 = newJObject()
  var body_594043 = newJObject()
  add(path_594041, "resourceGroupName", newJString(resourceGroupName))
  add(query_594042, "api-version", newJString(apiVersion))
  add(path_594041, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594043 = parameters
  add(path_594041, "workspaceName", newJString(workspaceName))
  result = call_594040.call(path_594041, query_594042, nil, nil, body_594043)

var workspacesUpdate* = Call_WorkspacesUpdate_594014(name: "workspacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}",
    validator: validate_WorkspacesUpdate_594015, base: "",
    url: url_WorkspacesUpdate_594016, schemes: {Scheme.Https})
type
  Call_WorkspacesDelete_594003 = ref object of OpenApiRestCall_593425
proc url_WorkspacesDelete_594005(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesDelete_594004(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a machine learning workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594006 = path.getOrDefault("resourceGroupName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "resourceGroupName", valid_594006
  var valid_594007 = path.getOrDefault("subscriptionId")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "subscriptionId", valid_594007
  var valid_594008 = path.getOrDefault("workspaceName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "workspaceName", valid_594008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594009 = query.getOrDefault("api-version")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "api-version", valid_594009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594010: Call_WorkspacesDelete_594003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a machine learning workspace.
  ## 
  let valid = call_594010.validator(path, query, header, formData, body)
  let scheme = call_594010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594010.url(scheme.get, call_594010.host, call_594010.base,
                         call_594010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594010, url, valid)

proc call*(call_594011: Call_WorkspacesDelete_594003; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesDelete
  ## Deletes a machine learning workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594012 = newJObject()
  var query_594013 = newJObject()
  add(path_594012, "resourceGroupName", newJString(resourceGroupName))
  add(query_594013, "api-version", newJString(apiVersion))
  add(path_594012, "subscriptionId", newJString(subscriptionId))
  add(path_594012, "workspaceName", newJString(workspaceName))
  result = call_594011.call(path_594012, query_594013, nil, nil, nil)

var workspacesDelete* = Call_WorkspacesDelete_594003(name: "workspacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}",
    validator: validate_WorkspacesDelete_594004, base: "",
    url: url_WorkspacesDelete_594005, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeListByWorkspace_594044 = ref object of OpenApiRestCall_593425
proc url_MachineLearningComputeListByWorkspace_594046(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeListByWorkspace_594045(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets computes in specified workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594047 = path.getOrDefault("resourceGroupName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "resourceGroupName", valid_594047
  var valid_594048 = path.getOrDefault("subscriptionId")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "subscriptionId", valid_594048
  var valid_594049 = path.getOrDefault("workspaceName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "workspaceName", valid_594049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594050 = query.getOrDefault("api-version")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "api-version", valid_594050
  var valid_594051 = query.getOrDefault("$skiptoken")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "$skiptoken", valid_594051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594052: Call_MachineLearningComputeListByWorkspace_594044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets computes in specified workspace.
  ## 
  let valid = call_594052.validator(path, query, header, formData, body)
  let scheme = call_594052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594052.url(scheme.get, call_594052.host, call_594052.base,
                         call_594052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594052, url, valid)

proc call*(call_594053: Call_MachineLearningComputeListByWorkspace_594044;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string; Skiptoken: string = ""): Recallable =
  ## machineLearningComputeListByWorkspace
  ## Gets computes in specified workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594054 = newJObject()
  var query_594055 = newJObject()
  add(path_594054, "resourceGroupName", newJString(resourceGroupName))
  add(query_594055, "api-version", newJString(apiVersion))
  add(path_594054, "subscriptionId", newJString(subscriptionId))
  add(query_594055, "$skiptoken", newJString(Skiptoken))
  add(path_594054, "workspaceName", newJString(workspaceName))
  result = call_594053.call(path_594054, query_594055, nil, nil, nil)

var machineLearningComputeListByWorkspace* = Call_MachineLearningComputeListByWorkspace_594044(
    name: "machineLearningComputeListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes",
    validator: validate_MachineLearningComputeListByWorkspace_594045, base: "",
    url: url_MachineLearningComputeListByWorkspace_594046, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeCreateOrUpdate_594068 = ref object of OpenApiRestCall_593425
proc url_MachineLearningComputeCreateOrUpdate_594070(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeCreateOrUpdate_594069(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594071 = path.getOrDefault("resourceGroupName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "resourceGroupName", valid_594071
  var valid_594072 = path.getOrDefault("subscriptionId")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "subscriptionId", valid_594072
  var valid_594073 = path.getOrDefault("computeName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "computeName", valid_594073
  var valid_594074 = path.getOrDefault("workspaceName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "workspaceName", valid_594074
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594075 = query.getOrDefault("api-version")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "api-version", valid_594075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Payload with Machine Learning compute definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594077: Call_MachineLearningComputeCreateOrUpdate_594068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.
  ## 
  let valid = call_594077.validator(path, query, header, formData, body)
  let scheme = call_594077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594077.url(scheme.get, call_594077.host, call_594077.base,
                         call_594077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594077, url, valid)

proc call*(call_594078: Call_MachineLearningComputeCreateOrUpdate_594068;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; parameters: JsonNode; workspaceName: string): Recallable =
  ## machineLearningComputeCreateOrUpdate
  ## Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   parameters: JObject (required)
  ##             : Payload with Machine Learning compute definition.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594079 = newJObject()
  var query_594080 = newJObject()
  var body_594081 = newJObject()
  add(path_594079, "resourceGroupName", newJString(resourceGroupName))
  add(query_594080, "api-version", newJString(apiVersion))
  add(path_594079, "subscriptionId", newJString(subscriptionId))
  add(path_594079, "computeName", newJString(computeName))
  if parameters != nil:
    body_594081 = parameters
  add(path_594079, "workspaceName", newJString(workspaceName))
  result = call_594078.call(path_594079, query_594080, nil, nil, body_594081)

var machineLearningComputeCreateOrUpdate* = Call_MachineLearningComputeCreateOrUpdate_594068(
    name: "machineLearningComputeCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}",
    validator: validate_MachineLearningComputeCreateOrUpdate_594069, base: "",
    url: url_MachineLearningComputeCreateOrUpdate_594070, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeSystemUpdate_594082 = ref object of OpenApiRestCall_593425
proc url_MachineLearningComputeSystemUpdate_594084(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeSystemUpdate_594083(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## System Update On Machine Learning compute.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594085 = path.getOrDefault("resourceGroupName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "resourceGroupName", valid_594085
  var valid_594086 = path.getOrDefault("subscriptionId")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "subscriptionId", valid_594086
  var valid_594087 = path.getOrDefault("computeName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "computeName", valid_594087
  var valid_594088 = path.getOrDefault("workspaceName")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "workspaceName", valid_594088
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594089 = query.getOrDefault("api-version")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "api-version", valid_594089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594090: Call_MachineLearningComputeSystemUpdate_594082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## System Update On Machine Learning compute.
  ## 
  let valid = call_594090.validator(path, query, header, formData, body)
  let scheme = call_594090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594090.url(scheme.get, call_594090.host, call_594090.base,
                         call_594090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594090, url, valid)

proc call*(call_594091: Call_MachineLearningComputeSystemUpdate_594082;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; workspaceName: string): Recallable =
  ## machineLearningComputeSystemUpdate
  ## System Update On Machine Learning compute.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594092 = newJObject()
  var query_594093 = newJObject()
  add(path_594092, "resourceGroupName", newJString(resourceGroupName))
  add(query_594093, "api-version", newJString(apiVersion))
  add(path_594092, "subscriptionId", newJString(subscriptionId))
  add(path_594092, "computeName", newJString(computeName))
  add(path_594092, "workspaceName", newJString(workspaceName))
  result = call_594091.call(path_594092, query_594093, nil, nil, nil)

var machineLearningComputeSystemUpdate* = Call_MachineLearningComputeSystemUpdate_594082(
    name: "machineLearningComputeSystemUpdate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}",
    validator: validate_MachineLearningComputeSystemUpdate_594083, base: "",
    url: url_MachineLearningComputeSystemUpdate_594084, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeGet_594056 = ref object of OpenApiRestCall_593425
proc url_MachineLearningComputeGet_594058(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeGet_594057(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets compute definition by its name. Any secrets (storage keys, service credentials, etc) are not returned - use 'keys' nested resource to get them.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594059 = path.getOrDefault("resourceGroupName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "resourceGroupName", valid_594059
  var valid_594060 = path.getOrDefault("subscriptionId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "subscriptionId", valid_594060
  var valid_594061 = path.getOrDefault("computeName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "computeName", valid_594061
  var valid_594062 = path.getOrDefault("workspaceName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "workspaceName", valid_594062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594063 = query.getOrDefault("api-version")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "api-version", valid_594063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594064: Call_MachineLearningComputeGet_594056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets compute definition by its name. Any secrets (storage keys, service credentials, etc) are not returned - use 'keys' nested resource to get them.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_MachineLearningComputeGet_594056;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; workspaceName: string): Recallable =
  ## machineLearningComputeGet
  ## Gets compute definition by its name. Any secrets (storage keys, service credentials, etc) are not returned - use 'keys' nested resource to get them.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  add(path_594066, "resourceGroupName", newJString(resourceGroupName))
  add(query_594067, "api-version", newJString(apiVersion))
  add(path_594066, "subscriptionId", newJString(subscriptionId))
  add(path_594066, "computeName", newJString(computeName))
  add(path_594066, "workspaceName", newJString(workspaceName))
  result = call_594065.call(path_594066, query_594067, nil, nil, nil)

var machineLearningComputeGet* = Call_MachineLearningComputeGet_594056(
    name: "machineLearningComputeGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}",
    validator: validate_MachineLearningComputeGet_594057, base: "",
    url: url_MachineLearningComputeGet_594058, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeDelete_594094 = ref object of OpenApiRestCall_593425
proc url_MachineLearningComputeDelete_594096(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeDelete_594095(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specified Machine Learning compute.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594097 = path.getOrDefault("resourceGroupName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "resourceGroupName", valid_594097
  var valid_594098 = path.getOrDefault("subscriptionId")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "subscriptionId", valid_594098
  var valid_594099 = path.getOrDefault("computeName")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "computeName", valid_594099
  var valid_594100 = path.getOrDefault("workspaceName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "workspaceName", valid_594100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594101 = query.getOrDefault("api-version")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "api-version", valid_594101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594102: Call_MachineLearningComputeDelete_594094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specified Machine Learning compute.
  ## 
  let valid = call_594102.validator(path, query, header, formData, body)
  let scheme = call_594102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594102.url(scheme.get, call_594102.host, call_594102.base,
                         call_594102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594102, url, valid)

proc call*(call_594103: Call_MachineLearningComputeDelete_594094;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; workspaceName: string): Recallable =
  ## machineLearningComputeDelete
  ## Deletes specified Machine Learning compute.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594104 = newJObject()
  var query_594105 = newJObject()
  add(path_594104, "resourceGroupName", newJString(resourceGroupName))
  add(query_594105, "api-version", newJString(apiVersion))
  add(path_594104, "subscriptionId", newJString(subscriptionId))
  add(path_594104, "computeName", newJString(computeName))
  add(path_594104, "workspaceName", newJString(workspaceName))
  result = call_594103.call(path_594104, query_594105, nil, nil, nil)

var machineLearningComputeDelete* = Call_MachineLearningComputeDelete_594094(
    name: "machineLearningComputeDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}",
    validator: validate_MachineLearningComputeDelete_594095, base: "",
    url: url_MachineLearningComputeDelete_594096, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeListKeys_594106 = ref object of OpenApiRestCall_593425
proc url_MachineLearningComputeListKeys_594108(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeListKeys_594107(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594109 = path.getOrDefault("resourceGroupName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "resourceGroupName", valid_594109
  var valid_594110 = path.getOrDefault("subscriptionId")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "subscriptionId", valid_594110
  var valid_594111 = path.getOrDefault("computeName")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "computeName", valid_594111
  var valid_594112 = path.getOrDefault("workspaceName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "workspaceName", valid_594112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594113 = query.getOrDefault("api-version")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "api-version", valid_594113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594114: Call_MachineLearningComputeListKeys_594106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).
  ## 
  let valid = call_594114.validator(path, query, header, formData, body)
  let scheme = call_594114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594114.url(scheme.get, call_594114.host, call_594114.base,
                         call_594114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594114, url, valid)

proc call*(call_594115: Call_MachineLearningComputeListKeys_594106;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; workspaceName: string): Recallable =
  ## machineLearningComputeListKeys
  ## Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594116 = newJObject()
  var query_594117 = newJObject()
  add(path_594116, "resourceGroupName", newJString(resourceGroupName))
  add(query_594117, "api-version", newJString(apiVersion))
  add(path_594116, "subscriptionId", newJString(subscriptionId))
  add(path_594116, "computeName", newJString(computeName))
  add(path_594116, "workspaceName", newJString(workspaceName))
  result = call_594115.call(path_594116, query_594117, nil, nil, nil)

var machineLearningComputeListKeys* = Call_MachineLearningComputeListKeys_594106(
    name: "machineLearningComputeListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}/listKeys",
    validator: validate_MachineLearningComputeListKeys_594107, base: "",
    url: url_MachineLearningComputeListKeys_594108, schemes: {Scheme.Https})
type
  Call_WorkspacesListKeys_594118 = ref object of OpenApiRestCall_593425
proc url_WorkspacesListKeys_594120(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListKeys_594119(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594121 = path.getOrDefault("resourceGroupName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "resourceGroupName", valid_594121
  var valid_594122 = path.getOrDefault("subscriptionId")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "subscriptionId", valid_594122
  var valid_594123 = path.getOrDefault("workspaceName")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "workspaceName", valid_594123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594124 = query.getOrDefault("api-version")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "api-version", valid_594124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594125: Call_WorkspacesListKeys_594118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ## 
  let valid = call_594125.validator(path, query, header, formData, body)
  let scheme = call_594125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594125.url(scheme.get, call_594125.host, call_594125.base,
                         call_594125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594125, url, valid)

proc call*(call_594126: Call_WorkspacesListKeys_594118; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesListKeys
  ## Lists all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594127 = newJObject()
  var query_594128 = newJObject()
  add(path_594127, "resourceGroupName", newJString(resourceGroupName))
  add(query_594128, "api-version", newJString(apiVersion))
  add(path_594127, "subscriptionId", newJString(subscriptionId))
  add(path_594127, "workspaceName", newJString(workspaceName))
  result = call_594126.call(path_594127, query_594128, nil, nil, nil)

var workspacesListKeys* = Call_WorkspacesListKeys_594118(
    name: "workspacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/listKeys",
    validator: validate_WorkspacesListKeys_594119, base: "",
    url: url_WorkspacesListKeys_594120, schemes: {Scheme.Https})
type
  Call_WorkspacesResyncKeys_594129 = ref object of OpenApiRestCall_593425
proc url_WorkspacesResyncKeys_594131(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/resyncKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesResyncKeys_594130(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resync all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594132 = path.getOrDefault("resourceGroupName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "resourceGroupName", valid_594132
  var valid_594133 = path.getOrDefault("subscriptionId")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "subscriptionId", valid_594133
  var valid_594134 = path.getOrDefault("workspaceName")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "workspaceName", valid_594134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594135 = query.getOrDefault("api-version")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "api-version", valid_594135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594136: Call_WorkspacesResyncKeys_594129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resync all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ## 
  let valid = call_594136.validator(path, query, header, formData, body)
  let scheme = call_594136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594136.url(scheme.get, call_594136.host, call_594136.base,
                         call_594136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594136, url, valid)

proc call*(call_594137: Call_WorkspacesResyncKeys_594129;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string): Recallable =
  ## workspacesResyncKeys
  ## Resync all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594138 = newJObject()
  var query_594139 = newJObject()
  add(path_594138, "resourceGroupName", newJString(resourceGroupName))
  add(query_594139, "api-version", newJString(apiVersion))
  add(path_594138, "subscriptionId", newJString(subscriptionId))
  add(path_594138, "workspaceName", newJString(workspaceName))
  result = call_594137.call(path_594138, query_594139, nil, nil, nil)

var workspacesResyncKeys* = Call_WorkspacesResyncKeys_594129(
    name: "workspacesResyncKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/resyncKeys",
    validator: validate_WorkspacesResyncKeys_594130, base: "",
    url: url_WorkspacesResyncKeys_594131, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
