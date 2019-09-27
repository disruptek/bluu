
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: LogicManagementClient
## version: 2015-02-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## REST API for Azure Logic Apps.
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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
  macServiceName = "logic"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_WorkflowsListBySubscription_593643 = ref object of OpenApiRestCall_593421
proc url_WorkflowsListBySubscription_593645(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsListBySubscription_593644(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of workflows by subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593819 = path.getOrDefault("subscriptionId")
  valid_593819 = validateParameter(valid_593819, JString, required = true,
                                 default = nil)
  if valid_593819 != nil:
    section.add "subscriptionId", valid_593819
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593820 = query.getOrDefault("api-version")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "api-version", valid_593820
  var valid_593821 = query.getOrDefault("$top")
  valid_593821 = validateParameter(valid_593821, JInt, required = false, default = nil)
  if valid_593821 != nil:
    section.add "$top", valid_593821
  var valid_593822 = query.getOrDefault("$filter")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "$filter", valid_593822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_WorkflowsListBySubscription_593643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflows by subscription.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_WorkflowsListBySubscription_593643;
          apiVersion: string; subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## workflowsListBySubscription
  ## Gets a list of workflows by subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_593917 = newJObject()
  var query_593919 = newJObject()
  add(query_593919, "api-version", newJString(apiVersion))
  add(path_593917, "subscriptionId", newJString(subscriptionId))
  add(query_593919, "$top", newJInt(Top))
  add(query_593919, "$filter", newJString(Filter))
  result = call_593916.call(path_593917, query_593919, nil, nil, nil)

var workflowsListBySubscription* = Call_WorkflowsListBySubscription_593643(
    name: "workflowsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Logic/workflows",
    validator: validate_WorkflowsListBySubscription_593644, base: "",
    url: url_WorkflowsListBySubscription_593645, schemes: {Scheme.Https})
type
  Call_WorkflowsListByResourceGroup_593958 = ref object of OpenApiRestCall_593421
proc url_WorkflowsListByResourceGroup_593960(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsListByResourceGroup_593959(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of workflows by resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593961 = path.getOrDefault("resourceGroupName")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "resourceGroupName", valid_593961
  var valid_593962 = path.getOrDefault("subscriptionId")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "subscriptionId", valid_593962
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593963 = query.getOrDefault("api-version")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "api-version", valid_593963
  var valid_593964 = query.getOrDefault("$top")
  valid_593964 = validateParameter(valid_593964, JInt, required = false, default = nil)
  if valid_593964 != nil:
    section.add "$top", valid_593964
  var valid_593965 = query.getOrDefault("$filter")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "$filter", valid_593965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_WorkflowsListByResourceGroup_593958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflows by resource group.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_WorkflowsListByResourceGroup_593958;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## workflowsListByResourceGroup
  ## Gets a list of workflows by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_593968 = newJObject()
  var query_593969 = newJObject()
  add(path_593968, "resourceGroupName", newJString(resourceGroupName))
  add(query_593969, "api-version", newJString(apiVersion))
  add(path_593968, "subscriptionId", newJString(subscriptionId))
  add(query_593969, "$top", newJInt(Top))
  add(query_593969, "$filter", newJString(Filter))
  result = call_593967.call(path_593968, query_593969, nil, nil, nil)

var workflowsListByResourceGroup* = Call_WorkflowsListByResourceGroup_593958(
    name: "workflowsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows",
    validator: validate_WorkflowsListByResourceGroup_593959, base: "",
    url: url_WorkflowsListByResourceGroup_593960, schemes: {Scheme.Https})
type
  Call_WorkflowsCreateOrUpdate_593981 = ref object of OpenApiRestCall_593421
proc url_WorkflowsCreateOrUpdate_593983(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsCreateOrUpdate_593982(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_593984 = path.getOrDefault("workflowName")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "workflowName", valid_593984
  var valid_593985 = path.getOrDefault("resourceGroupName")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "resourceGroupName", valid_593985
  var valid_593986 = path.getOrDefault("subscriptionId")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "subscriptionId", valid_593986
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593987 = query.getOrDefault("api-version")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "api-version", valid_593987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   workflow: JObject (required)
  ##           : The workflow.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593989: Call_WorkflowsCreateOrUpdate_593981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a workflow.
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_WorkflowsCreateOrUpdate_593981; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workflow: JsonNode): Recallable =
  ## workflowsCreateOrUpdate
  ## Creates or updates a workflow.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   workflow: JObject (required)
  ##           : The workflow.
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  var body_593993 = newJObject()
  add(path_593991, "workflowName", newJString(workflowName))
  add(path_593991, "resourceGroupName", newJString(resourceGroupName))
  add(query_593992, "api-version", newJString(apiVersion))
  add(path_593991, "subscriptionId", newJString(subscriptionId))
  if workflow != nil:
    body_593993 = workflow
  result = call_593990.call(path_593991, query_593992, nil, nil, body_593993)

var workflowsCreateOrUpdate* = Call_WorkflowsCreateOrUpdate_593981(
    name: "workflowsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsCreateOrUpdate_593982, base: "",
    url: url_WorkflowsCreateOrUpdate_593983, schemes: {Scheme.Https})
type
  Call_WorkflowsGet_593970 = ref object of OpenApiRestCall_593421
proc url_WorkflowsGet_593972(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsGet_593971(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_593973 = path.getOrDefault("workflowName")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "workflowName", valid_593973
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "api-version", valid_593976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593977: Call_WorkflowsGet_593970; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow.
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_WorkflowsGet_593970; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## workflowsGet
  ## Gets a workflow.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_593979 = newJObject()
  var query_593980 = newJObject()
  add(path_593979, "workflowName", newJString(workflowName))
  add(path_593979, "resourceGroupName", newJString(resourceGroupName))
  add(query_593980, "api-version", newJString(apiVersion))
  add(path_593979, "subscriptionId", newJString(subscriptionId))
  result = call_593978.call(path_593979, query_593980, nil, nil, nil)

var workflowsGet* = Call_WorkflowsGet_593970(name: "workflowsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsGet_593971, base: "", url: url_WorkflowsGet_593972,
    schemes: {Scheme.Https})
type
  Call_WorkflowsUpdate_594005 = ref object of OpenApiRestCall_593421
proc url_WorkflowsUpdate_594007(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsUpdate_594006(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594008 = path.getOrDefault("workflowName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "workflowName", valid_594008
  var valid_594009 = path.getOrDefault("resourceGroupName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "resourceGroupName", valid_594009
  var valid_594010 = path.getOrDefault("subscriptionId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "subscriptionId", valid_594010
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594011 = query.getOrDefault("api-version")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "api-version", valid_594011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   workflow: JObject (required)
  ##           : The workflow.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594013: Call_WorkflowsUpdate_594005; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a workflow.
  ## 
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_WorkflowsUpdate_594005; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workflow: JsonNode): Recallable =
  ## workflowsUpdate
  ## Updates a workflow.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   workflow: JObject (required)
  ##           : The workflow.
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  var body_594017 = newJObject()
  add(path_594015, "workflowName", newJString(workflowName))
  add(path_594015, "resourceGroupName", newJString(resourceGroupName))
  add(query_594016, "api-version", newJString(apiVersion))
  add(path_594015, "subscriptionId", newJString(subscriptionId))
  if workflow != nil:
    body_594017 = workflow
  result = call_594014.call(path_594015, query_594016, nil, nil, body_594017)

var workflowsUpdate* = Call_WorkflowsUpdate_594005(name: "workflowsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsUpdate_594006, base: "", url: url_WorkflowsUpdate_594007,
    schemes: {Scheme.Https})
type
  Call_WorkflowsDelete_593994 = ref object of OpenApiRestCall_593421
proc url_WorkflowsDelete_593996(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsDelete_593995(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_593997 = path.getOrDefault("workflowName")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "workflowName", valid_593997
  var valid_593998 = path.getOrDefault("resourceGroupName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "resourceGroupName", valid_593998
  var valid_593999 = path.getOrDefault("subscriptionId")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "subscriptionId", valid_593999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594000 = query.getOrDefault("api-version")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "api-version", valid_594000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594001: Call_WorkflowsDelete_593994; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a workflow.
  ## 
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_WorkflowsDelete_593994; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## workflowsDelete
  ## Deletes a workflow.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_594003 = newJObject()
  var query_594004 = newJObject()
  add(path_594003, "workflowName", newJString(workflowName))
  add(path_594003, "resourceGroupName", newJString(resourceGroupName))
  add(query_594004, "api-version", newJString(apiVersion))
  add(path_594003, "subscriptionId", newJString(subscriptionId))
  result = call_594002.call(path_594003, query_594004, nil, nil, nil)

var workflowsDelete* = Call_WorkflowsDelete_593994(name: "workflowsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsDelete_593995, base: "", url: url_WorkflowsDelete_593996,
    schemes: {Scheme.Https})
type
  Call_WorkflowAccessKeysList_594018 = ref object of OpenApiRestCall_593421
proc url_WorkflowAccessKeysList_594020(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/accessKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowAccessKeysList_594019(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of workflow access keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594021 = path.getOrDefault("workflowName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "workflowName", valid_594021
  var valid_594022 = path.getOrDefault("resourceGroupName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "resourceGroupName", valid_594022
  var valid_594023 = path.getOrDefault("subscriptionId")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "subscriptionId", valid_594023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594024 = query.getOrDefault("api-version")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "api-version", valid_594024
  var valid_594025 = query.getOrDefault("$top")
  valid_594025 = validateParameter(valid_594025, JInt, required = false, default = nil)
  if valid_594025 != nil:
    section.add "$top", valid_594025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_WorkflowAccessKeysList_594018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow access keys.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_WorkflowAccessKeysList_594018; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0): Recallable =
  ## workflowAccessKeysList
  ## Gets a list of workflow access keys.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(path_594028, "workflowName", newJString(workflowName))
  add(path_594028, "resourceGroupName", newJString(resourceGroupName))
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "subscriptionId", newJString(subscriptionId))
  add(query_594029, "$top", newJInt(Top))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var workflowAccessKeysList* = Call_WorkflowAccessKeysList_594018(
    name: "workflowAccessKeysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/accessKeys",
    validator: validate_WorkflowAccessKeysList_594019, base: "",
    url: url_WorkflowAccessKeysList_594020, schemes: {Scheme.Https})
type
  Call_WorkflowAccessKeysCreateOrUpdate_594042 = ref object of OpenApiRestCall_593421
proc url_WorkflowAccessKeysCreateOrUpdate_594044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  assert "accessKeyName" in path, "`accessKeyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/accessKeys/"),
               (kind: VariableSegment, value: "accessKeyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowAccessKeysCreateOrUpdate_594043(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a workflow access key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   accessKeyName: JString (required)
  ##                : The workflow access key name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594045 = path.getOrDefault("workflowName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "workflowName", valid_594045
  var valid_594046 = path.getOrDefault("resourceGroupName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "resourceGroupName", valid_594046
  var valid_594047 = path.getOrDefault("subscriptionId")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "subscriptionId", valid_594047
  var valid_594048 = path.getOrDefault("accessKeyName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "accessKeyName", valid_594048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594049 = query.getOrDefault("api-version")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "api-version", valid_594049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   workflowAccesskey: JObject (required)
  ##                    : The workflow access key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594051: Call_WorkflowAccessKeysCreateOrUpdate_594042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a workflow access key.
  ## 
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_WorkflowAccessKeysCreateOrUpdate_594042;
          workflowName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; workflowAccesskey: JsonNode; accessKeyName: string): Recallable =
  ## workflowAccessKeysCreateOrUpdate
  ## Creates or updates a workflow access key.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   workflowAccesskey: JObject (required)
  ##                    : The workflow access key.
  ##   accessKeyName: string (required)
  ##                : The workflow access key name.
  var path_594053 = newJObject()
  var query_594054 = newJObject()
  var body_594055 = newJObject()
  add(path_594053, "workflowName", newJString(workflowName))
  add(path_594053, "resourceGroupName", newJString(resourceGroupName))
  add(query_594054, "api-version", newJString(apiVersion))
  add(path_594053, "subscriptionId", newJString(subscriptionId))
  if workflowAccesskey != nil:
    body_594055 = workflowAccesskey
  add(path_594053, "accessKeyName", newJString(accessKeyName))
  result = call_594052.call(path_594053, query_594054, nil, nil, body_594055)

var workflowAccessKeysCreateOrUpdate* = Call_WorkflowAccessKeysCreateOrUpdate_594042(
    name: "workflowAccessKeysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/accessKeys/{accessKeyName}",
    validator: validate_WorkflowAccessKeysCreateOrUpdate_594043, base: "",
    url: url_WorkflowAccessKeysCreateOrUpdate_594044, schemes: {Scheme.Https})
type
  Call_WorkflowAccessKeysGet_594030 = ref object of OpenApiRestCall_593421
proc url_WorkflowAccessKeysGet_594032(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  assert "accessKeyName" in path, "`accessKeyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/accessKeys/"),
               (kind: VariableSegment, value: "accessKeyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowAccessKeysGet_594031(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a workflow access key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   accessKeyName: JString (required)
  ##                : The workflow access key name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594033 = path.getOrDefault("workflowName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "workflowName", valid_594033
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
  var valid_594036 = path.getOrDefault("accessKeyName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "accessKeyName", valid_594036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_594038: Call_WorkflowAccessKeysGet_594030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow access key.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_WorkflowAccessKeysGet_594030; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accessKeyName: string): Recallable =
  ## workflowAccessKeysGet
  ## Gets a workflow access key.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   accessKeyName: string (required)
  ##                : The workflow access key name.
  var path_594040 = newJObject()
  var query_594041 = newJObject()
  add(path_594040, "workflowName", newJString(workflowName))
  add(path_594040, "resourceGroupName", newJString(resourceGroupName))
  add(query_594041, "api-version", newJString(apiVersion))
  add(path_594040, "subscriptionId", newJString(subscriptionId))
  add(path_594040, "accessKeyName", newJString(accessKeyName))
  result = call_594039.call(path_594040, query_594041, nil, nil, nil)

var workflowAccessKeysGet* = Call_WorkflowAccessKeysGet_594030(
    name: "workflowAccessKeysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/accessKeys/{accessKeyName}",
    validator: validate_WorkflowAccessKeysGet_594031, base: "",
    url: url_WorkflowAccessKeysGet_594032, schemes: {Scheme.Https})
type
  Call_WorkflowAccessKeysDelete_594056 = ref object of OpenApiRestCall_593421
proc url_WorkflowAccessKeysDelete_594058(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  assert "accessKeyName" in path, "`accessKeyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/accessKeys/"),
               (kind: VariableSegment, value: "accessKeyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowAccessKeysDelete_594057(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a workflow access key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   accessKeyName: JString (required)
  ##                : The workflow access key name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594059 = path.getOrDefault("workflowName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "workflowName", valid_594059
  var valid_594060 = path.getOrDefault("resourceGroupName")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "resourceGroupName", valid_594060
  var valid_594061 = path.getOrDefault("subscriptionId")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "subscriptionId", valid_594061
  var valid_594062 = path.getOrDefault("accessKeyName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "accessKeyName", valid_594062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_594064: Call_WorkflowAccessKeysDelete_594056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a workflow access key.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_WorkflowAccessKeysDelete_594056; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accessKeyName: string): Recallable =
  ## workflowAccessKeysDelete
  ## Deletes a workflow access key.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   accessKeyName: string (required)
  ##                : The workflow access key name.
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  add(path_594066, "workflowName", newJString(workflowName))
  add(path_594066, "resourceGroupName", newJString(resourceGroupName))
  add(query_594067, "api-version", newJString(apiVersion))
  add(path_594066, "subscriptionId", newJString(subscriptionId))
  add(path_594066, "accessKeyName", newJString(accessKeyName))
  result = call_594065.call(path_594066, query_594067, nil, nil, nil)

var workflowAccessKeysDelete* = Call_WorkflowAccessKeysDelete_594056(
    name: "workflowAccessKeysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/accessKeys/{accessKeyName}",
    validator: validate_WorkflowAccessKeysDelete_594057, base: "",
    url: url_WorkflowAccessKeysDelete_594058, schemes: {Scheme.Https})
type
  Call_WorkflowAccessKeysListSecretKeys_594068 = ref object of OpenApiRestCall_593421
proc url_WorkflowAccessKeysListSecretKeys_594070(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  assert "accessKeyName" in path, "`accessKeyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/accessKeys/"),
               (kind: VariableSegment, value: "accessKeyName"),
               (kind: ConstantSegment, value: "/list")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowAccessKeysListSecretKeys_594069(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists secret keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   accessKeyName: JString (required)
  ##                : The workflow access key name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594071 = path.getOrDefault("workflowName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "workflowName", valid_594071
  var valid_594072 = path.getOrDefault("resourceGroupName")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "resourceGroupName", valid_594072
  var valid_594073 = path.getOrDefault("subscriptionId")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "subscriptionId", valid_594073
  var valid_594074 = path.getOrDefault("accessKeyName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "accessKeyName", valid_594074
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_594076: Call_WorkflowAccessKeysListSecretKeys_594068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists secret keys.
  ## 
  let valid = call_594076.validator(path, query, header, formData, body)
  let scheme = call_594076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594076.url(scheme.get, call_594076.host, call_594076.base,
                         call_594076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594076, url, valid)

proc call*(call_594077: Call_WorkflowAccessKeysListSecretKeys_594068;
          workflowName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; accessKeyName: string): Recallable =
  ## workflowAccessKeysListSecretKeys
  ## Lists secret keys.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   accessKeyName: string (required)
  ##                : The workflow access key name.
  var path_594078 = newJObject()
  var query_594079 = newJObject()
  add(path_594078, "workflowName", newJString(workflowName))
  add(path_594078, "resourceGroupName", newJString(resourceGroupName))
  add(query_594079, "api-version", newJString(apiVersion))
  add(path_594078, "subscriptionId", newJString(subscriptionId))
  add(path_594078, "accessKeyName", newJString(accessKeyName))
  result = call_594077.call(path_594078, query_594079, nil, nil, nil)

var workflowAccessKeysListSecretKeys* = Call_WorkflowAccessKeysListSecretKeys_594068(
    name: "workflowAccessKeysListSecretKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/accessKeys/{accessKeyName}/list",
    validator: validate_WorkflowAccessKeysListSecretKeys_594069, base: "",
    url: url_WorkflowAccessKeysListSecretKeys_594070, schemes: {Scheme.Https})
type
  Call_WorkflowAccessKeysRegenerateSecretKey_594080 = ref object of OpenApiRestCall_593421
proc url_WorkflowAccessKeysRegenerateSecretKey_594082(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  assert "accessKeyName" in path, "`accessKeyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/accessKeys/"),
               (kind: VariableSegment, value: "accessKeyName"),
               (kind: ConstantSegment, value: "/regenerate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowAccessKeysRegenerateSecretKey_594081(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates secret key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   accessKeyName: JString (required)
  ##                : The workflow access key name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594083 = path.getOrDefault("workflowName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "workflowName", valid_594083
  var valid_594084 = path.getOrDefault("resourceGroupName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "resourceGroupName", valid_594084
  var valid_594085 = path.getOrDefault("subscriptionId")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "subscriptionId", valid_594085
  var valid_594086 = path.getOrDefault("accessKeyName")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "accessKeyName", valid_594086
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594087 = query.getOrDefault("api-version")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "api-version", valid_594087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594089: Call_WorkflowAccessKeysRegenerateSecretKey_594080;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates secret key.
  ## 
  let valid = call_594089.validator(path, query, header, formData, body)
  let scheme = call_594089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594089.url(scheme.get, call_594089.host, call_594089.base,
                         call_594089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594089, url, valid)

proc call*(call_594090: Call_WorkflowAccessKeysRegenerateSecretKey_594080;
          workflowName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; accessKeyName: string): Recallable =
  ## workflowAccessKeysRegenerateSecretKey
  ## Regenerates secret key.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   parameters: JObject (required)
  ##             : The parameters.
  ##   accessKeyName: string (required)
  ##                : The workflow access key name.
  var path_594091 = newJObject()
  var query_594092 = newJObject()
  var body_594093 = newJObject()
  add(path_594091, "workflowName", newJString(workflowName))
  add(path_594091, "resourceGroupName", newJString(resourceGroupName))
  add(query_594092, "api-version", newJString(apiVersion))
  add(path_594091, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594093 = parameters
  add(path_594091, "accessKeyName", newJString(accessKeyName))
  result = call_594090.call(path_594091, query_594092, nil, nil, body_594093)

var workflowAccessKeysRegenerateSecretKey* = Call_WorkflowAccessKeysRegenerateSecretKey_594080(
    name: "workflowAccessKeysRegenerateSecretKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/accessKeys/{accessKeyName}/regenerate",
    validator: validate_WorkflowAccessKeysRegenerateSecretKey_594081, base: "",
    url: url_WorkflowAccessKeysRegenerateSecretKey_594082, schemes: {Scheme.Https})
type
  Call_WorkflowsDisable_594094 = ref object of OpenApiRestCall_593421
proc url_WorkflowsDisable_594096(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/disable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsDisable_594095(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Disables a workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594097 = path.getOrDefault("workflowName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "workflowName", valid_594097
  var valid_594098 = path.getOrDefault("resourceGroupName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "resourceGroupName", valid_594098
  var valid_594099 = path.getOrDefault("subscriptionId")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "subscriptionId", valid_594099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594100 = query.getOrDefault("api-version")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "api-version", valid_594100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594101: Call_WorkflowsDisable_594094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disables a workflow.
  ## 
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_WorkflowsDisable_594094; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## workflowsDisable
  ## Disables a workflow.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  add(path_594103, "workflowName", newJString(workflowName))
  add(path_594103, "resourceGroupName", newJString(resourceGroupName))
  add(query_594104, "api-version", newJString(apiVersion))
  add(path_594103, "subscriptionId", newJString(subscriptionId))
  result = call_594102.call(path_594103, query_594104, nil, nil, nil)

var workflowsDisable* = Call_WorkflowsDisable_594094(name: "workflowsDisable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/disable",
    validator: validate_WorkflowsDisable_594095, base: "",
    url: url_WorkflowsDisable_594096, schemes: {Scheme.Https})
type
  Call_WorkflowsEnable_594105 = ref object of OpenApiRestCall_593421
proc url_WorkflowsEnable_594107(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/enable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsEnable_594106(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Enables a workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594108 = path.getOrDefault("workflowName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "workflowName", valid_594108
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594111 = query.getOrDefault("api-version")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "api-version", valid_594111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594112: Call_WorkflowsEnable_594105; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables a workflow.
  ## 
  let valid = call_594112.validator(path, query, header, formData, body)
  let scheme = call_594112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594112.url(scheme.get, call_594112.host, call_594112.base,
                         call_594112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594112, url, valid)

proc call*(call_594113: Call_WorkflowsEnable_594105; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## workflowsEnable
  ## Enables a workflow.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_594114 = newJObject()
  var query_594115 = newJObject()
  add(path_594114, "workflowName", newJString(workflowName))
  add(path_594114, "resourceGroupName", newJString(resourceGroupName))
  add(query_594115, "api-version", newJString(apiVersion))
  add(path_594114, "subscriptionId", newJString(subscriptionId))
  result = call_594113.call(path_594114, query_594115, nil, nil, nil)

var workflowsEnable* = Call_WorkflowsEnable_594105(name: "workflowsEnable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/enable",
    validator: validate_WorkflowsEnable_594106, base: "", url: url_WorkflowsEnable_594107,
    schemes: {Scheme.Https})
type
  Call_WorkflowsRun_594116 = ref object of OpenApiRestCall_593421
proc url_WorkflowsRun_594118(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsRun_594117(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Runs a workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594119 = path.getOrDefault("workflowName")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "workflowName", valid_594119
  var valid_594120 = path.getOrDefault("resourceGroupName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "resourceGroupName", valid_594120
  var valid_594121 = path.getOrDefault("subscriptionId")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "subscriptionId", valid_594121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594122 = query.getOrDefault("api-version")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "api-version", valid_594122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594124: Call_WorkflowsRun_594116; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a workflow.
  ## 
  let valid = call_594124.validator(path, query, header, formData, body)
  let scheme = call_594124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594124.url(scheme.get, call_594124.host, call_594124.base,
                         call_594124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594124, url, valid)

proc call*(call_594125: Call_WorkflowsRun_594116; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## workflowsRun
  ## Runs a workflow.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   parameters: JObject (required)
  ##             : The parameters.
  var path_594126 = newJObject()
  var query_594127 = newJObject()
  var body_594128 = newJObject()
  add(path_594126, "workflowName", newJString(workflowName))
  add(path_594126, "resourceGroupName", newJString(resourceGroupName))
  add(query_594127, "api-version", newJString(apiVersion))
  add(path_594126, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594128 = parameters
  result = call_594125.call(path_594126, query_594127, nil, nil, body_594128)

var workflowsRun* = Call_WorkflowsRun_594116(name: "workflowsRun",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/run",
    validator: validate_WorkflowsRun_594117, base: "", url: url_WorkflowsRun_594118,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunsList_594129 = ref object of OpenApiRestCall_593421
proc url_WorkflowRunsList_594131(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/runs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowRunsList_594130(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a list of workflow runs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594132 = path.getOrDefault("workflowName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "workflowName", valid_594132
  var valid_594133 = path.getOrDefault("resourceGroupName")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "resourceGroupName", valid_594133
  var valid_594134 = path.getOrDefault("subscriptionId")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "subscriptionId", valid_594134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594135 = query.getOrDefault("api-version")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "api-version", valid_594135
  var valid_594136 = query.getOrDefault("$top")
  valid_594136 = validateParameter(valid_594136, JInt, required = false, default = nil)
  if valid_594136 != nil:
    section.add "$top", valid_594136
  var valid_594137 = query.getOrDefault("$filter")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "$filter", valid_594137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594138: Call_WorkflowRunsList_594129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow runs.
  ## 
  let valid = call_594138.validator(path, query, header, formData, body)
  let scheme = call_594138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594138.url(scheme.get, call_594138.host, call_594138.base,
                         call_594138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594138, url, valid)

proc call*(call_594139: Call_WorkflowRunsList_594129; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## workflowRunsList
  ## Gets a list of workflow runs.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594140 = newJObject()
  var query_594141 = newJObject()
  add(path_594140, "workflowName", newJString(workflowName))
  add(path_594140, "resourceGroupName", newJString(resourceGroupName))
  add(query_594141, "api-version", newJString(apiVersion))
  add(path_594140, "subscriptionId", newJString(subscriptionId))
  add(query_594141, "$top", newJInt(Top))
  add(query_594141, "$filter", newJString(Filter))
  result = call_594139.call(path_594140, query_594141, nil, nil, nil)

var workflowRunsList* = Call_WorkflowRunsList_594129(name: "workflowRunsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs",
    validator: validate_WorkflowRunsList_594130, base: "",
    url: url_WorkflowRunsList_594131, schemes: {Scheme.Https})
type
  Call_WorkflowRunsGet_594142 = ref object of OpenApiRestCall_593421
proc url_WorkflowRunsGet_594144(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  assert "runName" in path, "`runName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowRunsGet_594143(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a workflow run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594145 = path.getOrDefault("workflowName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "workflowName", valid_594145
  var valid_594146 = path.getOrDefault("resourceGroupName")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "resourceGroupName", valid_594146
  var valid_594147 = path.getOrDefault("runName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "runName", valid_594147
  var valid_594148 = path.getOrDefault("subscriptionId")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "subscriptionId", valid_594148
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594149 = query.getOrDefault("api-version")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "api-version", valid_594149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594150: Call_WorkflowRunsGet_594142; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow run.
  ## 
  let valid = call_594150.validator(path, query, header, formData, body)
  let scheme = call_594150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594150.url(scheme.get, call_594150.host, call_594150.base,
                         call_594150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594150, url, valid)

proc call*(call_594151: Call_WorkflowRunsGet_594142; workflowName: string;
          resourceGroupName: string; runName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## workflowRunsGet
  ## Gets a workflow run.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_594152 = newJObject()
  var query_594153 = newJObject()
  add(path_594152, "workflowName", newJString(workflowName))
  add(path_594152, "resourceGroupName", newJString(resourceGroupName))
  add(path_594152, "runName", newJString(runName))
  add(query_594153, "api-version", newJString(apiVersion))
  add(path_594152, "subscriptionId", newJString(subscriptionId))
  result = call_594151.call(path_594152, query_594153, nil, nil, nil)

var workflowRunsGet* = Call_WorkflowRunsGet_594142(name: "workflowRunsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}",
    validator: validate_WorkflowRunsGet_594143, base: "", url: url_WorkflowRunsGet_594144,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsList_594154 = ref object of OpenApiRestCall_593421
proc url_WorkflowRunActionsList_594156(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  assert "runName" in path, "`runName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runName"),
               (kind: ConstantSegment, value: "/actions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowRunActionsList_594155(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of workflow run actions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594157 = path.getOrDefault("workflowName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "workflowName", valid_594157
  var valid_594158 = path.getOrDefault("resourceGroupName")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "resourceGroupName", valid_594158
  var valid_594159 = path.getOrDefault("runName")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "runName", valid_594159
  var valid_594160 = path.getOrDefault("subscriptionId")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "subscriptionId", valid_594160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594161 = query.getOrDefault("api-version")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "api-version", valid_594161
  var valid_594162 = query.getOrDefault("$top")
  valid_594162 = validateParameter(valid_594162, JInt, required = false, default = nil)
  if valid_594162 != nil:
    section.add "$top", valid_594162
  var valid_594163 = query.getOrDefault("$filter")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "$filter", valid_594163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594164: Call_WorkflowRunActionsList_594154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow run actions.
  ## 
  let valid = call_594164.validator(path, query, header, formData, body)
  let scheme = call_594164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594164.url(scheme.get, call_594164.host, call_594164.base,
                         call_594164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594164, url, valid)

proc call*(call_594165: Call_WorkflowRunActionsList_594154; workflowName: string;
          resourceGroupName: string; runName: string; apiVersion: string;
          subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## workflowRunActionsList
  ## Gets a list of workflow run actions.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594166 = newJObject()
  var query_594167 = newJObject()
  add(path_594166, "workflowName", newJString(workflowName))
  add(path_594166, "resourceGroupName", newJString(resourceGroupName))
  add(path_594166, "runName", newJString(runName))
  add(query_594167, "api-version", newJString(apiVersion))
  add(path_594166, "subscriptionId", newJString(subscriptionId))
  add(query_594167, "$top", newJInt(Top))
  add(query_594167, "$filter", newJString(Filter))
  result = call_594165.call(path_594166, query_594167, nil, nil, nil)

var workflowRunActionsList* = Call_WorkflowRunActionsList_594154(
    name: "workflowRunActionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions",
    validator: validate_WorkflowRunActionsList_594155, base: "",
    url: url_WorkflowRunActionsList_594156, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsGet_594168 = ref object of OpenApiRestCall_593421
proc url_WorkflowRunActionsGet_594170(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  assert "runName" in path, "`runName` is a required path parameter"
  assert "actionName" in path, "`actionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runName"),
               (kind: ConstantSegment, value: "/actions/"),
               (kind: VariableSegment, value: "actionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowRunActionsGet_594169(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a workflow run action.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   actionName: JString (required)
  ##             : The workflow action name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594171 = path.getOrDefault("workflowName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "workflowName", valid_594171
  var valid_594172 = path.getOrDefault("actionName")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "actionName", valid_594172
  var valid_594173 = path.getOrDefault("resourceGroupName")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "resourceGroupName", valid_594173
  var valid_594174 = path.getOrDefault("runName")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "runName", valid_594174
  var valid_594175 = path.getOrDefault("subscriptionId")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "subscriptionId", valid_594175
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594176 = query.getOrDefault("api-version")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "api-version", valid_594176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594177: Call_WorkflowRunActionsGet_594168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow run action.
  ## 
  let valid = call_594177.validator(path, query, header, formData, body)
  let scheme = call_594177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594177.url(scheme.get, call_594177.host, call_594177.base,
                         call_594177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594177, url, valid)

proc call*(call_594178: Call_WorkflowRunActionsGet_594168; workflowName: string;
          actionName: string; resourceGroupName: string; runName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## workflowRunActionsGet
  ## Gets a workflow run action.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   actionName: string (required)
  ##             : The workflow action name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_594179 = newJObject()
  var query_594180 = newJObject()
  add(path_594179, "workflowName", newJString(workflowName))
  add(path_594179, "actionName", newJString(actionName))
  add(path_594179, "resourceGroupName", newJString(resourceGroupName))
  add(path_594179, "runName", newJString(runName))
  add(query_594180, "api-version", newJString(apiVersion))
  add(path_594179, "subscriptionId", newJString(subscriptionId))
  result = call_594178.call(path_594179, query_594180, nil, nil, nil)

var workflowRunActionsGet* = Call_WorkflowRunActionsGet_594168(
    name: "workflowRunActionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}",
    validator: validate_WorkflowRunActionsGet_594169, base: "",
    url: url_WorkflowRunActionsGet_594170, schemes: {Scheme.Https})
type
  Call_WorkflowRunsCancel_594181 = ref object of OpenApiRestCall_593421
proc url_WorkflowRunsCancel_594183(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  assert "runName" in path, "`runName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowRunsCancel_594182(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Cancels a workflow run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594184 = path.getOrDefault("workflowName")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "workflowName", valid_594184
  var valid_594185 = path.getOrDefault("resourceGroupName")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "resourceGroupName", valid_594185
  var valid_594186 = path.getOrDefault("runName")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "runName", valid_594186
  var valid_594187 = path.getOrDefault("subscriptionId")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "subscriptionId", valid_594187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594188 = query.getOrDefault("api-version")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "api-version", valid_594188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594189: Call_WorkflowRunsCancel_594181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a workflow run.
  ## 
  let valid = call_594189.validator(path, query, header, formData, body)
  let scheme = call_594189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594189.url(scheme.get, call_594189.host, call_594189.base,
                         call_594189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594189, url, valid)

proc call*(call_594190: Call_WorkflowRunsCancel_594181; workflowName: string;
          resourceGroupName: string; runName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## workflowRunsCancel
  ## Cancels a workflow run.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_594191 = newJObject()
  var query_594192 = newJObject()
  add(path_594191, "workflowName", newJString(workflowName))
  add(path_594191, "resourceGroupName", newJString(resourceGroupName))
  add(path_594191, "runName", newJString(runName))
  add(query_594192, "api-version", newJString(apiVersion))
  add(path_594191, "subscriptionId", newJString(subscriptionId))
  result = call_594190.call(path_594191, query_594192, nil, nil, nil)

var workflowRunsCancel* = Call_WorkflowRunsCancel_594181(
    name: "workflowRunsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/cancel",
    validator: validate_WorkflowRunsCancel_594182, base: "",
    url: url_WorkflowRunsCancel_594183, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersList_594193 = ref object of OpenApiRestCall_593421
proc url_WorkflowTriggersList_594195(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/triggers/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowTriggersList_594194(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of workflow triggers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594196 = path.getOrDefault("workflowName")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "workflowName", valid_594196
  var valid_594197 = path.getOrDefault("resourceGroupName")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "resourceGroupName", valid_594197
  var valid_594198 = path.getOrDefault("subscriptionId")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "subscriptionId", valid_594198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594199 = query.getOrDefault("api-version")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "api-version", valid_594199
  var valid_594200 = query.getOrDefault("$top")
  valid_594200 = validateParameter(valid_594200, JInt, required = false, default = nil)
  if valid_594200 != nil:
    section.add "$top", valid_594200
  var valid_594201 = query.getOrDefault("$filter")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "$filter", valid_594201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594202: Call_WorkflowTriggersList_594193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow triggers.
  ## 
  let valid = call_594202.validator(path, query, header, formData, body)
  let scheme = call_594202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594202.url(scheme.get, call_594202.host, call_594202.base,
                         call_594202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594202, url, valid)

proc call*(call_594203: Call_WorkflowTriggersList_594193; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## workflowTriggersList
  ## Gets a list of workflow triggers.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594204 = newJObject()
  var query_594205 = newJObject()
  add(path_594204, "workflowName", newJString(workflowName))
  add(path_594204, "resourceGroupName", newJString(resourceGroupName))
  add(query_594205, "api-version", newJString(apiVersion))
  add(path_594204, "subscriptionId", newJString(subscriptionId))
  add(query_594205, "$top", newJInt(Top))
  add(query_594205, "$filter", newJString(Filter))
  result = call_594203.call(path_594204, query_594205, nil, nil, nil)

var workflowTriggersList* = Call_WorkflowTriggersList_594193(
    name: "workflowTriggersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/",
    validator: validate_WorkflowTriggersList_594194, base: "",
    url: url_WorkflowTriggersList_594195, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersGet_594206 = ref object of OpenApiRestCall_593421
proc url_WorkflowTriggersGet_594208(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowTriggersGet_594207(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets a workflow trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594209 = path.getOrDefault("workflowName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "workflowName", valid_594209
  var valid_594210 = path.getOrDefault("resourceGroupName")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "resourceGroupName", valid_594210
  var valid_594211 = path.getOrDefault("subscriptionId")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "subscriptionId", valid_594211
  var valid_594212 = path.getOrDefault("triggerName")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "triggerName", valid_594212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594213 = query.getOrDefault("api-version")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "api-version", valid_594213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594214: Call_WorkflowTriggersGet_594206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow trigger.
  ## 
  let valid = call_594214.validator(path, query, header, formData, body)
  let scheme = call_594214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594214.url(scheme.get, call_594214.host, call_594214.base,
                         call_594214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594214, url, valid)

proc call*(call_594215: Call_WorkflowTriggersGet_594206; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          triggerName: string): Recallable =
  ## workflowTriggersGet
  ## Gets a workflow trigger.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  var path_594216 = newJObject()
  var query_594217 = newJObject()
  add(path_594216, "workflowName", newJString(workflowName))
  add(path_594216, "resourceGroupName", newJString(resourceGroupName))
  add(query_594217, "api-version", newJString(apiVersion))
  add(path_594216, "subscriptionId", newJString(subscriptionId))
  add(path_594216, "triggerName", newJString(triggerName))
  result = call_594215.call(path_594216, query_594217, nil, nil, nil)

var workflowTriggersGet* = Call_WorkflowTriggersGet_594206(
    name: "workflowTriggersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}",
    validator: validate_WorkflowTriggersGet_594207, base: "",
    url: url_WorkflowTriggersGet_594208, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesList_594218 = ref object of OpenApiRestCall_593421
proc url_WorkflowTriggerHistoriesList_594220(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/histories")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowTriggerHistoriesList_594219(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of workflow trigger histories.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594221 = path.getOrDefault("workflowName")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "workflowName", valid_594221
  var valid_594222 = path.getOrDefault("resourceGroupName")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "resourceGroupName", valid_594222
  var valid_594223 = path.getOrDefault("subscriptionId")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "subscriptionId", valid_594223
  var valid_594224 = path.getOrDefault("triggerName")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "triggerName", valid_594224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594225 = query.getOrDefault("api-version")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "api-version", valid_594225
  var valid_594226 = query.getOrDefault("$top")
  valid_594226 = validateParameter(valid_594226, JInt, required = false, default = nil)
  if valid_594226 != nil:
    section.add "$top", valid_594226
  var valid_594227 = query.getOrDefault("$filter")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = nil)
  if valid_594227 != nil:
    section.add "$filter", valid_594227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594228: Call_WorkflowTriggerHistoriesList_594218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow trigger histories.
  ## 
  let valid = call_594228.validator(path, query, header, formData, body)
  let scheme = call_594228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594228.url(scheme.get, call_594228.host, call_594228.base,
                         call_594228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594228, url, valid)

proc call*(call_594229: Call_WorkflowTriggerHistoriesList_594218;
          workflowName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; triggerName: string; Top: int = 0; Filter: string = ""): Recallable =
  ## workflowTriggerHistoriesList
  ## Gets a list of workflow trigger histories.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594230 = newJObject()
  var query_594231 = newJObject()
  add(path_594230, "workflowName", newJString(workflowName))
  add(path_594230, "resourceGroupName", newJString(resourceGroupName))
  add(query_594231, "api-version", newJString(apiVersion))
  add(path_594230, "subscriptionId", newJString(subscriptionId))
  add(query_594231, "$top", newJInt(Top))
  add(path_594230, "triggerName", newJString(triggerName))
  add(query_594231, "$filter", newJString(Filter))
  result = call_594229.call(path_594230, query_594231, nil, nil, nil)

var workflowTriggerHistoriesList* = Call_WorkflowTriggerHistoriesList_594218(
    name: "workflowTriggerHistoriesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories",
    validator: validate_WorkflowTriggerHistoriesList_594219, base: "",
    url: url_WorkflowTriggerHistoriesList_594220, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesGet_594232 = ref object of OpenApiRestCall_593421
proc url_WorkflowTriggerHistoriesGet_594234(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  assert "historyName" in path, "`historyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowTriggerHistoriesGet_594233(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a workflow trigger history.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   historyName: JString (required)
  ##              : The workflow trigger history name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594235 = path.getOrDefault("workflowName")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "workflowName", valid_594235
  var valid_594236 = path.getOrDefault("resourceGroupName")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "resourceGroupName", valid_594236
  var valid_594237 = path.getOrDefault("historyName")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "historyName", valid_594237
  var valid_594238 = path.getOrDefault("subscriptionId")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "subscriptionId", valid_594238
  var valid_594239 = path.getOrDefault("triggerName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "triggerName", valid_594239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594240 = query.getOrDefault("api-version")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "api-version", valid_594240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594241: Call_WorkflowTriggerHistoriesGet_594232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow trigger history.
  ## 
  let valid = call_594241.validator(path, query, header, formData, body)
  let scheme = call_594241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594241.url(scheme.get, call_594241.host, call_594241.base,
                         call_594241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594241, url, valid)

proc call*(call_594242: Call_WorkflowTriggerHistoriesGet_594232;
          workflowName: string; resourceGroupName: string; apiVersion: string;
          historyName: string; subscriptionId: string; triggerName: string): Recallable =
  ## workflowTriggerHistoriesGet
  ## Gets a workflow trigger history.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   historyName: string (required)
  ##              : The workflow trigger history name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  var path_594243 = newJObject()
  var query_594244 = newJObject()
  add(path_594243, "workflowName", newJString(workflowName))
  add(path_594243, "resourceGroupName", newJString(resourceGroupName))
  add(query_594244, "api-version", newJString(apiVersion))
  add(path_594243, "historyName", newJString(historyName))
  add(path_594243, "subscriptionId", newJString(subscriptionId))
  add(path_594243, "triggerName", newJString(triggerName))
  result = call_594242.call(path_594243, query_594244, nil, nil, nil)

var workflowTriggerHistoriesGet* = Call_WorkflowTriggerHistoriesGet_594232(
    name: "workflowTriggerHistoriesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories/{historyName}",
    validator: validate_WorkflowTriggerHistoriesGet_594233, base: "",
    url: url_WorkflowTriggerHistoriesGet_594234, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersRun_594245 = ref object of OpenApiRestCall_593421
proc url_WorkflowTriggersRun_594247(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowTriggersRun_594246(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Runs a workflow trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594248 = path.getOrDefault("workflowName")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "workflowName", valid_594248
  var valid_594249 = path.getOrDefault("resourceGroupName")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "resourceGroupName", valid_594249
  var valid_594250 = path.getOrDefault("subscriptionId")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "subscriptionId", valid_594250
  var valid_594251 = path.getOrDefault("triggerName")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "triggerName", valid_594251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594252 = query.getOrDefault("api-version")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "api-version", valid_594252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594253: Call_WorkflowTriggersRun_594245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a workflow trigger.
  ## 
  let valid = call_594253.validator(path, query, header, formData, body)
  let scheme = call_594253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594253.url(scheme.get, call_594253.host, call_594253.base,
                         call_594253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594253, url, valid)

proc call*(call_594254: Call_WorkflowTriggersRun_594245; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          triggerName: string): Recallable =
  ## workflowTriggersRun
  ## Runs a workflow trigger.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  var path_594255 = newJObject()
  var query_594256 = newJObject()
  add(path_594255, "workflowName", newJString(workflowName))
  add(path_594255, "resourceGroupName", newJString(resourceGroupName))
  add(query_594256, "api-version", newJString(apiVersion))
  add(path_594255, "subscriptionId", newJString(subscriptionId))
  add(path_594255, "triggerName", newJString(triggerName))
  result = call_594254.call(path_594255, query_594256, nil, nil, nil)

var workflowTriggersRun* = Call_WorkflowTriggersRun_594245(
    name: "workflowTriggersRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/run",
    validator: validate_WorkflowTriggersRun_594246, base: "",
    url: url_WorkflowTriggersRun_594247, schemes: {Scheme.Https})
type
  Call_WorkflowsValidate_594257 = ref object of OpenApiRestCall_593421
proc url_WorkflowsValidate_594259(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsValidate_594258(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Validates a workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594260 = path.getOrDefault("workflowName")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "workflowName", valid_594260
  var valid_594261 = path.getOrDefault("resourceGroupName")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "resourceGroupName", valid_594261
  var valid_594262 = path.getOrDefault("subscriptionId")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "subscriptionId", valid_594262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594263 = query.getOrDefault("api-version")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "api-version", valid_594263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   workflow: JObject (required)
  ##           : The workflow.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594265: Call_WorkflowsValidate_594257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates a workflow.
  ## 
  let valid = call_594265.validator(path, query, header, formData, body)
  let scheme = call_594265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594265.url(scheme.get, call_594265.host, call_594265.base,
                         call_594265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594265, url, valid)

proc call*(call_594266: Call_WorkflowsValidate_594257; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workflow: JsonNode): Recallable =
  ## workflowsValidate
  ## Validates a workflow.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   workflow: JObject (required)
  ##           : The workflow.
  var path_594267 = newJObject()
  var query_594268 = newJObject()
  var body_594269 = newJObject()
  add(path_594267, "workflowName", newJString(workflowName))
  add(path_594267, "resourceGroupName", newJString(resourceGroupName))
  add(query_594268, "api-version", newJString(apiVersion))
  add(path_594267, "subscriptionId", newJString(subscriptionId))
  if workflow != nil:
    body_594269 = workflow
  result = call_594266.call(path_594267, query_594268, nil, nil, body_594269)

var workflowsValidate* = Call_WorkflowsValidate_594257(name: "workflowsValidate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/validate",
    validator: validate_WorkflowsValidate_594258, base: "",
    url: url_WorkflowsValidate_594259, schemes: {Scheme.Https})
type
  Call_WorkflowVersionsGet_594270 = ref object of OpenApiRestCall_593421
proc url_WorkflowVersionsGet_594272(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowVersionsGet_594271(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets a workflow version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   versionId: JString (required)
  ##            : The workflow versionId.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_594273 = path.getOrDefault("workflowName")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "workflowName", valid_594273
  var valid_594274 = path.getOrDefault("resourceGroupName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "resourceGroupName", valid_594274
  var valid_594275 = path.getOrDefault("versionId")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "versionId", valid_594275
  var valid_594276 = path.getOrDefault("subscriptionId")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "subscriptionId", valid_594276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594277 = query.getOrDefault("api-version")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "api-version", valid_594277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594278: Call_WorkflowVersionsGet_594270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow version.
  ## 
  let valid = call_594278.validator(path, query, header, formData, body)
  let scheme = call_594278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594278.url(scheme.get, call_594278.host, call_594278.base,
                         call_594278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594278, url, valid)

proc call*(call_594279: Call_WorkflowVersionsGet_594270; workflowName: string;
          resourceGroupName: string; versionId: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## workflowVersionsGet
  ## Gets a workflow version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   versionId: string (required)
  ##            : The workflow versionId.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_594280 = newJObject()
  var query_594281 = newJObject()
  add(path_594280, "workflowName", newJString(workflowName))
  add(path_594280, "resourceGroupName", newJString(resourceGroupName))
  add(path_594280, "versionId", newJString(versionId))
  add(query_594281, "api-version", newJString(apiVersion))
  add(path_594280, "subscriptionId", newJString(subscriptionId))
  result = call_594279.call(path_594280, query_594281, nil, nil, nil)

var workflowVersionsGet* = Call_WorkflowVersionsGet_594270(
    name: "workflowVersionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions/{versionId}",
    validator: validate_WorkflowVersionsGet_594271, base: "",
    url: url_WorkflowVersionsGet_594272, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
