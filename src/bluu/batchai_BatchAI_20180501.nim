
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BatchAI
## version: 2018-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure BatchAI Management API.
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

  OpenApiRestCall_574467 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574467](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574467): Option[Scheme] {.used.} =
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
  macServiceName = "batchai-BatchAI"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_574689 = ref object of OpenApiRestCall_574467
proc url_OperationsList_574691(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_574690(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists available operations for the Microsoft.BatchAI provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574850 = query.getOrDefault("api-version")
  valid_574850 = validateParameter(valid_574850, JString, required = true,
                                 default = nil)
  if valid_574850 != nil:
    section.add "api-version", valid_574850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574873: Call_OperationsList_574689; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations for the Microsoft.BatchAI provider.
  ## 
  let valid = call_574873.validator(path, query, header, formData, body)
  let scheme = call_574873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574873.url(scheme.get, call_574873.host, call_574873.base,
                         call_574873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574873, url, valid)

proc call*(call_574944: Call_OperationsList_574689; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations for the Microsoft.BatchAI provider.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  var query_574945 = newJObject()
  add(query_574945, "api-version", newJString(apiVersion))
  result = call_574944.call(nil, query_574945, nil, nil, nil)

var operationsList* = Call_OperationsList_574689(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.BatchAI/operations",
    validator: validate_OperationsList_574690, base: "", url: url_OperationsList_574691,
    schemes: {Scheme.Https})
type
  Call_UsagesList_574985 = ref object of OpenApiRestCall_574467
proc url_UsagesList_574987(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsagesList_574986(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current usage information as well as limits for Batch AI resources for given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   location: JString (required)
  ##           : The location for which resource usage is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575002 = path.getOrDefault("subscriptionId")
  valid_575002 = validateParameter(valid_575002, JString, required = true,
                                 default = nil)
  if valid_575002 != nil:
    section.add "subscriptionId", valid_575002
  var valid_575003 = path.getOrDefault("location")
  valid_575003 = validateParameter(valid_575003, JString, required = true,
                                 default = nil)
  if valid_575003 != nil:
    section.add "location", valid_575003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575004 = query.getOrDefault("api-version")
  valid_575004 = validateParameter(valid_575004, JString, required = true,
                                 default = nil)
  if valid_575004 != nil:
    section.add "api-version", valid_575004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575005: Call_UsagesList_574985; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current usage information as well as limits for Batch AI resources for given subscription.
  ## 
  let valid = call_575005.validator(path, query, header, formData, body)
  let scheme = call_575005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575005.url(scheme.get, call_575005.host, call_575005.base,
                         call_575005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575005, url, valid)

proc call*(call_575006: Call_UsagesList_574985; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usagesList
  ## Gets the current usage information as well as limits for Batch AI resources for given subscription.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   location: string (required)
  ##           : The location for which resource usage is queried.
  var path_575007 = newJObject()
  var query_575008 = newJObject()
  add(query_575008, "api-version", newJString(apiVersion))
  add(path_575007, "subscriptionId", newJString(subscriptionId))
  add(path_575007, "location", newJString(location))
  result = call_575006.call(path_575007, query_575008, nil, nil, nil)

var usagesList* = Call_UsagesList_574985(name: "usagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.BatchAI/locations/{location}/usages",
                                      validator: validate_UsagesList_574986,
                                      base: "", url: url_UsagesList_574987,
                                      schemes: {Scheme.Https})
type
  Call_WorkspacesList_575009 = ref object of OpenApiRestCall_574467
proc url_WorkspacesList_575011(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesList_575010(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a list of Workspaces associated with the given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575012 = path.getOrDefault("subscriptionId")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = nil)
  if valid_575012 != nil:
    section.add "subscriptionId", valid_575012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575013 = query.getOrDefault("api-version")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "api-version", valid_575013
  var valid_575028 = query.getOrDefault("maxresults")
  valid_575028 = validateParameter(valid_575028, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575028 != nil:
    section.add "maxresults", valid_575028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575029: Call_WorkspacesList_575009; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of Workspaces associated with the given subscription.
  ## 
  let valid = call_575029.validator(path, query, header, formData, body)
  let scheme = call_575029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575029.url(scheme.get, call_575029.host, call_575029.base,
                         call_575029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575029, url, valid)

proc call*(call_575030: Call_WorkspacesList_575009; apiVersion: string;
          subscriptionId: string; maxresults: int = 1000): Recallable =
  ## workspacesList
  ## Gets a list of Workspaces associated with the given subscription.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  var path_575031 = newJObject()
  var query_575032 = newJObject()
  add(query_575032, "api-version", newJString(apiVersion))
  add(path_575031, "subscriptionId", newJString(subscriptionId))
  add(query_575032, "maxresults", newJInt(maxresults))
  result = call_575030.call(path_575031, query_575032, nil, nil, nil)

var workspacesList* = Call_WorkspacesList_575009(name: "workspacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.BatchAI/workspaces",
    validator: validate_WorkspacesList_575010, base: "", url: url_WorkspacesList_575011,
    schemes: {Scheme.Https})
type
  Call_WorkspacesListByResourceGroup_575033 = ref object of OpenApiRestCall_574467
proc url_WorkspacesListByResourceGroup_575035(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListByResourceGroup_575034(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of Workspaces within the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575036 = path.getOrDefault("resourceGroupName")
  valid_575036 = validateParameter(valid_575036, JString, required = true,
                                 default = nil)
  if valid_575036 != nil:
    section.add "resourceGroupName", valid_575036
  var valid_575037 = path.getOrDefault("subscriptionId")
  valid_575037 = validateParameter(valid_575037, JString, required = true,
                                 default = nil)
  if valid_575037 != nil:
    section.add "subscriptionId", valid_575037
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575038 = query.getOrDefault("api-version")
  valid_575038 = validateParameter(valid_575038, JString, required = true,
                                 default = nil)
  if valid_575038 != nil:
    section.add "api-version", valid_575038
  var valid_575039 = query.getOrDefault("maxresults")
  valid_575039 = validateParameter(valid_575039, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575039 != nil:
    section.add "maxresults", valid_575039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575040: Call_WorkspacesListByResourceGroup_575033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of Workspaces within the specified resource group.
  ## 
  let valid = call_575040.validator(path, query, header, formData, body)
  let scheme = call_575040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575040.url(scheme.get, call_575040.host, call_575040.base,
                         call_575040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575040, url, valid)

proc call*(call_575041: Call_WorkspacesListByResourceGroup_575033;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          maxresults: int = 1000): Recallable =
  ## workspacesListByResourceGroup
  ## Gets a list of Workspaces within the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  var path_575042 = newJObject()
  var query_575043 = newJObject()
  add(path_575042, "resourceGroupName", newJString(resourceGroupName))
  add(query_575043, "api-version", newJString(apiVersion))
  add(path_575042, "subscriptionId", newJString(subscriptionId))
  add(query_575043, "maxresults", newJInt(maxresults))
  result = call_575041.call(path_575042, query_575043, nil, nil, nil)

var workspacesListByResourceGroup* = Call_WorkspacesListByResourceGroup_575033(
    name: "workspacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces",
    validator: validate_WorkspacesListByResourceGroup_575034, base: "",
    url: url_WorkspacesListByResourceGroup_575035, schemes: {Scheme.Https})
type
  Call_WorkspacesCreate_575055 = ref object of OpenApiRestCall_574467
proc url_WorkspacesCreate_575057(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesCreate_575056(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates a Workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575075 = path.getOrDefault("resourceGroupName")
  valid_575075 = validateParameter(valid_575075, JString, required = true,
                                 default = nil)
  if valid_575075 != nil:
    section.add "resourceGroupName", valid_575075
  var valid_575076 = path.getOrDefault("subscriptionId")
  valid_575076 = validateParameter(valid_575076, JString, required = true,
                                 default = nil)
  if valid_575076 != nil:
    section.add "subscriptionId", valid_575076
  var valid_575077 = path.getOrDefault("workspaceName")
  valid_575077 = validateParameter(valid_575077, JString, required = true,
                                 default = nil)
  if valid_575077 != nil:
    section.add "workspaceName", valid_575077
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575078 = query.getOrDefault("api-version")
  valid_575078 = validateParameter(valid_575078, JString, required = true,
                                 default = nil)
  if valid_575078 != nil:
    section.add "api-version", valid_575078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Workspace creation parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575080: Call_WorkspacesCreate_575055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Workspace.
  ## 
  let valid = call_575080.validator(path, query, header, formData, body)
  let scheme = call_575080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575080.url(scheme.get, call_575080.host, call_575080.base,
                         call_575080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575080, url, valid)

proc call*(call_575081: Call_WorkspacesCreate_575055; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          workspaceName: string): Recallable =
  ## workspacesCreate
  ## Creates a Workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   parameters: JObject (required)
  ##             : Workspace creation parameters.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575082 = newJObject()
  var query_575083 = newJObject()
  var body_575084 = newJObject()
  add(path_575082, "resourceGroupName", newJString(resourceGroupName))
  add(query_575083, "api-version", newJString(apiVersion))
  add(path_575082, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575084 = parameters
  add(path_575082, "workspaceName", newJString(workspaceName))
  result = call_575081.call(path_575082, query_575083, nil, nil, body_575084)

var workspacesCreate* = Call_WorkspacesCreate_575055(name: "workspacesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}",
    validator: validate_WorkspacesCreate_575056, base: "",
    url: url_WorkspacesCreate_575057, schemes: {Scheme.Https})
type
  Call_WorkspacesGet_575044 = ref object of OpenApiRestCall_574467
proc url_WorkspacesGet_575046(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesGet_575045(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a Workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575047 = path.getOrDefault("resourceGroupName")
  valid_575047 = validateParameter(valid_575047, JString, required = true,
                                 default = nil)
  if valid_575047 != nil:
    section.add "resourceGroupName", valid_575047
  var valid_575048 = path.getOrDefault("subscriptionId")
  valid_575048 = validateParameter(valid_575048, JString, required = true,
                                 default = nil)
  if valid_575048 != nil:
    section.add "subscriptionId", valid_575048
  var valid_575049 = path.getOrDefault("workspaceName")
  valid_575049 = validateParameter(valid_575049, JString, required = true,
                                 default = nil)
  if valid_575049 != nil:
    section.add "workspaceName", valid_575049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575050 = query.getOrDefault("api-version")
  valid_575050 = validateParameter(valid_575050, JString, required = true,
                                 default = nil)
  if valid_575050 != nil:
    section.add "api-version", valid_575050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575051: Call_WorkspacesGet_575044; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a Workspace.
  ## 
  let valid = call_575051.validator(path, query, header, formData, body)
  let scheme = call_575051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575051.url(scheme.get, call_575051.host, call_575051.base,
                         call_575051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575051, url, valid)

proc call*(call_575052: Call_WorkspacesGet_575044; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesGet
  ## Gets information about a Workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575053 = newJObject()
  var query_575054 = newJObject()
  add(path_575053, "resourceGroupName", newJString(resourceGroupName))
  add(query_575054, "api-version", newJString(apiVersion))
  add(path_575053, "subscriptionId", newJString(subscriptionId))
  add(path_575053, "workspaceName", newJString(workspaceName))
  result = call_575052.call(path_575053, query_575054, nil, nil, nil)

var workspacesGet* = Call_WorkspacesGet_575044(name: "workspacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}",
    validator: validate_WorkspacesGet_575045, base: "", url: url_WorkspacesGet_575046,
    schemes: {Scheme.Https})
type
  Call_WorkspacesUpdate_575096 = ref object of OpenApiRestCall_574467
proc url_WorkspacesUpdate_575098(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesUpdate_575097(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates properties of a Workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575099 = path.getOrDefault("resourceGroupName")
  valid_575099 = validateParameter(valid_575099, JString, required = true,
                                 default = nil)
  if valid_575099 != nil:
    section.add "resourceGroupName", valid_575099
  var valid_575100 = path.getOrDefault("subscriptionId")
  valid_575100 = validateParameter(valid_575100, JString, required = true,
                                 default = nil)
  if valid_575100 != nil:
    section.add "subscriptionId", valid_575100
  var valid_575101 = path.getOrDefault("workspaceName")
  valid_575101 = validateParameter(valid_575101, JString, required = true,
                                 default = nil)
  if valid_575101 != nil:
    section.add "workspaceName", valid_575101
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575102 = query.getOrDefault("api-version")
  valid_575102 = validateParameter(valid_575102, JString, required = true,
                                 default = nil)
  if valid_575102 != nil:
    section.add "api-version", valid_575102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters for workspace update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575104: Call_WorkspacesUpdate_575096; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates properties of a Workspace.
  ## 
  let valid = call_575104.validator(path, query, header, formData, body)
  let scheme = call_575104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575104.url(scheme.get, call_575104.host, call_575104.base,
                         call_575104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575104, url, valid)

proc call*(call_575105: Call_WorkspacesUpdate_575096; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          workspaceName: string): Recallable =
  ## workspacesUpdate
  ## Updates properties of a Workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   parameters: JObject (required)
  ##             : Additional parameters for workspace update.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575106 = newJObject()
  var query_575107 = newJObject()
  var body_575108 = newJObject()
  add(path_575106, "resourceGroupName", newJString(resourceGroupName))
  add(query_575107, "api-version", newJString(apiVersion))
  add(path_575106, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575108 = parameters
  add(path_575106, "workspaceName", newJString(workspaceName))
  result = call_575105.call(path_575106, query_575107, nil, nil, body_575108)

var workspacesUpdate* = Call_WorkspacesUpdate_575096(name: "workspacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}",
    validator: validate_WorkspacesUpdate_575097, base: "",
    url: url_WorkspacesUpdate_575098, schemes: {Scheme.Https})
type
  Call_WorkspacesDelete_575085 = ref object of OpenApiRestCall_574467
proc url_WorkspacesDelete_575087(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesDelete_575086(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a Workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575088 = path.getOrDefault("resourceGroupName")
  valid_575088 = validateParameter(valid_575088, JString, required = true,
                                 default = nil)
  if valid_575088 != nil:
    section.add "resourceGroupName", valid_575088
  var valid_575089 = path.getOrDefault("subscriptionId")
  valid_575089 = validateParameter(valid_575089, JString, required = true,
                                 default = nil)
  if valid_575089 != nil:
    section.add "subscriptionId", valid_575089
  var valid_575090 = path.getOrDefault("workspaceName")
  valid_575090 = validateParameter(valid_575090, JString, required = true,
                                 default = nil)
  if valid_575090 != nil:
    section.add "workspaceName", valid_575090
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575091 = query.getOrDefault("api-version")
  valid_575091 = validateParameter(valid_575091, JString, required = true,
                                 default = nil)
  if valid_575091 != nil:
    section.add "api-version", valid_575091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575092: Call_WorkspacesDelete_575085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Workspace.
  ## 
  let valid = call_575092.validator(path, query, header, formData, body)
  let scheme = call_575092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575092.url(scheme.get, call_575092.host, call_575092.base,
                         call_575092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575092, url, valid)

proc call*(call_575093: Call_WorkspacesDelete_575085; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesDelete
  ## Deletes a Workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575094 = newJObject()
  var query_575095 = newJObject()
  add(path_575094, "resourceGroupName", newJString(resourceGroupName))
  add(query_575095, "api-version", newJString(apiVersion))
  add(path_575094, "subscriptionId", newJString(subscriptionId))
  add(path_575094, "workspaceName", newJString(workspaceName))
  result = call_575093.call(path_575094, query_575095, nil, nil, nil)

var workspacesDelete* = Call_WorkspacesDelete_575085(name: "workspacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}",
    validator: validate_WorkspacesDelete_575086, base: "",
    url: url_WorkspacesDelete_575087, schemes: {Scheme.Https})
type
  Call_ClustersListByWorkspace_575109 = ref object of OpenApiRestCall_574467
proc url_ClustersListByWorkspace_575111(protocol: Scheme; host: string; base: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersListByWorkspace_575110(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about Clusters associated with the given Workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575112 = path.getOrDefault("resourceGroupName")
  valid_575112 = validateParameter(valid_575112, JString, required = true,
                                 default = nil)
  if valid_575112 != nil:
    section.add "resourceGroupName", valid_575112
  var valid_575113 = path.getOrDefault("subscriptionId")
  valid_575113 = validateParameter(valid_575113, JString, required = true,
                                 default = nil)
  if valid_575113 != nil:
    section.add "subscriptionId", valid_575113
  var valid_575114 = path.getOrDefault("workspaceName")
  valid_575114 = validateParameter(valid_575114, JString, required = true,
                                 default = nil)
  if valid_575114 != nil:
    section.add "workspaceName", valid_575114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575115 = query.getOrDefault("api-version")
  valid_575115 = validateParameter(valid_575115, JString, required = true,
                                 default = nil)
  if valid_575115 != nil:
    section.add "api-version", valid_575115
  var valid_575116 = query.getOrDefault("maxresults")
  valid_575116 = validateParameter(valid_575116, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575116 != nil:
    section.add "maxresults", valid_575116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575117: Call_ClustersListByWorkspace_575109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about Clusters associated with the given Workspace.
  ## 
  let valid = call_575117.validator(path, query, header, formData, body)
  let scheme = call_575117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575117.url(scheme.get, call_575117.host, call_575117.base,
                         call_575117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575117, url, valid)

proc call*(call_575118: Call_ClustersListByWorkspace_575109;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string; maxresults: int = 1000): Recallable =
  ## clustersListByWorkspace
  ## Gets information about Clusters associated with the given Workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575119 = newJObject()
  var query_575120 = newJObject()
  add(path_575119, "resourceGroupName", newJString(resourceGroupName))
  add(query_575120, "api-version", newJString(apiVersion))
  add(path_575119, "subscriptionId", newJString(subscriptionId))
  add(query_575120, "maxresults", newJInt(maxresults))
  add(path_575119, "workspaceName", newJString(workspaceName))
  result = call_575118.call(path_575119, query_575120, nil, nil, nil)

var clustersListByWorkspace* = Call_ClustersListByWorkspace_575109(
    name: "clustersListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/clusters",
    validator: validate_ClustersListByWorkspace_575110, base: "",
    url: url_ClustersListByWorkspace_575111, schemes: {Scheme.Https})
type
  Call_ClustersCreate_575133 = ref object of OpenApiRestCall_574467
proc url_ClustersCreate_575135(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersCreate_575134(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a Cluster in the given Workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575136 = path.getOrDefault("clusterName")
  valid_575136 = validateParameter(valid_575136, JString, required = true,
                                 default = nil)
  if valid_575136 != nil:
    section.add "clusterName", valid_575136
  var valid_575137 = path.getOrDefault("resourceGroupName")
  valid_575137 = validateParameter(valid_575137, JString, required = true,
                                 default = nil)
  if valid_575137 != nil:
    section.add "resourceGroupName", valid_575137
  var valid_575138 = path.getOrDefault("subscriptionId")
  valid_575138 = validateParameter(valid_575138, JString, required = true,
                                 default = nil)
  if valid_575138 != nil:
    section.add "subscriptionId", valid_575138
  var valid_575139 = path.getOrDefault("workspaceName")
  valid_575139 = validateParameter(valid_575139, JString, required = true,
                                 default = nil)
  if valid_575139 != nil:
    section.add "workspaceName", valid_575139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575140 = query.getOrDefault("api-version")
  valid_575140 = validateParameter(valid_575140, JString, required = true,
                                 default = nil)
  if valid_575140 != nil:
    section.add "api-version", valid_575140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the Cluster creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575142: Call_ClustersCreate_575133; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Cluster in the given Workspace.
  ## 
  let valid = call_575142.validator(path, query, header, formData, body)
  let scheme = call_575142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575142.url(scheme.get, call_575142.host, call_575142.base,
                         call_575142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575142, url, valid)

proc call*(call_575143: Call_ClustersCreate_575133; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; workspaceName: string): Recallable =
  ## clustersCreate
  ## Creates a Cluster in the given Workspace.
  ##   clusterName: string (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the Cluster creation.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575144 = newJObject()
  var query_575145 = newJObject()
  var body_575146 = newJObject()
  add(path_575144, "clusterName", newJString(clusterName))
  add(path_575144, "resourceGroupName", newJString(resourceGroupName))
  add(query_575145, "api-version", newJString(apiVersion))
  add(path_575144, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575146 = parameters
  add(path_575144, "workspaceName", newJString(workspaceName))
  result = call_575143.call(path_575144, query_575145, nil, nil, body_575146)

var clustersCreate* = Call_ClustersCreate_575133(name: "clustersCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/clusters/{clusterName}",
    validator: validate_ClustersCreate_575134, base: "", url: url_ClustersCreate_575135,
    schemes: {Scheme.Https})
type
  Call_ClustersGet_575121 = ref object of OpenApiRestCall_574467
proc url_ClustersGet_575123(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersGet_575122(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a Cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575124 = path.getOrDefault("clusterName")
  valid_575124 = validateParameter(valid_575124, JString, required = true,
                                 default = nil)
  if valid_575124 != nil:
    section.add "clusterName", valid_575124
  var valid_575125 = path.getOrDefault("resourceGroupName")
  valid_575125 = validateParameter(valid_575125, JString, required = true,
                                 default = nil)
  if valid_575125 != nil:
    section.add "resourceGroupName", valid_575125
  var valid_575126 = path.getOrDefault("subscriptionId")
  valid_575126 = validateParameter(valid_575126, JString, required = true,
                                 default = nil)
  if valid_575126 != nil:
    section.add "subscriptionId", valid_575126
  var valid_575127 = path.getOrDefault("workspaceName")
  valid_575127 = validateParameter(valid_575127, JString, required = true,
                                 default = nil)
  if valid_575127 != nil:
    section.add "workspaceName", valid_575127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575128 = query.getOrDefault("api-version")
  valid_575128 = validateParameter(valid_575128, JString, required = true,
                                 default = nil)
  if valid_575128 != nil:
    section.add "api-version", valid_575128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575129: Call_ClustersGet_575121; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a Cluster.
  ## 
  let valid = call_575129.validator(path, query, header, formData, body)
  let scheme = call_575129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575129.url(scheme.get, call_575129.host, call_575129.base,
                         call_575129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575129, url, valid)

proc call*(call_575130: Call_ClustersGet_575121; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string): Recallable =
  ## clustersGet
  ## Gets information about a Cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575131 = newJObject()
  var query_575132 = newJObject()
  add(path_575131, "clusterName", newJString(clusterName))
  add(path_575131, "resourceGroupName", newJString(resourceGroupName))
  add(query_575132, "api-version", newJString(apiVersion))
  add(path_575131, "subscriptionId", newJString(subscriptionId))
  add(path_575131, "workspaceName", newJString(workspaceName))
  result = call_575130.call(path_575131, query_575132, nil, nil, nil)

var clustersGet* = Call_ClustersGet_575121(name: "clustersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/clusters/{clusterName}",
                                        validator: validate_ClustersGet_575122,
                                        base: "", url: url_ClustersGet_575123,
                                        schemes: {Scheme.Https})
type
  Call_ClustersUpdate_575159 = ref object of OpenApiRestCall_574467
proc url_ClustersUpdate_575161(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersUpdate_575160(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates properties of a Cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575162 = path.getOrDefault("clusterName")
  valid_575162 = validateParameter(valid_575162, JString, required = true,
                                 default = nil)
  if valid_575162 != nil:
    section.add "clusterName", valid_575162
  var valid_575163 = path.getOrDefault("resourceGroupName")
  valid_575163 = validateParameter(valid_575163, JString, required = true,
                                 default = nil)
  if valid_575163 != nil:
    section.add "resourceGroupName", valid_575163
  var valid_575164 = path.getOrDefault("subscriptionId")
  valid_575164 = validateParameter(valid_575164, JString, required = true,
                                 default = nil)
  if valid_575164 != nil:
    section.add "subscriptionId", valid_575164
  var valid_575165 = path.getOrDefault("workspaceName")
  valid_575165 = validateParameter(valid_575165, JString, required = true,
                                 default = nil)
  if valid_575165 != nil:
    section.add "workspaceName", valid_575165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575166 = query.getOrDefault("api-version")
  valid_575166 = validateParameter(valid_575166, JString, required = true,
                                 default = nil)
  if valid_575166 != nil:
    section.add "api-version", valid_575166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters for cluster update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575168: Call_ClustersUpdate_575159; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates properties of a Cluster.
  ## 
  let valid = call_575168.validator(path, query, header, formData, body)
  let scheme = call_575168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575168.url(scheme.get, call_575168.host, call_575168.base,
                         call_575168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575168, url, valid)

proc call*(call_575169: Call_ClustersUpdate_575159; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; workspaceName: string): Recallable =
  ## clustersUpdate
  ## Updates properties of a Cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   parameters: JObject (required)
  ##             : Additional parameters for cluster update.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575170 = newJObject()
  var query_575171 = newJObject()
  var body_575172 = newJObject()
  add(path_575170, "clusterName", newJString(clusterName))
  add(path_575170, "resourceGroupName", newJString(resourceGroupName))
  add(query_575171, "api-version", newJString(apiVersion))
  add(path_575170, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575172 = parameters
  add(path_575170, "workspaceName", newJString(workspaceName))
  result = call_575169.call(path_575170, query_575171, nil, nil, body_575172)

var clustersUpdate* = Call_ClustersUpdate_575159(name: "clustersUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/clusters/{clusterName}",
    validator: validate_ClustersUpdate_575160, base: "", url: url_ClustersUpdate_575161,
    schemes: {Scheme.Https})
type
  Call_ClustersDelete_575147 = ref object of OpenApiRestCall_574467
proc url_ClustersDelete_575149(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersDelete_575148(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a Cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575150 = path.getOrDefault("clusterName")
  valid_575150 = validateParameter(valid_575150, JString, required = true,
                                 default = nil)
  if valid_575150 != nil:
    section.add "clusterName", valid_575150
  var valid_575151 = path.getOrDefault("resourceGroupName")
  valid_575151 = validateParameter(valid_575151, JString, required = true,
                                 default = nil)
  if valid_575151 != nil:
    section.add "resourceGroupName", valid_575151
  var valid_575152 = path.getOrDefault("subscriptionId")
  valid_575152 = validateParameter(valid_575152, JString, required = true,
                                 default = nil)
  if valid_575152 != nil:
    section.add "subscriptionId", valid_575152
  var valid_575153 = path.getOrDefault("workspaceName")
  valid_575153 = validateParameter(valid_575153, JString, required = true,
                                 default = nil)
  if valid_575153 != nil:
    section.add "workspaceName", valid_575153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575154 = query.getOrDefault("api-version")
  valid_575154 = validateParameter(valid_575154, JString, required = true,
                                 default = nil)
  if valid_575154 != nil:
    section.add "api-version", valid_575154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575155: Call_ClustersDelete_575147; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Cluster.
  ## 
  let valid = call_575155.validator(path, query, header, formData, body)
  let scheme = call_575155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575155.url(scheme.get, call_575155.host, call_575155.base,
                         call_575155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575155, url, valid)

proc call*(call_575156: Call_ClustersDelete_575147; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string): Recallable =
  ## clustersDelete
  ## Deletes a Cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575157 = newJObject()
  var query_575158 = newJObject()
  add(path_575157, "clusterName", newJString(clusterName))
  add(path_575157, "resourceGroupName", newJString(resourceGroupName))
  add(query_575158, "api-version", newJString(apiVersion))
  add(path_575157, "subscriptionId", newJString(subscriptionId))
  add(path_575157, "workspaceName", newJString(workspaceName))
  result = call_575156.call(path_575157, query_575158, nil, nil, nil)

var clustersDelete* = Call_ClustersDelete_575147(name: "clustersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/clusters/{clusterName}",
    validator: validate_ClustersDelete_575148, base: "", url: url_ClustersDelete_575149,
    schemes: {Scheme.Https})
type
  Call_ClustersListRemoteLoginInformation_575173 = ref object of OpenApiRestCall_574467
proc url_ClustersListRemoteLoginInformation_575175(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/listRemoteLoginInformation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersListRemoteLoginInformation_575174(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the IP address, port of all the compute nodes in the Cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575176 = path.getOrDefault("clusterName")
  valid_575176 = validateParameter(valid_575176, JString, required = true,
                                 default = nil)
  if valid_575176 != nil:
    section.add "clusterName", valid_575176
  var valid_575177 = path.getOrDefault("resourceGroupName")
  valid_575177 = validateParameter(valid_575177, JString, required = true,
                                 default = nil)
  if valid_575177 != nil:
    section.add "resourceGroupName", valid_575177
  var valid_575178 = path.getOrDefault("subscriptionId")
  valid_575178 = validateParameter(valid_575178, JString, required = true,
                                 default = nil)
  if valid_575178 != nil:
    section.add "subscriptionId", valid_575178
  var valid_575179 = path.getOrDefault("workspaceName")
  valid_575179 = validateParameter(valid_575179, JString, required = true,
                                 default = nil)
  if valid_575179 != nil:
    section.add "workspaceName", valid_575179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575180 = query.getOrDefault("api-version")
  valid_575180 = validateParameter(valid_575180, JString, required = true,
                                 default = nil)
  if valid_575180 != nil:
    section.add "api-version", valid_575180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575181: Call_ClustersListRemoteLoginInformation_575173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IP address, port of all the compute nodes in the Cluster.
  ## 
  let valid = call_575181.validator(path, query, header, formData, body)
  let scheme = call_575181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575181.url(scheme.get, call_575181.host, call_575181.base,
                         call_575181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575181, url, valid)

proc call*(call_575182: Call_ClustersListRemoteLoginInformation_575173;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; workspaceName: string): Recallable =
  ## clustersListRemoteLoginInformation
  ## Get the IP address, port of all the compute nodes in the Cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575183 = newJObject()
  var query_575184 = newJObject()
  add(path_575183, "clusterName", newJString(clusterName))
  add(path_575183, "resourceGroupName", newJString(resourceGroupName))
  add(query_575184, "api-version", newJString(apiVersion))
  add(path_575183, "subscriptionId", newJString(subscriptionId))
  add(path_575183, "workspaceName", newJString(workspaceName))
  result = call_575182.call(path_575183, query_575184, nil, nil, nil)

var clustersListRemoteLoginInformation* = Call_ClustersListRemoteLoginInformation_575173(
    name: "clustersListRemoteLoginInformation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/clusters/{clusterName}/listRemoteLoginInformation",
    validator: validate_ClustersListRemoteLoginInformation_575174, base: "",
    url: url_ClustersListRemoteLoginInformation_575175, schemes: {Scheme.Https})
type
  Call_ExperimentsListByWorkspace_575185 = ref object of OpenApiRestCall_574467
proc url_ExperimentsListByWorkspace_575187(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExperimentsListByWorkspace_575186(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of Experiments within the specified Workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575188 = path.getOrDefault("resourceGroupName")
  valid_575188 = validateParameter(valid_575188, JString, required = true,
                                 default = nil)
  if valid_575188 != nil:
    section.add "resourceGroupName", valid_575188
  var valid_575189 = path.getOrDefault("subscriptionId")
  valid_575189 = validateParameter(valid_575189, JString, required = true,
                                 default = nil)
  if valid_575189 != nil:
    section.add "subscriptionId", valid_575189
  var valid_575190 = path.getOrDefault("workspaceName")
  valid_575190 = validateParameter(valid_575190, JString, required = true,
                                 default = nil)
  if valid_575190 != nil:
    section.add "workspaceName", valid_575190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575191 = query.getOrDefault("api-version")
  valid_575191 = validateParameter(valid_575191, JString, required = true,
                                 default = nil)
  if valid_575191 != nil:
    section.add "api-version", valid_575191
  var valid_575192 = query.getOrDefault("maxresults")
  valid_575192 = validateParameter(valid_575192, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575192 != nil:
    section.add "maxresults", valid_575192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575193: Call_ExperimentsListByWorkspace_575185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of Experiments within the specified Workspace.
  ## 
  let valid = call_575193.validator(path, query, header, formData, body)
  let scheme = call_575193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575193.url(scheme.get, call_575193.host, call_575193.base,
                         call_575193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575193, url, valid)

proc call*(call_575194: Call_ExperimentsListByWorkspace_575185;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string; maxresults: int = 1000): Recallable =
  ## experimentsListByWorkspace
  ## Gets a list of Experiments within the specified Workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575195 = newJObject()
  var query_575196 = newJObject()
  add(path_575195, "resourceGroupName", newJString(resourceGroupName))
  add(query_575196, "api-version", newJString(apiVersion))
  add(path_575195, "subscriptionId", newJString(subscriptionId))
  add(query_575196, "maxresults", newJInt(maxresults))
  add(path_575195, "workspaceName", newJString(workspaceName))
  result = call_575194.call(path_575195, query_575196, nil, nil, nil)

var experimentsListByWorkspace* = Call_ExperimentsListByWorkspace_575185(
    name: "experimentsListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/experiments",
    validator: validate_ExperimentsListByWorkspace_575186, base: "",
    url: url_ExperimentsListByWorkspace_575187, schemes: {Scheme.Https})
type
  Call_ExperimentsCreate_575209 = ref object of OpenApiRestCall_574467
proc url_ExperimentsCreate_575211(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentName" in path, "`experimentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExperimentsCreate_575210(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates an Experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   experimentName: JString (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575212 = path.getOrDefault("resourceGroupName")
  valid_575212 = validateParameter(valid_575212, JString, required = true,
                                 default = nil)
  if valid_575212 != nil:
    section.add "resourceGroupName", valid_575212
  var valid_575213 = path.getOrDefault("subscriptionId")
  valid_575213 = validateParameter(valid_575213, JString, required = true,
                                 default = nil)
  if valid_575213 != nil:
    section.add "subscriptionId", valid_575213
  var valid_575214 = path.getOrDefault("experimentName")
  valid_575214 = validateParameter(valid_575214, JString, required = true,
                                 default = nil)
  if valid_575214 != nil:
    section.add "experimentName", valid_575214
  var valid_575215 = path.getOrDefault("workspaceName")
  valid_575215 = validateParameter(valid_575215, JString, required = true,
                                 default = nil)
  if valid_575215 != nil:
    section.add "workspaceName", valid_575215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575216 = query.getOrDefault("api-version")
  valid_575216 = validateParameter(valid_575216, JString, required = true,
                                 default = nil)
  if valid_575216 != nil:
    section.add "api-version", valid_575216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575217: Call_ExperimentsCreate_575209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an Experiment.
  ## 
  let valid = call_575217.validator(path, query, header, formData, body)
  let scheme = call_575217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575217.url(scheme.get, call_575217.host, call_575217.base,
                         call_575217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575217, url, valid)

proc call*(call_575218: Call_ExperimentsCreate_575209; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; experimentName: string;
          workspaceName: string): Recallable =
  ## experimentsCreate
  ## Creates an Experiment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   experimentName: string (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575219 = newJObject()
  var query_575220 = newJObject()
  add(path_575219, "resourceGroupName", newJString(resourceGroupName))
  add(query_575220, "api-version", newJString(apiVersion))
  add(path_575219, "subscriptionId", newJString(subscriptionId))
  add(path_575219, "experimentName", newJString(experimentName))
  add(path_575219, "workspaceName", newJString(workspaceName))
  result = call_575218.call(path_575219, query_575220, nil, nil, nil)

var experimentsCreate* = Call_ExperimentsCreate_575209(name: "experimentsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/experiments/{experimentName}",
    validator: validate_ExperimentsCreate_575210, base: "",
    url: url_ExperimentsCreate_575211, schemes: {Scheme.Https})
type
  Call_ExperimentsGet_575197 = ref object of OpenApiRestCall_574467
proc url_ExperimentsGet_575199(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentName" in path, "`experimentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExperimentsGet_575198(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about an Experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   experimentName: JString (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575200 = path.getOrDefault("resourceGroupName")
  valid_575200 = validateParameter(valid_575200, JString, required = true,
                                 default = nil)
  if valid_575200 != nil:
    section.add "resourceGroupName", valid_575200
  var valid_575201 = path.getOrDefault("subscriptionId")
  valid_575201 = validateParameter(valid_575201, JString, required = true,
                                 default = nil)
  if valid_575201 != nil:
    section.add "subscriptionId", valid_575201
  var valid_575202 = path.getOrDefault("experimentName")
  valid_575202 = validateParameter(valid_575202, JString, required = true,
                                 default = nil)
  if valid_575202 != nil:
    section.add "experimentName", valid_575202
  var valid_575203 = path.getOrDefault("workspaceName")
  valid_575203 = validateParameter(valid_575203, JString, required = true,
                                 default = nil)
  if valid_575203 != nil:
    section.add "workspaceName", valid_575203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575204 = query.getOrDefault("api-version")
  valid_575204 = validateParameter(valid_575204, JString, required = true,
                                 default = nil)
  if valid_575204 != nil:
    section.add "api-version", valid_575204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575205: Call_ExperimentsGet_575197; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an Experiment.
  ## 
  let valid = call_575205.validator(path, query, header, formData, body)
  let scheme = call_575205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575205.url(scheme.get, call_575205.host, call_575205.base,
                         call_575205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575205, url, valid)

proc call*(call_575206: Call_ExperimentsGet_575197; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; experimentName: string;
          workspaceName: string): Recallable =
  ## experimentsGet
  ## Gets information about an Experiment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   experimentName: string (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575207 = newJObject()
  var query_575208 = newJObject()
  add(path_575207, "resourceGroupName", newJString(resourceGroupName))
  add(query_575208, "api-version", newJString(apiVersion))
  add(path_575207, "subscriptionId", newJString(subscriptionId))
  add(path_575207, "experimentName", newJString(experimentName))
  add(path_575207, "workspaceName", newJString(workspaceName))
  result = call_575206.call(path_575207, query_575208, nil, nil, nil)

var experimentsGet* = Call_ExperimentsGet_575197(name: "experimentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/experiments/{experimentName}",
    validator: validate_ExperimentsGet_575198, base: "", url: url_ExperimentsGet_575199,
    schemes: {Scheme.Https})
type
  Call_ExperimentsDelete_575221 = ref object of OpenApiRestCall_574467
proc url_ExperimentsDelete_575223(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentName" in path, "`experimentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExperimentsDelete_575222(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an Experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   experimentName: JString (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575224 = path.getOrDefault("resourceGroupName")
  valid_575224 = validateParameter(valid_575224, JString, required = true,
                                 default = nil)
  if valid_575224 != nil:
    section.add "resourceGroupName", valid_575224
  var valid_575225 = path.getOrDefault("subscriptionId")
  valid_575225 = validateParameter(valid_575225, JString, required = true,
                                 default = nil)
  if valid_575225 != nil:
    section.add "subscriptionId", valid_575225
  var valid_575226 = path.getOrDefault("experimentName")
  valid_575226 = validateParameter(valid_575226, JString, required = true,
                                 default = nil)
  if valid_575226 != nil:
    section.add "experimentName", valid_575226
  var valid_575227 = path.getOrDefault("workspaceName")
  valid_575227 = validateParameter(valid_575227, JString, required = true,
                                 default = nil)
  if valid_575227 != nil:
    section.add "workspaceName", valid_575227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575228 = query.getOrDefault("api-version")
  valid_575228 = validateParameter(valid_575228, JString, required = true,
                                 default = nil)
  if valid_575228 != nil:
    section.add "api-version", valid_575228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575229: Call_ExperimentsDelete_575221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Experiment.
  ## 
  let valid = call_575229.validator(path, query, header, formData, body)
  let scheme = call_575229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575229.url(scheme.get, call_575229.host, call_575229.base,
                         call_575229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575229, url, valid)

proc call*(call_575230: Call_ExperimentsDelete_575221; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; experimentName: string;
          workspaceName: string): Recallable =
  ## experimentsDelete
  ## Deletes an Experiment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   experimentName: string (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575231 = newJObject()
  var query_575232 = newJObject()
  add(path_575231, "resourceGroupName", newJString(resourceGroupName))
  add(query_575232, "api-version", newJString(apiVersion))
  add(path_575231, "subscriptionId", newJString(subscriptionId))
  add(path_575231, "experimentName", newJString(experimentName))
  add(path_575231, "workspaceName", newJString(workspaceName))
  result = call_575230.call(path_575231, query_575232, nil, nil, nil)

var experimentsDelete* = Call_ExperimentsDelete_575221(name: "experimentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/experiments/{experimentName}",
    validator: validate_ExperimentsDelete_575222, base: "",
    url: url_ExperimentsDelete_575223, schemes: {Scheme.Https})
type
  Call_JobsListByExperiment_575233 = ref object of OpenApiRestCall_574467
proc url_JobsListByExperiment_575235(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentName" in path, "`experimentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListByExperiment_575234(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of Jobs within the specified Experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   experimentName: JString (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575236 = path.getOrDefault("resourceGroupName")
  valid_575236 = validateParameter(valid_575236, JString, required = true,
                                 default = nil)
  if valid_575236 != nil:
    section.add "resourceGroupName", valid_575236
  var valid_575237 = path.getOrDefault("subscriptionId")
  valid_575237 = validateParameter(valid_575237, JString, required = true,
                                 default = nil)
  if valid_575237 != nil:
    section.add "subscriptionId", valid_575237
  var valid_575238 = path.getOrDefault("experimentName")
  valid_575238 = validateParameter(valid_575238, JString, required = true,
                                 default = nil)
  if valid_575238 != nil:
    section.add "experimentName", valid_575238
  var valid_575239 = path.getOrDefault("workspaceName")
  valid_575239 = validateParameter(valid_575239, JString, required = true,
                                 default = nil)
  if valid_575239 != nil:
    section.add "workspaceName", valid_575239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575240 = query.getOrDefault("api-version")
  valid_575240 = validateParameter(valid_575240, JString, required = true,
                                 default = nil)
  if valid_575240 != nil:
    section.add "api-version", valid_575240
  var valid_575241 = query.getOrDefault("maxresults")
  valid_575241 = validateParameter(valid_575241, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575241 != nil:
    section.add "maxresults", valid_575241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575242: Call_JobsListByExperiment_575233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of Jobs within the specified Experiment.
  ## 
  let valid = call_575242.validator(path, query, header, formData, body)
  let scheme = call_575242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575242.url(scheme.get, call_575242.host, call_575242.base,
                         call_575242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575242, url, valid)

proc call*(call_575243: Call_JobsListByExperiment_575233;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          experimentName: string; workspaceName: string; maxresults: int = 1000): Recallable =
  ## jobsListByExperiment
  ## Gets a list of Jobs within the specified Experiment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   experimentName: string (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575244 = newJObject()
  var query_575245 = newJObject()
  add(path_575244, "resourceGroupName", newJString(resourceGroupName))
  add(query_575245, "api-version", newJString(apiVersion))
  add(path_575244, "subscriptionId", newJString(subscriptionId))
  add(query_575245, "maxresults", newJInt(maxresults))
  add(path_575244, "experimentName", newJString(experimentName))
  add(path_575244, "workspaceName", newJString(workspaceName))
  result = call_575243.call(path_575244, query_575245, nil, nil, nil)

var jobsListByExperiment* = Call_JobsListByExperiment_575233(
    name: "jobsListByExperiment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/experiments/{experimentName}/jobs",
    validator: validate_JobsListByExperiment_575234, base: "",
    url: url_JobsListByExperiment_575235, schemes: {Scheme.Https})
type
  Call_JobsCreate_575259 = ref object of OpenApiRestCall_574467
proc url_JobsCreate_575261(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentName" in path, "`experimentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsCreate_575260(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Job in the given Experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   experimentName: JString (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575262 = path.getOrDefault("resourceGroupName")
  valid_575262 = validateParameter(valid_575262, JString, required = true,
                                 default = nil)
  if valid_575262 != nil:
    section.add "resourceGroupName", valid_575262
  var valid_575263 = path.getOrDefault("subscriptionId")
  valid_575263 = validateParameter(valid_575263, JString, required = true,
                                 default = nil)
  if valid_575263 != nil:
    section.add "subscriptionId", valid_575263
  var valid_575264 = path.getOrDefault("jobName")
  valid_575264 = validateParameter(valid_575264, JString, required = true,
                                 default = nil)
  if valid_575264 != nil:
    section.add "jobName", valid_575264
  var valid_575265 = path.getOrDefault("experimentName")
  valid_575265 = validateParameter(valid_575265, JString, required = true,
                                 default = nil)
  if valid_575265 != nil:
    section.add "experimentName", valid_575265
  var valid_575266 = path.getOrDefault("workspaceName")
  valid_575266 = validateParameter(valid_575266, JString, required = true,
                                 default = nil)
  if valid_575266 != nil:
    section.add "workspaceName", valid_575266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575267 = query.getOrDefault("api-version")
  valid_575267 = validateParameter(valid_575267, JString, required = true,
                                 default = nil)
  if valid_575267 != nil:
    section.add "api-version", valid_575267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for job creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575269: Call_JobsCreate_575259; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Job in the given Experiment.
  ## 
  let valid = call_575269.validator(path, query, header, formData, body)
  let scheme = call_575269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575269.url(scheme.get, call_575269.host, call_575269.base,
                         call_575269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575269, url, valid)

proc call*(call_575270: Call_JobsCreate_575259; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          parameters: JsonNode; experimentName: string; workspaceName: string): Recallable =
  ## jobsCreate
  ## Creates a Job in the given Experiment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for job creation.
  ##   experimentName: string (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575271 = newJObject()
  var query_575272 = newJObject()
  var body_575273 = newJObject()
  add(path_575271, "resourceGroupName", newJString(resourceGroupName))
  add(query_575272, "api-version", newJString(apiVersion))
  add(path_575271, "subscriptionId", newJString(subscriptionId))
  add(path_575271, "jobName", newJString(jobName))
  if parameters != nil:
    body_575273 = parameters
  add(path_575271, "experimentName", newJString(experimentName))
  add(path_575271, "workspaceName", newJString(workspaceName))
  result = call_575270.call(path_575271, query_575272, nil, nil, body_575273)

var jobsCreate* = Call_JobsCreate_575259(name: "jobsCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/experiments/{experimentName}/jobs/{jobName}",
                                      validator: validate_JobsCreate_575260,
                                      base: "", url: url_JobsCreate_575261,
                                      schemes: {Scheme.Https})
type
  Call_JobsGet_575246 = ref object of OpenApiRestCall_574467
proc url_JobsGet_575248(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentName" in path, "`experimentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsGet_575247(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a Job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   experimentName: JString (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575249 = path.getOrDefault("resourceGroupName")
  valid_575249 = validateParameter(valid_575249, JString, required = true,
                                 default = nil)
  if valid_575249 != nil:
    section.add "resourceGroupName", valid_575249
  var valid_575250 = path.getOrDefault("subscriptionId")
  valid_575250 = validateParameter(valid_575250, JString, required = true,
                                 default = nil)
  if valid_575250 != nil:
    section.add "subscriptionId", valid_575250
  var valid_575251 = path.getOrDefault("jobName")
  valid_575251 = validateParameter(valid_575251, JString, required = true,
                                 default = nil)
  if valid_575251 != nil:
    section.add "jobName", valid_575251
  var valid_575252 = path.getOrDefault("experimentName")
  valid_575252 = validateParameter(valid_575252, JString, required = true,
                                 default = nil)
  if valid_575252 != nil:
    section.add "experimentName", valid_575252
  var valid_575253 = path.getOrDefault("workspaceName")
  valid_575253 = validateParameter(valid_575253, JString, required = true,
                                 default = nil)
  if valid_575253 != nil:
    section.add "workspaceName", valid_575253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575254 = query.getOrDefault("api-version")
  valid_575254 = validateParameter(valid_575254, JString, required = true,
                                 default = nil)
  if valid_575254 != nil:
    section.add "api-version", valid_575254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575255: Call_JobsGet_575246; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a Job.
  ## 
  let valid = call_575255.validator(path, query, header, formData, body)
  let scheme = call_575255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575255.url(scheme.get, call_575255.host, call_575255.base,
                         call_575255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575255, url, valid)

proc call*(call_575256: Call_JobsGet_575246; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          experimentName: string; workspaceName: string): Recallable =
  ## jobsGet
  ## Gets information about a Job.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   experimentName: string (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575257 = newJObject()
  var query_575258 = newJObject()
  add(path_575257, "resourceGroupName", newJString(resourceGroupName))
  add(query_575258, "api-version", newJString(apiVersion))
  add(path_575257, "subscriptionId", newJString(subscriptionId))
  add(path_575257, "jobName", newJString(jobName))
  add(path_575257, "experimentName", newJString(experimentName))
  add(path_575257, "workspaceName", newJString(workspaceName))
  result = call_575256.call(path_575257, query_575258, nil, nil, nil)

var jobsGet* = Call_JobsGet_575246(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/experiments/{experimentName}/jobs/{jobName}",
                                validator: validate_JobsGet_575247, base: "",
                                url: url_JobsGet_575248, schemes: {Scheme.Https})
type
  Call_JobsDelete_575274 = ref object of OpenApiRestCall_574467
proc url_JobsDelete_575276(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentName" in path, "`experimentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsDelete_575275(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   experimentName: JString (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575277 = path.getOrDefault("resourceGroupName")
  valid_575277 = validateParameter(valid_575277, JString, required = true,
                                 default = nil)
  if valid_575277 != nil:
    section.add "resourceGroupName", valid_575277
  var valid_575278 = path.getOrDefault("subscriptionId")
  valid_575278 = validateParameter(valid_575278, JString, required = true,
                                 default = nil)
  if valid_575278 != nil:
    section.add "subscriptionId", valid_575278
  var valid_575279 = path.getOrDefault("jobName")
  valid_575279 = validateParameter(valid_575279, JString, required = true,
                                 default = nil)
  if valid_575279 != nil:
    section.add "jobName", valid_575279
  var valid_575280 = path.getOrDefault("experimentName")
  valid_575280 = validateParameter(valid_575280, JString, required = true,
                                 default = nil)
  if valid_575280 != nil:
    section.add "experimentName", valid_575280
  var valid_575281 = path.getOrDefault("workspaceName")
  valid_575281 = validateParameter(valid_575281, JString, required = true,
                                 default = nil)
  if valid_575281 != nil:
    section.add "workspaceName", valid_575281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575282 = query.getOrDefault("api-version")
  valid_575282 = validateParameter(valid_575282, JString, required = true,
                                 default = nil)
  if valid_575282 != nil:
    section.add "api-version", valid_575282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575283: Call_JobsDelete_575274; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Job.
  ## 
  let valid = call_575283.validator(path, query, header, formData, body)
  let scheme = call_575283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575283.url(scheme.get, call_575283.host, call_575283.base,
                         call_575283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575283, url, valid)

proc call*(call_575284: Call_JobsDelete_575274; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          experimentName: string; workspaceName: string): Recallable =
  ## jobsDelete
  ## Deletes a Job.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   experimentName: string (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575285 = newJObject()
  var query_575286 = newJObject()
  add(path_575285, "resourceGroupName", newJString(resourceGroupName))
  add(query_575286, "api-version", newJString(apiVersion))
  add(path_575285, "subscriptionId", newJString(subscriptionId))
  add(path_575285, "jobName", newJString(jobName))
  add(path_575285, "experimentName", newJString(experimentName))
  add(path_575285, "workspaceName", newJString(workspaceName))
  result = call_575284.call(path_575285, query_575286, nil, nil, nil)

var jobsDelete* = Call_JobsDelete_575274(name: "jobsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/experiments/{experimentName}/jobs/{jobName}",
                                      validator: validate_JobsDelete_575275,
                                      base: "", url: url_JobsDelete_575276,
                                      schemes: {Scheme.Https})
type
  Call_JobsListOutputFiles_575287 = ref object of OpenApiRestCall_574467
proc url_JobsListOutputFiles_575289(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentName" in path, "`experimentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/listOutputFiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListOutputFiles_575288(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List all directories and files inside the given directory of the Job's output directory (if the output directory is on Azure File Share or Azure Storage Container).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   experimentName: JString (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575290 = path.getOrDefault("resourceGroupName")
  valid_575290 = validateParameter(valid_575290, JString, required = true,
                                 default = nil)
  if valid_575290 != nil:
    section.add "resourceGroupName", valid_575290
  var valid_575291 = path.getOrDefault("subscriptionId")
  valid_575291 = validateParameter(valid_575291, JString, required = true,
                                 default = nil)
  if valid_575291 != nil:
    section.add "subscriptionId", valid_575291
  var valid_575292 = path.getOrDefault("jobName")
  valid_575292 = validateParameter(valid_575292, JString, required = true,
                                 default = nil)
  if valid_575292 != nil:
    section.add "jobName", valid_575292
  var valid_575293 = path.getOrDefault("experimentName")
  valid_575293 = validateParameter(valid_575293, JString, required = true,
                                 default = nil)
  if valid_575293 != nil:
    section.add "experimentName", valid_575293
  var valid_575294 = path.getOrDefault("workspaceName")
  valid_575294 = validateParameter(valid_575294, JString, required = true,
                                 default = nil)
  if valid_575294 != nil:
    section.add "workspaceName", valid_575294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  ##   directory: JString
  ##            : The path to the directory.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   linkexpiryinminutes: JInt
  ##                      : The number of minutes after which the download link will expire.
  ##   outputdirectoryid: JString (required)
  ##                    : Id of the job output directory. This is the OutputDirectory-->id parameter that is given by the user during Create Job.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575295 = query.getOrDefault("api-version")
  valid_575295 = validateParameter(valid_575295, JString, required = true,
                                 default = nil)
  if valid_575295 != nil:
    section.add "api-version", valid_575295
  var valid_575296 = query.getOrDefault("directory")
  valid_575296 = validateParameter(valid_575296, JString, required = false,
                                 default = newJString("."))
  if valid_575296 != nil:
    section.add "directory", valid_575296
  var valid_575297 = query.getOrDefault("maxresults")
  valid_575297 = validateParameter(valid_575297, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575297 != nil:
    section.add "maxresults", valid_575297
  var valid_575298 = query.getOrDefault("linkexpiryinminutes")
  valid_575298 = validateParameter(valid_575298, JInt, required = false,
                                 default = newJInt(60))
  if valid_575298 != nil:
    section.add "linkexpiryinminutes", valid_575298
  var valid_575299 = query.getOrDefault("outputdirectoryid")
  valid_575299 = validateParameter(valid_575299, JString, required = true,
                                 default = nil)
  if valid_575299 != nil:
    section.add "outputdirectoryid", valid_575299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575300: Call_JobsListOutputFiles_575287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all directories and files inside the given directory of the Job's output directory (if the output directory is on Azure File Share or Azure Storage Container).
  ## 
  let valid = call_575300.validator(path, query, header, formData, body)
  let scheme = call_575300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575300.url(scheme.get, call_575300.host, call_575300.base,
                         call_575300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575300, url, valid)

proc call*(call_575301: Call_JobsListOutputFiles_575287; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          outputdirectoryid: string; experimentName: string; workspaceName: string;
          directory: string = "."; maxresults: int = 1000; linkexpiryinminutes: int = 60): Recallable =
  ## jobsListOutputFiles
  ## List all directories and files inside the given directory of the Job's output directory (if the output directory is on Azure File Share or Azure Storage Container).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   directory: string
  ##            : The path to the directory.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   linkexpiryinminutes: int
  ##                      : The number of minutes after which the download link will expire.
  ##   outputdirectoryid: string (required)
  ##                    : Id of the job output directory. This is the OutputDirectory-->id parameter that is given by the user during Create Job.
  ##   experimentName: string (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575302 = newJObject()
  var query_575303 = newJObject()
  add(path_575302, "resourceGroupName", newJString(resourceGroupName))
  add(query_575303, "api-version", newJString(apiVersion))
  add(query_575303, "directory", newJString(directory))
  add(path_575302, "subscriptionId", newJString(subscriptionId))
  add(path_575302, "jobName", newJString(jobName))
  add(query_575303, "maxresults", newJInt(maxresults))
  add(query_575303, "linkexpiryinminutes", newJInt(linkexpiryinminutes))
  add(query_575303, "outputdirectoryid", newJString(outputdirectoryid))
  add(path_575302, "experimentName", newJString(experimentName))
  add(path_575302, "workspaceName", newJString(workspaceName))
  result = call_575301.call(path_575302, query_575303, nil, nil, nil)

var jobsListOutputFiles* = Call_JobsListOutputFiles_575287(
    name: "jobsListOutputFiles", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/experiments/{experimentName}/jobs/{jobName}/listOutputFiles",
    validator: validate_JobsListOutputFiles_575288, base: "",
    url: url_JobsListOutputFiles_575289, schemes: {Scheme.Https})
type
  Call_JobsListRemoteLoginInformation_575304 = ref object of OpenApiRestCall_574467
proc url_JobsListRemoteLoginInformation_575306(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentName" in path, "`experimentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/listRemoteLoginInformation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListRemoteLoginInformation_575305(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of currently existing nodes which were used for the Job execution. The returned information contains the node ID, its public IP and SSH port.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   experimentName: JString (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575307 = path.getOrDefault("resourceGroupName")
  valid_575307 = validateParameter(valid_575307, JString, required = true,
                                 default = nil)
  if valid_575307 != nil:
    section.add "resourceGroupName", valid_575307
  var valid_575308 = path.getOrDefault("subscriptionId")
  valid_575308 = validateParameter(valid_575308, JString, required = true,
                                 default = nil)
  if valid_575308 != nil:
    section.add "subscriptionId", valid_575308
  var valid_575309 = path.getOrDefault("jobName")
  valid_575309 = validateParameter(valid_575309, JString, required = true,
                                 default = nil)
  if valid_575309 != nil:
    section.add "jobName", valid_575309
  var valid_575310 = path.getOrDefault("experimentName")
  valid_575310 = validateParameter(valid_575310, JString, required = true,
                                 default = nil)
  if valid_575310 != nil:
    section.add "experimentName", valid_575310
  var valid_575311 = path.getOrDefault("workspaceName")
  valid_575311 = validateParameter(valid_575311, JString, required = true,
                                 default = nil)
  if valid_575311 != nil:
    section.add "workspaceName", valid_575311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575312 = query.getOrDefault("api-version")
  valid_575312 = validateParameter(valid_575312, JString, required = true,
                                 default = nil)
  if valid_575312 != nil:
    section.add "api-version", valid_575312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575313: Call_JobsListRemoteLoginInformation_575304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of currently existing nodes which were used for the Job execution. The returned information contains the node ID, its public IP and SSH port.
  ## 
  let valid = call_575313.validator(path, query, header, formData, body)
  let scheme = call_575313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575313.url(scheme.get, call_575313.host, call_575313.base,
                         call_575313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575313, url, valid)

proc call*(call_575314: Call_JobsListRemoteLoginInformation_575304;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; experimentName: string; workspaceName: string): Recallable =
  ## jobsListRemoteLoginInformation
  ## Gets a list of currently existing nodes which were used for the Job execution. The returned information contains the node ID, its public IP and SSH port.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   experimentName: string (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575315 = newJObject()
  var query_575316 = newJObject()
  add(path_575315, "resourceGroupName", newJString(resourceGroupName))
  add(query_575316, "api-version", newJString(apiVersion))
  add(path_575315, "subscriptionId", newJString(subscriptionId))
  add(path_575315, "jobName", newJString(jobName))
  add(path_575315, "experimentName", newJString(experimentName))
  add(path_575315, "workspaceName", newJString(workspaceName))
  result = call_575314.call(path_575315, query_575316, nil, nil, nil)

var jobsListRemoteLoginInformation* = Call_JobsListRemoteLoginInformation_575304(
    name: "jobsListRemoteLoginInformation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/experiments/{experimentName}/jobs/{jobName}/listRemoteLoginInformation",
    validator: validate_JobsListRemoteLoginInformation_575305, base: "",
    url: url_JobsListRemoteLoginInformation_575306, schemes: {Scheme.Https})
type
  Call_JobsTerminate_575317 = ref object of OpenApiRestCall_574467
proc url_JobsTerminate_575319(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentName" in path, "`experimentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/terminate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsTerminate_575318(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Terminates a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   experimentName: JString (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575320 = path.getOrDefault("resourceGroupName")
  valid_575320 = validateParameter(valid_575320, JString, required = true,
                                 default = nil)
  if valid_575320 != nil:
    section.add "resourceGroupName", valid_575320
  var valid_575321 = path.getOrDefault("subscriptionId")
  valid_575321 = validateParameter(valid_575321, JString, required = true,
                                 default = nil)
  if valid_575321 != nil:
    section.add "subscriptionId", valid_575321
  var valid_575322 = path.getOrDefault("jobName")
  valid_575322 = validateParameter(valid_575322, JString, required = true,
                                 default = nil)
  if valid_575322 != nil:
    section.add "jobName", valid_575322
  var valid_575323 = path.getOrDefault("experimentName")
  valid_575323 = validateParameter(valid_575323, JString, required = true,
                                 default = nil)
  if valid_575323 != nil:
    section.add "experimentName", valid_575323
  var valid_575324 = path.getOrDefault("workspaceName")
  valid_575324 = validateParameter(valid_575324, JString, required = true,
                                 default = nil)
  if valid_575324 != nil:
    section.add "workspaceName", valid_575324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575325 = query.getOrDefault("api-version")
  valid_575325 = validateParameter(valid_575325, JString, required = true,
                                 default = nil)
  if valid_575325 != nil:
    section.add "api-version", valid_575325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575326: Call_JobsTerminate_575317; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Terminates a job.
  ## 
  let valid = call_575326.validator(path, query, header, formData, body)
  let scheme = call_575326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575326.url(scheme.get, call_575326.host, call_575326.base,
                         call_575326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575326, url, valid)

proc call*(call_575327: Call_JobsTerminate_575317; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          experimentName: string; workspaceName: string): Recallable =
  ## jobsTerminate
  ## Terminates a job.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   experimentName: string (required)
  ##                 : The name of the experiment. Experiment names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575328 = newJObject()
  var query_575329 = newJObject()
  add(path_575328, "resourceGroupName", newJString(resourceGroupName))
  add(query_575329, "api-version", newJString(apiVersion))
  add(path_575328, "subscriptionId", newJString(subscriptionId))
  add(path_575328, "jobName", newJString(jobName))
  add(path_575328, "experimentName", newJString(experimentName))
  add(path_575328, "workspaceName", newJString(workspaceName))
  result = call_575327.call(path_575328, query_575329, nil, nil, nil)

var jobsTerminate* = Call_JobsTerminate_575317(name: "jobsTerminate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/experiments/{experimentName}/jobs/{jobName}/terminate",
    validator: validate_JobsTerminate_575318, base: "", url: url_JobsTerminate_575319,
    schemes: {Scheme.Https})
type
  Call_FileServersListByWorkspace_575330 = ref object of OpenApiRestCall_574467
proc url_FileServersListByWorkspace_575332(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/fileServers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersListByWorkspace_575331(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of File Servers associated with the specified workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575333 = path.getOrDefault("resourceGroupName")
  valid_575333 = validateParameter(valid_575333, JString, required = true,
                                 default = nil)
  if valid_575333 != nil:
    section.add "resourceGroupName", valid_575333
  var valid_575334 = path.getOrDefault("subscriptionId")
  valid_575334 = validateParameter(valid_575334, JString, required = true,
                                 default = nil)
  if valid_575334 != nil:
    section.add "subscriptionId", valid_575334
  var valid_575335 = path.getOrDefault("workspaceName")
  valid_575335 = validateParameter(valid_575335, JString, required = true,
                                 default = nil)
  if valid_575335 != nil:
    section.add "workspaceName", valid_575335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575336 = query.getOrDefault("api-version")
  valid_575336 = validateParameter(valid_575336, JString, required = true,
                                 default = nil)
  if valid_575336 != nil:
    section.add "api-version", valid_575336
  var valid_575337 = query.getOrDefault("maxresults")
  valid_575337 = validateParameter(valid_575337, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575337 != nil:
    section.add "maxresults", valid_575337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575338: Call_FileServersListByWorkspace_575330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of File Servers associated with the specified workspace.
  ## 
  let valid = call_575338.validator(path, query, header, formData, body)
  let scheme = call_575338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575338.url(scheme.get, call_575338.host, call_575338.base,
                         call_575338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575338, url, valid)

proc call*(call_575339: Call_FileServersListByWorkspace_575330;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string; maxresults: int = 1000): Recallable =
  ## fileServersListByWorkspace
  ## Gets a list of File Servers associated with the specified workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575340 = newJObject()
  var query_575341 = newJObject()
  add(path_575340, "resourceGroupName", newJString(resourceGroupName))
  add(query_575341, "api-version", newJString(apiVersion))
  add(path_575340, "subscriptionId", newJString(subscriptionId))
  add(query_575341, "maxresults", newJInt(maxresults))
  add(path_575340, "workspaceName", newJString(workspaceName))
  result = call_575339.call(path_575340, query_575341, nil, nil, nil)

var fileServersListByWorkspace* = Call_FileServersListByWorkspace_575330(
    name: "fileServersListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/fileServers",
    validator: validate_FileServersListByWorkspace_575331, base: "",
    url: url_FileServersListByWorkspace_575332, schemes: {Scheme.Https})
type
  Call_FileServersCreate_575354 = ref object of OpenApiRestCall_574467
proc url_FileServersCreate_575356(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/fileServers/"),
               (kind: VariableSegment, value: "fileServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersCreate_575355(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a File Server in the given workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   fileServerName: JString (required)
  ##                 : The name of the file server within the specified resource group. File server names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575357 = path.getOrDefault("resourceGroupName")
  valid_575357 = validateParameter(valid_575357, JString, required = true,
                                 default = nil)
  if valid_575357 != nil:
    section.add "resourceGroupName", valid_575357
  var valid_575358 = path.getOrDefault("subscriptionId")
  valid_575358 = validateParameter(valid_575358, JString, required = true,
                                 default = nil)
  if valid_575358 != nil:
    section.add "subscriptionId", valid_575358
  var valid_575359 = path.getOrDefault("fileServerName")
  valid_575359 = validateParameter(valid_575359, JString, required = true,
                                 default = nil)
  if valid_575359 != nil:
    section.add "fileServerName", valid_575359
  var valid_575360 = path.getOrDefault("workspaceName")
  valid_575360 = validateParameter(valid_575360, JString, required = true,
                                 default = nil)
  if valid_575360 != nil:
    section.add "workspaceName", valid_575360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575361 = query.getOrDefault("api-version")
  valid_575361 = validateParameter(valid_575361, JString, required = true,
                                 default = nil)
  if valid_575361 != nil:
    section.add "api-version", valid_575361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for File Server creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575363: Call_FileServersCreate_575354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a File Server in the given workspace.
  ## 
  let valid = call_575363.validator(path, query, header, formData, body)
  let scheme = call_575363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575363.url(scheme.get, call_575363.host, call_575363.base,
                         call_575363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575363, url, valid)

proc call*(call_575364: Call_FileServersCreate_575354; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          fileServerName: string; workspaceName: string): Recallable =
  ## fileServersCreate
  ## Creates a File Server in the given workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for File Server creation.
  ##   fileServerName: string (required)
  ##                 : The name of the file server within the specified resource group. File server names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575365 = newJObject()
  var query_575366 = newJObject()
  var body_575367 = newJObject()
  add(path_575365, "resourceGroupName", newJString(resourceGroupName))
  add(query_575366, "api-version", newJString(apiVersion))
  add(path_575365, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575367 = parameters
  add(path_575365, "fileServerName", newJString(fileServerName))
  add(path_575365, "workspaceName", newJString(workspaceName))
  result = call_575364.call(path_575365, query_575366, nil, nil, body_575367)

var fileServersCreate* = Call_FileServersCreate_575354(name: "fileServersCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/fileServers/{fileServerName}",
    validator: validate_FileServersCreate_575355, base: "",
    url: url_FileServersCreate_575356, schemes: {Scheme.Https})
type
  Call_FileServersGet_575342 = ref object of OpenApiRestCall_574467
proc url_FileServersGet_575344(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/fileServers/"),
               (kind: VariableSegment, value: "fileServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersGet_575343(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about a File Server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   fileServerName: JString (required)
  ##                 : The name of the file server within the specified resource group. File server names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575345 = path.getOrDefault("resourceGroupName")
  valid_575345 = validateParameter(valid_575345, JString, required = true,
                                 default = nil)
  if valid_575345 != nil:
    section.add "resourceGroupName", valid_575345
  var valid_575346 = path.getOrDefault("subscriptionId")
  valid_575346 = validateParameter(valid_575346, JString, required = true,
                                 default = nil)
  if valid_575346 != nil:
    section.add "subscriptionId", valid_575346
  var valid_575347 = path.getOrDefault("fileServerName")
  valid_575347 = validateParameter(valid_575347, JString, required = true,
                                 default = nil)
  if valid_575347 != nil:
    section.add "fileServerName", valid_575347
  var valid_575348 = path.getOrDefault("workspaceName")
  valid_575348 = validateParameter(valid_575348, JString, required = true,
                                 default = nil)
  if valid_575348 != nil:
    section.add "workspaceName", valid_575348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575349 = query.getOrDefault("api-version")
  valid_575349 = validateParameter(valid_575349, JString, required = true,
                                 default = nil)
  if valid_575349 != nil:
    section.add "api-version", valid_575349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575350: Call_FileServersGet_575342; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a File Server.
  ## 
  let valid = call_575350.validator(path, query, header, formData, body)
  let scheme = call_575350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575350.url(scheme.get, call_575350.host, call_575350.base,
                         call_575350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575350, url, valid)

proc call*(call_575351: Call_FileServersGet_575342; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; fileServerName: string;
          workspaceName: string): Recallable =
  ## fileServersGet
  ## Gets information about a File Server.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   fileServerName: string (required)
  ##                 : The name of the file server within the specified resource group. File server names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575352 = newJObject()
  var query_575353 = newJObject()
  add(path_575352, "resourceGroupName", newJString(resourceGroupName))
  add(query_575353, "api-version", newJString(apiVersion))
  add(path_575352, "subscriptionId", newJString(subscriptionId))
  add(path_575352, "fileServerName", newJString(fileServerName))
  add(path_575352, "workspaceName", newJString(workspaceName))
  result = call_575351.call(path_575352, query_575353, nil, nil, nil)

var fileServersGet* = Call_FileServersGet_575342(name: "fileServersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/fileServers/{fileServerName}",
    validator: validate_FileServersGet_575343, base: "", url: url_FileServersGet_575344,
    schemes: {Scheme.Https})
type
  Call_FileServersDelete_575368 = ref object of OpenApiRestCall_574467
proc url_FileServersDelete_575370(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/fileServers/"),
               (kind: VariableSegment, value: "fileServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersDelete_575369(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a File Server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   fileServerName: JString (required)
  ##                 : The name of the file server within the specified resource group. File server names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575371 = path.getOrDefault("resourceGroupName")
  valid_575371 = validateParameter(valid_575371, JString, required = true,
                                 default = nil)
  if valid_575371 != nil:
    section.add "resourceGroupName", valid_575371
  var valid_575372 = path.getOrDefault("subscriptionId")
  valid_575372 = validateParameter(valid_575372, JString, required = true,
                                 default = nil)
  if valid_575372 != nil:
    section.add "subscriptionId", valid_575372
  var valid_575373 = path.getOrDefault("fileServerName")
  valid_575373 = validateParameter(valid_575373, JString, required = true,
                                 default = nil)
  if valid_575373 != nil:
    section.add "fileServerName", valid_575373
  var valid_575374 = path.getOrDefault("workspaceName")
  valid_575374 = validateParameter(valid_575374, JString, required = true,
                                 default = nil)
  if valid_575374 != nil:
    section.add "workspaceName", valid_575374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575375 = query.getOrDefault("api-version")
  valid_575375 = validateParameter(valid_575375, JString, required = true,
                                 default = nil)
  if valid_575375 != nil:
    section.add "api-version", valid_575375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575376: Call_FileServersDelete_575368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a File Server.
  ## 
  let valid = call_575376.validator(path, query, header, formData, body)
  let scheme = call_575376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575376.url(scheme.get, call_575376.host, call_575376.base,
                         call_575376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575376, url, valid)

proc call*(call_575377: Call_FileServersDelete_575368; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; fileServerName: string;
          workspaceName: string): Recallable =
  ## fileServersDelete
  ## Deletes a File Server.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   fileServerName: string (required)
  ##                 : The name of the file server within the specified resource group. File server names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   workspaceName: string (required)
  ##                : The name of the workspace. Workspace names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575378 = newJObject()
  var query_575379 = newJObject()
  add(path_575378, "resourceGroupName", newJString(resourceGroupName))
  add(query_575379, "api-version", newJString(apiVersion))
  add(path_575378, "subscriptionId", newJString(subscriptionId))
  add(path_575378, "fileServerName", newJString(fileServerName))
  add(path_575378, "workspaceName", newJString(workspaceName))
  result = call_575377.call(path_575378, query_575379, nil, nil, nil)

var fileServersDelete* = Call_FileServersDelete_575368(name: "fileServersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/workspaces/{workspaceName}/fileServers/{fileServerName}",
    validator: validate_FileServersDelete_575369, base: "",
    url: url_FileServersDelete_575370, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
