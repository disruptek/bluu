
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: LogicManagementClient
## version: 2016-06-01
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
  Call_ListOperations_563787 = ref object of OpenApiRestCall_563565
proc url_ListOperations_563789(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListOperations_563788(path: JsonNode; query: JsonNode;
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

proc call*(call_563973: Call_ListOperations_563787; path: JsonNode; query: JsonNode;
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

proc call*(call_564044: Call_ListOperations_563787; apiVersion: string): Recallable =
  ## listOperations
  ## Lists all of the available Logic REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version.
  var query_564045 = newJObject()
  add(query_564045, "api-version", newJString(apiVersion))
  result = call_564044.call(nil, query_564045, nil, nil, nil)

var listOperations* = Call_ListOperations_563787(name: "listOperations",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Logic/operations",
    validator: validate_ListOperations_563788, base: "", url: url_ListOperations_563789,
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
  Call_WorkflowsListBySubscription_564110 = ref object of OpenApiRestCall_563565
proc url_WorkflowsListBySubscription_564112(protocol: Scheme; host: string;
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

proc validate_WorkflowsListBySubscription_564111(path: JsonNode; query: JsonNode;
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
  ##   $filter: JString
  ##          : The filter to apply on the operation. Options for filters include: State, Trigger, and ReferencedResourceId.
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
  var valid_564116 = query.getOrDefault("$filter")
  valid_564116 = validateParameter(valid_564116, JString, required = false,
                                 default = nil)
  if valid_564116 != nil:
    section.add "$filter", valid_564116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564117: Call_WorkflowsListBySubscription_564110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflows by subscription.
  ## 
  let valid = call_564117.validator(path, query, header, formData, body)
  let scheme = call_564117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564117.url(scheme.get, call_564117.host, call_564117.base,
                         call_564117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564117, url, valid)

proc call*(call_564118: Call_WorkflowsListBySubscription_564110;
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
  var path_564119 = newJObject()
  var query_564120 = newJObject()
  add(query_564120, "api-version", newJString(apiVersion))
  add(query_564120, "$top", newJInt(Top))
  add(path_564119, "subscriptionId", newJString(subscriptionId))
  add(query_564120, "$filter", newJString(Filter))
  result = call_564118.call(path_564119, query_564120, nil, nil, nil)

var workflowsListBySubscription* = Call_WorkflowsListBySubscription_564110(
    name: "workflowsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Logic/workflows",
    validator: validate_WorkflowsListBySubscription_564111, base: "",
    url: url_WorkflowsListBySubscription_564112, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListByResourceGroup_564121 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsListByResourceGroup_564123(protocol: Scheme;
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

proc validate_IntegrationAccountsListByResourceGroup_564122(path: JsonNode;
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
  var valid_564124 = path.getOrDefault("subscriptionId")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "subscriptionId", valid_564124
  var valid_564125 = path.getOrDefault("resourceGroupName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "resourceGroupName", valid_564125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564126 = query.getOrDefault("api-version")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "api-version", valid_564126
  var valid_564127 = query.getOrDefault("$top")
  valid_564127 = validateParameter(valid_564127, JInt, required = false, default = nil)
  if valid_564127 != nil:
    section.add "$top", valid_564127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564128: Call_IntegrationAccountsListByResourceGroup_564121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration accounts by resource group.
  ## 
  let valid = call_564128.validator(path, query, header, formData, body)
  let scheme = call_564128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564128.url(scheme.get, call_564128.host, call_564128.base,
                         call_564128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564128, url, valid)

proc call*(call_564129: Call_IntegrationAccountsListByResourceGroup_564121;
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
  var path_564130 = newJObject()
  var query_564131 = newJObject()
  add(query_564131, "api-version", newJString(apiVersion))
  add(query_564131, "$top", newJInt(Top))
  add(path_564130, "subscriptionId", newJString(subscriptionId))
  add(path_564130, "resourceGroupName", newJString(resourceGroupName))
  result = call_564129.call(path_564130, query_564131, nil, nil, nil)

var integrationAccountsListByResourceGroup* = Call_IntegrationAccountsListByResourceGroup_564121(
    name: "integrationAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts",
    validator: validate_IntegrationAccountsListByResourceGroup_564122, base: "",
    url: url_IntegrationAccountsListByResourceGroup_564123,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountsCreateOrUpdate_564143 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsCreateOrUpdate_564145(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsCreateOrUpdate_564144(path: JsonNode;
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
  var valid_564146 = path.getOrDefault("subscriptionId")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "subscriptionId", valid_564146
  var valid_564147 = path.getOrDefault("resourceGroupName")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "resourceGroupName", valid_564147
  var valid_564148 = path.getOrDefault("integrationAccountName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "integrationAccountName", valid_564148
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564149 = query.getOrDefault("api-version")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "api-version", valid_564149
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

proc call*(call_564151: Call_IntegrationAccountsCreateOrUpdate_564143;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account.
  ## 
  let valid = call_564151.validator(path, query, header, formData, body)
  let scheme = call_564151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564151.url(scheme.get, call_564151.host, call_564151.base,
                         call_564151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564151, url, valid)

proc call*(call_564152: Call_IntegrationAccountsCreateOrUpdate_564143;
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
  var path_564153 = newJObject()
  var query_564154 = newJObject()
  var body_564155 = newJObject()
  add(query_564154, "api-version", newJString(apiVersion))
  add(path_564153, "subscriptionId", newJString(subscriptionId))
  if integrationAccount != nil:
    body_564155 = integrationAccount
  add(path_564153, "resourceGroupName", newJString(resourceGroupName))
  add(path_564153, "integrationAccountName", newJString(integrationAccountName))
  result = call_564152.call(path_564153, query_564154, nil, nil, body_564155)

var integrationAccountsCreateOrUpdate* = Call_IntegrationAccountsCreateOrUpdate_564143(
    name: "integrationAccountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsCreateOrUpdate_564144, base: "",
    url: url_IntegrationAccountsCreateOrUpdate_564145, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsGet_564132 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsGet_564134(protocol: Scheme; host: string; base: string;
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

proc validate_IntegrationAccountsGet_564133(path: JsonNode; query: JsonNode;
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
  var valid_564137 = path.getOrDefault("integrationAccountName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "integrationAccountName", valid_564137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_564139: Call_IntegrationAccountsGet_564132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account.
  ## 
  let valid = call_564139.validator(path, query, header, formData, body)
  let scheme = call_564139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564139.url(scheme.get, call_564139.host, call_564139.base,
                         call_564139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564139, url, valid)

proc call*(call_564140: Call_IntegrationAccountsGet_564132; apiVersion: string;
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
  var path_564141 = newJObject()
  var query_564142 = newJObject()
  add(query_564142, "api-version", newJString(apiVersion))
  add(path_564141, "subscriptionId", newJString(subscriptionId))
  add(path_564141, "resourceGroupName", newJString(resourceGroupName))
  add(path_564141, "integrationAccountName", newJString(integrationAccountName))
  result = call_564140.call(path_564141, query_564142, nil, nil, nil)

var integrationAccountsGet* = Call_IntegrationAccountsGet_564132(
    name: "integrationAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsGet_564133, base: "",
    url: url_IntegrationAccountsGet_564134, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsUpdate_564167 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsUpdate_564169(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsUpdate_564168(path: JsonNode; query: JsonNode;
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
  var valid_564170 = path.getOrDefault("subscriptionId")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "subscriptionId", valid_564170
  var valid_564171 = path.getOrDefault("resourceGroupName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "resourceGroupName", valid_564171
  var valid_564172 = path.getOrDefault("integrationAccountName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "integrationAccountName", valid_564172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564173 = query.getOrDefault("api-version")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "api-version", valid_564173
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

proc call*(call_564175: Call_IntegrationAccountsUpdate_564167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an integration account.
  ## 
  let valid = call_564175.validator(path, query, header, formData, body)
  let scheme = call_564175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564175.url(scheme.get, call_564175.host, call_564175.base,
                         call_564175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564175, url, valid)

proc call*(call_564176: Call_IntegrationAccountsUpdate_564167; apiVersion: string;
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
  var path_564177 = newJObject()
  var query_564178 = newJObject()
  var body_564179 = newJObject()
  add(query_564178, "api-version", newJString(apiVersion))
  add(path_564177, "subscriptionId", newJString(subscriptionId))
  if integrationAccount != nil:
    body_564179 = integrationAccount
  add(path_564177, "resourceGroupName", newJString(resourceGroupName))
  add(path_564177, "integrationAccountName", newJString(integrationAccountName))
  result = call_564176.call(path_564177, query_564178, nil, nil, body_564179)

var integrationAccountsUpdate* = Call_IntegrationAccountsUpdate_564167(
    name: "integrationAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsUpdate_564168, base: "",
    url: url_IntegrationAccountsUpdate_564169, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsDelete_564156 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsDelete_564158(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsDelete_564157(path: JsonNode; query: JsonNode;
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
  var valid_564161 = path.getOrDefault("integrationAccountName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "integrationAccountName", valid_564161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564162 = query.getOrDefault("api-version")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "api-version", valid_564162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564163: Call_IntegrationAccountsDelete_564156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account.
  ## 
  let valid = call_564163.validator(path, query, header, formData, body)
  let scheme = call_564163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564163.url(scheme.get, call_564163.host, call_564163.base,
                         call_564163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564163, url, valid)

proc call*(call_564164: Call_IntegrationAccountsDelete_564156; apiVersion: string;
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
  var path_564165 = newJObject()
  var query_564166 = newJObject()
  add(query_564166, "api-version", newJString(apiVersion))
  add(path_564165, "subscriptionId", newJString(subscriptionId))
  add(path_564165, "resourceGroupName", newJString(resourceGroupName))
  add(path_564165, "integrationAccountName", newJString(integrationAccountName))
  result = call_564164.call(path_564165, query_564166, nil, nil, nil)

var integrationAccountsDelete* = Call_IntegrationAccountsDelete_564156(
    name: "integrationAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsDelete_564157, base: "",
    url: url_IntegrationAccountsDelete_564158, schemes: {Scheme.Https})
type
  Call_AgreementsListByIntegrationAccounts_564180 = ref object of OpenApiRestCall_563565
proc url_AgreementsListByIntegrationAccounts_564182(protocol: Scheme; host: string;
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

proc validate_AgreementsListByIntegrationAccounts_564181(path: JsonNode;
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
  var valid_564185 = path.getOrDefault("integrationAccountName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "integrationAccountName", valid_564185
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
  var valid_564186 = query.getOrDefault("api-version")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "api-version", valid_564186
  var valid_564187 = query.getOrDefault("$top")
  valid_564187 = validateParameter(valid_564187, JInt, required = false, default = nil)
  if valid_564187 != nil:
    section.add "$top", valid_564187
  var valid_564188 = query.getOrDefault("$filter")
  valid_564188 = validateParameter(valid_564188, JString, required = false,
                                 default = nil)
  if valid_564188 != nil:
    section.add "$filter", valid_564188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564189: Call_AgreementsListByIntegrationAccounts_564180;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account agreements.
  ## 
  let valid = call_564189.validator(path, query, header, formData, body)
  let scheme = call_564189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564189.url(scheme.get, call_564189.host, call_564189.base,
                         call_564189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564189, url, valid)

proc call*(call_564190: Call_AgreementsListByIntegrationAccounts_564180;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; Top: int = 0; Filter: string = ""): Recallable =
  ## agreementsListByIntegrationAccounts
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
  var path_564191 = newJObject()
  var query_564192 = newJObject()
  add(query_564192, "api-version", newJString(apiVersion))
  add(query_564192, "$top", newJInt(Top))
  add(path_564191, "subscriptionId", newJString(subscriptionId))
  add(path_564191, "resourceGroupName", newJString(resourceGroupName))
  add(query_564192, "$filter", newJString(Filter))
  add(path_564191, "integrationAccountName", newJString(integrationAccountName))
  result = call_564190.call(path_564191, query_564192, nil, nil, nil)

var agreementsListByIntegrationAccounts* = Call_AgreementsListByIntegrationAccounts_564180(
    name: "agreementsListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements",
    validator: validate_AgreementsListByIntegrationAccounts_564181, base: "",
    url: url_AgreementsListByIntegrationAccounts_564182, schemes: {Scheme.Https})
type
  Call_AgreementsCreateOrUpdate_564205 = ref object of OpenApiRestCall_563565
proc url_AgreementsCreateOrUpdate_564207(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
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
               (kind: VariableSegment, value: "agreementName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AgreementsCreateOrUpdate_564206(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564208 = path.getOrDefault("agreementName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "agreementName", valid_564208
  var valid_564209 = path.getOrDefault("subscriptionId")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "subscriptionId", valid_564209
  var valid_564210 = path.getOrDefault("resourceGroupName")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "resourceGroupName", valid_564210
  var valid_564211 = path.getOrDefault("integrationAccountName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "integrationAccountName", valid_564211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564212 = query.getOrDefault("api-version")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "api-version", valid_564212
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

proc call*(call_564214: Call_AgreementsCreateOrUpdate_564205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account agreement.
  ## 
  let valid = call_564214.validator(path, query, header, formData, body)
  let scheme = call_564214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564214.url(scheme.get, call_564214.host, call_564214.base,
                         call_564214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564214, url, valid)

proc call*(call_564215: Call_AgreementsCreateOrUpdate_564205; apiVersion: string;
          agreement: JsonNode; agreementName: string; subscriptionId: string;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## agreementsCreateOrUpdate
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
  var path_564216 = newJObject()
  var query_564217 = newJObject()
  var body_564218 = newJObject()
  add(query_564217, "api-version", newJString(apiVersion))
  if agreement != nil:
    body_564218 = agreement
  add(path_564216, "agreementName", newJString(agreementName))
  add(path_564216, "subscriptionId", newJString(subscriptionId))
  add(path_564216, "resourceGroupName", newJString(resourceGroupName))
  add(path_564216, "integrationAccountName", newJString(integrationAccountName))
  result = call_564215.call(path_564216, query_564217, nil, nil, body_564218)

var agreementsCreateOrUpdate* = Call_AgreementsCreateOrUpdate_564205(
    name: "agreementsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_AgreementsCreateOrUpdate_564206, base: "",
    url: url_AgreementsCreateOrUpdate_564207, schemes: {Scheme.Https})
type
  Call_AgreementsGet_564193 = ref object of OpenApiRestCall_563565
proc url_AgreementsGet_564195(protocol: Scheme; host: string; base: string;
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

proc validate_AgreementsGet_564194(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564196 = path.getOrDefault("agreementName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "agreementName", valid_564196
  var valid_564197 = path.getOrDefault("subscriptionId")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "subscriptionId", valid_564197
  var valid_564198 = path.getOrDefault("resourceGroupName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "resourceGroupName", valid_564198
  var valid_564199 = path.getOrDefault("integrationAccountName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "integrationAccountName", valid_564199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564200 = query.getOrDefault("api-version")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "api-version", valid_564200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564201: Call_AgreementsGet_564193; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account agreement.
  ## 
  let valid = call_564201.validator(path, query, header, formData, body)
  let scheme = call_564201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564201.url(scheme.get, call_564201.host, call_564201.base,
                         call_564201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564201, url, valid)

proc call*(call_564202: Call_AgreementsGet_564193; apiVersion: string;
          agreementName: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## agreementsGet
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
  var path_564203 = newJObject()
  var query_564204 = newJObject()
  add(query_564204, "api-version", newJString(apiVersion))
  add(path_564203, "agreementName", newJString(agreementName))
  add(path_564203, "subscriptionId", newJString(subscriptionId))
  add(path_564203, "resourceGroupName", newJString(resourceGroupName))
  add(path_564203, "integrationAccountName", newJString(integrationAccountName))
  result = call_564202.call(path_564203, query_564204, nil, nil, nil)

var agreementsGet* = Call_AgreementsGet_564193(name: "agreementsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_AgreementsGet_564194, base: "", url: url_AgreementsGet_564195,
    schemes: {Scheme.Https})
type
  Call_AgreementsDelete_564219 = ref object of OpenApiRestCall_563565
proc url_AgreementsDelete_564221(protocol: Scheme; host: string; base: string;
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

proc validate_AgreementsDelete_564220(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
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
  var valid_564222 = path.getOrDefault("agreementName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "agreementName", valid_564222
  var valid_564223 = path.getOrDefault("subscriptionId")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "subscriptionId", valid_564223
  var valid_564224 = path.getOrDefault("resourceGroupName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "resourceGroupName", valid_564224
  var valid_564225 = path.getOrDefault("integrationAccountName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "integrationAccountName", valid_564225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564226 = query.getOrDefault("api-version")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "api-version", valid_564226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564227: Call_AgreementsDelete_564219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account agreement.
  ## 
  let valid = call_564227.validator(path, query, header, formData, body)
  let scheme = call_564227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564227.url(scheme.get, call_564227.host, call_564227.base,
                         call_564227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564227, url, valid)

proc call*(call_564228: Call_AgreementsDelete_564219; apiVersion: string;
          agreementName: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## agreementsDelete
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
  var path_564229 = newJObject()
  var query_564230 = newJObject()
  add(query_564230, "api-version", newJString(apiVersion))
  add(path_564229, "agreementName", newJString(agreementName))
  add(path_564229, "subscriptionId", newJString(subscriptionId))
  add(path_564229, "resourceGroupName", newJString(resourceGroupName))
  add(path_564229, "integrationAccountName", newJString(integrationAccountName))
  result = call_564228.call(path_564229, query_564230, nil, nil, nil)

var agreementsDelete* = Call_AgreementsDelete_564219(name: "agreementsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_AgreementsDelete_564220, base: "",
    url: url_AgreementsDelete_564221, schemes: {Scheme.Https})
type
  Call_AgreementsListContentCallbackUrl_564231 = ref object of OpenApiRestCall_563565
proc url_AgreementsListContentCallbackUrl_564233(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "agreementName"),
               (kind: ConstantSegment, value: "/listContentCallbackUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AgreementsListContentCallbackUrl_564232(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564234 = path.getOrDefault("agreementName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "agreementName", valid_564234
  var valid_564235 = path.getOrDefault("subscriptionId")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "subscriptionId", valid_564235
  var valid_564236 = path.getOrDefault("resourceGroupName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "resourceGroupName", valid_564236
  var valid_564237 = path.getOrDefault("integrationAccountName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "integrationAccountName", valid_564237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564238 = query.getOrDefault("api-version")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "api-version", valid_564238
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

proc call*(call_564240: Call_AgreementsListContentCallbackUrl_564231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_564240.validator(path, query, header, formData, body)
  let scheme = call_564240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564240.url(scheme.get, call_564240.host, call_564240.base,
                         call_564240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564240, url, valid)

proc call*(call_564241: Call_AgreementsListContentCallbackUrl_564231;
          apiVersion: string; agreementName: string; subscriptionId: string;
          listContentCallbackUrl: JsonNode; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## agreementsListContentCallbackUrl
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
  var path_564242 = newJObject()
  var query_564243 = newJObject()
  var body_564244 = newJObject()
  add(query_564243, "api-version", newJString(apiVersion))
  add(path_564242, "agreementName", newJString(agreementName))
  add(path_564242, "subscriptionId", newJString(subscriptionId))
  if listContentCallbackUrl != nil:
    body_564244 = listContentCallbackUrl
  add(path_564242, "resourceGroupName", newJString(resourceGroupName))
  add(path_564242, "integrationAccountName", newJString(integrationAccountName))
  result = call_564241.call(path_564242, query_564243, nil, nil, body_564244)

var agreementsListContentCallbackUrl* = Call_AgreementsListContentCallbackUrl_564231(
    name: "agreementsListContentCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}/listContentCallbackUrl",
    validator: validate_AgreementsListContentCallbackUrl_564232, base: "",
    url: url_AgreementsListContentCallbackUrl_564233, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesList_564245 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountAssembliesList_564247(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAssembliesList_564246(path: JsonNode;
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
  var valid_564248 = path.getOrDefault("subscriptionId")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "subscriptionId", valid_564248
  var valid_564249 = path.getOrDefault("resourceGroupName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "resourceGroupName", valid_564249
  var valid_564250 = path.getOrDefault("integrationAccountName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "integrationAccountName", valid_564250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564251 = query.getOrDefault("api-version")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "api-version", valid_564251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564252: Call_IntegrationAccountAssembliesList_564245;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the assemblies for an integration account.
  ## 
  let valid = call_564252.validator(path, query, header, formData, body)
  let scheme = call_564252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564252.url(scheme.get, call_564252.host, call_564252.base,
                         call_564252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564252, url, valid)

proc call*(call_564253: Call_IntegrationAccountAssembliesList_564245;
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
  var path_564254 = newJObject()
  var query_564255 = newJObject()
  add(query_564255, "api-version", newJString(apiVersion))
  add(path_564254, "subscriptionId", newJString(subscriptionId))
  add(path_564254, "resourceGroupName", newJString(resourceGroupName))
  add(path_564254, "integrationAccountName", newJString(integrationAccountName))
  result = call_564253.call(path_564254, query_564255, nil, nil, nil)

var integrationAccountAssembliesList* = Call_IntegrationAccountAssembliesList_564245(
    name: "integrationAccountAssembliesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies",
    validator: validate_IntegrationAccountAssembliesList_564246, base: "",
    url: url_IntegrationAccountAssembliesList_564247, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesCreateOrUpdate_564268 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountAssembliesCreateOrUpdate_564270(protocol: Scheme;
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

proc validate_IntegrationAccountAssembliesCreateOrUpdate_564269(path: JsonNode;
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
  var valid_564271 = path.getOrDefault("assemblyArtifactName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "assemblyArtifactName", valid_564271
  var valid_564272 = path.getOrDefault("subscriptionId")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "subscriptionId", valid_564272
  var valid_564273 = path.getOrDefault("resourceGroupName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "resourceGroupName", valid_564273
  var valid_564274 = path.getOrDefault("integrationAccountName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "integrationAccountName", valid_564274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564275 = query.getOrDefault("api-version")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "api-version", valid_564275
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

proc call*(call_564277: Call_IntegrationAccountAssembliesCreateOrUpdate_564268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an assembly for an integration account.
  ## 
  let valid = call_564277.validator(path, query, header, formData, body)
  let scheme = call_564277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564277.url(scheme.get, call_564277.host, call_564277.base,
                         call_564277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564277, url, valid)

proc call*(call_564278: Call_IntegrationAccountAssembliesCreateOrUpdate_564268;
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
  var path_564279 = newJObject()
  var query_564280 = newJObject()
  var body_564281 = newJObject()
  if assemblyArtifact != nil:
    body_564281 = assemblyArtifact
  add(path_564279, "assemblyArtifactName", newJString(assemblyArtifactName))
  add(query_564280, "api-version", newJString(apiVersion))
  add(path_564279, "subscriptionId", newJString(subscriptionId))
  add(path_564279, "resourceGroupName", newJString(resourceGroupName))
  add(path_564279, "integrationAccountName", newJString(integrationAccountName))
  result = call_564278.call(path_564279, query_564280, nil, nil, body_564281)

var integrationAccountAssembliesCreateOrUpdate* = Call_IntegrationAccountAssembliesCreateOrUpdate_564268(
    name: "integrationAccountAssembliesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}",
    validator: validate_IntegrationAccountAssembliesCreateOrUpdate_564269,
    base: "", url: url_IntegrationAccountAssembliesCreateOrUpdate_564270,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesGet_564256 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountAssembliesGet_564258(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAssembliesGet_564257(path: JsonNode;
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
  var valid_564259 = path.getOrDefault("assemblyArtifactName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "assemblyArtifactName", valid_564259
  var valid_564260 = path.getOrDefault("subscriptionId")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "subscriptionId", valid_564260
  var valid_564261 = path.getOrDefault("resourceGroupName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "resourceGroupName", valid_564261
  var valid_564262 = path.getOrDefault("integrationAccountName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "integrationAccountName", valid_564262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564263 = query.getOrDefault("api-version")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "api-version", valid_564263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564264: Call_IntegrationAccountAssembliesGet_564256;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an assembly for an integration account.
  ## 
  let valid = call_564264.validator(path, query, header, formData, body)
  let scheme = call_564264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564264.url(scheme.get, call_564264.host, call_564264.base,
                         call_564264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564264, url, valid)

proc call*(call_564265: Call_IntegrationAccountAssembliesGet_564256;
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
  var path_564266 = newJObject()
  var query_564267 = newJObject()
  add(path_564266, "assemblyArtifactName", newJString(assemblyArtifactName))
  add(query_564267, "api-version", newJString(apiVersion))
  add(path_564266, "subscriptionId", newJString(subscriptionId))
  add(path_564266, "resourceGroupName", newJString(resourceGroupName))
  add(path_564266, "integrationAccountName", newJString(integrationAccountName))
  result = call_564265.call(path_564266, query_564267, nil, nil, nil)

var integrationAccountAssembliesGet* = Call_IntegrationAccountAssembliesGet_564256(
    name: "integrationAccountAssembliesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}",
    validator: validate_IntegrationAccountAssembliesGet_564257, base: "",
    url: url_IntegrationAccountAssembliesGet_564258, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesDelete_564282 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountAssembliesDelete_564284(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAssembliesDelete_564283(path: JsonNode;
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
  var valid_564285 = path.getOrDefault("assemblyArtifactName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "assemblyArtifactName", valid_564285
  var valid_564286 = path.getOrDefault("subscriptionId")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "subscriptionId", valid_564286
  var valid_564287 = path.getOrDefault("resourceGroupName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "resourceGroupName", valid_564287
  var valid_564288 = path.getOrDefault("integrationAccountName")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "integrationAccountName", valid_564288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564289 = query.getOrDefault("api-version")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "api-version", valid_564289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564290: Call_IntegrationAccountAssembliesDelete_564282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an assembly for an integration account.
  ## 
  let valid = call_564290.validator(path, query, header, formData, body)
  let scheme = call_564290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564290.url(scheme.get, call_564290.host, call_564290.base,
                         call_564290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564290, url, valid)

proc call*(call_564291: Call_IntegrationAccountAssembliesDelete_564282;
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
  var path_564292 = newJObject()
  var query_564293 = newJObject()
  add(path_564292, "assemblyArtifactName", newJString(assemblyArtifactName))
  add(query_564293, "api-version", newJString(apiVersion))
  add(path_564292, "subscriptionId", newJString(subscriptionId))
  add(path_564292, "resourceGroupName", newJString(resourceGroupName))
  add(path_564292, "integrationAccountName", newJString(integrationAccountName))
  result = call_564291.call(path_564292, query_564293, nil, nil, nil)

var integrationAccountAssembliesDelete* = Call_IntegrationAccountAssembliesDelete_564282(
    name: "integrationAccountAssembliesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}",
    validator: validate_IntegrationAccountAssembliesDelete_564283, base: "",
    url: url_IntegrationAccountAssembliesDelete_564284, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesListContentCallbackUrl_564294 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountAssembliesListContentCallbackUrl_564296(
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

proc validate_IntegrationAccountAssembliesListContentCallbackUrl_564295(
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
  var valid_564297 = path.getOrDefault("assemblyArtifactName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "assemblyArtifactName", valid_564297
  var valid_564298 = path.getOrDefault("subscriptionId")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "subscriptionId", valid_564298
  var valid_564299 = path.getOrDefault("resourceGroupName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "resourceGroupName", valid_564299
  var valid_564300 = path.getOrDefault("integrationAccountName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "integrationAccountName", valid_564300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564301 = query.getOrDefault("api-version")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "api-version", valid_564301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564302: Call_IntegrationAccountAssembliesListContentCallbackUrl_564294;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url for an integration account assembly.
  ## 
  let valid = call_564302.validator(path, query, header, formData, body)
  let scheme = call_564302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564302.url(scheme.get, call_564302.host, call_564302.base,
                         call_564302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564302, url, valid)

proc call*(call_564303: Call_IntegrationAccountAssembliesListContentCallbackUrl_564294;
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
  var path_564304 = newJObject()
  var query_564305 = newJObject()
  add(path_564304, "assemblyArtifactName", newJString(assemblyArtifactName))
  add(query_564305, "api-version", newJString(apiVersion))
  add(path_564304, "subscriptionId", newJString(subscriptionId))
  add(path_564304, "resourceGroupName", newJString(resourceGroupName))
  add(path_564304, "integrationAccountName", newJString(integrationAccountName))
  result = call_564303.call(path_564304, query_564305, nil, nil, nil)

var integrationAccountAssembliesListContentCallbackUrl* = Call_IntegrationAccountAssembliesListContentCallbackUrl_564294(
    name: "integrationAccountAssembliesListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountAssembliesListContentCallbackUrl_564295,
    base: "", url: url_IntegrationAccountAssembliesListContentCallbackUrl_564296,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsList_564306 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountBatchConfigurationsList_564308(protocol: Scheme;
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

proc validate_IntegrationAccountBatchConfigurationsList_564307(path: JsonNode;
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
  var valid_564309 = path.getOrDefault("subscriptionId")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "subscriptionId", valid_564309
  var valid_564310 = path.getOrDefault("resourceGroupName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "resourceGroupName", valid_564310
  var valid_564311 = path.getOrDefault("integrationAccountName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "integrationAccountName", valid_564311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564312 = query.getOrDefault("api-version")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "api-version", valid_564312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564313: Call_IntegrationAccountBatchConfigurationsList_564306;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the batch configurations for an integration account.
  ## 
  let valid = call_564313.validator(path, query, header, formData, body)
  let scheme = call_564313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564313.url(scheme.get, call_564313.host, call_564313.base,
                         call_564313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564313, url, valid)

proc call*(call_564314: Call_IntegrationAccountBatchConfigurationsList_564306;
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
  var path_564315 = newJObject()
  var query_564316 = newJObject()
  add(query_564316, "api-version", newJString(apiVersion))
  add(path_564315, "subscriptionId", newJString(subscriptionId))
  add(path_564315, "resourceGroupName", newJString(resourceGroupName))
  add(path_564315, "integrationAccountName", newJString(integrationAccountName))
  result = call_564314.call(path_564315, query_564316, nil, nil, nil)

var integrationAccountBatchConfigurationsList* = Call_IntegrationAccountBatchConfigurationsList_564306(
    name: "integrationAccountBatchConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations",
    validator: validate_IntegrationAccountBatchConfigurationsList_564307,
    base: "", url: url_IntegrationAccountBatchConfigurationsList_564308,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_564329 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountBatchConfigurationsCreateOrUpdate_564331(
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

proc validate_IntegrationAccountBatchConfigurationsCreateOrUpdate_564330(
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
  var valid_564332 = path.getOrDefault("batchConfigurationName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "batchConfigurationName", valid_564332
  var valid_564333 = path.getOrDefault("subscriptionId")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "subscriptionId", valid_564333
  var valid_564334 = path.getOrDefault("resourceGroupName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "resourceGroupName", valid_564334
  var valid_564335 = path.getOrDefault("integrationAccountName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "integrationAccountName", valid_564335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564336 = query.getOrDefault("api-version")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "api-version", valid_564336
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

proc call*(call_564338: Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_564329;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a batch configuration for an integration account.
  ## 
  let valid = call_564338.validator(path, query, header, formData, body)
  let scheme = call_564338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564338.url(scheme.get, call_564338.host, call_564338.base,
                         call_564338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564338, url, valid)

proc call*(call_564339: Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_564329;
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
  var path_564340 = newJObject()
  var query_564341 = newJObject()
  var body_564342 = newJObject()
  add(query_564341, "api-version", newJString(apiVersion))
  add(path_564340, "batchConfigurationName", newJString(batchConfigurationName))
  add(path_564340, "subscriptionId", newJString(subscriptionId))
  add(path_564340, "resourceGroupName", newJString(resourceGroupName))
  add(path_564340, "integrationAccountName", newJString(integrationAccountName))
  if batchConfiguration != nil:
    body_564342 = batchConfiguration
  result = call_564339.call(path_564340, query_564341, nil, nil, body_564342)

var integrationAccountBatchConfigurationsCreateOrUpdate* = Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_564329(
    name: "integrationAccountBatchConfigurationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations/{batchConfigurationName}",
    validator: validate_IntegrationAccountBatchConfigurationsCreateOrUpdate_564330,
    base: "", url: url_IntegrationAccountBatchConfigurationsCreateOrUpdate_564331,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsGet_564317 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountBatchConfigurationsGet_564319(protocol: Scheme;
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

proc validate_IntegrationAccountBatchConfigurationsGet_564318(path: JsonNode;
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
  var valid_564320 = path.getOrDefault("batchConfigurationName")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "batchConfigurationName", valid_564320
  var valid_564321 = path.getOrDefault("subscriptionId")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "subscriptionId", valid_564321
  var valid_564322 = path.getOrDefault("resourceGroupName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "resourceGroupName", valid_564322
  var valid_564323 = path.getOrDefault("integrationAccountName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "integrationAccountName", valid_564323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564324 = query.getOrDefault("api-version")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "api-version", valid_564324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564325: Call_IntegrationAccountBatchConfigurationsGet_564317;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a batch configuration for an integration account.
  ## 
  let valid = call_564325.validator(path, query, header, formData, body)
  let scheme = call_564325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564325.url(scheme.get, call_564325.host, call_564325.base,
                         call_564325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564325, url, valid)

proc call*(call_564326: Call_IntegrationAccountBatchConfigurationsGet_564317;
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
  var path_564327 = newJObject()
  var query_564328 = newJObject()
  add(query_564328, "api-version", newJString(apiVersion))
  add(path_564327, "batchConfigurationName", newJString(batchConfigurationName))
  add(path_564327, "subscriptionId", newJString(subscriptionId))
  add(path_564327, "resourceGroupName", newJString(resourceGroupName))
  add(path_564327, "integrationAccountName", newJString(integrationAccountName))
  result = call_564326.call(path_564327, query_564328, nil, nil, nil)

var integrationAccountBatchConfigurationsGet* = Call_IntegrationAccountBatchConfigurationsGet_564317(
    name: "integrationAccountBatchConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations/{batchConfigurationName}",
    validator: validate_IntegrationAccountBatchConfigurationsGet_564318, base: "",
    url: url_IntegrationAccountBatchConfigurationsGet_564319,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsDelete_564343 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountBatchConfigurationsDelete_564345(protocol: Scheme;
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

proc validate_IntegrationAccountBatchConfigurationsDelete_564344(path: JsonNode;
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
  var valid_564346 = path.getOrDefault("batchConfigurationName")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "batchConfigurationName", valid_564346
  var valid_564347 = path.getOrDefault("subscriptionId")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "subscriptionId", valid_564347
  var valid_564348 = path.getOrDefault("resourceGroupName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "resourceGroupName", valid_564348
  var valid_564349 = path.getOrDefault("integrationAccountName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "integrationAccountName", valid_564349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564350 = query.getOrDefault("api-version")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "api-version", valid_564350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564351: Call_IntegrationAccountBatchConfigurationsDelete_564343;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a batch configuration for an integration account.
  ## 
  let valid = call_564351.validator(path, query, header, formData, body)
  let scheme = call_564351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564351.url(scheme.get, call_564351.host, call_564351.base,
                         call_564351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564351, url, valid)

proc call*(call_564352: Call_IntegrationAccountBatchConfigurationsDelete_564343;
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
  var path_564353 = newJObject()
  var query_564354 = newJObject()
  add(query_564354, "api-version", newJString(apiVersion))
  add(path_564353, "batchConfigurationName", newJString(batchConfigurationName))
  add(path_564353, "subscriptionId", newJString(subscriptionId))
  add(path_564353, "resourceGroupName", newJString(resourceGroupName))
  add(path_564353, "integrationAccountName", newJString(integrationAccountName))
  result = call_564352.call(path_564353, query_564354, nil, nil, nil)

var integrationAccountBatchConfigurationsDelete* = Call_IntegrationAccountBatchConfigurationsDelete_564343(
    name: "integrationAccountBatchConfigurationsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations/{batchConfigurationName}",
    validator: validate_IntegrationAccountBatchConfigurationsDelete_564344,
    base: "", url: url_IntegrationAccountBatchConfigurationsDelete_564345,
    schemes: {Scheme.Https})
type
  Call_CertificatesListByIntegrationAccounts_564355 = ref object of OpenApiRestCall_563565
proc url_CertificatesListByIntegrationAccounts_564357(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/certificates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesListByIntegrationAccounts_564356(path: JsonNode;
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
  var valid_564358 = path.getOrDefault("subscriptionId")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "subscriptionId", valid_564358
  var valid_564359 = path.getOrDefault("resourceGroupName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "resourceGroupName", valid_564359
  var valid_564360 = path.getOrDefault("integrationAccountName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "integrationAccountName", valid_564360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564361 = query.getOrDefault("api-version")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "api-version", valid_564361
  var valid_564362 = query.getOrDefault("$top")
  valid_564362 = validateParameter(valid_564362, JInt, required = false, default = nil)
  if valid_564362 != nil:
    section.add "$top", valid_564362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564363: Call_CertificatesListByIntegrationAccounts_564355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account certificates.
  ## 
  let valid = call_564363.validator(path, query, header, formData, body)
  let scheme = call_564363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564363.url(scheme.get, call_564363.host, call_564363.base,
                         call_564363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564363, url, valid)

proc call*(call_564364: Call_CertificatesListByIntegrationAccounts_564355;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; Top: int = 0): Recallable =
  ## certificatesListByIntegrationAccounts
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
  var path_564365 = newJObject()
  var query_564366 = newJObject()
  add(query_564366, "api-version", newJString(apiVersion))
  add(query_564366, "$top", newJInt(Top))
  add(path_564365, "subscriptionId", newJString(subscriptionId))
  add(path_564365, "resourceGroupName", newJString(resourceGroupName))
  add(path_564365, "integrationAccountName", newJString(integrationAccountName))
  result = call_564364.call(path_564365, query_564366, nil, nil, nil)

var certificatesListByIntegrationAccounts* = Call_CertificatesListByIntegrationAccounts_564355(
    name: "certificatesListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates",
    validator: validate_CertificatesListByIntegrationAccounts_564356, base: "",
    url: url_CertificatesListByIntegrationAccounts_564357, schemes: {Scheme.Https})
type
  Call_CertificatesCreateOrUpdate_564379 = ref object of OpenApiRestCall_563565
proc url_CertificatesCreateOrUpdate_564381(protocol: Scheme; host: string;
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

proc validate_CertificatesCreateOrUpdate_564380(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564382 = path.getOrDefault("subscriptionId")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "subscriptionId", valid_564382
  var valid_564383 = path.getOrDefault("resourceGroupName")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "resourceGroupName", valid_564383
  var valid_564384 = path.getOrDefault("integrationAccountName")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "integrationAccountName", valid_564384
  var valid_564385 = path.getOrDefault("certificateName")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "certificateName", valid_564385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564386 = query.getOrDefault("api-version")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "api-version", valid_564386
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

proc call*(call_564388: Call_CertificatesCreateOrUpdate_564379; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account certificate.
  ## 
  let valid = call_564388.validator(path, query, header, formData, body)
  let scheme = call_564388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564388.url(scheme.get, call_564388.host, call_564388.base,
                         call_564388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564388, url, valid)

proc call*(call_564389: Call_CertificatesCreateOrUpdate_564379; apiVersion: string;
          certificate: JsonNode; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; certificateName: string): Recallable =
  ## certificatesCreateOrUpdate
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
  var path_564390 = newJObject()
  var query_564391 = newJObject()
  var body_564392 = newJObject()
  add(query_564391, "api-version", newJString(apiVersion))
  if certificate != nil:
    body_564392 = certificate
  add(path_564390, "subscriptionId", newJString(subscriptionId))
  add(path_564390, "resourceGroupName", newJString(resourceGroupName))
  add(path_564390, "integrationAccountName", newJString(integrationAccountName))
  add(path_564390, "certificateName", newJString(certificateName))
  result = call_564389.call(path_564390, query_564391, nil, nil, body_564392)

var certificatesCreateOrUpdate* = Call_CertificatesCreateOrUpdate_564379(
    name: "certificatesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_CertificatesCreateOrUpdate_564380, base: "",
    url: url_CertificatesCreateOrUpdate_564381, schemes: {Scheme.Https})
type
  Call_CertificatesGet_564367 = ref object of OpenApiRestCall_563565
proc url_CertificatesGet_564369(protocol: Scheme; host: string; base: string;
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

proc validate_CertificatesGet_564368(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
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
  var valid_564370 = path.getOrDefault("subscriptionId")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "subscriptionId", valid_564370
  var valid_564371 = path.getOrDefault("resourceGroupName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "resourceGroupName", valid_564371
  var valid_564372 = path.getOrDefault("integrationAccountName")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "integrationAccountName", valid_564372
  var valid_564373 = path.getOrDefault("certificateName")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "certificateName", valid_564373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564374 = query.getOrDefault("api-version")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "api-version", valid_564374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564375: Call_CertificatesGet_564367; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account certificate.
  ## 
  let valid = call_564375.validator(path, query, header, formData, body)
  let scheme = call_564375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564375.url(scheme.get, call_564375.host, call_564375.base,
                         call_564375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564375, url, valid)

proc call*(call_564376: Call_CertificatesGet_564367; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; certificateName: string): Recallable =
  ## certificatesGet
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
  var path_564377 = newJObject()
  var query_564378 = newJObject()
  add(query_564378, "api-version", newJString(apiVersion))
  add(path_564377, "subscriptionId", newJString(subscriptionId))
  add(path_564377, "resourceGroupName", newJString(resourceGroupName))
  add(path_564377, "integrationAccountName", newJString(integrationAccountName))
  add(path_564377, "certificateName", newJString(certificateName))
  result = call_564376.call(path_564377, query_564378, nil, nil, nil)

var certificatesGet* = Call_CertificatesGet_564367(name: "certificatesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_CertificatesGet_564368, base: "", url: url_CertificatesGet_564369,
    schemes: {Scheme.Https})
type
  Call_CertificatesDelete_564393 = ref object of OpenApiRestCall_563565
proc url_CertificatesDelete_564395(protocol: Scheme; host: string; base: string;
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

proc validate_CertificatesDelete_564394(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
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
  var valid_564396 = path.getOrDefault("subscriptionId")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "subscriptionId", valid_564396
  var valid_564397 = path.getOrDefault("resourceGroupName")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "resourceGroupName", valid_564397
  var valid_564398 = path.getOrDefault("integrationAccountName")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "integrationAccountName", valid_564398
  var valid_564399 = path.getOrDefault("certificateName")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "certificateName", valid_564399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564400 = query.getOrDefault("api-version")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "api-version", valid_564400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564401: Call_CertificatesDelete_564393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account certificate.
  ## 
  let valid = call_564401.validator(path, query, header, formData, body)
  let scheme = call_564401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564401.url(scheme.get, call_564401.host, call_564401.base,
                         call_564401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564401, url, valid)

proc call*(call_564402: Call_CertificatesDelete_564393; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; certificateName: string): Recallable =
  ## certificatesDelete
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
  var path_564403 = newJObject()
  var query_564404 = newJObject()
  add(query_564404, "api-version", newJString(apiVersion))
  add(path_564403, "subscriptionId", newJString(subscriptionId))
  add(path_564403, "resourceGroupName", newJString(resourceGroupName))
  add(path_564403, "integrationAccountName", newJString(integrationAccountName))
  add(path_564403, "certificateName", newJString(certificateName))
  result = call_564402.call(path_564403, query_564404, nil, nil, nil)

var certificatesDelete* = Call_CertificatesDelete_564393(
    name: "certificatesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_CertificatesDelete_564394, base: "",
    url: url_CertificatesDelete_564395, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsGetCallbackUrl_564405 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsGetCallbackUrl_564407(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsGetCallbackUrl_564406(path: JsonNode;
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
  var valid_564408 = path.getOrDefault("subscriptionId")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "subscriptionId", valid_564408
  var valid_564409 = path.getOrDefault("resourceGroupName")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "resourceGroupName", valid_564409
  var valid_564410 = path.getOrDefault("integrationAccountName")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "integrationAccountName", valid_564410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564411 = query.getOrDefault("api-version")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "api-version", valid_564411
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

proc call*(call_564413: Call_IntegrationAccountsGetCallbackUrl_564405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the integration account callback URL.
  ## 
  let valid = call_564413.validator(path, query, header, formData, body)
  let scheme = call_564413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564413.url(scheme.get, call_564413.host, call_564413.base,
                         call_564413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564413, url, valid)

proc call*(call_564414: Call_IntegrationAccountsGetCallbackUrl_564405;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode; integrationAccountName: string): Recallable =
  ## integrationAccountsGetCallbackUrl
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
  var path_564415 = newJObject()
  var query_564416 = newJObject()
  var body_564417 = newJObject()
  add(query_564416, "api-version", newJString(apiVersion))
  add(path_564415, "subscriptionId", newJString(subscriptionId))
  add(path_564415, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564417 = parameters
  add(path_564415, "integrationAccountName", newJString(integrationAccountName))
  result = call_564414.call(path_564415, query_564416, nil, nil, body_564417)

var integrationAccountsGetCallbackUrl* = Call_IntegrationAccountsGetCallbackUrl_564405(
    name: "integrationAccountsGetCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/listCallbackUrl",
    validator: validate_IntegrationAccountsGetCallbackUrl_564406, base: "",
    url: url_IntegrationAccountsGetCallbackUrl_564407, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListKeyVaultKeys_564418 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsListKeyVaultKeys_564420(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsListKeyVaultKeys_564419(path: JsonNode;
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
  var valid_564421 = path.getOrDefault("subscriptionId")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "subscriptionId", valid_564421
  var valid_564422 = path.getOrDefault("resourceGroupName")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "resourceGroupName", valid_564422
  var valid_564423 = path.getOrDefault("integrationAccountName")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "integrationAccountName", valid_564423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564424 = query.getOrDefault("api-version")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "api-version", valid_564424
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

proc call*(call_564426: Call_IntegrationAccountsListKeyVaultKeys_564418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the integration account's Key Vault keys.
  ## 
  let valid = call_564426.validator(path, query, header, formData, body)
  let scheme = call_564426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564426.url(scheme.get, call_564426.host, call_564426.base,
                         call_564426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564426, url, valid)

proc call*(call_564427: Call_IntegrationAccountsListKeyVaultKeys_564418;
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
  var path_564428 = newJObject()
  var query_564429 = newJObject()
  var body_564430 = newJObject()
  add(query_564429, "api-version", newJString(apiVersion))
  add(path_564428, "subscriptionId", newJString(subscriptionId))
  if listKeyVaultKeys != nil:
    body_564430 = listKeyVaultKeys
  add(path_564428, "resourceGroupName", newJString(resourceGroupName))
  add(path_564428, "integrationAccountName", newJString(integrationAccountName))
  result = call_564427.call(path_564428, query_564429, nil, nil, body_564430)

var integrationAccountsListKeyVaultKeys* = Call_IntegrationAccountsListKeyVaultKeys_564418(
    name: "integrationAccountsListKeyVaultKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/listKeyVaultKeys",
    validator: validate_IntegrationAccountsListKeyVaultKeys_564419, base: "",
    url: url_IntegrationAccountsListKeyVaultKeys_564420, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsLogTrackingEvents_564431 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsLogTrackingEvents_564433(protocol: Scheme;
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

proc validate_IntegrationAccountsLogTrackingEvents_564432(path: JsonNode;
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
  var valid_564434 = path.getOrDefault("subscriptionId")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "subscriptionId", valid_564434
  var valid_564435 = path.getOrDefault("resourceGroupName")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "resourceGroupName", valid_564435
  var valid_564436 = path.getOrDefault("integrationAccountName")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "integrationAccountName", valid_564436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564437 = query.getOrDefault("api-version")
  valid_564437 = validateParameter(valid_564437, JString, required = true,
                                 default = nil)
  if valid_564437 != nil:
    section.add "api-version", valid_564437
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

proc call*(call_564439: Call_IntegrationAccountsLogTrackingEvents_564431;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Logs the integration account's tracking events.
  ## 
  let valid = call_564439.validator(path, query, header, formData, body)
  let scheme = call_564439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564439.url(scheme.get, call_564439.host, call_564439.base,
                         call_564439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564439, url, valid)

proc call*(call_564440: Call_IntegrationAccountsLogTrackingEvents_564431;
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
  var path_564441 = newJObject()
  var query_564442 = newJObject()
  var body_564443 = newJObject()
  add(query_564442, "api-version", newJString(apiVersion))
  if logTrackingEvents != nil:
    body_564443 = logTrackingEvents
  add(path_564441, "subscriptionId", newJString(subscriptionId))
  add(path_564441, "resourceGroupName", newJString(resourceGroupName))
  add(path_564441, "integrationAccountName", newJString(integrationAccountName))
  result = call_564440.call(path_564441, query_564442, nil, nil, body_564443)

var integrationAccountsLogTrackingEvents* = Call_IntegrationAccountsLogTrackingEvents_564431(
    name: "integrationAccountsLogTrackingEvents", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/logTrackingEvents",
    validator: validate_IntegrationAccountsLogTrackingEvents_564432, base: "",
    url: url_IntegrationAccountsLogTrackingEvents_564433, schemes: {Scheme.Https})
type
  Call_MapsListByIntegrationAccounts_564444 = ref object of OpenApiRestCall_563565
proc url_MapsListByIntegrationAccounts_564446(protocol: Scheme; host: string;
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

proc validate_MapsListByIntegrationAccounts_564445(path: JsonNode; query: JsonNode;
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
  var valid_564447 = path.getOrDefault("subscriptionId")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "subscriptionId", valid_564447
  var valid_564448 = path.getOrDefault("resourceGroupName")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "resourceGroupName", valid_564448
  var valid_564449 = path.getOrDefault("integrationAccountName")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "integrationAccountName", valid_564449
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
  var valid_564450 = query.getOrDefault("api-version")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "api-version", valid_564450
  var valid_564451 = query.getOrDefault("$top")
  valid_564451 = validateParameter(valid_564451, JInt, required = false, default = nil)
  if valid_564451 != nil:
    section.add "$top", valid_564451
  var valid_564452 = query.getOrDefault("$filter")
  valid_564452 = validateParameter(valid_564452, JString, required = false,
                                 default = nil)
  if valid_564452 != nil:
    section.add "$filter", valid_564452
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564453: Call_MapsListByIntegrationAccounts_564444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account maps.
  ## 
  let valid = call_564453.validator(path, query, header, formData, body)
  let scheme = call_564453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564453.url(scheme.get, call_564453.host, call_564453.base,
                         call_564453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564453, url, valid)

proc call*(call_564454: Call_MapsListByIntegrationAccounts_564444;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; Top: int = 0; Filter: string = ""): Recallable =
  ## mapsListByIntegrationAccounts
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
  var path_564455 = newJObject()
  var query_564456 = newJObject()
  add(query_564456, "api-version", newJString(apiVersion))
  add(query_564456, "$top", newJInt(Top))
  add(path_564455, "subscriptionId", newJString(subscriptionId))
  add(path_564455, "resourceGroupName", newJString(resourceGroupName))
  add(query_564456, "$filter", newJString(Filter))
  add(path_564455, "integrationAccountName", newJString(integrationAccountName))
  result = call_564454.call(path_564455, query_564456, nil, nil, nil)

var mapsListByIntegrationAccounts* = Call_MapsListByIntegrationAccounts_564444(
    name: "mapsListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps",
    validator: validate_MapsListByIntegrationAccounts_564445, base: "",
    url: url_MapsListByIntegrationAccounts_564446, schemes: {Scheme.Https})
type
  Call_MapsCreateOrUpdate_564469 = ref object of OpenApiRestCall_563565
proc url_MapsCreateOrUpdate_564471(protocol: Scheme; host: string; base: string;
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

proc validate_MapsCreateOrUpdate_564470(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
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
  var valid_564472 = path.getOrDefault("mapName")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "mapName", valid_564472
  var valid_564473 = path.getOrDefault("subscriptionId")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "subscriptionId", valid_564473
  var valid_564474 = path.getOrDefault("resourceGroupName")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "resourceGroupName", valid_564474
  var valid_564475 = path.getOrDefault("integrationAccountName")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = nil)
  if valid_564475 != nil:
    section.add "integrationAccountName", valid_564475
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564476 = query.getOrDefault("api-version")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = nil)
  if valid_564476 != nil:
    section.add "api-version", valid_564476
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

proc call*(call_564478: Call_MapsCreateOrUpdate_564469; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account map.
  ## 
  let valid = call_564478.validator(path, query, header, formData, body)
  let scheme = call_564478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564478.url(scheme.get, call_564478.host, call_564478.base,
                         call_564478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564478, url, valid)

proc call*(call_564479: Call_MapsCreateOrUpdate_564469; map: JsonNode;
          apiVersion: string; mapName: string; subscriptionId: string;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## mapsCreateOrUpdate
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
  var path_564480 = newJObject()
  var query_564481 = newJObject()
  var body_564482 = newJObject()
  if map != nil:
    body_564482 = map
  add(query_564481, "api-version", newJString(apiVersion))
  add(path_564480, "mapName", newJString(mapName))
  add(path_564480, "subscriptionId", newJString(subscriptionId))
  add(path_564480, "resourceGroupName", newJString(resourceGroupName))
  add(path_564480, "integrationAccountName", newJString(integrationAccountName))
  result = call_564479.call(path_564480, query_564481, nil, nil, body_564482)

var mapsCreateOrUpdate* = Call_MapsCreateOrUpdate_564469(
    name: "mapsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_MapsCreateOrUpdate_564470, base: "",
    url: url_MapsCreateOrUpdate_564471, schemes: {Scheme.Https})
type
  Call_MapsGet_564457 = ref object of OpenApiRestCall_563565
proc url_MapsGet_564459(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
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

proc validate_MapsGet_564458(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564460 = path.getOrDefault("mapName")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "mapName", valid_564460
  var valid_564461 = path.getOrDefault("subscriptionId")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = nil)
  if valid_564461 != nil:
    section.add "subscriptionId", valid_564461
  var valid_564462 = path.getOrDefault("resourceGroupName")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "resourceGroupName", valid_564462
  var valid_564463 = path.getOrDefault("integrationAccountName")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "integrationAccountName", valid_564463
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564464 = query.getOrDefault("api-version")
  valid_564464 = validateParameter(valid_564464, JString, required = true,
                                 default = nil)
  if valid_564464 != nil:
    section.add "api-version", valid_564464
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564465: Call_MapsGet_564457; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account map.
  ## 
  let valid = call_564465.validator(path, query, header, formData, body)
  let scheme = call_564465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564465.url(scheme.get, call_564465.host, call_564465.base,
                         call_564465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564465, url, valid)

proc call*(call_564466: Call_MapsGet_564457; apiVersion: string; mapName: string;
          subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## mapsGet
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
  var path_564467 = newJObject()
  var query_564468 = newJObject()
  add(query_564468, "api-version", newJString(apiVersion))
  add(path_564467, "mapName", newJString(mapName))
  add(path_564467, "subscriptionId", newJString(subscriptionId))
  add(path_564467, "resourceGroupName", newJString(resourceGroupName))
  add(path_564467, "integrationAccountName", newJString(integrationAccountName))
  result = call_564466.call(path_564467, query_564468, nil, nil, nil)

var mapsGet* = Call_MapsGet_564457(name: "mapsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
                                validator: validate_MapsGet_564458, base: "",
                                url: url_MapsGet_564459, schemes: {Scheme.Https})
type
  Call_MapsDelete_564483 = ref object of OpenApiRestCall_563565
proc url_MapsDelete_564485(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
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

proc validate_MapsDelete_564484(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564486 = path.getOrDefault("mapName")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "mapName", valid_564486
  var valid_564487 = path.getOrDefault("subscriptionId")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "subscriptionId", valid_564487
  var valid_564488 = path.getOrDefault("resourceGroupName")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "resourceGroupName", valid_564488
  var valid_564489 = path.getOrDefault("integrationAccountName")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = nil)
  if valid_564489 != nil:
    section.add "integrationAccountName", valid_564489
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564490 = query.getOrDefault("api-version")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "api-version", valid_564490
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564491: Call_MapsDelete_564483; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account map.
  ## 
  let valid = call_564491.validator(path, query, header, formData, body)
  let scheme = call_564491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564491.url(scheme.get, call_564491.host, call_564491.base,
                         call_564491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564491, url, valid)

proc call*(call_564492: Call_MapsDelete_564483; apiVersion: string; mapName: string;
          subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## mapsDelete
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
  var path_564493 = newJObject()
  var query_564494 = newJObject()
  add(query_564494, "api-version", newJString(apiVersion))
  add(path_564493, "mapName", newJString(mapName))
  add(path_564493, "subscriptionId", newJString(subscriptionId))
  add(path_564493, "resourceGroupName", newJString(resourceGroupName))
  add(path_564493, "integrationAccountName", newJString(integrationAccountName))
  result = call_564492.call(path_564493, query_564494, nil, nil, nil)

var mapsDelete* = Call_MapsDelete_564483(name: "mapsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
                                      validator: validate_MapsDelete_564484,
                                      base: "", url: url_MapsDelete_564485,
                                      schemes: {Scheme.Https})
type
  Call_MapsListContentCallbackUrl_564495 = ref object of OpenApiRestCall_563565
proc url_MapsListContentCallbackUrl_564497(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "mapName"),
               (kind: ConstantSegment, value: "/listContentCallbackUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MapsListContentCallbackUrl_564496(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564498 = path.getOrDefault("mapName")
  valid_564498 = validateParameter(valid_564498, JString, required = true,
                                 default = nil)
  if valid_564498 != nil:
    section.add "mapName", valid_564498
  var valid_564499 = path.getOrDefault("subscriptionId")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "subscriptionId", valid_564499
  var valid_564500 = path.getOrDefault("resourceGroupName")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "resourceGroupName", valid_564500
  var valid_564501 = path.getOrDefault("integrationAccountName")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "integrationAccountName", valid_564501
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564502 = query.getOrDefault("api-version")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "api-version", valid_564502
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

proc call*(call_564504: Call_MapsListContentCallbackUrl_564495; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_564504.validator(path, query, header, formData, body)
  let scheme = call_564504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564504.url(scheme.get, call_564504.host, call_564504.base,
                         call_564504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564504, url, valid)

proc call*(call_564505: Call_MapsListContentCallbackUrl_564495; apiVersion: string;
          mapName: string; subscriptionId: string; listContentCallbackUrl: JsonNode;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## mapsListContentCallbackUrl
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
  var path_564506 = newJObject()
  var query_564507 = newJObject()
  var body_564508 = newJObject()
  add(query_564507, "api-version", newJString(apiVersion))
  add(path_564506, "mapName", newJString(mapName))
  add(path_564506, "subscriptionId", newJString(subscriptionId))
  if listContentCallbackUrl != nil:
    body_564508 = listContentCallbackUrl
  add(path_564506, "resourceGroupName", newJString(resourceGroupName))
  add(path_564506, "integrationAccountName", newJString(integrationAccountName))
  result = call_564505.call(path_564506, query_564507, nil, nil, body_564508)

var mapsListContentCallbackUrl* = Call_MapsListContentCallbackUrl_564495(
    name: "mapsListContentCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}/listContentCallbackUrl",
    validator: validate_MapsListContentCallbackUrl_564496, base: "",
    url: url_MapsListContentCallbackUrl_564497, schemes: {Scheme.Https})
type
  Call_PartnersListByIntegrationAccounts_564509 = ref object of OpenApiRestCall_563565
proc url_PartnersListByIntegrationAccounts_564511(protocol: Scheme; host: string;
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

proc validate_PartnersListByIntegrationAccounts_564510(path: JsonNode;
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
  var valid_564512 = path.getOrDefault("subscriptionId")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "subscriptionId", valid_564512
  var valid_564513 = path.getOrDefault("resourceGroupName")
  valid_564513 = validateParameter(valid_564513, JString, required = true,
                                 default = nil)
  if valid_564513 != nil:
    section.add "resourceGroupName", valid_564513
  var valid_564514 = path.getOrDefault("integrationAccountName")
  valid_564514 = validateParameter(valid_564514, JString, required = true,
                                 default = nil)
  if valid_564514 != nil:
    section.add "integrationAccountName", valid_564514
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
  var valid_564515 = query.getOrDefault("api-version")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "api-version", valid_564515
  var valid_564516 = query.getOrDefault("$top")
  valid_564516 = validateParameter(valid_564516, JInt, required = false, default = nil)
  if valid_564516 != nil:
    section.add "$top", valid_564516
  var valid_564517 = query.getOrDefault("$filter")
  valid_564517 = validateParameter(valid_564517, JString, required = false,
                                 default = nil)
  if valid_564517 != nil:
    section.add "$filter", valid_564517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564518: Call_PartnersListByIntegrationAccounts_564509;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account partners.
  ## 
  let valid = call_564518.validator(path, query, header, formData, body)
  let scheme = call_564518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564518.url(scheme.get, call_564518.host, call_564518.base,
                         call_564518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564518, url, valid)

proc call*(call_564519: Call_PartnersListByIntegrationAccounts_564509;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; Top: int = 0; Filter: string = ""): Recallable =
  ## partnersListByIntegrationAccounts
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
  var path_564520 = newJObject()
  var query_564521 = newJObject()
  add(query_564521, "api-version", newJString(apiVersion))
  add(query_564521, "$top", newJInt(Top))
  add(path_564520, "subscriptionId", newJString(subscriptionId))
  add(path_564520, "resourceGroupName", newJString(resourceGroupName))
  add(query_564521, "$filter", newJString(Filter))
  add(path_564520, "integrationAccountName", newJString(integrationAccountName))
  result = call_564519.call(path_564520, query_564521, nil, nil, nil)

var partnersListByIntegrationAccounts* = Call_PartnersListByIntegrationAccounts_564509(
    name: "partnersListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners",
    validator: validate_PartnersListByIntegrationAccounts_564510, base: "",
    url: url_PartnersListByIntegrationAccounts_564511, schemes: {Scheme.Https})
type
  Call_PartnersCreateOrUpdate_564534 = ref object of OpenApiRestCall_563565
proc url_PartnersCreateOrUpdate_564536(protocol: Scheme; host: string; base: string;
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

proc validate_PartnersCreateOrUpdate_564535(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564537 = path.getOrDefault("subscriptionId")
  valid_564537 = validateParameter(valid_564537, JString, required = true,
                                 default = nil)
  if valid_564537 != nil:
    section.add "subscriptionId", valid_564537
  var valid_564538 = path.getOrDefault("partnerName")
  valid_564538 = validateParameter(valid_564538, JString, required = true,
                                 default = nil)
  if valid_564538 != nil:
    section.add "partnerName", valid_564538
  var valid_564539 = path.getOrDefault("resourceGroupName")
  valid_564539 = validateParameter(valid_564539, JString, required = true,
                                 default = nil)
  if valid_564539 != nil:
    section.add "resourceGroupName", valid_564539
  var valid_564540 = path.getOrDefault("integrationAccountName")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "integrationAccountName", valid_564540
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564541 = query.getOrDefault("api-version")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "api-version", valid_564541
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

proc call*(call_564543: Call_PartnersCreateOrUpdate_564534; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account partner.
  ## 
  let valid = call_564543.validator(path, query, header, formData, body)
  let scheme = call_564543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564543.url(scheme.get, call_564543.host, call_564543.base,
                         call_564543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564543, url, valid)

proc call*(call_564544: Call_PartnersCreateOrUpdate_564534; partner: JsonNode;
          apiVersion: string; subscriptionId: string; partnerName: string;
          resourceGroupName: string; integrationAccountName: string): Recallable =
  ## partnersCreateOrUpdate
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
  var path_564545 = newJObject()
  var query_564546 = newJObject()
  var body_564547 = newJObject()
  if partner != nil:
    body_564547 = partner
  add(query_564546, "api-version", newJString(apiVersion))
  add(path_564545, "subscriptionId", newJString(subscriptionId))
  add(path_564545, "partnerName", newJString(partnerName))
  add(path_564545, "resourceGroupName", newJString(resourceGroupName))
  add(path_564545, "integrationAccountName", newJString(integrationAccountName))
  result = call_564544.call(path_564545, query_564546, nil, nil, body_564547)

var partnersCreateOrUpdate* = Call_PartnersCreateOrUpdate_564534(
    name: "partnersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_PartnersCreateOrUpdate_564535, base: "",
    url: url_PartnersCreateOrUpdate_564536, schemes: {Scheme.Https})
type
  Call_PartnersGet_564522 = ref object of OpenApiRestCall_563565
proc url_PartnersGet_564524(protocol: Scheme; host: string; base: string;
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

proc validate_PartnersGet_564523(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564525 = path.getOrDefault("subscriptionId")
  valid_564525 = validateParameter(valid_564525, JString, required = true,
                                 default = nil)
  if valid_564525 != nil:
    section.add "subscriptionId", valid_564525
  var valid_564526 = path.getOrDefault("partnerName")
  valid_564526 = validateParameter(valid_564526, JString, required = true,
                                 default = nil)
  if valid_564526 != nil:
    section.add "partnerName", valid_564526
  var valid_564527 = path.getOrDefault("resourceGroupName")
  valid_564527 = validateParameter(valid_564527, JString, required = true,
                                 default = nil)
  if valid_564527 != nil:
    section.add "resourceGroupName", valid_564527
  var valid_564528 = path.getOrDefault("integrationAccountName")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "integrationAccountName", valid_564528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564529 = query.getOrDefault("api-version")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "api-version", valid_564529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564530: Call_PartnersGet_564522; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account partner.
  ## 
  let valid = call_564530.validator(path, query, header, formData, body)
  let scheme = call_564530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564530.url(scheme.get, call_564530.host, call_564530.base,
                         call_564530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564530, url, valid)

proc call*(call_564531: Call_PartnersGet_564522; apiVersion: string;
          subscriptionId: string; partnerName: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## partnersGet
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
  var path_564532 = newJObject()
  var query_564533 = newJObject()
  add(query_564533, "api-version", newJString(apiVersion))
  add(path_564532, "subscriptionId", newJString(subscriptionId))
  add(path_564532, "partnerName", newJString(partnerName))
  add(path_564532, "resourceGroupName", newJString(resourceGroupName))
  add(path_564532, "integrationAccountName", newJString(integrationAccountName))
  result = call_564531.call(path_564532, query_564533, nil, nil, nil)

var partnersGet* = Call_PartnersGet_564522(name: "partnersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
                                        validator: validate_PartnersGet_564523,
                                        base: "", url: url_PartnersGet_564524,
                                        schemes: {Scheme.Https})
type
  Call_PartnersDelete_564548 = ref object of OpenApiRestCall_563565
proc url_PartnersDelete_564550(protocol: Scheme; host: string; base: string;
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

proc validate_PartnersDelete_564549(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
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
  var valid_564551 = path.getOrDefault("subscriptionId")
  valid_564551 = validateParameter(valid_564551, JString, required = true,
                                 default = nil)
  if valid_564551 != nil:
    section.add "subscriptionId", valid_564551
  var valid_564552 = path.getOrDefault("partnerName")
  valid_564552 = validateParameter(valid_564552, JString, required = true,
                                 default = nil)
  if valid_564552 != nil:
    section.add "partnerName", valid_564552
  var valid_564553 = path.getOrDefault("resourceGroupName")
  valid_564553 = validateParameter(valid_564553, JString, required = true,
                                 default = nil)
  if valid_564553 != nil:
    section.add "resourceGroupName", valid_564553
  var valid_564554 = path.getOrDefault("integrationAccountName")
  valid_564554 = validateParameter(valid_564554, JString, required = true,
                                 default = nil)
  if valid_564554 != nil:
    section.add "integrationAccountName", valid_564554
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564555 = query.getOrDefault("api-version")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "api-version", valid_564555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564556: Call_PartnersDelete_564548; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account partner.
  ## 
  let valid = call_564556.validator(path, query, header, formData, body)
  let scheme = call_564556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564556.url(scheme.get, call_564556.host, call_564556.base,
                         call_564556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564556, url, valid)

proc call*(call_564557: Call_PartnersDelete_564548; apiVersion: string;
          subscriptionId: string; partnerName: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## partnersDelete
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
  var path_564558 = newJObject()
  var query_564559 = newJObject()
  add(query_564559, "api-version", newJString(apiVersion))
  add(path_564558, "subscriptionId", newJString(subscriptionId))
  add(path_564558, "partnerName", newJString(partnerName))
  add(path_564558, "resourceGroupName", newJString(resourceGroupName))
  add(path_564558, "integrationAccountName", newJString(integrationAccountName))
  result = call_564557.call(path_564558, query_564559, nil, nil, nil)

var partnersDelete* = Call_PartnersDelete_564548(name: "partnersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_PartnersDelete_564549, base: "", url: url_PartnersDelete_564550,
    schemes: {Scheme.Https})
type
  Call_PartnersListContentCallbackUrl_564560 = ref object of OpenApiRestCall_563565
proc url_PartnersListContentCallbackUrl_564562(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "partnerName"),
               (kind: ConstantSegment, value: "/listContentCallbackUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnersListContentCallbackUrl_564561(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564563 = path.getOrDefault("subscriptionId")
  valid_564563 = validateParameter(valid_564563, JString, required = true,
                                 default = nil)
  if valid_564563 != nil:
    section.add "subscriptionId", valid_564563
  var valid_564564 = path.getOrDefault("partnerName")
  valid_564564 = validateParameter(valid_564564, JString, required = true,
                                 default = nil)
  if valid_564564 != nil:
    section.add "partnerName", valid_564564
  var valid_564565 = path.getOrDefault("resourceGroupName")
  valid_564565 = validateParameter(valid_564565, JString, required = true,
                                 default = nil)
  if valid_564565 != nil:
    section.add "resourceGroupName", valid_564565
  var valid_564566 = path.getOrDefault("integrationAccountName")
  valid_564566 = validateParameter(valid_564566, JString, required = true,
                                 default = nil)
  if valid_564566 != nil:
    section.add "integrationAccountName", valid_564566
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564567 = query.getOrDefault("api-version")
  valid_564567 = validateParameter(valid_564567, JString, required = true,
                                 default = nil)
  if valid_564567 != nil:
    section.add "api-version", valid_564567
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

proc call*(call_564569: Call_PartnersListContentCallbackUrl_564560; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_564569.validator(path, query, header, formData, body)
  let scheme = call_564569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564569.url(scheme.get, call_564569.host, call_564569.base,
                         call_564569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564569, url, valid)

proc call*(call_564570: Call_PartnersListContentCallbackUrl_564560;
          apiVersion: string; subscriptionId: string; partnerName: string;
          listContentCallbackUrl: JsonNode; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## partnersListContentCallbackUrl
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
  var path_564571 = newJObject()
  var query_564572 = newJObject()
  var body_564573 = newJObject()
  add(query_564572, "api-version", newJString(apiVersion))
  add(path_564571, "subscriptionId", newJString(subscriptionId))
  add(path_564571, "partnerName", newJString(partnerName))
  if listContentCallbackUrl != nil:
    body_564573 = listContentCallbackUrl
  add(path_564571, "resourceGroupName", newJString(resourceGroupName))
  add(path_564571, "integrationAccountName", newJString(integrationAccountName))
  result = call_564570.call(path_564571, query_564572, nil, nil, body_564573)

var partnersListContentCallbackUrl* = Call_PartnersListContentCallbackUrl_564560(
    name: "partnersListContentCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}/listContentCallbackUrl",
    validator: validate_PartnersListContentCallbackUrl_564561, base: "",
    url: url_PartnersListContentCallbackUrl_564562, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsRegenerateAccessKey_564574 = ref object of OpenApiRestCall_563565
proc url_IntegrationAccountsRegenerateAccessKey_564576(protocol: Scheme;
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

proc validate_IntegrationAccountsRegenerateAccessKey_564575(path: JsonNode;
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
  var valid_564577 = path.getOrDefault("subscriptionId")
  valid_564577 = validateParameter(valid_564577, JString, required = true,
                                 default = nil)
  if valid_564577 != nil:
    section.add "subscriptionId", valid_564577
  var valid_564578 = path.getOrDefault("resourceGroupName")
  valid_564578 = validateParameter(valid_564578, JString, required = true,
                                 default = nil)
  if valid_564578 != nil:
    section.add "resourceGroupName", valid_564578
  var valid_564579 = path.getOrDefault("integrationAccountName")
  valid_564579 = validateParameter(valid_564579, JString, required = true,
                                 default = nil)
  if valid_564579 != nil:
    section.add "integrationAccountName", valid_564579
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564580 = query.getOrDefault("api-version")
  valid_564580 = validateParameter(valid_564580, JString, required = true,
                                 default = nil)
  if valid_564580 != nil:
    section.add "api-version", valid_564580
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

proc call*(call_564582: Call_IntegrationAccountsRegenerateAccessKey_564574;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the integration account access key.
  ## 
  let valid = call_564582.validator(path, query, header, formData, body)
  let scheme = call_564582.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564582.url(scheme.get, call_564582.host, call_564582.base,
                         call_564582.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564582, url, valid)

proc call*(call_564583: Call_IntegrationAccountsRegenerateAccessKey_564574;
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
  var path_564584 = newJObject()
  var query_564585 = newJObject()
  var body_564586 = newJObject()
  add(query_564585, "api-version", newJString(apiVersion))
  add(path_564584, "subscriptionId", newJString(subscriptionId))
  add(path_564584, "resourceGroupName", newJString(resourceGroupName))
  if regenerateAccessKey != nil:
    body_564586 = regenerateAccessKey
  add(path_564584, "integrationAccountName", newJString(integrationAccountName))
  result = call_564583.call(path_564584, query_564585, nil, nil, body_564586)

var integrationAccountsRegenerateAccessKey* = Call_IntegrationAccountsRegenerateAccessKey_564574(
    name: "integrationAccountsRegenerateAccessKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/regenerateAccessKey",
    validator: validate_IntegrationAccountsRegenerateAccessKey_564575, base: "",
    url: url_IntegrationAccountsRegenerateAccessKey_564576,
    schemes: {Scheme.Https})
type
  Call_RosettaNetProcessConfigurationsListByIntegrationAccounts_564587 = ref object of OpenApiRestCall_563565
proc url_RosettaNetProcessConfigurationsListByIntegrationAccounts_564589(
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"), (
        kind: ConstantSegment, value: "/rosettanetprocessconfigurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RosettaNetProcessConfigurationsListByIntegrationAccounts_564588(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a list of integration account RosettaNet process configurations.
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
  var valid_564590 = path.getOrDefault("subscriptionId")
  valid_564590 = validateParameter(valid_564590, JString, required = true,
                                 default = nil)
  if valid_564590 != nil:
    section.add "subscriptionId", valid_564590
  var valid_564591 = path.getOrDefault("resourceGroupName")
  valid_564591 = validateParameter(valid_564591, JString, required = true,
                                 default = nil)
  if valid_564591 != nil:
    section.add "resourceGroupName", valid_564591
  var valid_564592 = path.getOrDefault("integrationAccountName")
  valid_564592 = validateParameter(valid_564592, JString, required = true,
                                 default = nil)
  if valid_564592 != nil:
    section.add "integrationAccountName", valid_564592
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
  var valid_564593 = query.getOrDefault("api-version")
  valid_564593 = validateParameter(valid_564593, JString, required = true,
                                 default = nil)
  if valid_564593 != nil:
    section.add "api-version", valid_564593
  var valid_564594 = query.getOrDefault("$top")
  valid_564594 = validateParameter(valid_564594, JInt, required = false, default = nil)
  if valid_564594 != nil:
    section.add "$top", valid_564594
  var valid_564595 = query.getOrDefault("$filter")
  valid_564595 = validateParameter(valid_564595, JString, required = false,
                                 default = nil)
  if valid_564595 != nil:
    section.add "$filter", valid_564595
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564596: Call_RosettaNetProcessConfigurationsListByIntegrationAccounts_564587;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account RosettaNet process configurations.
  ## 
  let valid = call_564596.validator(path, query, header, formData, body)
  let scheme = call_564596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564596.url(scheme.get, call_564596.host, call_564596.base,
                         call_564596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564596, url, valid)

proc call*(call_564597: Call_RosettaNetProcessConfigurationsListByIntegrationAccounts_564587;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; Top: int = 0; Filter: string = ""): Recallable =
  ## rosettaNetProcessConfigurationsListByIntegrationAccounts
  ## Gets a list of integration account RosettaNet process configurations.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  var path_564598 = newJObject()
  var query_564599 = newJObject()
  add(query_564599, "api-version", newJString(apiVersion))
  add(query_564599, "$top", newJInt(Top))
  add(path_564598, "subscriptionId", newJString(subscriptionId))
  add(path_564598, "resourceGroupName", newJString(resourceGroupName))
  add(query_564599, "$filter", newJString(Filter))
  add(path_564598, "integrationAccountName", newJString(integrationAccountName))
  result = call_564597.call(path_564598, query_564599, nil, nil, nil)

var rosettaNetProcessConfigurationsListByIntegrationAccounts* = Call_RosettaNetProcessConfigurationsListByIntegrationAccounts_564587(
    name: "rosettaNetProcessConfigurationsListByIntegrationAccounts",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/rosettanetprocessconfigurations", validator: validate_RosettaNetProcessConfigurationsListByIntegrationAccounts_564588,
    base: "", url: url_RosettaNetProcessConfigurationsListByIntegrationAccounts_564589,
    schemes: {Scheme.Https})
type
  Call_RosettaNetProcessConfigurationsCreateOrUpdate_564612 = ref object of OpenApiRestCall_563565
proc url_RosettaNetProcessConfigurationsCreateOrUpdate_564614(protocol: Scheme;
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
  assert "rosettaNetProcessConfigurationName" in path,
        "`rosettaNetProcessConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"), (
        kind: ConstantSegment, value: "/rosettanetprocessconfigurations/"), (
        kind: VariableSegment, value: "rosettaNetProcessConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RosettaNetProcessConfigurationsCreateOrUpdate_564613(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates an integration account RosettaNetProcessConfiguration.
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
  ##   rosettaNetProcessConfigurationName: JString (required)
  ##                                     : The integration account RosettaNet ProcessConfiguration name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564615 = path.getOrDefault("subscriptionId")
  valid_564615 = validateParameter(valid_564615, JString, required = true,
                                 default = nil)
  if valid_564615 != nil:
    section.add "subscriptionId", valid_564615
  var valid_564616 = path.getOrDefault("resourceGroupName")
  valid_564616 = validateParameter(valid_564616, JString, required = true,
                                 default = nil)
  if valid_564616 != nil:
    section.add "resourceGroupName", valid_564616
  var valid_564617 = path.getOrDefault("integrationAccountName")
  valid_564617 = validateParameter(valid_564617, JString, required = true,
                                 default = nil)
  if valid_564617 != nil:
    section.add "integrationAccountName", valid_564617
  var valid_564618 = path.getOrDefault("rosettaNetProcessConfigurationName")
  valid_564618 = validateParameter(valid_564618, JString, required = true,
                                 default = nil)
  if valid_564618 != nil:
    section.add "rosettaNetProcessConfigurationName", valid_564618
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564619 = query.getOrDefault("api-version")
  valid_564619 = validateParameter(valid_564619, JString, required = true,
                                 default = nil)
  if valid_564619 != nil:
    section.add "api-version", valid_564619
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   rosettaNetProcessConfiguration: JObject (required)
  ##                                 : The integration account RosettaNet ProcessConfiguration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564621: Call_RosettaNetProcessConfigurationsCreateOrUpdate_564612;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account RosettaNetProcessConfiguration.
  ## 
  let valid = call_564621.validator(path, query, header, formData, body)
  let scheme = call_564621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564621.url(scheme.get, call_564621.host, call_564621.base,
                         call_564621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564621, url, valid)

proc call*(call_564622: Call_RosettaNetProcessConfigurationsCreateOrUpdate_564612;
          apiVersion: string; rosettaNetProcessConfiguration: JsonNode;
          subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string;
          rosettaNetProcessConfigurationName: string): Recallable =
  ## rosettaNetProcessConfigurationsCreateOrUpdate
  ## Creates or updates an integration account RosettaNetProcessConfiguration.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   rosettaNetProcessConfiguration: JObject (required)
  ##                                 : The integration account RosettaNet ProcessConfiguration.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   rosettaNetProcessConfigurationName: string (required)
  ##                                     : The integration account RosettaNet ProcessConfiguration name.
  var path_564623 = newJObject()
  var query_564624 = newJObject()
  var body_564625 = newJObject()
  add(query_564624, "api-version", newJString(apiVersion))
  if rosettaNetProcessConfiguration != nil:
    body_564625 = rosettaNetProcessConfiguration
  add(path_564623, "subscriptionId", newJString(subscriptionId))
  add(path_564623, "resourceGroupName", newJString(resourceGroupName))
  add(path_564623, "integrationAccountName", newJString(integrationAccountName))
  add(path_564623, "rosettaNetProcessConfigurationName",
      newJString(rosettaNetProcessConfigurationName))
  result = call_564622.call(path_564623, query_564624, nil, nil, body_564625)

var rosettaNetProcessConfigurationsCreateOrUpdate* = Call_RosettaNetProcessConfigurationsCreateOrUpdate_564612(
    name: "rosettaNetProcessConfigurationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/rosettanetprocessconfigurations/{rosettaNetProcessConfigurationName}",
    validator: validate_RosettaNetProcessConfigurationsCreateOrUpdate_564613,
    base: "", url: url_RosettaNetProcessConfigurationsCreateOrUpdate_564614,
    schemes: {Scheme.Https})
type
  Call_RosettaNetProcessConfigurationsGet_564600 = ref object of OpenApiRestCall_563565
proc url_RosettaNetProcessConfigurationsGet_564602(protocol: Scheme; host: string;
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
  assert "rosettaNetProcessConfigurationName" in path,
        "`rosettaNetProcessConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"), (
        kind: ConstantSegment, value: "/rosettanetprocessconfigurations/"), (
        kind: VariableSegment, value: "rosettaNetProcessConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RosettaNetProcessConfigurationsGet_564601(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account RosettaNetProcessConfiguration.
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
  ##   rosettaNetProcessConfigurationName: JString (required)
  ##                                     : The integration account RosettaNetProcessConfiguration name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564603 = path.getOrDefault("subscriptionId")
  valid_564603 = validateParameter(valid_564603, JString, required = true,
                                 default = nil)
  if valid_564603 != nil:
    section.add "subscriptionId", valid_564603
  var valid_564604 = path.getOrDefault("resourceGroupName")
  valid_564604 = validateParameter(valid_564604, JString, required = true,
                                 default = nil)
  if valid_564604 != nil:
    section.add "resourceGroupName", valid_564604
  var valid_564605 = path.getOrDefault("integrationAccountName")
  valid_564605 = validateParameter(valid_564605, JString, required = true,
                                 default = nil)
  if valid_564605 != nil:
    section.add "integrationAccountName", valid_564605
  var valid_564606 = path.getOrDefault("rosettaNetProcessConfigurationName")
  valid_564606 = validateParameter(valid_564606, JString, required = true,
                                 default = nil)
  if valid_564606 != nil:
    section.add "rosettaNetProcessConfigurationName", valid_564606
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564607 = query.getOrDefault("api-version")
  valid_564607 = validateParameter(valid_564607, JString, required = true,
                                 default = nil)
  if valid_564607 != nil:
    section.add "api-version", valid_564607
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564608: Call_RosettaNetProcessConfigurationsGet_564600;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an integration account RosettaNetProcessConfiguration.
  ## 
  let valid = call_564608.validator(path, query, header, formData, body)
  let scheme = call_564608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564608.url(scheme.get, call_564608.host, call_564608.base,
                         call_564608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564608, url, valid)

proc call*(call_564609: Call_RosettaNetProcessConfigurationsGet_564600;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string;
          rosettaNetProcessConfigurationName: string): Recallable =
  ## rosettaNetProcessConfigurationsGet
  ## Gets an integration account RosettaNetProcessConfiguration.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   rosettaNetProcessConfigurationName: string (required)
  ##                                     : The integration account RosettaNetProcessConfiguration name.
  var path_564610 = newJObject()
  var query_564611 = newJObject()
  add(query_564611, "api-version", newJString(apiVersion))
  add(path_564610, "subscriptionId", newJString(subscriptionId))
  add(path_564610, "resourceGroupName", newJString(resourceGroupName))
  add(path_564610, "integrationAccountName", newJString(integrationAccountName))
  add(path_564610, "rosettaNetProcessConfigurationName",
      newJString(rosettaNetProcessConfigurationName))
  result = call_564609.call(path_564610, query_564611, nil, nil, nil)

var rosettaNetProcessConfigurationsGet* = Call_RosettaNetProcessConfigurationsGet_564600(
    name: "rosettaNetProcessConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/rosettanetprocessconfigurations/{rosettaNetProcessConfigurationName}",
    validator: validate_RosettaNetProcessConfigurationsGet_564601, base: "",
    url: url_RosettaNetProcessConfigurationsGet_564602, schemes: {Scheme.Https})
type
  Call_RosettaNetProcessConfigurationsDelete_564626 = ref object of OpenApiRestCall_563565
proc url_RosettaNetProcessConfigurationsDelete_564628(protocol: Scheme;
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
  assert "rosettaNetProcessConfigurationName" in path,
        "`rosettaNetProcessConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"), (
        kind: ConstantSegment, value: "/rosettanetprocessconfigurations/"), (
        kind: VariableSegment, value: "rosettaNetProcessConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RosettaNetProcessConfigurationsDelete_564627(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account RosettaNet ProcessConfiguration.
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
  ##   rosettaNetProcessConfigurationName: JString (required)
  ##                                     : The integration account RosettaNetProcessConfiguration name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564629 = path.getOrDefault("subscriptionId")
  valid_564629 = validateParameter(valid_564629, JString, required = true,
                                 default = nil)
  if valid_564629 != nil:
    section.add "subscriptionId", valid_564629
  var valid_564630 = path.getOrDefault("resourceGroupName")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "resourceGroupName", valid_564630
  var valid_564631 = path.getOrDefault("integrationAccountName")
  valid_564631 = validateParameter(valid_564631, JString, required = true,
                                 default = nil)
  if valid_564631 != nil:
    section.add "integrationAccountName", valid_564631
  var valid_564632 = path.getOrDefault("rosettaNetProcessConfigurationName")
  valid_564632 = validateParameter(valid_564632, JString, required = true,
                                 default = nil)
  if valid_564632 != nil:
    section.add "rosettaNetProcessConfigurationName", valid_564632
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564633 = query.getOrDefault("api-version")
  valid_564633 = validateParameter(valid_564633, JString, required = true,
                                 default = nil)
  if valid_564633 != nil:
    section.add "api-version", valid_564633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564634: Call_RosettaNetProcessConfigurationsDelete_564626;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account RosettaNet ProcessConfiguration.
  ## 
  let valid = call_564634.validator(path, query, header, formData, body)
  let scheme = call_564634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564634.url(scheme.get, call_564634.host, call_564634.base,
                         call_564634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564634, url, valid)

proc call*(call_564635: Call_RosettaNetProcessConfigurationsDelete_564626;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string;
          rosettaNetProcessConfigurationName: string): Recallable =
  ## rosettaNetProcessConfigurationsDelete
  ## Deletes an integration account RosettaNet ProcessConfiguration.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   rosettaNetProcessConfigurationName: string (required)
  ##                                     : The integration account RosettaNetProcessConfiguration name.
  var path_564636 = newJObject()
  var query_564637 = newJObject()
  add(query_564637, "api-version", newJString(apiVersion))
  add(path_564636, "subscriptionId", newJString(subscriptionId))
  add(path_564636, "resourceGroupName", newJString(resourceGroupName))
  add(path_564636, "integrationAccountName", newJString(integrationAccountName))
  add(path_564636, "rosettaNetProcessConfigurationName",
      newJString(rosettaNetProcessConfigurationName))
  result = call_564635.call(path_564636, query_564637, nil, nil, nil)

var rosettaNetProcessConfigurationsDelete* = Call_RosettaNetProcessConfigurationsDelete_564626(
    name: "rosettaNetProcessConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/rosettanetprocessconfigurations/{rosettaNetProcessConfigurationName}",
    validator: validate_RosettaNetProcessConfigurationsDelete_564627, base: "",
    url: url_RosettaNetProcessConfigurationsDelete_564628, schemes: {Scheme.Https})
type
  Call_SchemasListByIntegrationAccounts_564638 = ref object of OpenApiRestCall_563565
proc url_SchemasListByIntegrationAccounts_564640(protocol: Scheme; host: string;
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

proc validate_SchemasListByIntegrationAccounts_564639(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564641 = path.getOrDefault("subscriptionId")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "subscriptionId", valid_564641
  var valid_564642 = path.getOrDefault("resourceGroupName")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "resourceGroupName", valid_564642
  var valid_564643 = path.getOrDefault("integrationAccountName")
  valid_564643 = validateParameter(valid_564643, JString, required = true,
                                 default = nil)
  if valid_564643 != nil:
    section.add "integrationAccountName", valid_564643
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
  var valid_564644 = query.getOrDefault("api-version")
  valid_564644 = validateParameter(valid_564644, JString, required = true,
                                 default = nil)
  if valid_564644 != nil:
    section.add "api-version", valid_564644
  var valid_564645 = query.getOrDefault("$top")
  valid_564645 = validateParameter(valid_564645, JInt, required = false, default = nil)
  if valid_564645 != nil:
    section.add "$top", valid_564645
  var valid_564646 = query.getOrDefault("$filter")
  valid_564646 = validateParameter(valid_564646, JString, required = false,
                                 default = nil)
  if valid_564646 != nil:
    section.add "$filter", valid_564646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564647: Call_SchemasListByIntegrationAccounts_564638;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account schemas.
  ## 
  let valid = call_564647.validator(path, query, header, formData, body)
  let scheme = call_564647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564647.url(scheme.get, call_564647.host, call_564647.base,
                         call_564647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564647, url, valid)

proc call*(call_564648: Call_SchemasListByIntegrationAccounts_564638;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; Top: int = 0; Filter: string = ""): Recallable =
  ## schemasListByIntegrationAccounts
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
  var path_564649 = newJObject()
  var query_564650 = newJObject()
  add(query_564650, "api-version", newJString(apiVersion))
  add(query_564650, "$top", newJInt(Top))
  add(path_564649, "subscriptionId", newJString(subscriptionId))
  add(path_564649, "resourceGroupName", newJString(resourceGroupName))
  add(query_564650, "$filter", newJString(Filter))
  add(path_564649, "integrationAccountName", newJString(integrationAccountName))
  result = call_564648.call(path_564649, query_564650, nil, nil, nil)

var schemasListByIntegrationAccounts* = Call_SchemasListByIntegrationAccounts_564638(
    name: "schemasListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas",
    validator: validate_SchemasListByIntegrationAccounts_564639, base: "",
    url: url_SchemasListByIntegrationAccounts_564640, schemes: {Scheme.Https})
type
  Call_SchemasCreateOrUpdate_564663 = ref object of OpenApiRestCall_563565
proc url_SchemasCreateOrUpdate_564665(protocol: Scheme; host: string; base: string;
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

proc validate_SchemasCreateOrUpdate_564664(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564666 = path.getOrDefault("subscriptionId")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "subscriptionId", valid_564666
  var valid_564667 = path.getOrDefault("resourceGroupName")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "resourceGroupName", valid_564667
  var valid_564668 = path.getOrDefault("schemaName")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "schemaName", valid_564668
  var valid_564669 = path.getOrDefault("integrationAccountName")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "integrationAccountName", valid_564669
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564670 = query.getOrDefault("api-version")
  valid_564670 = validateParameter(valid_564670, JString, required = true,
                                 default = nil)
  if valid_564670 != nil:
    section.add "api-version", valid_564670
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

proc call*(call_564672: Call_SchemasCreateOrUpdate_564663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account schema.
  ## 
  let valid = call_564672.validator(path, query, header, formData, body)
  let scheme = call_564672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564672.url(scheme.get, call_564672.host, call_564672.base,
                         call_564672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564672, url, valid)

proc call*(call_564673: Call_SchemasCreateOrUpdate_564663; apiVersion: string;
          schema: JsonNode; subscriptionId: string; resourceGroupName: string;
          schemaName: string; integrationAccountName: string): Recallable =
  ## schemasCreateOrUpdate
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
  var path_564674 = newJObject()
  var query_564675 = newJObject()
  var body_564676 = newJObject()
  add(query_564675, "api-version", newJString(apiVersion))
  if schema != nil:
    body_564676 = schema
  add(path_564674, "subscriptionId", newJString(subscriptionId))
  add(path_564674, "resourceGroupName", newJString(resourceGroupName))
  add(path_564674, "schemaName", newJString(schemaName))
  add(path_564674, "integrationAccountName", newJString(integrationAccountName))
  result = call_564673.call(path_564674, query_564675, nil, nil, body_564676)

var schemasCreateOrUpdate* = Call_SchemasCreateOrUpdate_564663(
    name: "schemasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_SchemasCreateOrUpdate_564664, base: "",
    url: url_SchemasCreateOrUpdate_564665, schemes: {Scheme.Https})
type
  Call_SchemasGet_564651 = ref object of OpenApiRestCall_563565
proc url_SchemasGet_564653(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
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

proc validate_SchemasGet_564652(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564654 = path.getOrDefault("subscriptionId")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "subscriptionId", valid_564654
  var valid_564655 = path.getOrDefault("resourceGroupName")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "resourceGroupName", valid_564655
  var valid_564656 = path.getOrDefault("schemaName")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "schemaName", valid_564656
  var valid_564657 = path.getOrDefault("integrationAccountName")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "integrationAccountName", valid_564657
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564658 = query.getOrDefault("api-version")
  valid_564658 = validateParameter(valid_564658, JString, required = true,
                                 default = nil)
  if valid_564658 != nil:
    section.add "api-version", valid_564658
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564659: Call_SchemasGet_564651; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account schema.
  ## 
  let valid = call_564659.validator(path, query, header, formData, body)
  let scheme = call_564659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564659.url(scheme.get, call_564659.host, call_564659.base,
                         call_564659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564659, url, valid)

proc call*(call_564660: Call_SchemasGet_564651; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; schemaName: string;
          integrationAccountName: string): Recallable =
  ## schemasGet
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
  var path_564661 = newJObject()
  var query_564662 = newJObject()
  add(query_564662, "api-version", newJString(apiVersion))
  add(path_564661, "subscriptionId", newJString(subscriptionId))
  add(path_564661, "resourceGroupName", newJString(resourceGroupName))
  add(path_564661, "schemaName", newJString(schemaName))
  add(path_564661, "integrationAccountName", newJString(integrationAccountName))
  result = call_564660.call(path_564661, query_564662, nil, nil, nil)

var schemasGet* = Call_SchemasGet_564651(name: "schemasGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
                                      validator: validate_SchemasGet_564652,
                                      base: "", url: url_SchemasGet_564653,
                                      schemes: {Scheme.Https})
type
  Call_SchemasDelete_564677 = ref object of OpenApiRestCall_563565
proc url_SchemasDelete_564679(protocol: Scheme; host: string; base: string;
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

proc validate_SchemasDelete_564678(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564680 = path.getOrDefault("subscriptionId")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "subscriptionId", valid_564680
  var valid_564681 = path.getOrDefault("resourceGroupName")
  valid_564681 = validateParameter(valid_564681, JString, required = true,
                                 default = nil)
  if valid_564681 != nil:
    section.add "resourceGroupName", valid_564681
  var valid_564682 = path.getOrDefault("schemaName")
  valid_564682 = validateParameter(valid_564682, JString, required = true,
                                 default = nil)
  if valid_564682 != nil:
    section.add "schemaName", valid_564682
  var valid_564683 = path.getOrDefault("integrationAccountName")
  valid_564683 = validateParameter(valid_564683, JString, required = true,
                                 default = nil)
  if valid_564683 != nil:
    section.add "integrationAccountName", valid_564683
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564684 = query.getOrDefault("api-version")
  valid_564684 = validateParameter(valid_564684, JString, required = true,
                                 default = nil)
  if valid_564684 != nil:
    section.add "api-version", valid_564684
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564685: Call_SchemasDelete_564677; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account schema.
  ## 
  let valid = call_564685.validator(path, query, header, formData, body)
  let scheme = call_564685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564685.url(scheme.get, call_564685.host, call_564685.base,
                         call_564685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564685, url, valid)

proc call*(call_564686: Call_SchemasDelete_564677; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; schemaName: string;
          integrationAccountName: string): Recallable =
  ## schemasDelete
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
  var path_564687 = newJObject()
  var query_564688 = newJObject()
  add(query_564688, "api-version", newJString(apiVersion))
  add(path_564687, "subscriptionId", newJString(subscriptionId))
  add(path_564687, "resourceGroupName", newJString(resourceGroupName))
  add(path_564687, "schemaName", newJString(schemaName))
  add(path_564687, "integrationAccountName", newJString(integrationAccountName))
  result = call_564686.call(path_564687, query_564688, nil, nil, nil)

var schemasDelete* = Call_SchemasDelete_564677(name: "schemasDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_SchemasDelete_564678, base: "", url: url_SchemasDelete_564679,
    schemes: {Scheme.Https})
type
  Call_SchemasListContentCallbackUrl_564689 = ref object of OpenApiRestCall_563565
proc url_SchemasListContentCallbackUrl_564691(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/listContentCallbackUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchemasListContentCallbackUrl_564690(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564692 = path.getOrDefault("subscriptionId")
  valid_564692 = validateParameter(valid_564692, JString, required = true,
                                 default = nil)
  if valid_564692 != nil:
    section.add "subscriptionId", valid_564692
  var valid_564693 = path.getOrDefault("resourceGroupName")
  valid_564693 = validateParameter(valid_564693, JString, required = true,
                                 default = nil)
  if valid_564693 != nil:
    section.add "resourceGroupName", valid_564693
  var valid_564694 = path.getOrDefault("schemaName")
  valid_564694 = validateParameter(valid_564694, JString, required = true,
                                 default = nil)
  if valid_564694 != nil:
    section.add "schemaName", valid_564694
  var valid_564695 = path.getOrDefault("integrationAccountName")
  valid_564695 = validateParameter(valid_564695, JString, required = true,
                                 default = nil)
  if valid_564695 != nil:
    section.add "integrationAccountName", valid_564695
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564696 = query.getOrDefault("api-version")
  valid_564696 = validateParameter(valid_564696, JString, required = true,
                                 default = nil)
  if valid_564696 != nil:
    section.add "api-version", valid_564696
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

proc call*(call_564698: Call_SchemasListContentCallbackUrl_564689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_564698.validator(path, query, header, formData, body)
  let scheme = call_564698.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564698.url(scheme.get, call_564698.host, call_564698.base,
                         call_564698.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564698, url, valid)

proc call*(call_564699: Call_SchemasListContentCallbackUrl_564689;
          apiVersion: string; subscriptionId: string;
          listContentCallbackUrl: JsonNode; resourceGroupName: string;
          schemaName: string; integrationAccountName: string): Recallable =
  ## schemasListContentCallbackUrl
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
  var path_564700 = newJObject()
  var query_564701 = newJObject()
  var body_564702 = newJObject()
  add(query_564701, "api-version", newJString(apiVersion))
  add(path_564700, "subscriptionId", newJString(subscriptionId))
  if listContentCallbackUrl != nil:
    body_564702 = listContentCallbackUrl
  add(path_564700, "resourceGroupName", newJString(resourceGroupName))
  add(path_564700, "schemaName", newJString(schemaName))
  add(path_564700, "integrationAccountName", newJString(integrationAccountName))
  result = call_564699.call(path_564700, query_564701, nil, nil, body_564702)

var schemasListContentCallbackUrl* = Call_SchemasListContentCallbackUrl_564689(
    name: "schemasListContentCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}/listContentCallbackUrl",
    validator: validate_SchemasListContentCallbackUrl_564690, base: "",
    url: url_SchemasListContentCallbackUrl_564691, schemes: {Scheme.Https})
type
  Call_SessionsListByIntegrationAccounts_564703 = ref object of OpenApiRestCall_563565
proc url_SessionsListByIntegrationAccounts_564705(protocol: Scheme; host: string;
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

proc validate_SessionsListByIntegrationAccounts_564704(path: JsonNode;
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
  var valid_564706 = path.getOrDefault("subscriptionId")
  valid_564706 = validateParameter(valid_564706, JString, required = true,
                                 default = nil)
  if valid_564706 != nil:
    section.add "subscriptionId", valid_564706
  var valid_564707 = path.getOrDefault("resourceGroupName")
  valid_564707 = validateParameter(valid_564707, JString, required = true,
                                 default = nil)
  if valid_564707 != nil:
    section.add "resourceGroupName", valid_564707
  var valid_564708 = path.getOrDefault("integrationAccountName")
  valid_564708 = validateParameter(valid_564708, JString, required = true,
                                 default = nil)
  if valid_564708 != nil:
    section.add "integrationAccountName", valid_564708
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
  var valid_564709 = query.getOrDefault("api-version")
  valid_564709 = validateParameter(valid_564709, JString, required = true,
                                 default = nil)
  if valid_564709 != nil:
    section.add "api-version", valid_564709
  var valid_564710 = query.getOrDefault("$top")
  valid_564710 = validateParameter(valid_564710, JInt, required = false, default = nil)
  if valid_564710 != nil:
    section.add "$top", valid_564710
  var valid_564711 = query.getOrDefault("$filter")
  valid_564711 = validateParameter(valid_564711, JString, required = false,
                                 default = nil)
  if valid_564711 != nil:
    section.add "$filter", valid_564711
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564712: Call_SessionsListByIntegrationAccounts_564703;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account sessions.
  ## 
  let valid = call_564712.validator(path, query, header, formData, body)
  let scheme = call_564712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564712.url(scheme.get, call_564712.host, call_564712.base,
                         call_564712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564712, url, valid)

proc call*(call_564713: Call_SessionsListByIntegrationAccounts_564703;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          integrationAccountName: string; Top: int = 0; Filter: string = ""): Recallable =
  ## sessionsListByIntegrationAccounts
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
  var path_564714 = newJObject()
  var query_564715 = newJObject()
  add(query_564715, "api-version", newJString(apiVersion))
  add(query_564715, "$top", newJInt(Top))
  add(path_564714, "subscriptionId", newJString(subscriptionId))
  add(path_564714, "resourceGroupName", newJString(resourceGroupName))
  add(query_564715, "$filter", newJString(Filter))
  add(path_564714, "integrationAccountName", newJString(integrationAccountName))
  result = call_564713.call(path_564714, query_564715, nil, nil, nil)

var sessionsListByIntegrationAccounts* = Call_SessionsListByIntegrationAccounts_564703(
    name: "sessionsListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions",
    validator: validate_SessionsListByIntegrationAccounts_564704, base: "",
    url: url_SessionsListByIntegrationAccounts_564705, schemes: {Scheme.Https})
type
  Call_SessionsCreateOrUpdate_564728 = ref object of OpenApiRestCall_563565
proc url_SessionsCreateOrUpdate_564730(protocol: Scheme; host: string; base: string;
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

proc validate_SessionsCreateOrUpdate_564729(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564731 = path.getOrDefault("subscriptionId")
  valid_564731 = validateParameter(valid_564731, JString, required = true,
                                 default = nil)
  if valid_564731 != nil:
    section.add "subscriptionId", valid_564731
  var valid_564732 = path.getOrDefault("sessionName")
  valid_564732 = validateParameter(valid_564732, JString, required = true,
                                 default = nil)
  if valid_564732 != nil:
    section.add "sessionName", valid_564732
  var valid_564733 = path.getOrDefault("resourceGroupName")
  valid_564733 = validateParameter(valid_564733, JString, required = true,
                                 default = nil)
  if valid_564733 != nil:
    section.add "resourceGroupName", valid_564733
  var valid_564734 = path.getOrDefault("integrationAccountName")
  valid_564734 = validateParameter(valid_564734, JString, required = true,
                                 default = nil)
  if valid_564734 != nil:
    section.add "integrationAccountName", valid_564734
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564735 = query.getOrDefault("api-version")
  valid_564735 = validateParameter(valid_564735, JString, required = true,
                                 default = nil)
  if valid_564735 != nil:
    section.add "api-version", valid_564735
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

proc call*(call_564737: Call_SessionsCreateOrUpdate_564728; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account session.
  ## 
  let valid = call_564737.validator(path, query, header, formData, body)
  let scheme = call_564737.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564737.url(scheme.get, call_564737.host, call_564737.base,
                         call_564737.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564737, url, valid)

proc call*(call_564738: Call_SessionsCreateOrUpdate_564728; apiVersion: string;
          subscriptionId: string; sessionName: string; resourceGroupName: string;
          session: JsonNode; integrationAccountName: string): Recallable =
  ## sessionsCreateOrUpdate
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
  var path_564739 = newJObject()
  var query_564740 = newJObject()
  var body_564741 = newJObject()
  add(query_564740, "api-version", newJString(apiVersion))
  add(path_564739, "subscriptionId", newJString(subscriptionId))
  add(path_564739, "sessionName", newJString(sessionName))
  add(path_564739, "resourceGroupName", newJString(resourceGroupName))
  if session != nil:
    body_564741 = session
  add(path_564739, "integrationAccountName", newJString(integrationAccountName))
  result = call_564738.call(path_564739, query_564740, nil, nil, body_564741)

var sessionsCreateOrUpdate* = Call_SessionsCreateOrUpdate_564728(
    name: "sessionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
    validator: validate_SessionsCreateOrUpdate_564729, base: "",
    url: url_SessionsCreateOrUpdate_564730, schemes: {Scheme.Https})
type
  Call_SessionsGet_564716 = ref object of OpenApiRestCall_563565
proc url_SessionsGet_564718(protocol: Scheme; host: string; base: string;
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

proc validate_SessionsGet_564717(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564719 = path.getOrDefault("subscriptionId")
  valid_564719 = validateParameter(valid_564719, JString, required = true,
                                 default = nil)
  if valid_564719 != nil:
    section.add "subscriptionId", valid_564719
  var valid_564720 = path.getOrDefault("sessionName")
  valid_564720 = validateParameter(valid_564720, JString, required = true,
                                 default = nil)
  if valid_564720 != nil:
    section.add "sessionName", valid_564720
  var valid_564721 = path.getOrDefault("resourceGroupName")
  valid_564721 = validateParameter(valid_564721, JString, required = true,
                                 default = nil)
  if valid_564721 != nil:
    section.add "resourceGroupName", valid_564721
  var valid_564722 = path.getOrDefault("integrationAccountName")
  valid_564722 = validateParameter(valid_564722, JString, required = true,
                                 default = nil)
  if valid_564722 != nil:
    section.add "integrationAccountName", valid_564722
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564723 = query.getOrDefault("api-version")
  valid_564723 = validateParameter(valid_564723, JString, required = true,
                                 default = nil)
  if valid_564723 != nil:
    section.add "api-version", valid_564723
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564724: Call_SessionsGet_564716; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account session.
  ## 
  let valid = call_564724.validator(path, query, header, formData, body)
  let scheme = call_564724.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564724.url(scheme.get, call_564724.host, call_564724.base,
                         call_564724.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564724, url, valid)

proc call*(call_564725: Call_SessionsGet_564716; apiVersion: string;
          subscriptionId: string; sessionName: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## sessionsGet
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
  var path_564726 = newJObject()
  var query_564727 = newJObject()
  add(query_564727, "api-version", newJString(apiVersion))
  add(path_564726, "subscriptionId", newJString(subscriptionId))
  add(path_564726, "sessionName", newJString(sessionName))
  add(path_564726, "resourceGroupName", newJString(resourceGroupName))
  add(path_564726, "integrationAccountName", newJString(integrationAccountName))
  result = call_564725.call(path_564726, query_564727, nil, nil, nil)

var sessionsGet* = Call_SessionsGet_564716(name: "sessionsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
                                        validator: validate_SessionsGet_564717,
                                        base: "", url: url_SessionsGet_564718,
                                        schemes: {Scheme.Https})
type
  Call_SessionsDelete_564742 = ref object of OpenApiRestCall_563565
proc url_SessionsDelete_564744(protocol: Scheme; host: string; base: string;
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

proc validate_SessionsDelete_564743(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
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
  var valid_564745 = path.getOrDefault("subscriptionId")
  valid_564745 = validateParameter(valid_564745, JString, required = true,
                                 default = nil)
  if valid_564745 != nil:
    section.add "subscriptionId", valid_564745
  var valid_564746 = path.getOrDefault("sessionName")
  valid_564746 = validateParameter(valid_564746, JString, required = true,
                                 default = nil)
  if valid_564746 != nil:
    section.add "sessionName", valid_564746
  var valid_564747 = path.getOrDefault("resourceGroupName")
  valid_564747 = validateParameter(valid_564747, JString, required = true,
                                 default = nil)
  if valid_564747 != nil:
    section.add "resourceGroupName", valid_564747
  var valid_564748 = path.getOrDefault("integrationAccountName")
  valid_564748 = validateParameter(valid_564748, JString, required = true,
                                 default = nil)
  if valid_564748 != nil:
    section.add "integrationAccountName", valid_564748
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564749 = query.getOrDefault("api-version")
  valid_564749 = validateParameter(valid_564749, JString, required = true,
                                 default = nil)
  if valid_564749 != nil:
    section.add "api-version", valid_564749
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564750: Call_SessionsDelete_564742; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account session.
  ## 
  let valid = call_564750.validator(path, query, header, formData, body)
  let scheme = call_564750.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564750.url(scheme.get, call_564750.host, call_564750.base,
                         call_564750.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564750, url, valid)

proc call*(call_564751: Call_SessionsDelete_564742; apiVersion: string;
          subscriptionId: string; sessionName: string; resourceGroupName: string;
          integrationAccountName: string): Recallable =
  ## sessionsDelete
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
  var path_564752 = newJObject()
  var query_564753 = newJObject()
  add(query_564753, "api-version", newJString(apiVersion))
  add(path_564752, "subscriptionId", newJString(subscriptionId))
  add(path_564752, "sessionName", newJString(sessionName))
  add(path_564752, "resourceGroupName", newJString(resourceGroupName))
  add(path_564752, "integrationAccountName", newJString(integrationAccountName))
  result = call_564751.call(path_564752, query_564753, nil, nil, nil)

var sessionsDelete* = Call_SessionsDelete_564742(name: "sessionsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
    validator: validate_SessionsDelete_564743, base: "", url: url_SessionsDelete_564744,
    schemes: {Scheme.Https})
type
  Call_WorkflowsValidate_564754 = ref object of OpenApiRestCall_563565
proc url_WorkflowsValidate_564756(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_WorkflowsValidate_564755(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
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
  var valid_564757 = path.getOrDefault("workflowName")
  valid_564757 = validateParameter(valid_564757, JString, required = true,
                                 default = nil)
  if valid_564757 != nil:
    section.add "workflowName", valid_564757
  var valid_564758 = path.getOrDefault("subscriptionId")
  valid_564758 = validateParameter(valid_564758, JString, required = true,
                                 default = nil)
  if valid_564758 != nil:
    section.add "subscriptionId", valid_564758
  var valid_564759 = path.getOrDefault("location")
  valid_564759 = validateParameter(valid_564759, JString, required = true,
                                 default = nil)
  if valid_564759 != nil:
    section.add "location", valid_564759
  var valid_564760 = path.getOrDefault("resourceGroupName")
  valid_564760 = validateParameter(valid_564760, JString, required = true,
                                 default = nil)
  if valid_564760 != nil:
    section.add "resourceGroupName", valid_564760
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564761 = query.getOrDefault("api-version")
  valid_564761 = validateParameter(valid_564761, JString, required = true,
                                 default = nil)
  if valid_564761 != nil:
    section.add "api-version", valid_564761
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   workflow: JObject (required)
  ##           : The workflow definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564763: Call_WorkflowsValidate_564754; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the workflow definition.
  ## 
  let valid = call_564763.validator(path, query, header, formData, body)
  let scheme = call_564763.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564763.url(scheme.get, call_564763.host, call_564763.base,
                         call_564763.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564763, url, valid)

proc call*(call_564764: Call_WorkflowsValidate_564754; apiVersion: string;
          workflowName: string; subscriptionId: string; location: string;
          resourceGroupName: string; workflow: JsonNode): Recallable =
  ## workflowsValidate
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
  ##   workflow: JObject (required)
  ##           : The workflow definition.
  var path_564765 = newJObject()
  var query_564766 = newJObject()
  var body_564767 = newJObject()
  add(query_564766, "api-version", newJString(apiVersion))
  add(path_564765, "workflowName", newJString(workflowName))
  add(path_564765, "subscriptionId", newJString(subscriptionId))
  add(path_564765, "location", newJString(location))
  add(path_564765, "resourceGroupName", newJString(resourceGroupName))
  if workflow != nil:
    body_564767 = workflow
  result = call_564764.call(path_564765, query_564766, nil, nil, body_564767)

var workflowsValidate* = Call_WorkflowsValidate_564754(name: "workflowsValidate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/locations/{location}/workflows/{workflowName}/validate",
    validator: validate_WorkflowsValidate_564755, base: "",
    url: url_WorkflowsValidate_564756, schemes: {Scheme.Https})
type
  Call_WorkflowsListByResourceGroup_564768 = ref object of OpenApiRestCall_563565
proc url_WorkflowsListByResourceGroup_564770(protocol: Scheme; host: string;
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

proc validate_WorkflowsListByResourceGroup_564769(path: JsonNode; query: JsonNode;
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
  var valid_564771 = path.getOrDefault("subscriptionId")
  valid_564771 = validateParameter(valid_564771, JString, required = true,
                                 default = nil)
  if valid_564771 != nil:
    section.add "subscriptionId", valid_564771
  var valid_564772 = path.getOrDefault("resourceGroupName")
  valid_564772 = validateParameter(valid_564772, JString, required = true,
                                 default = nil)
  if valid_564772 != nil:
    section.add "resourceGroupName", valid_564772
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
  var valid_564773 = query.getOrDefault("api-version")
  valid_564773 = validateParameter(valid_564773, JString, required = true,
                                 default = nil)
  if valid_564773 != nil:
    section.add "api-version", valid_564773
  var valid_564774 = query.getOrDefault("$top")
  valid_564774 = validateParameter(valid_564774, JInt, required = false, default = nil)
  if valid_564774 != nil:
    section.add "$top", valid_564774
  var valid_564775 = query.getOrDefault("$filter")
  valid_564775 = validateParameter(valid_564775, JString, required = false,
                                 default = nil)
  if valid_564775 != nil:
    section.add "$filter", valid_564775
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564776: Call_WorkflowsListByResourceGroup_564768; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflows by resource group.
  ## 
  let valid = call_564776.validator(path, query, header, formData, body)
  let scheme = call_564776.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564776.url(scheme.get, call_564776.host, call_564776.base,
                         call_564776.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564776, url, valid)

proc call*(call_564777: Call_WorkflowsListByResourceGroup_564768;
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
  var path_564778 = newJObject()
  var query_564779 = newJObject()
  add(query_564779, "api-version", newJString(apiVersion))
  add(query_564779, "$top", newJInt(Top))
  add(path_564778, "subscriptionId", newJString(subscriptionId))
  add(path_564778, "resourceGroupName", newJString(resourceGroupName))
  add(query_564779, "$filter", newJString(Filter))
  result = call_564777.call(path_564778, query_564779, nil, nil, nil)

var workflowsListByResourceGroup* = Call_WorkflowsListByResourceGroup_564768(
    name: "workflowsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows",
    validator: validate_WorkflowsListByResourceGroup_564769, base: "",
    url: url_WorkflowsListByResourceGroup_564770, schemes: {Scheme.Https})
type
  Call_WorkflowsCreateOrUpdate_564791 = ref object of OpenApiRestCall_563565
proc url_WorkflowsCreateOrUpdate_564793(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsCreateOrUpdate_564792(path: JsonNode; query: JsonNode;
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
  var valid_564794 = path.getOrDefault("workflowName")
  valid_564794 = validateParameter(valid_564794, JString, required = true,
                                 default = nil)
  if valid_564794 != nil:
    section.add "workflowName", valid_564794
  var valid_564795 = path.getOrDefault("subscriptionId")
  valid_564795 = validateParameter(valid_564795, JString, required = true,
                                 default = nil)
  if valid_564795 != nil:
    section.add "subscriptionId", valid_564795
  var valid_564796 = path.getOrDefault("resourceGroupName")
  valid_564796 = validateParameter(valid_564796, JString, required = true,
                                 default = nil)
  if valid_564796 != nil:
    section.add "resourceGroupName", valid_564796
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564797 = query.getOrDefault("api-version")
  valid_564797 = validateParameter(valid_564797, JString, required = true,
                                 default = nil)
  if valid_564797 != nil:
    section.add "api-version", valid_564797
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

proc call*(call_564799: Call_WorkflowsCreateOrUpdate_564791; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a workflow.
  ## 
  let valid = call_564799.validator(path, query, header, formData, body)
  let scheme = call_564799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564799.url(scheme.get, call_564799.host, call_564799.base,
                         call_564799.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564799, url, valid)

proc call*(call_564800: Call_WorkflowsCreateOrUpdate_564791; apiVersion: string;
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
  var path_564801 = newJObject()
  var query_564802 = newJObject()
  var body_564803 = newJObject()
  add(query_564802, "api-version", newJString(apiVersion))
  add(path_564801, "workflowName", newJString(workflowName))
  add(path_564801, "subscriptionId", newJString(subscriptionId))
  add(path_564801, "resourceGroupName", newJString(resourceGroupName))
  if workflow != nil:
    body_564803 = workflow
  result = call_564800.call(path_564801, query_564802, nil, nil, body_564803)

var workflowsCreateOrUpdate* = Call_WorkflowsCreateOrUpdate_564791(
    name: "workflowsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsCreateOrUpdate_564792, base: "",
    url: url_WorkflowsCreateOrUpdate_564793, schemes: {Scheme.Https})
type
  Call_WorkflowsGet_564780 = ref object of OpenApiRestCall_563565
proc url_WorkflowsGet_564782(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsGet_564781(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564783 = path.getOrDefault("workflowName")
  valid_564783 = validateParameter(valid_564783, JString, required = true,
                                 default = nil)
  if valid_564783 != nil:
    section.add "workflowName", valid_564783
  var valid_564784 = path.getOrDefault("subscriptionId")
  valid_564784 = validateParameter(valid_564784, JString, required = true,
                                 default = nil)
  if valid_564784 != nil:
    section.add "subscriptionId", valid_564784
  var valid_564785 = path.getOrDefault("resourceGroupName")
  valid_564785 = validateParameter(valid_564785, JString, required = true,
                                 default = nil)
  if valid_564785 != nil:
    section.add "resourceGroupName", valid_564785
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564786 = query.getOrDefault("api-version")
  valid_564786 = validateParameter(valid_564786, JString, required = true,
                                 default = nil)
  if valid_564786 != nil:
    section.add "api-version", valid_564786
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564787: Call_WorkflowsGet_564780; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow.
  ## 
  let valid = call_564787.validator(path, query, header, formData, body)
  let scheme = call_564787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564787.url(scheme.get, call_564787.host, call_564787.base,
                         call_564787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564787, url, valid)

proc call*(call_564788: Call_WorkflowsGet_564780; apiVersion: string;
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
  var path_564789 = newJObject()
  var query_564790 = newJObject()
  add(query_564790, "api-version", newJString(apiVersion))
  add(path_564789, "workflowName", newJString(workflowName))
  add(path_564789, "subscriptionId", newJString(subscriptionId))
  add(path_564789, "resourceGroupName", newJString(resourceGroupName))
  result = call_564788.call(path_564789, query_564790, nil, nil, nil)

var workflowsGet* = Call_WorkflowsGet_564780(name: "workflowsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsGet_564781, base: "", url: url_WorkflowsGet_564782,
    schemes: {Scheme.Https})
type
  Call_WorkflowsUpdate_564815 = ref object of OpenApiRestCall_563565
proc url_WorkflowsUpdate_564817(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsUpdate_564816(path: JsonNode; query: JsonNode;
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
  var valid_564818 = path.getOrDefault("workflowName")
  valid_564818 = validateParameter(valid_564818, JString, required = true,
                                 default = nil)
  if valid_564818 != nil:
    section.add "workflowName", valid_564818
  var valid_564819 = path.getOrDefault("subscriptionId")
  valid_564819 = validateParameter(valid_564819, JString, required = true,
                                 default = nil)
  if valid_564819 != nil:
    section.add "subscriptionId", valid_564819
  var valid_564820 = path.getOrDefault("resourceGroupName")
  valid_564820 = validateParameter(valid_564820, JString, required = true,
                                 default = nil)
  if valid_564820 != nil:
    section.add "resourceGroupName", valid_564820
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564821 = query.getOrDefault("api-version")
  valid_564821 = validateParameter(valid_564821, JString, required = true,
                                 default = nil)
  if valid_564821 != nil:
    section.add "api-version", valid_564821
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

proc call*(call_564823: Call_WorkflowsUpdate_564815; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a workflow.
  ## 
  let valid = call_564823.validator(path, query, header, formData, body)
  let scheme = call_564823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564823.url(scheme.get, call_564823.host, call_564823.base,
                         call_564823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564823, url, valid)

proc call*(call_564824: Call_WorkflowsUpdate_564815; apiVersion: string;
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
  var path_564825 = newJObject()
  var query_564826 = newJObject()
  var body_564827 = newJObject()
  add(query_564826, "api-version", newJString(apiVersion))
  add(path_564825, "workflowName", newJString(workflowName))
  add(path_564825, "subscriptionId", newJString(subscriptionId))
  add(path_564825, "resourceGroupName", newJString(resourceGroupName))
  if workflow != nil:
    body_564827 = workflow
  result = call_564824.call(path_564825, query_564826, nil, nil, body_564827)

var workflowsUpdate* = Call_WorkflowsUpdate_564815(name: "workflowsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsUpdate_564816, base: "", url: url_WorkflowsUpdate_564817,
    schemes: {Scheme.Https})
type
  Call_WorkflowsDelete_564804 = ref object of OpenApiRestCall_563565
proc url_WorkflowsDelete_564806(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsDelete_564805(path: JsonNode; query: JsonNode;
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
  var valid_564807 = path.getOrDefault("workflowName")
  valid_564807 = validateParameter(valid_564807, JString, required = true,
                                 default = nil)
  if valid_564807 != nil:
    section.add "workflowName", valid_564807
  var valid_564808 = path.getOrDefault("subscriptionId")
  valid_564808 = validateParameter(valid_564808, JString, required = true,
                                 default = nil)
  if valid_564808 != nil:
    section.add "subscriptionId", valid_564808
  var valid_564809 = path.getOrDefault("resourceGroupName")
  valid_564809 = validateParameter(valid_564809, JString, required = true,
                                 default = nil)
  if valid_564809 != nil:
    section.add "resourceGroupName", valid_564809
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564810 = query.getOrDefault("api-version")
  valid_564810 = validateParameter(valid_564810, JString, required = true,
                                 default = nil)
  if valid_564810 != nil:
    section.add "api-version", valid_564810
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564811: Call_WorkflowsDelete_564804; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a workflow.
  ## 
  let valid = call_564811.validator(path, query, header, formData, body)
  let scheme = call_564811.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564811.url(scheme.get, call_564811.host, call_564811.base,
                         call_564811.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564811, url, valid)

proc call*(call_564812: Call_WorkflowsDelete_564804; apiVersion: string;
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
  var path_564813 = newJObject()
  var query_564814 = newJObject()
  add(query_564814, "api-version", newJString(apiVersion))
  add(path_564813, "workflowName", newJString(workflowName))
  add(path_564813, "subscriptionId", newJString(subscriptionId))
  add(path_564813, "resourceGroupName", newJString(resourceGroupName))
  result = call_564812.call(path_564813, query_564814, nil, nil, nil)

var workflowsDelete* = Call_WorkflowsDelete_564804(name: "workflowsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsDelete_564805, base: "", url: url_WorkflowsDelete_564806,
    schemes: {Scheme.Https})
type
  Call_WorkflowsDisable_564828 = ref object of OpenApiRestCall_563565
proc url_WorkflowsDisable_564830(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsDisable_564829(path: JsonNode; query: JsonNode;
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
  var valid_564831 = path.getOrDefault("workflowName")
  valid_564831 = validateParameter(valid_564831, JString, required = true,
                                 default = nil)
  if valid_564831 != nil:
    section.add "workflowName", valid_564831
  var valid_564832 = path.getOrDefault("subscriptionId")
  valid_564832 = validateParameter(valid_564832, JString, required = true,
                                 default = nil)
  if valid_564832 != nil:
    section.add "subscriptionId", valid_564832
  var valid_564833 = path.getOrDefault("resourceGroupName")
  valid_564833 = validateParameter(valid_564833, JString, required = true,
                                 default = nil)
  if valid_564833 != nil:
    section.add "resourceGroupName", valid_564833
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564834 = query.getOrDefault("api-version")
  valid_564834 = validateParameter(valid_564834, JString, required = true,
                                 default = nil)
  if valid_564834 != nil:
    section.add "api-version", valid_564834
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564835: Call_WorkflowsDisable_564828; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disables a workflow.
  ## 
  let valid = call_564835.validator(path, query, header, formData, body)
  let scheme = call_564835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564835.url(scheme.get, call_564835.host, call_564835.base,
                         call_564835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564835, url, valid)

proc call*(call_564836: Call_WorkflowsDisable_564828; apiVersion: string;
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
  var path_564837 = newJObject()
  var query_564838 = newJObject()
  add(query_564838, "api-version", newJString(apiVersion))
  add(path_564837, "workflowName", newJString(workflowName))
  add(path_564837, "subscriptionId", newJString(subscriptionId))
  add(path_564837, "resourceGroupName", newJString(resourceGroupName))
  result = call_564836.call(path_564837, query_564838, nil, nil, nil)

var workflowsDisable* = Call_WorkflowsDisable_564828(name: "workflowsDisable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/disable",
    validator: validate_WorkflowsDisable_564829, base: "",
    url: url_WorkflowsDisable_564830, schemes: {Scheme.Https})
type
  Call_WorkflowsEnable_564839 = ref object of OpenApiRestCall_563565
proc url_WorkflowsEnable_564841(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsEnable_564840(path: JsonNode; query: JsonNode;
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
  var valid_564842 = path.getOrDefault("workflowName")
  valid_564842 = validateParameter(valid_564842, JString, required = true,
                                 default = nil)
  if valid_564842 != nil:
    section.add "workflowName", valid_564842
  var valid_564843 = path.getOrDefault("subscriptionId")
  valid_564843 = validateParameter(valid_564843, JString, required = true,
                                 default = nil)
  if valid_564843 != nil:
    section.add "subscriptionId", valid_564843
  var valid_564844 = path.getOrDefault("resourceGroupName")
  valid_564844 = validateParameter(valid_564844, JString, required = true,
                                 default = nil)
  if valid_564844 != nil:
    section.add "resourceGroupName", valid_564844
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564845 = query.getOrDefault("api-version")
  valid_564845 = validateParameter(valid_564845, JString, required = true,
                                 default = nil)
  if valid_564845 != nil:
    section.add "api-version", valid_564845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564846: Call_WorkflowsEnable_564839; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables a workflow.
  ## 
  let valid = call_564846.validator(path, query, header, formData, body)
  let scheme = call_564846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564846.url(scheme.get, call_564846.host, call_564846.base,
                         call_564846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564846, url, valid)

proc call*(call_564847: Call_WorkflowsEnable_564839; apiVersion: string;
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
  var path_564848 = newJObject()
  var query_564849 = newJObject()
  add(query_564849, "api-version", newJString(apiVersion))
  add(path_564848, "workflowName", newJString(workflowName))
  add(path_564848, "subscriptionId", newJString(subscriptionId))
  add(path_564848, "resourceGroupName", newJString(resourceGroupName))
  result = call_564847.call(path_564848, query_564849, nil, nil, nil)

var workflowsEnable* = Call_WorkflowsEnable_564839(name: "workflowsEnable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/enable",
    validator: validate_WorkflowsEnable_564840, base: "", url: url_WorkflowsEnable_564841,
    schemes: {Scheme.Https})
type
  Call_WorkflowsGenerateUpgradedDefinition_564850 = ref object of OpenApiRestCall_563565
proc url_WorkflowsGenerateUpgradedDefinition_564852(protocol: Scheme; host: string;
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

proc validate_WorkflowsGenerateUpgradedDefinition_564851(path: JsonNode;
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
  var valid_564853 = path.getOrDefault("workflowName")
  valid_564853 = validateParameter(valid_564853, JString, required = true,
                                 default = nil)
  if valid_564853 != nil:
    section.add "workflowName", valid_564853
  var valid_564854 = path.getOrDefault("subscriptionId")
  valid_564854 = validateParameter(valid_564854, JString, required = true,
                                 default = nil)
  if valid_564854 != nil:
    section.add "subscriptionId", valid_564854
  var valid_564855 = path.getOrDefault("resourceGroupName")
  valid_564855 = validateParameter(valid_564855, JString, required = true,
                                 default = nil)
  if valid_564855 != nil:
    section.add "resourceGroupName", valid_564855
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564856 = query.getOrDefault("api-version")
  valid_564856 = validateParameter(valid_564856, JString, required = true,
                                 default = nil)
  if valid_564856 != nil:
    section.add "api-version", valid_564856
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

proc call*(call_564858: Call_WorkflowsGenerateUpgradedDefinition_564850;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates the upgraded definition for a workflow.
  ## 
  let valid = call_564858.validator(path, query, header, formData, body)
  let scheme = call_564858.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564858.url(scheme.get, call_564858.host, call_564858.base,
                         call_564858.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564858, url, valid)

proc call*(call_564859: Call_WorkflowsGenerateUpgradedDefinition_564850;
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
  var path_564860 = newJObject()
  var query_564861 = newJObject()
  var body_564862 = newJObject()
  add(query_564861, "api-version", newJString(apiVersion))
  add(path_564860, "workflowName", newJString(workflowName))
  add(path_564860, "subscriptionId", newJString(subscriptionId))
  add(path_564860, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564862 = parameters
  result = call_564859.call(path_564860, query_564861, nil, nil, body_564862)

var workflowsGenerateUpgradedDefinition* = Call_WorkflowsGenerateUpgradedDefinition_564850(
    name: "workflowsGenerateUpgradedDefinition", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/generateUpgradedDefinition",
    validator: validate_WorkflowsGenerateUpgradedDefinition_564851, base: "",
    url: url_WorkflowsGenerateUpgradedDefinition_564852, schemes: {Scheme.Https})
type
  Call_WorkflowsListCallbackUrl_564863 = ref object of OpenApiRestCall_563565
proc url_WorkflowsListCallbackUrl_564865(protocol: Scheme; host: string;
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

proc validate_WorkflowsListCallbackUrl_564864(path: JsonNode; query: JsonNode;
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
  var valid_564866 = path.getOrDefault("workflowName")
  valid_564866 = validateParameter(valid_564866, JString, required = true,
                                 default = nil)
  if valid_564866 != nil:
    section.add "workflowName", valid_564866
  var valid_564867 = path.getOrDefault("subscriptionId")
  valid_564867 = validateParameter(valid_564867, JString, required = true,
                                 default = nil)
  if valid_564867 != nil:
    section.add "subscriptionId", valid_564867
  var valid_564868 = path.getOrDefault("resourceGroupName")
  valid_564868 = validateParameter(valid_564868, JString, required = true,
                                 default = nil)
  if valid_564868 != nil:
    section.add "resourceGroupName", valid_564868
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564869 = query.getOrDefault("api-version")
  valid_564869 = validateParameter(valid_564869, JString, required = true,
                                 default = nil)
  if valid_564869 != nil:
    section.add "api-version", valid_564869
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

proc call*(call_564871: Call_WorkflowsListCallbackUrl_564863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the workflow callback Url.
  ## 
  let valid = call_564871.validator(path, query, header, formData, body)
  let scheme = call_564871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564871.url(scheme.get, call_564871.host, call_564871.base,
                         call_564871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564871, url, valid)

proc call*(call_564872: Call_WorkflowsListCallbackUrl_564863; apiVersion: string;
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
  var path_564873 = newJObject()
  var query_564874 = newJObject()
  var body_564875 = newJObject()
  add(query_564874, "api-version", newJString(apiVersion))
  add(path_564873, "workflowName", newJString(workflowName))
  add(path_564873, "subscriptionId", newJString(subscriptionId))
  add(path_564873, "resourceGroupName", newJString(resourceGroupName))
  if listCallbackUrl != nil:
    body_564875 = listCallbackUrl
  result = call_564872.call(path_564873, query_564874, nil, nil, body_564875)

var workflowsListCallbackUrl* = Call_WorkflowsListCallbackUrl_564863(
    name: "workflowsListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/listCallbackUrl",
    validator: validate_WorkflowsListCallbackUrl_564864, base: "",
    url: url_WorkflowsListCallbackUrl_564865, schemes: {Scheme.Https})
type
  Call_WorkflowsListSwagger_564876 = ref object of OpenApiRestCall_563565
proc url_WorkflowsListSwagger_564878(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsListSwagger_564877(path: JsonNode; query: JsonNode;
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
  var valid_564879 = path.getOrDefault("workflowName")
  valid_564879 = validateParameter(valid_564879, JString, required = true,
                                 default = nil)
  if valid_564879 != nil:
    section.add "workflowName", valid_564879
  var valid_564880 = path.getOrDefault("subscriptionId")
  valid_564880 = validateParameter(valid_564880, JString, required = true,
                                 default = nil)
  if valid_564880 != nil:
    section.add "subscriptionId", valid_564880
  var valid_564881 = path.getOrDefault("resourceGroupName")
  valid_564881 = validateParameter(valid_564881, JString, required = true,
                                 default = nil)
  if valid_564881 != nil:
    section.add "resourceGroupName", valid_564881
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564882 = query.getOrDefault("api-version")
  valid_564882 = validateParameter(valid_564882, JString, required = true,
                                 default = nil)
  if valid_564882 != nil:
    section.add "api-version", valid_564882
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564883: Call_WorkflowsListSwagger_564876; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an OpenAPI definition for the workflow.
  ## 
  let valid = call_564883.validator(path, query, header, formData, body)
  let scheme = call_564883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564883.url(scheme.get, call_564883.host, call_564883.base,
                         call_564883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564883, url, valid)

proc call*(call_564884: Call_WorkflowsListSwagger_564876; apiVersion: string;
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
  var path_564885 = newJObject()
  var query_564886 = newJObject()
  add(query_564886, "api-version", newJString(apiVersion))
  add(path_564885, "workflowName", newJString(workflowName))
  add(path_564885, "subscriptionId", newJString(subscriptionId))
  add(path_564885, "resourceGroupName", newJString(resourceGroupName))
  result = call_564884.call(path_564885, query_564886, nil, nil, nil)

var workflowsListSwagger* = Call_WorkflowsListSwagger_564876(
    name: "workflowsListSwagger", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/listSwagger",
    validator: validate_WorkflowsListSwagger_564877, base: "",
    url: url_WorkflowsListSwagger_564878, schemes: {Scheme.Https})
type
  Call_WorkflowsMove_564887 = ref object of OpenApiRestCall_563565
proc url_WorkflowsMove_564889(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsMove_564888(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564890 = path.getOrDefault("workflowName")
  valid_564890 = validateParameter(valid_564890, JString, required = true,
                                 default = nil)
  if valid_564890 != nil:
    section.add "workflowName", valid_564890
  var valid_564891 = path.getOrDefault("subscriptionId")
  valid_564891 = validateParameter(valid_564891, JString, required = true,
                                 default = nil)
  if valid_564891 != nil:
    section.add "subscriptionId", valid_564891
  var valid_564892 = path.getOrDefault("resourceGroupName")
  valid_564892 = validateParameter(valid_564892, JString, required = true,
                                 default = nil)
  if valid_564892 != nil:
    section.add "resourceGroupName", valid_564892
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564893 = query.getOrDefault("api-version")
  valid_564893 = validateParameter(valid_564893, JString, required = true,
                                 default = nil)
  if valid_564893 != nil:
    section.add "api-version", valid_564893
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

proc call*(call_564895: Call_WorkflowsMove_564887; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves an existing workflow.
  ## 
  let valid = call_564895.validator(path, query, header, formData, body)
  let scheme = call_564895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564895.url(scheme.get, call_564895.host, call_564895.base,
                         call_564895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564895, url, valid)

proc call*(call_564896: Call_WorkflowsMove_564887; apiVersion: string;
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
  var path_564897 = newJObject()
  var query_564898 = newJObject()
  var body_564899 = newJObject()
  add(query_564898, "api-version", newJString(apiVersion))
  add(path_564897, "workflowName", newJString(workflowName))
  add(path_564897, "subscriptionId", newJString(subscriptionId))
  if move != nil:
    body_564899 = move
  add(path_564897, "resourceGroupName", newJString(resourceGroupName))
  result = call_564896.call(path_564897, query_564898, nil, nil, body_564899)

var workflowsMove* = Call_WorkflowsMove_564887(name: "workflowsMove",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/move",
    validator: validate_WorkflowsMove_564888, base: "", url: url_WorkflowsMove_564889,
    schemes: {Scheme.Https})
type
  Call_WorkflowsRegenerateAccessKey_564900 = ref object of OpenApiRestCall_563565
proc url_WorkflowsRegenerateAccessKey_564902(protocol: Scheme; host: string;
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

proc validate_WorkflowsRegenerateAccessKey_564901(path: JsonNode; query: JsonNode;
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
  var valid_564903 = path.getOrDefault("workflowName")
  valid_564903 = validateParameter(valid_564903, JString, required = true,
                                 default = nil)
  if valid_564903 != nil:
    section.add "workflowName", valid_564903
  var valid_564904 = path.getOrDefault("subscriptionId")
  valid_564904 = validateParameter(valid_564904, JString, required = true,
                                 default = nil)
  if valid_564904 != nil:
    section.add "subscriptionId", valid_564904
  var valid_564905 = path.getOrDefault("resourceGroupName")
  valid_564905 = validateParameter(valid_564905, JString, required = true,
                                 default = nil)
  if valid_564905 != nil:
    section.add "resourceGroupName", valid_564905
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564906 = query.getOrDefault("api-version")
  valid_564906 = validateParameter(valid_564906, JString, required = true,
                                 default = nil)
  if valid_564906 != nil:
    section.add "api-version", valid_564906
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

proc call*(call_564908: Call_WorkflowsRegenerateAccessKey_564900; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the callback URL access key for request triggers.
  ## 
  let valid = call_564908.validator(path, query, header, formData, body)
  let scheme = call_564908.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564908.url(scheme.get, call_564908.host, call_564908.base,
                         call_564908.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564908, url, valid)

proc call*(call_564909: Call_WorkflowsRegenerateAccessKey_564900;
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
  var path_564910 = newJObject()
  var query_564911 = newJObject()
  var body_564912 = newJObject()
  add(query_564911, "api-version", newJString(apiVersion))
  if keyType != nil:
    body_564912 = keyType
  add(path_564910, "workflowName", newJString(workflowName))
  add(path_564910, "subscriptionId", newJString(subscriptionId))
  add(path_564910, "resourceGroupName", newJString(resourceGroupName))
  result = call_564909.call(path_564910, query_564911, nil, nil, body_564912)

var workflowsRegenerateAccessKey* = Call_WorkflowsRegenerateAccessKey_564900(
    name: "workflowsRegenerateAccessKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/regenerateAccessKey",
    validator: validate_WorkflowsRegenerateAccessKey_564901, base: "",
    url: url_WorkflowsRegenerateAccessKey_564902, schemes: {Scheme.Https})
type
  Call_WorkflowRunsList_564913 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunsList_564915(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsList_564914(path: JsonNode; query: JsonNode;
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
  var valid_564916 = path.getOrDefault("workflowName")
  valid_564916 = validateParameter(valid_564916, JString, required = true,
                                 default = nil)
  if valid_564916 != nil:
    section.add "workflowName", valid_564916
  var valid_564917 = path.getOrDefault("subscriptionId")
  valid_564917 = validateParameter(valid_564917, JString, required = true,
                                 default = nil)
  if valid_564917 != nil:
    section.add "subscriptionId", valid_564917
  var valid_564918 = path.getOrDefault("resourceGroupName")
  valid_564918 = validateParameter(valid_564918, JString, required = true,
                                 default = nil)
  if valid_564918 != nil:
    section.add "resourceGroupName", valid_564918
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
  var valid_564919 = query.getOrDefault("api-version")
  valid_564919 = validateParameter(valid_564919, JString, required = true,
                                 default = nil)
  if valid_564919 != nil:
    section.add "api-version", valid_564919
  var valid_564920 = query.getOrDefault("$top")
  valid_564920 = validateParameter(valid_564920, JInt, required = false, default = nil)
  if valid_564920 != nil:
    section.add "$top", valid_564920
  var valid_564921 = query.getOrDefault("$filter")
  valid_564921 = validateParameter(valid_564921, JString, required = false,
                                 default = nil)
  if valid_564921 != nil:
    section.add "$filter", valid_564921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564922: Call_WorkflowRunsList_564913; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow runs.
  ## 
  let valid = call_564922.validator(path, query, header, formData, body)
  let scheme = call_564922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564922.url(scheme.get, call_564922.host, call_564922.base,
                         call_564922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564922, url, valid)

proc call*(call_564923: Call_WorkflowRunsList_564913; apiVersion: string;
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
  var path_564924 = newJObject()
  var query_564925 = newJObject()
  add(query_564925, "api-version", newJString(apiVersion))
  add(query_564925, "$top", newJInt(Top))
  add(path_564924, "workflowName", newJString(workflowName))
  add(path_564924, "subscriptionId", newJString(subscriptionId))
  add(path_564924, "resourceGroupName", newJString(resourceGroupName))
  add(query_564925, "$filter", newJString(Filter))
  result = call_564923.call(path_564924, query_564925, nil, nil, nil)

var workflowRunsList* = Call_WorkflowRunsList_564913(name: "workflowRunsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs",
    validator: validate_WorkflowRunsList_564914, base: "",
    url: url_WorkflowRunsList_564915, schemes: {Scheme.Https})
type
  Call_WorkflowRunsGet_564926 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunsGet_564928(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsGet_564927(path: JsonNode; query: JsonNode;
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
  var valid_564929 = path.getOrDefault("runName")
  valid_564929 = validateParameter(valid_564929, JString, required = true,
                                 default = nil)
  if valid_564929 != nil:
    section.add "runName", valid_564929
  var valid_564930 = path.getOrDefault("workflowName")
  valid_564930 = validateParameter(valid_564930, JString, required = true,
                                 default = nil)
  if valid_564930 != nil:
    section.add "workflowName", valid_564930
  var valid_564931 = path.getOrDefault("subscriptionId")
  valid_564931 = validateParameter(valid_564931, JString, required = true,
                                 default = nil)
  if valid_564931 != nil:
    section.add "subscriptionId", valid_564931
  var valid_564932 = path.getOrDefault("resourceGroupName")
  valid_564932 = validateParameter(valid_564932, JString, required = true,
                                 default = nil)
  if valid_564932 != nil:
    section.add "resourceGroupName", valid_564932
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564933 = query.getOrDefault("api-version")
  valid_564933 = validateParameter(valid_564933, JString, required = true,
                                 default = nil)
  if valid_564933 != nil:
    section.add "api-version", valid_564933
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564934: Call_WorkflowRunsGet_564926; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow run.
  ## 
  let valid = call_564934.validator(path, query, header, formData, body)
  let scheme = call_564934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564934.url(scheme.get, call_564934.host, call_564934.base,
                         call_564934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564934, url, valid)

proc call*(call_564935: Call_WorkflowRunsGet_564926; runName: string;
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
  var path_564936 = newJObject()
  var query_564937 = newJObject()
  add(path_564936, "runName", newJString(runName))
  add(query_564937, "api-version", newJString(apiVersion))
  add(path_564936, "workflowName", newJString(workflowName))
  add(path_564936, "subscriptionId", newJString(subscriptionId))
  add(path_564936, "resourceGroupName", newJString(resourceGroupName))
  result = call_564935.call(path_564936, query_564937, nil, nil, nil)

var workflowRunsGet* = Call_WorkflowRunsGet_564926(name: "workflowRunsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}",
    validator: validate_WorkflowRunsGet_564927, base: "", url: url_WorkflowRunsGet_564928,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunsDelete_564938 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunsDelete_564940(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsDelete_564939(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a workflow run.
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
  var valid_564941 = path.getOrDefault("runName")
  valid_564941 = validateParameter(valid_564941, JString, required = true,
                                 default = nil)
  if valid_564941 != nil:
    section.add "runName", valid_564941
  var valid_564942 = path.getOrDefault("workflowName")
  valid_564942 = validateParameter(valid_564942, JString, required = true,
                                 default = nil)
  if valid_564942 != nil:
    section.add "workflowName", valid_564942
  var valid_564943 = path.getOrDefault("subscriptionId")
  valid_564943 = validateParameter(valid_564943, JString, required = true,
                                 default = nil)
  if valid_564943 != nil:
    section.add "subscriptionId", valid_564943
  var valid_564944 = path.getOrDefault("resourceGroupName")
  valid_564944 = validateParameter(valid_564944, JString, required = true,
                                 default = nil)
  if valid_564944 != nil:
    section.add "resourceGroupName", valid_564944
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564945 = query.getOrDefault("api-version")
  valid_564945 = validateParameter(valid_564945, JString, required = true,
                                 default = nil)
  if valid_564945 != nil:
    section.add "api-version", valid_564945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564946: Call_WorkflowRunsDelete_564938; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a workflow run.
  ## 
  let valid = call_564946.validator(path, query, header, formData, body)
  let scheme = call_564946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564946.url(scheme.get, call_564946.host, call_564946.base,
                         call_564946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564946, url, valid)

proc call*(call_564947: Call_WorkflowRunsDelete_564938; runName: string;
          apiVersion: string; workflowName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## workflowRunsDelete
  ## Deletes a workflow run.
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
  var path_564948 = newJObject()
  var query_564949 = newJObject()
  add(path_564948, "runName", newJString(runName))
  add(query_564949, "api-version", newJString(apiVersion))
  add(path_564948, "workflowName", newJString(workflowName))
  add(path_564948, "subscriptionId", newJString(subscriptionId))
  add(path_564948, "resourceGroupName", newJString(resourceGroupName))
  result = call_564947.call(path_564948, query_564949, nil, nil, nil)

var workflowRunsDelete* = Call_WorkflowRunsDelete_564938(
    name: "workflowRunsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}",
    validator: validate_WorkflowRunsDelete_564939, base: "",
    url: url_WorkflowRunsDelete_564940, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsList_564950 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionsList_564952(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunActionsList_564951(path: JsonNode; query: JsonNode;
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
  var valid_564953 = path.getOrDefault("runName")
  valid_564953 = validateParameter(valid_564953, JString, required = true,
                                 default = nil)
  if valid_564953 != nil:
    section.add "runName", valid_564953
  var valid_564954 = path.getOrDefault("workflowName")
  valid_564954 = validateParameter(valid_564954, JString, required = true,
                                 default = nil)
  if valid_564954 != nil:
    section.add "workflowName", valid_564954
  var valid_564955 = path.getOrDefault("subscriptionId")
  valid_564955 = validateParameter(valid_564955, JString, required = true,
                                 default = nil)
  if valid_564955 != nil:
    section.add "subscriptionId", valid_564955
  var valid_564956 = path.getOrDefault("resourceGroupName")
  valid_564956 = validateParameter(valid_564956, JString, required = true,
                                 default = nil)
  if valid_564956 != nil:
    section.add "resourceGroupName", valid_564956
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
  var valid_564957 = query.getOrDefault("api-version")
  valid_564957 = validateParameter(valid_564957, JString, required = true,
                                 default = nil)
  if valid_564957 != nil:
    section.add "api-version", valid_564957
  var valid_564958 = query.getOrDefault("$top")
  valid_564958 = validateParameter(valid_564958, JInt, required = false, default = nil)
  if valid_564958 != nil:
    section.add "$top", valid_564958
  var valid_564959 = query.getOrDefault("$filter")
  valid_564959 = validateParameter(valid_564959, JString, required = false,
                                 default = nil)
  if valid_564959 != nil:
    section.add "$filter", valid_564959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564960: Call_WorkflowRunActionsList_564950; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow run actions.
  ## 
  let valid = call_564960.validator(path, query, header, formData, body)
  let scheme = call_564960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564960.url(scheme.get, call_564960.host, call_564960.base,
                         call_564960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564960, url, valid)

proc call*(call_564961: Call_WorkflowRunActionsList_564950; runName: string;
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
  var path_564962 = newJObject()
  var query_564963 = newJObject()
  add(path_564962, "runName", newJString(runName))
  add(query_564963, "api-version", newJString(apiVersion))
  add(query_564963, "$top", newJInt(Top))
  add(path_564962, "workflowName", newJString(workflowName))
  add(path_564962, "subscriptionId", newJString(subscriptionId))
  add(path_564962, "resourceGroupName", newJString(resourceGroupName))
  add(query_564963, "$filter", newJString(Filter))
  result = call_564961.call(path_564962, query_564963, nil, nil, nil)

var workflowRunActionsList* = Call_WorkflowRunActionsList_564950(
    name: "workflowRunActionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions",
    validator: validate_WorkflowRunActionsList_564951, base: "",
    url: url_WorkflowRunActionsList_564952, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsGet_564964 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionsGet_564966(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunActionsGet_564965(path: JsonNode; query: JsonNode;
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
  var valid_564967 = path.getOrDefault("runName")
  valid_564967 = validateParameter(valid_564967, JString, required = true,
                                 default = nil)
  if valid_564967 != nil:
    section.add "runName", valid_564967
  var valid_564968 = path.getOrDefault("workflowName")
  valid_564968 = validateParameter(valid_564968, JString, required = true,
                                 default = nil)
  if valid_564968 != nil:
    section.add "workflowName", valid_564968
  var valid_564969 = path.getOrDefault("subscriptionId")
  valid_564969 = validateParameter(valid_564969, JString, required = true,
                                 default = nil)
  if valid_564969 != nil:
    section.add "subscriptionId", valid_564969
  var valid_564970 = path.getOrDefault("actionName")
  valid_564970 = validateParameter(valid_564970, JString, required = true,
                                 default = nil)
  if valid_564970 != nil:
    section.add "actionName", valid_564970
  var valid_564971 = path.getOrDefault("resourceGroupName")
  valid_564971 = validateParameter(valid_564971, JString, required = true,
                                 default = nil)
  if valid_564971 != nil:
    section.add "resourceGroupName", valid_564971
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564972 = query.getOrDefault("api-version")
  valid_564972 = validateParameter(valid_564972, JString, required = true,
                                 default = nil)
  if valid_564972 != nil:
    section.add "api-version", valid_564972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564973: Call_WorkflowRunActionsGet_564964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow run action.
  ## 
  let valid = call_564973.validator(path, query, header, formData, body)
  let scheme = call_564973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564973.url(scheme.get, call_564973.host, call_564973.base,
                         call_564973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564973, url, valid)

proc call*(call_564974: Call_WorkflowRunActionsGet_564964; runName: string;
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
  var path_564975 = newJObject()
  var query_564976 = newJObject()
  add(path_564975, "runName", newJString(runName))
  add(query_564976, "api-version", newJString(apiVersion))
  add(path_564975, "workflowName", newJString(workflowName))
  add(path_564975, "subscriptionId", newJString(subscriptionId))
  add(path_564975, "actionName", newJString(actionName))
  add(path_564975, "resourceGroupName", newJString(resourceGroupName))
  result = call_564974.call(path_564975, query_564976, nil, nil, nil)

var workflowRunActionsGet* = Call_WorkflowRunActionsGet_564964(
    name: "workflowRunActionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}",
    validator: validate_WorkflowRunActionsGet_564965, base: "",
    url: url_WorkflowRunActionsGet_564966, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsListExpressionTraces_564977 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionsListExpressionTraces_564979(protocol: Scheme;
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

proc validate_WorkflowRunActionsListExpressionTraces_564978(path: JsonNode;
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
  var valid_564980 = path.getOrDefault("runName")
  valid_564980 = validateParameter(valid_564980, JString, required = true,
                                 default = nil)
  if valid_564980 != nil:
    section.add "runName", valid_564980
  var valid_564981 = path.getOrDefault("workflowName")
  valid_564981 = validateParameter(valid_564981, JString, required = true,
                                 default = nil)
  if valid_564981 != nil:
    section.add "workflowName", valid_564981
  var valid_564982 = path.getOrDefault("subscriptionId")
  valid_564982 = validateParameter(valid_564982, JString, required = true,
                                 default = nil)
  if valid_564982 != nil:
    section.add "subscriptionId", valid_564982
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

proc call*(call_564986: Call_WorkflowRunActionsListExpressionTraces_564977;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a workflow run expression trace.
  ## 
  let valid = call_564986.validator(path, query, header, formData, body)
  let scheme = call_564986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564986.url(scheme.get, call_564986.host, call_564986.base,
                         call_564986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564986, url, valid)

proc call*(call_564987: Call_WorkflowRunActionsListExpressionTraces_564977;
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
  var path_564988 = newJObject()
  var query_564989 = newJObject()
  add(path_564988, "runName", newJString(runName))
  add(query_564989, "api-version", newJString(apiVersion))
  add(path_564988, "workflowName", newJString(workflowName))
  add(path_564988, "subscriptionId", newJString(subscriptionId))
  add(path_564988, "actionName", newJString(actionName))
  add(path_564988, "resourceGroupName", newJString(resourceGroupName))
  result = call_564987.call(path_564988, query_564989, nil, nil, nil)

var workflowRunActionsListExpressionTraces* = Call_WorkflowRunActionsListExpressionTraces_564977(
    name: "workflowRunActionsListExpressionTraces", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/listExpressionTraces",
    validator: validate_WorkflowRunActionsListExpressionTraces_564978, base: "",
    url: url_WorkflowRunActionsListExpressionTraces_564979,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsList_564990 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionRepetitionsList_564992(protocol: Scheme; host: string;
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

proc validate_WorkflowRunActionRepetitionsList_564991(path: JsonNode;
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
  var valid_564993 = path.getOrDefault("runName")
  valid_564993 = validateParameter(valid_564993, JString, required = true,
                                 default = nil)
  if valid_564993 != nil:
    section.add "runName", valid_564993
  var valid_564994 = path.getOrDefault("workflowName")
  valid_564994 = validateParameter(valid_564994, JString, required = true,
                                 default = nil)
  if valid_564994 != nil:
    section.add "workflowName", valid_564994
  var valid_564995 = path.getOrDefault("subscriptionId")
  valid_564995 = validateParameter(valid_564995, JString, required = true,
                                 default = nil)
  if valid_564995 != nil:
    section.add "subscriptionId", valid_564995
  var valid_564996 = path.getOrDefault("actionName")
  valid_564996 = validateParameter(valid_564996, JString, required = true,
                                 default = nil)
  if valid_564996 != nil:
    section.add "actionName", valid_564996
  var valid_564997 = path.getOrDefault("resourceGroupName")
  valid_564997 = validateParameter(valid_564997, JString, required = true,
                                 default = nil)
  if valid_564997 != nil:
    section.add "resourceGroupName", valid_564997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564998 = query.getOrDefault("api-version")
  valid_564998 = validateParameter(valid_564998, JString, required = true,
                                 default = nil)
  if valid_564998 != nil:
    section.add "api-version", valid_564998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564999: Call_WorkflowRunActionRepetitionsList_564990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all of a workflow run action repetitions.
  ## 
  let valid = call_564999.validator(path, query, header, formData, body)
  let scheme = call_564999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564999.url(scheme.get, call_564999.host, call_564999.base,
                         call_564999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564999, url, valid)

proc call*(call_565000: Call_WorkflowRunActionRepetitionsList_564990;
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
  var path_565001 = newJObject()
  var query_565002 = newJObject()
  add(path_565001, "runName", newJString(runName))
  add(query_565002, "api-version", newJString(apiVersion))
  add(path_565001, "workflowName", newJString(workflowName))
  add(path_565001, "subscriptionId", newJString(subscriptionId))
  add(path_565001, "actionName", newJString(actionName))
  add(path_565001, "resourceGroupName", newJString(resourceGroupName))
  result = call_565000.call(path_565001, query_565002, nil, nil, nil)

var workflowRunActionRepetitionsList* = Call_WorkflowRunActionRepetitionsList_564990(
    name: "workflowRunActionRepetitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions",
    validator: validate_WorkflowRunActionRepetitionsList_564991, base: "",
    url: url_WorkflowRunActionRepetitionsList_564992, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsGet_565003 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionRepetitionsGet_565005(protocol: Scheme; host: string;
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

proc validate_WorkflowRunActionRepetitionsGet_565004(path: JsonNode;
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
  var valid_565006 = path.getOrDefault("runName")
  valid_565006 = validateParameter(valid_565006, JString, required = true,
                                 default = nil)
  if valid_565006 != nil:
    section.add "runName", valid_565006
  var valid_565007 = path.getOrDefault("workflowName")
  valid_565007 = validateParameter(valid_565007, JString, required = true,
                                 default = nil)
  if valid_565007 != nil:
    section.add "workflowName", valid_565007
  var valid_565008 = path.getOrDefault("subscriptionId")
  valid_565008 = validateParameter(valid_565008, JString, required = true,
                                 default = nil)
  if valid_565008 != nil:
    section.add "subscriptionId", valid_565008
  var valid_565009 = path.getOrDefault("repetitionName")
  valid_565009 = validateParameter(valid_565009, JString, required = true,
                                 default = nil)
  if valid_565009 != nil:
    section.add "repetitionName", valid_565009
  var valid_565010 = path.getOrDefault("actionName")
  valid_565010 = validateParameter(valid_565010, JString, required = true,
                                 default = nil)
  if valid_565010 != nil:
    section.add "actionName", valid_565010
  var valid_565011 = path.getOrDefault("resourceGroupName")
  valid_565011 = validateParameter(valid_565011, JString, required = true,
                                 default = nil)
  if valid_565011 != nil:
    section.add "resourceGroupName", valid_565011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565012 = query.getOrDefault("api-version")
  valid_565012 = validateParameter(valid_565012, JString, required = true,
                                 default = nil)
  if valid_565012 != nil:
    section.add "api-version", valid_565012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565013: Call_WorkflowRunActionRepetitionsGet_565003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a workflow run action repetition.
  ## 
  let valid = call_565013.validator(path, query, header, formData, body)
  let scheme = call_565013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565013.url(scheme.get, call_565013.host, call_565013.base,
                         call_565013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565013, url, valid)

proc call*(call_565014: Call_WorkflowRunActionRepetitionsGet_565003;
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
  var path_565015 = newJObject()
  var query_565016 = newJObject()
  add(path_565015, "runName", newJString(runName))
  add(query_565016, "api-version", newJString(apiVersion))
  add(path_565015, "workflowName", newJString(workflowName))
  add(path_565015, "subscriptionId", newJString(subscriptionId))
  add(path_565015, "repetitionName", newJString(repetitionName))
  add(path_565015, "actionName", newJString(actionName))
  add(path_565015, "resourceGroupName", newJString(resourceGroupName))
  result = call_565014.call(path_565015, query_565016, nil, nil, nil)

var workflowRunActionRepetitionsGet* = Call_WorkflowRunActionRepetitionsGet_565003(
    name: "workflowRunActionRepetitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}",
    validator: validate_WorkflowRunActionRepetitionsGet_565004, base: "",
    url: url_WorkflowRunActionRepetitionsGet_565005, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsListExpressionTraces_565017 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionRepetitionsListExpressionTraces_565019(
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

proc validate_WorkflowRunActionRepetitionsListExpressionTraces_565018(
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
  var valid_565020 = path.getOrDefault("runName")
  valid_565020 = validateParameter(valid_565020, JString, required = true,
                                 default = nil)
  if valid_565020 != nil:
    section.add "runName", valid_565020
  var valid_565021 = path.getOrDefault("workflowName")
  valid_565021 = validateParameter(valid_565021, JString, required = true,
                                 default = nil)
  if valid_565021 != nil:
    section.add "workflowName", valid_565021
  var valid_565022 = path.getOrDefault("subscriptionId")
  valid_565022 = validateParameter(valid_565022, JString, required = true,
                                 default = nil)
  if valid_565022 != nil:
    section.add "subscriptionId", valid_565022
  var valid_565023 = path.getOrDefault("repetitionName")
  valid_565023 = validateParameter(valid_565023, JString, required = true,
                                 default = nil)
  if valid_565023 != nil:
    section.add "repetitionName", valid_565023
  var valid_565024 = path.getOrDefault("actionName")
  valid_565024 = validateParameter(valid_565024, JString, required = true,
                                 default = nil)
  if valid_565024 != nil:
    section.add "actionName", valid_565024
  var valid_565025 = path.getOrDefault("resourceGroupName")
  valid_565025 = validateParameter(valid_565025, JString, required = true,
                                 default = nil)
  if valid_565025 != nil:
    section.add "resourceGroupName", valid_565025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565026 = query.getOrDefault("api-version")
  valid_565026 = validateParameter(valid_565026, JString, required = true,
                                 default = nil)
  if valid_565026 != nil:
    section.add "api-version", valid_565026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565027: Call_WorkflowRunActionRepetitionsListExpressionTraces_565017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a workflow run expression trace.
  ## 
  let valid = call_565027.validator(path, query, header, formData, body)
  let scheme = call_565027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565027.url(scheme.get, call_565027.host, call_565027.base,
                         call_565027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565027, url, valid)

proc call*(call_565028: Call_WorkflowRunActionRepetitionsListExpressionTraces_565017;
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
  var path_565029 = newJObject()
  var query_565030 = newJObject()
  add(path_565029, "runName", newJString(runName))
  add(query_565030, "api-version", newJString(apiVersion))
  add(path_565029, "workflowName", newJString(workflowName))
  add(path_565029, "subscriptionId", newJString(subscriptionId))
  add(path_565029, "repetitionName", newJString(repetitionName))
  add(path_565029, "actionName", newJString(actionName))
  add(path_565029, "resourceGroupName", newJString(resourceGroupName))
  result = call_565028.call(path_565029, query_565030, nil, nil, nil)

var workflowRunActionRepetitionsListExpressionTraces* = Call_WorkflowRunActionRepetitionsListExpressionTraces_565017(
    name: "workflowRunActionRepetitionsListExpressionTraces",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/listExpressionTraces",
    validator: validate_WorkflowRunActionRepetitionsListExpressionTraces_565018,
    base: "", url: url_WorkflowRunActionRepetitionsListExpressionTraces_565019,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsRequestHistoriesList_565031 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionRepetitionsRequestHistoriesList_565033(
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

proc validate_WorkflowRunActionRepetitionsRequestHistoriesList_565032(
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
  var valid_565034 = path.getOrDefault("runName")
  valid_565034 = validateParameter(valid_565034, JString, required = true,
                                 default = nil)
  if valid_565034 != nil:
    section.add "runName", valid_565034
  var valid_565035 = path.getOrDefault("workflowName")
  valid_565035 = validateParameter(valid_565035, JString, required = true,
                                 default = nil)
  if valid_565035 != nil:
    section.add "workflowName", valid_565035
  var valid_565036 = path.getOrDefault("subscriptionId")
  valid_565036 = validateParameter(valid_565036, JString, required = true,
                                 default = nil)
  if valid_565036 != nil:
    section.add "subscriptionId", valid_565036
  var valid_565037 = path.getOrDefault("repetitionName")
  valid_565037 = validateParameter(valid_565037, JString, required = true,
                                 default = nil)
  if valid_565037 != nil:
    section.add "repetitionName", valid_565037
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

proc call*(call_565041: Call_WorkflowRunActionRepetitionsRequestHistoriesList_565031;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a workflow run repetition request history.
  ## 
  let valid = call_565041.validator(path, query, header, formData, body)
  let scheme = call_565041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565041.url(scheme.get, call_565041.host, call_565041.base,
                         call_565041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565041, url, valid)

proc call*(call_565042: Call_WorkflowRunActionRepetitionsRequestHistoriesList_565031;
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
  var path_565043 = newJObject()
  var query_565044 = newJObject()
  add(path_565043, "runName", newJString(runName))
  add(query_565044, "api-version", newJString(apiVersion))
  add(path_565043, "workflowName", newJString(workflowName))
  add(path_565043, "subscriptionId", newJString(subscriptionId))
  add(path_565043, "repetitionName", newJString(repetitionName))
  add(path_565043, "actionName", newJString(actionName))
  add(path_565043, "resourceGroupName", newJString(resourceGroupName))
  result = call_565042.call(path_565043, query_565044, nil, nil, nil)

var workflowRunActionRepetitionsRequestHistoriesList* = Call_WorkflowRunActionRepetitionsRequestHistoriesList_565031(
    name: "workflowRunActionRepetitionsRequestHistoriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/requestHistories",
    validator: validate_WorkflowRunActionRepetitionsRequestHistoriesList_565032,
    base: "", url: url_WorkflowRunActionRepetitionsRequestHistoriesList_565033,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsRequestHistoriesGet_565045 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionRepetitionsRequestHistoriesGet_565047(protocol: Scheme;
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

proc validate_WorkflowRunActionRepetitionsRequestHistoriesGet_565046(
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
  var valid_565048 = path.getOrDefault("runName")
  valid_565048 = validateParameter(valid_565048, JString, required = true,
                                 default = nil)
  if valid_565048 != nil:
    section.add "runName", valid_565048
  var valid_565049 = path.getOrDefault("requestHistoryName")
  valid_565049 = validateParameter(valid_565049, JString, required = true,
                                 default = nil)
  if valid_565049 != nil:
    section.add "requestHistoryName", valid_565049
  var valid_565050 = path.getOrDefault("workflowName")
  valid_565050 = validateParameter(valid_565050, JString, required = true,
                                 default = nil)
  if valid_565050 != nil:
    section.add "workflowName", valid_565050
  var valid_565051 = path.getOrDefault("subscriptionId")
  valid_565051 = validateParameter(valid_565051, JString, required = true,
                                 default = nil)
  if valid_565051 != nil:
    section.add "subscriptionId", valid_565051
  var valid_565052 = path.getOrDefault("repetitionName")
  valid_565052 = validateParameter(valid_565052, JString, required = true,
                                 default = nil)
  if valid_565052 != nil:
    section.add "repetitionName", valid_565052
  var valid_565053 = path.getOrDefault("actionName")
  valid_565053 = validateParameter(valid_565053, JString, required = true,
                                 default = nil)
  if valid_565053 != nil:
    section.add "actionName", valid_565053
  var valid_565054 = path.getOrDefault("resourceGroupName")
  valid_565054 = validateParameter(valid_565054, JString, required = true,
                                 default = nil)
  if valid_565054 != nil:
    section.add "resourceGroupName", valid_565054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565055 = query.getOrDefault("api-version")
  valid_565055 = validateParameter(valid_565055, JString, required = true,
                                 default = nil)
  if valid_565055 != nil:
    section.add "api-version", valid_565055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565056: Call_WorkflowRunActionRepetitionsRequestHistoriesGet_565045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a workflow run repetition request history.
  ## 
  let valid = call_565056.validator(path, query, header, formData, body)
  let scheme = call_565056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565056.url(scheme.get, call_565056.host, call_565056.base,
                         call_565056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565056, url, valid)

proc call*(call_565057: Call_WorkflowRunActionRepetitionsRequestHistoriesGet_565045;
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
  var path_565058 = newJObject()
  var query_565059 = newJObject()
  add(path_565058, "runName", newJString(runName))
  add(query_565059, "api-version", newJString(apiVersion))
  add(path_565058, "requestHistoryName", newJString(requestHistoryName))
  add(path_565058, "workflowName", newJString(workflowName))
  add(path_565058, "subscriptionId", newJString(subscriptionId))
  add(path_565058, "repetitionName", newJString(repetitionName))
  add(path_565058, "actionName", newJString(actionName))
  add(path_565058, "resourceGroupName", newJString(resourceGroupName))
  result = call_565057.call(path_565058, query_565059, nil, nil, nil)

var workflowRunActionRepetitionsRequestHistoriesGet* = Call_WorkflowRunActionRepetitionsRequestHistoriesGet_565045(
    name: "workflowRunActionRepetitionsRequestHistoriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/requestHistories/{requestHistoryName}",
    validator: validate_WorkflowRunActionRepetitionsRequestHistoriesGet_565046,
    base: "", url: url_WorkflowRunActionRepetitionsRequestHistoriesGet_565047,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRequestHistoriesList_565060 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionRequestHistoriesList_565062(protocol: Scheme;
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

proc validate_WorkflowRunActionRequestHistoriesList_565061(path: JsonNode;
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
  var valid_565063 = path.getOrDefault("runName")
  valid_565063 = validateParameter(valid_565063, JString, required = true,
                                 default = nil)
  if valid_565063 != nil:
    section.add "runName", valid_565063
  var valid_565064 = path.getOrDefault("workflowName")
  valid_565064 = validateParameter(valid_565064, JString, required = true,
                                 default = nil)
  if valid_565064 != nil:
    section.add "workflowName", valid_565064
  var valid_565065 = path.getOrDefault("subscriptionId")
  valid_565065 = validateParameter(valid_565065, JString, required = true,
                                 default = nil)
  if valid_565065 != nil:
    section.add "subscriptionId", valid_565065
  var valid_565066 = path.getOrDefault("actionName")
  valid_565066 = validateParameter(valid_565066, JString, required = true,
                                 default = nil)
  if valid_565066 != nil:
    section.add "actionName", valid_565066
  var valid_565067 = path.getOrDefault("resourceGroupName")
  valid_565067 = validateParameter(valid_565067, JString, required = true,
                                 default = nil)
  if valid_565067 != nil:
    section.add "resourceGroupName", valid_565067
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565068 = query.getOrDefault("api-version")
  valid_565068 = validateParameter(valid_565068, JString, required = true,
                                 default = nil)
  if valid_565068 != nil:
    section.add "api-version", valid_565068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565069: Call_WorkflowRunActionRequestHistoriesList_565060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a workflow run request history.
  ## 
  let valid = call_565069.validator(path, query, header, formData, body)
  let scheme = call_565069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565069.url(scheme.get, call_565069.host, call_565069.base,
                         call_565069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565069, url, valid)

proc call*(call_565070: Call_WorkflowRunActionRequestHistoriesList_565060;
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
  var path_565071 = newJObject()
  var query_565072 = newJObject()
  add(path_565071, "runName", newJString(runName))
  add(query_565072, "api-version", newJString(apiVersion))
  add(path_565071, "workflowName", newJString(workflowName))
  add(path_565071, "subscriptionId", newJString(subscriptionId))
  add(path_565071, "actionName", newJString(actionName))
  add(path_565071, "resourceGroupName", newJString(resourceGroupName))
  result = call_565070.call(path_565071, query_565072, nil, nil, nil)

var workflowRunActionRequestHistoriesList* = Call_WorkflowRunActionRequestHistoriesList_565060(
    name: "workflowRunActionRequestHistoriesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/requestHistories",
    validator: validate_WorkflowRunActionRequestHistoriesList_565061, base: "",
    url: url_WorkflowRunActionRequestHistoriesList_565062, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRequestHistoriesGet_565073 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionRequestHistoriesGet_565075(protocol: Scheme;
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

proc validate_WorkflowRunActionRequestHistoriesGet_565074(path: JsonNode;
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
  var valid_565076 = path.getOrDefault("runName")
  valid_565076 = validateParameter(valid_565076, JString, required = true,
                                 default = nil)
  if valid_565076 != nil:
    section.add "runName", valid_565076
  var valid_565077 = path.getOrDefault("requestHistoryName")
  valid_565077 = validateParameter(valid_565077, JString, required = true,
                                 default = nil)
  if valid_565077 != nil:
    section.add "requestHistoryName", valid_565077
  var valid_565078 = path.getOrDefault("workflowName")
  valid_565078 = validateParameter(valid_565078, JString, required = true,
                                 default = nil)
  if valid_565078 != nil:
    section.add "workflowName", valid_565078
  var valid_565079 = path.getOrDefault("subscriptionId")
  valid_565079 = validateParameter(valid_565079, JString, required = true,
                                 default = nil)
  if valid_565079 != nil:
    section.add "subscriptionId", valid_565079
  var valid_565080 = path.getOrDefault("actionName")
  valid_565080 = validateParameter(valid_565080, JString, required = true,
                                 default = nil)
  if valid_565080 != nil:
    section.add "actionName", valid_565080
  var valid_565081 = path.getOrDefault("resourceGroupName")
  valid_565081 = validateParameter(valid_565081, JString, required = true,
                                 default = nil)
  if valid_565081 != nil:
    section.add "resourceGroupName", valid_565081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565082 = query.getOrDefault("api-version")
  valid_565082 = validateParameter(valid_565082, JString, required = true,
                                 default = nil)
  if valid_565082 != nil:
    section.add "api-version", valid_565082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565083: Call_WorkflowRunActionRequestHistoriesGet_565073;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a workflow run request history.
  ## 
  let valid = call_565083.validator(path, query, header, formData, body)
  let scheme = call_565083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565083.url(scheme.get, call_565083.host, call_565083.base,
                         call_565083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565083, url, valid)

proc call*(call_565084: Call_WorkflowRunActionRequestHistoriesGet_565073;
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
  var path_565085 = newJObject()
  var query_565086 = newJObject()
  add(path_565085, "runName", newJString(runName))
  add(query_565086, "api-version", newJString(apiVersion))
  add(path_565085, "requestHistoryName", newJString(requestHistoryName))
  add(path_565085, "workflowName", newJString(workflowName))
  add(path_565085, "subscriptionId", newJString(subscriptionId))
  add(path_565085, "actionName", newJString(actionName))
  add(path_565085, "resourceGroupName", newJString(resourceGroupName))
  result = call_565084.call(path_565085, query_565086, nil, nil, nil)

var workflowRunActionRequestHistoriesGet* = Call_WorkflowRunActionRequestHistoriesGet_565073(
    name: "workflowRunActionRequestHistoriesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/requestHistories/{requestHistoryName}",
    validator: validate_WorkflowRunActionRequestHistoriesGet_565074, base: "",
    url: url_WorkflowRunActionRequestHistoriesGet_565075, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionScopedRepetitionsList_565087 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionScopedRepetitionsList_565089(protocol: Scheme;
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

proc validate_WorkflowRunActionScopedRepetitionsList_565088(path: JsonNode;
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
  var valid_565090 = path.getOrDefault("runName")
  valid_565090 = validateParameter(valid_565090, JString, required = true,
                                 default = nil)
  if valid_565090 != nil:
    section.add "runName", valid_565090
  var valid_565091 = path.getOrDefault("workflowName")
  valid_565091 = validateParameter(valid_565091, JString, required = true,
                                 default = nil)
  if valid_565091 != nil:
    section.add "workflowName", valid_565091
  var valid_565092 = path.getOrDefault("subscriptionId")
  valid_565092 = validateParameter(valid_565092, JString, required = true,
                                 default = nil)
  if valid_565092 != nil:
    section.add "subscriptionId", valid_565092
  var valid_565093 = path.getOrDefault("actionName")
  valid_565093 = validateParameter(valid_565093, JString, required = true,
                                 default = nil)
  if valid_565093 != nil:
    section.add "actionName", valid_565093
  var valid_565094 = path.getOrDefault("resourceGroupName")
  valid_565094 = validateParameter(valid_565094, JString, required = true,
                                 default = nil)
  if valid_565094 != nil:
    section.add "resourceGroupName", valid_565094
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565095 = query.getOrDefault("api-version")
  valid_565095 = validateParameter(valid_565095, JString, required = true,
                                 default = nil)
  if valid_565095 != nil:
    section.add "api-version", valid_565095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565096: Call_WorkflowRunActionScopedRepetitionsList_565087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the workflow run action scoped repetitions.
  ## 
  let valid = call_565096.validator(path, query, header, formData, body)
  let scheme = call_565096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565096.url(scheme.get, call_565096.host, call_565096.base,
                         call_565096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565096, url, valid)

proc call*(call_565097: Call_WorkflowRunActionScopedRepetitionsList_565087;
          runName: string; apiVersion: string; workflowName: string;
          subscriptionId: string; actionName: string; resourceGroupName: string): Recallable =
  ## workflowRunActionScopedRepetitionsList
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
  var path_565098 = newJObject()
  var query_565099 = newJObject()
  add(path_565098, "runName", newJString(runName))
  add(query_565099, "api-version", newJString(apiVersion))
  add(path_565098, "workflowName", newJString(workflowName))
  add(path_565098, "subscriptionId", newJString(subscriptionId))
  add(path_565098, "actionName", newJString(actionName))
  add(path_565098, "resourceGroupName", newJString(resourceGroupName))
  result = call_565097.call(path_565098, query_565099, nil, nil, nil)

var workflowRunActionScopedRepetitionsList* = Call_WorkflowRunActionScopedRepetitionsList_565087(
    name: "workflowRunActionScopedRepetitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/scopeRepetitions",
    validator: validate_WorkflowRunActionScopedRepetitionsList_565088, base: "",
    url: url_WorkflowRunActionScopedRepetitionsList_565089,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionScopedRepetitionsGet_565100 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunActionScopedRepetitionsGet_565102(protocol: Scheme;
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

proc validate_WorkflowRunActionScopedRepetitionsGet_565101(path: JsonNode;
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
  var valid_565103 = path.getOrDefault("runName")
  valid_565103 = validateParameter(valid_565103, JString, required = true,
                                 default = nil)
  if valid_565103 != nil:
    section.add "runName", valid_565103
  var valid_565104 = path.getOrDefault("workflowName")
  valid_565104 = validateParameter(valid_565104, JString, required = true,
                                 default = nil)
  if valid_565104 != nil:
    section.add "workflowName", valid_565104
  var valid_565105 = path.getOrDefault("subscriptionId")
  valid_565105 = validateParameter(valid_565105, JString, required = true,
                                 default = nil)
  if valid_565105 != nil:
    section.add "subscriptionId", valid_565105
  var valid_565106 = path.getOrDefault("repetitionName")
  valid_565106 = validateParameter(valid_565106, JString, required = true,
                                 default = nil)
  if valid_565106 != nil:
    section.add "repetitionName", valid_565106
  var valid_565107 = path.getOrDefault("actionName")
  valid_565107 = validateParameter(valid_565107, JString, required = true,
                                 default = nil)
  if valid_565107 != nil:
    section.add "actionName", valid_565107
  var valid_565108 = path.getOrDefault("resourceGroupName")
  valid_565108 = validateParameter(valid_565108, JString, required = true,
                                 default = nil)
  if valid_565108 != nil:
    section.add "resourceGroupName", valid_565108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565109 = query.getOrDefault("api-version")
  valid_565109 = validateParameter(valid_565109, JString, required = true,
                                 default = nil)
  if valid_565109 != nil:
    section.add "api-version", valid_565109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565110: Call_WorkflowRunActionScopedRepetitionsGet_565100;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a workflow run action scoped repetition.
  ## 
  let valid = call_565110.validator(path, query, header, formData, body)
  let scheme = call_565110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565110.url(scheme.get, call_565110.host, call_565110.base,
                         call_565110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565110, url, valid)

proc call*(call_565111: Call_WorkflowRunActionScopedRepetitionsGet_565100;
          runName: string; apiVersion: string; workflowName: string;
          subscriptionId: string; repetitionName: string; actionName: string;
          resourceGroupName: string): Recallable =
  ## workflowRunActionScopedRepetitionsGet
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
  var path_565112 = newJObject()
  var query_565113 = newJObject()
  add(path_565112, "runName", newJString(runName))
  add(query_565113, "api-version", newJString(apiVersion))
  add(path_565112, "workflowName", newJString(workflowName))
  add(path_565112, "subscriptionId", newJString(subscriptionId))
  add(path_565112, "repetitionName", newJString(repetitionName))
  add(path_565112, "actionName", newJString(actionName))
  add(path_565112, "resourceGroupName", newJString(resourceGroupName))
  result = call_565111.call(path_565112, query_565113, nil, nil, nil)

var workflowRunActionScopedRepetitionsGet* = Call_WorkflowRunActionScopedRepetitionsGet_565100(
    name: "workflowRunActionScopedRepetitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/scopeRepetitions/{repetitionName}",
    validator: validate_WorkflowRunActionScopedRepetitionsGet_565101, base: "",
    url: url_WorkflowRunActionScopedRepetitionsGet_565102, schemes: {Scheme.Https})
type
  Call_WorkflowRunsCancel_565114 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunsCancel_565116(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsCancel_565115(path: JsonNode; query: JsonNode;
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
  var valid_565117 = path.getOrDefault("runName")
  valid_565117 = validateParameter(valid_565117, JString, required = true,
                                 default = nil)
  if valid_565117 != nil:
    section.add "runName", valid_565117
  var valid_565118 = path.getOrDefault("workflowName")
  valid_565118 = validateParameter(valid_565118, JString, required = true,
                                 default = nil)
  if valid_565118 != nil:
    section.add "workflowName", valid_565118
  var valid_565119 = path.getOrDefault("subscriptionId")
  valid_565119 = validateParameter(valid_565119, JString, required = true,
                                 default = nil)
  if valid_565119 != nil:
    section.add "subscriptionId", valid_565119
  var valid_565120 = path.getOrDefault("resourceGroupName")
  valid_565120 = validateParameter(valid_565120, JString, required = true,
                                 default = nil)
  if valid_565120 != nil:
    section.add "resourceGroupName", valid_565120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565121 = query.getOrDefault("api-version")
  valid_565121 = validateParameter(valid_565121, JString, required = true,
                                 default = nil)
  if valid_565121 != nil:
    section.add "api-version", valid_565121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565122: Call_WorkflowRunsCancel_565114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a workflow run.
  ## 
  let valid = call_565122.validator(path, query, header, formData, body)
  let scheme = call_565122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565122.url(scheme.get, call_565122.host, call_565122.base,
                         call_565122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565122, url, valid)

proc call*(call_565123: Call_WorkflowRunsCancel_565114; runName: string;
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
  var path_565124 = newJObject()
  var query_565125 = newJObject()
  add(path_565124, "runName", newJString(runName))
  add(query_565125, "api-version", newJString(apiVersion))
  add(path_565124, "workflowName", newJString(workflowName))
  add(path_565124, "subscriptionId", newJString(subscriptionId))
  add(path_565124, "resourceGroupName", newJString(resourceGroupName))
  result = call_565123.call(path_565124, query_565125, nil, nil, nil)

var workflowRunsCancel* = Call_WorkflowRunsCancel_565114(
    name: "workflowRunsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/cancel",
    validator: validate_WorkflowRunsCancel_565115, base: "",
    url: url_WorkflowRunsCancel_565116, schemes: {Scheme.Https})
type
  Call_WorkflowRunOperationsGet_565126 = ref object of OpenApiRestCall_563565
proc url_WorkflowRunOperationsGet_565128(protocol: Scheme; host: string;
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

proc validate_WorkflowRunOperationsGet_565127(path: JsonNode; query: JsonNode;
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
  var valid_565129 = path.getOrDefault("runName")
  valid_565129 = validateParameter(valid_565129, JString, required = true,
                                 default = nil)
  if valid_565129 != nil:
    section.add "runName", valid_565129
  var valid_565130 = path.getOrDefault("operationId")
  valid_565130 = validateParameter(valid_565130, JString, required = true,
                                 default = nil)
  if valid_565130 != nil:
    section.add "operationId", valid_565130
  var valid_565131 = path.getOrDefault("workflowName")
  valid_565131 = validateParameter(valid_565131, JString, required = true,
                                 default = nil)
  if valid_565131 != nil:
    section.add "workflowName", valid_565131
  var valid_565132 = path.getOrDefault("subscriptionId")
  valid_565132 = validateParameter(valid_565132, JString, required = true,
                                 default = nil)
  if valid_565132 != nil:
    section.add "subscriptionId", valid_565132
  var valid_565133 = path.getOrDefault("resourceGroupName")
  valid_565133 = validateParameter(valid_565133, JString, required = true,
                                 default = nil)
  if valid_565133 != nil:
    section.add "resourceGroupName", valid_565133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565134 = query.getOrDefault("api-version")
  valid_565134 = validateParameter(valid_565134, JString, required = true,
                                 default = nil)
  if valid_565134 != nil:
    section.add "api-version", valid_565134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565135: Call_WorkflowRunOperationsGet_565126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an operation for a run.
  ## 
  let valid = call_565135.validator(path, query, header, formData, body)
  let scheme = call_565135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565135.url(scheme.get, call_565135.host, call_565135.base,
                         call_565135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565135, url, valid)

proc call*(call_565136: Call_WorkflowRunOperationsGet_565126; runName: string;
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
  var path_565137 = newJObject()
  var query_565138 = newJObject()
  add(path_565137, "runName", newJString(runName))
  add(query_565138, "api-version", newJString(apiVersion))
  add(path_565137, "operationId", newJString(operationId))
  add(path_565137, "workflowName", newJString(workflowName))
  add(path_565137, "subscriptionId", newJString(subscriptionId))
  add(path_565137, "resourceGroupName", newJString(resourceGroupName))
  result = call_565136.call(path_565137, query_565138, nil, nil, nil)

var workflowRunOperationsGet* = Call_WorkflowRunOperationsGet_565126(
    name: "workflowRunOperationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/operations/{operationId}",
    validator: validate_WorkflowRunOperationsGet_565127, base: "",
    url: url_WorkflowRunOperationsGet_565128, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersList_565139 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggersList_565141(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersList_565140(path: JsonNode; query: JsonNode;
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
  var valid_565142 = path.getOrDefault("workflowName")
  valid_565142 = validateParameter(valid_565142, JString, required = true,
                                 default = nil)
  if valid_565142 != nil:
    section.add "workflowName", valid_565142
  var valid_565143 = path.getOrDefault("subscriptionId")
  valid_565143 = validateParameter(valid_565143, JString, required = true,
                                 default = nil)
  if valid_565143 != nil:
    section.add "subscriptionId", valid_565143
  var valid_565144 = path.getOrDefault("resourceGroupName")
  valid_565144 = validateParameter(valid_565144, JString, required = true,
                                 default = nil)
  if valid_565144 != nil:
    section.add "resourceGroupName", valid_565144
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
  var valid_565145 = query.getOrDefault("api-version")
  valid_565145 = validateParameter(valid_565145, JString, required = true,
                                 default = nil)
  if valid_565145 != nil:
    section.add "api-version", valid_565145
  var valid_565146 = query.getOrDefault("$top")
  valid_565146 = validateParameter(valid_565146, JInt, required = false, default = nil)
  if valid_565146 != nil:
    section.add "$top", valid_565146
  var valid_565147 = query.getOrDefault("$filter")
  valid_565147 = validateParameter(valid_565147, JString, required = false,
                                 default = nil)
  if valid_565147 != nil:
    section.add "$filter", valid_565147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565148: Call_WorkflowTriggersList_565139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow triggers.
  ## 
  let valid = call_565148.validator(path, query, header, formData, body)
  let scheme = call_565148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565148.url(scheme.get, call_565148.host, call_565148.base,
                         call_565148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565148, url, valid)

proc call*(call_565149: Call_WorkflowTriggersList_565139; apiVersion: string;
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
  var path_565150 = newJObject()
  var query_565151 = newJObject()
  add(query_565151, "api-version", newJString(apiVersion))
  add(query_565151, "$top", newJInt(Top))
  add(path_565150, "workflowName", newJString(workflowName))
  add(path_565150, "subscriptionId", newJString(subscriptionId))
  add(path_565150, "resourceGroupName", newJString(resourceGroupName))
  add(query_565151, "$filter", newJString(Filter))
  result = call_565149.call(path_565150, query_565151, nil, nil, nil)

var workflowTriggersList* = Call_WorkflowTriggersList_565139(
    name: "workflowTriggersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers",
    validator: validate_WorkflowTriggersList_565140, base: "",
    url: url_WorkflowTriggersList_565141, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersGet_565152 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggersGet_565154(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersGet_565153(path: JsonNode; query: JsonNode;
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
  var valid_565155 = path.getOrDefault("workflowName")
  valid_565155 = validateParameter(valid_565155, JString, required = true,
                                 default = nil)
  if valid_565155 != nil:
    section.add "workflowName", valid_565155
  var valid_565156 = path.getOrDefault("subscriptionId")
  valid_565156 = validateParameter(valid_565156, JString, required = true,
                                 default = nil)
  if valid_565156 != nil:
    section.add "subscriptionId", valid_565156
  var valid_565157 = path.getOrDefault("resourceGroupName")
  valid_565157 = validateParameter(valid_565157, JString, required = true,
                                 default = nil)
  if valid_565157 != nil:
    section.add "resourceGroupName", valid_565157
  var valid_565158 = path.getOrDefault("triggerName")
  valid_565158 = validateParameter(valid_565158, JString, required = true,
                                 default = nil)
  if valid_565158 != nil:
    section.add "triggerName", valid_565158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565159 = query.getOrDefault("api-version")
  valid_565159 = validateParameter(valid_565159, JString, required = true,
                                 default = nil)
  if valid_565159 != nil:
    section.add "api-version", valid_565159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565160: Call_WorkflowTriggersGet_565152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow trigger.
  ## 
  let valid = call_565160.validator(path, query, header, formData, body)
  let scheme = call_565160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565160.url(scheme.get, call_565160.host, call_565160.base,
                         call_565160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565160, url, valid)

proc call*(call_565161: Call_WorkflowTriggersGet_565152; apiVersion: string;
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
  var path_565162 = newJObject()
  var query_565163 = newJObject()
  add(query_565163, "api-version", newJString(apiVersion))
  add(path_565162, "workflowName", newJString(workflowName))
  add(path_565162, "subscriptionId", newJString(subscriptionId))
  add(path_565162, "resourceGroupName", newJString(resourceGroupName))
  add(path_565162, "triggerName", newJString(triggerName))
  result = call_565161.call(path_565162, query_565163, nil, nil, nil)

var workflowTriggersGet* = Call_WorkflowTriggersGet_565152(
    name: "workflowTriggersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}",
    validator: validate_WorkflowTriggersGet_565153, base: "",
    url: url_WorkflowTriggersGet_565154, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesList_565164 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggerHistoriesList_565166(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesList_565165(path: JsonNode; query: JsonNode;
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
  var valid_565167 = path.getOrDefault("workflowName")
  valid_565167 = validateParameter(valid_565167, JString, required = true,
                                 default = nil)
  if valid_565167 != nil:
    section.add "workflowName", valid_565167
  var valid_565168 = path.getOrDefault("subscriptionId")
  valid_565168 = validateParameter(valid_565168, JString, required = true,
                                 default = nil)
  if valid_565168 != nil:
    section.add "subscriptionId", valid_565168
  var valid_565169 = path.getOrDefault("resourceGroupName")
  valid_565169 = validateParameter(valid_565169, JString, required = true,
                                 default = nil)
  if valid_565169 != nil:
    section.add "resourceGroupName", valid_565169
  var valid_565170 = path.getOrDefault("triggerName")
  valid_565170 = validateParameter(valid_565170, JString, required = true,
                                 default = nil)
  if valid_565170 != nil:
    section.add "triggerName", valid_565170
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
  var valid_565171 = query.getOrDefault("api-version")
  valid_565171 = validateParameter(valid_565171, JString, required = true,
                                 default = nil)
  if valid_565171 != nil:
    section.add "api-version", valid_565171
  var valid_565172 = query.getOrDefault("$top")
  valid_565172 = validateParameter(valid_565172, JInt, required = false, default = nil)
  if valid_565172 != nil:
    section.add "$top", valid_565172
  var valid_565173 = query.getOrDefault("$filter")
  valid_565173 = validateParameter(valid_565173, JString, required = false,
                                 default = nil)
  if valid_565173 != nil:
    section.add "$filter", valid_565173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565174: Call_WorkflowTriggerHistoriesList_565164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow trigger histories.
  ## 
  let valid = call_565174.validator(path, query, header, formData, body)
  let scheme = call_565174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565174.url(scheme.get, call_565174.host, call_565174.base,
                         call_565174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565174, url, valid)

proc call*(call_565175: Call_WorkflowTriggerHistoriesList_565164;
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
  var path_565176 = newJObject()
  var query_565177 = newJObject()
  add(query_565177, "api-version", newJString(apiVersion))
  add(query_565177, "$top", newJInt(Top))
  add(path_565176, "workflowName", newJString(workflowName))
  add(path_565176, "subscriptionId", newJString(subscriptionId))
  add(path_565176, "resourceGroupName", newJString(resourceGroupName))
  add(query_565177, "$filter", newJString(Filter))
  add(path_565176, "triggerName", newJString(triggerName))
  result = call_565175.call(path_565176, query_565177, nil, nil, nil)

var workflowTriggerHistoriesList* = Call_WorkflowTriggerHistoriesList_565164(
    name: "workflowTriggerHistoriesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories",
    validator: validate_WorkflowTriggerHistoriesList_565165, base: "",
    url: url_WorkflowTriggerHistoriesList_565166, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesGet_565178 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggerHistoriesGet_565180(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesGet_565179(path: JsonNode; query: JsonNode;
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
  var valid_565181 = path.getOrDefault("workflowName")
  valid_565181 = validateParameter(valid_565181, JString, required = true,
                                 default = nil)
  if valid_565181 != nil:
    section.add "workflowName", valid_565181
  var valid_565182 = path.getOrDefault("subscriptionId")
  valid_565182 = validateParameter(valid_565182, JString, required = true,
                                 default = nil)
  if valid_565182 != nil:
    section.add "subscriptionId", valid_565182
  var valid_565183 = path.getOrDefault("historyName")
  valid_565183 = validateParameter(valid_565183, JString, required = true,
                                 default = nil)
  if valid_565183 != nil:
    section.add "historyName", valid_565183
  var valid_565184 = path.getOrDefault("resourceGroupName")
  valid_565184 = validateParameter(valid_565184, JString, required = true,
                                 default = nil)
  if valid_565184 != nil:
    section.add "resourceGroupName", valid_565184
  var valid_565185 = path.getOrDefault("triggerName")
  valid_565185 = validateParameter(valid_565185, JString, required = true,
                                 default = nil)
  if valid_565185 != nil:
    section.add "triggerName", valid_565185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565186 = query.getOrDefault("api-version")
  valid_565186 = validateParameter(valid_565186, JString, required = true,
                                 default = nil)
  if valid_565186 != nil:
    section.add "api-version", valid_565186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565187: Call_WorkflowTriggerHistoriesGet_565178; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow trigger history.
  ## 
  let valid = call_565187.validator(path, query, header, formData, body)
  let scheme = call_565187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565187.url(scheme.get, call_565187.host, call_565187.base,
                         call_565187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565187, url, valid)

proc call*(call_565188: Call_WorkflowTriggerHistoriesGet_565178;
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
  var path_565189 = newJObject()
  var query_565190 = newJObject()
  add(query_565190, "api-version", newJString(apiVersion))
  add(path_565189, "workflowName", newJString(workflowName))
  add(path_565189, "subscriptionId", newJString(subscriptionId))
  add(path_565189, "historyName", newJString(historyName))
  add(path_565189, "resourceGroupName", newJString(resourceGroupName))
  add(path_565189, "triggerName", newJString(triggerName))
  result = call_565188.call(path_565189, query_565190, nil, nil, nil)

var workflowTriggerHistoriesGet* = Call_WorkflowTriggerHistoriesGet_565178(
    name: "workflowTriggerHistoriesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories/{historyName}",
    validator: validate_WorkflowTriggerHistoriesGet_565179, base: "",
    url: url_WorkflowTriggerHistoriesGet_565180, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesResubmit_565191 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggerHistoriesResubmit_565193(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesResubmit_565192(path: JsonNode;
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
  var valid_565194 = path.getOrDefault("workflowName")
  valid_565194 = validateParameter(valid_565194, JString, required = true,
                                 default = nil)
  if valid_565194 != nil:
    section.add "workflowName", valid_565194
  var valid_565195 = path.getOrDefault("subscriptionId")
  valid_565195 = validateParameter(valid_565195, JString, required = true,
                                 default = nil)
  if valid_565195 != nil:
    section.add "subscriptionId", valid_565195
  var valid_565196 = path.getOrDefault("historyName")
  valid_565196 = validateParameter(valid_565196, JString, required = true,
                                 default = nil)
  if valid_565196 != nil:
    section.add "historyName", valid_565196
  var valid_565197 = path.getOrDefault("resourceGroupName")
  valid_565197 = validateParameter(valid_565197, JString, required = true,
                                 default = nil)
  if valid_565197 != nil:
    section.add "resourceGroupName", valid_565197
  var valid_565198 = path.getOrDefault("triggerName")
  valid_565198 = validateParameter(valid_565198, JString, required = true,
                                 default = nil)
  if valid_565198 != nil:
    section.add "triggerName", valid_565198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565199 = query.getOrDefault("api-version")
  valid_565199 = validateParameter(valid_565199, JString, required = true,
                                 default = nil)
  if valid_565199 != nil:
    section.add "api-version", valid_565199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565200: Call_WorkflowTriggerHistoriesResubmit_565191;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resubmits a workflow run based on the trigger history.
  ## 
  let valid = call_565200.validator(path, query, header, formData, body)
  let scheme = call_565200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565200.url(scheme.get, call_565200.host, call_565200.base,
                         call_565200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565200, url, valid)

proc call*(call_565201: Call_WorkflowTriggerHistoriesResubmit_565191;
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
  var path_565202 = newJObject()
  var query_565203 = newJObject()
  add(query_565203, "api-version", newJString(apiVersion))
  add(path_565202, "workflowName", newJString(workflowName))
  add(path_565202, "subscriptionId", newJString(subscriptionId))
  add(path_565202, "historyName", newJString(historyName))
  add(path_565202, "resourceGroupName", newJString(resourceGroupName))
  add(path_565202, "triggerName", newJString(triggerName))
  result = call_565201.call(path_565202, query_565203, nil, nil, nil)

var workflowTriggerHistoriesResubmit* = Call_WorkflowTriggerHistoriesResubmit_565191(
    name: "workflowTriggerHistoriesResubmit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories/{historyName}/resubmit",
    validator: validate_WorkflowTriggerHistoriesResubmit_565192, base: "",
    url: url_WorkflowTriggerHistoriesResubmit_565193, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersListCallbackUrl_565204 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggersListCallbackUrl_565206(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggersListCallbackUrl_565205(path: JsonNode;
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
  var valid_565207 = path.getOrDefault("workflowName")
  valid_565207 = validateParameter(valid_565207, JString, required = true,
                                 default = nil)
  if valid_565207 != nil:
    section.add "workflowName", valid_565207
  var valid_565208 = path.getOrDefault("subscriptionId")
  valid_565208 = validateParameter(valid_565208, JString, required = true,
                                 default = nil)
  if valid_565208 != nil:
    section.add "subscriptionId", valid_565208
  var valid_565209 = path.getOrDefault("resourceGroupName")
  valid_565209 = validateParameter(valid_565209, JString, required = true,
                                 default = nil)
  if valid_565209 != nil:
    section.add "resourceGroupName", valid_565209
  var valid_565210 = path.getOrDefault("triggerName")
  valid_565210 = validateParameter(valid_565210, JString, required = true,
                                 default = nil)
  if valid_565210 != nil:
    section.add "triggerName", valid_565210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565211 = query.getOrDefault("api-version")
  valid_565211 = validateParameter(valid_565211, JString, required = true,
                                 default = nil)
  if valid_565211 != nil:
    section.add "api-version", valid_565211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565212: Call_WorkflowTriggersListCallbackUrl_565204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the callback URL for a workflow trigger.
  ## 
  let valid = call_565212.validator(path, query, header, formData, body)
  let scheme = call_565212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565212.url(scheme.get, call_565212.host, call_565212.base,
                         call_565212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565212, url, valid)

proc call*(call_565213: Call_WorkflowTriggersListCallbackUrl_565204;
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
  var path_565214 = newJObject()
  var query_565215 = newJObject()
  add(query_565215, "api-version", newJString(apiVersion))
  add(path_565214, "workflowName", newJString(workflowName))
  add(path_565214, "subscriptionId", newJString(subscriptionId))
  add(path_565214, "resourceGroupName", newJString(resourceGroupName))
  add(path_565214, "triggerName", newJString(triggerName))
  result = call_565213.call(path_565214, query_565215, nil, nil, nil)

var workflowTriggersListCallbackUrl* = Call_WorkflowTriggersListCallbackUrl_565204(
    name: "workflowTriggersListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/listCallbackUrl",
    validator: validate_WorkflowTriggersListCallbackUrl_565205, base: "",
    url: url_WorkflowTriggersListCallbackUrl_565206, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersReset_565216 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggersReset_565218(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersReset_565217(path: JsonNode; query: JsonNode;
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
  var valid_565219 = path.getOrDefault("workflowName")
  valid_565219 = validateParameter(valid_565219, JString, required = true,
                                 default = nil)
  if valid_565219 != nil:
    section.add "workflowName", valid_565219
  var valid_565220 = path.getOrDefault("subscriptionId")
  valid_565220 = validateParameter(valid_565220, JString, required = true,
                                 default = nil)
  if valid_565220 != nil:
    section.add "subscriptionId", valid_565220
  var valid_565221 = path.getOrDefault("resourceGroupName")
  valid_565221 = validateParameter(valid_565221, JString, required = true,
                                 default = nil)
  if valid_565221 != nil:
    section.add "resourceGroupName", valid_565221
  var valid_565222 = path.getOrDefault("triggerName")
  valid_565222 = validateParameter(valid_565222, JString, required = true,
                                 default = nil)
  if valid_565222 != nil:
    section.add "triggerName", valid_565222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565223 = query.getOrDefault("api-version")
  valid_565223 = validateParameter(valid_565223, JString, required = true,
                                 default = nil)
  if valid_565223 != nil:
    section.add "api-version", valid_565223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565224: Call_WorkflowTriggersReset_565216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets a workflow trigger.
  ## 
  let valid = call_565224.validator(path, query, header, formData, body)
  let scheme = call_565224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565224.url(scheme.get, call_565224.host, call_565224.base,
                         call_565224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565224, url, valid)

proc call*(call_565225: Call_WorkflowTriggersReset_565216; apiVersion: string;
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
  var path_565226 = newJObject()
  var query_565227 = newJObject()
  add(query_565227, "api-version", newJString(apiVersion))
  add(path_565226, "workflowName", newJString(workflowName))
  add(path_565226, "subscriptionId", newJString(subscriptionId))
  add(path_565226, "resourceGroupName", newJString(resourceGroupName))
  add(path_565226, "triggerName", newJString(triggerName))
  result = call_565225.call(path_565226, query_565227, nil, nil, nil)

var workflowTriggersReset* = Call_WorkflowTriggersReset_565216(
    name: "workflowTriggersReset", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/reset",
    validator: validate_WorkflowTriggersReset_565217, base: "",
    url: url_WorkflowTriggersReset_565218, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersRun_565228 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggersRun_565230(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersRun_565229(path: JsonNode; query: JsonNode;
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
  var valid_565231 = path.getOrDefault("workflowName")
  valid_565231 = validateParameter(valid_565231, JString, required = true,
                                 default = nil)
  if valid_565231 != nil:
    section.add "workflowName", valid_565231
  var valid_565232 = path.getOrDefault("subscriptionId")
  valid_565232 = validateParameter(valid_565232, JString, required = true,
                                 default = nil)
  if valid_565232 != nil:
    section.add "subscriptionId", valid_565232
  var valid_565233 = path.getOrDefault("resourceGroupName")
  valid_565233 = validateParameter(valid_565233, JString, required = true,
                                 default = nil)
  if valid_565233 != nil:
    section.add "resourceGroupName", valid_565233
  var valid_565234 = path.getOrDefault("triggerName")
  valid_565234 = validateParameter(valid_565234, JString, required = true,
                                 default = nil)
  if valid_565234 != nil:
    section.add "triggerName", valid_565234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565235 = query.getOrDefault("api-version")
  valid_565235 = validateParameter(valid_565235, JString, required = true,
                                 default = nil)
  if valid_565235 != nil:
    section.add "api-version", valid_565235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565236: Call_WorkflowTriggersRun_565228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a workflow trigger.
  ## 
  let valid = call_565236.validator(path, query, header, formData, body)
  let scheme = call_565236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565236.url(scheme.get, call_565236.host, call_565236.base,
                         call_565236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565236, url, valid)

proc call*(call_565237: Call_WorkflowTriggersRun_565228; apiVersion: string;
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
  var path_565238 = newJObject()
  var query_565239 = newJObject()
  add(query_565239, "api-version", newJString(apiVersion))
  add(path_565238, "workflowName", newJString(workflowName))
  add(path_565238, "subscriptionId", newJString(subscriptionId))
  add(path_565238, "resourceGroupName", newJString(resourceGroupName))
  add(path_565238, "triggerName", newJString(triggerName))
  result = call_565237.call(path_565238, query_565239, nil, nil, nil)

var workflowTriggersRun* = Call_WorkflowTriggersRun_565228(
    name: "workflowTriggersRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/run",
    validator: validate_WorkflowTriggersRun_565229, base: "",
    url: url_WorkflowTriggersRun_565230, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersGetSchemaJson_565240 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggersGetSchemaJson_565242(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggersGetSchemaJson_565241(path: JsonNode; query: JsonNode;
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
  var valid_565243 = path.getOrDefault("workflowName")
  valid_565243 = validateParameter(valid_565243, JString, required = true,
                                 default = nil)
  if valid_565243 != nil:
    section.add "workflowName", valid_565243
  var valid_565244 = path.getOrDefault("subscriptionId")
  valid_565244 = validateParameter(valid_565244, JString, required = true,
                                 default = nil)
  if valid_565244 != nil:
    section.add "subscriptionId", valid_565244
  var valid_565245 = path.getOrDefault("resourceGroupName")
  valid_565245 = validateParameter(valid_565245, JString, required = true,
                                 default = nil)
  if valid_565245 != nil:
    section.add "resourceGroupName", valid_565245
  var valid_565246 = path.getOrDefault("triggerName")
  valid_565246 = validateParameter(valid_565246, JString, required = true,
                                 default = nil)
  if valid_565246 != nil:
    section.add "triggerName", valid_565246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565247 = query.getOrDefault("api-version")
  valid_565247 = validateParameter(valid_565247, JString, required = true,
                                 default = nil)
  if valid_565247 != nil:
    section.add "api-version", valid_565247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565248: Call_WorkflowTriggersGetSchemaJson_565240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the trigger schema as JSON.
  ## 
  let valid = call_565248.validator(path, query, header, formData, body)
  let scheme = call_565248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565248.url(scheme.get, call_565248.host, call_565248.base,
                         call_565248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565248, url, valid)

proc call*(call_565249: Call_WorkflowTriggersGetSchemaJson_565240;
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
  var path_565250 = newJObject()
  var query_565251 = newJObject()
  add(query_565251, "api-version", newJString(apiVersion))
  add(path_565250, "workflowName", newJString(workflowName))
  add(path_565250, "subscriptionId", newJString(subscriptionId))
  add(path_565250, "resourceGroupName", newJString(resourceGroupName))
  add(path_565250, "triggerName", newJString(triggerName))
  result = call_565249.call(path_565250, query_565251, nil, nil, nil)

var workflowTriggersGetSchemaJson* = Call_WorkflowTriggersGetSchemaJson_565240(
    name: "workflowTriggersGetSchemaJson", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/schemas/json",
    validator: validate_WorkflowTriggersGetSchemaJson_565241, base: "",
    url: url_WorkflowTriggersGetSchemaJson_565242, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersSetState_565252 = ref object of OpenApiRestCall_563565
proc url_WorkflowTriggersSetState_565254(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggersSetState_565253(path: JsonNode; query: JsonNode;
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
  var valid_565255 = path.getOrDefault("workflowName")
  valid_565255 = validateParameter(valid_565255, JString, required = true,
                                 default = nil)
  if valid_565255 != nil:
    section.add "workflowName", valid_565255
  var valid_565256 = path.getOrDefault("subscriptionId")
  valid_565256 = validateParameter(valid_565256, JString, required = true,
                                 default = nil)
  if valid_565256 != nil:
    section.add "subscriptionId", valid_565256
  var valid_565257 = path.getOrDefault("resourceGroupName")
  valid_565257 = validateParameter(valid_565257, JString, required = true,
                                 default = nil)
  if valid_565257 != nil:
    section.add "resourceGroupName", valid_565257
  var valid_565258 = path.getOrDefault("triggerName")
  valid_565258 = validateParameter(valid_565258, JString, required = true,
                                 default = nil)
  if valid_565258 != nil:
    section.add "triggerName", valid_565258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565259 = query.getOrDefault("api-version")
  valid_565259 = validateParameter(valid_565259, JString, required = true,
                                 default = nil)
  if valid_565259 != nil:
    section.add "api-version", valid_565259
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

proc call*(call_565261: Call_WorkflowTriggersSetState_565252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of a workflow trigger.
  ## 
  let valid = call_565261.validator(path, query, header, formData, body)
  let scheme = call_565261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565261.url(scheme.get, call_565261.host, call_565261.base,
                         call_565261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565261, url, valid)

proc call*(call_565262: Call_WorkflowTriggersSetState_565252; apiVersion: string;
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
  var path_565263 = newJObject()
  var query_565264 = newJObject()
  var body_565265 = newJObject()
  add(query_565264, "api-version", newJString(apiVersion))
  add(path_565263, "workflowName", newJString(workflowName))
  add(path_565263, "subscriptionId", newJString(subscriptionId))
  if setState != nil:
    body_565265 = setState
  add(path_565263, "resourceGroupName", newJString(resourceGroupName))
  add(path_565263, "triggerName", newJString(triggerName))
  result = call_565262.call(path_565263, query_565264, nil, nil, body_565265)

var workflowTriggersSetState* = Call_WorkflowTriggersSetState_565252(
    name: "workflowTriggersSetState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/setState",
    validator: validate_WorkflowTriggersSetState_565253, base: "",
    url: url_WorkflowTriggersSetState_565254, schemes: {Scheme.Https})
type
  Call_WorkflowsValidateWorkflow_565266 = ref object of OpenApiRestCall_563565
proc url_WorkflowsValidateWorkflow_565268(protocol: Scheme; host: string;
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

proc validate_WorkflowsValidateWorkflow_565267(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_565269 = path.getOrDefault("workflowName")
  valid_565269 = validateParameter(valid_565269, JString, required = true,
                                 default = nil)
  if valid_565269 != nil:
    section.add "workflowName", valid_565269
  var valid_565270 = path.getOrDefault("subscriptionId")
  valid_565270 = validateParameter(valid_565270, JString, required = true,
                                 default = nil)
  if valid_565270 != nil:
    section.add "subscriptionId", valid_565270
  var valid_565271 = path.getOrDefault("resourceGroupName")
  valid_565271 = validateParameter(valid_565271, JString, required = true,
                                 default = nil)
  if valid_565271 != nil:
    section.add "resourceGroupName", valid_565271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565272 = query.getOrDefault("api-version")
  valid_565272 = validateParameter(valid_565272, JString, required = true,
                                 default = nil)
  if valid_565272 != nil:
    section.add "api-version", valid_565272
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

proc call*(call_565274: Call_WorkflowsValidateWorkflow_565266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the workflow.
  ## 
  let valid = call_565274.validator(path, query, header, formData, body)
  let scheme = call_565274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565274.url(scheme.get, call_565274.host, call_565274.base,
                         call_565274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565274, url, valid)

proc call*(call_565275: Call_WorkflowsValidateWorkflow_565266; apiVersion: string;
          workflowName: string; subscriptionId: string; resourceGroupName: string;
          validate: JsonNode): Recallable =
  ## workflowsValidateWorkflow
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
  var path_565276 = newJObject()
  var query_565277 = newJObject()
  var body_565278 = newJObject()
  add(query_565277, "api-version", newJString(apiVersion))
  add(path_565276, "workflowName", newJString(workflowName))
  add(path_565276, "subscriptionId", newJString(subscriptionId))
  add(path_565276, "resourceGroupName", newJString(resourceGroupName))
  if validate != nil:
    body_565278 = validate
  result = call_565275.call(path_565276, query_565277, nil, nil, body_565278)

var workflowsValidateWorkflow* = Call_WorkflowsValidateWorkflow_565266(
    name: "workflowsValidateWorkflow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/validate",
    validator: validate_WorkflowsValidateWorkflow_565267, base: "",
    url: url_WorkflowsValidateWorkflow_565268, schemes: {Scheme.Https})
type
  Call_WorkflowVersionsList_565279 = ref object of OpenApiRestCall_563565
proc url_WorkflowVersionsList_565281(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowVersionsList_565280(path: JsonNode; query: JsonNode;
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
  var valid_565282 = path.getOrDefault("workflowName")
  valid_565282 = validateParameter(valid_565282, JString, required = true,
                                 default = nil)
  if valid_565282 != nil:
    section.add "workflowName", valid_565282
  var valid_565283 = path.getOrDefault("subscriptionId")
  valid_565283 = validateParameter(valid_565283, JString, required = true,
                                 default = nil)
  if valid_565283 != nil:
    section.add "subscriptionId", valid_565283
  var valid_565284 = path.getOrDefault("resourceGroupName")
  valid_565284 = validateParameter(valid_565284, JString, required = true,
                                 default = nil)
  if valid_565284 != nil:
    section.add "resourceGroupName", valid_565284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565285 = query.getOrDefault("api-version")
  valid_565285 = validateParameter(valid_565285, JString, required = true,
                                 default = nil)
  if valid_565285 != nil:
    section.add "api-version", valid_565285
  var valid_565286 = query.getOrDefault("$top")
  valid_565286 = validateParameter(valid_565286, JInt, required = false, default = nil)
  if valid_565286 != nil:
    section.add "$top", valid_565286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565287: Call_WorkflowVersionsList_565279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow versions.
  ## 
  let valid = call_565287.validator(path, query, header, formData, body)
  let scheme = call_565287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565287.url(scheme.get, call_565287.host, call_565287.base,
                         call_565287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565287, url, valid)

proc call*(call_565288: Call_WorkflowVersionsList_565279; apiVersion: string;
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
  var path_565289 = newJObject()
  var query_565290 = newJObject()
  add(query_565290, "api-version", newJString(apiVersion))
  add(query_565290, "$top", newJInt(Top))
  add(path_565289, "workflowName", newJString(workflowName))
  add(path_565289, "subscriptionId", newJString(subscriptionId))
  add(path_565289, "resourceGroupName", newJString(resourceGroupName))
  result = call_565288.call(path_565289, query_565290, nil, nil, nil)

var workflowVersionsList* = Call_WorkflowVersionsList_565279(
    name: "workflowVersionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions",
    validator: validate_WorkflowVersionsList_565280, base: "",
    url: url_WorkflowVersionsList_565281, schemes: {Scheme.Https})
type
  Call_WorkflowVersionsGet_565291 = ref object of OpenApiRestCall_563565
proc url_WorkflowVersionsGet_565293(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowVersionsGet_565292(path: JsonNode; query: JsonNode;
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
  var valid_565294 = path.getOrDefault("workflowName")
  valid_565294 = validateParameter(valid_565294, JString, required = true,
                                 default = nil)
  if valid_565294 != nil:
    section.add "workflowName", valid_565294
  var valid_565295 = path.getOrDefault("subscriptionId")
  valid_565295 = validateParameter(valid_565295, JString, required = true,
                                 default = nil)
  if valid_565295 != nil:
    section.add "subscriptionId", valid_565295
  var valid_565296 = path.getOrDefault("resourceGroupName")
  valid_565296 = validateParameter(valid_565296, JString, required = true,
                                 default = nil)
  if valid_565296 != nil:
    section.add "resourceGroupName", valid_565296
  var valid_565297 = path.getOrDefault("versionId")
  valid_565297 = validateParameter(valid_565297, JString, required = true,
                                 default = nil)
  if valid_565297 != nil:
    section.add "versionId", valid_565297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565298 = query.getOrDefault("api-version")
  valid_565298 = validateParameter(valid_565298, JString, required = true,
                                 default = nil)
  if valid_565298 != nil:
    section.add "api-version", valid_565298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565299: Call_WorkflowVersionsGet_565291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow version.
  ## 
  let valid = call_565299.validator(path, query, header, formData, body)
  let scheme = call_565299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565299.url(scheme.get, call_565299.host, call_565299.base,
                         call_565299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565299, url, valid)

proc call*(call_565300: Call_WorkflowVersionsGet_565291; apiVersion: string;
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
  var path_565301 = newJObject()
  var query_565302 = newJObject()
  add(query_565302, "api-version", newJString(apiVersion))
  add(path_565301, "workflowName", newJString(workflowName))
  add(path_565301, "subscriptionId", newJString(subscriptionId))
  add(path_565301, "resourceGroupName", newJString(resourceGroupName))
  add(path_565301, "versionId", newJString(versionId))
  result = call_565300.call(path_565301, query_565302, nil, nil, nil)

var workflowVersionsGet* = Call_WorkflowVersionsGet_565291(
    name: "workflowVersionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions/{versionId}",
    validator: validate_WorkflowVersionsGet_565292, base: "",
    url: url_WorkflowVersionsGet_565293, schemes: {Scheme.Https})
type
  Call_WorkflowVersionsListCallbackUrl_565303 = ref object of OpenApiRestCall_563565
proc url_WorkflowVersionsListCallbackUrl_565305(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_WorkflowVersionsListCallbackUrl_565304(path: JsonNode;
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
  var valid_565306 = path.getOrDefault("workflowName")
  valid_565306 = validateParameter(valid_565306, JString, required = true,
                                 default = nil)
  if valid_565306 != nil:
    section.add "workflowName", valid_565306
  var valid_565307 = path.getOrDefault("subscriptionId")
  valid_565307 = validateParameter(valid_565307, JString, required = true,
                                 default = nil)
  if valid_565307 != nil:
    section.add "subscriptionId", valid_565307
  var valid_565308 = path.getOrDefault("resourceGroupName")
  valid_565308 = validateParameter(valid_565308, JString, required = true,
                                 default = nil)
  if valid_565308 != nil:
    section.add "resourceGroupName", valid_565308
  var valid_565309 = path.getOrDefault("triggerName")
  valid_565309 = validateParameter(valid_565309, JString, required = true,
                                 default = nil)
  if valid_565309 != nil:
    section.add "triggerName", valid_565309
  var valid_565310 = path.getOrDefault("versionId")
  valid_565310 = validateParameter(valid_565310, JString, required = true,
                                 default = nil)
  if valid_565310 != nil:
    section.add "versionId", valid_565310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565311 = query.getOrDefault("api-version")
  valid_565311 = validateParameter(valid_565311, JString, required = true,
                                 default = nil)
  if valid_565311 != nil:
    section.add "api-version", valid_565311
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

proc call*(call_565313: Call_WorkflowVersionsListCallbackUrl_565303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the callback url for a trigger of a workflow version.
  ## 
  let valid = call_565313.validator(path, query, header, formData, body)
  let scheme = call_565313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565313.url(scheme.get, call_565313.host, call_565313.base,
                         call_565313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565313, url, valid)

proc call*(call_565314: Call_WorkflowVersionsListCallbackUrl_565303;
          apiVersion: string; workflowName: string; subscriptionId: string;
          resourceGroupName: string; triggerName: string; versionId: string;
          parameters: JsonNode = nil): Recallable =
  ## workflowVersionsListCallbackUrl
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
  var path_565315 = newJObject()
  var query_565316 = newJObject()
  var body_565317 = newJObject()
  add(query_565316, "api-version", newJString(apiVersion))
  add(path_565315, "workflowName", newJString(workflowName))
  add(path_565315, "subscriptionId", newJString(subscriptionId))
  add(path_565315, "resourceGroupName", newJString(resourceGroupName))
  add(path_565315, "triggerName", newJString(triggerName))
  add(path_565315, "versionId", newJString(versionId))
  if parameters != nil:
    body_565317 = parameters
  result = call_565314.call(path_565315, query_565316, nil, nil, body_565317)

var workflowVersionsListCallbackUrl* = Call_WorkflowVersionsListCallbackUrl_565303(
    name: "workflowVersionsListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions/{versionId}/triggers/{triggerName}/listCallbackUrl",
    validator: validate_WorkflowVersionsListCallbackUrl_565304, base: "",
    url: url_WorkflowVersionsListCallbackUrl_565305, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
