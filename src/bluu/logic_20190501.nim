
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: LogicManagementClient
## version: 2019-05-01
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

  OpenApiRestCall_563565 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563565](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563565): Option[Scheme] {.used.} =
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
  macServiceName = "logic"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563787 = ref object of OpenApiRestCall_563565
proc url_OperationsList_563789(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563788(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Logic REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563950 = query.getOrDefault("api-version")
  valid_563950 = validateParameter(valid_563950, JString, required = true,
                                 default = nil)
  if valid_563950 != nil:
    section.add "api-version", valid_563950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563973: Call_OperationsList_563787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Logic REST API operations.
  ## 
  let valid = call_563973.validator(path, query, header, formData, body)
  let scheme = call_563973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563973.url(scheme.get, call_563973.host, call_563973.base,
                         call_563973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563973, url, valid)

proc call*(call_564044: Call_OperationsList_563787; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Logic REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version.
  var query_564045 = newJObject()
  add(query_564045, "api-version", newJString(apiVersion))
  result = call_564044.call(nil, query_564045, nil, nil, nil)

var operationsList* = Call_OperationsList_563787(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Logic/operations",
    validator: validate_OperationsList_563788, base: "", url: url_OperationsList_563789,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListBySubscription_564085 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsListBySubscription_564087(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsListBySubscription_564086(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration accounts by subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564103 = path.getOrDefault("subscriptionId")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "subscriptionId", valid_564103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564104 = query.getOrDefault("api-version")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "api-version", valid_564104
  var valid_564105 = query.getOrDefault("$top")
  valid_564105 = validateParameter(valid_564105, JInt, required = false, default = nil)
  if valid_564105 != nil:
    section.add "$top", valid_564105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564106: Call_IntegrationAccountsListBySubscription_564085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration accounts by subscription.
  ## 
  let valid = call_564106.validator(path, query, header, formData, body)
  let scheme = call_564106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564106.url(scheme.get, call_564106.host, call_564106.base,
                         call_564106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564106, url, valid)

proc call*(call_564107: Call_IntegrationAccountsListBySubscription_564085;
          apiVersion: string; subscriptionId: string; Top: int = 0): Recallable =
  ## integrationAccountsListBySubscription
  ## Gets a list of integration accounts by subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_564108 = newJObject()
  var query_564109 = newJObject()
  add(query_564109, "api-version", newJString(apiVersion))
  add(query_564109, "$top", newJInt(Top))
  add(path_564108, "subscriptionId", newJString(subscriptionId))
  result = call_564107.call(path_564108, query_564109, nil, nil, nil)

var integrationAccountsListBySubscription* = Call_IntegrationAccountsListBySubscription_564085(
    name: "integrationAccountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Logic/integrationAccounts",
    validator: validate_IntegrationAccountsListBySubscription_564086, base: "",
    url: url_IntegrationAccountsListBySubscription_564087, schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentsListBySubscription_564110 = ref object of OpenApiRestCall_563565
proc url_IntegrationServiceEnvironmentsListBySubscription_564112(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationServiceEnvironments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationServiceEnvironmentsListBySubscription_564111(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a list of integration service environments by subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564113 = path.getOrDefault("subscriptionId")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "subscriptionId", valid_564113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564114 = query.getOrDefault("api-version")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "api-version", valid_564114
  var valid_564115 = query.getOrDefault("$top")
  valid_564115 = validateParameter(valid_564115, JInt, required = false, default = nil)
  if valid_564115 != nil:
    section.add "$top", valid_564115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564116: Call_IntegrationServiceEnvironmentsListBySubscription_564110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration service environments by subscription.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_IntegrationServiceEnvironmentsListBySubscription_564110;
          apiVersion: string; subscriptionId: string; Top: int = 0): Recallable =
  ## integrationServiceEnvironmentsListBySubscription
  ## Gets a list of integration service environments by subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  add(query_564119, "api-version", newJString(apiVersion))
  add(query_564119, "$top", newJInt(Top))
  add(path_564118, "subscriptionId", newJString(subscriptionId))
  result = call_564117.call(path_564118, query_564119, nil, nil, nil)

var integrationServiceEnvironmentsListBySubscription* = Call_IntegrationServiceEnvironmentsListBySubscription_564110(
    name: "integrationServiceEnvironmentsListBySubscription",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Logic/integrationServiceEnvironments",
    validator: validate_IntegrationServiceEnvironmentsListBySubscription_564111,
    base: "", url: url_IntegrationServiceEnvironmentsListBySubscription_564112,
    schemes: {Scheme.Https})
type
  Call_WorkflowsListBySubscription_564120 = ref object of OpenApiRestCall_563565
proc url_WorkflowsListBySubscription_564122(protocol: Scheme; host: string;
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

proc validate_WorkflowsListBySubscription_564121(path: JsonNode; query: JsonNode;
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
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Options for filters include: State, Trigger, and ReferencedResourceId.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564124 = query.getOrDefault("api-version")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "api-version", valid_564124
  var valid_564125 = query.getOrDefault("$top")
  valid_564125 = validateParameter(valid_564125, JInt, required = false, default = nil)
  if valid_564125 != nil:
    section.add "$top", valid_564125
  var valid_564126 = query.getOrDefault("$filter")
  valid_564126 = validateParameter(valid_564126, JString, required = false,
                                 default = nil)
  if valid_564126 != nil:
    section.add "$filter", valid_564126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564127: Call_WorkflowsListBySubscription_564120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflows by subscription.
  ## 
  let valid = call_564127.validator(path, query, header, formData, body)
  let scheme = call_564127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564127.url(scheme.get, call_564127.host, call_564127.base,
                         call_564127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564127, url, valid)

proc call*(call_564128: Call_WorkflowsListBySubscription_564120;
          apiVersion: string; subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## workflowsListBySubscription
  ## Gets a list of workflows by subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Filter: string
  ##         : The filter to apply on the operation. Options for filters include: State, Trigger, and ReferencedResourceId.
  var path_564129 = newJObject()
  var query_564130 = newJObject()
  add(query_564130, "api-version", newJString(apiVersion))
  add(query_564130, "$top", newJInt(Top))
  add(path_564129, "subscriptionId", newJString(subscriptionId))
  add(query_564130, "$filter", newJString(Filter))
  result = call_564128.call(path_564129, query_564130, nil, nil, nil)

var workflowsListBySubscription* = Call_WorkflowsListBySubscription_564120(
    name: "workflowsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Logic/workflows",
    validator: validate_WorkflowsListBySubscription_564121, base: "",
    url: url_WorkflowsListBySubscription_564122, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListByResourceGroup_564131 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsListByResourceGroup_564133(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Logic/integrationAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsListByResourceGroup_564132(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration accounts by resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564134 = path.getOrDefault("subscriptionId")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "subscriptionId", valid_564134
  var valid_564135 = path.getOrDefault("resourceGroupName")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "resourceGroupName", valid_564135
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564136 = query.getOrDefault("api-version")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "api-version", valid_564136
  var valid_564137 = query.getOrDefault("$top")
  valid_564137 = validateParameter(valid_564137, JInt, required = false, default = nil)
  if valid_564137 != nil:
    section.add "$top", valid_564137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564138: Call_IntegrationAccountsListByResourceGroup_564131;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration accounts by resource group.
  ## 
  let valid = call_564138.validator(path, query, header, formData, body)
  let scheme = call_564138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564138.url(scheme.get, call_564138.host, call_564138.base,
                         call_564138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564138, url, valid)

proc call*(call_564139: Call_IntegrationAccountsListByResourceGroup_564131;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0): Recallable =
  ## integrationAccountsListByResourceGroup
  ## Gets a list of integration accounts by resource group.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564140 = newJObject()
  var query_564141 = newJObject()
  add(query_564141, "api-version", newJString(apiVersion))
  add(query_564141, "$top", newJInt(Top))
  add(path_564140, "subscriptionId", newJString(subscriptionId))
  add(path_564140, "resourceGroupName", newJString(resourceGroupName))
  result = call_564139.call(path_564140, query_564141, nil, nil, nil)

var integrationAccountsListByResourceGroup* = Call_IntegrationAccountsListByResourceGroup_564131(
    name: "integrationAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts",
    validator: validate_IntegrationAccountsListByResourceGroup_564132, base: "",
    url: url_IntegrationAccountsListByResourceGroup_564133,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountsCreateOrUpdate_564153 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsCreateOrUpdate_564155(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsCreateOrUpdate_564154(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564156 = path.getOrDefault("subscriptionId")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "subscriptionId", valid_564156
  var valid_564157 = path.getOrDefault("resourceGroupName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "resourceGroupName", valid_564157
  var valid_564158 = path.getOrDefault("integrationAccountName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "integrationAccountName", valid_564158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564159 = query.getOrDefault("api-version")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "api-version", valid_564159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   integrationAccount: JObject (required)
  ##                     : The integration account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564161: Call_IntegrationAccountsCreateOrUpdate_564153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account.
  ## 
  let valid = call_564161.validator(path, query, header, formData, body)
  let scheme = call_564161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564161.url(scheme.get, call_564161.host, call_564161.base,
                         call_564161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564161, url, valid)

proc call*(call_564162: Call_IntegrationAccountsCreateOrUpdate_564153;
          apiVersion: string; subscriptionId: string; integrationAccount: JsonNode;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## integrationAccountsCreateOrUpdate
  ## Creates or updates an integration account.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   integrationAccount: JObject (required)
  ##                     : The integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564163 = newJObject()
  var query_564164 = newJObject()
  var body_564165 = newJObject()
  add(query_564164, "api-version", newJString(apiVersion))
  add(path_564163, "subscriptionId", newJString(subscriptionId))
  if integrationAccount != nil:
    body_564165 = integrationAccount
  add(path_564163, "resourceGroupName", newJString(resourceGroupName))
  add(path_564163, "integrationAccountName", newJString(integrationAccountName))
  result = call_564162.call(path_564163, query_564164, nil, nil, body_564165)

var integrationAccountsCreateOrUpdate* = Call_IntegrationAccountsCreateOrUpdate_564153(
    name: "integrationAccountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsCreateOrUpdate_564154, base: "",
    url: url_IntegrationAccountsCreateOrUpdate_564155, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsGet_564142 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsGet_564144(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsGet_564143(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564145 = path.getOrDefault("subscriptionId")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "subscriptionId", valid_564145
  var valid_564146 = path.getOrDefault("resourceGroupName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "resourceGroupName", valid_564146
  var valid_564147 = path.getOrDefault("integrationAccountName")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "integrationAccountName", valid_564147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564148 = query.getOrDefault("api-version")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "api-version", valid_564148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564149: Call_IntegrationAccountsGet_564142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account.
  ## 
  let valid = call_564149.validator(path, query, header, formData, body)
  let scheme = call_564149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564149.url(scheme.get, call_564149.host, call_564149.base,
                         call_564149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564149, url, valid)

proc call*(call_564150: Call_IntegrationAccountsGet_564142; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## integrationAccountsGet
  ## Gets an integration account.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564151 = newJObject()
  var query_564152 = newJObject()
  add(query_564152, "api-version", newJString(apiVersion))
  add(path_564151, "subscriptionId", newJString(subscriptionId))
  add(path_564151, "resourceGroupName", newJString(resourceGroupName))
  add(path_564151, "integrationAccountName", newJString(integrationAccountName))
  result = call_564150.call(path_564151, query_564152, nil, nil, nil)

var integrationAccountsGet* = Call_IntegrationAccountsGet_564142(
    name: "integrationAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsGet_564143, base: "",
    url: url_IntegrationAccountsGet_564144, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsUpdate_564177 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsUpdate_564179(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsUpdate_564178(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564180 = path.getOrDefault("subscriptionId")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "subscriptionId", valid_564180
  var valid_564181 = path.getOrDefault("resourceGroupName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "resourceGroupName", valid_564181
  var valid_564182 = path.getOrDefault("integrationAccountName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "integrationAccountName", valid_564182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564183 = query.getOrDefault("api-version")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "api-version", valid_564183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   integrationAccount: JObject (required)
  ##                     : The integration account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564185: Call_IntegrationAccountsUpdate_564177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an integration account.
  ## 
  let valid = call_564185.validator(path, query, header, formData, body)
  let scheme = call_564185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564185.url(scheme.get, call_564185.host, call_564185.base,
                         call_564185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564185, url, valid)

proc call*(call_564186: Call_IntegrationAccountsUpdate_564177; apiVersion: string;
          subscriptionId: string; integrationAccount: JsonNode;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## integrationAccountsUpdate
  ## Updates an integration account.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   integrationAccount: JObject (required)
  ##                     : The integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564187 = newJObject()
  var query_564188 = newJObject()
  var body_564189 = newJObject()
  add(query_564188, "api-version", newJString(apiVersion))
  add(path_564187, "subscriptionId", newJString(subscriptionId))
  if integrationAccount != nil:
    body_564189 = integrationAccount
  add(path_564187, "resourceGroupName", newJString(resourceGroupName))
  add(path_564187, "integrationAccountName", newJString(integrationAccountName))
  result = call_564186.call(path_564187, query_564188, nil, nil, body_564189)

var integrationAccountsUpdate* = Call_IntegrationAccountsUpdate_564177(
    name: "integrationAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsUpdate_564178, base: "",
    url: url_IntegrationAccountsUpdate_564179, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsDelete_564166 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsDelete_564168(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsDelete_564167(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564169 = path.getOrDefault("subscriptionId")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "subscriptionId", valid_564169
  var valid_564170 = path.getOrDefault("resourceGroupName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "resourceGroupName", valid_564170
  var valid_564171 = path.getOrDefault("integrationAccountName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "integrationAccountName", valid_564171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564172 = query.getOrDefault("api-version")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "api-version", valid_564172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564173: Call_IntegrationAccountsDelete_564166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account.
  ## 
  let valid = call_564173.validator(path, query, header, formData, body)
  let scheme = call_564173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564173.url(scheme.get, call_564173.host, call_564173.base,
                         call_564173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564173, url, valid)

proc call*(call_564174: Call_IntegrationAccountsDelete_564166; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## integrationAccountsDelete
  ## Deletes an integration account.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564175 = newJObject()
  var query_564176 = newJObject()
  add(query_564176, "api-version", newJString(apiVersion))
  add(path_564175, "subscriptionId", newJString(subscriptionId))
  add(path_564175, "resourceGroupName", newJString(resourceGroupName))
  add(path_564175, "integrationAccountName", newJString(integrationAccountName))
  result = call_564174.call(path_564175, query_564176, nil, nil, nil)

var integrationAccountsDelete* = Call_IntegrationAccountsDelete_564166(
    name: "integrationAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsDelete_564167, base: "",
    url: url_IntegrationAccountsDelete_564168, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsList_564190 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountAgreementsList_564192(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/agreements")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountAgreementsList_564191(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account agreements.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564193 = path.getOrDefault("subscriptionId")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "subscriptionId", valid_564193
  var valid_564194 = path.getOrDefault("resourceGroupName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "resourceGroupName", valid_564194
  var valid_564195 = path.getOrDefault("integrationAccountName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "integrationAccountName", valid_564195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Options for filters include: AgreementType.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564196 = query.getOrDefault("api-version")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "api-version", valid_564196
  var valid_564197 = query.getOrDefault("$top")
  valid_564197 = validateParameter(valid_564197, JInt, required = false, default = nil)
  if valid_564197 != nil:
    section.add "$top", valid_564197
  var valid_564198 = query.getOrDefault("$filter")
  valid_564198 = validateParameter(valid_564198, JString, required = false,
                                 default = nil)
  if valid_564198 != nil:
    section.add "$filter", valid_564198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564199: Call_IntegrationAccountAgreementsList_564190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account agreements.
  ## 
  let valid = call_564199.validator(path, query, header, formData, body)
  let scheme = call_564199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564199.url(scheme.get, call_564199.host, call_564199.base,
                         call_564199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564199, url, valid)

proc call*(call_564200: Call_IntegrationAccountAgreementsList_564190;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; Top: int = 0; Filter: string = ""): Recallable =
  ## integrationAccountAgreementsList
  ## Gets a list of integration account agreements.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   Filter: string
  ##         : The filter to apply on the operation. Options for filters include: AgreementType.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564201 = newJObject()
  var query_564202 = newJObject()
  add(query_564202, "api-version", newJString(apiVersion))
  add(query_564202, "$top", newJInt(Top))
  add(path_564201, "subscriptionId", newJString(subscriptionId))
  add(path_564201, "resourceGroupName", newJString(resourceGroupName))
  add(query_564202, "$filter", newJString(Filter))
  add(path_564201, "integrationAccountName", newJString(integrationAccountName))
  result = call_564200.call(path_564201, query_564202, nil, nil, nil)

var integrationAccountAgreementsList* = Call_IntegrationAccountAgreementsList_564190(
    name: "integrationAccountAgreementsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements",
    validator: validate_IntegrationAccountAgreementsList_564191, base: "",
    url: url_IntegrationAccountAgreementsList_564192, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsCreateOrUpdate_564215 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountAgreementsCreateOrUpdate_564217(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "agreementName" in path, "`agreementName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/agreements/"),
               (kind: VariableSegment, value: "agreementName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountAgreementsCreateOrUpdate_564216(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account agreement.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   agreementName: JString (required)
  ##                : The integration account agreement name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `agreementName` field"
  var valid_564218 = path.getOrDefault("agreementName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "agreementName", valid_564218
  var valid_564219 = path.getOrDefault("subscriptionId")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "subscriptionId", valid_564219
  var valid_564220 = path.getOrDefault("resourceGroupName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "resourceGroupName", valid_564220
  var valid_564221 = path.getOrDefault("integrationAccountName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "integrationAccountName", valid_564221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564222 = query.getOrDefault("api-version")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "api-version", valid_564222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   agreement: JObject (required)
  ##            : The integration account agreement.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564224: Call_IntegrationAccountAgreementsCreateOrUpdate_564215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account agreement.
  ## 
  let valid = call_564224.validator(path, query, header, formData, body)
  let scheme = call_564224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564224.url(scheme.get, call_564224.host, call_564224.base,
                         call_564224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564224, url, valid)

proc call*(call_564225: Call_IntegrationAccountAgreementsCreateOrUpdate_564215;
          apiVersion: string; agreement: JsonNode; agreementName: string;
          subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## integrationAccountAgreementsCreateOrUpdate
  ## Creates or updates an integration account agreement.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   agreement: JObject (required)
  ##            : The integration account agreement.
  ##   agreementName: string (required)
  ##                : The integration account agreement name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564226 = newJObject()
  var query_564227 = newJObject()
  var body_564228 = newJObject()
  add(query_564227, "api-version", newJString(apiVersion))
  if agreement != nil:
    body_564228 = agreement
  add(path_564226, "agreementName", newJString(agreementName))
  add(path_564226, "subscriptionId", newJString(subscriptionId))
  add(path_564226, "resourceGroupName", newJString(resourceGroupName))
  add(path_564226, "integrationAccountName", newJString(integrationAccountName))
  result = call_564225.call(path_564226, query_564227, nil, nil, body_564228)

var integrationAccountAgreementsCreateOrUpdate* = Call_IntegrationAccountAgreementsCreateOrUpdate_564215(
    name: "integrationAccountAgreementsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_IntegrationAccountAgreementsCreateOrUpdate_564216,
    base: "", url: url_IntegrationAccountAgreementsCreateOrUpdate_564217,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsGet_564203 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountAgreementsGet_564205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "agreementName" in path, "`agreementName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/agreements/"),
               (kind: VariableSegment, value: "agreementName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountAgreementsGet_564204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account agreement.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   agreementName: JString (required)
  ##                : The integration account agreement name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `agreementName` field"
  var valid_564206 = path.getOrDefault("agreementName")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "agreementName", valid_564206
  var valid_564207 = path.getOrDefault("subscriptionId")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "subscriptionId", valid_564207
  var valid_564208 = path.getOrDefault("resourceGroupName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "resourceGroupName", valid_564208
  var valid_564209 = path.getOrDefault("integrationAccountName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "integrationAccountName", valid_564209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564210 = query.getOrDefault("api-version")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "api-version", valid_564210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564211: Call_IntegrationAccountAgreementsGet_564203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an integration account agreement.
  ## 
  let valid = call_564211.validator(path, query, header, formData, body)
  let scheme = call_564211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564211.url(scheme.get, call_564211.host, call_564211.base,
                         call_564211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564211, url, valid)

proc call*(call_564212: Call_IntegrationAccountAgreementsGet_564203;
          apiVersion: string; agreementName: string; subscriptionId: string;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## integrationAccountAgreementsGet
  ## Gets an integration account agreement.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   agreementName: string (required)
  ##                : The integration account agreement name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564213 = newJObject()
  var query_564214 = newJObject()
  add(query_564214, "api-version", newJString(apiVersion))
  add(path_564213, "agreementName", newJString(agreementName))
  add(path_564213, "subscriptionId", newJString(subscriptionId))
  add(path_564213, "resourceGroupName", newJString(resourceGroupName))
  add(path_564213, "integrationAccountName", newJString(integrationAccountName))
  result = call_564212.call(path_564213, query_564214, nil, nil, nil)

var integrationAccountAgreementsGet* = Call_IntegrationAccountAgreementsGet_564203(
    name: "integrationAccountAgreementsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_IntegrationAccountAgreementsGet_564204, base: "",
    url: url_IntegrationAccountAgreementsGet_564205, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsDelete_564229 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountAgreementsDelete_564231(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "agreementName" in path, "`agreementName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/agreements/"),
               (kind: VariableSegment, value: "agreementName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountAgreementsDelete_564230(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account agreement.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   agreementName: JString (required)
  ##                : The integration account agreement name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `agreementName` field"
  var valid_564232 = path.getOrDefault("agreementName")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "agreementName", valid_564232
  var valid_564233 = path.getOrDefault("subscriptionId")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "subscriptionId", valid_564233
  var valid_564234 = path.getOrDefault("resourceGroupName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "resourceGroupName", valid_564234
  var valid_564235 = path.getOrDefault("integrationAccountName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "integrationAccountName", valid_564235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564236 = query.getOrDefault("api-version")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "api-version", valid_564236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564237: Call_IntegrationAccountAgreementsDelete_564229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account agreement.
  ## 
  let valid = call_564237.validator(path, query, header, formData, body)
  let scheme = call_564237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564237.url(scheme.get, call_564237.host, call_564237.base,
                         call_564237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564237, url, valid)

proc call*(call_564238: Call_IntegrationAccountAgreementsDelete_564229;
          apiVersion: string; agreementName: string; subscriptionId: string;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## integrationAccountAgreementsDelete
  ## Deletes an integration account agreement.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   agreementName: string (required)
  ##                : The integration account agreement name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564239 = newJObject()
  var query_564240 = newJObject()
  add(query_564240, "api-version", newJString(apiVersion))
  add(path_564239, "agreementName", newJString(agreementName))
  add(path_564239, "subscriptionId", newJString(subscriptionId))
  add(path_564239, "resourceGroupName", newJString(resourceGroupName))
  add(path_564239, "integrationAccountName", newJString(integrationAccountName))
  result = call_564238.call(path_564239, query_564240, nil, nil, nil)

var integrationAccountAgreementsDelete* = Call_IntegrationAccountAgreementsDelete_564229(
    name: "integrationAccountAgreementsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_IntegrationAccountAgreementsDelete_564230, base: "",
    url: url_IntegrationAccountAgreementsDelete_564231, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsListContentCallbackUrl_564241 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountAgreementsListContentCallbackUrl_564243(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "agreementName" in path, "`agreementName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/agreements/"),
               (kind: VariableSegment, value: "agreementName"),
               (kind: ConstantSegment, value: "/listContentCallbackUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountAgreementsListContentCallbackUrl_564242(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the content callback url.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   agreementName: JString (required)
  ##                : The integration account agreement name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `agreementName` field"
  var valid_564244 = path.getOrDefault("agreementName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "agreementName", valid_564244
  var valid_564245 = path.getOrDefault("subscriptionId")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "subscriptionId", valid_564245
  var valid_564246 = path.getOrDefault("resourceGroupName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "resourceGroupName", valid_564246
  var valid_564247 = path.getOrDefault("integrationAccountName")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "integrationAccountName", valid_564247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564248 = query.getOrDefault("api-version")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "api-version", valid_564248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   listContentCallbackUrl: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564250: Call_IntegrationAccountAgreementsListContentCallbackUrl_564241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_564250.validator(path, query, header, formData, body)
  let scheme = call_564250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564250.url(scheme.get, call_564250.host, call_564250.base,
                         call_564250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564250, url, valid)

proc call*(call_564251: Call_IntegrationAccountAgreementsListContentCallbackUrl_564241;
          apiVersion: string; agreementName: string; subscriptionId: string;
          listContentCallbackUrl: JsonNode; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## integrationAccountAgreementsListContentCallbackUrl
  ## Get the content callback url.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   agreementName: string (required)
  ##                : The integration account agreement name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   listContentCallbackUrl: JObject (required)
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564252 = newJObject()
  var query_564253 = newJObject()
  var body_564254 = newJObject()
  add(query_564253, "api-version", newJString(apiVersion))
  add(path_564252, "agreementName", newJString(agreementName))
  add(path_564252, "subscriptionId", newJString(subscriptionId))
  if listContentCallbackUrl != nil:
    body_564254 = listContentCallbackUrl
  add(path_564252, "resourceGroupName", newJString(resourceGroupName))
  add(path_564252, "integrationAccountName", newJString(integrationAccountName))
  result = call_564251.call(path_564252, query_564253, nil, nil, body_564254)

var integrationAccountAgreementsListContentCallbackUrl* = Call_IntegrationAccountAgreementsListContentCallbackUrl_564241(
    name: "integrationAccountAgreementsListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountAgreementsListContentCallbackUrl_564242,
    base: "", url: url_IntegrationAccountAgreementsListContentCallbackUrl_564243,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesList_564255 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountAssembliesList_564257(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/assemblies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountAssembliesList_564256(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the assemblies for an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564258 = path.getOrDefault("subscriptionId")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "subscriptionId", valid_564258
  var valid_564259 = path.getOrDefault("resourceGroupName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "resourceGroupName", valid_564259
  var valid_564260 = path.getOrDefault("integrationAccountName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "integrationAccountName", valid_564260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564261 = query.getOrDefault("api-version")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "api-version", valid_564261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564262: Call_IntegrationAccountAssembliesList_564255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the assemblies for an integration account.
  ## 
  let valid = call_564262.validator(path, query, header, formData, body)
  let scheme = call_564262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564262.url(scheme.get, call_564262.host, call_564262.base,
                         call_564262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564262, url, valid)

proc call*(call_564263: Call_IntegrationAccountAssembliesList_564255;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## integrationAccountAssembliesList
  ## List the assemblies for an integration account.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564264 = newJObject()
  var query_564265 = newJObject()
  add(query_564265, "api-version", newJString(apiVersion))
  add(path_564264, "subscriptionId", newJString(subscriptionId))
  add(path_564264, "resourceGroupName", newJString(resourceGroupName))
  add(path_564264, "integrationAccountName", newJString(integrationAccountName))
  result = call_564263.call(path_564264, query_564265, nil, nil, nil)

var integrationAccountAssembliesList* = Call_IntegrationAccountAssembliesList_564255(
    name: "integrationAccountAssembliesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies",
    validator: validate_IntegrationAccountAssembliesList_564256, base: "",
    url: url_IntegrationAccountAssembliesList_564257, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesCreateOrUpdate_564278 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountAssembliesCreateOrUpdate_564280(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "assemblyArtifactName" in path,
        "`assemblyArtifactName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/assemblies/"),
               (kind: VariableSegment, value: "assemblyArtifactName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountAssembliesCreateOrUpdate_564279(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an assembly for an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assemblyArtifactName: JString (required)
  ##                       : The assembly artifact name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `assemblyArtifactName` field"
  var valid_564281 = path.getOrDefault("assemblyArtifactName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "assemblyArtifactName", valid_564281
  var valid_564282 = path.getOrDefault("subscriptionId")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "subscriptionId", valid_564282
  var valid_564283 = path.getOrDefault("resourceGroupName")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "resourceGroupName", valid_564283
  var valid_564284 = path.getOrDefault("integrationAccountName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "integrationAccountName", valid_564284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564285 = query.getOrDefault("api-version")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "api-version", valid_564285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   assemblyArtifact: JObject (required)
  ##                   : The assembly artifact.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564287: Call_IntegrationAccountAssembliesCreateOrUpdate_564278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an assembly for an integration account.
  ## 
  let valid = call_564287.validator(path, query, header, formData, body)
  let scheme = call_564287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564287.url(scheme.get, call_564287.host, call_564287.base,
                         call_564287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564287, url, valid)

proc call*(call_564288: Call_IntegrationAccountAssembliesCreateOrUpdate_564278;
          assemblyArtifact: JsonNode; assemblyArtifactName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## integrationAccountAssembliesCreateOrUpdate
  ## Create or update an assembly for an integration account.
  ##   assemblyArtifact: JObject (required)
  ##                   : The assembly artifact.
  ##   assemblyArtifactName: string (required)
  ##                       : The assembly artifact name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564289 = newJObject()
  var query_564290 = newJObject()
  var body_564291 = newJObject()
  if assemblyArtifact != nil:
    body_564291 = assemblyArtifact
  add(path_564289, "assemblyArtifactName", newJString(assemblyArtifactName))
  add(query_564290, "api-version", newJString(apiVersion))
  add(path_564289, "subscriptionId", newJString(subscriptionId))
  add(path_564289, "resourceGroupName", newJString(resourceGroupName))
  add(path_564289, "integrationAccountName", newJString(integrationAccountName))
  result = call_564288.call(path_564289, query_564290, nil, nil, body_564291)

var integrationAccountAssembliesCreateOrUpdate* = Call_IntegrationAccountAssembliesCreateOrUpdate_564278(
    name: "integrationAccountAssembliesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}",
    validator: validate_IntegrationAccountAssembliesCreateOrUpdate_564279,
    base: "", url: url_IntegrationAccountAssembliesCreateOrUpdate_564280,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesGet_564266 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountAssembliesGet_564268(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "assemblyArtifactName" in path,
        "`assemblyArtifactName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/assemblies/"),
               (kind: VariableSegment, value: "assemblyArtifactName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountAssembliesGet_564267(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an assembly for an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assemblyArtifactName: JString (required)
  ##                       : The assembly artifact name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `assemblyArtifactName` field"
  var valid_564269 = path.getOrDefault("assemblyArtifactName")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "assemblyArtifactName", valid_564269
  var valid_564270 = path.getOrDefault("subscriptionId")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "subscriptionId", valid_564270
  var valid_564271 = path.getOrDefault("resourceGroupName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "resourceGroupName", valid_564271
  var valid_564272 = path.getOrDefault("integrationAccountName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "integrationAccountName", valid_564272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564273 = query.getOrDefault("api-version")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "api-version", valid_564273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564274: Call_IntegrationAccountAssembliesGet_564266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an assembly for an integration account.
  ## 
  let valid = call_564274.validator(path, query, header, formData, body)
  let scheme = call_564274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564274.url(scheme.get, call_564274.host, call_564274.base,
                         call_564274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564274, url, valid)

proc call*(call_564275: Call_IntegrationAccountAssembliesGet_564266;
          assemblyArtifactName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## integrationAccountAssembliesGet
  ## Get an assembly for an integration account.
  ##   assemblyArtifactName: string (required)
  ##                       : The assembly artifact name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564276 = newJObject()
  var query_564277 = newJObject()
  add(path_564276, "assemblyArtifactName", newJString(assemblyArtifactName))
  add(query_564277, "api-version", newJString(apiVersion))
  add(path_564276, "subscriptionId", newJString(subscriptionId))
  add(path_564276, "resourceGroupName", newJString(resourceGroupName))
  add(path_564276, "integrationAccountName", newJString(integrationAccountName))
  result = call_564275.call(path_564276, query_564277, nil, nil, nil)

var integrationAccountAssembliesGet* = Call_IntegrationAccountAssembliesGet_564266(
    name: "integrationAccountAssembliesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}",
    validator: validate_IntegrationAccountAssembliesGet_564267, base: "",
    url: url_IntegrationAccountAssembliesGet_564268, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesDelete_564292 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountAssembliesDelete_564294(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "assemblyArtifactName" in path,
        "`assemblyArtifactName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/assemblies/"),
               (kind: VariableSegment, value: "assemblyArtifactName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountAssembliesDelete_564293(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an assembly for an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assemblyArtifactName: JString (required)
  ##                       : The assembly artifact name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `assemblyArtifactName` field"
  var valid_564295 = path.getOrDefault("assemblyArtifactName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "assemblyArtifactName", valid_564295
  var valid_564296 = path.getOrDefault("subscriptionId")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "subscriptionId", valid_564296
  var valid_564297 = path.getOrDefault("resourceGroupName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "resourceGroupName", valid_564297
  var valid_564298 = path.getOrDefault("integrationAccountName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "integrationAccountName", valid_564298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564299 = query.getOrDefault("api-version")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "api-version", valid_564299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564300: Call_IntegrationAccountAssembliesDelete_564292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an assembly for an integration account.
  ## 
  let valid = call_564300.validator(path, query, header, formData, body)
  let scheme = call_564300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564300.url(scheme.get, call_564300.host, call_564300.base,
                         call_564300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564300, url, valid)

proc call*(call_564301: Call_IntegrationAccountAssembliesDelete_564292;
          assemblyArtifactName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## integrationAccountAssembliesDelete
  ## Delete an assembly for an integration account.
  ##   assemblyArtifactName: string (required)
  ##                       : The assembly artifact name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564302 = newJObject()
  var query_564303 = newJObject()
  add(path_564302, "assemblyArtifactName", newJString(assemblyArtifactName))
  add(query_564303, "api-version", newJString(apiVersion))
  add(path_564302, "subscriptionId", newJString(subscriptionId))
  add(path_564302, "resourceGroupName", newJString(resourceGroupName))
  add(path_564302, "integrationAccountName", newJString(integrationAccountName))
  result = call_564301.call(path_564302, query_564303, nil, nil, nil)

var integrationAccountAssembliesDelete* = Call_IntegrationAccountAssembliesDelete_564292(
    name: "integrationAccountAssembliesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}",
    validator: validate_IntegrationAccountAssembliesDelete_564293, base: "",
    url: url_IntegrationAccountAssembliesDelete_564294, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesListContentCallbackUrl_564304 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountAssembliesListContentCallbackUrl_564306(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "assemblyArtifactName" in path,
        "`assemblyArtifactName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/assemblies/"),
               (kind: VariableSegment, value: "assemblyArtifactName"),
               (kind: ConstantSegment, value: "/listContentCallbackUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountAssembliesListContentCallbackUrl_564305(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the content callback url for an integration account assembly.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assemblyArtifactName: JString (required)
  ##                       : The assembly artifact name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `assemblyArtifactName` field"
  var valid_564307 = path.getOrDefault("assemblyArtifactName")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "assemblyArtifactName", valid_564307
  var valid_564308 = path.getOrDefault("subscriptionId")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "subscriptionId", valid_564308
  var valid_564309 = path.getOrDefault("resourceGroupName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "resourceGroupName", valid_564309
  var valid_564310 = path.getOrDefault("integrationAccountName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "integrationAccountName", valid_564310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_564312: Call_IntegrationAccountAssembliesListContentCallbackUrl_564304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url for an integration account assembly.
  ## 
  let valid = call_564312.validator(path, query, header, formData, body)
  let scheme = call_564312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564312.url(scheme.get, call_564312.host, call_564312.base,
                         call_564312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564312, url, valid)

proc call*(call_564313: Call_IntegrationAccountAssembliesListContentCallbackUrl_564304;
          assemblyArtifactName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## integrationAccountAssembliesListContentCallbackUrl
  ## Get the content callback url for an integration account assembly.
  ##   assemblyArtifactName: string (required)
  ##                       : The assembly artifact name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564314 = newJObject()
  var query_564315 = newJObject()
  add(path_564314, "assemblyArtifactName", newJString(assemblyArtifactName))
  add(query_564315, "api-version", newJString(apiVersion))
  add(path_564314, "subscriptionId", newJString(subscriptionId))
  add(path_564314, "resourceGroupName", newJString(resourceGroupName))
  add(path_564314, "integrationAccountName", newJString(integrationAccountName))
  result = call_564313.call(path_564314, query_564315, nil, nil, nil)

var integrationAccountAssembliesListContentCallbackUrl* = Call_IntegrationAccountAssembliesListContentCallbackUrl_564304(
    name: "integrationAccountAssembliesListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountAssembliesListContentCallbackUrl_564305,
    base: "", url: url_IntegrationAccountAssembliesListContentCallbackUrl_564306,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsList_564316 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountBatchConfigurationsList_564318(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/batchConfigurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountBatchConfigurationsList_564317(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the batch configurations for an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
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
  var valid_564321 = path.getOrDefault("integrationAccountName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "integrationAccountName", valid_564321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_564323: Call_IntegrationAccountBatchConfigurationsList_564316;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the batch configurations for an integration account.
  ## 
  let valid = call_564323.validator(path, query, header, formData, body)
  let scheme = call_564323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564323.url(scheme.get, call_564323.host, call_564323.base,
                         call_564323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564323, url, valid)

proc call*(call_564324: Call_IntegrationAccountBatchConfigurationsList_564316;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## integrationAccountBatchConfigurationsList
  ## List the batch configurations for an integration account.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564325 = newJObject()
  var query_564326 = newJObject()
  add(query_564326, "api-version", newJString(apiVersion))
  add(path_564325, "subscriptionId", newJString(subscriptionId))
  add(path_564325, "resourceGroupName", newJString(resourceGroupName))
  add(path_564325, "integrationAccountName", newJString(integrationAccountName))
  result = call_564324.call(path_564325, query_564326, nil, nil, nil)

var integrationAccountBatchConfigurationsList* = Call_IntegrationAccountBatchConfigurationsList_564316(
    name: "integrationAccountBatchConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations",
    validator: validate_IntegrationAccountBatchConfigurationsList_564317,
    base: "", url: url_IntegrationAccountBatchConfigurationsList_564318,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_564339 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountBatchConfigurationsCreateOrUpdate_564341(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "batchConfigurationName" in path,
        "`batchConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/batchConfigurations/"),
               (kind: VariableSegment, value: "batchConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountBatchConfigurationsCreateOrUpdate_564340(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create or update a batch configuration for an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   batchConfigurationName: JString (required)
  ##                         : The batch configuration name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `batchConfigurationName` field"
  var valid_564342 = path.getOrDefault("batchConfigurationName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "batchConfigurationName", valid_564342
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
  var valid_564345 = path.getOrDefault("integrationAccountName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "integrationAccountName", valid_564345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  ## parameters in `body` object:
  ##   batchConfiguration: JObject (required)
  ##                     : The batch configuration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564348: Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_564339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a batch configuration for an integration account.
  ## 
  let valid = call_564348.validator(path, query, header, formData, body)
  let scheme = call_564348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564348.url(scheme.get, call_564348.host, call_564348.base,
                         call_564348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564348, url, valid)

proc call*(call_564349: Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_564339;
          apiVersion: string; batchConfigurationName: string;
          subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; batchConfiguration: JsonNode): Recallable =
  ## integrationAccountBatchConfigurationsCreateOrUpdate
  ## Create or update a batch configuration for an integration account.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   batchConfigurationName: string (required)
  ##                         : The batch configuration name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   batchConfiguration: JObject (required)
  ##                     : The batch configuration.
  var path_564350 = newJObject()
  var query_564351 = newJObject()
  var body_564352 = newJObject()
  add(query_564351, "api-version", newJString(apiVersion))
  add(path_564350, "batchConfigurationName", newJString(batchConfigurationName))
  add(path_564350, "subscriptionId", newJString(subscriptionId))
  add(path_564350, "resourceGroupName", newJString(resourceGroupName))
  add(path_564350, "integrationAccountName", newJString(integrationAccountName))
  if batchConfiguration != nil:
    body_564352 = batchConfiguration
  result = call_564349.call(path_564350, query_564351, nil, nil, body_564352)

var integrationAccountBatchConfigurationsCreateOrUpdate* = Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_564339(
    name: "integrationAccountBatchConfigurationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations/{batchConfigurationName}",
    validator: validate_IntegrationAccountBatchConfigurationsCreateOrUpdate_564340,
    base: "", url: url_IntegrationAccountBatchConfigurationsCreateOrUpdate_564341,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsGet_564327 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountBatchConfigurationsGet_564329(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "batchConfigurationName" in path,
        "`batchConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/batchConfigurations/"),
               (kind: VariableSegment, value: "batchConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountBatchConfigurationsGet_564328(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a batch configuration for an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   batchConfigurationName: JString (required)
  ##                         : The batch configuration name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `batchConfigurationName` field"
  var valid_564330 = path.getOrDefault("batchConfigurationName")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "batchConfigurationName", valid_564330
  var valid_564331 = path.getOrDefault("subscriptionId")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "subscriptionId", valid_564331
  var valid_564332 = path.getOrDefault("resourceGroupName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "resourceGroupName", valid_564332
  var valid_564333 = path.getOrDefault("integrationAccountName")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "integrationAccountName", valid_564333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564334 = query.getOrDefault("api-version")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "api-version", valid_564334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564335: Call_IntegrationAccountBatchConfigurationsGet_564327;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a batch configuration for an integration account.
  ## 
  let valid = call_564335.validator(path, query, header, formData, body)
  let scheme = call_564335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564335.url(scheme.get, call_564335.host, call_564335.base,
                         call_564335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564335, url, valid)

proc call*(call_564336: Call_IntegrationAccountBatchConfigurationsGet_564327;
          apiVersion: string; batchConfigurationName: string;
          subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## integrationAccountBatchConfigurationsGet
  ## Get a batch configuration for an integration account.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   batchConfigurationName: string (required)
  ##                         : The batch configuration name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564337 = newJObject()
  var query_564338 = newJObject()
  add(query_564338, "api-version", newJString(apiVersion))
  add(path_564337, "batchConfigurationName", newJString(batchConfigurationName))
  add(path_564337, "subscriptionId", newJString(subscriptionId))
  add(path_564337, "resourceGroupName", newJString(resourceGroupName))
  add(path_564337, "integrationAccountName", newJString(integrationAccountName))
  result = call_564336.call(path_564337, query_564338, nil, nil, nil)

var integrationAccountBatchConfigurationsGet* = Call_IntegrationAccountBatchConfigurationsGet_564327(
    name: "integrationAccountBatchConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations/{batchConfigurationName}",
    validator: validate_IntegrationAccountBatchConfigurationsGet_564328, base: "",
    url: url_IntegrationAccountBatchConfigurationsGet_564329,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsDelete_564353 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountBatchConfigurationsDelete_564355(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "batchConfigurationName" in path,
        "`batchConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/batchConfigurations/"),
               (kind: VariableSegment, value: "batchConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountBatchConfigurationsDelete_564354(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a batch configuration for an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   batchConfigurationName: JString (required)
  ##                         : The batch configuration name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `batchConfigurationName` field"
  var valid_564356 = path.getOrDefault("batchConfigurationName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "batchConfigurationName", valid_564356
  var valid_564357 = path.getOrDefault("subscriptionId")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "subscriptionId", valid_564357
  var valid_564358 = path.getOrDefault("resourceGroupName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "resourceGroupName", valid_564358
  var valid_564359 = path.getOrDefault("integrationAccountName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "integrationAccountName", valid_564359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564360 = query.getOrDefault("api-version")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "api-version", valid_564360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564361: Call_IntegrationAccountBatchConfigurationsDelete_564353;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a batch configuration for an integration account.
  ## 
  let valid = call_564361.validator(path, query, header, formData, body)
  let scheme = call_564361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564361.url(scheme.get, call_564361.host, call_564361.base,
                         call_564361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564361, url, valid)

proc call*(call_564362: Call_IntegrationAccountBatchConfigurationsDelete_564353;
          apiVersion: string; batchConfigurationName: string;
          subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## integrationAccountBatchConfigurationsDelete
  ## Delete a batch configuration for an integration account.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   batchConfigurationName: string (required)
  ##                         : The batch configuration name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564363 = newJObject()
  var query_564364 = newJObject()
  add(query_564364, "api-version", newJString(apiVersion))
  add(path_564363, "batchConfigurationName", newJString(batchConfigurationName))
  add(path_564363, "subscriptionId", newJString(subscriptionId))
  add(path_564363, "resourceGroupName", newJString(resourceGroupName))
  add(path_564363, "integrationAccountName", newJString(integrationAccountName))
  result = call_564362.call(path_564363, query_564364, nil, nil, nil)

var integrationAccountBatchConfigurationsDelete* = Call_IntegrationAccountBatchConfigurationsDelete_564353(
    name: "integrationAccountBatchConfigurationsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations/{batchConfigurationName}",
    validator: validate_IntegrationAccountBatchConfigurationsDelete_564354,
    base: "", url: url_IntegrationAccountBatchConfigurationsDelete_564355,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesList_564365 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountCertificatesList_564367(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/certificates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountCertificatesList_564366(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account certificates.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564368 = path.getOrDefault("subscriptionId")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "subscriptionId", valid_564368
  var valid_564369 = path.getOrDefault("resourceGroupName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "resourceGroupName", valid_564369
  var valid_564370 = path.getOrDefault("integrationAccountName")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "integrationAccountName", valid_564370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564371 = query.getOrDefault("api-version")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "api-version", valid_564371
  var valid_564372 = query.getOrDefault("$top")
  valid_564372 = validateParameter(valid_564372, JInt, required = false, default = nil)
  if valid_564372 != nil:
    section.add "$top", valid_564372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564373: Call_IntegrationAccountCertificatesList_564365;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account certificates.
  ## 
  let valid = call_564373.validator(path, query, header, formData, body)
  let scheme = call_564373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564373.url(scheme.get, call_564373.host, call_564373.base,
                         call_564373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564373, url, valid)

proc call*(call_564374: Call_IntegrationAccountCertificatesList_564365;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; Top: int = 0): Recallable =
  ## integrationAccountCertificatesList
  ## Gets a list of integration account certificates.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564375 = newJObject()
  var query_564376 = newJObject()
  add(query_564376, "api-version", newJString(apiVersion))
  add(query_564376, "$top", newJInt(Top))
  add(path_564375, "subscriptionId", newJString(subscriptionId))
  add(path_564375, "resourceGroupName", newJString(resourceGroupName))
  add(path_564375, "integrationAccountName", newJString(integrationAccountName))
  result = call_564374.call(path_564375, query_564376, nil, nil, nil)

var integrationAccountCertificatesList* = Call_IntegrationAccountCertificatesList_564365(
    name: "integrationAccountCertificatesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates",
    validator: validate_IntegrationAccountCertificatesList_564366, base: "",
    url: url_IntegrationAccountCertificatesList_564367, schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesCreateOrUpdate_564389 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountCertificatesCreateOrUpdate_564391(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountCertificatesCreateOrUpdate_564390(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   certificateName: JString (required)
  ##                  : The integration account certificate name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564392 = path.getOrDefault("subscriptionId")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "subscriptionId", valid_564392
  var valid_564393 = path.getOrDefault("resourceGroupName")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "resourceGroupName", valid_564393
  var valid_564394 = path.getOrDefault("integrationAccountName")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "integrationAccountName", valid_564394
  var valid_564395 = path.getOrDefault("certificateName")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "certificateName", valid_564395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564396 = query.getOrDefault("api-version")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "api-version", valid_564396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   certificate: JObject (required)
  ##              : The integration account certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564398: Call_IntegrationAccountCertificatesCreateOrUpdate_564389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account certificate.
  ## 
  let valid = call_564398.validator(path, query, header, formData, body)
  let scheme = call_564398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564398.url(scheme.get, call_564398.host, call_564398.base,
                         call_564398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564398, url, valid)

proc call*(call_564399: Call_IntegrationAccountCertificatesCreateOrUpdate_564389;
          apiVersion: string; certificate: JsonNode; subscriptionId: string;
          resourceGroupName: string; integrationAccountName: string;
          certificateName: string): Recallable =
  ## integrationAccountCertificatesCreateOrUpdate
  ## Creates or updates an integration account certificate.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   certificate: JObject (required)
  ##              : The integration account certificate.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   certificateName: string (required)
  ##                  : The integration account certificate name.
  var path_564400 = newJObject()
  var query_564401 = newJObject()
  var body_564402 = newJObject()
  add(query_564401, "api-version", newJString(apiVersion))
  if certificate != nil:
    body_564402 = certificate
  add(path_564400, "subscriptionId", newJString(subscriptionId))
  add(path_564400, "resourceGroupName", newJString(resourceGroupName))
  add(path_564400, "integrationAccountName", newJString(integrationAccountName))
  add(path_564400, "certificateName", newJString(certificateName))
  result = call_564399.call(path_564400, query_564401, nil, nil, body_564402)

var integrationAccountCertificatesCreateOrUpdate* = Call_IntegrationAccountCertificatesCreateOrUpdate_564389(
    name: "integrationAccountCertificatesCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_IntegrationAccountCertificatesCreateOrUpdate_564390,
    base: "", url: url_IntegrationAccountCertificatesCreateOrUpdate_564391,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesGet_564377 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountCertificatesGet_564379(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountCertificatesGet_564378(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   certificateName: JString (required)
  ##                  : The integration account certificate name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564380 = path.getOrDefault("subscriptionId")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "subscriptionId", valid_564380
  var valid_564381 = path.getOrDefault("resourceGroupName")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "resourceGroupName", valid_564381
  var valid_564382 = path.getOrDefault("integrationAccountName")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "integrationAccountName", valid_564382
  var valid_564383 = path.getOrDefault("certificateName")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "certificateName", valid_564383
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564384 = query.getOrDefault("api-version")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "api-version", valid_564384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564385: Call_IntegrationAccountCertificatesGet_564377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an integration account certificate.
  ## 
  let valid = call_564385.validator(path, query, header, formData, body)
  let scheme = call_564385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564385.url(scheme.get, call_564385.host, call_564385.base,
                         call_564385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564385, url, valid)

proc call*(call_564386: Call_IntegrationAccountCertificatesGet_564377;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; certificateName: string): Recallable =
  ## integrationAccountCertificatesGet
  ## Gets an integration account certificate.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   certificateName: string (required)
  ##                  : The integration account certificate name.
  var path_564387 = newJObject()
  var query_564388 = newJObject()
  add(query_564388, "api-version", newJString(apiVersion))
  add(path_564387, "subscriptionId", newJString(subscriptionId))
  add(path_564387, "resourceGroupName", newJString(resourceGroupName))
  add(path_564387, "integrationAccountName", newJString(integrationAccountName))
  add(path_564387, "certificateName", newJString(certificateName))
  result = call_564386.call(path_564387, query_564388, nil, nil, nil)

var integrationAccountCertificatesGet* = Call_IntegrationAccountCertificatesGet_564377(
    name: "integrationAccountCertificatesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_IntegrationAccountCertificatesGet_564378, base: "",
    url: url_IntegrationAccountCertificatesGet_564379, schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesDelete_564403 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountCertificatesDelete_564405(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountCertificatesDelete_564404(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   certificateName: JString (required)
  ##                  : The integration account certificate name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564406 = path.getOrDefault("subscriptionId")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "subscriptionId", valid_564406
  var valid_564407 = path.getOrDefault("resourceGroupName")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "resourceGroupName", valid_564407
  var valid_564408 = path.getOrDefault("integrationAccountName")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "integrationAccountName", valid_564408
  var valid_564409 = path.getOrDefault("certificateName")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "certificateName", valid_564409
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564410 = query.getOrDefault("api-version")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "api-version", valid_564410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564411: Call_IntegrationAccountCertificatesDelete_564403;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account certificate.
  ## 
  let valid = call_564411.validator(path, query, header, formData, body)
  let scheme = call_564411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564411.url(scheme.get, call_564411.host, call_564411.base,
                         call_564411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564411, url, valid)

proc call*(call_564412: Call_IntegrationAccountCertificatesDelete_564403;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; certificateName: string): Recallable =
  ## integrationAccountCertificatesDelete
  ## Deletes an integration account certificate.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   certificateName: string (required)
  ##                  : The integration account certificate name.
  var path_564413 = newJObject()
  var query_564414 = newJObject()
  add(query_564414, "api-version", newJString(apiVersion))
  add(path_564413, "subscriptionId", newJString(subscriptionId))
  add(path_564413, "resourceGroupName", newJString(resourceGroupName))
  add(path_564413, "integrationAccountName", newJString(integrationAccountName))
  add(path_564413, "certificateName", newJString(certificateName))
  result = call_564412.call(path_564413, query_564414, nil, nil, nil)

var integrationAccountCertificatesDelete* = Call_IntegrationAccountCertificatesDelete_564403(
    name: "integrationAccountCertificatesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_IntegrationAccountCertificatesDelete_564404, base: "",
    url: url_IntegrationAccountCertificatesDelete_564405, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListCallbackUrl_564415 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsListCallbackUrl_564417(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/listCallbackUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsListCallbackUrl_564416(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the integration account callback URL.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564418 = path.getOrDefault("subscriptionId")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "subscriptionId", valid_564418
  var valid_564419 = path.getOrDefault("resourceGroupName")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "resourceGroupName", valid_564419
  var valid_564420 = path.getOrDefault("integrationAccountName")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "integrationAccountName", valid_564420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564421 = query.getOrDefault("api-version")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "api-version", valid_564421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The callback URL parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564423: Call_IntegrationAccountsListCallbackUrl_564415;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the integration account callback URL.
  ## 
  let valid = call_564423.validator(path, query, header, formData, body)
  let scheme = call_564423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564423.url(scheme.get, call_564423.host, call_564423.base,
                         call_564423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564423, url, valid)

proc call*(call_564424: Call_IntegrationAccountsListCallbackUrl_564415;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode; integrationAccountName: string): Recallable =
  ## integrationAccountsListCallbackUrl
  ## Gets the integration account callback URL.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   parameters: JObject (required)
  ##             : The callback URL parameters.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564425 = newJObject()
  var query_564426 = newJObject()
  var body_564427 = newJObject()
  add(query_564426, "api-version", newJString(apiVersion))
  add(path_564425, "subscriptionId", newJString(subscriptionId))
  add(path_564425, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564427 = parameters
  add(path_564425, "integrationAccountName", newJString(integrationAccountName))
  result = call_564424.call(path_564425, query_564426, nil, nil, body_564427)

var integrationAccountsListCallbackUrl* = Call_IntegrationAccountsListCallbackUrl_564415(
    name: "integrationAccountsListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/listCallbackUrl",
    validator: validate_IntegrationAccountsListCallbackUrl_564416, base: "",
    url: url_IntegrationAccountsListCallbackUrl_564417, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListKeyVaultKeys_564428 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsListKeyVaultKeys_564430(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/listKeyVaultKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsListKeyVaultKeys_564429(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the integration account's Key Vault keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564431 = path.getOrDefault("subscriptionId")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "subscriptionId", valid_564431
  var valid_564432 = path.getOrDefault("resourceGroupName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "resourceGroupName", valid_564432
  var valid_564433 = path.getOrDefault("integrationAccountName")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "integrationAccountName", valid_564433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564434 = query.getOrDefault("api-version")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "api-version", valid_564434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   listKeyVaultKeys: JObject (required)
  ##                   : The key vault parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564436: Call_IntegrationAccountsListKeyVaultKeys_564428;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the integration account's Key Vault keys.
  ## 
  let valid = call_564436.validator(path, query, header, formData, body)
  let scheme = call_564436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564436.url(scheme.get, call_564436.host, call_564436.base,
                         call_564436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564436, url, valid)

proc call*(call_564437: Call_IntegrationAccountsListKeyVaultKeys_564428;
          apiVersion: string; subscriptionId: string; listKeyVaultKeys: JsonNode;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## integrationAccountsListKeyVaultKeys
  ## Gets the integration account's Key Vault keys.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   listKeyVaultKeys: JObject (required)
  ##                   : The key vault parameters.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564438 = newJObject()
  var query_564439 = newJObject()
  var body_564440 = newJObject()
  add(query_564439, "api-version", newJString(apiVersion))
  add(path_564438, "subscriptionId", newJString(subscriptionId))
  if listKeyVaultKeys != nil:
    body_564440 = listKeyVaultKeys
  add(path_564438, "resourceGroupName", newJString(resourceGroupName))
  add(path_564438, "integrationAccountName", newJString(integrationAccountName))
  result = call_564437.call(path_564438, query_564439, nil, nil, body_564440)

var integrationAccountsListKeyVaultKeys* = Call_IntegrationAccountsListKeyVaultKeys_564428(
    name: "integrationAccountsListKeyVaultKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/listKeyVaultKeys",
    validator: validate_IntegrationAccountsListKeyVaultKeys_564429, base: "",
    url: url_IntegrationAccountsListKeyVaultKeys_564430, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsLogTrackingEvents_564441 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsLogTrackingEvents_564443(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/logTrackingEvents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsLogTrackingEvents_564442(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Logs the integration account's tracking events.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564444 = path.getOrDefault("subscriptionId")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "subscriptionId", valid_564444
  var valid_564445 = path.getOrDefault("resourceGroupName")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "resourceGroupName", valid_564445
  var valid_564446 = path.getOrDefault("integrationAccountName")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "integrationAccountName", valid_564446
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564447 = query.getOrDefault("api-version")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "api-version", valid_564447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   logTrackingEvents: JObject (required)
  ##                    : The callback URL parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564449: Call_IntegrationAccountsLogTrackingEvents_564441;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Logs the integration account's tracking events.
  ## 
  let valid = call_564449.validator(path, query, header, formData, body)
  let scheme = call_564449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564449.url(scheme.get, call_564449.host, call_564449.base,
                         call_564449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564449, url, valid)

proc call*(call_564450: Call_IntegrationAccountsLogTrackingEvents_564441;
          apiVersion: string; logTrackingEvents: JsonNode; subscriptionId: string;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## integrationAccountsLogTrackingEvents
  ## Logs the integration account's tracking events.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   logTrackingEvents: JObject (required)
  ##                    : The callback URL parameters.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564451 = newJObject()
  var query_564452 = newJObject()
  var body_564453 = newJObject()
  add(query_564452, "api-version", newJString(apiVersion))
  if logTrackingEvents != nil:
    body_564453 = logTrackingEvents
  add(path_564451, "subscriptionId", newJString(subscriptionId))
  add(path_564451, "resourceGroupName", newJString(resourceGroupName))
  add(path_564451, "integrationAccountName", newJString(integrationAccountName))
  result = call_564450.call(path_564451, query_564452, nil, nil, body_564453)

var integrationAccountsLogTrackingEvents* = Call_IntegrationAccountsLogTrackingEvents_564441(
    name: "integrationAccountsLogTrackingEvents", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/logTrackingEvents",
    validator: validate_IntegrationAccountsLogTrackingEvents_564442, base: "",
    url: url_IntegrationAccountsLogTrackingEvents_564443, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsList_564454 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountMapsList_564456(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/maps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountMapsList_564455(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account maps.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564457 = path.getOrDefault("subscriptionId")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "subscriptionId", valid_564457
  var valid_564458 = path.getOrDefault("resourceGroupName")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "resourceGroupName", valid_564458
  var valid_564459 = path.getOrDefault("integrationAccountName")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "integrationAccountName", valid_564459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Options for filters include: MapType.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564460 = query.getOrDefault("api-version")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "api-version", valid_564460
  var valid_564461 = query.getOrDefault("$top")
  valid_564461 = validateParameter(valid_564461, JInt, required = false, default = nil)
  if valid_564461 != nil:
    section.add "$top", valid_564461
  var valid_564462 = query.getOrDefault("$filter")
  valid_564462 = validateParameter(valid_564462, JString, required = false,
                                 default = nil)
  if valid_564462 != nil:
    section.add "$filter", valid_564462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564463: Call_IntegrationAccountMapsList_564454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account maps.
  ## 
  let valid = call_564463.validator(path, query, header, formData, body)
  let scheme = call_564463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564463.url(scheme.get, call_564463.host, call_564463.base,
                         call_564463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564463, url, valid)

proc call*(call_564464: Call_IntegrationAccountMapsList_564454; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; Top: int = 0; Filter: string = ""): Recallable =
  ## integrationAccountMapsList
  ## Gets a list of integration account maps.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   Filter: string
  ##         : The filter to apply on the operation. Options for filters include: MapType.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564465 = newJObject()
  var query_564466 = newJObject()
  add(query_564466, "api-version", newJString(apiVersion))
  add(query_564466, "$top", newJInt(Top))
  add(path_564465, "subscriptionId", newJString(subscriptionId))
  add(path_564465, "resourceGroupName", newJString(resourceGroupName))
  add(query_564466, "$filter", newJString(Filter))
  add(path_564465, "integrationAccountName", newJString(integrationAccountName))
  result = call_564464.call(path_564465, query_564466, nil, nil, nil)

var integrationAccountMapsList* = Call_IntegrationAccountMapsList_564454(
    name: "integrationAccountMapsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps",
    validator: validate_IntegrationAccountMapsList_564455, base: "",
    url: url_IntegrationAccountMapsList_564456, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsCreateOrUpdate_564479 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountMapsCreateOrUpdate_564481(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "mapName" in path, "`mapName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/maps/"),
               (kind: VariableSegment, value: "mapName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountMapsCreateOrUpdate_564480(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account map.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   mapName: JString (required)
  ##          : The integration account map name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `mapName` field"
  var valid_564482 = path.getOrDefault("mapName")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "mapName", valid_564482
  var valid_564483 = path.getOrDefault("subscriptionId")
  valid_564483 = validateParameter(valid_564483, JString, required = true,
                                 default = nil)
  if valid_564483 != nil:
    section.add "subscriptionId", valid_564483
  var valid_564484 = path.getOrDefault("resourceGroupName")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "resourceGroupName", valid_564484
  var valid_564485 = path.getOrDefault("integrationAccountName")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "integrationAccountName", valid_564485
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564486 = query.getOrDefault("api-version")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "api-version", valid_564486
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   map: JObject (required)
  ##      : The integration account map.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564488: Call_IntegrationAccountMapsCreateOrUpdate_564479;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account map.
  ## 
  let valid = call_564488.validator(path, query, header, formData, body)
  let scheme = call_564488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564488.url(scheme.get, call_564488.host, call_564488.base,
                         call_564488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564488, url, valid)

proc call*(call_564489: Call_IntegrationAccountMapsCreateOrUpdate_564479;
          map: JsonNode; apiVersion: string; mapName: string; subscriptionId: string;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## integrationAccountMapsCreateOrUpdate
  ## Creates or updates an integration account map.
  ##   map: JObject (required)
  ##      : The integration account map.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   mapName: string (required)
  ##          : The integration account map name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564490 = newJObject()
  var query_564491 = newJObject()
  var body_564492 = newJObject()
  if map != nil:
    body_564492 = map
  add(query_564491, "api-version", newJString(apiVersion))
  add(path_564490, "mapName", newJString(mapName))
  add(path_564490, "subscriptionId", newJString(subscriptionId))
  add(path_564490, "resourceGroupName", newJString(resourceGroupName))
  add(path_564490, "integrationAccountName", newJString(integrationAccountName))
  result = call_564489.call(path_564490, query_564491, nil, nil, body_564492)

var integrationAccountMapsCreateOrUpdate* = Call_IntegrationAccountMapsCreateOrUpdate_564479(
    name: "integrationAccountMapsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_IntegrationAccountMapsCreateOrUpdate_564480, base: "",
    url: url_IntegrationAccountMapsCreateOrUpdate_564481, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsGet_564467 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountMapsGet_564469(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "mapName" in path, "`mapName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/maps/"),
               (kind: VariableSegment, value: "mapName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountMapsGet_564468(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account map.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   mapName: JString (required)
  ##          : The integration account map name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `mapName` field"
  var valid_564470 = path.getOrDefault("mapName")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "mapName", valid_564470
  var valid_564471 = path.getOrDefault("subscriptionId")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "subscriptionId", valid_564471
  var valid_564472 = path.getOrDefault("resourceGroupName")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "resourceGroupName", valid_564472
  var valid_564473 = path.getOrDefault("integrationAccountName")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "integrationAccountName", valid_564473
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564474 = query.getOrDefault("api-version")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "api-version", valid_564474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564475: Call_IntegrationAccountMapsGet_564467; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account map.
  ## 
  let valid = call_564475.validator(path, query, header, formData, body)
  let scheme = call_564475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564475.url(scheme.get, call_564475.host, call_564475.base,
                         call_564475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564475, url, valid)

proc call*(call_564476: Call_IntegrationAccountMapsGet_564467; apiVersion: string;
          mapName: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## integrationAccountMapsGet
  ## Gets an integration account map.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   mapName: string (required)
  ##          : The integration account map name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564477 = newJObject()
  var query_564478 = newJObject()
  add(query_564478, "api-version", newJString(apiVersion))
  add(path_564477, "mapName", newJString(mapName))
  add(path_564477, "subscriptionId", newJString(subscriptionId))
  add(path_564477, "resourceGroupName", newJString(resourceGroupName))
  add(path_564477, "integrationAccountName", newJString(integrationAccountName))
  result = call_564476.call(path_564477, query_564478, nil, nil, nil)

var integrationAccountMapsGet* = Call_IntegrationAccountMapsGet_564467(
    name: "integrationAccountMapsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_IntegrationAccountMapsGet_564468, base: "",
    url: url_IntegrationAccountMapsGet_564469, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsDelete_564493 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountMapsDelete_564495(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "mapName" in path, "`mapName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/maps/"),
               (kind: VariableSegment, value: "mapName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountMapsDelete_564494(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account map.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   mapName: JString (required)
  ##          : The integration account map name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `mapName` field"
  var valid_564496 = path.getOrDefault("mapName")
  valid_564496 = validateParameter(valid_564496, JString, required = true,
                                 default = nil)
  if valid_564496 != nil:
    section.add "mapName", valid_564496
  var valid_564497 = path.getOrDefault("subscriptionId")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "subscriptionId", valid_564497
  var valid_564498 = path.getOrDefault("resourceGroupName")
  valid_564498 = validateParameter(valid_564498, JString, required = true,
                                 default = nil)
  if valid_564498 != nil:
    section.add "resourceGroupName", valid_564498
  var valid_564499 = path.getOrDefault("integrationAccountName")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "integrationAccountName", valid_564499
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564500 = query.getOrDefault("api-version")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "api-version", valid_564500
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564501: Call_IntegrationAccountMapsDelete_564493; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account map.
  ## 
  let valid = call_564501.validator(path, query, header, formData, body)
  let scheme = call_564501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564501.url(scheme.get, call_564501.host, call_564501.base,
                         call_564501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564501, url, valid)

proc call*(call_564502: Call_IntegrationAccountMapsDelete_564493;
          apiVersion: string; mapName: string; subscriptionId: string;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## integrationAccountMapsDelete
  ## Deletes an integration account map.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   mapName: string (required)
  ##          : The integration account map name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564503 = newJObject()
  var query_564504 = newJObject()
  add(query_564504, "api-version", newJString(apiVersion))
  add(path_564503, "mapName", newJString(mapName))
  add(path_564503, "subscriptionId", newJString(subscriptionId))
  add(path_564503, "resourceGroupName", newJString(resourceGroupName))
  add(path_564503, "integrationAccountName", newJString(integrationAccountName))
  result = call_564502.call(path_564503, query_564504, nil, nil, nil)

var integrationAccountMapsDelete* = Call_IntegrationAccountMapsDelete_564493(
    name: "integrationAccountMapsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_IntegrationAccountMapsDelete_564494, base: "",
    url: url_IntegrationAccountMapsDelete_564495, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsListContentCallbackUrl_564505 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountMapsListContentCallbackUrl_564507(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "mapName" in path, "`mapName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/maps/"),
               (kind: VariableSegment, value: "mapName"),
               (kind: ConstantSegment, value: "/listContentCallbackUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountMapsListContentCallbackUrl_564506(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the content callback url.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   mapName: JString (required)
  ##          : The integration account map name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `mapName` field"
  var valid_564508 = path.getOrDefault("mapName")
  valid_564508 = validateParameter(valid_564508, JString, required = true,
                                 default = nil)
  if valid_564508 != nil:
    section.add "mapName", valid_564508
  var valid_564509 = path.getOrDefault("subscriptionId")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = nil)
  if valid_564509 != nil:
    section.add "subscriptionId", valid_564509
  var valid_564510 = path.getOrDefault("resourceGroupName")
  valid_564510 = validateParameter(valid_564510, JString, required = true,
                                 default = nil)
  if valid_564510 != nil:
    section.add "resourceGroupName", valid_564510
  var valid_564511 = path.getOrDefault("integrationAccountName")
  valid_564511 = validateParameter(valid_564511, JString, required = true,
                                 default = nil)
  if valid_564511 != nil:
    section.add "integrationAccountName", valid_564511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564512 = query.getOrDefault("api-version")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "api-version", valid_564512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   listContentCallbackUrl: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564514: Call_IntegrationAccountMapsListContentCallbackUrl_564505;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_564514.validator(path, query, header, formData, body)
  let scheme = call_564514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564514.url(scheme.get, call_564514.host, call_564514.base,
                         call_564514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564514, url, valid)

proc call*(call_564515: Call_IntegrationAccountMapsListContentCallbackUrl_564505;
          apiVersion: string; mapName: string; subscriptionId: string;
          listContentCallbackUrl: JsonNode; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## integrationAccountMapsListContentCallbackUrl
  ## Get the content callback url.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   mapName: string (required)
  ##          : The integration account map name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   listContentCallbackUrl: JObject (required)
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564516 = newJObject()
  var query_564517 = newJObject()
  var body_564518 = newJObject()
  add(query_564517, "api-version", newJString(apiVersion))
  add(path_564516, "mapName", newJString(mapName))
  add(path_564516, "subscriptionId", newJString(subscriptionId))
  if listContentCallbackUrl != nil:
    body_564518 = listContentCallbackUrl
  add(path_564516, "resourceGroupName", newJString(resourceGroupName))
  add(path_564516, "integrationAccountName", newJString(integrationAccountName))
  result = call_564515.call(path_564516, query_564517, nil, nil, body_564518)

var integrationAccountMapsListContentCallbackUrl* = Call_IntegrationAccountMapsListContentCallbackUrl_564505(
    name: "integrationAccountMapsListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountMapsListContentCallbackUrl_564506,
    base: "", url: url_IntegrationAccountMapsListContentCallbackUrl_564507,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersList_564519 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountPartnersList_564521(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/partners")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountPartnersList_564520(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account partners.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564522 = path.getOrDefault("subscriptionId")
  valid_564522 = validateParameter(valid_564522, JString, required = true,
                                 default = nil)
  if valid_564522 != nil:
    section.add "subscriptionId", valid_564522
  var valid_564523 = path.getOrDefault("resourceGroupName")
  valid_564523 = validateParameter(valid_564523, JString, required = true,
                                 default = nil)
  if valid_564523 != nil:
    section.add "resourceGroupName", valid_564523
  var valid_564524 = path.getOrDefault("integrationAccountName")
  valid_564524 = validateParameter(valid_564524, JString, required = true,
                                 default = nil)
  if valid_564524 != nil:
    section.add "integrationAccountName", valid_564524
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Options for filters include: PartnerType.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564525 = query.getOrDefault("api-version")
  valid_564525 = validateParameter(valid_564525, JString, required = true,
                                 default = nil)
  if valid_564525 != nil:
    section.add "api-version", valid_564525
  var valid_564526 = query.getOrDefault("$top")
  valid_564526 = validateParameter(valid_564526, JInt, required = false, default = nil)
  if valid_564526 != nil:
    section.add "$top", valid_564526
  var valid_564527 = query.getOrDefault("$filter")
  valid_564527 = validateParameter(valid_564527, JString, required = false,
                                 default = nil)
  if valid_564527 != nil:
    section.add "$filter", valid_564527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564528: Call_IntegrationAccountPartnersList_564519; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account partners.
  ## 
  let valid = call_564528.validator(path, query, header, formData, body)
  let scheme = call_564528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564528.url(scheme.get, call_564528.host, call_564528.base,
                         call_564528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564528, url, valid)

proc call*(call_564529: Call_IntegrationAccountPartnersList_564519;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; Top: int = 0; Filter: string = ""): Recallable =
  ## integrationAccountPartnersList
  ## Gets a list of integration account partners.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   Filter: string
  ##         : The filter to apply on the operation. Options for filters include: PartnerType.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564530 = newJObject()
  var query_564531 = newJObject()
  add(query_564531, "api-version", newJString(apiVersion))
  add(query_564531, "$top", newJInt(Top))
  add(path_564530, "subscriptionId", newJString(subscriptionId))
  add(path_564530, "resourceGroupName", newJString(resourceGroupName))
  add(query_564531, "$filter", newJString(Filter))
  add(path_564530, "integrationAccountName", newJString(integrationAccountName))
  result = call_564529.call(path_564530, query_564531, nil, nil, nil)

var integrationAccountPartnersList* = Call_IntegrationAccountPartnersList_564519(
    name: "integrationAccountPartnersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners",
    validator: validate_IntegrationAccountPartnersList_564520, base: "",
    url: url_IntegrationAccountPartnersList_564521, schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersCreateOrUpdate_564544 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountPartnersCreateOrUpdate_564546(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "partnerName" in path, "`partnerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/partners/"),
               (kind: VariableSegment, value: "partnerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountPartnersCreateOrUpdate_564545(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account partner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   partnerName: JString (required)
  ##              : The integration account partner name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564547 = path.getOrDefault("subscriptionId")
  valid_564547 = validateParameter(valid_564547, JString, required = true,
                                 default = nil)
  if valid_564547 != nil:
    section.add "subscriptionId", valid_564547
  var valid_564548 = path.getOrDefault("partnerName")
  valid_564548 = validateParameter(valid_564548, JString, required = true,
                                 default = nil)
  if valid_564548 != nil:
    section.add "partnerName", valid_564548
  var valid_564549 = path.getOrDefault("resourceGroupName")
  valid_564549 = validateParameter(valid_564549, JString, required = true,
                                 default = nil)
  if valid_564549 != nil:
    section.add "resourceGroupName", valid_564549
  var valid_564550 = path.getOrDefault("integrationAccountName")
  valid_564550 = validateParameter(valid_564550, JString, required = true,
                                 default = nil)
  if valid_564550 != nil:
    section.add "integrationAccountName", valid_564550
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564551 = query.getOrDefault("api-version")
  valid_564551 = validateParameter(valid_564551, JString, required = true,
                                 default = nil)
  if valid_564551 != nil:
    section.add "api-version", valid_564551
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   partner: JObject (required)
  ##          : The integration account partner.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564553: Call_IntegrationAccountPartnersCreateOrUpdate_564544;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account partner.
  ## 
  let valid = call_564553.validator(path, query, header, formData, body)
  let scheme = call_564553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564553.url(scheme.get, call_564553.host, call_564553.base,
                         call_564553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564553, url, valid)

proc call*(call_564554: Call_IntegrationAccountPartnersCreateOrUpdate_564544;
          partner: JsonNode; apiVersion: string; subscriptionId: string;
          partnerName: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## integrationAccountPartnersCreateOrUpdate
  ## Creates or updates an integration account partner.
  ##   partner: JObject (required)
  ##          : The integration account partner.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   partnerName: string (required)
  ##              : The integration account partner name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564555 = newJObject()
  var query_564556 = newJObject()
  var body_564557 = newJObject()
  if partner != nil:
    body_564557 = partner
  add(query_564556, "api-version", newJString(apiVersion))
  add(path_564555, "subscriptionId", newJString(subscriptionId))
  add(path_564555, "partnerName", newJString(partnerName))
  add(path_564555, "resourceGroupName", newJString(resourceGroupName))
  add(path_564555, "integrationAccountName", newJString(integrationAccountName))
  result = call_564554.call(path_564555, query_564556, nil, nil, body_564557)

var integrationAccountPartnersCreateOrUpdate* = Call_IntegrationAccountPartnersCreateOrUpdate_564544(
    name: "integrationAccountPartnersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_IntegrationAccountPartnersCreateOrUpdate_564545, base: "",
    url: url_IntegrationAccountPartnersCreateOrUpdate_564546,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersGet_564532 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountPartnersGet_564534(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "partnerName" in path, "`partnerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/partners/"),
               (kind: VariableSegment, value: "partnerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountPartnersGet_564533(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account partner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   partnerName: JString (required)
  ##              : The integration account partner name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564535 = path.getOrDefault("subscriptionId")
  valid_564535 = validateParameter(valid_564535, JString, required = true,
                                 default = nil)
  if valid_564535 != nil:
    section.add "subscriptionId", valid_564535
  var valid_564536 = path.getOrDefault("partnerName")
  valid_564536 = validateParameter(valid_564536, JString, required = true,
                                 default = nil)
  if valid_564536 != nil:
    section.add "partnerName", valid_564536
  var valid_564537 = path.getOrDefault("resourceGroupName")
  valid_564537 = validateParameter(valid_564537, JString, required = true,
                                 default = nil)
  if valid_564537 != nil:
    section.add "resourceGroupName", valid_564537
  var valid_564538 = path.getOrDefault("integrationAccountName")
  valid_564538 = validateParameter(valid_564538, JString, required = true,
                                 default = nil)
  if valid_564538 != nil:
    section.add "integrationAccountName", valid_564538
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564539 = query.getOrDefault("api-version")
  valid_564539 = validateParameter(valid_564539, JString, required = true,
                                 default = nil)
  if valid_564539 != nil:
    section.add "api-version", valid_564539
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564540: Call_IntegrationAccountPartnersGet_564532; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account partner.
  ## 
  let valid = call_564540.validator(path, query, header, formData, body)
  let scheme = call_564540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564540.url(scheme.get, call_564540.host, call_564540.base,
                         call_564540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564540, url, valid)

proc call*(call_564541: Call_IntegrationAccountPartnersGet_564532;
          apiVersion: string; subscriptionId: string; partnerName: string;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## integrationAccountPartnersGet
  ## Gets an integration account partner.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   partnerName: string (required)
  ##              : The integration account partner name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564542 = newJObject()
  var query_564543 = newJObject()
  add(query_564543, "api-version", newJString(apiVersion))
  add(path_564542, "subscriptionId", newJString(subscriptionId))
  add(path_564542, "partnerName", newJString(partnerName))
  add(path_564542, "resourceGroupName", newJString(resourceGroupName))
  add(path_564542, "integrationAccountName", newJString(integrationAccountName))
  result = call_564541.call(path_564542, query_564543, nil, nil, nil)

var integrationAccountPartnersGet* = Call_IntegrationAccountPartnersGet_564532(
    name: "integrationAccountPartnersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_IntegrationAccountPartnersGet_564533, base: "",
    url: url_IntegrationAccountPartnersGet_564534, schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersDelete_564558 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountPartnersDelete_564560(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "partnerName" in path, "`partnerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/partners/"),
               (kind: VariableSegment, value: "partnerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountPartnersDelete_564559(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account partner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   partnerName: JString (required)
  ##              : The integration account partner name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564561 = path.getOrDefault("subscriptionId")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = nil)
  if valid_564561 != nil:
    section.add "subscriptionId", valid_564561
  var valid_564562 = path.getOrDefault("partnerName")
  valid_564562 = validateParameter(valid_564562, JString, required = true,
                                 default = nil)
  if valid_564562 != nil:
    section.add "partnerName", valid_564562
  var valid_564563 = path.getOrDefault("resourceGroupName")
  valid_564563 = validateParameter(valid_564563, JString, required = true,
                                 default = nil)
  if valid_564563 != nil:
    section.add "resourceGroupName", valid_564563
  var valid_564564 = path.getOrDefault("integrationAccountName")
  valid_564564 = validateParameter(valid_564564, JString, required = true,
                                 default = nil)
  if valid_564564 != nil:
    section.add "integrationAccountName", valid_564564
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564565 = query.getOrDefault("api-version")
  valid_564565 = validateParameter(valid_564565, JString, required = true,
                                 default = nil)
  if valid_564565 != nil:
    section.add "api-version", valid_564565
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564566: Call_IntegrationAccountPartnersDelete_564558;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account partner.
  ## 
  let valid = call_564566.validator(path, query, header, formData, body)
  let scheme = call_564566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564566.url(scheme.get, call_564566.host, call_564566.base,
                         call_564566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564566, url, valid)

proc call*(call_564567: Call_IntegrationAccountPartnersDelete_564558;
          apiVersion: string; subscriptionId: string; partnerName: string;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## integrationAccountPartnersDelete
  ## Deletes an integration account partner.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   partnerName: string (required)
  ##              : The integration account partner name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564568 = newJObject()
  var query_564569 = newJObject()
  add(query_564569, "api-version", newJString(apiVersion))
  add(path_564568, "subscriptionId", newJString(subscriptionId))
  add(path_564568, "partnerName", newJString(partnerName))
  add(path_564568, "resourceGroupName", newJString(resourceGroupName))
  add(path_564568, "integrationAccountName", newJString(integrationAccountName))
  result = call_564567.call(path_564568, query_564569, nil, nil, nil)

var integrationAccountPartnersDelete* = Call_IntegrationAccountPartnersDelete_564558(
    name: "integrationAccountPartnersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_IntegrationAccountPartnersDelete_564559, base: "",
    url: url_IntegrationAccountPartnersDelete_564560, schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersListContentCallbackUrl_564570 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountPartnersListContentCallbackUrl_564572(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "partnerName" in path, "`partnerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/partners/"),
               (kind: VariableSegment, value: "partnerName"),
               (kind: ConstantSegment, value: "/listContentCallbackUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountPartnersListContentCallbackUrl_564571(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the content callback url.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   partnerName: JString (required)
  ##              : The integration account partner name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564573 = path.getOrDefault("subscriptionId")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = nil)
  if valid_564573 != nil:
    section.add "subscriptionId", valid_564573
  var valid_564574 = path.getOrDefault("partnerName")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "partnerName", valid_564574
  var valid_564575 = path.getOrDefault("resourceGroupName")
  valid_564575 = validateParameter(valid_564575, JString, required = true,
                                 default = nil)
  if valid_564575 != nil:
    section.add "resourceGroupName", valid_564575
  var valid_564576 = path.getOrDefault("integrationAccountName")
  valid_564576 = validateParameter(valid_564576, JString, required = true,
                                 default = nil)
  if valid_564576 != nil:
    section.add "integrationAccountName", valid_564576
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564577 = query.getOrDefault("api-version")
  valid_564577 = validateParameter(valid_564577, JString, required = true,
                                 default = nil)
  if valid_564577 != nil:
    section.add "api-version", valid_564577
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   listContentCallbackUrl: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564579: Call_IntegrationAccountPartnersListContentCallbackUrl_564570;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_564579.validator(path, query, header, formData, body)
  let scheme = call_564579.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564579.url(scheme.get, call_564579.host, call_564579.base,
                         call_564579.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564579, url, valid)

proc call*(call_564580: Call_IntegrationAccountPartnersListContentCallbackUrl_564570;
          apiVersion: string; subscriptionId: string; partnerName: string;
          listContentCallbackUrl: JsonNode; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## integrationAccountPartnersListContentCallbackUrl
  ## Get the content callback url.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   partnerName: string (required)
  ##              : The integration account partner name.
  ##   listContentCallbackUrl: JObject (required)
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564581 = newJObject()
  var query_564582 = newJObject()
  var body_564583 = newJObject()
  add(query_564582, "api-version", newJString(apiVersion))
  add(path_564581, "subscriptionId", newJString(subscriptionId))
  add(path_564581, "partnerName", newJString(partnerName))
  if listContentCallbackUrl != nil:
    body_564583 = listContentCallbackUrl
  add(path_564581, "resourceGroupName", newJString(resourceGroupName))
  add(path_564581, "integrationAccountName", newJString(integrationAccountName))
  result = call_564580.call(path_564581, query_564582, nil, nil, body_564583)

var integrationAccountPartnersListContentCallbackUrl* = Call_IntegrationAccountPartnersListContentCallbackUrl_564570(
    name: "integrationAccountPartnersListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountPartnersListContentCallbackUrl_564571,
    base: "", url: url_IntegrationAccountPartnersListContentCallbackUrl_564572,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountsRegenerateAccessKey_564584 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsRegenerateAccessKey_564586(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/regenerateAccessKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsRegenerateAccessKey_564585(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the integration account access key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564587 = path.getOrDefault("subscriptionId")
  valid_564587 = validateParameter(valid_564587, JString, required = true,
                                 default = nil)
  if valid_564587 != nil:
    section.add "subscriptionId", valid_564587
  var valid_564588 = path.getOrDefault("resourceGroupName")
  valid_564588 = validateParameter(valid_564588, JString, required = true,
                                 default = nil)
  if valid_564588 != nil:
    section.add "resourceGroupName", valid_564588
  var valid_564589 = path.getOrDefault("integrationAccountName")
  valid_564589 = validateParameter(valid_564589, JString, required = true,
                                 default = nil)
  if valid_564589 != nil:
    section.add "integrationAccountName", valid_564589
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564590 = query.getOrDefault("api-version")
  valid_564590 = validateParameter(valid_564590, JString, required = true,
                                 default = nil)
  if valid_564590 != nil:
    section.add "api-version", valid_564590
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regenerateAccessKey: JObject (required)
  ##                      : The access key type.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564592: Call_IntegrationAccountsRegenerateAccessKey_564584;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the integration account access key.
  ## 
  let valid = call_564592.validator(path, query, header, formData, body)
  let scheme = call_564592.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564592.url(scheme.get, call_564592.host, call_564592.base,
                         call_564592.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564592, url, valid)

proc call*(call_564593: Call_IntegrationAccountsRegenerateAccessKey_564584;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          regenerateAccessKey: JsonNode; integrationAccountName: string): Recallable =
  ## integrationAccountsRegenerateAccessKey
  ## Regenerates the integration account access key.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   regenerateAccessKey: JObject (required)
  ##                      : The access key type.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564594 = newJObject()
  var query_564595 = newJObject()
  var body_564596 = newJObject()
  add(query_564595, "api-version", newJString(apiVersion))
  add(path_564594, "subscriptionId", newJString(subscriptionId))
  add(path_564594, "resourceGroupName", newJString(resourceGroupName))
  if regenerateAccessKey != nil:
    body_564596 = regenerateAccessKey
  add(path_564594, "integrationAccountName", newJString(integrationAccountName))
  result = call_564593.call(path_564594, query_564595, nil, nil, body_564596)

var integrationAccountsRegenerateAccessKey* = Call_IntegrationAccountsRegenerateAccessKey_564584(
    name: "integrationAccountsRegenerateAccessKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/regenerateAccessKey",
    validator: validate_IntegrationAccountsRegenerateAccessKey_564585, base: "",
    url: url_IntegrationAccountsRegenerateAccessKey_564586,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasList_564597 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountSchemasList_564599(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/schemas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountSchemasList_564598(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account schemas.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564600 = path.getOrDefault("subscriptionId")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = nil)
  if valid_564600 != nil:
    section.add "subscriptionId", valid_564600
  var valid_564601 = path.getOrDefault("resourceGroupName")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = nil)
  if valid_564601 != nil:
    section.add "resourceGroupName", valid_564601
  var valid_564602 = path.getOrDefault("integrationAccountName")
  valid_564602 = validateParameter(valid_564602, JString, required = true,
                                 default = nil)
  if valid_564602 != nil:
    section.add "integrationAccountName", valid_564602
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Options for filters include: SchemaType.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564603 = query.getOrDefault("api-version")
  valid_564603 = validateParameter(valid_564603, JString, required = true,
                                 default = nil)
  if valid_564603 != nil:
    section.add "api-version", valid_564603
  var valid_564604 = query.getOrDefault("$top")
  valid_564604 = validateParameter(valid_564604, JInt, required = false, default = nil)
  if valid_564604 != nil:
    section.add "$top", valid_564604
  var valid_564605 = query.getOrDefault("$filter")
  valid_564605 = validateParameter(valid_564605, JString, required = false,
                                 default = nil)
  if valid_564605 != nil:
    section.add "$filter", valid_564605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564606: Call_IntegrationAccountSchemasList_564597; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account schemas.
  ## 
  let valid = call_564606.validator(path, query, header, formData, body)
  let scheme = call_564606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564606.url(scheme.get, call_564606.host, call_564606.base,
                         call_564606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564606, url, valid)

proc call*(call_564607: Call_IntegrationAccountSchemasList_564597;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; Top: int = 0; Filter: string = ""): Recallable =
  ## integrationAccountSchemasList
  ## Gets a list of integration account schemas.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   Filter: string
  ##         : The filter to apply on the operation. Options for filters include: SchemaType.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564608 = newJObject()
  var query_564609 = newJObject()
  add(query_564609, "api-version", newJString(apiVersion))
  add(query_564609, "$top", newJInt(Top))
  add(path_564608, "subscriptionId", newJString(subscriptionId))
  add(path_564608, "resourceGroupName", newJString(resourceGroupName))
  add(query_564609, "$filter", newJString(Filter))
  add(path_564608, "integrationAccountName", newJString(integrationAccountName))
  result = call_564607.call(path_564608, query_564609, nil, nil, nil)

var integrationAccountSchemasList* = Call_IntegrationAccountSchemasList_564597(
    name: "integrationAccountSchemasList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas",
    validator: validate_IntegrationAccountSchemasList_564598, base: "",
    url: url_IntegrationAccountSchemasList_564599, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasCreateOrUpdate_564622 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountSchemasCreateOrUpdate_564624(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountSchemasCreateOrUpdate_564623(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account schema.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   schemaName: JString (required)
  ##             : The integration account schema name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564625 = path.getOrDefault("subscriptionId")
  valid_564625 = validateParameter(valid_564625, JString, required = true,
                                 default = nil)
  if valid_564625 != nil:
    section.add "subscriptionId", valid_564625
  var valid_564626 = path.getOrDefault("resourceGroupName")
  valid_564626 = validateParameter(valid_564626, JString, required = true,
                                 default = nil)
  if valid_564626 != nil:
    section.add "resourceGroupName", valid_564626
  var valid_564627 = path.getOrDefault("schemaName")
  valid_564627 = validateParameter(valid_564627, JString, required = true,
                                 default = nil)
  if valid_564627 != nil:
    section.add "schemaName", valid_564627
  var valid_564628 = path.getOrDefault("integrationAccountName")
  valid_564628 = validateParameter(valid_564628, JString, required = true,
                                 default = nil)
  if valid_564628 != nil:
    section.add "integrationAccountName", valid_564628
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564629 = query.getOrDefault("api-version")
  valid_564629 = validateParameter(valid_564629, JString, required = true,
                                 default = nil)
  if valid_564629 != nil:
    section.add "api-version", valid_564629
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schema: JObject (required)
  ##         : The integration account schema.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564631: Call_IntegrationAccountSchemasCreateOrUpdate_564622;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account schema.
  ## 
  let valid = call_564631.validator(path, query, header, formData, body)
  let scheme = call_564631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564631.url(scheme.get, call_564631.host, call_564631.base,
                         call_564631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564631, url, valid)

proc call*(call_564632: Call_IntegrationAccountSchemasCreateOrUpdate_564622;
          apiVersion: string; schema: JsonNode; subscriptionId: string;
          resourceGroupName: string; schemaName: string;
          integrationAccountName: string): Recallable =
  ## integrationAccountSchemasCreateOrUpdate
  ## Creates or updates an integration account schema.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   schema: JObject (required)
  ##         : The integration account schema.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   schemaName: string (required)
  ##             : The integration account schema name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564633 = newJObject()
  var query_564634 = newJObject()
  var body_564635 = newJObject()
  add(query_564634, "api-version", newJString(apiVersion))
  if schema != nil:
    body_564635 = schema
  add(path_564633, "subscriptionId", newJString(subscriptionId))
  add(path_564633, "resourceGroupName", newJString(resourceGroupName))
  add(path_564633, "schemaName", newJString(schemaName))
  add(path_564633, "integrationAccountName", newJString(integrationAccountName))
  result = call_564632.call(path_564633, query_564634, nil, nil, body_564635)

var integrationAccountSchemasCreateOrUpdate* = Call_IntegrationAccountSchemasCreateOrUpdate_564622(
    name: "integrationAccountSchemasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_IntegrationAccountSchemasCreateOrUpdate_564623, base: "",
    url: url_IntegrationAccountSchemasCreateOrUpdate_564624,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasGet_564610 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountSchemasGet_564612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountSchemasGet_564611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account schema.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   schemaName: JString (required)
  ##             : The integration account schema name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564613 = path.getOrDefault("subscriptionId")
  valid_564613 = validateParameter(valid_564613, JString, required = true,
                                 default = nil)
  if valid_564613 != nil:
    section.add "subscriptionId", valid_564613
  var valid_564614 = path.getOrDefault("resourceGroupName")
  valid_564614 = validateParameter(valid_564614, JString, required = true,
                                 default = nil)
  if valid_564614 != nil:
    section.add "resourceGroupName", valid_564614
  var valid_564615 = path.getOrDefault("schemaName")
  valid_564615 = validateParameter(valid_564615, JString, required = true,
                                 default = nil)
  if valid_564615 != nil:
    section.add "schemaName", valid_564615
  var valid_564616 = path.getOrDefault("integrationAccountName")
  valid_564616 = validateParameter(valid_564616, JString, required = true,
                                 default = nil)
  if valid_564616 != nil:
    section.add "integrationAccountName", valid_564616
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564617 = query.getOrDefault("api-version")
  valid_564617 = validateParameter(valid_564617, JString, required = true,
                                 default = nil)
  if valid_564617 != nil:
    section.add "api-version", valid_564617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564618: Call_IntegrationAccountSchemasGet_564610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account schema.
  ## 
  let valid = call_564618.validator(path, query, header, formData, body)
  let scheme = call_564618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564618.url(scheme.get, call_564618.host, call_564618.base,
                         call_564618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564618, url, valid)

proc call*(call_564619: Call_IntegrationAccountSchemasGet_564610;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          schemaName: string; integrationAccountName: string): Recallable =
  ## integrationAccountSchemasGet
  ## Gets an integration account schema.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   schemaName: string (required)
  ##             : The integration account schema name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564620 = newJObject()
  var query_564621 = newJObject()
  add(query_564621, "api-version", newJString(apiVersion))
  add(path_564620, "subscriptionId", newJString(subscriptionId))
  add(path_564620, "resourceGroupName", newJString(resourceGroupName))
  add(path_564620, "schemaName", newJString(schemaName))
  add(path_564620, "integrationAccountName", newJString(integrationAccountName))
  result = call_564619.call(path_564620, query_564621, nil, nil, nil)

var integrationAccountSchemasGet* = Call_IntegrationAccountSchemasGet_564610(
    name: "integrationAccountSchemasGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_IntegrationAccountSchemasGet_564611, base: "",
    url: url_IntegrationAccountSchemasGet_564612, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasDelete_564636 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountSchemasDelete_564638(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountSchemasDelete_564637(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account schema.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   schemaName: JString (required)
  ##             : The integration account schema name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564639 = path.getOrDefault("subscriptionId")
  valid_564639 = validateParameter(valid_564639, JString, required = true,
                                 default = nil)
  if valid_564639 != nil:
    section.add "subscriptionId", valid_564639
  var valid_564640 = path.getOrDefault("resourceGroupName")
  valid_564640 = validateParameter(valid_564640, JString, required = true,
                                 default = nil)
  if valid_564640 != nil:
    section.add "resourceGroupName", valid_564640
  var valid_564641 = path.getOrDefault("schemaName")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "schemaName", valid_564641
  var valid_564642 = path.getOrDefault("integrationAccountName")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "integrationAccountName", valid_564642
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564643 = query.getOrDefault("api-version")
  valid_564643 = validateParameter(valid_564643, JString, required = true,
                                 default = nil)
  if valid_564643 != nil:
    section.add "api-version", valid_564643
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564644: Call_IntegrationAccountSchemasDelete_564636;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account schema.
  ## 
  let valid = call_564644.validator(path, query, header, formData, body)
  let scheme = call_564644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564644.url(scheme.get, call_564644.host, call_564644.base,
                         call_564644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564644, url, valid)

proc call*(call_564645: Call_IntegrationAccountSchemasDelete_564636;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          schemaName: string; integrationAccountName: string): Recallable =
  ## integrationAccountSchemasDelete
  ## Deletes an integration account schema.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   schemaName: string (required)
  ##             : The integration account schema name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564646 = newJObject()
  var query_564647 = newJObject()
  add(query_564647, "api-version", newJString(apiVersion))
  add(path_564646, "subscriptionId", newJString(subscriptionId))
  add(path_564646, "resourceGroupName", newJString(resourceGroupName))
  add(path_564646, "schemaName", newJString(schemaName))
  add(path_564646, "integrationAccountName", newJString(integrationAccountName))
  result = call_564645.call(path_564646, query_564647, nil, nil, nil)

var integrationAccountSchemasDelete* = Call_IntegrationAccountSchemasDelete_564636(
    name: "integrationAccountSchemasDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_IntegrationAccountSchemasDelete_564637, base: "",
    url: url_IntegrationAccountSchemasDelete_564638, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasListContentCallbackUrl_564648 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountSchemasListContentCallbackUrl_564650(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/listContentCallbackUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountSchemasListContentCallbackUrl_564649(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the content callback url.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   schemaName: JString (required)
  ##             : The integration account schema name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564651 = path.getOrDefault("subscriptionId")
  valid_564651 = validateParameter(valid_564651, JString, required = true,
                                 default = nil)
  if valid_564651 != nil:
    section.add "subscriptionId", valid_564651
  var valid_564652 = path.getOrDefault("resourceGroupName")
  valid_564652 = validateParameter(valid_564652, JString, required = true,
                                 default = nil)
  if valid_564652 != nil:
    section.add "resourceGroupName", valid_564652
  var valid_564653 = path.getOrDefault("schemaName")
  valid_564653 = validateParameter(valid_564653, JString, required = true,
                                 default = nil)
  if valid_564653 != nil:
    section.add "schemaName", valid_564653
  var valid_564654 = path.getOrDefault("integrationAccountName")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "integrationAccountName", valid_564654
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564655 = query.getOrDefault("api-version")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "api-version", valid_564655
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   listContentCallbackUrl: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564657: Call_IntegrationAccountSchemasListContentCallbackUrl_564648;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_564657.validator(path, query, header, formData, body)
  let scheme = call_564657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564657.url(scheme.get, call_564657.host, call_564657.base,
                         call_564657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564657, url, valid)

proc call*(call_564658: Call_IntegrationAccountSchemasListContentCallbackUrl_564648;
          apiVersion: string; subscriptionId: string;
          listContentCallbackUrl: JsonNode; resourceGroupName: string;
          schemaName: string; integrationAccountName: string): Recallable =
  ## integrationAccountSchemasListContentCallbackUrl
  ## Get the content callback url.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   listContentCallbackUrl: JObject (required)
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   schemaName: string (required)
  ##             : The integration account schema name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564659 = newJObject()
  var query_564660 = newJObject()
  var body_564661 = newJObject()
  add(query_564660, "api-version", newJString(apiVersion))
  add(path_564659, "subscriptionId", newJString(subscriptionId))
  if listContentCallbackUrl != nil:
    body_564661 = listContentCallbackUrl
  add(path_564659, "resourceGroupName", newJString(resourceGroupName))
  add(path_564659, "schemaName", newJString(schemaName))
  add(path_564659, "integrationAccountName", newJString(integrationAccountName))
  result = call_564658.call(path_564659, query_564660, nil, nil, body_564661)

var integrationAccountSchemasListContentCallbackUrl* = Call_IntegrationAccountSchemasListContentCallbackUrl_564648(
    name: "integrationAccountSchemasListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountSchemasListContentCallbackUrl_564649,
    base: "", url: url_IntegrationAccountSchemasListContentCallbackUrl_564650,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountSessionsList_564662 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountSessionsList_564664(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/sessions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountSessionsList_564663(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account sessions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564665 = path.getOrDefault("subscriptionId")
  valid_564665 = validateParameter(valid_564665, JString, required = true,
                                 default = nil)
  if valid_564665 != nil:
    section.add "subscriptionId", valid_564665
  var valid_564666 = path.getOrDefault("resourceGroupName")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "resourceGroupName", valid_564666
  var valid_564667 = path.getOrDefault("integrationAccountName")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "integrationAccountName", valid_564667
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Options for filters include: ChangedTime.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564668 = query.getOrDefault("api-version")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "api-version", valid_564668
  var valid_564669 = query.getOrDefault("$top")
  valid_564669 = validateParameter(valid_564669, JInt, required = false, default = nil)
  if valid_564669 != nil:
    section.add "$top", valid_564669
  var valid_564670 = query.getOrDefault("$filter")
  valid_564670 = validateParameter(valid_564670, JString, required = false,
                                 default = nil)
  if valid_564670 != nil:
    section.add "$filter", valid_564670
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564671: Call_IntegrationAccountSessionsList_564662; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account sessions.
  ## 
  let valid = call_564671.validator(path, query, header, formData, body)
  let scheme = call_564671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564671.url(scheme.get, call_564671.host, call_564671.base,
                         call_564671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564671, url, valid)

proc call*(call_564672: Call_IntegrationAccountSessionsList_564662;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; Top: int = 0; Filter: string = ""): Recallable =
  ## integrationAccountSessionsList
  ## Gets a list of integration account sessions.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   Filter: string
  ##         : The filter to apply on the operation. Options for filters include: ChangedTime.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564673 = newJObject()
  var query_564674 = newJObject()
  add(query_564674, "api-version", newJString(apiVersion))
  add(query_564674, "$top", newJInt(Top))
  add(path_564673, "subscriptionId", newJString(subscriptionId))
  add(path_564673, "resourceGroupName", newJString(resourceGroupName))
  add(query_564674, "$filter", newJString(Filter))
  add(path_564673, "integrationAccountName", newJString(integrationAccountName))
  result = call_564672.call(path_564673, query_564674, nil, nil, nil)

var integrationAccountSessionsList* = Call_IntegrationAccountSessionsList_564662(
    name: "integrationAccountSessionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions",
    validator: validate_IntegrationAccountSessionsList_564663, base: "",
    url: url_IntegrationAccountSessionsList_564664, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSessionsCreateOrUpdate_564687 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountSessionsCreateOrUpdate_564689(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "sessionName" in path, "`sessionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/sessions/"),
               (kind: VariableSegment, value: "sessionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountSessionsCreateOrUpdate_564688(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   sessionName: JString (required)
  ##              : The integration account session name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564690 = path.getOrDefault("subscriptionId")
  valid_564690 = validateParameter(valid_564690, JString, required = true,
                                 default = nil)
  if valid_564690 != nil:
    section.add "subscriptionId", valid_564690
  var valid_564691 = path.getOrDefault("sessionName")
  valid_564691 = validateParameter(valid_564691, JString, required = true,
                                 default = nil)
  if valid_564691 != nil:
    section.add "sessionName", valid_564691
  var valid_564692 = path.getOrDefault("resourceGroupName")
  valid_564692 = validateParameter(valid_564692, JString, required = true,
                                 default = nil)
  if valid_564692 != nil:
    section.add "resourceGroupName", valid_564692
  var valid_564693 = path.getOrDefault("integrationAccountName")
  valid_564693 = validateParameter(valid_564693, JString, required = true,
                                 default = nil)
  if valid_564693 != nil:
    section.add "integrationAccountName", valid_564693
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564694 = query.getOrDefault("api-version")
  valid_564694 = validateParameter(valid_564694, JString, required = true,
                                 default = nil)
  if valid_564694 != nil:
    section.add "api-version", valid_564694
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   session: JObject (required)
  ##          : The integration account session.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564696: Call_IntegrationAccountSessionsCreateOrUpdate_564687;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account session.
  ## 
  let valid = call_564696.validator(path, query, header, formData, body)
  let scheme = call_564696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564696.url(scheme.get, call_564696.host, call_564696.base,
                         call_564696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564696, url, valid)

proc call*(call_564697: Call_IntegrationAccountSessionsCreateOrUpdate_564687;
          apiVersion: string; subscriptionId: string; sessionName: string;
          resourceGroupName: string; session: JsonNode;
          integrationAccountName: string): Recallable =
  ## integrationAccountSessionsCreateOrUpdate
  ## Creates or updates an integration account session.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   sessionName: string (required)
  ##              : The integration account session name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   session: JObject (required)
  ##          : The integration account session.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564698 = newJObject()
  var query_564699 = newJObject()
  var body_564700 = newJObject()
  add(query_564699, "api-version", newJString(apiVersion))
  add(path_564698, "subscriptionId", newJString(subscriptionId))
  add(path_564698, "sessionName", newJString(sessionName))
  add(path_564698, "resourceGroupName", newJString(resourceGroupName))
  if session != nil:
    body_564700 = session
  add(path_564698, "integrationAccountName", newJString(integrationAccountName))
  result = call_564697.call(path_564698, query_564699, nil, nil, body_564700)

var integrationAccountSessionsCreateOrUpdate* = Call_IntegrationAccountSessionsCreateOrUpdate_564687(
    name: "integrationAccountSessionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
    validator: validate_IntegrationAccountSessionsCreateOrUpdate_564688, base: "",
    url: url_IntegrationAccountSessionsCreateOrUpdate_564689,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountSessionsGet_564675 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountSessionsGet_564677(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "sessionName" in path, "`sessionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/sessions/"),
               (kind: VariableSegment, value: "sessionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountSessionsGet_564676(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   sessionName: JString (required)
  ##              : The integration account session name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564678 = path.getOrDefault("subscriptionId")
  valid_564678 = validateParameter(valid_564678, JString, required = true,
                                 default = nil)
  if valid_564678 != nil:
    section.add "subscriptionId", valid_564678
  var valid_564679 = path.getOrDefault("sessionName")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "sessionName", valid_564679
  var valid_564680 = path.getOrDefault("resourceGroupName")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "resourceGroupName", valid_564680
  var valid_564681 = path.getOrDefault("integrationAccountName")
  valid_564681 = validateParameter(valid_564681, JString, required = true,
                                 default = nil)
  if valid_564681 != nil:
    section.add "integrationAccountName", valid_564681
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564682 = query.getOrDefault("api-version")
  valid_564682 = validateParameter(valid_564682, JString, required = true,
                                 default = nil)
  if valid_564682 != nil:
    section.add "api-version", valid_564682
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564683: Call_IntegrationAccountSessionsGet_564675; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account session.
  ## 
  let valid = call_564683.validator(path, query, header, formData, body)
  let scheme = call_564683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564683.url(scheme.get, call_564683.host, call_564683.base,
                         call_564683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564683, url, valid)

proc call*(call_564684: Call_IntegrationAccountSessionsGet_564675;
          apiVersion: string; subscriptionId: string; sessionName: string;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## integrationAccountSessionsGet
  ## Gets an integration account session.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   sessionName: string (required)
  ##              : The integration account session name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564685 = newJObject()
  var query_564686 = newJObject()
  add(query_564686, "api-version", newJString(apiVersion))
  add(path_564685, "subscriptionId", newJString(subscriptionId))
  add(path_564685, "sessionName", newJString(sessionName))
  add(path_564685, "resourceGroupName", newJString(resourceGroupName))
  add(path_564685, "integrationAccountName", newJString(integrationAccountName))
  result = call_564684.call(path_564685, query_564686, nil, nil, nil)

var integrationAccountSessionsGet* = Call_IntegrationAccountSessionsGet_564675(
    name: "integrationAccountSessionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
    validator: validate_IntegrationAccountSessionsGet_564676, base: "",
    url: url_IntegrationAccountSessionsGet_564677, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSessionsDelete_564701 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountSessionsDelete_564703(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "sessionName" in path, "`sessionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/sessions/"),
               (kind: VariableSegment, value: "sessionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountSessionsDelete_564702(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   sessionName: JString (required)
  ##              : The integration account session name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564704 = path.getOrDefault("subscriptionId")
  valid_564704 = validateParameter(valid_564704, JString, required = true,
                                 default = nil)
  if valid_564704 != nil:
    section.add "subscriptionId", valid_564704
  var valid_564705 = path.getOrDefault("sessionName")
  valid_564705 = validateParameter(valid_564705, JString, required = true,
                                 default = nil)
  if valid_564705 != nil:
    section.add "sessionName", valid_564705
  var valid_564706 = path.getOrDefault("resourceGroupName")
  valid_564706 = validateParameter(valid_564706, JString, required = true,
                                 default = nil)
  if valid_564706 != nil:
    section.add "resourceGroupName", valid_564706
  var valid_564707 = path.getOrDefault("integrationAccountName")
  valid_564707 = validateParameter(valid_564707, JString, required = true,
                                 default = nil)
  if valid_564707 != nil:
    section.add "integrationAccountName", valid_564707
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564708 = query.getOrDefault("api-version")
  valid_564708 = validateParameter(valid_564708, JString, required = true,
                                 default = nil)
  if valid_564708 != nil:
    section.add "api-version", valid_564708
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564709: Call_IntegrationAccountSessionsDelete_564701;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account session.
  ## 
  let valid = call_564709.validator(path, query, header, formData, body)
  let scheme = call_564709.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564709.url(scheme.get, call_564709.host, call_564709.base,
                         call_564709.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564709, url, valid)

proc call*(call_564710: Call_IntegrationAccountSessionsDelete_564701;
          apiVersion: string; subscriptionId: string; sessionName: string;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## integrationAccountSessionsDelete
  ## Deletes an integration account session.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   sessionName: string (required)
  ##              : The integration account session name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564711 = newJObject()
  var query_564712 = newJObject()
  add(query_564712, "api-version", newJString(apiVersion))
  add(path_564711, "subscriptionId", newJString(subscriptionId))
  add(path_564711, "sessionName", newJString(sessionName))
  add(path_564711, "resourceGroupName", newJString(resourceGroupName))
  add(path_564711, "integrationAccountName", newJString(integrationAccountName))
  result = call_564710.call(path_564711, query_564712, nil, nil, nil)

var integrationAccountSessionsDelete* = Call_IntegrationAccountSessionsDelete_564701(
    name: "integrationAccountSessionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
    validator: validate_IntegrationAccountSessionsDelete_564702, base: "",
    url: url_IntegrationAccountSessionsDelete_564703, schemes: {Scheme.Https})
type
  Call_WorkflowsValidateByLocation_564713 = ref object of OpenApiRestCall_563565
proc url_WorkflowsValidateByLocation_564715(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsValidateByLocation_564714(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the workflow definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   location: JString (required)
  ##           : The workflow location.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_564716 = path.getOrDefault("workflowName")
  valid_564716 = validateParameter(valid_564716, JString, required = true,
                                 default = nil)
  if valid_564716 != nil:
    section.add "workflowName", valid_564716
  var valid_564717 = path.getOrDefault("subscriptionId")
  valid_564717 = validateParameter(valid_564717, JString, required = true,
                                 default = nil)
  if valid_564717 != nil:
    section.add "subscriptionId", valid_564717
  var valid_564718 = path.getOrDefault("location")
  valid_564718 = validateParameter(valid_564718, JString, required = true,
                                 default = nil)
  if valid_564718 != nil:
    section.add "location", valid_564718
  var valid_564719 = path.getOrDefault("resourceGroupName")
  valid_564719 = validateParameter(valid_564719, JString, required = true,
                                 default = nil)
  if valid_564719 != nil:
    section.add "resourceGroupName", valid_564719
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564720 = query.getOrDefault("api-version")
  valid_564720 = validateParameter(valid_564720, JString, required = true,
                                 default = nil)
  if valid_564720 != nil:
    section.add "api-version", valid_564720
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564721: Call_WorkflowsValidateByLocation_564713; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the workflow definition.
  ## 
  let valid = call_564721.validator(path, query, header, formData, body)
  let scheme = call_564721.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564721.url(scheme.get, call_564721.host, call_564721.base,
                         call_564721.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564721, url, valid)

proc call*(call_564722: Call_WorkflowsValidateByLocation_564713;
          apiVersion: string; workflowName: string; subscriptionId: string;
          location: string; resourceGroupName: string): Recallable =
  ## workflowsValidateByLocation
  ## Validates the workflow definition.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   location: string (required)
  ##           : The workflow location.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564723 = newJObject()
  var query_564724 = newJObject()
  add(query_564724, "api-version", newJString(apiVersion))
  add(path_564723, "workflowName", newJString(workflowName))
  add(path_564723, "subscriptionId", newJString(subscriptionId))
  add(path_564723, "location", newJString(location))
  add(path_564723, "resourceGroupName", newJString(resourceGroupName))
  result = call_564722.call(path_564723, query_564724, nil, nil, nil)

var workflowsValidateByLocation* = Call_WorkflowsValidateByLocation_564713(
    name: "workflowsValidateByLocation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/locations/{location}/workflows/{workflowName}/validate",
    validator: validate_WorkflowsValidateByLocation_564714, base: "",
    url: url_WorkflowsValidateByLocation_564715, schemes: {Scheme.Https})
type
  Call_WorkflowsListByResourceGroup_564725 = ref object of OpenApiRestCall_563565
proc url_WorkflowsListByResourceGroup_564727(protocol: Scheme; host: string;
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

proc validate_WorkflowsListByResourceGroup_564726(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of workflows by resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564728 = path.getOrDefault("subscriptionId")
  valid_564728 = validateParameter(valid_564728, JString, required = true,
                                 default = nil)
  if valid_564728 != nil:
    section.add "subscriptionId", valid_564728
  var valid_564729 = path.getOrDefault("resourceGroupName")
  valid_564729 = validateParameter(valid_564729, JString, required = true,
                                 default = nil)
  if valid_564729 != nil:
    section.add "resourceGroupName", valid_564729
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Options for filters include: State, Trigger, and ReferencedResourceId.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564730 = query.getOrDefault("api-version")
  valid_564730 = validateParameter(valid_564730, JString, required = true,
                                 default = nil)
  if valid_564730 != nil:
    section.add "api-version", valid_564730
  var valid_564731 = query.getOrDefault("$top")
  valid_564731 = validateParameter(valid_564731, JInt, required = false, default = nil)
  if valid_564731 != nil:
    section.add "$top", valid_564731
  var valid_564732 = query.getOrDefault("$filter")
  valid_564732 = validateParameter(valid_564732, JString, required = false,
                                 default = nil)
  if valid_564732 != nil:
    section.add "$filter", valid_564732
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564733: Call_WorkflowsListByResourceGroup_564725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflows by resource group.
  ## 
  let valid = call_564733.validator(path, query, header, formData, body)
  let scheme = call_564733.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564733.url(scheme.get, call_564733.host, call_564733.base,
                         call_564733.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564733, url, valid)

proc call*(call_564734: Call_WorkflowsListByResourceGroup_564725;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## workflowsListByResourceGroup
  ## Gets a list of workflows by resource group.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   Filter: string
  ##         : The filter to apply on the operation. Options for filters include: State, Trigger, and ReferencedResourceId.
  var path_564735 = newJObject()
  var query_564736 = newJObject()
  add(query_564736, "api-version", newJString(apiVersion))
  add(query_564736, "$top", newJInt(Top))
  add(path_564735, "subscriptionId", newJString(subscriptionId))
  add(path_564735, "resourceGroupName", newJString(resourceGroupName))
  add(query_564736, "$filter", newJString(Filter))
  result = call_564734.call(path_564735, query_564736, nil, nil, nil)

var workflowsListByResourceGroup* = Call_WorkflowsListByResourceGroup_564725(
    name: "workflowsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows",
    validator: validate_WorkflowsListByResourceGroup_564726, base: "",
    url: url_WorkflowsListByResourceGroup_564727, schemes: {Scheme.Https})
type
  Call_WorkflowsCreateOrUpdate_564748 = ref object of OpenApiRestCall_563565
proc url_WorkflowsCreateOrUpdate_564750(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsCreateOrUpdate_564749(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_564751 = path.getOrDefault("workflowName")
  valid_564751 = validateParameter(valid_564751, JString, required = true,
                                 default = nil)
  if valid_564751 != nil:
    section.add "workflowName", valid_564751
  var valid_564752 = path.getOrDefault("subscriptionId")
  valid_564752 = validateParameter(valid_564752, JString, required = true,
                                 default = nil)
  if valid_564752 != nil:
    section.add "subscriptionId", valid_564752
  var valid_564753 = path.getOrDefault("resourceGroupName")
  valid_564753 = validateParameter(valid_564753, JString, required = true,
                                 default = nil)
  if valid_564753 != nil:
    section.add "resourceGroupName", valid_564753
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564754 = query.getOrDefault("api-version")
  valid_564754 = validateParameter(valid_564754, JString, required = true,
                                 default = nil)
  if valid_564754 != nil:
    section.add "api-version", valid_564754
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

proc call*(call_564756: Call_WorkflowsCreateOrUpdate_564748; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a workflow.
  ## 
  let valid = call_564756.validator(path, query, header, formData, body)
  let scheme = call_564756.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564756.url(scheme.get, call_564756.host, call_564756.base,
                         call_564756.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564756, url, valid)

proc call*(call_564757: Call_WorkflowsCreateOrUpdate_564748; apiVersion: string;
          workflowName: string; subscriptionId: string; resourceGroupName: string;
          workflow: JsonNode): Recallable =
  ## workflowsCreateOrUpdate
  ## Creates or updates a workflow.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   workflow: JObject (required)
  ##           : The workflow.
  var path_564758 = newJObject()
  var query_564759 = newJObject()
  var body_564760 = newJObject()
  add(query_564759, "api-version", newJString(apiVersion))
  add(path_564758, "workflowName", newJString(workflowName))
  add(path_564758, "subscriptionId", newJString(subscriptionId))
  add(path_564758, "resourceGroupName", newJString(resourceGroupName))
  if workflow != nil:
    body_564760 = workflow
  result = call_564757.call(path_564758, query_564759, nil, nil, body_564760)

var workflowsCreateOrUpdate* = Call_WorkflowsCreateOrUpdate_564748(
    name: "workflowsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsCreateOrUpdate_564749, base: "",
    url: url_WorkflowsCreateOrUpdate_564750, schemes: {Scheme.Https})
type
  Call_WorkflowsGet_564737 = ref object of OpenApiRestCall_563565
proc url_WorkflowsGet_564739(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsGet_564738(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_564740 = path.getOrDefault("workflowName")
  valid_564740 = validateParameter(valid_564740, JString, required = true,
                                 default = nil)
  if valid_564740 != nil:
    section.add "workflowName", valid_564740
  var valid_564741 = path.getOrDefault("subscriptionId")
  valid_564741 = validateParameter(valid_564741, JString, required = true,
                                 default = nil)
  if valid_564741 != nil:
    section.add "subscriptionId", valid_564741
  var valid_564742 = path.getOrDefault("resourceGroupName")
  valid_564742 = validateParameter(valid_564742, JString, required = true,
                                 default = nil)
  if valid_564742 != nil:
    section.add "resourceGroupName", valid_564742
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564743 = query.getOrDefault("api-version")
  valid_564743 = validateParameter(valid_564743, JString, required = true,
                                 default = nil)
  if valid_564743 != nil:
    section.add "api-version", valid_564743
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564744: Call_WorkflowsGet_564737; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow.
  ## 
  let valid = call_564744.validator(path, query, header, formData, body)
  let scheme = call_564744.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564744.url(scheme.get, call_564744.host, call_564744.base,
                         call_564744.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564744, url, valid)

proc call*(call_564745: Call_WorkflowsGet_564737; apiVersion: string;
          workflowName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## workflowsGet
  ## Gets a workflow.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564746 = newJObject()
  var query_564747 = newJObject()
  add(query_564747, "api-version", newJString(apiVersion))
  add(path_564746, "workflowName", newJString(workflowName))
  add(path_564746, "subscriptionId", newJString(subscriptionId))
  add(path_564746, "resourceGroupName", newJString(resourceGroupName))
  result = call_564745.call(path_564746, query_564747, nil, nil, nil)

var workflowsGet* = Call_WorkflowsGet_564737(name: "workflowsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsGet_564738, base: "", url: url_WorkflowsGet_564739,
    schemes: {Scheme.Https})
type
  Call_WorkflowsUpdate_564772 = ref object of OpenApiRestCall_563565
proc url_WorkflowsUpdate_564774(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsUpdate_564773(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_564775 = path.getOrDefault("workflowName")
  valid_564775 = validateParameter(valid_564775, JString, required = true,
                                 default = nil)
  if valid_564775 != nil:
    section.add "workflowName", valid_564775
  var valid_564776 = path.getOrDefault("subscriptionId")
  valid_564776 = validateParameter(valid_564776, JString, required = true,
                                 default = nil)
  if valid_564776 != nil:
    section.add "subscriptionId", valid_564776
  var valid_564777 = path.getOrDefault("resourceGroupName")
  valid_564777 = validateParameter(valid_564777, JString, required = true,
                                 default = nil)
  if valid_564777 != nil:
    section.add "resourceGroupName", valid_564777
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564778 = query.getOrDefault("api-version")
  valid_564778 = validateParameter(valid_564778, JString, required = true,
                                 default = nil)
  if valid_564778 != nil:
    section.add "api-version", valid_564778
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

proc call*(call_564780: Call_WorkflowsUpdate_564772; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a workflow.
  ## 
  let valid = call_564780.validator(path, query, header, formData, body)
  let scheme = call_564780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564780.url(scheme.get, call_564780.host, call_564780.base,
                         call_564780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564780, url, valid)

proc call*(call_564781: Call_WorkflowsUpdate_564772; apiVersion: string;
          workflowName: string; subscriptionId: string; resourceGroupName: string;
          workflow: JsonNode): Recallable =
  ## workflowsUpdate
  ## Updates a workflow.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   workflow: JObject (required)
  ##           : The workflow.
  var path_564782 = newJObject()
  var query_564783 = newJObject()
  var body_564784 = newJObject()
  add(query_564783, "api-version", newJString(apiVersion))
  add(path_564782, "workflowName", newJString(workflowName))
  add(path_564782, "subscriptionId", newJString(subscriptionId))
  add(path_564782, "resourceGroupName", newJString(resourceGroupName))
  if workflow != nil:
    body_564784 = workflow
  result = call_564781.call(path_564782, query_564783, nil, nil, body_564784)

var workflowsUpdate* = Call_WorkflowsUpdate_564772(name: "workflowsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsUpdate_564773, base: "", url: url_WorkflowsUpdate_564774,
    schemes: {Scheme.Https})
type
  Call_WorkflowsDelete_564761 = ref object of OpenApiRestCall_563565
proc url_WorkflowsDelete_564763(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsDelete_564762(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_564764 = path.getOrDefault("workflowName")
  valid_564764 = validateParameter(valid_564764, JString, required = true,
                                 default = nil)
  if valid_564764 != nil:
    section.add "workflowName", valid_564764
  var valid_564765 = path.getOrDefault("subscriptionId")
  valid_564765 = validateParameter(valid_564765, JString, required = true,
                                 default = nil)
  if valid_564765 != nil:
    section.add "subscriptionId", valid_564765
  var valid_564766 = path.getOrDefault("resourceGroupName")
  valid_564766 = validateParameter(valid_564766, JString, required = true,
                                 default = nil)
  if valid_564766 != nil:
    section.add "resourceGroupName", valid_564766
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564767 = query.getOrDefault("api-version")
  valid_564767 = validateParameter(valid_564767, JString, required = true,
                                 default = nil)
  if valid_564767 != nil:
    section.add "api-version", valid_564767
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564768: Call_WorkflowsDelete_564761; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a workflow.
  ## 
  let valid = call_564768.validator(path, query, header, formData, body)
  let scheme = call_564768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564768.url(scheme.get, call_564768.host, call_564768.base,
                         call_564768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564768, url, valid)

proc call*(call_564769: Call_WorkflowsDelete_564761; apiVersion: string;
          workflowName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## workflowsDelete
  ## Deletes a workflow.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564770 = newJObject()
  var query_564771 = newJObject()
  add(query_564771, "api-version", newJString(apiVersion))
  add(path_564770, "workflowName", newJString(workflowName))
  add(path_564770, "subscriptionId", newJString(subscriptionId))
  add(path_564770, "resourceGroupName", newJString(resourceGroupName))
  result = call_564769.call(path_564770, query_564771, nil, nil, nil)

var workflowsDelete* = Call_WorkflowsDelete_564761(name: "workflowsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsDelete_564762, base: "", url: url_WorkflowsDelete_564763,
    schemes: {Scheme.Https})
type
  Call_WorkflowsDisable_564785 = ref object of OpenApiRestCall_563565
proc url_WorkflowsDisable_564787(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsDisable_564786(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Disables a workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_564788 = path.getOrDefault("workflowName")
  valid_564788 = validateParameter(valid_564788, JString, required = true,
                                 default = nil)
  if valid_564788 != nil:
    section.add "workflowName", valid_564788
  var valid_564789 = path.getOrDefault("subscriptionId")
  valid_564789 = validateParameter(valid_564789, JString, required = true,
                                 default = nil)
  if valid_564789 != nil:
    section.add "subscriptionId", valid_564789
  var valid_564790 = path.getOrDefault("resourceGroupName")
  valid_564790 = validateParameter(valid_564790, JString, required = true,
                                 default = nil)
  if valid_564790 != nil:
    section.add "resourceGroupName", valid_564790
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564791 = query.getOrDefault("api-version")
  valid_564791 = validateParameter(valid_564791, JString, required = true,
                                 default = nil)
  if valid_564791 != nil:
    section.add "api-version", valid_564791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564792: Call_WorkflowsDisable_564785; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disables a workflow.
  ## 
  let valid = call_564792.validator(path, query, header, formData, body)
  let scheme = call_564792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564792.url(scheme.get, call_564792.host, call_564792.base,
                         call_564792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564792, url, valid)

proc call*(call_564793: Call_WorkflowsDisable_564785; apiVersion: string;
          workflowName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## workflowsDisable
  ## Disables a workflow.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564794 = newJObject()
  var query_564795 = newJObject()
  add(query_564795, "api-version", newJString(apiVersion))
  add(path_564794, "workflowName", newJString(workflowName))
  add(path_564794, "subscriptionId", newJString(subscriptionId))
  add(path_564794, "resourceGroupName", newJString(resourceGroupName))
  result = call_564793.call(path_564794, query_564795, nil, nil, nil)

var workflowsDisable* = Call_WorkflowsDisable_564785(name: "workflowsDisable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/disable",
    validator: validate_WorkflowsDisable_564786, base: "",
    url: url_WorkflowsDisable_564787, schemes: {Scheme.Https})
type
  Call_WorkflowsEnable_564796 = ref object of OpenApiRestCall_563565
proc url_WorkflowsEnable_564798(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsEnable_564797(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Enables a workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_564799 = path.getOrDefault("workflowName")
  valid_564799 = validateParameter(valid_564799, JString, required = true,
                                 default = nil)
  if valid_564799 != nil:
    section.add "workflowName", valid_564799
  var valid_564800 = path.getOrDefault("subscriptionId")
  valid_564800 = validateParameter(valid_564800, JString, required = true,
                                 default = nil)
  if valid_564800 != nil:
    section.add "subscriptionId", valid_564800
  var valid_564801 = path.getOrDefault("resourceGroupName")
  valid_564801 = validateParameter(valid_564801, JString, required = true,
                                 default = nil)
  if valid_564801 != nil:
    section.add "resourceGroupName", valid_564801
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564802 = query.getOrDefault("api-version")
  valid_564802 = validateParameter(valid_564802, JString, required = true,
                                 default = nil)
  if valid_564802 != nil:
    section.add "api-version", valid_564802
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564803: Call_WorkflowsEnable_564796; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables a workflow.
  ## 
  let valid = call_564803.validator(path, query, header, formData, body)
  let scheme = call_564803.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564803.url(scheme.get, call_564803.host, call_564803.base,
                         call_564803.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564803, url, valid)

proc call*(call_564804: Call_WorkflowsEnable_564796; apiVersion: string;
          workflowName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## workflowsEnable
  ## Enables a workflow.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564805 = newJObject()
  var query_564806 = newJObject()
  add(query_564806, "api-version", newJString(apiVersion))
  add(path_564805, "workflowName", newJString(workflowName))
  add(path_564805, "subscriptionId", newJString(subscriptionId))
  add(path_564805, "resourceGroupName", newJString(resourceGroupName))
  result = call_564804.call(path_564805, query_564806, nil, nil, nil)

var workflowsEnable* = Call_WorkflowsEnable_564796(name: "workflowsEnable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/enable",
    validator: validate_WorkflowsEnable_564797, base: "", url: url_WorkflowsEnable_564798,
    schemes: {Scheme.Https})
type
  Call_WorkflowsGenerateUpgradedDefinition_564807 = ref object of OpenApiRestCall_563565
proc url_WorkflowsGenerateUpgradedDefinition_564809(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/generateUpgradedDefinition")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsGenerateUpgradedDefinition_564808(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates the upgraded definition for a workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_564810 = path.getOrDefault("workflowName")
  valid_564810 = validateParameter(valid_564810, JString, required = true,
                                 default = nil)
  if valid_564810 != nil:
    section.add "workflowName", valid_564810
  var valid_564811 = path.getOrDefault("subscriptionId")
  valid_564811 = validateParameter(valid_564811, JString, required = true,
                                 default = nil)
  if valid_564811 != nil:
    section.add "subscriptionId", valid_564811
  var valid_564812 = path.getOrDefault("resourceGroupName")
  valid_564812 = validateParameter(valid_564812, JString, required = true,
                                 default = nil)
  if valid_564812 != nil:
    section.add "resourceGroupName", valid_564812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564813 = query.getOrDefault("api-version")
  valid_564813 = validateParameter(valid_564813, JString, required = true,
                                 default = nil)
  if valid_564813 != nil:
    section.add "api-version", valid_564813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for generating an upgraded definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564815: Call_WorkflowsGenerateUpgradedDefinition_564807;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates the upgraded definition for a workflow.
  ## 
  let valid = call_564815.validator(path, query, header, formData, body)
  let scheme = call_564815.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564815.url(scheme.get, call_564815.host, call_564815.base,
                         call_564815.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564815, url, valid)

proc call*(call_564816: Call_WorkflowsGenerateUpgradedDefinition_564807;
          apiVersion: string; workflowName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## workflowsGenerateUpgradedDefinition
  ## Generates the upgraded definition for a workflow.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   parameters: JObject (required)
  ##             : Parameters for generating an upgraded definition.
  var path_564817 = newJObject()
  var query_564818 = newJObject()
  var body_564819 = newJObject()
  add(query_564818, "api-version", newJString(apiVersion))
  add(path_564817, "workflowName", newJString(workflowName))
  add(path_564817, "subscriptionId", newJString(subscriptionId))
  add(path_564817, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564819 = parameters
  result = call_564816.call(path_564817, query_564818, nil, nil, body_564819)

var workflowsGenerateUpgradedDefinition* = Call_WorkflowsGenerateUpgradedDefinition_564807(
    name: "workflowsGenerateUpgradedDefinition", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/generateUpgradedDefinition",
    validator: validate_WorkflowsGenerateUpgradedDefinition_564808, base: "",
    url: url_WorkflowsGenerateUpgradedDefinition_564809, schemes: {Scheme.Https})
type
  Call_WorkflowsListCallbackUrl_564820 = ref object of OpenApiRestCall_563565
proc url_WorkflowsListCallbackUrl_564822(protocol: Scheme; host: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/listCallbackUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsListCallbackUrl_564821(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the workflow callback Url.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_564823 = path.getOrDefault("workflowName")
  valid_564823 = validateParameter(valid_564823, JString, required = true,
                                 default = nil)
  if valid_564823 != nil:
    section.add "workflowName", valid_564823
  var valid_564824 = path.getOrDefault("subscriptionId")
  valid_564824 = validateParameter(valid_564824, JString, required = true,
                                 default = nil)
  if valid_564824 != nil:
    section.add "subscriptionId", valid_564824
  var valid_564825 = path.getOrDefault("resourceGroupName")
  valid_564825 = validateParameter(valid_564825, JString, required = true,
                                 default = nil)
  if valid_564825 != nil:
    section.add "resourceGroupName", valid_564825
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564826 = query.getOrDefault("api-version")
  valid_564826 = validateParameter(valid_564826, JString, required = true,
                                 default = nil)
  if valid_564826 != nil:
    section.add "api-version", valid_564826
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   listCallbackUrl: JObject (required)
  ##                  : Which callback url to list.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564828: Call_WorkflowsListCallbackUrl_564820; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the workflow callback Url.
  ## 
  let valid = call_564828.validator(path, query, header, formData, body)
  let scheme = call_564828.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564828.url(scheme.get, call_564828.host, call_564828.base,
                         call_564828.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564828, url, valid)

proc call*(call_564829: Call_WorkflowsListCallbackUrl_564820; apiVersion: string;
          workflowName: string; subscriptionId: string; resourceGroupName: string;
          listCallbackUrl: JsonNode): Recallable =
  ## workflowsListCallbackUrl
  ## Get the workflow callback Url.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   listCallbackUrl: JObject (required)
  ##                  : Which callback url to list.
  var path_564830 = newJObject()
  var query_564831 = newJObject()
  var body_564832 = newJObject()
  add(query_564831, "api-version", newJString(apiVersion))
  add(path_564830, "workflowName", newJString(workflowName))
  add(path_564830, "subscriptionId", newJString(subscriptionId))
  add(path_564830, "resourceGroupName", newJString(resourceGroupName))
  if listCallbackUrl != nil:
    body_564832 = listCallbackUrl
  result = call_564829.call(path_564830, query_564831, nil, nil, body_564832)

var workflowsListCallbackUrl* = Call_WorkflowsListCallbackUrl_564820(
    name: "workflowsListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/listCallbackUrl",
    validator: validate_WorkflowsListCallbackUrl_564821, base: "",
    url: url_WorkflowsListCallbackUrl_564822, schemes: {Scheme.Https})
type
  Call_WorkflowsListSwagger_564833 = ref object of OpenApiRestCall_563565
proc url_WorkflowsListSwagger_564835(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/listSwagger")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsListSwagger_564834(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an OpenAPI definition for the workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_564836 = path.getOrDefault("workflowName")
  valid_564836 = validateParameter(valid_564836, JString, required = true,
                                 default = nil)
  if valid_564836 != nil:
    section.add "workflowName", valid_564836
  var valid_564837 = path.getOrDefault("subscriptionId")
  valid_564837 = validateParameter(valid_564837, JString, required = true,
                                 default = nil)
  if valid_564837 != nil:
    section.add "subscriptionId", valid_564837
  var valid_564838 = path.getOrDefault("resourceGroupName")
  valid_564838 = validateParameter(valid_564838, JString, required = true,
                                 default = nil)
  if valid_564838 != nil:
    section.add "resourceGroupName", valid_564838
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564839 = query.getOrDefault("api-version")
  valid_564839 = validateParameter(valid_564839, JString, required = true,
                                 default = nil)
  if valid_564839 != nil:
    section.add "api-version", valid_564839
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564840: Call_WorkflowsListSwagger_564833; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an OpenAPI definition for the workflow.
  ## 
  let valid = call_564840.validator(path, query, header, formData, body)
  let scheme = call_564840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564840.url(scheme.get, call_564840.host, call_564840.base,
                         call_564840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564840, url, valid)

proc call*(call_564841: Call_WorkflowsListSwagger_564833; apiVersion: string;
          workflowName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## workflowsListSwagger
  ## Gets an OpenAPI definition for the workflow.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564842 = newJObject()
  var query_564843 = newJObject()
  add(query_564843, "api-version", newJString(apiVersion))
  add(path_564842, "workflowName", newJString(workflowName))
  add(path_564842, "subscriptionId", newJString(subscriptionId))
  add(path_564842, "resourceGroupName", newJString(resourceGroupName))
  result = call_564841.call(path_564842, query_564843, nil, nil, nil)

var workflowsListSwagger* = Call_WorkflowsListSwagger_564833(
    name: "workflowsListSwagger", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/listSwagger",
    validator: validate_WorkflowsListSwagger_564834, base: "",
    url: url_WorkflowsListSwagger_564835, schemes: {Scheme.Https})
type
  Call_WorkflowsMove_564844 = ref object of OpenApiRestCall_563565
proc url_WorkflowsMove_564846(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/move")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsMove_564845(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Moves an existing workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_564847 = path.getOrDefault("workflowName")
  valid_564847 = validateParameter(valid_564847, JString, required = true,
                                 default = nil)
  if valid_564847 != nil:
    section.add "workflowName", valid_564847
  var valid_564848 = path.getOrDefault("subscriptionId")
  valid_564848 = validateParameter(valid_564848, JString, required = true,
                                 default = nil)
  if valid_564848 != nil:
    section.add "subscriptionId", valid_564848
  var valid_564849 = path.getOrDefault("resourceGroupName")
  valid_564849 = validateParameter(valid_564849, JString, required = true,
                                 default = nil)
  if valid_564849 != nil:
    section.add "resourceGroupName", valid_564849
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564850 = query.getOrDefault("api-version")
  valid_564850 = validateParameter(valid_564850, JString, required = true,
                                 default = nil)
  if valid_564850 != nil:
    section.add "api-version", valid_564850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   move: JObject (required)
  ##       : The workflow to move.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564852: Call_WorkflowsMove_564844; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves an existing workflow.
  ## 
  let valid = call_564852.validator(path, query, header, formData, body)
  let scheme = call_564852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564852.url(scheme.get, call_564852.host, call_564852.base,
                         call_564852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564852, url, valid)

proc call*(call_564853: Call_WorkflowsMove_564844; apiVersion: string;
          workflowName: string; subscriptionId: string; move: JsonNode;
          resourceGroupName: string): Recallable =
  ## workflowsMove
  ## Moves an existing workflow.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   move: JObject (required)
  ##       : The workflow to move.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564854 = newJObject()
  var query_564855 = newJObject()
  var body_564856 = newJObject()
  add(query_564855, "api-version", newJString(apiVersion))
  add(path_564854, "workflowName", newJString(workflowName))
  add(path_564854, "subscriptionId", newJString(subscriptionId))
  if move != nil:
    body_564856 = move
  add(path_564854, "resourceGroupName", newJString(resourceGroupName))
  result = call_564853.call(path_564854, query_564855, nil, nil, body_564856)

var workflowsMove* = Call_WorkflowsMove_564844(name: "workflowsMove",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/move",
    validator: validate_WorkflowsMove_564845, base: "", url: url_WorkflowsMove_564846,
    schemes: {Scheme.Https})
type
  Call_WorkflowsRegenerateAccessKey_564857 = ref object of OpenApiRestCall_563565
proc url_WorkflowsRegenerateAccessKey_564859(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/regenerateAccessKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsRegenerateAccessKey_564858(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the callback URL access key for request triggers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_564860 = path.getOrDefault("workflowName")
  valid_564860 = validateParameter(valid_564860, JString, required = true,
                                 default = nil)
  if valid_564860 != nil:
    section.add "workflowName", valid_564860
  var valid_564861 = path.getOrDefault("subscriptionId")
  valid_564861 = validateParameter(valid_564861, JString, required = true,
                                 default = nil)
  if valid_564861 != nil:
    section.add "subscriptionId", valid_564861
  var valid_564862 = path.getOrDefault("resourceGroupName")
  valid_564862 = validateParameter(valid_564862, JString, required = true,
                                 default = nil)
  if valid_564862 != nil:
    section.add "resourceGroupName", valid_564862
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564863 = query.getOrDefault("api-version")
  valid_564863 = validateParameter(valid_564863, JString, required = true,
                                 default = nil)
  if valid_564863 != nil:
    section.add "api-version", valid_564863
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   keyType: JObject (required)
  ##          : The access key type.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564865: Call_WorkflowsRegenerateAccessKey_564857; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the callback URL access key for request triggers.
  ## 
  let valid = call_564865.validator(path, query, header, formData, body)
  let scheme = call_564865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564865.url(scheme.get, call_564865.host, call_564865.base,
                         call_564865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564865, url, valid)

proc call*(call_564866: Call_WorkflowsRegenerateAccessKey_564857;
          apiVersion: string; keyType: JsonNode; workflowName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## workflowsRegenerateAccessKey
  ## Regenerates the callback URL access key for request triggers.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   keyType: JObject (required)
  ##          : The access key type.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564867 = newJObject()
  var query_564868 = newJObject()
  var body_564869 = newJObject()
  add(query_564868, "api-version", newJString(apiVersion))
  if keyType != nil:
    body_564869 = keyType
  add(path_564867, "workflowName", newJString(workflowName))
  add(path_564867, "subscriptionId", newJString(subscriptionId))
  add(path_564867, "resourceGroupName", newJString(resourceGroupName))
  result = call_564866.call(path_564867, query_564868, nil, nil, body_564869)

var workflowsRegenerateAccessKey* = Call_WorkflowsRegenerateAccessKey_564857(
    name: "workflowsRegenerateAccessKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/regenerateAccessKey",
    validator: validate_WorkflowsRegenerateAccessKey_564858, base: "",
    url: url_WorkflowsRegenerateAccessKey_564859, schemes: {Scheme.Https})
type
  Call_WorkflowRunsList_564870 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunsList_564872(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsList_564871(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a list of workflow runs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_564873 = path.getOrDefault("workflowName")
  valid_564873 = validateParameter(valid_564873, JString, required = true,
                                 default = nil)
  if valid_564873 != nil:
    section.add "workflowName", valid_564873
  var valid_564874 = path.getOrDefault("subscriptionId")
  valid_564874 = validateParameter(valid_564874, JString, required = true,
                                 default = nil)
  if valid_564874 != nil:
    section.add "subscriptionId", valid_564874
  var valid_564875 = path.getOrDefault("resourceGroupName")
  valid_564875 = validateParameter(valid_564875, JString, required = true,
                                 default = nil)
  if valid_564875 != nil:
    section.add "resourceGroupName", valid_564875
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Options for filters include: Status, StartTime, and ClientTrackingId.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564876 = query.getOrDefault("api-version")
  valid_564876 = validateParameter(valid_564876, JString, required = true,
                                 default = nil)
  if valid_564876 != nil:
    section.add "api-version", valid_564876
  var valid_564877 = query.getOrDefault("$top")
  valid_564877 = validateParameter(valid_564877, JInt, required = false, default = nil)
  if valid_564877 != nil:
    section.add "$top", valid_564877
  var valid_564878 = query.getOrDefault("$filter")
  valid_564878 = validateParameter(valid_564878, JString, required = false,
                                 default = nil)
  if valid_564878 != nil:
    section.add "$filter", valid_564878
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564879: Call_WorkflowRunsList_564870; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow runs.
  ## 
  let valid = call_564879.validator(path, query, header, formData, body)
  let scheme = call_564879.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564879.url(scheme.get, call_564879.host, call_564879.base,
                         call_564879.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564879, url, valid)

proc call*(call_564880: Call_WorkflowRunsList_564870; apiVersion: string;
          workflowName: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## workflowRunsList
  ## Gets a list of workflow runs.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   Filter: string
  ##         : The filter to apply on the operation. Options for filters include: Status, StartTime, and ClientTrackingId.
  var path_564881 = newJObject()
  var query_564882 = newJObject()
  add(query_564882, "api-version", newJString(apiVersion))
  add(query_564882, "$top", newJInt(Top))
  add(path_564881, "workflowName", newJString(workflowName))
  add(path_564881, "subscriptionId", newJString(subscriptionId))
  add(path_564881, "resourceGroupName", newJString(resourceGroupName))
  add(query_564882, "$filter", newJString(Filter))
  result = call_564880.call(path_564881, query_564882, nil, nil, nil)

var workflowRunsList* = Call_WorkflowRunsList_564870(name: "workflowRunsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs",
    validator: validate_WorkflowRunsList_564871, base: "",
    url: url_WorkflowRunsList_564872, schemes: {Scheme.Https})
type
  Call_WorkflowRunsGet_564883 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunsGet_564885(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsGet_564884(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a workflow run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runName` field"
  var valid_564886 = path.getOrDefault("runName")
  valid_564886 = validateParameter(valid_564886, JString, required = true,
                                 default = nil)
  if valid_564886 != nil:
    section.add "runName", valid_564886
  var valid_564887 = path.getOrDefault("workflowName")
  valid_564887 = validateParameter(valid_564887, JString, required = true,
                                 default = nil)
  if valid_564887 != nil:
    section.add "workflowName", valid_564887
  var valid_564888 = path.getOrDefault("subscriptionId")
  valid_564888 = validateParameter(valid_564888, JString, required = true,
                                 default = nil)
  if valid_564888 != nil:
    section.add "subscriptionId", valid_564888
  var valid_564889 = path.getOrDefault("resourceGroupName")
  valid_564889 = validateParameter(valid_564889, JString, required = true,
                                 default = nil)
  if valid_564889 != nil:
    section.add "resourceGroupName", valid_564889
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564890 = query.getOrDefault("api-version")
  valid_564890 = validateParameter(valid_564890, JString, required = true,
                                 default = nil)
  if valid_564890 != nil:
    section.add "api-version", valid_564890
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564891: Call_WorkflowRunsGet_564883; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow run.
  ## 
  let valid = call_564891.validator(path, query, header, formData, body)
  let scheme = call_564891.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564891.url(scheme.get, call_564891.host, call_564891.base,
                         call_564891.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564891, url, valid)

proc call*(call_564892: Call_WorkflowRunsGet_564883; runName: string;
          apiVersion: string; workflowName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## workflowRunsGet
  ## Gets a workflow run.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564893 = newJObject()
  var query_564894 = newJObject()
  add(path_564893, "runName", newJString(runName))
  add(query_564894, "api-version", newJString(apiVersion))
  add(path_564893, "workflowName", newJString(workflowName))
  add(path_564893, "subscriptionId", newJString(subscriptionId))
  add(path_564893, "resourceGroupName", newJString(resourceGroupName))
  result = call_564892.call(path_564893, query_564894, nil, nil, nil)

var workflowRunsGet* = Call_WorkflowRunsGet_564883(name: "workflowRunsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}",
    validator: validate_WorkflowRunsGet_564884, base: "", url: url_WorkflowRunsGet_564885,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsList_564895 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionsList_564897(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunActionsList_564896(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of workflow run actions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runName` field"
  var valid_564898 = path.getOrDefault("runName")
  valid_564898 = validateParameter(valid_564898, JString, required = true,
                                 default = nil)
  if valid_564898 != nil:
    section.add "runName", valid_564898
  var valid_564899 = path.getOrDefault("workflowName")
  valid_564899 = validateParameter(valid_564899, JString, required = true,
                                 default = nil)
  if valid_564899 != nil:
    section.add "workflowName", valid_564899
  var valid_564900 = path.getOrDefault("subscriptionId")
  valid_564900 = validateParameter(valid_564900, JString, required = true,
                                 default = nil)
  if valid_564900 != nil:
    section.add "subscriptionId", valid_564900
  var valid_564901 = path.getOrDefault("resourceGroupName")
  valid_564901 = validateParameter(valid_564901, JString, required = true,
                                 default = nil)
  if valid_564901 != nil:
    section.add "resourceGroupName", valid_564901
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Options for filters include: Status.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564902 = query.getOrDefault("api-version")
  valid_564902 = validateParameter(valid_564902, JString, required = true,
                                 default = nil)
  if valid_564902 != nil:
    section.add "api-version", valid_564902
  var valid_564903 = query.getOrDefault("$top")
  valid_564903 = validateParameter(valid_564903, JInt, required = false, default = nil)
  if valid_564903 != nil:
    section.add "$top", valid_564903
  var valid_564904 = query.getOrDefault("$filter")
  valid_564904 = validateParameter(valid_564904, JString, required = false,
                                 default = nil)
  if valid_564904 != nil:
    section.add "$filter", valid_564904
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564905: Call_WorkflowRunActionsList_564895; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow run actions.
  ## 
  let valid = call_564905.validator(path, query, header, formData, body)
  let scheme = call_564905.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564905.url(scheme.get, call_564905.host, call_564905.base,
                         call_564905.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564905, url, valid)

proc call*(call_564906: Call_WorkflowRunActionsList_564895; runName: string;
          apiVersion: string; workflowName: string; subscriptionId: string;
          resourceGroupName: string; Top: int = 0; Filter: string = ""): Recallable =
  ## workflowRunActionsList
  ## Gets a list of workflow run actions.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   Filter: string
  ##         : The filter to apply on the operation. Options for filters include: Status.
  var path_564907 = newJObject()
  var query_564908 = newJObject()
  add(path_564907, "runName", newJString(runName))
  add(query_564908, "api-version", newJString(apiVersion))
  add(query_564908, "$top", newJInt(Top))
  add(path_564907, "workflowName", newJString(workflowName))
  add(path_564907, "subscriptionId", newJString(subscriptionId))
  add(path_564907, "resourceGroupName", newJString(resourceGroupName))
  add(query_564908, "$filter", newJString(Filter))
  result = call_564906.call(path_564907, query_564908, nil, nil, nil)

var workflowRunActionsList* = Call_WorkflowRunActionsList_564895(
    name: "workflowRunActionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions",
    validator: validate_WorkflowRunActionsList_564896, base: "",
    url: url_WorkflowRunActionsList_564897, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsGet_564909 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionsGet_564911(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunActionsGet_564910(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a workflow run action.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   actionName: JString (required)
  ##             : The workflow action name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runName` field"
  var valid_564912 = path.getOrDefault("runName")
  valid_564912 = validateParameter(valid_564912, JString, required = true,
                                 default = nil)
  if valid_564912 != nil:
    section.add "runName", valid_564912
  var valid_564913 = path.getOrDefault("workflowName")
  valid_564913 = validateParameter(valid_564913, JString, required = true,
                                 default = nil)
  if valid_564913 != nil:
    section.add "workflowName", valid_564913
  var valid_564914 = path.getOrDefault("subscriptionId")
  valid_564914 = validateParameter(valid_564914, JString, required = true,
                                 default = nil)
  if valid_564914 != nil:
    section.add "subscriptionId", valid_564914
  var valid_564915 = path.getOrDefault("actionName")
  valid_564915 = validateParameter(valid_564915, JString, required = true,
                                 default = nil)
  if valid_564915 != nil:
    section.add "actionName", valid_564915
  var valid_564916 = path.getOrDefault("resourceGroupName")
  valid_564916 = validateParameter(valid_564916, JString, required = true,
                                 default = nil)
  if valid_564916 != nil:
    section.add "resourceGroupName", valid_564916
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564917 = query.getOrDefault("api-version")
  valid_564917 = validateParameter(valid_564917, JString, required = true,
                                 default = nil)
  if valid_564917 != nil:
    section.add "api-version", valid_564917
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564918: Call_WorkflowRunActionsGet_564909; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow run action.
  ## 
  let valid = call_564918.validator(path, query, header, formData, body)
  let scheme = call_564918.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564918.url(scheme.get, call_564918.host, call_564918.base,
                         call_564918.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564918, url, valid)

proc call*(call_564919: Call_WorkflowRunActionsGet_564909; runName: string;
          apiVersion: string; workflowName: string; subscriptionId: string;
          actionName: string; resourceGroupName: string): Recallable =
  ## workflowRunActionsGet
  ## Gets a workflow run action.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   actionName: string (required)
  ##             : The workflow action name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564920 = newJObject()
  var query_564921 = newJObject()
  add(path_564920, "runName", newJString(runName))
  add(query_564921, "api-version", newJString(apiVersion))
  add(path_564920, "workflowName", newJString(workflowName))
  add(path_564920, "subscriptionId", newJString(subscriptionId))
  add(path_564920, "actionName", newJString(actionName))
  add(path_564920, "resourceGroupName", newJString(resourceGroupName))
  result = call_564919.call(path_564920, query_564921, nil, nil, nil)

var workflowRunActionsGet* = Call_WorkflowRunActionsGet_564909(
    name: "workflowRunActionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}",
    validator: validate_WorkflowRunActionsGet_564910, base: "",
    url: url_WorkflowRunActionsGet_564911, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsListExpressionTraces_564922 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionsListExpressionTraces_564924(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "actionName"),
               (kind: ConstantSegment, value: "/listExpressionTraces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowRunActionsListExpressionTraces_564923(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a workflow run expression trace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   actionName: JString (required)
  ##             : The workflow action name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runName` field"
  var valid_564925 = path.getOrDefault("runName")
  valid_564925 = validateParameter(valid_564925, JString, required = true,
                                 default = nil)
  if valid_564925 != nil:
    section.add "runName", valid_564925
  var valid_564926 = path.getOrDefault("workflowName")
  valid_564926 = validateParameter(valid_564926, JString, required = true,
                                 default = nil)
  if valid_564926 != nil:
    section.add "workflowName", valid_564926
  var valid_564927 = path.getOrDefault("subscriptionId")
  valid_564927 = validateParameter(valid_564927, JString, required = true,
                                 default = nil)
  if valid_564927 != nil:
    section.add "subscriptionId", valid_564927
  var valid_564928 = path.getOrDefault("actionName")
  valid_564928 = validateParameter(valid_564928, JString, required = true,
                                 default = nil)
  if valid_564928 != nil:
    section.add "actionName", valid_564928
  var valid_564929 = path.getOrDefault("resourceGroupName")
  valid_564929 = validateParameter(valid_564929, JString, required = true,
                                 default = nil)
  if valid_564929 != nil:
    section.add "resourceGroupName", valid_564929
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564930 = query.getOrDefault("api-version")
  valid_564930 = validateParameter(valid_564930, JString, required = true,
                                 default = nil)
  if valid_564930 != nil:
    section.add "api-version", valid_564930
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564931: Call_WorkflowRunActionsListExpressionTraces_564922;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a workflow run expression trace.
  ## 
  let valid = call_564931.validator(path, query, header, formData, body)
  let scheme = call_564931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564931.url(scheme.get, call_564931.host, call_564931.base,
                         call_564931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564931, url, valid)

proc call*(call_564932: Call_WorkflowRunActionsListExpressionTraces_564922;
          runName: string; apiVersion: string; workflowName: string;
          subscriptionId: string; actionName: string; resourceGroupName: string): Recallable =
  ## workflowRunActionsListExpressionTraces
  ## Lists a workflow run expression trace.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   actionName: string (required)
  ##             : The workflow action name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564933 = newJObject()
  var query_564934 = newJObject()
  add(path_564933, "runName", newJString(runName))
  add(query_564934, "api-version", newJString(apiVersion))
  add(path_564933, "workflowName", newJString(workflowName))
  add(path_564933, "subscriptionId", newJString(subscriptionId))
  add(path_564933, "actionName", newJString(actionName))
  add(path_564933, "resourceGroupName", newJString(resourceGroupName))
  result = call_564932.call(path_564933, query_564934, nil, nil, nil)

var workflowRunActionsListExpressionTraces* = Call_WorkflowRunActionsListExpressionTraces_564922(
    name: "workflowRunActionsListExpressionTraces", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/listExpressionTraces",
    validator: validate_WorkflowRunActionsListExpressionTraces_564923, base: "",
    url: url_WorkflowRunActionsListExpressionTraces_564924,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsList_564935 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionRepetitionsList_564937(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "actionName"),
               (kind: ConstantSegment, value: "/repetitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowRunActionRepetitionsList_564936(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all of a workflow run action repetitions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   actionName: JString (required)
  ##             : The workflow action name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runName` field"
  var valid_564938 = path.getOrDefault("runName")
  valid_564938 = validateParameter(valid_564938, JString, required = true,
                                 default = nil)
  if valid_564938 != nil:
    section.add "runName", valid_564938
  var valid_564939 = path.getOrDefault("workflowName")
  valid_564939 = validateParameter(valid_564939, JString, required = true,
                                 default = nil)
  if valid_564939 != nil:
    section.add "workflowName", valid_564939
  var valid_564940 = path.getOrDefault("subscriptionId")
  valid_564940 = validateParameter(valid_564940, JString, required = true,
                                 default = nil)
  if valid_564940 != nil:
    section.add "subscriptionId", valid_564940
  var valid_564941 = path.getOrDefault("actionName")
  valid_564941 = validateParameter(valid_564941, JString, required = true,
                                 default = nil)
  if valid_564941 != nil:
    section.add "actionName", valid_564941
  var valid_564942 = path.getOrDefault("resourceGroupName")
  valid_564942 = validateParameter(valid_564942, JString, required = true,
                                 default = nil)
  if valid_564942 != nil:
    section.add "resourceGroupName", valid_564942
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564943 = query.getOrDefault("api-version")
  valid_564943 = validateParameter(valid_564943, JString, required = true,
                                 default = nil)
  if valid_564943 != nil:
    section.add "api-version", valid_564943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564944: Call_WorkflowRunActionRepetitionsList_564935;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all of a workflow run action repetitions.
  ## 
  let valid = call_564944.validator(path, query, header, formData, body)
  let scheme = call_564944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564944.url(scheme.get, call_564944.host, call_564944.base,
                         call_564944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564944, url, valid)

proc call*(call_564945: Call_WorkflowRunActionRepetitionsList_564935;
          runName: string; apiVersion: string; workflowName: string;
          subscriptionId: string; actionName: string; resourceGroupName: string): Recallable =
  ## workflowRunActionRepetitionsList
  ## Get all of a workflow run action repetitions.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   actionName: string (required)
  ##             : The workflow action name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564946 = newJObject()
  var query_564947 = newJObject()
  add(path_564946, "runName", newJString(runName))
  add(query_564947, "api-version", newJString(apiVersion))
  add(path_564946, "workflowName", newJString(workflowName))
  add(path_564946, "subscriptionId", newJString(subscriptionId))
  add(path_564946, "actionName", newJString(actionName))
  add(path_564946, "resourceGroupName", newJString(resourceGroupName))
  result = call_564945.call(path_564946, query_564947, nil, nil, nil)

var workflowRunActionRepetitionsList* = Call_WorkflowRunActionRepetitionsList_564935(
    name: "workflowRunActionRepetitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions",
    validator: validate_WorkflowRunActionRepetitionsList_564936, base: "",
    url: url_WorkflowRunActionRepetitionsList_564937, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsGet_564948 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionRepetitionsGet_564950(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
  assert "repetitionName" in path, "`repetitionName` is a required path parameter"
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
               (kind: VariableSegment, value: "actionName"),
               (kind: ConstantSegment, value: "/repetitions/"),
               (kind: VariableSegment, value: "repetitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowRunActionRepetitionsGet_564949(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a workflow run action repetition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   repetitionName: JString (required)
  ##                 : The workflow repetition.
  ##   actionName: JString (required)
  ##             : The workflow action name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runName` field"
  var valid_564951 = path.getOrDefault("runName")
  valid_564951 = validateParameter(valid_564951, JString, required = true,
                                 default = nil)
  if valid_564951 != nil:
    section.add "runName", valid_564951
  var valid_564952 = path.getOrDefault("workflowName")
  valid_564952 = validateParameter(valid_564952, JString, required = true,
                                 default = nil)
  if valid_564952 != nil:
    section.add "workflowName", valid_564952
  var valid_564953 = path.getOrDefault("subscriptionId")
  valid_564953 = validateParameter(valid_564953, JString, required = true,
                                 default = nil)
  if valid_564953 != nil:
    section.add "subscriptionId", valid_564953
  var valid_564954 = path.getOrDefault("repetitionName")
  valid_564954 = validateParameter(valid_564954, JString, required = true,
                                 default = nil)
  if valid_564954 != nil:
    section.add "repetitionName", valid_564954
  var valid_564955 = path.getOrDefault("actionName")
  valid_564955 = validateParameter(valid_564955, JString, required = true,
                                 default = nil)
  if valid_564955 != nil:
    section.add "actionName", valid_564955
  var valid_564956 = path.getOrDefault("resourceGroupName")
  valid_564956 = validateParameter(valid_564956, JString, required = true,
                                 default = nil)
  if valid_564956 != nil:
    section.add "resourceGroupName", valid_564956
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564957 = query.getOrDefault("api-version")
  valid_564957 = validateParameter(valid_564957, JString, required = true,
                                 default = nil)
  if valid_564957 != nil:
    section.add "api-version", valid_564957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564958: Call_WorkflowRunActionRepetitionsGet_564948;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a workflow run action repetition.
  ## 
  let valid = call_564958.validator(path, query, header, formData, body)
  let scheme = call_564958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564958.url(scheme.get, call_564958.host, call_564958.base,
                         call_564958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564958, url, valid)

proc call*(call_564959: Call_WorkflowRunActionRepetitionsGet_564948;
          runName: string; apiVersion: string; workflowName: string;
          subscriptionId: string; repetitionName: string; actionName: string;
          resourceGroupName: string): Recallable =
  ## workflowRunActionRepetitionsGet
  ## Get a workflow run action repetition.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   repetitionName: string (required)
  ##                 : The workflow repetition.
  ##   actionName: string (required)
  ##             : The workflow action name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564960 = newJObject()
  var query_564961 = newJObject()
  add(path_564960, "runName", newJString(runName))
  add(query_564961, "api-version", newJString(apiVersion))
  add(path_564960, "workflowName", newJString(workflowName))
  add(path_564960, "subscriptionId", newJString(subscriptionId))
  add(path_564960, "repetitionName", newJString(repetitionName))
  add(path_564960, "actionName", newJString(actionName))
  add(path_564960, "resourceGroupName", newJString(resourceGroupName))
  result = call_564959.call(path_564960, query_564961, nil, nil, nil)

var workflowRunActionRepetitionsGet* = Call_WorkflowRunActionRepetitionsGet_564948(
    name: "workflowRunActionRepetitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}",
    validator: validate_WorkflowRunActionRepetitionsGet_564949, base: "",
    url: url_WorkflowRunActionRepetitionsGet_564950, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsListExpressionTraces_564962 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionRepetitionsListExpressionTraces_564964(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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
  assert "repetitionName" in path, "`repetitionName` is a required path parameter"
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
               (kind: VariableSegment, value: "actionName"),
               (kind: ConstantSegment, value: "/repetitions/"),
               (kind: VariableSegment, value: "repetitionName"),
               (kind: ConstantSegment, value: "/listExpressionTraces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowRunActionRepetitionsListExpressionTraces_564963(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists a workflow run expression trace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   repetitionName: JString (required)
  ##                 : The workflow repetition.
  ##   actionName: JString (required)
  ##             : The workflow action name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runName` field"
  var valid_564965 = path.getOrDefault("runName")
  valid_564965 = validateParameter(valid_564965, JString, required = true,
                                 default = nil)
  if valid_564965 != nil:
    section.add "runName", valid_564965
  var valid_564966 = path.getOrDefault("workflowName")
  valid_564966 = validateParameter(valid_564966, JString, required = true,
                                 default = nil)
  if valid_564966 != nil:
    section.add "workflowName", valid_564966
  var valid_564967 = path.getOrDefault("subscriptionId")
  valid_564967 = validateParameter(valid_564967, JString, required = true,
                                 default = nil)
  if valid_564967 != nil:
    section.add "subscriptionId", valid_564967
  var valid_564968 = path.getOrDefault("repetitionName")
  valid_564968 = validateParameter(valid_564968, JString, required = true,
                                 default = nil)
  if valid_564968 != nil:
    section.add "repetitionName", valid_564968
  var valid_564969 = path.getOrDefault("actionName")
  valid_564969 = validateParameter(valid_564969, JString, required = true,
                                 default = nil)
  if valid_564969 != nil:
    section.add "actionName", valid_564969
  var valid_564970 = path.getOrDefault("resourceGroupName")
  valid_564970 = validateParameter(valid_564970, JString, required = true,
                                 default = nil)
  if valid_564970 != nil:
    section.add "resourceGroupName", valid_564970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564971 = query.getOrDefault("api-version")
  valid_564971 = validateParameter(valid_564971, JString, required = true,
                                 default = nil)
  if valid_564971 != nil:
    section.add "api-version", valid_564971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564972: Call_WorkflowRunActionRepetitionsListExpressionTraces_564962;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a workflow run expression trace.
  ## 
  let valid = call_564972.validator(path, query, header, formData, body)
  let scheme = call_564972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564972.url(scheme.get, call_564972.host, call_564972.base,
                         call_564972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564972, url, valid)

proc call*(call_564973: Call_WorkflowRunActionRepetitionsListExpressionTraces_564962;
          runName: string; apiVersion: string; workflowName: string;
          subscriptionId: string; repetitionName: string; actionName: string;
          resourceGroupName: string): Recallable =
  ## workflowRunActionRepetitionsListExpressionTraces
  ## Lists a workflow run expression trace.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   repetitionName: string (required)
  ##                 : The workflow repetition.
  ##   actionName: string (required)
  ##             : The workflow action name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564974 = newJObject()
  var query_564975 = newJObject()
  add(path_564974, "runName", newJString(runName))
  add(query_564975, "api-version", newJString(apiVersion))
  add(path_564974, "workflowName", newJString(workflowName))
  add(path_564974, "subscriptionId", newJString(subscriptionId))
  add(path_564974, "repetitionName", newJString(repetitionName))
  add(path_564974, "actionName", newJString(actionName))
  add(path_564974, "resourceGroupName", newJString(resourceGroupName))
  result = call_564973.call(path_564974, query_564975, nil, nil, nil)

var workflowRunActionRepetitionsListExpressionTraces* = Call_WorkflowRunActionRepetitionsListExpressionTraces_564962(
    name: "workflowRunActionRepetitionsListExpressionTraces",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/listExpressionTraces",
    validator: validate_WorkflowRunActionRepetitionsListExpressionTraces_564963,
    base: "", url: url_WorkflowRunActionRepetitionsListExpressionTraces_564964,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsRequestHistoriesList_564976 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionRepetitionsRequestHistoriesList_564978(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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
  assert "repetitionName" in path, "`repetitionName` is a required path parameter"
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
               (kind: VariableSegment, value: "actionName"),
               (kind: ConstantSegment, value: "/repetitions/"),
               (kind: VariableSegment, value: "repetitionName"),
               (kind: ConstantSegment, value: "/requestHistories")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowRunActionRepetitionsRequestHistoriesList_564977(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List a workflow run repetition request history.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   repetitionName: JString (required)
  ##                 : The workflow repetition.
  ##   actionName: JString (required)
  ##             : The workflow action name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runName` field"
  var valid_564979 = path.getOrDefault("runName")
  valid_564979 = validateParameter(valid_564979, JString, required = true,
                                 default = nil)
  if valid_564979 != nil:
    section.add "runName", valid_564979
  var valid_564980 = path.getOrDefault("workflowName")
  valid_564980 = validateParameter(valid_564980, JString, required = true,
                                 default = nil)
  if valid_564980 != nil:
    section.add "workflowName", valid_564980
  var valid_564981 = path.getOrDefault("subscriptionId")
  valid_564981 = validateParameter(valid_564981, JString, required = true,
                                 default = nil)
  if valid_564981 != nil:
    section.add "subscriptionId", valid_564981
  var valid_564982 = path.getOrDefault("repetitionName")
  valid_564982 = validateParameter(valid_564982, JString, required = true,
                                 default = nil)
  if valid_564982 != nil:
    section.add "repetitionName", valid_564982
  var valid_564983 = path.getOrDefault("actionName")
  valid_564983 = validateParameter(valid_564983, JString, required = true,
                                 default = nil)
  if valid_564983 != nil:
    section.add "actionName", valid_564983
  var valid_564984 = path.getOrDefault("resourceGroupName")
  valid_564984 = validateParameter(valid_564984, JString, required = true,
                                 default = nil)
  if valid_564984 != nil:
    section.add "resourceGroupName", valid_564984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564985 = query.getOrDefault("api-version")
  valid_564985 = validateParameter(valid_564985, JString, required = true,
                                 default = nil)
  if valid_564985 != nil:
    section.add "api-version", valid_564985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564986: Call_WorkflowRunActionRepetitionsRequestHistoriesList_564976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a workflow run repetition request history.
  ## 
  let valid = call_564986.validator(path, query, header, formData, body)
  let scheme = call_564986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564986.url(scheme.get, call_564986.host, call_564986.base,
                         call_564986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564986, url, valid)

proc call*(call_564987: Call_WorkflowRunActionRepetitionsRequestHistoriesList_564976;
          runName: string; apiVersion: string; workflowName: string;
          subscriptionId: string; repetitionName: string; actionName: string;
          resourceGroupName: string): Recallable =
  ## workflowRunActionRepetitionsRequestHistoriesList
  ## List a workflow run repetition request history.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   repetitionName: string (required)
  ##                 : The workflow repetition.
  ##   actionName: string (required)
  ##             : The workflow action name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564988 = newJObject()
  var query_564989 = newJObject()
  add(path_564988, "runName", newJString(runName))
  add(query_564989, "api-version", newJString(apiVersion))
  add(path_564988, "workflowName", newJString(workflowName))
  add(path_564988, "subscriptionId", newJString(subscriptionId))
  add(path_564988, "repetitionName", newJString(repetitionName))
  add(path_564988, "actionName", newJString(actionName))
  add(path_564988, "resourceGroupName", newJString(resourceGroupName))
  result = call_564987.call(path_564988, query_564989, nil, nil, nil)

var workflowRunActionRepetitionsRequestHistoriesList* = Call_WorkflowRunActionRepetitionsRequestHistoriesList_564976(
    name: "workflowRunActionRepetitionsRequestHistoriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/requestHistories",
    validator: validate_WorkflowRunActionRepetitionsRequestHistoriesList_564977,
    base: "", url: url_WorkflowRunActionRepetitionsRequestHistoriesList_564978,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsRequestHistoriesGet_564990 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionRepetitionsRequestHistoriesGet_564992(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
  assert "repetitionName" in path, "`repetitionName` is a required path parameter"
  assert "requestHistoryName" in path,
        "`requestHistoryName` is a required path parameter"
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
               (kind: VariableSegment, value: "actionName"),
               (kind: ConstantSegment, value: "/repetitions/"),
               (kind: VariableSegment, value: "repetitionName"),
               (kind: ConstantSegment, value: "/requestHistories/"),
               (kind: VariableSegment, value: "requestHistoryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowRunActionRepetitionsRequestHistoriesGet_564991(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a workflow run repetition request history.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   requestHistoryName: JString (required)
  ##                     : The request history name.
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   repetitionName: JString (required)
  ##                 : The workflow repetition.
  ##   actionName: JString (required)
  ##             : The workflow action name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runName` field"
  var valid_564993 = path.getOrDefault("runName")
  valid_564993 = validateParameter(valid_564993, JString, required = true,
                                 default = nil)
  if valid_564993 != nil:
    section.add "runName", valid_564993
  var valid_564994 = path.getOrDefault("requestHistoryName")
  valid_564994 = validateParameter(valid_564994, JString, required = true,
                                 default = nil)
  if valid_564994 != nil:
    section.add "requestHistoryName", valid_564994
  var valid_564995 = path.getOrDefault("workflowName")
  valid_564995 = validateParameter(valid_564995, JString, required = true,
                                 default = nil)
  if valid_564995 != nil:
    section.add "workflowName", valid_564995
  var valid_564996 = path.getOrDefault("subscriptionId")
  valid_564996 = validateParameter(valid_564996, JString, required = true,
                                 default = nil)
  if valid_564996 != nil:
    section.add "subscriptionId", valid_564996
  var valid_564997 = path.getOrDefault("repetitionName")
  valid_564997 = validateParameter(valid_564997, JString, required = true,
                                 default = nil)
  if valid_564997 != nil:
    section.add "repetitionName", valid_564997
  var valid_564998 = path.getOrDefault("actionName")
  valid_564998 = validateParameter(valid_564998, JString, required = true,
                                 default = nil)
  if valid_564998 != nil:
    section.add "actionName", valid_564998
  var valid_564999 = path.getOrDefault("resourceGroupName")
  valid_564999 = validateParameter(valid_564999, JString, required = true,
                                 default = nil)
  if valid_564999 != nil:
    section.add "resourceGroupName", valid_564999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565000 = query.getOrDefault("api-version")
  valid_565000 = validateParameter(valid_565000, JString, required = true,
                                 default = nil)
  if valid_565000 != nil:
    section.add "api-version", valid_565000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565001: Call_WorkflowRunActionRepetitionsRequestHistoriesGet_564990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a workflow run repetition request history.
  ## 
  let valid = call_565001.validator(path, query, header, formData, body)
  let scheme = call_565001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565001.url(scheme.get, call_565001.host, call_565001.base,
                         call_565001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565001, url, valid)

proc call*(call_565002: Call_WorkflowRunActionRepetitionsRequestHistoriesGet_564990;
          runName: string; apiVersion: string; requestHistoryName: string;
          workflowName: string; subscriptionId: string; repetitionName: string;
          actionName: string; resourceGroupName: string): Recallable =
  ## workflowRunActionRepetitionsRequestHistoriesGet
  ## Gets a workflow run repetition request history.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   requestHistoryName: string (required)
  ##                     : The request history name.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   repetitionName: string (required)
  ##                 : The workflow repetition.
  ##   actionName: string (required)
  ##             : The workflow action name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_565003 = newJObject()
  var query_565004 = newJObject()
  add(path_565003, "runName", newJString(runName))
  add(query_565004, "api-version", newJString(apiVersion))
  add(path_565003, "requestHistoryName", newJString(requestHistoryName))
  add(path_565003, "workflowName", newJString(workflowName))
  add(path_565003, "subscriptionId", newJString(subscriptionId))
  add(path_565003, "repetitionName", newJString(repetitionName))
  add(path_565003, "actionName", newJString(actionName))
  add(path_565003, "resourceGroupName", newJString(resourceGroupName))
  result = call_565002.call(path_565003, query_565004, nil, nil, nil)

var workflowRunActionRepetitionsRequestHistoriesGet* = Call_WorkflowRunActionRepetitionsRequestHistoriesGet_564990(
    name: "workflowRunActionRepetitionsRequestHistoriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/requestHistories/{requestHistoryName}",
    validator: validate_WorkflowRunActionRepetitionsRequestHistoriesGet_564991,
    base: "", url: url_WorkflowRunActionRepetitionsRequestHistoriesGet_564992,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRequestHistoriesList_565005 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionRequestHistoriesList_565007(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "actionName"),
               (kind: ConstantSegment, value: "/requestHistories")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowRunActionRequestHistoriesList_565006(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List a workflow run request history.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   actionName: JString (required)
  ##             : The workflow action name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runName` field"
  var valid_565008 = path.getOrDefault("runName")
  valid_565008 = validateParameter(valid_565008, JString, required = true,
                                 default = nil)
  if valid_565008 != nil:
    section.add "runName", valid_565008
  var valid_565009 = path.getOrDefault("workflowName")
  valid_565009 = validateParameter(valid_565009, JString, required = true,
                                 default = nil)
  if valid_565009 != nil:
    section.add "workflowName", valid_565009
  var valid_565010 = path.getOrDefault("subscriptionId")
  valid_565010 = validateParameter(valid_565010, JString, required = true,
                                 default = nil)
  if valid_565010 != nil:
    section.add "subscriptionId", valid_565010
  var valid_565011 = path.getOrDefault("actionName")
  valid_565011 = validateParameter(valid_565011, JString, required = true,
                                 default = nil)
  if valid_565011 != nil:
    section.add "actionName", valid_565011
  var valid_565012 = path.getOrDefault("resourceGroupName")
  valid_565012 = validateParameter(valid_565012, JString, required = true,
                                 default = nil)
  if valid_565012 != nil:
    section.add "resourceGroupName", valid_565012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565013 = query.getOrDefault("api-version")
  valid_565013 = validateParameter(valid_565013, JString, required = true,
                                 default = nil)
  if valid_565013 != nil:
    section.add "api-version", valid_565013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565014: Call_WorkflowRunActionRequestHistoriesList_565005;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a workflow run request history.
  ## 
  let valid = call_565014.validator(path, query, header, formData, body)
  let scheme = call_565014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565014.url(scheme.get, call_565014.host, call_565014.base,
                         call_565014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565014, url, valid)

proc call*(call_565015: Call_WorkflowRunActionRequestHistoriesList_565005;
          runName: string; apiVersion: string; workflowName: string;
          subscriptionId: string; actionName: string; resourceGroupName: string): Recallable =
  ## workflowRunActionRequestHistoriesList
  ## List a workflow run request history.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   actionName: string (required)
  ##             : The workflow action name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_565016 = newJObject()
  var query_565017 = newJObject()
  add(path_565016, "runName", newJString(runName))
  add(query_565017, "api-version", newJString(apiVersion))
  add(path_565016, "workflowName", newJString(workflowName))
  add(path_565016, "subscriptionId", newJString(subscriptionId))
  add(path_565016, "actionName", newJString(actionName))
  add(path_565016, "resourceGroupName", newJString(resourceGroupName))
  result = call_565015.call(path_565016, query_565017, nil, nil, nil)

var workflowRunActionRequestHistoriesList* = Call_WorkflowRunActionRequestHistoriesList_565005(
    name: "workflowRunActionRequestHistoriesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/requestHistories",
    validator: validate_WorkflowRunActionRequestHistoriesList_565006, base: "",
    url: url_WorkflowRunActionRequestHistoriesList_565007, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRequestHistoriesGet_565018 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionRequestHistoriesGet_565020(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
  assert "requestHistoryName" in path,
        "`requestHistoryName` is a required path parameter"
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
               (kind: VariableSegment, value: "actionName"),
               (kind: ConstantSegment, value: "/requestHistories/"),
               (kind: VariableSegment, value: "requestHistoryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowRunActionRequestHistoriesGet_565019(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a workflow run request history.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   requestHistoryName: JString (required)
  ##                     : The request history name.
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   actionName: JString (required)
  ##             : The workflow action name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runName` field"
  var valid_565021 = path.getOrDefault("runName")
  valid_565021 = validateParameter(valid_565021, JString, required = true,
                                 default = nil)
  if valid_565021 != nil:
    section.add "runName", valid_565021
  var valid_565022 = path.getOrDefault("requestHistoryName")
  valid_565022 = validateParameter(valid_565022, JString, required = true,
                                 default = nil)
  if valid_565022 != nil:
    section.add "requestHistoryName", valid_565022
  var valid_565023 = path.getOrDefault("workflowName")
  valid_565023 = validateParameter(valid_565023, JString, required = true,
                                 default = nil)
  if valid_565023 != nil:
    section.add "workflowName", valid_565023
  var valid_565024 = path.getOrDefault("subscriptionId")
  valid_565024 = validateParameter(valid_565024, JString, required = true,
                                 default = nil)
  if valid_565024 != nil:
    section.add "subscriptionId", valid_565024
  var valid_565025 = path.getOrDefault("actionName")
  valid_565025 = validateParameter(valid_565025, JString, required = true,
                                 default = nil)
  if valid_565025 != nil:
    section.add "actionName", valid_565025
  var valid_565026 = path.getOrDefault("resourceGroupName")
  valid_565026 = validateParameter(valid_565026, JString, required = true,
                                 default = nil)
  if valid_565026 != nil:
    section.add "resourceGroupName", valid_565026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565027 = query.getOrDefault("api-version")
  valid_565027 = validateParameter(valid_565027, JString, required = true,
                                 default = nil)
  if valid_565027 != nil:
    section.add "api-version", valid_565027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565028: Call_WorkflowRunActionRequestHistoriesGet_565018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a workflow run request history.
  ## 
  let valid = call_565028.validator(path, query, header, formData, body)
  let scheme = call_565028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565028.url(scheme.get, call_565028.host, call_565028.base,
                         call_565028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565028, url, valid)

proc call*(call_565029: Call_WorkflowRunActionRequestHistoriesGet_565018;
          runName: string; apiVersion: string; requestHistoryName: string;
          workflowName: string; subscriptionId: string; actionName: string;
          resourceGroupName: string): Recallable =
  ## workflowRunActionRequestHistoriesGet
  ## Gets a workflow run request history.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   requestHistoryName: string (required)
  ##                     : The request history name.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   actionName: string (required)
  ##             : The workflow action name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_565030 = newJObject()
  var query_565031 = newJObject()
  add(path_565030, "runName", newJString(runName))
  add(query_565031, "api-version", newJString(apiVersion))
  add(path_565030, "requestHistoryName", newJString(requestHistoryName))
  add(path_565030, "workflowName", newJString(workflowName))
  add(path_565030, "subscriptionId", newJString(subscriptionId))
  add(path_565030, "actionName", newJString(actionName))
  add(path_565030, "resourceGroupName", newJString(resourceGroupName))
  result = call_565029.call(path_565030, query_565031, nil, nil, nil)

var workflowRunActionRequestHistoriesGet* = Call_WorkflowRunActionRequestHistoriesGet_565018(
    name: "workflowRunActionRequestHistoriesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/requestHistories/{requestHistoryName}",
    validator: validate_WorkflowRunActionRequestHistoriesGet_565019, base: "",
    url: url_WorkflowRunActionRequestHistoriesGet_565020, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionScopeRepetitionsList_565032 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionScopeRepetitionsList_565034(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "actionName"),
               (kind: ConstantSegment, value: "/scopeRepetitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowRunActionScopeRepetitionsList_565033(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the workflow run action scoped repetitions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   actionName: JString (required)
  ##             : The workflow action name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runName` field"
  var valid_565035 = path.getOrDefault("runName")
  valid_565035 = validateParameter(valid_565035, JString, required = true,
                                 default = nil)
  if valid_565035 != nil:
    section.add "runName", valid_565035
  var valid_565036 = path.getOrDefault("workflowName")
  valid_565036 = validateParameter(valid_565036, JString, required = true,
                                 default = nil)
  if valid_565036 != nil:
    section.add "workflowName", valid_565036
  var valid_565037 = path.getOrDefault("subscriptionId")
  valid_565037 = validateParameter(valid_565037, JString, required = true,
                                 default = nil)
  if valid_565037 != nil:
    section.add "subscriptionId", valid_565037
  var valid_565038 = path.getOrDefault("actionName")
  valid_565038 = validateParameter(valid_565038, JString, required = true,
                                 default = nil)
  if valid_565038 != nil:
    section.add "actionName", valid_565038
  var valid_565039 = path.getOrDefault("resourceGroupName")
  valid_565039 = validateParameter(valid_565039, JString, required = true,
                                 default = nil)
  if valid_565039 != nil:
    section.add "resourceGroupName", valid_565039
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565040 = query.getOrDefault("api-version")
  valid_565040 = validateParameter(valid_565040, JString, required = true,
                                 default = nil)
  if valid_565040 != nil:
    section.add "api-version", valid_565040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565041: Call_WorkflowRunActionScopeRepetitionsList_565032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the workflow run action scoped repetitions.
  ## 
  let valid = call_565041.validator(path, query, header, formData, body)
  let scheme = call_565041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565041.url(scheme.get, call_565041.host, call_565041.base,
                         call_565041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565041, url, valid)

proc call*(call_565042: Call_WorkflowRunActionScopeRepetitionsList_565032;
          runName: string; apiVersion: string; workflowName: string;
          subscriptionId: string; actionName: string; resourceGroupName: string): Recallable =
  ## workflowRunActionScopeRepetitionsList
  ## List the workflow run action scoped repetitions.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   actionName: string (required)
  ##             : The workflow action name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_565043 = newJObject()
  var query_565044 = newJObject()
  add(path_565043, "runName", newJString(runName))
  add(query_565044, "api-version", newJString(apiVersion))
  add(path_565043, "workflowName", newJString(workflowName))
  add(path_565043, "subscriptionId", newJString(subscriptionId))
  add(path_565043, "actionName", newJString(actionName))
  add(path_565043, "resourceGroupName", newJString(resourceGroupName))
  result = call_565042.call(path_565043, query_565044, nil, nil, nil)

var workflowRunActionScopeRepetitionsList* = Call_WorkflowRunActionScopeRepetitionsList_565032(
    name: "workflowRunActionScopeRepetitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/scopeRepetitions",
    validator: validate_WorkflowRunActionScopeRepetitionsList_565033, base: "",
    url: url_WorkflowRunActionScopeRepetitionsList_565034, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionScopeRepetitionsGet_565045 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionScopeRepetitionsGet_565047(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
  assert "repetitionName" in path, "`repetitionName` is a required path parameter"
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
               (kind: VariableSegment, value: "actionName"),
               (kind: ConstantSegment, value: "/scopeRepetitions/"),
               (kind: VariableSegment, value: "repetitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowRunActionScopeRepetitionsGet_565046(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a workflow run action scoped repetition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   repetitionName: JString (required)
  ##                 : The workflow repetition.
  ##   actionName: JString (required)
  ##             : The workflow action name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runName` field"
  var valid_565048 = path.getOrDefault("runName")
  valid_565048 = validateParameter(valid_565048, JString, required = true,
                                 default = nil)
  if valid_565048 != nil:
    section.add "runName", valid_565048
  var valid_565049 = path.getOrDefault("workflowName")
  valid_565049 = validateParameter(valid_565049, JString, required = true,
                                 default = nil)
  if valid_565049 != nil:
    section.add "workflowName", valid_565049
  var valid_565050 = path.getOrDefault("subscriptionId")
  valid_565050 = validateParameter(valid_565050, JString, required = true,
                                 default = nil)
  if valid_565050 != nil:
    section.add "subscriptionId", valid_565050
  var valid_565051 = path.getOrDefault("repetitionName")
  valid_565051 = validateParameter(valid_565051, JString, required = true,
                                 default = nil)
  if valid_565051 != nil:
    section.add "repetitionName", valid_565051
  var valid_565052 = path.getOrDefault("actionName")
  valid_565052 = validateParameter(valid_565052, JString, required = true,
                                 default = nil)
  if valid_565052 != nil:
    section.add "actionName", valid_565052
  var valid_565053 = path.getOrDefault("resourceGroupName")
  valid_565053 = validateParameter(valid_565053, JString, required = true,
                                 default = nil)
  if valid_565053 != nil:
    section.add "resourceGroupName", valid_565053
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565054 = query.getOrDefault("api-version")
  valid_565054 = validateParameter(valid_565054, JString, required = true,
                                 default = nil)
  if valid_565054 != nil:
    section.add "api-version", valid_565054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565055: Call_WorkflowRunActionScopeRepetitionsGet_565045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a workflow run action scoped repetition.
  ## 
  let valid = call_565055.validator(path, query, header, formData, body)
  let scheme = call_565055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565055.url(scheme.get, call_565055.host, call_565055.base,
                         call_565055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565055, url, valid)

proc call*(call_565056: Call_WorkflowRunActionScopeRepetitionsGet_565045;
          runName: string; apiVersion: string; workflowName: string;
          subscriptionId: string; repetitionName: string; actionName: string;
          resourceGroupName: string): Recallable =
  ## workflowRunActionScopeRepetitionsGet
  ## Get a workflow run action scoped repetition.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   repetitionName: string (required)
  ##                 : The workflow repetition.
  ##   actionName: string (required)
  ##             : The workflow action name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_565057 = newJObject()
  var query_565058 = newJObject()
  add(path_565057, "runName", newJString(runName))
  add(query_565058, "api-version", newJString(apiVersion))
  add(path_565057, "workflowName", newJString(workflowName))
  add(path_565057, "subscriptionId", newJString(subscriptionId))
  add(path_565057, "repetitionName", newJString(repetitionName))
  add(path_565057, "actionName", newJString(actionName))
  add(path_565057, "resourceGroupName", newJString(resourceGroupName))
  result = call_565056.call(path_565057, query_565058, nil, nil, nil)

var workflowRunActionScopeRepetitionsGet* = Call_WorkflowRunActionScopeRepetitionsGet_565045(
    name: "workflowRunActionScopeRepetitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/scopeRepetitions/{repetitionName}",
    validator: validate_WorkflowRunActionScopeRepetitionsGet_565046, base: "",
    url: url_WorkflowRunActionScopeRepetitionsGet_565047, schemes: {Scheme.Https})
type
  Call_WorkflowRunsCancel_565059 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunsCancel_565061(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsCancel_565060(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Cancels a workflow run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runName` field"
  var valid_565062 = path.getOrDefault("runName")
  valid_565062 = validateParameter(valid_565062, JString, required = true,
                                 default = nil)
  if valid_565062 != nil:
    section.add "runName", valid_565062
  var valid_565063 = path.getOrDefault("workflowName")
  valid_565063 = validateParameter(valid_565063, JString, required = true,
                                 default = nil)
  if valid_565063 != nil:
    section.add "workflowName", valid_565063
  var valid_565064 = path.getOrDefault("subscriptionId")
  valid_565064 = validateParameter(valid_565064, JString, required = true,
                                 default = nil)
  if valid_565064 != nil:
    section.add "subscriptionId", valid_565064
  var valid_565065 = path.getOrDefault("resourceGroupName")
  valid_565065 = validateParameter(valid_565065, JString, required = true,
                                 default = nil)
  if valid_565065 != nil:
    section.add "resourceGroupName", valid_565065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565066 = query.getOrDefault("api-version")
  valid_565066 = validateParameter(valid_565066, JString, required = true,
                                 default = nil)
  if valid_565066 != nil:
    section.add "api-version", valid_565066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565067: Call_WorkflowRunsCancel_565059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a workflow run.
  ## 
  let valid = call_565067.validator(path, query, header, formData, body)
  let scheme = call_565067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565067.url(scheme.get, call_565067.host, call_565067.base,
                         call_565067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565067, url, valid)

proc call*(call_565068: Call_WorkflowRunsCancel_565059; runName: string;
          apiVersion: string; workflowName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## workflowRunsCancel
  ## Cancels a workflow run.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_565069 = newJObject()
  var query_565070 = newJObject()
  add(path_565069, "runName", newJString(runName))
  add(query_565070, "api-version", newJString(apiVersion))
  add(path_565069, "workflowName", newJString(workflowName))
  add(path_565069, "subscriptionId", newJString(subscriptionId))
  add(path_565069, "resourceGroupName", newJString(resourceGroupName))
  result = call_565068.call(path_565069, query_565070, nil, nil, nil)

var workflowRunsCancel* = Call_WorkflowRunsCancel_565059(
    name: "workflowRunsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/cancel",
    validator: validate_WorkflowRunsCancel_565060, base: "",
    url: url_WorkflowRunsCancel_565061, schemes: {Scheme.Https})
type
  Call_WorkflowRunOperationsGet_565071 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunOperationsGet_565073(protocol: Scheme; host: string;
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
  assert "runName" in path, "`runName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowRunOperationsGet_565072(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an operation for a run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runName: JString (required)
  ##          : The workflow run name.
  ##   operationId: JString (required)
  ##              : The workflow operation id.
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runName` field"
  var valid_565074 = path.getOrDefault("runName")
  valid_565074 = validateParameter(valid_565074, JString, required = true,
                                 default = nil)
  if valid_565074 != nil:
    section.add "runName", valid_565074
  var valid_565075 = path.getOrDefault("operationId")
  valid_565075 = validateParameter(valid_565075, JString, required = true,
                                 default = nil)
  if valid_565075 != nil:
    section.add "operationId", valid_565075
  var valid_565076 = path.getOrDefault("workflowName")
  valid_565076 = validateParameter(valid_565076, JString, required = true,
                                 default = nil)
  if valid_565076 != nil:
    section.add "workflowName", valid_565076
  var valid_565077 = path.getOrDefault("subscriptionId")
  valid_565077 = validateParameter(valid_565077, JString, required = true,
                                 default = nil)
  if valid_565077 != nil:
    section.add "subscriptionId", valid_565077
  var valid_565078 = path.getOrDefault("resourceGroupName")
  valid_565078 = validateParameter(valid_565078, JString, required = true,
                                 default = nil)
  if valid_565078 != nil:
    section.add "resourceGroupName", valid_565078
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565079 = query.getOrDefault("api-version")
  valid_565079 = validateParameter(valid_565079, JString, required = true,
                                 default = nil)
  if valid_565079 != nil:
    section.add "api-version", valid_565079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565080: Call_WorkflowRunOperationsGet_565071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an operation for a run.
  ## 
  let valid = call_565080.validator(path, query, header, formData, body)
  let scheme = call_565080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565080.url(scheme.get, call_565080.host, call_565080.base,
                         call_565080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565080, url, valid)

proc call*(call_565081: Call_WorkflowRunOperationsGet_565071; runName: string;
          apiVersion: string; operationId: string; workflowName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## workflowRunOperationsGet
  ## Gets an operation for a run.
  ##   runName: string (required)
  ##          : The workflow run name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   operationId: string (required)
  ##              : The workflow operation id.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_565082 = newJObject()
  var query_565083 = newJObject()
  add(path_565082, "runName", newJString(runName))
  add(query_565083, "api-version", newJString(apiVersion))
  add(path_565082, "operationId", newJString(operationId))
  add(path_565082, "workflowName", newJString(workflowName))
  add(path_565082, "subscriptionId", newJString(subscriptionId))
  add(path_565082, "resourceGroupName", newJString(resourceGroupName))
  result = call_565081.call(path_565082, query_565083, nil, nil, nil)

var workflowRunOperationsGet* = Call_WorkflowRunOperationsGet_565071(
    name: "workflowRunOperationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/operations/{operationId}",
    validator: validate_WorkflowRunOperationsGet_565072, base: "",
    url: url_WorkflowRunOperationsGet_565073, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersList_565084 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggersList_565086(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowTriggersList_565085(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of workflow triggers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_565087 = path.getOrDefault("workflowName")
  valid_565087 = validateParameter(valid_565087, JString, required = true,
                                 default = nil)
  if valid_565087 != nil:
    section.add "workflowName", valid_565087
  var valid_565088 = path.getOrDefault("subscriptionId")
  valid_565088 = validateParameter(valid_565088, JString, required = true,
                                 default = nil)
  if valid_565088 != nil:
    section.add "subscriptionId", valid_565088
  var valid_565089 = path.getOrDefault("resourceGroupName")
  valid_565089 = validateParameter(valid_565089, JString, required = true,
                                 default = nil)
  if valid_565089 != nil:
    section.add "resourceGroupName", valid_565089
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
  var valid_565090 = query.getOrDefault("api-version")
  valid_565090 = validateParameter(valid_565090, JString, required = true,
                                 default = nil)
  if valid_565090 != nil:
    section.add "api-version", valid_565090
  var valid_565091 = query.getOrDefault("$top")
  valid_565091 = validateParameter(valid_565091, JInt, required = false, default = nil)
  if valid_565091 != nil:
    section.add "$top", valid_565091
  var valid_565092 = query.getOrDefault("$filter")
  valid_565092 = validateParameter(valid_565092, JString, required = false,
                                 default = nil)
  if valid_565092 != nil:
    section.add "$filter", valid_565092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565093: Call_WorkflowTriggersList_565084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow triggers.
  ## 
  let valid = call_565093.validator(path, query, header, formData, body)
  let scheme = call_565093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565093.url(scheme.get, call_565093.host, call_565093.base,
                         call_565093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565093, url, valid)

proc call*(call_565094: Call_WorkflowTriggersList_565084; apiVersion: string;
          workflowName: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## workflowTriggersList
  ## Gets a list of workflow triggers.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_565095 = newJObject()
  var query_565096 = newJObject()
  add(query_565096, "api-version", newJString(apiVersion))
  add(query_565096, "$top", newJInt(Top))
  add(path_565095, "workflowName", newJString(workflowName))
  add(path_565095, "subscriptionId", newJString(subscriptionId))
  add(path_565095, "resourceGroupName", newJString(resourceGroupName))
  add(query_565096, "$filter", newJString(Filter))
  result = call_565094.call(path_565095, query_565096, nil, nil, nil)

var workflowTriggersList* = Call_WorkflowTriggersList_565084(
    name: "workflowTriggersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers",
    validator: validate_WorkflowTriggersList_565085, base: "",
    url: url_WorkflowTriggersList_565086, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersGet_565097 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggersGet_565099(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersGet_565098(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets a workflow trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_565100 = path.getOrDefault("workflowName")
  valid_565100 = validateParameter(valid_565100, JString, required = true,
                                 default = nil)
  if valid_565100 != nil:
    section.add "workflowName", valid_565100
  var valid_565101 = path.getOrDefault("subscriptionId")
  valid_565101 = validateParameter(valid_565101, JString, required = true,
                                 default = nil)
  if valid_565101 != nil:
    section.add "subscriptionId", valid_565101
  var valid_565102 = path.getOrDefault("resourceGroupName")
  valid_565102 = validateParameter(valid_565102, JString, required = true,
                                 default = nil)
  if valid_565102 != nil:
    section.add "resourceGroupName", valid_565102
  var valid_565103 = path.getOrDefault("triggerName")
  valid_565103 = validateParameter(valid_565103, JString, required = true,
                                 default = nil)
  if valid_565103 != nil:
    section.add "triggerName", valid_565103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565104 = query.getOrDefault("api-version")
  valid_565104 = validateParameter(valid_565104, JString, required = true,
                                 default = nil)
  if valid_565104 != nil:
    section.add "api-version", valid_565104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565105: Call_WorkflowTriggersGet_565097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow trigger.
  ## 
  let valid = call_565105.validator(path, query, header, formData, body)
  let scheme = call_565105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565105.url(scheme.get, call_565105.host, call_565105.base,
                         call_565105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565105, url, valid)

proc call*(call_565106: Call_WorkflowTriggersGet_565097; apiVersion: string;
          workflowName: string; subscriptionId: string; resourceGroupName: string;
          triggerName: string): Recallable =
  ## workflowTriggersGet
  ## Gets a workflow trigger.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  var path_565107 = newJObject()
  var query_565108 = newJObject()
  add(query_565108, "api-version", newJString(apiVersion))
  add(path_565107, "workflowName", newJString(workflowName))
  add(path_565107, "subscriptionId", newJString(subscriptionId))
  add(path_565107, "resourceGroupName", newJString(resourceGroupName))
  add(path_565107, "triggerName", newJString(triggerName))
  result = call_565106.call(path_565107, query_565108, nil, nil, nil)

var workflowTriggersGet* = Call_WorkflowTriggersGet_565097(
    name: "workflowTriggersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}",
    validator: validate_WorkflowTriggersGet_565098, base: "",
    url: url_WorkflowTriggersGet_565099, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesList_565109 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggerHistoriesList_565111(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesList_565110(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of workflow trigger histories.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_565112 = path.getOrDefault("workflowName")
  valid_565112 = validateParameter(valid_565112, JString, required = true,
                                 default = nil)
  if valid_565112 != nil:
    section.add "workflowName", valid_565112
  var valid_565113 = path.getOrDefault("subscriptionId")
  valid_565113 = validateParameter(valid_565113, JString, required = true,
                                 default = nil)
  if valid_565113 != nil:
    section.add "subscriptionId", valid_565113
  var valid_565114 = path.getOrDefault("resourceGroupName")
  valid_565114 = validateParameter(valid_565114, JString, required = true,
                                 default = nil)
  if valid_565114 != nil:
    section.add "resourceGroupName", valid_565114
  var valid_565115 = path.getOrDefault("triggerName")
  valid_565115 = validateParameter(valid_565115, JString, required = true,
                                 default = nil)
  if valid_565115 != nil:
    section.add "triggerName", valid_565115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Options for filters include: Status, StartTime, and ClientTrackingId.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565116 = query.getOrDefault("api-version")
  valid_565116 = validateParameter(valid_565116, JString, required = true,
                                 default = nil)
  if valid_565116 != nil:
    section.add "api-version", valid_565116
  var valid_565117 = query.getOrDefault("$top")
  valid_565117 = validateParameter(valid_565117, JInt, required = false, default = nil)
  if valid_565117 != nil:
    section.add "$top", valid_565117
  var valid_565118 = query.getOrDefault("$filter")
  valid_565118 = validateParameter(valid_565118, JString, required = false,
                                 default = nil)
  if valid_565118 != nil:
    section.add "$filter", valid_565118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565119: Call_WorkflowTriggerHistoriesList_565109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow trigger histories.
  ## 
  let valid = call_565119.validator(path, query, header, formData, body)
  let scheme = call_565119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565119.url(scheme.get, call_565119.host, call_565119.base,
                         call_565119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565119, url, valid)

proc call*(call_565120: Call_WorkflowTriggerHistoriesList_565109;
          apiVersion: string; workflowName: string; subscriptionId: string;
          resourceGroupName: string; triggerName: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## workflowTriggerHistoriesList
  ## Gets a list of workflow trigger histories.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   Filter: string
  ##         : The filter to apply on the operation. Options for filters include: Status, StartTime, and ClientTrackingId.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  var path_565121 = newJObject()
  var query_565122 = newJObject()
  add(query_565122, "api-version", newJString(apiVersion))
  add(query_565122, "$top", newJInt(Top))
  add(path_565121, "workflowName", newJString(workflowName))
  add(path_565121, "subscriptionId", newJString(subscriptionId))
  add(path_565121, "resourceGroupName", newJString(resourceGroupName))
  add(query_565122, "$filter", newJString(Filter))
  add(path_565121, "triggerName", newJString(triggerName))
  result = call_565120.call(path_565121, query_565122, nil, nil, nil)

var workflowTriggerHistoriesList* = Call_WorkflowTriggerHistoriesList_565109(
    name: "workflowTriggerHistoriesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories",
    validator: validate_WorkflowTriggerHistoriesList_565110, base: "",
    url: url_WorkflowTriggerHistoriesList_565111, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesGet_565123 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggerHistoriesGet_565125(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesGet_565124(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a workflow trigger history.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   historyName: JString (required)
  ##              : The workflow trigger history name. Corresponds to the run name for triggers that resulted in a run.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_565126 = path.getOrDefault("workflowName")
  valid_565126 = validateParameter(valid_565126, JString, required = true,
                                 default = nil)
  if valid_565126 != nil:
    section.add "workflowName", valid_565126
  var valid_565127 = path.getOrDefault("subscriptionId")
  valid_565127 = validateParameter(valid_565127, JString, required = true,
                                 default = nil)
  if valid_565127 != nil:
    section.add "subscriptionId", valid_565127
  var valid_565128 = path.getOrDefault("historyName")
  valid_565128 = validateParameter(valid_565128, JString, required = true,
                                 default = nil)
  if valid_565128 != nil:
    section.add "historyName", valid_565128
  var valid_565129 = path.getOrDefault("resourceGroupName")
  valid_565129 = validateParameter(valid_565129, JString, required = true,
                                 default = nil)
  if valid_565129 != nil:
    section.add "resourceGroupName", valid_565129
  var valid_565130 = path.getOrDefault("triggerName")
  valid_565130 = validateParameter(valid_565130, JString, required = true,
                                 default = nil)
  if valid_565130 != nil:
    section.add "triggerName", valid_565130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565131 = query.getOrDefault("api-version")
  valid_565131 = validateParameter(valid_565131, JString, required = true,
                                 default = nil)
  if valid_565131 != nil:
    section.add "api-version", valid_565131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565132: Call_WorkflowTriggerHistoriesGet_565123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow trigger history.
  ## 
  let valid = call_565132.validator(path, query, header, formData, body)
  let scheme = call_565132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565132.url(scheme.get, call_565132.host, call_565132.base,
                         call_565132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565132, url, valid)

proc call*(call_565133: Call_WorkflowTriggerHistoriesGet_565123;
          apiVersion: string; workflowName: string; subscriptionId: string;
          historyName: string; resourceGroupName: string; triggerName: string): Recallable =
  ## workflowTriggerHistoriesGet
  ## Gets a workflow trigger history.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   historyName: string (required)
  ##              : The workflow trigger history name. Corresponds to the run name for triggers that resulted in a run.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  var path_565134 = newJObject()
  var query_565135 = newJObject()
  add(query_565135, "api-version", newJString(apiVersion))
  add(path_565134, "workflowName", newJString(workflowName))
  add(path_565134, "subscriptionId", newJString(subscriptionId))
  add(path_565134, "historyName", newJString(historyName))
  add(path_565134, "resourceGroupName", newJString(resourceGroupName))
  add(path_565134, "triggerName", newJString(triggerName))
  result = call_565133.call(path_565134, query_565135, nil, nil, nil)

var workflowTriggerHistoriesGet* = Call_WorkflowTriggerHistoriesGet_565123(
    name: "workflowTriggerHistoriesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories/{historyName}",
    validator: validate_WorkflowTriggerHistoriesGet_565124, base: "",
    url: url_WorkflowTriggerHistoriesGet_565125, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesResubmit_565136 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggerHistoriesResubmit_565138(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "historyName"),
               (kind: ConstantSegment, value: "/resubmit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowTriggerHistoriesResubmit_565137(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resubmits a workflow run based on the trigger history.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   historyName: JString (required)
  ##              : The workflow trigger history name. Corresponds to the run name for triggers that resulted in a run.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_565139 = path.getOrDefault("workflowName")
  valid_565139 = validateParameter(valid_565139, JString, required = true,
                                 default = nil)
  if valid_565139 != nil:
    section.add "workflowName", valid_565139
  var valid_565140 = path.getOrDefault("subscriptionId")
  valid_565140 = validateParameter(valid_565140, JString, required = true,
                                 default = nil)
  if valid_565140 != nil:
    section.add "subscriptionId", valid_565140
  var valid_565141 = path.getOrDefault("historyName")
  valid_565141 = validateParameter(valid_565141, JString, required = true,
                                 default = nil)
  if valid_565141 != nil:
    section.add "historyName", valid_565141
  var valid_565142 = path.getOrDefault("resourceGroupName")
  valid_565142 = validateParameter(valid_565142, JString, required = true,
                                 default = nil)
  if valid_565142 != nil:
    section.add "resourceGroupName", valid_565142
  var valid_565143 = path.getOrDefault("triggerName")
  valid_565143 = validateParameter(valid_565143, JString, required = true,
                                 default = nil)
  if valid_565143 != nil:
    section.add "triggerName", valid_565143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565144 = query.getOrDefault("api-version")
  valid_565144 = validateParameter(valid_565144, JString, required = true,
                                 default = nil)
  if valid_565144 != nil:
    section.add "api-version", valid_565144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565145: Call_WorkflowTriggerHistoriesResubmit_565136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resubmits a workflow run based on the trigger history.
  ## 
  let valid = call_565145.validator(path, query, header, formData, body)
  let scheme = call_565145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565145.url(scheme.get, call_565145.host, call_565145.base,
                         call_565145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565145, url, valid)

proc call*(call_565146: Call_WorkflowTriggerHistoriesResubmit_565136;
          apiVersion: string; workflowName: string; subscriptionId: string;
          historyName: string; resourceGroupName: string; triggerName: string): Recallable =
  ## workflowTriggerHistoriesResubmit
  ## Resubmits a workflow run based on the trigger history.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   historyName: string (required)
  ##              : The workflow trigger history name. Corresponds to the run name for triggers that resulted in a run.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  var path_565147 = newJObject()
  var query_565148 = newJObject()
  add(query_565148, "api-version", newJString(apiVersion))
  add(path_565147, "workflowName", newJString(workflowName))
  add(path_565147, "subscriptionId", newJString(subscriptionId))
  add(path_565147, "historyName", newJString(historyName))
  add(path_565147, "resourceGroupName", newJString(resourceGroupName))
  add(path_565147, "triggerName", newJString(triggerName))
  result = call_565146.call(path_565147, query_565148, nil, nil, nil)

var workflowTriggerHistoriesResubmit* = Call_WorkflowTriggerHistoriesResubmit_565136(
    name: "workflowTriggerHistoriesResubmit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories/{historyName}/resubmit",
    validator: validate_WorkflowTriggerHistoriesResubmit_565137, base: "",
    url: url_WorkflowTriggerHistoriesResubmit_565138, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersListCallbackUrl_565149 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggersListCallbackUrl_565151(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/listCallbackUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowTriggersListCallbackUrl_565150(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the callback URL for a workflow trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_565152 = path.getOrDefault("workflowName")
  valid_565152 = validateParameter(valid_565152, JString, required = true,
                                 default = nil)
  if valid_565152 != nil:
    section.add "workflowName", valid_565152
  var valid_565153 = path.getOrDefault("subscriptionId")
  valid_565153 = validateParameter(valid_565153, JString, required = true,
                                 default = nil)
  if valid_565153 != nil:
    section.add "subscriptionId", valid_565153
  var valid_565154 = path.getOrDefault("resourceGroupName")
  valid_565154 = validateParameter(valid_565154, JString, required = true,
                                 default = nil)
  if valid_565154 != nil:
    section.add "resourceGroupName", valid_565154
  var valid_565155 = path.getOrDefault("triggerName")
  valid_565155 = validateParameter(valid_565155, JString, required = true,
                                 default = nil)
  if valid_565155 != nil:
    section.add "triggerName", valid_565155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565156 = query.getOrDefault("api-version")
  valid_565156 = validateParameter(valid_565156, JString, required = true,
                                 default = nil)
  if valid_565156 != nil:
    section.add "api-version", valid_565156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565157: Call_WorkflowTriggersListCallbackUrl_565149;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the callback URL for a workflow trigger.
  ## 
  let valid = call_565157.validator(path, query, header, formData, body)
  let scheme = call_565157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565157.url(scheme.get, call_565157.host, call_565157.base,
                         call_565157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565157, url, valid)

proc call*(call_565158: Call_WorkflowTriggersListCallbackUrl_565149;
          apiVersion: string; workflowName: string; subscriptionId: string;
          resourceGroupName: string; triggerName: string): Recallable =
  ## workflowTriggersListCallbackUrl
  ## Get the callback URL for a workflow trigger.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  var path_565159 = newJObject()
  var query_565160 = newJObject()
  add(query_565160, "api-version", newJString(apiVersion))
  add(path_565159, "workflowName", newJString(workflowName))
  add(path_565159, "subscriptionId", newJString(subscriptionId))
  add(path_565159, "resourceGroupName", newJString(resourceGroupName))
  add(path_565159, "triggerName", newJString(triggerName))
  result = call_565158.call(path_565159, query_565160, nil, nil, nil)

var workflowTriggersListCallbackUrl* = Call_WorkflowTriggersListCallbackUrl_565149(
    name: "workflowTriggersListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/listCallbackUrl",
    validator: validate_WorkflowTriggersListCallbackUrl_565150, base: "",
    url: url_WorkflowTriggersListCallbackUrl_565151, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersReset_565161 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggersReset_565163(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowTriggersReset_565162(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets a workflow trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_565164 = path.getOrDefault("workflowName")
  valid_565164 = validateParameter(valid_565164, JString, required = true,
                                 default = nil)
  if valid_565164 != nil:
    section.add "workflowName", valid_565164
  var valid_565165 = path.getOrDefault("subscriptionId")
  valid_565165 = validateParameter(valid_565165, JString, required = true,
                                 default = nil)
  if valid_565165 != nil:
    section.add "subscriptionId", valid_565165
  var valid_565166 = path.getOrDefault("resourceGroupName")
  valid_565166 = validateParameter(valid_565166, JString, required = true,
                                 default = nil)
  if valid_565166 != nil:
    section.add "resourceGroupName", valid_565166
  var valid_565167 = path.getOrDefault("triggerName")
  valid_565167 = validateParameter(valid_565167, JString, required = true,
                                 default = nil)
  if valid_565167 != nil:
    section.add "triggerName", valid_565167
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565168 = query.getOrDefault("api-version")
  valid_565168 = validateParameter(valid_565168, JString, required = true,
                                 default = nil)
  if valid_565168 != nil:
    section.add "api-version", valid_565168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565169: Call_WorkflowTriggersReset_565161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets a workflow trigger.
  ## 
  let valid = call_565169.validator(path, query, header, formData, body)
  let scheme = call_565169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565169.url(scheme.get, call_565169.host, call_565169.base,
                         call_565169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565169, url, valid)

proc call*(call_565170: Call_WorkflowTriggersReset_565161; apiVersion: string;
          workflowName: string; subscriptionId: string; resourceGroupName: string;
          triggerName: string): Recallable =
  ## workflowTriggersReset
  ## Resets a workflow trigger.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  var path_565171 = newJObject()
  var query_565172 = newJObject()
  add(query_565172, "api-version", newJString(apiVersion))
  add(path_565171, "workflowName", newJString(workflowName))
  add(path_565171, "subscriptionId", newJString(subscriptionId))
  add(path_565171, "resourceGroupName", newJString(resourceGroupName))
  add(path_565171, "triggerName", newJString(triggerName))
  result = call_565170.call(path_565171, query_565172, nil, nil, nil)

var workflowTriggersReset* = Call_WorkflowTriggersReset_565161(
    name: "workflowTriggersReset", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/reset",
    validator: validate_WorkflowTriggersReset_565162, base: "",
    url: url_WorkflowTriggersReset_565163, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersRun_565173 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggersRun_565175(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersRun_565174(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Runs a workflow trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_565176 = path.getOrDefault("workflowName")
  valid_565176 = validateParameter(valid_565176, JString, required = true,
                                 default = nil)
  if valid_565176 != nil:
    section.add "workflowName", valid_565176
  var valid_565177 = path.getOrDefault("subscriptionId")
  valid_565177 = validateParameter(valid_565177, JString, required = true,
                                 default = nil)
  if valid_565177 != nil:
    section.add "subscriptionId", valid_565177
  var valid_565178 = path.getOrDefault("resourceGroupName")
  valid_565178 = validateParameter(valid_565178, JString, required = true,
                                 default = nil)
  if valid_565178 != nil:
    section.add "resourceGroupName", valid_565178
  var valid_565179 = path.getOrDefault("triggerName")
  valid_565179 = validateParameter(valid_565179, JString, required = true,
                                 default = nil)
  if valid_565179 != nil:
    section.add "triggerName", valid_565179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565180 = query.getOrDefault("api-version")
  valid_565180 = validateParameter(valid_565180, JString, required = true,
                                 default = nil)
  if valid_565180 != nil:
    section.add "api-version", valid_565180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565181: Call_WorkflowTriggersRun_565173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a workflow trigger.
  ## 
  let valid = call_565181.validator(path, query, header, formData, body)
  let scheme = call_565181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565181.url(scheme.get, call_565181.host, call_565181.base,
                         call_565181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565181, url, valid)

proc call*(call_565182: Call_WorkflowTriggersRun_565173; apiVersion: string;
          workflowName: string; subscriptionId: string; resourceGroupName: string;
          triggerName: string): Recallable =
  ## workflowTriggersRun
  ## Runs a workflow trigger.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  var path_565183 = newJObject()
  var query_565184 = newJObject()
  add(query_565184, "api-version", newJString(apiVersion))
  add(path_565183, "workflowName", newJString(workflowName))
  add(path_565183, "subscriptionId", newJString(subscriptionId))
  add(path_565183, "resourceGroupName", newJString(resourceGroupName))
  add(path_565183, "triggerName", newJString(triggerName))
  result = call_565182.call(path_565183, query_565184, nil, nil, nil)

var workflowTriggersRun* = Call_WorkflowTriggersRun_565173(
    name: "workflowTriggersRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/run",
    validator: validate_WorkflowTriggersRun_565174, base: "",
    url: url_WorkflowTriggersRun_565175, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersGetSchemaJson_565185 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggersGetSchemaJson_565187(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/schemas/json")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowTriggersGetSchemaJson_565186(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the trigger schema as JSON.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_565188 = path.getOrDefault("workflowName")
  valid_565188 = validateParameter(valid_565188, JString, required = true,
                                 default = nil)
  if valid_565188 != nil:
    section.add "workflowName", valid_565188
  var valid_565189 = path.getOrDefault("subscriptionId")
  valid_565189 = validateParameter(valid_565189, JString, required = true,
                                 default = nil)
  if valid_565189 != nil:
    section.add "subscriptionId", valid_565189
  var valid_565190 = path.getOrDefault("resourceGroupName")
  valid_565190 = validateParameter(valid_565190, JString, required = true,
                                 default = nil)
  if valid_565190 != nil:
    section.add "resourceGroupName", valid_565190
  var valid_565191 = path.getOrDefault("triggerName")
  valid_565191 = validateParameter(valid_565191, JString, required = true,
                                 default = nil)
  if valid_565191 != nil:
    section.add "triggerName", valid_565191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565192 = query.getOrDefault("api-version")
  valid_565192 = validateParameter(valid_565192, JString, required = true,
                                 default = nil)
  if valid_565192 != nil:
    section.add "api-version", valid_565192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565193: Call_WorkflowTriggersGetSchemaJson_565185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the trigger schema as JSON.
  ## 
  let valid = call_565193.validator(path, query, header, formData, body)
  let scheme = call_565193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565193.url(scheme.get, call_565193.host, call_565193.base,
                         call_565193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565193, url, valid)

proc call*(call_565194: Call_WorkflowTriggersGetSchemaJson_565185;
          apiVersion: string; workflowName: string; subscriptionId: string;
          resourceGroupName: string; triggerName: string): Recallable =
  ## workflowTriggersGetSchemaJson
  ## Get the trigger schema as JSON.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  var path_565195 = newJObject()
  var query_565196 = newJObject()
  add(query_565196, "api-version", newJString(apiVersion))
  add(path_565195, "workflowName", newJString(workflowName))
  add(path_565195, "subscriptionId", newJString(subscriptionId))
  add(path_565195, "resourceGroupName", newJString(resourceGroupName))
  add(path_565195, "triggerName", newJString(triggerName))
  result = call_565194.call(path_565195, query_565196, nil, nil, nil)

var workflowTriggersGetSchemaJson* = Call_WorkflowTriggersGetSchemaJson_565185(
    name: "workflowTriggersGetSchemaJson", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/schemas/json",
    validator: validate_WorkflowTriggersGetSchemaJson_565186, base: "",
    url: url_WorkflowTriggersGetSchemaJson_565187, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersSetState_565197 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggersSetState_565199(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/setState")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowTriggersSetState_565198(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the state of a workflow trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_565200 = path.getOrDefault("workflowName")
  valid_565200 = validateParameter(valid_565200, JString, required = true,
                                 default = nil)
  if valid_565200 != nil:
    section.add "workflowName", valid_565200
  var valid_565201 = path.getOrDefault("subscriptionId")
  valid_565201 = validateParameter(valid_565201, JString, required = true,
                                 default = nil)
  if valid_565201 != nil:
    section.add "subscriptionId", valid_565201
  var valid_565202 = path.getOrDefault("resourceGroupName")
  valid_565202 = validateParameter(valid_565202, JString, required = true,
                                 default = nil)
  if valid_565202 != nil:
    section.add "resourceGroupName", valid_565202
  var valid_565203 = path.getOrDefault("triggerName")
  valid_565203 = validateParameter(valid_565203, JString, required = true,
                                 default = nil)
  if valid_565203 != nil:
    section.add "triggerName", valid_565203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565204 = query.getOrDefault("api-version")
  valid_565204 = validateParameter(valid_565204, JString, required = true,
                                 default = nil)
  if valid_565204 != nil:
    section.add "api-version", valid_565204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   setState: JObject (required)
  ##           : The workflow trigger state.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565206: Call_WorkflowTriggersSetState_565197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of a workflow trigger.
  ## 
  let valid = call_565206.validator(path, query, header, formData, body)
  let scheme = call_565206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565206.url(scheme.get, call_565206.host, call_565206.base,
                         call_565206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565206, url, valid)

proc call*(call_565207: Call_WorkflowTriggersSetState_565197; apiVersion: string;
          workflowName: string; subscriptionId: string; setState: JsonNode;
          resourceGroupName: string; triggerName: string): Recallable =
  ## workflowTriggersSetState
  ## Sets the state of a workflow trigger.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   setState: JObject (required)
  ##           : The workflow trigger state.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  var path_565208 = newJObject()
  var query_565209 = newJObject()
  var body_565210 = newJObject()
  add(query_565209, "api-version", newJString(apiVersion))
  add(path_565208, "workflowName", newJString(workflowName))
  add(path_565208, "subscriptionId", newJString(subscriptionId))
  if setState != nil:
    body_565210 = setState
  add(path_565208, "resourceGroupName", newJString(resourceGroupName))
  add(path_565208, "triggerName", newJString(triggerName))
  result = call_565207.call(path_565208, query_565209, nil, nil, body_565210)

var workflowTriggersSetState* = Call_WorkflowTriggersSetState_565197(
    name: "workflowTriggersSetState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/setState",
    validator: validate_WorkflowTriggersSetState_565198, base: "",
    url: url_WorkflowTriggersSetState_565199, schemes: {Scheme.Https})
type
  Call_WorkflowsValidateByResourceGroup_565211 = ref object of OpenApiRestCall_563565
proc url_WorkflowsValidateByResourceGroup_565213(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_WorkflowsValidateByResourceGroup_565212(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_565214 = path.getOrDefault("workflowName")
  valid_565214 = validateParameter(valid_565214, JString, required = true,
                                 default = nil)
  if valid_565214 != nil:
    section.add "workflowName", valid_565214
  var valid_565215 = path.getOrDefault("subscriptionId")
  valid_565215 = validateParameter(valid_565215, JString, required = true,
                                 default = nil)
  if valid_565215 != nil:
    section.add "subscriptionId", valid_565215
  var valid_565216 = path.getOrDefault("resourceGroupName")
  valid_565216 = validateParameter(valid_565216, JString, required = true,
                                 default = nil)
  if valid_565216 != nil:
    section.add "resourceGroupName", valid_565216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565217 = query.getOrDefault("api-version")
  valid_565217 = validateParameter(valid_565217, JString, required = true,
                                 default = nil)
  if valid_565217 != nil:
    section.add "api-version", valid_565217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   validate: JObject (required)
  ##           : The workflow.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565219: Call_WorkflowsValidateByResourceGroup_565211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates the workflow.
  ## 
  let valid = call_565219.validator(path, query, header, formData, body)
  let scheme = call_565219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565219.url(scheme.get, call_565219.host, call_565219.base,
                         call_565219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565219, url, valid)

proc call*(call_565220: Call_WorkflowsValidateByResourceGroup_565211;
          apiVersion: string; workflowName: string; subscriptionId: string;
          resourceGroupName: string; validate: JsonNode): Recallable =
  ## workflowsValidateByResourceGroup
  ## Validates the workflow.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   validate: JObject (required)
  ##           : The workflow.
  var path_565221 = newJObject()
  var query_565222 = newJObject()
  var body_565223 = newJObject()
  add(query_565222, "api-version", newJString(apiVersion))
  add(path_565221, "workflowName", newJString(workflowName))
  add(path_565221, "subscriptionId", newJString(subscriptionId))
  add(path_565221, "resourceGroupName", newJString(resourceGroupName))
  if validate != nil:
    body_565223 = validate
  result = call_565220.call(path_565221, query_565222, nil, nil, body_565223)

var workflowsValidateByResourceGroup* = Call_WorkflowsValidateByResourceGroup_565211(
    name: "workflowsValidateByResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/validate",
    validator: validate_WorkflowsValidateByResourceGroup_565212, base: "",
    url: url_WorkflowsValidateByResourceGroup_565213, schemes: {Scheme.Https})
type
  Call_WorkflowVersionsList_565224 = ref object of OpenApiRestCall_563565
proc url_WorkflowVersionsList_565226(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowVersionsList_565225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of workflow versions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_565227 = path.getOrDefault("workflowName")
  valid_565227 = validateParameter(valid_565227, JString, required = true,
                                 default = nil)
  if valid_565227 != nil:
    section.add "workflowName", valid_565227
  var valid_565228 = path.getOrDefault("subscriptionId")
  valid_565228 = validateParameter(valid_565228, JString, required = true,
                                 default = nil)
  if valid_565228 != nil:
    section.add "subscriptionId", valid_565228
  var valid_565229 = path.getOrDefault("resourceGroupName")
  valid_565229 = validateParameter(valid_565229, JString, required = true,
                                 default = nil)
  if valid_565229 != nil:
    section.add "resourceGroupName", valid_565229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565230 = query.getOrDefault("api-version")
  valid_565230 = validateParameter(valid_565230, JString, required = true,
                                 default = nil)
  if valid_565230 != nil:
    section.add "api-version", valid_565230
  var valid_565231 = query.getOrDefault("$top")
  valid_565231 = validateParameter(valid_565231, JInt, required = false, default = nil)
  if valid_565231 != nil:
    section.add "$top", valid_565231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565232: Call_WorkflowVersionsList_565224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow versions.
  ## 
  let valid = call_565232.validator(path, query, header, formData, body)
  let scheme = call_565232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565232.url(scheme.get, call_565232.host, call_565232.base,
                         call_565232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565232, url, valid)

proc call*(call_565233: Call_WorkflowVersionsList_565224; apiVersion: string;
          workflowName: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0): Recallable =
  ## workflowVersionsList
  ## Gets a list of workflow versions.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_565234 = newJObject()
  var query_565235 = newJObject()
  add(query_565235, "api-version", newJString(apiVersion))
  add(query_565235, "$top", newJInt(Top))
  add(path_565234, "workflowName", newJString(workflowName))
  add(path_565234, "subscriptionId", newJString(subscriptionId))
  add(path_565234, "resourceGroupName", newJString(resourceGroupName))
  result = call_565233.call(path_565234, query_565235, nil, nil, nil)

var workflowVersionsList* = Call_WorkflowVersionsList_565224(
    name: "workflowVersionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions",
    validator: validate_WorkflowVersionsList_565225, base: "",
    url: url_WorkflowVersionsList_565226, schemes: {Scheme.Https})
type
  Call_WorkflowVersionsGet_565236 = ref object of OpenApiRestCall_563565
proc url_WorkflowVersionsGet_565238(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowVersionsGet_565237(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets a workflow version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   versionId: JString (required)
  ##            : The workflow versionId.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_565239 = path.getOrDefault("workflowName")
  valid_565239 = validateParameter(valid_565239, JString, required = true,
                                 default = nil)
  if valid_565239 != nil:
    section.add "workflowName", valid_565239
  var valid_565240 = path.getOrDefault("subscriptionId")
  valid_565240 = validateParameter(valid_565240, JString, required = true,
                                 default = nil)
  if valid_565240 != nil:
    section.add "subscriptionId", valid_565240
  var valid_565241 = path.getOrDefault("resourceGroupName")
  valid_565241 = validateParameter(valid_565241, JString, required = true,
                                 default = nil)
  if valid_565241 != nil:
    section.add "resourceGroupName", valid_565241
  var valid_565242 = path.getOrDefault("versionId")
  valid_565242 = validateParameter(valid_565242, JString, required = true,
                                 default = nil)
  if valid_565242 != nil:
    section.add "versionId", valid_565242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565243 = query.getOrDefault("api-version")
  valid_565243 = validateParameter(valid_565243, JString, required = true,
                                 default = nil)
  if valid_565243 != nil:
    section.add "api-version", valid_565243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565244: Call_WorkflowVersionsGet_565236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow version.
  ## 
  let valid = call_565244.validator(path, query, header, formData, body)
  let scheme = call_565244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565244.url(scheme.get, call_565244.host, call_565244.base,
                         call_565244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565244, url, valid)

proc call*(call_565245: Call_WorkflowVersionsGet_565236; apiVersion: string;
          workflowName: string; subscriptionId: string; resourceGroupName: string;
          versionId: string): Recallable =
  ## workflowVersionsGet
  ## Gets a workflow version.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   versionId: string (required)
  ##            : The workflow versionId.
  var path_565246 = newJObject()
  var query_565247 = newJObject()
  add(query_565247, "api-version", newJString(apiVersion))
  add(path_565246, "workflowName", newJString(workflowName))
  add(path_565246, "subscriptionId", newJString(subscriptionId))
  add(path_565246, "resourceGroupName", newJString(resourceGroupName))
  add(path_565246, "versionId", newJString(versionId))
  result = call_565245.call(path_565246, query_565247, nil, nil, nil)

var workflowVersionsGet* = Call_WorkflowVersionsGet_565236(
    name: "workflowVersionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions/{versionId}",
    validator: validate_WorkflowVersionsGet_565237, base: "",
    url: url_WorkflowVersionsGet_565238, schemes: {Scheme.Https})
type
  Call_WorkflowVersionTriggersListCallbackUrl_565248 = ref object of OpenApiRestCall_563565
proc url_WorkflowVersionTriggersListCallbackUrl_565250(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workflowName" in path, "`workflowName` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Logic/workflows/"),
               (kind: VariableSegment, value: "workflowName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/listCallbackUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowVersionTriggersListCallbackUrl_565249(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the callback url for a trigger of a workflow version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  ##   versionId: JString (required)
  ##            : The workflow versionId.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_565251 = path.getOrDefault("workflowName")
  valid_565251 = validateParameter(valid_565251, JString, required = true,
                                 default = nil)
  if valid_565251 != nil:
    section.add "workflowName", valid_565251
  var valid_565252 = path.getOrDefault("subscriptionId")
  valid_565252 = validateParameter(valid_565252, JString, required = true,
                                 default = nil)
  if valid_565252 != nil:
    section.add "subscriptionId", valid_565252
  var valid_565253 = path.getOrDefault("resourceGroupName")
  valid_565253 = validateParameter(valid_565253, JString, required = true,
                                 default = nil)
  if valid_565253 != nil:
    section.add "resourceGroupName", valid_565253
  var valid_565254 = path.getOrDefault("triggerName")
  valid_565254 = validateParameter(valid_565254, JString, required = true,
                                 default = nil)
  if valid_565254 != nil:
    section.add "triggerName", valid_565254
  var valid_565255 = path.getOrDefault("versionId")
  valid_565255 = validateParameter(valid_565255, JString, required = true,
                                 default = nil)
  if valid_565255 != nil:
    section.add "versionId", valid_565255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565256 = query.getOrDefault("api-version")
  valid_565256 = validateParameter(valid_565256, JString, required = true,
                                 default = nil)
  if valid_565256 != nil:
    section.add "api-version", valid_565256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : The callback URL parameters.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565258: Call_WorkflowVersionTriggersListCallbackUrl_565248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the callback url for a trigger of a workflow version.
  ## 
  let valid = call_565258.validator(path, query, header, formData, body)
  let scheme = call_565258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565258.url(scheme.get, call_565258.host, call_565258.base,
                         call_565258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565258, url, valid)

proc call*(call_565259: Call_WorkflowVersionTriggersListCallbackUrl_565248;
          apiVersion: string; workflowName: string; subscriptionId: string;
          resourceGroupName: string; triggerName: string; versionId: string;
          parameters: JsonNode = nil): Recallable =
  ## workflowVersionTriggersListCallbackUrl
  ## Get the callback url for a trigger of a workflow version.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  ##   versionId: string (required)
  ##            : The workflow versionId.
  ##   parameters: JObject
  ##             : The callback URL parameters.
  var path_565260 = newJObject()
  var query_565261 = newJObject()
  var body_565262 = newJObject()
  add(query_565261, "api-version", newJString(apiVersion))
  add(path_565260, "workflowName", newJString(workflowName))
  add(path_565260, "subscriptionId", newJString(subscriptionId))
  add(path_565260, "resourceGroupName", newJString(resourceGroupName))
  add(path_565260, "triggerName", newJString(triggerName))
  add(path_565260, "versionId", newJString(versionId))
  if parameters != nil:
    body_565262 = parameters
  result = call_565259.call(path_565260, query_565261, nil, nil, body_565262)

var workflowVersionTriggersListCallbackUrl* = Call_WorkflowVersionTriggersListCallbackUrl_565248(
    name: "workflowVersionTriggersListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions/{versionId}/triggers/{triggerName}/listCallbackUrl",
    validator: validate_WorkflowVersionTriggersListCallbackUrl_565249, base: "",
    url: url_WorkflowVersionTriggersListCallbackUrl_565250,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentsListByResourceGroup_565263 = ref object of OpenApiRestCall_563565
proc url_IntegrationServiceEnvironmentsListByResourceGroup_565265(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationServiceEnvironments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationServiceEnvironmentsListByResourceGroup_565264(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a list of integration service environments by resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroup` field"
  var valid_565266 = path.getOrDefault("resourceGroup")
  valid_565266 = validateParameter(valid_565266, JString, required = true,
                                 default = nil)
  if valid_565266 != nil:
    section.add "resourceGroup", valid_565266
  var valid_565267 = path.getOrDefault("subscriptionId")
  valid_565267 = validateParameter(valid_565267, JString, required = true,
                                 default = nil)
  if valid_565267 != nil:
    section.add "subscriptionId", valid_565267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565268 = query.getOrDefault("api-version")
  valid_565268 = validateParameter(valid_565268, JString, required = true,
                                 default = nil)
  if valid_565268 != nil:
    section.add "api-version", valid_565268
  var valid_565269 = query.getOrDefault("$top")
  valid_565269 = validateParameter(valid_565269, JInt, required = false, default = nil)
  if valid_565269 != nil:
    section.add "$top", valid_565269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565270: Call_IntegrationServiceEnvironmentsListByResourceGroup_565263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration service environments by resource group.
  ## 
  let valid = call_565270.validator(path, query, header, formData, body)
  let scheme = call_565270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565270.url(scheme.get, call_565270.host, call_565270.base,
                         call_565270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565270, url, valid)

proc call*(call_565271: Call_IntegrationServiceEnvironmentsListByResourceGroup_565263;
          resourceGroup: string; apiVersion: string; subscriptionId: string;
          Top: int = 0): Recallable =
  ## integrationServiceEnvironmentsListByResourceGroup
  ## Gets a list of integration service environments by resource group.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_565272 = newJObject()
  var query_565273 = newJObject()
  add(path_565272, "resourceGroup", newJString(resourceGroup))
  add(query_565273, "api-version", newJString(apiVersion))
  add(query_565273, "$top", newJInt(Top))
  add(path_565272, "subscriptionId", newJString(subscriptionId))
  result = call_565271.call(path_565272, query_565273, nil, nil, nil)

var integrationServiceEnvironmentsListByResourceGroup* = Call_IntegrationServiceEnvironmentsListByResourceGroup_565263(
    name: "integrationServiceEnvironmentsListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments",
    validator: validate_IntegrationServiceEnvironmentsListByResourceGroup_565264,
    base: "", url: url_IntegrationServiceEnvironmentsListByResourceGroup_565265,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentsCreateOrUpdate_565285 = ref object of OpenApiRestCall_563565
proc url_IntegrationServiceEnvironmentsCreateOrUpdate_565287(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "integrationServiceEnvironmentName" in path,
        "`integrationServiceEnvironmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationServiceEnvironments/"), (
        kind: VariableSegment, value: "integrationServiceEnvironmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationServiceEnvironmentsCreateOrUpdate_565286(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration service environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationServiceEnvironmentName` field"
  var valid_565288 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_565288 = validateParameter(valid_565288, JString, required = true,
                                 default = nil)
  if valid_565288 != nil:
    section.add "integrationServiceEnvironmentName", valid_565288
  var valid_565289 = path.getOrDefault("resourceGroup")
  valid_565289 = validateParameter(valid_565289, JString, required = true,
                                 default = nil)
  if valid_565289 != nil:
    section.add "resourceGroup", valid_565289
  var valid_565290 = path.getOrDefault("subscriptionId")
  valid_565290 = validateParameter(valid_565290, JString, required = true,
                                 default = nil)
  if valid_565290 != nil:
    section.add "subscriptionId", valid_565290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565291 = query.getOrDefault("api-version")
  valid_565291 = validateParameter(valid_565291, JString, required = true,
                                 default = nil)
  if valid_565291 != nil:
    section.add "api-version", valid_565291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   integrationServiceEnvironment: JObject (required)
  ##                                : The integration service environment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565293: Call_IntegrationServiceEnvironmentsCreateOrUpdate_565285;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration service environment.
  ## 
  let valid = call_565293.validator(path, query, header, formData, body)
  let scheme = call_565293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565293.url(scheme.get, call_565293.host, call_565293.base,
                         call_565293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565293, url, valid)

proc call*(call_565294: Call_IntegrationServiceEnvironmentsCreateOrUpdate_565285;
          integrationServiceEnvironmentName: string; resourceGroup: string;
          apiVersion: string; subscriptionId: string;
          integrationServiceEnvironment: JsonNode): Recallable =
  ## integrationServiceEnvironmentsCreateOrUpdate
  ## Creates or updates an integration service environment.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   integrationServiceEnvironment: JObject (required)
  ##                                : The integration service environment.
  var path_565295 = newJObject()
  var query_565296 = newJObject()
  var body_565297 = newJObject()
  add(path_565295, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  add(path_565295, "resourceGroup", newJString(resourceGroup))
  add(query_565296, "api-version", newJString(apiVersion))
  add(path_565295, "subscriptionId", newJString(subscriptionId))
  if integrationServiceEnvironment != nil:
    body_565297 = integrationServiceEnvironment
  result = call_565294.call(path_565295, query_565296, nil, nil, body_565297)

var integrationServiceEnvironmentsCreateOrUpdate* = Call_IntegrationServiceEnvironmentsCreateOrUpdate_565285(
    name: "integrationServiceEnvironmentsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}",
    validator: validate_IntegrationServiceEnvironmentsCreateOrUpdate_565286,
    base: "", url: url_IntegrationServiceEnvironmentsCreateOrUpdate_565287,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentsGet_565274 = ref object of OpenApiRestCall_563565
proc url_IntegrationServiceEnvironmentsGet_565276(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "integrationServiceEnvironmentName" in path,
        "`integrationServiceEnvironmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationServiceEnvironments/"), (
        kind: VariableSegment, value: "integrationServiceEnvironmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationServiceEnvironmentsGet_565275(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration service environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationServiceEnvironmentName` field"
  var valid_565277 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_565277 = validateParameter(valid_565277, JString, required = true,
                                 default = nil)
  if valid_565277 != nil:
    section.add "integrationServiceEnvironmentName", valid_565277
  var valid_565278 = path.getOrDefault("resourceGroup")
  valid_565278 = validateParameter(valid_565278, JString, required = true,
                                 default = nil)
  if valid_565278 != nil:
    section.add "resourceGroup", valid_565278
  var valid_565279 = path.getOrDefault("subscriptionId")
  valid_565279 = validateParameter(valid_565279, JString, required = true,
                                 default = nil)
  if valid_565279 != nil:
    section.add "subscriptionId", valid_565279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565280 = query.getOrDefault("api-version")
  valid_565280 = validateParameter(valid_565280, JString, required = true,
                                 default = nil)
  if valid_565280 != nil:
    section.add "api-version", valid_565280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565281: Call_IntegrationServiceEnvironmentsGet_565274;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an integration service environment.
  ## 
  let valid = call_565281.validator(path, query, header, formData, body)
  let scheme = call_565281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565281.url(scheme.get, call_565281.host, call_565281.base,
                         call_565281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565281, url, valid)

proc call*(call_565282: Call_IntegrationServiceEnvironmentsGet_565274;
          integrationServiceEnvironmentName: string; resourceGroup: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## integrationServiceEnvironmentsGet
  ## Gets an integration service environment.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_565283 = newJObject()
  var query_565284 = newJObject()
  add(path_565283, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  add(path_565283, "resourceGroup", newJString(resourceGroup))
  add(query_565284, "api-version", newJString(apiVersion))
  add(path_565283, "subscriptionId", newJString(subscriptionId))
  result = call_565282.call(path_565283, query_565284, nil, nil, nil)

var integrationServiceEnvironmentsGet* = Call_IntegrationServiceEnvironmentsGet_565274(
    name: "integrationServiceEnvironmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}",
    validator: validate_IntegrationServiceEnvironmentsGet_565275, base: "",
    url: url_IntegrationServiceEnvironmentsGet_565276, schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentsUpdate_565309 = ref object of OpenApiRestCall_563565
proc url_IntegrationServiceEnvironmentsUpdate_565311(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "integrationServiceEnvironmentName" in path,
        "`integrationServiceEnvironmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationServiceEnvironments/"), (
        kind: VariableSegment, value: "integrationServiceEnvironmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationServiceEnvironmentsUpdate_565310(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an integration service environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationServiceEnvironmentName` field"
  var valid_565312 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_565312 = validateParameter(valid_565312, JString, required = true,
                                 default = nil)
  if valid_565312 != nil:
    section.add "integrationServiceEnvironmentName", valid_565312
  var valid_565313 = path.getOrDefault("resourceGroup")
  valid_565313 = validateParameter(valid_565313, JString, required = true,
                                 default = nil)
  if valid_565313 != nil:
    section.add "resourceGroup", valid_565313
  var valid_565314 = path.getOrDefault("subscriptionId")
  valid_565314 = validateParameter(valid_565314, JString, required = true,
                                 default = nil)
  if valid_565314 != nil:
    section.add "subscriptionId", valid_565314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565315 = query.getOrDefault("api-version")
  valid_565315 = validateParameter(valid_565315, JString, required = true,
                                 default = nil)
  if valid_565315 != nil:
    section.add "api-version", valid_565315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   integrationServiceEnvironment: JObject (required)
  ##                                : The integration service environment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565317: Call_IntegrationServiceEnvironmentsUpdate_565309;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an integration service environment.
  ## 
  let valid = call_565317.validator(path, query, header, formData, body)
  let scheme = call_565317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565317.url(scheme.get, call_565317.host, call_565317.base,
                         call_565317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565317, url, valid)

proc call*(call_565318: Call_IntegrationServiceEnvironmentsUpdate_565309;
          integrationServiceEnvironmentName: string; resourceGroup: string;
          apiVersion: string; subscriptionId: string;
          integrationServiceEnvironment: JsonNode): Recallable =
  ## integrationServiceEnvironmentsUpdate
  ## Updates an integration service environment.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   integrationServiceEnvironment: JObject (required)
  ##                                : The integration service environment.
  var path_565319 = newJObject()
  var query_565320 = newJObject()
  var body_565321 = newJObject()
  add(path_565319, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  add(path_565319, "resourceGroup", newJString(resourceGroup))
  add(query_565320, "api-version", newJString(apiVersion))
  add(path_565319, "subscriptionId", newJString(subscriptionId))
  if integrationServiceEnvironment != nil:
    body_565321 = integrationServiceEnvironment
  result = call_565318.call(path_565319, query_565320, nil, nil, body_565321)

var integrationServiceEnvironmentsUpdate* = Call_IntegrationServiceEnvironmentsUpdate_565309(
    name: "integrationServiceEnvironmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}",
    validator: validate_IntegrationServiceEnvironmentsUpdate_565310, base: "",
    url: url_IntegrationServiceEnvironmentsUpdate_565311, schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentsDelete_565298 = ref object of OpenApiRestCall_563565
proc url_IntegrationServiceEnvironmentsDelete_565300(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "integrationServiceEnvironmentName" in path,
        "`integrationServiceEnvironmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationServiceEnvironments/"), (
        kind: VariableSegment, value: "integrationServiceEnvironmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationServiceEnvironmentsDelete_565299(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration service environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationServiceEnvironmentName` field"
  var valid_565301 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_565301 = validateParameter(valid_565301, JString, required = true,
                                 default = nil)
  if valid_565301 != nil:
    section.add "integrationServiceEnvironmentName", valid_565301
  var valid_565302 = path.getOrDefault("resourceGroup")
  valid_565302 = validateParameter(valid_565302, JString, required = true,
                                 default = nil)
  if valid_565302 != nil:
    section.add "resourceGroup", valid_565302
  var valid_565303 = path.getOrDefault("subscriptionId")
  valid_565303 = validateParameter(valid_565303, JString, required = true,
                                 default = nil)
  if valid_565303 != nil:
    section.add "subscriptionId", valid_565303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565304 = query.getOrDefault("api-version")
  valid_565304 = validateParameter(valid_565304, JString, required = true,
                                 default = nil)
  if valid_565304 != nil:
    section.add "api-version", valid_565304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565305: Call_IntegrationServiceEnvironmentsDelete_565298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration service environment.
  ## 
  let valid = call_565305.validator(path, query, header, formData, body)
  let scheme = call_565305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565305.url(scheme.get, call_565305.host, call_565305.base,
                         call_565305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565305, url, valid)

proc call*(call_565306: Call_IntegrationServiceEnvironmentsDelete_565298;
          integrationServiceEnvironmentName: string; resourceGroup: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## integrationServiceEnvironmentsDelete
  ## Deletes an integration service environment.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_565307 = newJObject()
  var query_565308 = newJObject()
  add(path_565307, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  add(path_565307, "resourceGroup", newJString(resourceGroup))
  add(query_565308, "api-version", newJString(apiVersion))
  add(path_565307, "subscriptionId", newJString(subscriptionId))
  result = call_565306.call(path_565307, query_565308, nil, nil, nil)

var integrationServiceEnvironmentsDelete* = Call_IntegrationServiceEnvironmentsDelete_565298(
    name: "integrationServiceEnvironmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}",
    validator: validate_IntegrationServiceEnvironmentsDelete_565299, base: "",
    url: url_IntegrationServiceEnvironmentsDelete_565300, schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentNetworkHealthGet_565322 = ref object of OpenApiRestCall_563565
proc url_IntegrationServiceEnvironmentNetworkHealthGet_565324(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "integrationServiceEnvironmentName" in path,
        "`integrationServiceEnvironmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationServiceEnvironments/"), (
        kind: VariableSegment, value: "integrationServiceEnvironmentName"),
               (kind: ConstantSegment, value: "/health/network")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationServiceEnvironmentNetworkHealthGet_565323(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the integration service environment network health.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationServiceEnvironmentName` field"
  var valid_565325 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_565325 = validateParameter(valid_565325, JString, required = true,
                                 default = nil)
  if valid_565325 != nil:
    section.add "integrationServiceEnvironmentName", valid_565325
  var valid_565326 = path.getOrDefault("resourceGroup")
  valid_565326 = validateParameter(valid_565326, JString, required = true,
                                 default = nil)
  if valid_565326 != nil:
    section.add "resourceGroup", valid_565326
  var valid_565327 = path.getOrDefault("subscriptionId")
  valid_565327 = validateParameter(valid_565327, JString, required = true,
                                 default = nil)
  if valid_565327 != nil:
    section.add "subscriptionId", valid_565327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565328 = query.getOrDefault("api-version")
  valid_565328 = validateParameter(valid_565328, JString, required = true,
                                 default = nil)
  if valid_565328 != nil:
    section.add "api-version", valid_565328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565329: Call_IntegrationServiceEnvironmentNetworkHealthGet_565322;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the integration service environment network health.
  ## 
  let valid = call_565329.validator(path, query, header, formData, body)
  let scheme = call_565329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565329.url(scheme.get, call_565329.host, call_565329.base,
                         call_565329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565329, url, valid)

proc call*(call_565330: Call_IntegrationServiceEnvironmentNetworkHealthGet_565322;
          integrationServiceEnvironmentName: string; resourceGroup: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## integrationServiceEnvironmentNetworkHealthGet
  ## Gets the integration service environment network health.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_565331 = newJObject()
  var query_565332 = newJObject()
  add(path_565331, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  add(path_565331, "resourceGroup", newJString(resourceGroup))
  add(query_565332, "api-version", newJString(apiVersion))
  add(path_565331, "subscriptionId", newJString(subscriptionId))
  result = call_565330.call(path_565331, query_565332, nil, nil, nil)

var integrationServiceEnvironmentNetworkHealthGet* = Call_IntegrationServiceEnvironmentNetworkHealthGet_565322(
    name: "integrationServiceEnvironmentNetworkHealthGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}/health/network",
    validator: validate_IntegrationServiceEnvironmentNetworkHealthGet_565323,
    base: "", url: url_IntegrationServiceEnvironmentNetworkHealthGet_565324,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentManagedApisList_565333 = ref object of OpenApiRestCall_563565
proc url_IntegrationServiceEnvironmentManagedApisList_565335(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "integrationServiceEnvironmentName" in path,
        "`integrationServiceEnvironmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationServiceEnvironments/"), (
        kind: VariableSegment, value: "integrationServiceEnvironmentName"),
               (kind: ConstantSegment, value: "/managedApis")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationServiceEnvironmentManagedApisList_565334(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the integration service environment managed Apis.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationServiceEnvironmentName` field"
  var valid_565336 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_565336 = validateParameter(valid_565336, JString, required = true,
                                 default = nil)
  if valid_565336 != nil:
    section.add "integrationServiceEnvironmentName", valid_565336
  var valid_565337 = path.getOrDefault("resourceGroup")
  valid_565337 = validateParameter(valid_565337, JString, required = true,
                                 default = nil)
  if valid_565337 != nil:
    section.add "resourceGroup", valid_565337
  var valid_565338 = path.getOrDefault("subscriptionId")
  valid_565338 = validateParameter(valid_565338, JString, required = true,
                                 default = nil)
  if valid_565338 != nil:
    section.add "subscriptionId", valid_565338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565339 = query.getOrDefault("api-version")
  valid_565339 = validateParameter(valid_565339, JString, required = true,
                                 default = nil)
  if valid_565339 != nil:
    section.add "api-version", valid_565339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565340: Call_IntegrationServiceEnvironmentManagedApisList_565333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the integration service environment managed Apis.
  ## 
  let valid = call_565340.validator(path, query, header, formData, body)
  let scheme = call_565340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565340.url(scheme.get, call_565340.host, call_565340.base,
                         call_565340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565340, url, valid)

proc call*(call_565341: Call_IntegrationServiceEnvironmentManagedApisList_565333;
          integrationServiceEnvironmentName: string; resourceGroup: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## integrationServiceEnvironmentManagedApisList
  ## Gets the integration service environment managed Apis.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_565342 = newJObject()
  var query_565343 = newJObject()
  add(path_565342, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  add(path_565342, "resourceGroup", newJString(resourceGroup))
  add(query_565343, "api-version", newJString(apiVersion))
  add(path_565342, "subscriptionId", newJString(subscriptionId))
  result = call_565341.call(path_565342, query_565343, nil, nil, nil)

var integrationServiceEnvironmentManagedApisList* = Call_IntegrationServiceEnvironmentManagedApisList_565333(
    name: "integrationServiceEnvironmentManagedApisList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}/managedApis",
    validator: validate_IntegrationServiceEnvironmentManagedApisList_565334,
    base: "", url: url_IntegrationServiceEnvironmentManagedApisList_565335,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentManagedApisPut_565356 = ref object of OpenApiRestCall_563565
proc url_IntegrationServiceEnvironmentManagedApisPut_565358(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "integrationServiceEnvironmentName" in path,
        "`integrationServiceEnvironmentName` is a required path parameter"
  assert "apiName" in path, "`apiName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationServiceEnvironments/"), (
        kind: VariableSegment, value: "integrationServiceEnvironmentName"),
               (kind: ConstantSegment, value: "/managedApis/"),
               (kind: VariableSegment, value: "apiName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationServiceEnvironmentManagedApisPut_565357(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Puts the integration service environment managed Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: JString (required)
  ##                : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   apiName: JString (required)
  ##          : The api name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationServiceEnvironmentName` field"
  var valid_565359 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_565359 = validateParameter(valid_565359, JString, required = true,
                                 default = nil)
  if valid_565359 != nil:
    section.add "integrationServiceEnvironmentName", valid_565359
  var valid_565360 = path.getOrDefault("resourceGroup")
  valid_565360 = validateParameter(valid_565360, JString, required = true,
                                 default = nil)
  if valid_565360 != nil:
    section.add "resourceGroup", valid_565360
  var valid_565361 = path.getOrDefault("subscriptionId")
  valid_565361 = validateParameter(valid_565361, JString, required = true,
                                 default = nil)
  if valid_565361 != nil:
    section.add "subscriptionId", valid_565361
  var valid_565362 = path.getOrDefault("apiName")
  valid_565362 = validateParameter(valid_565362, JString, required = true,
                                 default = nil)
  if valid_565362 != nil:
    section.add "apiName", valid_565362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565363 = query.getOrDefault("api-version")
  valid_565363 = validateParameter(valid_565363, JString, required = true,
                                 default = nil)
  if valid_565363 != nil:
    section.add "api-version", valid_565363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565364: Call_IntegrationServiceEnvironmentManagedApisPut_565356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Puts the integration service environment managed Api.
  ## 
  let valid = call_565364.validator(path, query, header, formData, body)
  let scheme = call_565364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565364.url(scheme.get, call_565364.host, call_565364.base,
                         call_565364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565364, url, valid)

proc call*(call_565365: Call_IntegrationServiceEnvironmentManagedApisPut_565356;
          integrationServiceEnvironmentName: string; resourceGroup: string;
          apiVersion: string; subscriptionId: string; apiName: string): Recallable =
  ## integrationServiceEnvironmentManagedApisPut
  ## Puts the integration service environment managed Api.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: string (required)
  ##                : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   apiName: string (required)
  ##          : The api name.
  var path_565366 = newJObject()
  var query_565367 = newJObject()
  add(path_565366, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  add(path_565366, "resourceGroup", newJString(resourceGroup))
  add(query_565367, "api-version", newJString(apiVersion))
  add(path_565366, "subscriptionId", newJString(subscriptionId))
  add(path_565366, "apiName", newJString(apiName))
  result = call_565365.call(path_565366, query_565367, nil, nil, nil)

var integrationServiceEnvironmentManagedApisPut* = Call_IntegrationServiceEnvironmentManagedApisPut_565356(
    name: "integrationServiceEnvironmentManagedApisPut", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}/managedApis/{apiName}",
    validator: validate_IntegrationServiceEnvironmentManagedApisPut_565357,
    base: "", url: url_IntegrationServiceEnvironmentManagedApisPut_565358,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentManagedApisGet_565344 = ref object of OpenApiRestCall_563565
proc url_IntegrationServiceEnvironmentManagedApisGet_565346(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "integrationServiceEnvironmentName" in path,
        "`integrationServiceEnvironmentName` is a required path parameter"
  assert "apiName" in path, "`apiName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationServiceEnvironments/"), (
        kind: VariableSegment, value: "integrationServiceEnvironmentName"),
               (kind: ConstantSegment, value: "/managedApis/"),
               (kind: VariableSegment, value: "apiName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationServiceEnvironmentManagedApisGet_565345(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the integration service environment managed Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: JString (required)
  ##                : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   apiName: JString (required)
  ##          : The api name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationServiceEnvironmentName` field"
  var valid_565347 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_565347 = validateParameter(valid_565347, JString, required = true,
                                 default = nil)
  if valid_565347 != nil:
    section.add "integrationServiceEnvironmentName", valid_565347
  var valid_565348 = path.getOrDefault("resourceGroup")
  valid_565348 = validateParameter(valid_565348, JString, required = true,
                                 default = nil)
  if valid_565348 != nil:
    section.add "resourceGroup", valid_565348
  var valid_565349 = path.getOrDefault("subscriptionId")
  valid_565349 = validateParameter(valid_565349, JString, required = true,
                                 default = nil)
  if valid_565349 != nil:
    section.add "subscriptionId", valid_565349
  var valid_565350 = path.getOrDefault("apiName")
  valid_565350 = validateParameter(valid_565350, JString, required = true,
                                 default = nil)
  if valid_565350 != nil:
    section.add "apiName", valid_565350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565351 = query.getOrDefault("api-version")
  valid_565351 = validateParameter(valid_565351, JString, required = true,
                                 default = nil)
  if valid_565351 != nil:
    section.add "api-version", valid_565351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565352: Call_IntegrationServiceEnvironmentManagedApisGet_565344;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the integration service environment managed Api.
  ## 
  let valid = call_565352.validator(path, query, header, formData, body)
  let scheme = call_565352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565352.url(scheme.get, call_565352.host, call_565352.base,
                         call_565352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565352, url, valid)

proc call*(call_565353: Call_IntegrationServiceEnvironmentManagedApisGet_565344;
          integrationServiceEnvironmentName: string; resourceGroup: string;
          apiVersion: string; subscriptionId: string; apiName: string): Recallable =
  ## integrationServiceEnvironmentManagedApisGet
  ## Gets the integration service environment managed Api.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: string (required)
  ##                : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   apiName: string (required)
  ##          : The api name.
  var path_565354 = newJObject()
  var query_565355 = newJObject()
  add(path_565354, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  add(path_565354, "resourceGroup", newJString(resourceGroup))
  add(query_565355, "api-version", newJString(apiVersion))
  add(path_565354, "subscriptionId", newJString(subscriptionId))
  add(path_565354, "apiName", newJString(apiName))
  result = call_565353.call(path_565354, query_565355, nil, nil, nil)

var integrationServiceEnvironmentManagedApisGet* = Call_IntegrationServiceEnvironmentManagedApisGet_565344(
    name: "integrationServiceEnvironmentManagedApisGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}/managedApis/{apiName}",
    validator: validate_IntegrationServiceEnvironmentManagedApisGet_565345,
    base: "", url: url_IntegrationServiceEnvironmentManagedApisGet_565346,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentManagedApisDelete_565368 = ref object of OpenApiRestCall_563565
proc url_IntegrationServiceEnvironmentManagedApisDelete_565370(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "integrationServiceEnvironmentName" in path,
        "`integrationServiceEnvironmentName` is a required path parameter"
  assert "apiName" in path, "`apiName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationServiceEnvironments/"), (
        kind: VariableSegment, value: "integrationServiceEnvironmentName"),
               (kind: ConstantSegment, value: "/managedApis/"),
               (kind: VariableSegment, value: "apiName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationServiceEnvironmentManagedApisDelete_565369(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the integration service environment managed Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   apiName: JString (required)
  ##          : The api name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationServiceEnvironmentName` field"
  var valid_565371 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_565371 = validateParameter(valid_565371, JString, required = true,
                                 default = nil)
  if valid_565371 != nil:
    section.add "integrationServiceEnvironmentName", valid_565371
  var valid_565372 = path.getOrDefault("resourceGroup")
  valid_565372 = validateParameter(valid_565372, JString, required = true,
                                 default = nil)
  if valid_565372 != nil:
    section.add "resourceGroup", valid_565372
  var valid_565373 = path.getOrDefault("subscriptionId")
  valid_565373 = validateParameter(valid_565373, JString, required = true,
                                 default = nil)
  if valid_565373 != nil:
    section.add "subscriptionId", valid_565373
  var valid_565374 = path.getOrDefault("apiName")
  valid_565374 = validateParameter(valid_565374, JString, required = true,
                                 default = nil)
  if valid_565374 != nil:
    section.add "apiName", valid_565374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565375 = query.getOrDefault("api-version")
  valid_565375 = validateParameter(valid_565375, JString, required = true,
                                 default = nil)
  if valid_565375 != nil:
    section.add "api-version", valid_565375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565376: Call_IntegrationServiceEnvironmentManagedApisDelete_565368;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the integration service environment managed Api.
  ## 
  let valid = call_565376.validator(path, query, header, formData, body)
  let scheme = call_565376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565376.url(scheme.get, call_565376.host, call_565376.base,
                         call_565376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565376, url, valid)

proc call*(call_565377: Call_IntegrationServiceEnvironmentManagedApisDelete_565368;
          integrationServiceEnvironmentName: string; resourceGroup: string;
          apiVersion: string; subscriptionId: string; apiName: string): Recallable =
  ## integrationServiceEnvironmentManagedApisDelete
  ## Deletes the integration service environment managed Api.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   apiName: string (required)
  ##          : The api name.
  var path_565378 = newJObject()
  var query_565379 = newJObject()
  add(path_565378, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  add(path_565378, "resourceGroup", newJString(resourceGroup))
  add(query_565379, "api-version", newJString(apiVersion))
  add(path_565378, "subscriptionId", newJString(subscriptionId))
  add(path_565378, "apiName", newJString(apiName))
  result = call_565377.call(path_565378, query_565379, nil, nil, nil)

var integrationServiceEnvironmentManagedApisDelete* = Call_IntegrationServiceEnvironmentManagedApisDelete_565368(
    name: "integrationServiceEnvironmentManagedApisDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}/managedApis/{apiName}",
    validator: validate_IntegrationServiceEnvironmentManagedApisDelete_565369,
    base: "", url: url_IntegrationServiceEnvironmentManagedApisDelete_565370,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentManagedApiOperationsList_565380 = ref object of OpenApiRestCall_563565
proc url_IntegrationServiceEnvironmentManagedApiOperationsList_565382(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "integrationServiceEnvironmentName" in path,
        "`integrationServiceEnvironmentName` is a required path parameter"
  assert "apiName" in path, "`apiName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationServiceEnvironments/"), (
        kind: VariableSegment, value: "integrationServiceEnvironmentName"),
               (kind: ConstantSegment, value: "/managedApis/"),
               (kind: VariableSegment, value: "apiName"),
               (kind: ConstantSegment, value: "/apiOperations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationServiceEnvironmentManagedApiOperationsList_565381(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the managed Api operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   apiName: JString (required)
  ##          : The api name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationServiceEnvironmentName` field"
  var valid_565383 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_565383 = validateParameter(valid_565383, JString, required = true,
                                 default = nil)
  if valid_565383 != nil:
    section.add "integrationServiceEnvironmentName", valid_565383
  var valid_565384 = path.getOrDefault("resourceGroup")
  valid_565384 = validateParameter(valid_565384, JString, required = true,
                                 default = nil)
  if valid_565384 != nil:
    section.add "resourceGroup", valid_565384
  var valid_565385 = path.getOrDefault("subscriptionId")
  valid_565385 = validateParameter(valid_565385, JString, required = true,
                                 default = nil)
  if valid_565385 != nil:
    section.add "subscriptionId", valid_565385
  var valid_565386 = path.getOrDefault("apiName")
  valid_565386 = validateParameter(valid_565386, JString, required = true,
                                 default = nil)
  if valid_565386 != nil:
    section.add "apiName", valid_565386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565387 = query.getOrDefault("api-version")
  valid_565387 = validateParameter(valid_565387, JString, required = true,
                                 default = nil)
  if valid_565387 != nil:
    section.add "api-version", valid_565387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565388: Call_IntegrationServiceEnvironmentManagedApiOperationsList_565380;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the managed Api operations.
  ## 
  let valid = call_565388.validator(path, query, header, formData, body)
  let scheme = call_565388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565388.url(scheme.get, call_565388.host, call_565388.base,
                         call_565388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565388, url, valid)

proc call*(call_565389: Call_IntegrationServiceEnvironmentManagedApiOperationsList_565380;
          integrationServiceEnvironmentName: string; resourceGroup: string;
          apiVersion: string; subscriptionId: string; apiName: string): Recallable =
  ## integrationServiceEnvironmentManagedApiOperationsList
  ## Gets the managed Api operations.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   apiName: string (required)
  ##          : The api name.
  var path_565390 = newJObject()
  var query_565391 = newJObject()
  add(path_565390, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  add(path_565390, "resourceGroup", newJString(resourceGroup))
  add(query_565391, "api-version", newJString(apiVersion))
  add(path_565390, "subscriptionId", newJString(subscriptionId))
  add(path_565390, "apiName", newJString(apiName))
  result = call_565389.call(path_565390, query_565391, nil, nil, nil)

var integrationServiceEnvironmentManagedApiOperationsList* = Call_IntegrationServiceEnvironmentManagedApiOperationsList_565380(
    name: "integrationServiceEnvironmentManagedApiOperationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}/managedApis/{apiName}/apiOperations",
    validator: validate_IntegrationServiceEnvironmentManagedApiOperationsList_565381,
    base: "", url: url_IntegrationServiceEnvironmentManagedApiOperationsList_565382,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentsRestart_565392 = ref object of OpenApiRestCall_563565
proc url_IntegrationServiceEnvironmentsRestart_565394(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "integrationServiceEnvironmentName" in path,
        "`integrationServiceEnvironmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationServiceEnvironments/"), (
        kind: VariableSegment, value: "integrationServiceEnvironmentName"),
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationServiceEnvironmentsRestart_565393(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restarts an integration service environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationServiceEnvironmentName` field"
  var valid_565395 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_565395 = validateParameter(valid_565395, JString, required = true,
                                 default = nil)
  if valid_565395 != nil:
    section.add "integrationServiceEnvironmentName", valid_565395
  var valid_565396 = path.getOrDefault("resourceGroup")
  valid_565396 = validateParameter(valid_565396, JString, required = true,
                                 default = nil)
  if valid_565396 != nil:
    section.add "resourceGroup", valid_565396
  var valid_565397 = path.getOrDefault("subscriptionId")
  valid_565397 = validateParameter(valid_565397, JString, required = true,
                                 default = nil)
  if valid_565397 != nil:
    section.add "subscriptionId", valid_565397
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565398 = query.getOrDefault("api-version")
  valid_565398 = validateParameter(valid_565398, JString, required = true,
                                 default = nil)
  if valid_565398 != nil:
    section.add "api-version", valid_565398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565399: Call_IntegrationServiceEnvironmentsRestart_565392;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restarts an integration service environment.
  ## 
  let valid = call_565399.validator(path, query, header, formData, body)
  let scheme = call_565399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565399.url(scheme.get, call_565399.host, call_565399.base,
                         call_565399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565399, url, valid)

proc call*(call_565400: Call_IntegrationServiceEnvironmentsRestart_565392;
          integrationServiceEnvironmentName: string; resourceGroup: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## integrationServiceEnvironmentsRestart
  ## Restarts an integration service environment.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_565401 = newJObject()
  var query_565402 = newJObject()
  add(path_565401, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  add(path_565401, "resourceGroup", newJString(resourceGroup))
  add(query_565402, "api-version", newJString(apiVersion))
  add(path_565401, "subscriptionId", newJString(subscriptionId))
  result = call_565400.call(path_565401, query_565402, nil, nil, nil)

var integrationServiceEnvironmentsRestart* = Call_IntegrationServiceEnvironmentsRestart_565392(
    name: "integrationServiceEnvironmentsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}/restart",
    validator: validate_IntegrationServiceEnvironmentsRestart_565393, base: "",
    url: url_IntegrationServiceEnvironmentsRestart_565394, schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentSkusList_565403 = ref object of OpenApiRestCall_563565
proc url_IntegrationServiceEnvironmentSkusList_565405(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "integrationServiceEnvironmentName" in path,
        "`integrationServiceEnvironmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationServiceEnvironments/"), (
        kind: VariableSegment, value: "integrationServiceEnvironmentName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationServiceEnvironmentSkusList_565404(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration service environment Skus.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationServiceEnvironmentName` field"
  var valid_565406 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_565406 = validateParameter(valid_565406, JString, required = true,
                                 default = nil)
  if valid_565406 != nil:
    section.add "integrationServiceEnvironmentName", valid_565406
  var valid_565407 = path.getOrDefault("resourceGroup")
  valid_565407 = validateParameter(valid_565407, JString, required = true,
                                 default = nil)
  if valid_565407 != nil:
    section.add "resourceGroup", valid_565407
  var valid_565408 = path.getOrDefault("subscriptionId")
  valid_565408 = validateParameter(valid_565408, JString, required = true,
                                 default = nil)
  if valid_565408 != nil:
    section.add "subscriptionId", valid_565408
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565409 = query.getOrDefault("api-version")
  valid_565409 = validateParameter(valid_565409, JString, required = true,
                                 default = nil)
  if valid_565409 != nil:
    section.add "api-version", valid_565409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565410: Call_IntegrationServiceEnvironmentSkusList_565403;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration service environment Skus.
  ## 
  let valid = call_565410.validator(path, query, header, formData, body)
  let scheme = call_565410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565410.url(scheme.get, call_565410.host, call_565410.base,
                         call_565410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565410, url, valid)

proc call*(call_565411: Call_IntegrationServiceEnvironmentSkusList_565403;
          integrationServiceEnvironmentName: string; resourceGroup: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## integrationServiceEnvironmentSkusList
  ## Gets a list of integration service environment Skus.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_565412 = newJObject()
  var query_565413 = newJObject()
  add(path_565412, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  add(path_565412, "resourceGroup", newJString(resourceGroup))
  add(query_565413, "api-version", newJString(apiVersion))
  add(path_565412, "subscriptionId", newJString(subscriptionId))
  result = call_565411.call(path_565412, query_565413, nil, nil, nil)

var integrationServiceEnvironmentSkusList* = Call_IntegrationServiceEnvironmentSkusList_565403(
    name: "integrationServiceEnvironmentSkusList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}/skus",
    validator: validate_IntegrationServiceEnvironmentSkusList_565404, base: "",
    url: url_IntegrationServiceEnvironmentSkusList_565405, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
