
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567667): Option[Scheme] {.used.} =
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
  macServiceName = "logic"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ListOperations_567889 = ref object of OpenApiRestCall_567667
proc url_ListOperations_567891(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListOperations_567890(path: JsonNode; query: JsonNode;
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
  var valid_568050 = query.getOrDefault("api-version")
  valid_568050 = validateParameter(valid_568050, JString, required = true,
                                 default = nil)
  if valid_568050 != nil:
    section.add "api-version", valid_568050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568073: Call_ListOperations_567889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Logic REST API operations.
  ## 
  let valid = call_568073.validator(path, query, header, formData, body)
  let scheme = call_568073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568073.url(scheme.get, call_568073.host, call_568073.base,
                         call_568073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568073, url, valid)

proc call*(call_568144: Call_ListOperations_567889; apiVersion: string): Recallable =
  ## listOperations
  ## Lists all of the available Logic REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version.
  var query_568145 = newJObject()
  add(query_568145, "api-version", newJString(apiVersion))
  result = call_568144.call(nil, query_568145, nil, nil, nil)

var listOperations* = Call_ListOperations_567889(name: "listOperations",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Logic/operations",
    validator: validate_ListOperations_567890, base: "", url: url_ListOperations_567891,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListBySubscription_568185 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountsListBySubscription_568187(protocol: Scheme;
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

proc validate_IntegrationAccountsListBySubscription_568186(path: JsonNode;
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
  var valid_568203 = path.getOrDefault("subscriptionId")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "subscriptionId", valid_568203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568204 = query.getOrDefault("api-version")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "api-version", valid_568204
  var valid_568205 = query.getOrDefault("$top")
  valid_568205 = validateParameter(valid_568205, JInt, required = false, default = nil)
  if valid_568205 != nil:
    section.add "$top", valid_568205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568206: Call_IntegrationAccountsListBySubscription_568185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration accounts by subscription.
  ## 
  let valid = call_568206.validator(path, query, header, formData, body)
  let scheme = call_568206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568206.url(scheme.get, call_568206.host, call_568206.base,
                         call_568206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568206, url, valid)

proc call*(call_568207: Call_IntegrationAccountsListBySubscription_568185;
          apiVersion: string; subscriptionId: string; Top: int = 0): Recallable =
  ## integrationAccountsListBySubscription
  ## Gets a list of integration accounts by subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  var path_568208 = newJObject()
  var query_568209 = newJObject()
  add(query_568209, "api-version", newJString(apiVersion))
  add(path_568208, "subscriptionId", newJString(subscriptionId))
  add(query_568209, "$top", newJInt(Top))
  result = call_568207.call(path_568208, query_568209, nil, nil, nil)

var integrationAccountsListBySubscription* = Call_IntegrationAccountsListBySubscription_568185(
    name: "integrationAccountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Logic/integrationAccounts",
    validator: validate_IntegrationAccountsListBySubscription_568186, base: "",
    url: url_IntegrationAccountsListBySubscription_568187, schemes: {Scheme.Https})
type
  Call_WorkflowsListBySubscription_568210 = ref object of OpenApiRestCall_567667
proc url_WorkflowsListBySubscription_568212(protocol: Scheme; host: string;
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

proc validate_WorkflowsListBySubscription_568211(path: JsonNode; query: JsonNode;
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
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
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
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
  var valid_568215 = query.getOrDefault("$top")
  valid_568215 = validateParameter(valid_568215, JInt, required = false, default = nil)
  if valid_568215 != nil:
    section.add "$top", valid_568215
  var valid_568216 = query.getOrDefault("$filter")
  valid_568216 = validateParameter(valid_568216, JString, required = false,
                                 default = nil)
  if valid_568216 != nil:
    section.add "$filter", valid_568216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568217: Call_WorkflowsListBySubscription_568210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflows by subscription.
  ## 
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_WorkflowsListBySubscription_568210;
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
  ##         : The filter to apply on the operation. Options for filters include: State, Trigger, and ReferencedResourceId.
  var path_568219 = newJObject()
  var query_568220 = newJObject()
  add(query_568220, "api-version", newJString(apiVersion))
  add(path_568219, "subscriptionId", newJString(subscriptionId))
  add(query_568220, "$top", newJInt(Top))
  add(query_568220, "$filter", newJString(Filter))
  result = call_568218.call(path_568219, query_568220, nil, nil, nil)

var workflowsListBySubscription* = Call_WorkflowsListBySubscription_568210(
    name: "workflowsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Logic/workflows",
    validator: validate_WorkflowsListBySubscription_568211, base: "",
    url: url_WorkflowsListBySubscription_568212, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListByResourceGroup_568221 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountsListByResourceGroup_568223(protocol: Scheme;
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

proc validate_IntegrationAccountsListByResourceGroup_568222(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration accounts by resource group.
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
  var valid_568224 = path.getOrDefault("resourceGroupName")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "resourceGroupName", valid_568224
  var valid_568225 = path.getOrDefault("subscriptionId")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "subscriptionId", valid_568225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568226 = query.getOrDefault("api-version")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "api-version", valid_568226
  var valid_568227 = query.getOrDefault("$top")
  valid_568227 = validateParameter(valid_568227, JInt, required = false, default = nil)
  if valid_568227 != nil:
    section.add "$top", valid_568227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568228: Call_IntegrationAccountsListByResourceGroup_568221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration accounts by resource group.
  ## 
  let valid = call_568228.validator(path, query, header, formData, body)
  let scheme = call_568228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568228.url(scheme.get, call_568228.host, call_568228.base,
                         call_568228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568228, url, valid)

proc call*(call_568229: Call_IntegrationAccountsListByResourceGroup_568221;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0): Recallable =
  ## integrationAccountsListByResourceGroup
  ## Gets a list of integration accounts by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  var path_568230 = newJObject()
  var query_568231 = newJObject()
  add(path_568230, "resourceGroupName", newJString(resourceGroupName))
  add(query_568231, "api-version", newJString(apiVersion))
  add(path_568230, "subscriptionId", newJString(subscriptionId))
  add(query_568231, "$top", newJInt(Top))
  result = call_568229.call(path_568230, query_568231, nil, nil, nil)

var integrationAccountsListByResourceGroup* = Call_IntegrationAccountsListByResourceGroup_568221(
    name: "integrationAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts",
    validator: validate_IntegrationAccountsListByResourceGroup_568222, base: "",
    url: url_IntegrationAccountsListByResourceGroup_568223,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountsCreateOrUpdate_568243 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountsCreateOrUpdate_568245(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsCreateOrUpdate_568244(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568246 = path.getOrDefault("resourceGroupName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "resourceGroupName", valid_568246
  var valid_568247 = path.getOrDefault("integrationAccountName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "integrationAccountName", valid_568247
  var valid_568248 = path.getOrDefault("subscriptionId")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "subscriptionId", valid_568248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568249 = query.getOrDefault("api-version")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "api-version", valid_568249
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

proc call*(call_568251: Call_IntegrationAccountsCreateOrUpdate_568243;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account.
  ## 
  let valid = call_568251.validator(path, query, header, formData, body)
  let scheme = call_568251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568251.url(scheme.get, call_568251.host, call_568251.base,
                         call_568251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568251, url, valid)

proc call*(call_568252: Call_IntegrationAccountsCreateOrUpdate_568243;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          integrationAccount: JsonNode): Recallable =
  ## integrationAccountsCreateOrUpdate
  ## Creates or updates an integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   integrationAccount: JObject (required)
  ##                     : The integration account.
  var path_568253 = newJObject()
  var query_568254 = newJObject()
  var body_568255 = newJObject()
  add(path_568253, "resourceGroupName", newJString(resourceGroupName))
  add(query_568254, "api-version", newJString(apiVersion))
  add(path_568253, "integrationAccountName", newJString(integrationAccountName))
  add(path_568253, "subscriptionId", newJString(subscriptionId))
  if integrationAccount != nil:
    body_568255 = integrationAccount
  result = call_568252.call(path_568253, query_568254, nil, nil, body_568255)

var integrationAccountsCreateOrUpdate* = Call_IntegrationAccountsCreateOrUpdate_568243(
    name: "integrationAccountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsCreateOrUpdate_568244, base: "",
    url: url_IntegrationAccountsCreateOrUpdate_568245, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsGet_568232 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountsGet_568234(protocol: Scheme; host: string; base: string;
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

proc validate_IntegrationAccountsGet_568233(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568235 = path.getOrDefault("resourceGroupName")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "resourceGroupName", valid_568235
  var valid_568236 = path.getOrDefault("integrationAccountName")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "integrationAccountName", valid_568236
  var valid_568237 = path.getOrDefault("subscriptionId")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "subscriptionId", valid_568237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568238 = query.getOrDefault("api-version")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "api-version", valid_568238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568239: Call_IntegrationAccountsGet_568232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account.
  ## 
  let valid = call_568239.validator(path, query, header, formData, body)
  let scheme = call_568239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568239.url(scheme.get, call_568239.host, call_568239.base,
                         call_568239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568239, url, valid)

proc call*(call_568240: Call_IntegrationAccountsGet_568232;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string): Recallable =
  ## integrationAccountsGet
  ## Gets an integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_568241 = newJObject()
  var query_568242 = newJObject()
  add(path_568241, "resourceGroupName", newJString(resourceGroupName))
  add(query_568242, "api-version", newJString(apiVersion))
  add(path_568241, "integrationAccountName", newJString(integrationAccountName))
  add(path_568241, "subscriptionId", newJString(subscriptionId))
  result = call_568240.call(path_568241, query_568242, nil, nil, nil)

var integrationAccountsGet* = Call_IntegrationAccountsGet_568232(
    name: "integrationAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsGet_568233, base: "",
    url: url_IntegrationAccountsGet_568234, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsUpdate_568267 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountsUpdate_568269(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsUpdate_568268(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568270 = path.getOrDefault("resourceGroupName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "resourceGroupName", valid_568270
  var valid_568271 = path.getOrDefault("integrationAccountName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "integrationAccountName", valid_568271
  var valid_568272 = path.getOrDefault("subscriptionId")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "subscriptionId", valid_568272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568273 = query.getOrDefault("api-version")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "api-version", valid_568273
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

proc call*(call_568275: Call_IntegrationAccountsUpdate_568267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an integration account.
  ## 
  let valid = call_568275.validator(path, query, header, formData, body)
  let scheme = call_568275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568275.url(scheme.get, call_568275.host, call_568275.base,
                         call_568275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568275, url, valid)

proc call*(call_568276: Call_IntegrationAccountsUpdate_568267;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          integrationAccount: JsonNode): Recallable =
  ## integrationAccountsUpdate
  ## Updates an integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   integrationAccount: JObject (required)
  ##                     : The integration account.
  var path_568277 = newJObject()
  var query_568278 = newJObject()
  var body_568279 = newJObject()
  add(path_568277, "resourceGroupName", newJString(resourceGroupName))
  add(query_568278, "api-version", newJString(apiVersion))
  add(path_568277, "integrationAccountName", newJString(integrationAccountName))
  add(path_568277, "subscriptionId", newJString(subscriptionId))
  if integrationAccount != nil:
    body_568279 = integrationAccount
  result = call_568276.call(path_568277, query_568278, nil, nil, body_568279)

var integrationAccountsUpdate* = Call_IntegrationAccountsUpdate_568267(
    name: "integrationAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsUpdate_568268, base: "",
    url: url_IntegrationAccountsUpdate_568269, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsDelete_568256 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountsDelete_568258(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsDelete_568257(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568259 = path.getOrDefault("resourceGroupName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "resourceGroupName", valid_568259
  var valid_568260 = path.getOrDefault("integrationAccountName")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "integrationAccountName", valid_568260
  var valid_568261 = path.getOrDefault("subscriptionId")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "subscriptionId", valid_568261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568262 = query.getOrDefault("api-version")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "api-version", valid_568262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568263: Call_IntegrationAccountsDelete_568256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account.
  ## 
  let valid = call_568263.validator(path, query, header, formData, body)
  let scheme = call_568263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568263.url(scheme.get, call_568263.host, call_568263.base,
                         call_568263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568263, url, valid)

proc call*(call_568264: Call_IntegrationAccountsDelete_568256;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string): Recallable =
  ## integrationAccountsDelete
  ## Deletes an integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_568265 = newJObject()
  var query_568266 = newJObject()
  add(path_568265, "resourceGroupName", newJString(resourceGroupName))
  add(query_568266, "api-version", newJString(apiVersion))
  add(path_568265, "integrationAccountName", newJString(integrationAccountName))
  add(path_568265, "subscriptionId", newJString(subscriptionId))
  result = call_568264.call(path_568265, query_568266, nil, nil, nil)

var integrationAccountsDelete* = Call_IntegrationAccountsDelete_568256(
    name: "integrationAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsDelete_568257, base: "",
    url: url_IntegrationAccountsDelete_568258, schemes: {Scheme.Https})
type
  Call_AgreementsListByIntegrationAccounts_568280 = ref object of OpenApiRestCall_567667
proc url_AgreementsListByIntegrationAccounts_568282(protocol: Scheme; host: string;
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

proc validate_AgreementsListByIntegrationAccounts_568281(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account agreements.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568283 = path.getOrDefault("resourceGroupName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "resourceGroupName", valid_568283
  var valid_568284 = path.getOrDefault("integrationAccountName")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "integrationAccountName", valid_568284
  var valid_568285 = path.getOrDefault("subscriptionId")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "subscriptionId", valid_568285
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
  var valid_568286 = query.getOrDefault("api-version")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "api-version", valid_568286
  var valid_568287 = query.getOrDefault("$top")
  valid_568287 = validateParameter(valid_568287, JInt, required = false, default = nil)
  if valid_568287 != nil:
    section.add "$top", valid_568287
  var valid_568288 = query.getOrDefault("$filter")
  valid_568288 = validateParameter(valid_568288, JString, required = false,
                                 default = nil)
  if valid_568288 != nil:
    section.add "$filter", valid_568288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568289: Call_AgreementsListByIntegrationAccounts_568280;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account agreements.
  ## 
  let valid = call_568289.validator(path, query, header, formData, body)
  let scheme = call_568289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568289.url(scheme.get, call_568289.host, call_568289.base,
                         call_568289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568289, url, valid)

proc call*(call_568290: Call_AgreementsListByIntegrationAccounts_568280;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## agreementsListByIntegrationAccounts
  ## Gets a list of integration account agreements.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   Filter: string
  ##         : The filter to apply on the operation. Options for filters include: AgreementType.
  var path_568291 = newJObject()
  var query_568292 = newJObject()
  add(path_568291, "resourceGroupName", newJString(resourceGroupName))
  add(query_568292, "api-version", newJString(apiVersion))
  add(path_568291, "integrationAccountName", newJString(integrationAccountName))
  add(path_568291, "subscriptionId", newJString(subscriptionId))
  add(query_568292, "$top", newJInt(Top))
  add(query_568292, "$filter", newJString(Filter))
  result = call_568290.call(path_568291, query_568292, nil, nil, nil)

var agreementsListByIntegrationAccounts* = Call_AgreementsListByIntegrationAccounts_568280(
    name: "agreementsListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements",
    validator: validate_AgreementsListByIntegrationAccounts_568281, base: "",
    url: url_AgreementsListByIntegrationAccounts_568282, schemes: {Scheme.Https})
type
  Call_AgreementsCreateOrUpdate_568305 = ref object of OpenApiRestCall_567667
proc url_AgreementsCreateOrUpdate_568307(protocol: Scheme; host: string;
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

proc validate_AgreementsCreateOrUpdate_568306(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account agreement.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   agreementName: JString (required)
  ##                : The integration account agreement name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568308 = path.getOrDefault("resourceGroupName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "resourceGroupName", valid_568308
  var valid_568309 = path.getOrDefault("integrationAccountName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "integrationAccountName", valid_568309
  var valid_568310 = path.getOrDefault("subscriptionId")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "subscriptionId", valid_568310
  var valid_568311 = path.getOrDefault("agreementName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "agreementName", valid_568311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568312 = query.getOrDefault("api-version")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "api-version", valid_568312
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

proc call*(call_568314: Call_AgreementsCreateOrUpdate_568305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account agreement.
  ## 
  let valid = call_568314.validator(path, query, header, formData, body)
  let scheme = call_568314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568314.url(scheme.get, call_568314.host, call_568314.base,
                         call_568314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568314, url, valid)

proc call*(call_568315: Call_AgreementsCreateOrUpdate_568305;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          agreementName: string; agreement: JsonNode): Recallable =
  ## agreementsCreateOrUpdate
  ## Creates or updates an integration account agreement.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   agreementName: string (required)
  ##                : The integration account agreement name.
  ##   agreement: JObject (required)
  ##            : The integration account agreement.
  var path_568316 = newJObject()
  var query_568317 = newJObject()
  var body_568318 = newJObject()
  add(path_568316, "resourceGroupName", newJString(resourceGroupName))
  add(query_568317, "api-version", newJString(apiVersion))
  add(path_568316, "integrationAccountName", newJString(integrationAccountName))
  add(path_568316, "subscriptionId", newJString(subscriptionId))
  add(path_568316, "agreementName", newJString(agreementName))
  if agreement != nil:
    body_568318 = agreement
  result = call_568315.call(path_568316, query_568317, nil, nil, body_568318)

var agreementsCreateOrUpdate* = Call_AgreementsCreateOrUpdate_568305(
    name: "agreementsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_AgreementsCreateOrUpdate_568306, base: "",
    url: url_AgreementsCreateOrUpdate_568307, schemes: {Scheme.Https})
type
  Call_AgreementsGet_568293 = ref object of OpenApiRestCall_567667
proc url_AgreementsGet_568295(protocol: Scheme; host: string; base: string;
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

proc validate_AgreementsGet_568294(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account agreement.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   agreementName: JString (required)
  ##                : The integration account agreement name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568296 = path.getOrDefault("resourceGroupName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "resourceGroupName", valid_568296
  var valid_568297 = path.getOrDefault("integrationAccountName")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "integrationAccountName", valid_568297
  var valid_568298 = path.getOrDefault("subscriptionId")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "subscriptionId", valid_568298
  var valid_568299 = path.getOrDefault("agreementName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "agreementName", valid_568299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568300 = query.getOrDefault("api-version")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "api-version", valid_568300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568301: Call_AgreementsGet_568293; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account agreement.
  ## 
  let valid = call_568301.validator(path, query, header, formData, body)
  let scheme = call_568301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568301.url(scheme.get, call_568301.host, call_568301.base,
                         call_568301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568301, url, valid)

proc call*(call_568302: Call_AgreementsGet_568293; resourceGroupName: string;
          apiVersion: string; integrationAccountName: string;
          subscriptionId: string; agreementName: string): Recallable =
  ## agreementsGet
  ## Gets an integration account agreement.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   agreementName: string (required)
  ##                : The integration account agreement name.
  var path_568303 = newJObject()
  var query_568304 = newJObject()
  add(path_568303, "resourceGroupName", newJString(resourceGroupName))
  add(query_568304, "api-version", newJString(apiVersion))
  add(path_568303, "integrationAccountName", newJString(integrationAccountName))
  add(path_568303, "subscriptionId", newJString(subscriptionId))
  add(path_568303, "agreementName", newJString(agreementName))
  result = call_568302.call(path_568303, query_568304, nil, nil, nil)

var agreementsGet* = Call_AgreementsGet_568293(name: "agreementsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_AgreementsGet_568294, base: "", url: url_AgreementsGet_568295,
    schemes: {Scheme.Https})
type
  Call_AgreementsDelete_568319 = ref object of OpenApiRestCall_567667
proc url_AgreementsDelete_568321(protocol: Scheme; host: string; base: string;
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

proc validate_AgreementsDelete_568320(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes an integration account agreement.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   agreementName: JString (required)
  ##                : The integration account agreement name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568322 = path.getOrDefault("resourceGroupName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "resourceGroupName", valid_568322
  var valid_568323 = path.getOrDefault("integrationAccountName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "integrationAccountName", valid_568323
  var valid_568324 = path.getOrDefault("subscriptionId")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "subscriptionId", valid_568324
  var valid_568325 = path.getOrDefault("agreementName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "agreementName", valid_568325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568326 = query.getOrDefault("api-version")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "api-version", valid_568326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568327: Call_AgreementsDelete_568319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account agreement.
  ## 
  let valid = call_568327.validator(path, query, header, formData, body)
  let scheme = call_568327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568327.url(scheme.get, call_568327.host, call_568327.base,
                         call_568327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568327, url, valid)

proc call*(call_568328: Call_AgreementsDelete_568319; resourceGroupName: string;
          apiVersion: string; integrationAccountName: string;
          subscriptionId: string; agreementName: string): Recallable =
  ## agreementsDelete
  ## Deletes an integration account agreement.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   agreementName: string (required)
  ##                : The integration account agreement name.
  var path_568329 = newJObject()
  var query_568330 = newJObject()
  add(path_568329, "resourceGroupName", newJString(resourceGroupName))
  add(query_568330, "api-version", newJString(apiVersion))
  add(path_568329, "integrationAccountName", newJString(integrationAccountName))
  add(path_568329, "subscriptionId", newJString(subscriptionId))
  add(path_568329, "agreementName", newJString(agreementName))
  result = call_568328.call(path_568329, query_568330, nil, nil, nil)

var agreementsDelete* = Call_AgreementsDelete_568319(name: "agreementsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_AgreementsDelete_568320, base: "",
    url: url_AgreementsDelete_568321, schemes: {Scheme.Https})
type
  Call_AgreementsListContentCallbackUrl_568331 = ref object of OpenApiRestCall_567667
proc url_AgreementsListContentCallbackUrl_568333(protocol: Scheme; host: string;
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

proc validate_AgreementsListContentCallbackUrl_568332(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the content callback url.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   agreementName: JString (required)
  ##                : The integration account agreement name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568334 = path.getOrDefault("resourceGroupName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "resourceGroupName", valid_568334
  var valid_568335 = path.getOrDefault("integrationAccountName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "integrationAccountName", valid_568335
  var valid_568336 = path.getOrDefault("subscriptionId")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "subscriptionId", valid_568336
  var valid_568337 = path.getOrDefault("agreementName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "agreementName", valid_568337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568338 = query.getOrDefault("api-version")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "api-version", valid_568338
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

proc call*(call_568340: Call_AgreementsListContentCallbackUrl_568331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_568340.validator(path, query, header, formData, body)
  let scheme = call_568340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568340.url(scheme.get, call_568340.host, call_568340.base,
                         call_568340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568340, url, valid)

proc call*(call_568341: Call_AgreementsListContentCallbackUrl_568331;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          agreementName: string; listContentCallbackUrl: JsonNode): Recallable =
  ## agreementsListContentCallbackUrl
  ## Get the content callback url.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   agreementName: string (required)
  ##                : The integration account agreement name.
  ##   listContentCallbackUrl: JObject (required)
  var path_568342 = newJObject()
  var query_568343 = newJObject()
  var body_568344 = newJObject()
  add(path_568342, "resourceGroupName", newJString(resourceGroupName))
  add(query_568343, "api-version", newJString(apiVersion))
  add(path_568342, "integrationAccountName", newJString(integrationAccountName))
  add(path_568342, "subscriptionId", newJString(subscriptionId))
  add(path_568342, "agreementName", newJString(agreementName))
  if listContentCallbackUrl != nil:
    body_568344 = listContentCallbackUrl
  result = call_568341.call(path_568342, query_568343, nil, nil, body_568344)

var agreementsListContentCallbackUrl* = Call_AgreementsListContentCallbackUrl_568331(
    name: "agreementsListContentCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}/listContentCallbackUrl",
    validator: validate_AgreementsListContentCallbackUrl_568332, base: "",
    url: url_AgreementsListContentCallbackUrl_568333, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesList_568345 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountAssembliesList_568347(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAssembliesList_568346(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the assemblies for an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568348 = path.getOrDefault("resourceGroupName")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "resourceGroupName", valid_568348
  var valid_568349 = path.getOrDefault("integrationAccountName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "integrationAccountName", valid_568349
  var valid_568350 = path.getOrDefault("subscriptionId")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "subscriptionId", valid_568350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568351 = query.getOrDefault("api-version")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "api-version", valid_568351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568352: Call_IntegrationAccountAssembliesList_568345;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the assemblies for an integration account.
  ## 
  let valid = call_568352.validator(path, query, header, formData, body)
  let scheme = call_568352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568352.url(scheme.get, call_568352.host, call_568352.base,
                         call_568352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568352, url, valid)

proc call*(call_568353: Call_IntegrationAccountAssembliesList_568345;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string): Recallable =
  ## integrationAccountAssembliesList
  ## List the assemblies for an integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_568354 = newJObject()
  var query_568355 = newJObject()
  add(path_568354, "resourceGroupName", newJString(resourceGroupName))
  add(query_568355, "api-version", newJString(apiVersion))
  add(path_568354, "integrationAccountName", newJString(integrationAccountName))
  add(path_568354, "subscriptionId", newJString(subscriptionId))
  result = call_568353.call(path_568354, query_568355, nil, nil, nil)

var integrationAccountAssembliesList* = Call_IntegrationAccountAssembliesList_568345(
    name: "integrationAccountAssembliesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies",
    validator: validate_IntegrationAccountAssembliesList_568346, base: "",
    url: url_IntegrationAccountAssembliesList_568347, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesCreateOrUpdate_568368 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountAssembliesCreateOrUpdate_568370(protocol: Scheme;
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

proc validate_IntegrationAccountAssembliesCreateOrUpdate_568369(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an assembly for an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   assemblyArtifactName: JString (required)
  ##                       : The assembly artifact name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568371 = path.getOrDefault("resourceGroupName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "resourceGroupName", valid_568371
  var valid_568372 = path.getOrDefault("integrationAccountName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "integrationAccountName", valid_568372
  var valid_568373 = path.getOrDefault("subscriptionId")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "subscriptionId", valid_568373
  var valid_568374 = path.getOrDefault("assemblyArtifactName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "assemblyArtifactName", valid_568374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568375 = query.getOrDefault("api-version")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "api-version", valid_568375
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

proc call*(call_568377: Call_IntegrationAccountAssembliesCreateOrUpdate_568368;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an assembly for an integration account.
  ## 
  let valid = call_568377.validator(path, query, header, formData, body)
  let scheme = call_568377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568377.url(scheme.get, call_568377.host, call_568377.base,
                         call_568377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568377, url, valid)

proc call*(call_568378: Call_IntegrationAccountAssembliesCreateOrUpdate_568368;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          assemblyArtifact: JsonNode; assemblyArtifactName: string): Recallable =
  ## integrationAccountAssembliesCreateOrUpdate
  ## Create or update an assembly for an integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   assemblyArtifact: JObject (required)
  ##                   : The assembly artifact.
  ##   assemblyArtifactName: string (required)
  ##                       : The assembly artifact name.
  var path_568379 = newJObject()
  var query_568380 = newJObject()
  var body_568381 = newJObject()
  add(path_568379, "resourceGroupName", newJString(resourceGroupName))
  add(query_568380, "api-version", newJString(apiVersion))
  add(path_568379, "integrationAccountName", newJString(integrationAccountName))
  add(path_568379, "subscriptionId", newJString(subscriptionId))
  if assemblyArtifact != nil:
    body_568381 = assemblyArtifact
  add(path_568379, "assemblyArtifactName", newJString(assemblyArtifactName))
  result = call_568378.call(path_568379, query_568380, nil, nil, body_568381)

var integrationAccountAssembliesCreateOrUpdate* = Call_IntegrationAccountAssembliesCreateOrUpdate_568368(
    name: "integrationAccountAssembliesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}",
    validator: validate_IntegrationAccountAssembliesCreateOrUpdate_568369,
    base: "", url: url_IntegrationAccountAssembliesCreateOrUpdate_568370,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesGet_568356 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountAssembliesGet_568358(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAssembliesGet_568357(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an assembly for an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   assemblyArtifactName: JString (required)
  ##                       : The assembly artifact name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568359 = path.getOrDefault("resourceGroupName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "resourceGroupName", valid_568359
  var valid_568360 = path.getOrDefault("integrationAccountName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "integrationAccountName", valid_568360
  var valid_568361 = path.getOrDefault("subscriptionId")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "subscriptionId", valid_568361
  var valid_568362 = path.getOrDefault("assemblyArtifactName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "assemblyArtifactName", valid_568362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568363 = query.getOrDefault("api-version")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "api-version", valid_568363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568364: Call_IntegrationAccountAssembliesGet_568356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an assembly for an integration account.
  ## 
  let valid = call_568364.validator(path, query, header, formData, body)
  let scheme = call_568364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568364.url(scheme.get, call_568364.host, call_568364.base,
                         call_568364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568364, url, valid)

proc call*(call_568365: Call_IntegrationAccountAssembliesGet_568356;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          assemblyArtifactName: string): Recallable =
  ## integrationAccountAssembliesGet
  ## Get an assembly for an integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   assemblyArtifactName: string (required)
  ##                       : The assembly artifact name.
  var path_568366 = newJObject()
  var query_568367 = newJObject()
  add(path_568366, "resourceGroupName", newJString(resourceGroupName))
  add(query_568367, "api-version", newJString(apiVersion))
  add(path_568366, "integrationAccountName", newJString(integrationAccountName))
  add(path_568366, "subscriptionId", newJString(subscriptionId))
  add(path_568366, "assemblyArtifactName", newJString(assemblyArtifactName))
  result = call_568365.call(path_568366, query_568367, nil, nil, nil)

var integrationAccountAssembliesGet* = Call_IntegrationAccountAssembliesGet_568356(
    name: "integrationAccountAssembliesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}",
    validator: validate_IntegrationAccountAssembliesGet_568357, base: "",
    url: url_IntegrationAccountAssembliesGet_568358, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesDelete_568382 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountAssembliesDelete_568384(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAssembliesDelete_568383(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an assembly for an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   assemblyArtifactName: JString (required)
  ##                       : The assembly artifact name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568385 = path.getOrDefault("resourceGroupName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "resourceGroupName", valid_568385
  var valid_568386 = path.getOrDefault("integrationAccountName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "integrationAccountName", valid_568386
  var valid_568387 = path.getOrDefault("subscriptionId")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "subscriptionId", valid_568387
  var valid_568388 = path.getOrDefault("assemblyArtifactName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "assemblyArtifactName", valid_568388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568389 = query.getOrDefault("api-version")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "api-version", valid_568389
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568390: Call_IntegrationAccountAssembliesDelete_568382;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an assembly for an integration account.
  ## 
  let valid = call_568390.validator(path, query, header, formData, body)
  let scheme = call_568390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568390.url(scheme.get, call_568390.host, call_568390.base,
                         call_568390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568390, url, valid)

proc call*(call_568391: Call_IntegrationAccountAssembliesDelete_568382;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          assemblyArtifactName: string): Recallable =
  ## integrationAccountAssembliesDelete
  ## Delete an assembly for an integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   assemblyArtifactName: string (required)
  ##                       : The assembly artifact name.
  var path_568392 = newJObject()
  var query_568393 = newJObject()
  add(path_568392, "resourceGroupName", newJString(resourceGroupName))
  add(query_568393, "api-version", newJString(apiVersion))
  add(path_568392, "integrationAccountName", newJString(integrationAccountName))
  add(path_568392, "subscriptionId", newJString(subscriptionId))
  add(path_568392, "assemblyArtifactName", newJString(assemblyArtifactName))
  result = call_568391.call(path_568392, query_568393, nil, nil, nil)

var integrationAccountAssembliesDelete* = Call_IntegrationAccountAssembliesDelete_568382(
    name: "integrationAccountAssembliesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}",
    validator: validate_IntegrationAccountAssembliesDelete_568383, base: "",
    url: url_IntegrationAccountAssembliesDelete_568384, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesListContentCallbackUrl_568394 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountAssembliesListContentCallbackUrl_568396(
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

proc validate_IntegrationAccountAssembliesListContentCallbackUrl_568395(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the content callback url for an integration account assembly.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   assemblyArtifactName: JString (required)
  ##                       : The assembly artifact name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568397 = path.getOrDefault("resourceGroupName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "resourceGroupName", valid_568397
  var valid_568398 = path.getOrDefault("integrationAccountName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "integrationAccountName", valid_568398
  var valid_568399 = path.getOrDefault("subscriptionId")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "subscriptionId", valid_568399
  var valid_568400 = path.getOrDefault("assemblyArtifactName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "assemblyArtifactName", valid_568400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568401 = query.getOrDefault("api-version")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "api-version", valid_568401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568402: Call_IntegrationAccountAssembliesListContentCallbackUrl_568394;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url for an integration account assembly.
  ## 
  let valid = call_568402.validator(path, query, header, formData, body)
  let scheme = call_568402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568402.url(scheme.get, call_568402.host, call_568402.base,
                         call_568402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568402, url, valid)

proc call*(call_568403: Call_IntegrationAccountAssembliesListContentCallbackUrl_568394;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          assemblyArtifactName: string): Recallable =
  ## integrationAccountAssembliesListContentCallbackUrl
  ## Get the content callback url for an integration account assembly.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   assemblyArtifactName: string (required)
  ##                       : The assembly artifact name.
  var path_568404 = newJObject()
  var query_568405 = newJObject()
  add(path_568404, "resourceGroupName", newJString(resourceGroupName))
  add(query_568405, "api-version", newJString(apiVersion))
  add(path_568404, "integrationAccountName", newJString(integrationAccountName))
  add(path_568404, "subscriptionId", newJString(subscriptionId))
  add(path_568404, "assemblyArtifactName", newJString(assemblyArtifactName))
  result = call_568403.call(path_568404, query_568405, nil, nil, nil)

var integrationAccountAssembliesListContentCallbackUrl* = Call_IntegrationAccountAssembliesListContentCallbackUrl_568394(
    name: "integrationAccountAssembliesListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountAssembliesListContentCallbackUrl_568395,
    base: "", url: url_IntegrationAccountAssembliesListContentCallbackUrl_568396,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsList_568406 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountBatchConfigurationsList_568408(protocol: Scheme;
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

proc validate_IntegrationAccountBatchConfigurationsList_568407(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the batch configurations for an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568409 = path.getOrDefault("resourceGroupName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "resourceGroupName", valid_568409
  var valid_568410 = path.getOrDefault("integrationAccountName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "integrationAccountName", valid_568410
  var valid_568411 = path.getOrDefault("subscriptionId")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "subscriptionId", valid_568411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568412 = query.getOrDefault("api-version")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "api-version", valid_568412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568413: Call_IntegrationAccountBatchConfigurationsList_568406;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the batch configurations for an integration account.
  ## 
  let valid = call_568413.validator(path, query, header, formData, body)
  let scheme = call_568413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568413.url(scheme.get, call_568413.host, call_568413.base,
                         call_568413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568413, url, valid)

proc call*(call_568414: Call_IntegrationAccountBatchConfigurationsList_568406;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string): Recallable =
  ## integrationAccountBatchConfigurationsList
  ## List the batch configurations for an integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_568415 = newJObject()
  var query_568416 = newJObject()
  add(path_568415, "resourceGroupName", newJString(resourceGroupName))
  add(query_568416, "api-version", newJString(apiVersion))
  add(path_568415, "integrationAccountName", newJString(integrationAccountName))
  add(path_568415, "subscriptionId", newJString(subscriptionId))
  result = call_568414.call(path_568415, query_568416, nil, nil, nil)

var integrationAccountBatchConfigurationsList* = Call_IntegrationAccountBatchConfigurationsList_568406(
    name: "integrationAccountBatchConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations",
    validator: validate_IntegrationAccountBatchConfigurationsList_568407,
    base: "", url: url_IntegrationAccountBatchConfigurationsList_568408,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_568429 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountBatchConfigurationsCreateOrUpdate_568431(
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

proc validate_IntegrationAccountBatchConfigurationsCreateOrUpdate_568430(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create or update a batch configuration for an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   batchConfigurationName: JString (required)
  ##                         : The batch configuration name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568432 = path.getOrDefault("resourceGroupName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "resourceGroupName", valid_568432
  var valid_568433 = path.getOrDefault("integrationAccountName")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "integrationAccountName", valid_568433
  var valid_568434 = path.getOrDefault("subscriptionId")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "subscriptionId", valid_568434
  var valid_568435 = path.getOrDefault("batchConfigurationName")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "batchConfigurationName", valid_568435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568436 = query.getOrDefault("api-version")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "api-version", valid_568436
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

proc call*(call_568438: Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_568429;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a batch configuration for an integration account.
  ## 
  let valid = call_568438.validator(path, query, header, formData, body)
  let scheme = call_568438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568438.url(scheme.get, call_568438.host, call_568438.base,
                         call_568438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568438, url, valid)

proc call*(call_568439: Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_568429;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          batchConfigurationName: string; batchConfiguration: JsonNode): Recallable =
  ## integrationAccountBatchConfigurationsCreateOrUpdate
  ## Create or update a batch configuration for an integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   batchConfigurationName: string (required)
  ##                         : The batch configuration name.
  ##   batchConfiguration: JObject (required)
  ##                     : The batch configuration.
  var path_568440 = newJObject()
  var query_568441 = newJObject()
  var body_568442 = newJObject()
  add(path_568440, "resourceGroupName", newJString(resourceGroupName))
  add(query_568441, "api-version", newJString(apiVersion))
  add(path_568440, "integrationAccountName", newJString(integrationAccountName))
  add(path_568440, "subscriptionId", newJString(subscriptionId))
  add(path_568440, "batchConfigurationName", newJString(batchConfigurationName))
  if batchConfiguration != nil:
    body_568442 = batchConfiguration
  result = call_568439.call(path_568440, query_568441, nil, nil, body_568442)

var integrationAccountBatchConfigurationsCreateOrUpdate* = Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_568429(
    name: "integrationAccountBatchConfigurationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations/{batchConfigurationName}",
    validator: validate_IntegrationAccountBatchConfigurationsCreateOrUpdate_568430,
    base: "", url: url_IntegrationAccountBatchConfigurationsCreateOrUpdate_568431,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsGet_568417 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountBatchConfigurationsGet_568419(protocol: Scheme;
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

proc validate_IntegrationAccountBatchConfigurationsGet_568418(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a batch configuration for an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   batchConfigurationName: JString (required)
  ##                         : The batch configuration name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568420 = path.getOrDefault("resourceGroupName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "resourceGroupName", valid_568420
  var valid_568421 = path.getOrDefault("integrationAccountName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "integrationAccountName", valid_568421
  var valid_568422 = path.getOrDefault("subscriptionId")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "subscriptionId", valid_568422
  var valid_568423 = path.getOrDefault("batchConfigurationName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "batchConfigurationName", valid_568423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568424 = query.getOrDefault("api-version")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "api-version", valid_568424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568425: Call_IntegrationAccountBatchConfigurationsGet_568417;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a batch configuration for an integration account.
  ## 
  let valid = call_568425.validator(path, query, header, formData, body)
  let scheme = call_568425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568425.url(scheme.get, call_568425.host, call_568425.base,
                         call_568425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568425, url, valid)

proc call*(call_568426: Call_IntegrationAccountBatchConfigurationsGet_568417;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          batchConfigurationName: string): Recallable =
  ## integrationAccountBatchConfigurationsGet
  ## Get a batch configuration for an integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   batchConfigurationName: string (required)
  ##                         : The batch configuration name.
  var path_568427 = newJObject()
  var query_568428 = newJObject()
  add(path_568427, "resourceGroupName", newJString(resourceGroupName))
  add(query_568428, "api-version", newJString(apiVersion))
  add(path_568427, "integrationAccountName", newJString(integrationAccountName))
  add(path_568427, "subscriptionId", newJString(subscriptionId))
  add(path_568427, "batchConfigurationName", newJString(batchConfigurationName))
  result = call_568426.call(path_568427, query_568428, nil, nil, nil)

var integrationAccountBatchConfigurationsGet* = Call_IntegrationAccountBatchConfigurationsGet_568417(
    name: "integrationAccountBatchConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations/{batchConfigurationName}",
    validator: validate_IntegrationAccountBatchConfigurationsGet_568418, base: "",
    url: url_IntegrationAccountBatchConfigurationsGet_568419,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsDelete_568443 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountBatchConfigurationsDelete_568445(protocol: Scheme;
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

proc validate_IntegrationAccountBatchConfigurationsDelete_568444(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a batch configuration for an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   batchConfigurationName: JString (required)
  ##                         : The batch configuration name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568446 = path.getOrDefault("resourceGroupName")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "resourceGroupName", valid_568446
  var valid_568447 = path.getOrDefault("integrationAccountName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "integrationAccountName", valid_568447
  var valid_568448 = path.getOrDefault("subscriptionId")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "subscriptionId", valid_568448
  var valid_568449 = path.getOrDefault("batchConfigurationName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "batchConfigurationName", valid_568449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568450 = query.getOrDefault("api-version")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "api-version", valid_568450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568451: Call_IntegrationAccountBatchConfigurationsDelete_568443;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a batch configuration for an integration account.
  ## 
  let valid = call_568451.validator(path, query, header, formData, body)
  let scheme = call_568451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568451.url(scheme.get, call_568451.host, call_568451.base,
                         call_568451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568451, url, valid)

proc call*(call_568452: Call_IntegrationAccountBatchConfigurationsDelete_568443;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          batchConfigurationName: string): Recallable =
  ## integrationAccountBatchConfigurationsDelete
  ## Delete a batch configuration for an integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   batchConfigurationName: string (required)
  ##                         : The batch configuration name.
  var path_568453 = newJObject()
  var query_568454 = newJObject()
  add(path_568453, "resourceGroupName", newJString(resourceGroupName))
  add(query_568454, "api-version", newJString(apiVersion))
  add(path_568453, "integrationAccountName", newJString(integrationAccountName))
  add(path_568453, "subscriptionId", newJString(subscriptionId))
  add(path_568453, "batchConfigurationName", newJString(batchConfigurationName))
  result = call_568452.call(path_568453, query_568454, nil, nil, nil)

var integrationAccountBatchConfigurationsDelete* = Call_IntegrationAccountBatchConfigurationsDelete_568443(
    name: "integrationAccountBatchConfigurationsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations/{batchConfigurationName}",
    validator: validate_IntegrationAccountBatchConfigurationsDelete_568444,
    base: "", url: url_IntegrationAccountBatchConfigurationsDelete_568445,
    schemes: {Scheme.Https})
type
  Call_CertificatesListByIntegrationAccounts_568455 = ref object of OpenApiRestCall_567667
proc url_CertificatesListByIntegrationAccounts_568457(protocol: Scheme;
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

proc validate_CertificatesListByIntegrationAccounts_568456(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account certificates.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568458 = path.getOrDefault("resourceGroupName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "resourceGroupName", valid_568458
  var valid_568459 = path.getOrDefault("integrationAccountName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "integrationAccountName", valid_568459
  var valid_568460 = path.getOrDefault("subscriptionId")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "subscriptionId", valid_568460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568461 = query.getOrDefault("api-version")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "api-version", valid_568461
  var valid_568462 = query.getOrDefault("$top")
  valid_568462 = validateParameter(valid_568462, JInt, required = false, default = nil)
  if valid_568462 != nil:
    section.add "$top", valid_568462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568463: Call_CertificatesListByIntegrationAccounts_568455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account certificates.
  ## 
  let valid = call_568463.validator(path, query, header, formData, body)
  let scheme = call_568463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568463.url(scheme.get, call_568463.host, call_568463.base,
                         call_568463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568463, url, valid)

proc call*(call_568464: Call_CertificatesListByIntegrationAccounts_568455;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0): Recallable =
  ## certificatesListByIntegrationAccounts
  ## Gets a list of integration account certificates.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  var path_568465 = newJObject()
  var query_568466 = newJObject()
  add(path_568465, "resourceGroupName", newJString(resourceGroupName))
  add(query_568466, "api-version", newJString(apiVersion))
  add(path_568465, "integrationAccountName", newJString(integrationAccountName))
  add(path_568465, "subscriptionId", newJString(subscriptionId))
  add(query_568466, "$top", newJInt(Top))
  result = call_568464.call(path_568465, query_568466, nil, nil, nil)

var certificatesListByIntegrationAccounts* = Call_CertificatesListByIntegrationAccounts_568455(
    name: "certificatesListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates",
    validator: validate_CertificatesListByIntegrationAccounts_568456, base: "",
    url: url_CertificatesListByIntegrationAccounts_568457, schemes: {Scheme.Https})
type
  Call_CertificatesCreateOrUpdate_568479 = ref object of OpenApiRestCall_567667
proc url_CertificatesCreateOrUpdate_568481(protocol: Scheme; host: string;
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

proc validate_CertificatesCreateOrUpdate_568480(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   certificateName: JString (required)
  ##                  : The integration account certificate name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568482 = path.getOrDefault("resourceGroupName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "resourceGroupName", valid_568482
  var valid_568483 = path.getOrDefault("integrationAccountName")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "integrationAccountName", valid_568483
  var valid_568484 = path.getOrDefault("subscriptionId")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "subscriptionId", valid_568484
  var valid_568485 = path.getOrDefault("certificateName")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "certificateName", valid_568485
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568486 = query.getOrDefault("api-version")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "api-version", valid_568486
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

proc call*(call_568488: Call_CertificatesCreateOrUpdate_568479; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account certificate.
  ## 
  let valid = call_568488.validator(path, query, header, formData, body)
  let scheme = call_568488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568488.url(scheme.get, call_568488.host, call_568488.base,
                         call_568488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568488, url, valid)

proc call*(call_568489: Call_CertificatesCreateOrUpdate_568479;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          certificate: JsonNode; certificateName: string): Recallable =
  ## certificatesCreateOrUpdate
  ## Creates or updates an integration account certificate.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   certificate: JObject (required)
  ##              : The integration account certificate.
  ##   certificateName: string (required)
  ##                  : The integration account certificate name.
  var path_568490 = newJObject()
  var query_568491 = newJObject()
  var body_568492 = newJObject()
  add(path_568490, "resourceGroupName", newJString(resourceGroupName))
  add(query_568491, "api-version", newJString(apiVersion))
  add(path_568490, "integrationAccountName", newJString(integrationAccountName))
  add(path_568490, "subscriptionId", newJString(subscriptionId))
  if certificate != nil:
    body_568492 = certificate
  add(path_568490, "certificateName", newJString(certificateName))
  result = call_568489.call(path_568490, query_568491, nil, nil, body_568492)

var certificatesCreateOrUpdate* = Call_CertificatesCreateOrUpdate_568479(
    name: "certificatesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_CertificatesCreateOrUpdate_568480, base: "",
    url: url_CertificatesCreateOrUpdate_568481, schemes: {Scheme.Https})
type
  Call_CertificatesGet_568467 = ref object of OpenApiRestCall_567667
proc url_CertificatesGet_568469(protocol: Scheme; host: string; base: string;
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

proc validate_CertificatesGet_568468(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets an integration account certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   certificateName: JString (required)
  ##                  : The integration account certificate name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568470 = path.getOrDefault("resourceGroupName")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "resourceGroupName", valid_568470
  var valid_568471 = path.getOrDefault("integrationAccountName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "integrationAccountName", valid_568471
  var valid_568472 = path.getOrDefault("subscriptionId")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "subscriptionId", valid_568472
  var valid_568473 = path.getOrDefault("certificateName")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "certificateName", valid_568473
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568474 = query.getOrDefault("api-version")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "api-version", valid_568474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568475: Call_CertificatesGet_568467; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account certificate.
  ## 
  let valid = call_568475.validator(path, query, header, formData, body)
  let scheme = call_568475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568475.url(scheme.get, call_568475.host, call_568475.base,
                         call_568475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568475, url, valid)

proc call*(call_568476: Call_CertificatesGet_568467; resourceGroupName: string;
          apiVersion: string; integrationAccountName: string;
          subscriptionId: string; certificateName: string): Recallable =
  ## certificatesGet
  ## Gets an integration account certificate.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   certificateName: string (required)
  ##                  : The integration account certificate name.
  var path_568477 = newJObject()
  var query_568478 = newJObject()
  add(path_568477, "resourceGroupName", newJString(resourceGroupName))
  add(query_568478, "api-version", newJString(apiVersion))
  add(path_568477, "integrationAccountName", newJString(integrationAccountName))
  add(path_568477, "subscriptionId", newJString(subscriptionId))
  add(path_568477, "certificateName", newJString(certificateName))
  result = call_568476.call(path_568477, query_568478, nil, nil, nil)

var certificatesGet* = Call_CertificatesGet_568467(name: "certificatesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_CertificatesGet_568468, base: "", url: url_CertificatesGet_568469,
    schemes: {Scheme.Https})
type
  Call_CertificatesDelete_568493 = ref object of OpenApiRestCall_567667
proc url_CertificatesDelete_568495(protocol: Scheme; host: string; base: string;
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

proc validate_CertificatesDelete_568494(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes an integration account certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   certificateName: JString (required)
  ##                  : The integration account certificate name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568496 = path.getOrDefault("resourceGroupName")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "resourceGroupName", valid_568496
  var valid_568497 = path.getOrDefault("integrationAccountName")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "integrationAccountName", valid_568497
  var valid_568498 = path.getOrDefault("subscriptionId")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "subscriptionId", valid_568498
  var valid_568499 = path.getOrDefault("certificateName")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "certificateName", valid_568499
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568500 = query.getOrDefault("api-version")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "api-version", valid_568500
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568501: Call_CertificatesDelete_568493; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account certificate.
  ## 
  let valid = call_568501.validator(path, query, header, formData, body)
  let scheme = call_568501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568501.url(scheme.get, call_568501.host, call_568501.base,
                         call_568501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568501, url, valid)

proc call*(call_568502: Call_CertificatesDelete_568493; resourceGroupName: string;
          apiVersion: string; integrationAccountName: string;
          subscriptionId: string; certificateName: string): Recallable =
  ## certificatesDelete
  ## Deletes an integration account certificate.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   certificateName: string (required)
  ##                  : The integration account certificate name.
  var path_568503 = newJObject()
  var query_568504 = newJObject()
  add(path_568503, "resourceGroupName", newJString(resourceGroupName))
  add(query_568504, "api-version", newJString(apiVersion))
  add(path_568503, "integrationAccountName", newJString(integrationAccountName))
  add(path_568503, "subscriptionId", newJString(subscriptionId))
  add(path_568503, "certificateName", newJString(certificateName))
  result = call_568502.call(path_568503, query_568504, nil, nil, nil)

var certificatesDelete* = Call_CertificatesDelete_568493(
    name: "certificatesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_CertificatesDelete_568494, base: "",
    url: url_CertificatesDelete_568495, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsGetCallbackUrl_568505 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountsGetCallbackUrl_568507(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsGetCallbackUrl_568506(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the integration account callback URL.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568508 = path.getOrDefault("resourceGroupName")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "resourceGroupName", valid_568508
  var valid_568509 = path.getOrDefault("integrationAccountName")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "integrationAccountName", valid_568509
  var valid_568510 = path.getOrDefault("subscriptionId")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "subscriptionId", valid_568510
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568511 = query.getOrDefault("api-version")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "api-version", valid_568511
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

proc call*(call_568513: Call_IntegrationAccountsGetCallbackUrl_568505;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the integration account callback URL.
  ## 
  let valid = call_568513.validator(path, query, header, formData, body)
  let scheme = call_568513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568513.url(scheme.get, call_568513.host, call_568513.base,
                         call_568513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568513, url, valid)

proc call*(call_568514: Call_IntegrationAccountsGetCallbackUrl_568505;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## integrationAccountsGetCallbackUrl
  ## Gets the integration account callback URL.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   parameters: JObject (required)
  ##             : The callback URL parameters.
  var path_568515 = newJObject()
  var query_568516 = newJObject()
  var body_568517 = newJObject()
  add(path_568515, "resourceGroupName", newJString(resourceGroupName))
  add(query_568516, "api-version", newJString(apiVersion))
  add(path_568515, "integrationAccountName", newJString(integrationAccountName))
  add(path_568515, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568517 = parameters
  result = call_568514.call(path_568515, query_568516, nil, nil, body_568517)

var integrationAccountsGetCallbackUrl* = Call_IntegrationAccountsGetCallbackUrl_568505(
    name: "integrationAccountsGetCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/listCallbackUrl",
    validator: validate_IntegrationAccountsGetCallbackUrl_568506, base: "",
    url: url_IntegrationAccountsGetCallbackUrl_568507, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListKeyVaultKeys_568518 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountsListKeyVaultKeys_568520(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsListKeyVaultKeys_568519(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the integration account's Key Vault keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568521 = path.getOrDefault("resourceGroupName")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "resourceGroupName", valid_568521
  var valid_568522 = path.getOrDefault("integrationAccountName")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "integrationAccountName", valid_568522
  var valid_568523 = path.getOrDefault("subscriptionId")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "subscriptionId", valid_568523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568524 = query.getOrDefault("api-version")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "api-version", valid_568524
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

proc call*(call_568526: Call_IntegrationAccountsListKeyVaultKeys_568518;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the integration account's Key Vault keys.
  ## 
  let valid = call_568526.validator(path, query, header, formData, body)
  let scheme = call_568526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568526.url(scheme.get, call_568526.host, call_568526.base,
                         call_568526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568526, url, valid)

proc call*(call_568527: Call_IntegrationAccountsListKeyVaultKeys_568518;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          listKeyVaultKeys: JsonNode): Recallable =
  ## integrationAccountsListKeyVaultKeys
  ## Gets the integration account's Key Vault keys.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   listKeyVaultKeys: JObject (required)
  ##                   : The key vault parameters.
  var path_568528 = newJObject()
  var query_568529 = newJObject()
  var body_568530 = newJObject()
  add(path_568528, "resourceGroupName", newJString(resourceGroupName))
  add(query_568529, "api-version", newJString(apiVersion))
  add(path_568528, "integrationAccountName", newJString(integrationAccountName))
  add(path_568528, "subscriptionId", newJString(subscriptionId))
  if listKeyVaultKeys != nil:
    body_568530 = listKeyVaultKeys
  result = call_568527.call(path_568528, query_568529, nil, nil, body_568530)

var integrationAccountsListKeyVaultKeys* = Call_IntegrationAccountsListKeyVaultKeys_568518(
    name: "integrationAccountsListKeyVaultKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/listKeyVaultKeys",
    validator: validate_IntegrationAccountsListKeyVaultKeys_568519, base: "",
    url: url_IntegrationAccountsListKeyVaultKeys_568520, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsLogTrackingEvents_568531 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountsLogTrackingEvents_568533(protocol: Scheme;
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

proc validate_IntegrationAccountsLogTrackingEvents_568532(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Logs the integration account's tracking events.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568534 = path.getOrDefault("resourceGroupName")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "resourceGroupName", valid_568534
  var valid_568535 = path.getOrDefault("integrationAccountName")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "integrationAccountName", valid_568535
  var valid_568536 = path.getOrDefault("subscriptionId")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = nil)
  if valid_568536 != nil:
    section.add "subscriptionId", valid_568536
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568537 = query.getOrDefault("api-version")
  valid_568537 = validateParameter(valid_568537, JString, required = true,
                                 default = nil)
  if valid_568537 != nil:
    section.add "api-version", valid_568537
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

proc call*(call_568539: Call_IntegrationAccountsLogTrackingEvents_568531;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Logs the integration account's tracking events.
  ## 
  let valid = call_568539.validator(path, query, header, formData, body)
  let scheme = call_568539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568539.url(scheme.get, call_568539.host, call_568539.base,
                         call_568539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568539, url, valid)

proc call*(call_568540: Call_IntegrationAccountsLogTrackingEvents_568531;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          logTrackingEvents: JsonNode): Recallable =
  ## integrationAccountsLogTrackingEvents
  ## Logs the integration account's tracking events.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   logTrackingEvents: JObject (required)
  ##                    : The callback URL parameters.
  var path_568541 = newJObject()
  var query_568542 = newJObject()
  var body_568543 = newJObject()
  add(path_568541, "resourceGroupName", newJString(resourceGroupName))
  add(query_568542, "api-version", newJString(apiVersion))
  add(path_568541, "integrationAccountName", newJString(integrationAccountName))
  add(path_568541, "subscriptionId", newJString(subscriptionId))
  if logTrackingEvents != nil:
    body_568543 = logTrackingEvents
  result = call_568540.call(path_568541, query_568542, nil, nil, body_568543)

var integrationAccountsLogTrackingEvents* = Call_IntegrationAccountsLogTrackingEvents_568531(
    name: "integrationAccountsLogTrackingEvents", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/logTrackingEvents",
    validator: validate_IntegrationAccountsLogTrackingEvents_568532, base: "",
    url: url_IntegrationAccountsLogTrackingEvents_568533, schemes: {Scheme.Https})
type
  Call_MapsListByIntegrationAccounts_568544 = ref object of OpenApiRestCall_567667
proc url_MapsListByIntegrationAccounts_568546(protocol: Scheme; host: string;
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

proc validate_MapsListByIntegrationAccounts_568545(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account maps.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568547 = path.getOrDefault("resourceGroupName")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "resourceGroupName", valid_568547
  var valid_568548 = path.getOrDefault("integrationAccountName")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "integrationAccountName", valid_568548
  var valid_568549 = path.getOrDefault("subscriptionId")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "subscriptionId", valid_568549
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
  var valid_568550 = query.getOrDefault("api-version")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "api-version", valid_568550
  var valid_568551 = query.getOrDefault("$top")
  valid_568551 = validateParameter(valid_568551, JInt, required = false, default = nil)
  if valid_568551 != nil:
    section.add "$top", valid_568551
  var valid_568552 = query.getOrDefault("$filter")
  valid_568552 = validateParameter(valid_568552, JString, required = false,
                                 default = nil)
  if valid_568552 != nil:
    section.add "$filter", valid_568552
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568553: Call_MapsListByIntegrationAccounts_568544; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account maps.
  ## 
  let valid = call_568553.validator(path, query, header, formData, body)
  let scheme = call_568553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568553.url(scheme.get, call_568553.host, call_568553.base,
                         call_568553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568553, url, valid)

proc call*(call_568554: Call_MapsListByIntegrationAccounts_568544;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## mapsListByIntegrationAccounts
  ## Gets a list of integration account maps.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   Filter: string
  ##         : The filter to apply on the operation. Options for filters include: MapType.
  var path_568555 = newJObject()
  var query_568556 = newJObject()
  add(path_568555, "resourceGroupName", newJString(resourceGroupName))
  add(query_568556, "api-version", newJString(apiVersion))
  add(path_568555, "integrationAccountName", newJString(integrationAccountName))
  add(path_568555, "subscriptionId", newJString(subscriptionId))
  add(query_568556, "$top", newJInt(Top))
  add(query_568556, "$filter", newJString(Filter))
  result = call_568554.call(path_568555, query_568556, nil, nil, nil)

var mapsListByIntegrationAccounts* = Call_MapsListByIntegrationAccounts_568544(
    name: "mapsListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps",
    validator: validate_MapsListByIntegrationAccounts_568545, base: "",
    url: url_MapsListByIntegrationAccounts_568546, schemes: {Scheme.Https})
type
  Call_MapsCreateOrUpdate_568569 = ref object of OpenApiRestCall_567667
proc url_MapsCreateOrUpdate_568571(protocol: Scheme; host: string; base: string;
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

proc validate_MapsCreateOrUpdate_568570(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates or updates an integration account map.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   mapName: JString (required)
  ##          : The integration account map name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568572 = path.getOrDefault("resourceGroupName")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "resourceGroupName", valid_568572
  var valid_568573 = path.getOrDefault("mapName")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "mapName", valid_568573
  var valid_568574 = path.getOrDefault("integrationAccountName")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "integrationAccountName", valid_568574
  var valid_568575 = path.getOrDefault("subscriptionId")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "subscriptionId", valid_568575
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568576 = query.getOrDefault("api-version")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "api-version", valid_568576
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

proc call*(call_568578: Call_MapsCreateOrUpdate_568569; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account map.
  ## 
  let valid = call_568578.validator(path, query, header, formData, body)
  let scheme = call_568578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568578.url(scheme.get, call_568578.host, call_568578.base,
                         call_568578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568578, url, valid)

proc call*(call_568579: Call_MapsCreateOrUpdate_568569; resourceGroupName: string;
          map: JsonNode; mapName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string): Recallable =
  ## mapsCreateOrUpdate
  ## Creates or updates an integration account map.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   map: JObject (required)
  ##      : The integration account map.
  ##   mapName: string (required)
  ##          : The integration account map name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_568580 = newJObject()
  var query_568581 = newJObject()
  var body_568582 = newJObject()
  add(path_568580, "resourceGroupName", newJString(resourceGroupName))
  if map != nil:
    body_568582 = map
  add(path_568580, "mapName", newJString(mapName))
  add(query_568581, "api-version", newJString(apiVersion))
  add(path_568580, "integrationAccountName", newJString(integrationAccountName))
  add(path_568580, "subscriptionId", newJString(subscriptionId))
  result = call_568579.call(path_568580, query_568581, nil, nil, body_568582)

var mapsCreateOrUpdate* = Call_MapsCreateOrUpdate_568569(
    name: "mapsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_MapsCreateOrUpdate_568570, base: "",
    url: url_MapsCreateOrUpdate_568571, schemes: {Scheme.Https})
type
  Call_MapsGet_568557 = ref object of OpenApiRestCall_567667
proc url_MapsGet_568559(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_MapsGet_568558(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account map.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   mapName: JString (required)
  ##          : The integration account map name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568560 = path.getOrDefault("resourceGroupName")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "resourceGroupName", valid_568560
  var valid_568561 = path.getOrDefault("mapName")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "mapName", valid_568561
  var valid_568562 = path.getOrDefault("integrationAccountName")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "integrationAccountName", valid_568562
  var valid_568563 = path.getOrDefault("subscriptionId")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "subscriptionId", valid_568563
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568564 = query.getOrDefault("api-version")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "api-version", valid_568564
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568565: Call_MapsGet_568557; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account map.
  ## 
  let valid = call_568565.validator(path, query, header, formData, body)
  let scheme = call_568565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568565.url(scheme.get, call_568565.host, call_568565.base,
                         call_568565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568565, url, valid)

proc call*(call_568566: Call_MapsGet_568557; resourceGroupName: string;
          mapName: string; apiVersion: string; integrationAccountName: string;
          subscriptionId: string): Recallable =
  ## mapsGet
  ## Gets an integration account map.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   mapName: string (required)
  ##          : The integration account map name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_568567 = newJObject()
  var query_568568 = newJObject()
  add(path_568567, "resourceGroupName", newJString(resourceGroupName))
  add(path_568567, "mapName", newJString(mapName))
  add(query_568568, "api-version", newJString(apiVersion))
  add(path_568567, "integrationAccountName", newJString(integrationAccountName))
  add(path_568567, "subscriptionId", newJString(subscriptionId))
  result = call_568566.call(path_568567, query_568568, nil, nil, nil)

var mapsGet* = Call_MapsGet_568557(name: "mapsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
                                validator: validate_MapsGet_568558, base: "",
                                url: url_MapsGet_568559, schemes: {Scheme.Https})
type
  Call_MapsDelete_568583 = ref object of OpenApiRestCall_567667
proc url_MapsDelete_568585(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_MapsDelete_568584(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account map.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   mapName: JString (required)
  ##          : The integration account map name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568586 = path.getOrDefault("resourceGroupName")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "resourceGroupName", valid_568586
  var valid_568587 = path.getOrDefault("mapName")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "mapName", valid_568587
  var valid_568588 = path.getOrDefault("integrationAccountName")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "integrationAccountName", valid_568588
  var valid_568589 = path.getOrDefault("subscriptionId")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "subscriptionId", valid_568589
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568590 = query.getOrDefault("api-version")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "api-version", valid_568590
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568591: Call_MapsDelete_568583; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account map.
  ## 
  let valid = call_568591.validator(path, query, header, formData, body)
  let scheme = call_568591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568591.url(scheme.get, call_568591.host, call_568591.base,
                         call_568591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568591, url, valid)

proc call*(call_568592: Call_MapsDelete_568583; resourceGroupName: string;
          mapName: string; apiVersion: string; integrationAccountName: string;
          subscriptionId: string): Recallable =
  ## mapsDelete
  ## Deletes an integration account map.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   mapName: string (required)
  ##          : The integration account map name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_568593 = newJObject()
  var query_568594 = newJObject()
  add(path_568593, "resourceGroupName", newJString(resourceGroupName))
  add(path_568593, "mapName", newJString(mapName))
  add(query_568594, "api-version", newJString(apiVersion))
  add(path_568593, "integrationAccountName", newJString(integrationAccountName))
  add(path_568593, "subscriptionId", newJString(subscriptionId))
  result = call_568592.call(path_568593, query_568594, nil, nil, nil)

var mapsDelete* = Call_MapsDelete_568583(name: "mapsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
                                      validator: validate_MapsDelete_568584,
                                      base: "", url: url_MapsDelete_568585,
                                      schemes: {Scheme.Https})
type
  Call_MapsListContentCallbackUrl_568595 = ref object of OpenApiRestCall_567667
proc url_MapsListContentCallbackUrl_568597(protocol: Scheme; host: string;
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

proc validate_MapsListContentCallbackUrl_568596(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the content callback url.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   mapName: JString (required)
  ##          : The integration account map name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568598 = path.getOrDefault("resourceGroupName")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "resourceGroupName", valid_568598
  var valid_568599 = path.getOrDefault("mapName")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "mapName", valid_568599
  var valid_568600 = path.getOrDefault("integrationAccountName")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "integrationAccountName", valid_568600
  var valid_568601 = path.getOrDefault("subscriptionId")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "subscriptionId", valid_568601
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568602 = query.getOrDefault("api-version")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "api-version", valid_568602
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

proc call*(call_568604: Call_MapsListContentCallbackUrl_568595; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_568604.validator(path, query, header, formData, body)
  let scheme = call_568604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568604.url(scheme.get, call_568604.host, call_568604.base,
                         call_568604.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568604, url, valid)

proc call*(call_568605: Call_MapsListContentCallbackUrl_568595;
          resourceGroupName: string; mapName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          listContentCallbackUrl: JsonNode): Recallable =
  ## mapsListContentCallbackUrl
  ## Get the content callback url.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   mapName: string (required)
  ##          : The integration account map name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   listContentCallbackUrl: JObject (required)
  var path_568606 = newJObject()
  var query_568607 = newJObject()
  var body_568608 = newJObject()
  add(path_568606, "resourceGroupName", newJString(resourceGroupName))
  add(path_568606, "mapName", newJString(mapName))
  add(query_568607, "api-version", newJString(apiVersion))
  add(path_568606, "integrationAccountName", newJString(integrationAccountName))
  add(path_568606, "subscriptionId", newJString(subscriptionId))
  if listContentCallbackUrl != nil:
    body_568608 = listContentCallbackUrl
  result = call_568605.call(path_568606, query_568607, nil, nil, body_568608)

var mapsListContentCallbackUrl* = Call_MapsListContentCallbackUrl_568595(
    name: "mapsListContentCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}/listContentCallbackUrl",
    validator: validate_MapsListContentCallbackUrl_568596, base: "",
    url: url_MapsListContentCallbackUrl_568597, schemes: {Scheme.Https})
type
  Call_PartnersListByIntegrationAccounts_568609 = ref object of OpenApiRestCall_567667
proc url_PartnersListByIntegrationAccounts_568611(protocol: Scheme; host: string;
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

proc validate_PartnersListByIntegrationAccounts_568610(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account partners.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568612 = path.getOrDefault("resourceGroupName")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "resourceGroupName", valid_568612
  var valid_568613 = path.getOrDefault("integrationAccountName")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "integrationAccountName", valid_568613
  var valid_568614 = path.getOrDefault("subscriptionId")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "subscriptionId", valid_568614
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
  var valid_568615 = query.getOrDefault("api-version")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "api-version", valid_568615
  var valid_568616 = query.getOrDefault("$top")
  valid_568616 = validateParameter(valid_568616, JInt, required = false, default = nil)
  if valid_568616 != nil:
    section.add "$top", valid_568616
  var valid_568617 = query.getOrDefault("$filter")
  valid_568617 = validateParameter(valid_568617, JString, required = false,
                                 default = nil)
  if valid_568617 != nil:
    section.add "$filter", valid_568617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568618: Call_PartnersListByIntegrationAccounts_568609;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account partners.
  ## 
  let valid = call_568618.validator(path, query, header, formData, body)
  let scheme = call_568618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568618.url(scheme.get, call_568618.host, call_568618.base,
                         call_568618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568618, url, valid)

proc call*(call_568619: Call_PartnersListByIntegrationAccounts_568609;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## partnersListByIntegrationAccounts
  ## Gets a list of integration account partners.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   Filter: string
  ##         : The filter to apply on the operation. Options for filters include: PartnerType.
  var path_568620 = newJObject()
  var query_568621 = newJObject()
  add(path_568620, "resourceGroupName", newJString(resourceGroupName))
  add(query_568621, "api-version", newJString(apiVersion))
  add(path_568620, "integrationAccountName", newJString(integrationAccountName))
  add(path_568620, "subscriptionId", newJString(subscriptionId))
  add(query_568621, "$top", newJInt(Top))
  add(query_568621, "$filter", newJString(Filter))
  result = call_568619.call(path_568620, query_568621, nil, nil, nil)

var partnersListByIntegrationAccounts* = Call_PartnersListByIntegrationAccounts_568609(
    name: "partnersListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners",
    validator: validate_PartnersListByIntegrationAccounts_568610, base: "",
    url: url_PartnersListByIntegrationAccounts_568611, schemes: {Scheme.Https})
type
  Call_PartnersCreateOrUpdate_568634 = ref object of OpenApiRestCall_567667
proc url_PartnersCreateOrUpdate_568636(protocol: Scheme; host: string; base: string;
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

proc validate_PartnersCreateOrUpdate_568635(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account partner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   partnerName: JString (required)
  ##              : The integration account partner name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568637 = path.getOrDefault("resourceGroupName")
  valid_568637 = validateParameter(valid_568637, JString, required = true,
                                 default = nil)
  if valid_568637 != nil:
    section.add "resourceGroupName", valid_568637
  var valid_568638 = path.getOrDefault("integrationAccountName")
  valid_568638 = validateParameter(valid_568638, JString, required = true,
                                 default = nil)
  if valid_568638 != nil:
    section.add "integrationAccountName", valid_568638
  var valid_568639 = path.getOrDefault("subscriptionId")
  valid_568639 = validateParameter(valid_568639, JString, required = true,
                                 default = nil)
  if valid_568639 != nil:
    section.add "subscriptionId", valid_568639
  var valid_568640 = path.getOrDefault("partnerName")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "partnerName", valid_568640
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568641 = query.getOrDefault("api-version")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "api-version", valid_568641
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

proc call*(call_568643: Call_PartnersCreateOrUpdate_568634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account partner.
  ## 
  let valid = call_568643.validator(path, query, header, formData, body)
  let scheme = call_568643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568643.url(scheme.get, call_568643.host, call_568643.base,
                         call_568643.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568643, url, valid)

proc call*(call_568644: Call_PartnersCreateOrUpdate_568634;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; partner: JsonNode;
          partnerName: string): Recallable =
  ## partnersCreateOrUpdate
  ## Creates or updates an integration account partner.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   partner: JObject (required)
  ##          : The integration account partner.
  ##   partnerName: string (required)
  ##              : The integration account partner name.
  var path_568645 = newJObject()
  var query_568646 = newJObject()
  var body_568647 = newJObject()
  add(path_568645, "resourceGroupName", newJString(resourceGroupName))
  add(query_568646, "api-version", newJString(apiVersion))
  add(path_568645, "integrationAccountName", newJString(integrationAccountName))
  add(path_568645, "subscriptionId", newJString(subscriptionId))
  if partner != nil:
    body_568647 = partner
  add(path_568645, "partnerName", newJString(partnerName))
  result = call_568644.call(path_568645, query_568646, nil, nil, body_568647)

var partnersCreateOrUpdate* = Call_PartnersCreateOrUpdate_568634(
    name: "partnersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_PartnersCreateOrUpdate_568635, base: "",
    url: url_PartnersCreateOrUpdate_568636, schemes: {Scheme.Https})
type
  Call_PartnersGet_568622 = ref object of OpenApiRestCall_567667
proc url_PartnersGet_568624(protocol: Scheme; host: string; base: string;
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

proc validate_PartnersGet_568623(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account partner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   partnerName: JString (required)
  ##              : The integration account partner name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568625 = path.getOrDefault("resourceGroupName")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "resourceGroupName", valid_568625
  var valid_568626 = path.getOrDefault("integrationAccountName")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "integrationAccountName", valid_568626
  var valid_568627 = path.getOrDefault("subscriptionId")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "subscriptionId", valid_568627
  var valid_568628 = path.getOrDefault("partnerName")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "partnerName", valid_568628
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568629 = query.getOrDefault("api-version")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "api-version", valid_568629
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568630: Call_PartnersGet_568622; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account partner.
  ## 
  let valid = call_568630.validator(path, query, header, formData, body)
  let scheme = call_568630.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568630.url(scheme.get, call_568630.host, call_568630.base,
                         call_568630.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568630, url, valid)

proc call*(call_568631: Call_PartnersGet_568622; resourceGroupName: string;
          apiVersion: string; integrationAccountName: string;
          subscriptionId: string; partnerName: string): Recallable =
  ## partnersGet
  ## Gets an integration account partner.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   partnerName: string (required)
  ##              : The integration account partner name.
  var path_568632 = newJObject()
  var query_568633 = newJObject()
  add(path_568632, "resourceGroupName", newJString(resourceGroupName))
  add(query_568633, "api-version", newJString(apiVersion))
  add(path_568632, "integrationAccountName", newJString(integrationAccountName))
  add(path_568632, "subscriptionId", newJString(subscriptionId))
  add(path_568632, "partnerName", newJString(partnerName))
  result = call_568631.call(path_568632, query_568633, nil, nil, nil)

var partnersGet* = Call_PartnersGet_568622(name: "partnersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
                                        validator: validate_PartnersGet_568623,
                                        base: "", url: url_PartnersGet_568624,
                                        schemes: {Scheme.Https})
type
  Call_PartnersDelete_568648 = ref object of OpenApiRestCall_567667
proc url_PartnersDelete_568650(protocol: Scheme; host: string; base: string;
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

proc validate_PartnersDelete_568649(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes an integration account partner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   partnerName: JString (required)
  ##              : The integration account partner name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568651 = path.getOrDefault("resourceGroupName")
  valid_568651 = validateParameter(valid_568651, JString, required = true,
                                 default = nil)
  if valid_568651 != nil:
    section.add "resourceGroupName", valid_568651
  var valid_568652 = path.getOrDefault("integrationAccountName")
  valid_568652 = validateParameter(valid_568652, JString, required = true,
                                 default = nil)
  if valid_568652 != nil:
    section.add "integrationAccountName", valid_568652
  var valid_568653 = path.getOrDefault("subscriptionId")
  valid_568653 = validateParameter(valid_568653, JString, required = true,
                                 default = nil)
  if valid_568653 != nil:
    section.add "subscriptionId", valid_568653
  var valid_568654 = path.getOrDefault("partnerName")
  valid_568654 = validateParameter(valid_568654, JString, required = true,
                                 default = nil)
  if valid_568654 != nil:
    section.add "partnerName", valid_568654
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568655 = query.getOrDefault("api-version")
  valid_568655 = validateParameter(valid_568655, JString, required = true,
                                 default = nil)
  if valid_568655 != nil:
    section.add "api-version", valid_568655
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568656: Call_PartnersDelete_568648; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account partner.
  ## 
  let valid = call_568656.validator(path, query, header, formData, body)
  let scheme = call_568656.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568656.url(scheme.get, call_568656.host, call_568656.base,
                         call_568656.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568656, url, valid)

proc call*(call_568657: Call_PartnersDelete_568648; resourceGroupName: string;
          apiVersion: string; integrationAccountName: string;
          subscriptionId: string; partnerName: string): Recallable =
  ## partnersDelete
  ## Deletes an integration account partner.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   partnerName: string (required)
  ##              : The integration account partner name.
  var path_568658 = newJObject()
  var query_568659 = newJObject()
  add(path_568658, "resourceGroupName", newJString(resourceGroupName))
  add(query_568659, "api-version", newJString(apiVersion))
  add(path_568658, "integrationAccountName", newJString(integrationAccountName))
  add(path_568658, "subscriptionId", newJString(subscriptionId))
  add(path_568658, "partnerName", newJString(partnerName))
  result = call_568657.call(path_568658, query_568659, nil, nil, nil)

var partnersDelete* = Call_PartnersDelete_568648(name: "partnersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_PartnersDelete_568649, base: "", url: url_PartnersDelete_568650,
    schemes: {Scheme.Https})
type
  Call_PartnersListContentCallbackUrl_568660 = ref object of OpenApiRestCall_567667
proc url_PartnersListContentCallbackUrl_568662(protocol: Scheme; host: string;
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

proc validate_PartnersListContentCallbackUrl_568661(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the content callback url.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   partnerName: JString (required)
  ##              : The integration account partner name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568663 = path.getOrDefault("resourceGroupName")
  valid_568663 = validateParameter(valid_568663, JString, required = true,
                                 default = nil)
  if valid_568663 != nil:
    section.add "resourceGroupName", valid_568663
  var valid_568664 = path.getOrDefault("integrationAccountName")
  valid_568664 = validateParameter(valid_568664, JString, required = true,
                                 default = nil)
  if valid_568664 != nil:
    section.add "integrationAccountName", valid_568664
  var valid_568665 = path.getOrDefault("subscriptionId")
  valid_568665 = validateParameter(valid_568665, JString, required = true,
                                 default = nil)
  if valid_568665 != nil:
    section.add "subscriptionId", valid_568665
  var valid_568666 = path.getOrDefault("partnerName")
  valid_568666 = validateParameter(valid_568666, JString, required = true,
                                 default = nil)
  if valid_568666 != nil:
    section.add "partnerName", valid_568666
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568667 = query.getOrDefault("api-version")
  valid_568667 = validateParameter(valid_568667, JString, required = true,
                                 default = nil)
  if valid_568667 != nil:
    section.add "api-version", valid_568667
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

proc call*(call_568669: Call_PartnersListContentCallbackUrl_568660; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_568669.validator(path, query, header, formData, body)
  let scheme = call_568669.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568669.url(scheme.get, call_568669.host, call_568669.base,
                         call_568669.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568669, url, valid)

proc call*(call_568670: Call_PartnersListContentCallbackUrl_568660;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          partnerName: string; listContentCallbackUrl: JsonNode): Recallable =
  ## partnersListContentCallbackUrl
  ## Get the content callback url.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   partnerName: string (required)
  ##              : The integration account partner name.
  ##   listContentCallbackUrl: JObject (required)
  var path_568671 = newJObject()
  var query_568672 = newJObject()
  var body_568673 = newJObject()
  add(path_568671, "resourceGroupName", newJString(resourceGroupName))
  add(query_568672, "api-version", newJString(apiVersion))
  add(path_568671, "integrationAccountName", newJString(integrationAccountName))
  add(path_568671, "subscriptionId", newJString(subscriptionId))
  add(path_568671, "partnerName", newJString(partnerName))
  if listContentCallbackUrl != nil:
    body_568673 = listContentCallbackUrl
  result = call_568670.call(path_568671, query_568672, nil, nil, body_568673)

var partnersListContentCallbackUrl* = Call_PartnersListContentCallbackUrl_568660(
    name: "partnersListContentCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}/listContentCallbackUrl",
    validator: validate_PartnersListContentCallbackUrl_568661, base: "",
    url: url_PartnersListContentCallbackUrl_568662, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsRegenerateAccessKey_568674 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountsRegenerateAccessKey_568676(protocol: Scheme;
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

proc validate_IntegrationAccountsRegenerateAccessKey_568675(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the integration account access key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568677 = path.getOrDefault("resourceGroupName")
  valid_568677 = validateParameter(valid_568677, JString, required = true,
                                 default = nil)
  if valid_568677 != nil:
    section.add "resourceGroupName", valid_568677
  var valid_568678 = path.getOrDefault("integrationAccountName")
  valid_568678 = validateParameter(valid_568678, JString, required = true,
                                 default = nil)
  if valid_568678 != nil:
    section.add "integrationAccountName", valid_568678
  var valid_568679 = path.getOrDefault("subscriptionId")
  valid_568679 = validateParameter(valid_568679, JString, required = true,
                                 default = nil)
  if valid_568679 != nil:
    section.add "subscriptionId", valid_568679
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568680 = query.getOrDefault("api-version")
  valid_568680 = validateParameter(valid_568680, JString, required = true,
                                 default = nil)
  if valid_568680 != nil:
    section.add "api-version", valid_568680
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

proc call*(call_568682: Call_IntegrationAccountsRegenerateAccessKey_568674;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the integration account access key.
  ## 
  let valid = call_568682.validator(path, query, header, formData, body)
  let scheme = call_568682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568682.url(scheme.get, call_568682.host, call_568682.base,
                         call_568682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568682, url, valid)

proc call*(call_568683: Call_IntegrationAccountsRegenerateAccessKey_568674;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          regenerateAccessKey: JsonNode): Recallable =
  ## integrationAccountsRegenerateAccessKey
  ## Regenerates the integration account access key.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   regenerateAccessKey: JObject (required)
  ##                      : The access key type.
  var path_568684 = newJObject()
  var query_568685 = newJObject()
  var body_568686 = newJObject()
  add(path_568684, "resourceGroupName", newJString(resourceGroupName))
  add(query_568685, "api-version", newJString(apiVersion))
  add(path_568684, "integrationAccountName", newJString(integrationAccountName))
  add(path_568684, "subscriptionId", newJString(subscriptionId))
  if regenerateAccessKey != nil:
    body_568686 = regenerateAccessKey
  result = call_568683.call(path_568684, query_568685, nil, nil, body_568686)

var integrationAccountsRegenerateAccessKey* = Call_IntegrationAccountsRegenerateAccessKey_568674(
    name: "integrationAccountsRegenerateAccessKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/regenerateAccessKey",
    validator: validate_IntegrationAccountsRegenerateAccessKey_568675, base: "",
    url: url_IntegrationAccountsRegenerateAccessKey_568676,
    schemes: {Scheme.Https})
type
  Call_RosettaNetProcessConfigurationsListByIntegrationAccounts_568687 = ref object of OpenApiRestCall_567667
proc url_RosettaNetProcessConfigurationsListByIntegrationAccounts_568689(
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

proc validate_RosettaNetProcessConfigurationsListByIntegrationAccounts_568688(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a list of integration account RosettaNet process configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568690 = path.getOrDefault("resourceGroupName")
  valid_568690 = validateParameter(valid_568690, JString, required = true,
                                 default = nil)
  if valid_568690 != nil:
    section.add "resourceGroupName", valid_568690
  var valid_568691 = path.getOrDefault("integrationAccountName")
  valid_568691 = validateParameter(valid_568691, JString, required = true,
                                 default = nil)
  if valid_568691 != nil:
    section.add "integrationAccountName", valid_568691
  var valid_568692 = path.getOrDefault("subscriptionId")
  valid_568692 = validateParameter(valid_568692, JString, required = true,
                                 default = nil)
  if valid_568692 != nil:
    section.add "subscriptionId", valid_568692
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
  var valid_568693 = query.getOrDefault("api-version")
  valid_568693 = validateParameter(valid_568693, JString, required = true,
                                 default = nil)
  if valid_568693 != nil:
    section.add "api-version", valid_568693
  var valid_568694 = query.getOrDefault("$top")
  valid_568694 = validateParameter(valid_568694, JInt, required = false, default = nil)
  if valid_568694 != nil:
    section.add "$top", valid_568694
  var valid_568695 = query.getOrDefault("$filter")
  valid_568695 = validateParameter(valid_568695, JString, required = false,
                                 default = nil)
  if valid_568695 != nil:
    section.add "$filter", valid_568695
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568696: Call_RosettaNetProcessConfigurationsListByIntegrationAccounts_568687;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account RosettaNet process configurations.
  ## 
  let valid = call_568696.validator(path, query, header, formData, body)
  let scheme = call_568696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568696.url(scheme.get, call_568696.host, call_568696.base,
                         call_568696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568696, url, valid)

proc call*(call_568697: Call_RosettaNetProcessConfigurationsListByIntegrationAccounts_568687;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## rosettaNetProcessConfigurationsListByIntegrationAccounts
  ## Gets a list of integration account RosettaNet process configurations.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568698 = newJObject()
  var query_568699 = newJObject()
  add(path_568698, "resourceGroupName", newJString(resourceGroupName))
  add(query_568699, "api-version", newJString(apiVersion))
  add(path_568698, "integrationAccountName", newJString(integrationAccountName))
  add(path_568698, "subscriptionId", newJString(subscriptionId))
  add(query_568699, "$top", newJInt(Top))
  add(query_568699, "$filter", newJString(Filter))
  result = call_568697.call(path_568698, query_568699, nil, nil, nil)

var rosettaNetProcessConfigurationsListByIntegrationAccounts* = Call_RosettaNetProcessConfigurationsListByIntegrationAccounts_568687(
    name: "rosettaNetProcessConfigurationsListByIntegrationAccounts",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/rosettanetprocessconfigurations", validator: validate_RosettaNetProcessConfigurationsListByIntegrationAccounts_568688,
    base: "", url: url_RosettaNetProcessConfigurationsListByIntegrationAccounts_568689,
    schemes: {Scheme.Https})
type
  Call_RosettaNetProcessConfigurationsCreateOrUpdate_568712 = ref object of OpenApiRestCall_567667
proc url_RosettaNetProcessConfigurationsCreateOrUpdate_568714(protocol: Scheme;
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

proc validate_RosettaNetProcessConfigurationsCreateOrUpdate_568713(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates an integration account RosettaNetProcessConfiguration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   rosettaNetProcessConfigurationName: JString (required)
  ##                                     : The integration account RosettaNet ProcessConfiguration name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568715 = path.getOrDefault("resourceGroupName")
  valid_568715 = validateParameter(valid_568715, JString, required = true,
                                 default = nil)
  if valid_568715 != nil:
    section.add "resourceGroupName", valid_568715
  var valid_568716 = path.getOrDefault("integrationAccountName")
  valid_568716 = validateParameter(valid_568716, JString, required = true,
                                 default = nil)
  if valid_568716 != nil:
    section.add "integrationAccountName", valid_568716
  var valid_568717 = path.getOrDefault("subscriptionId")
  valid_568717 = validateParameter(valid_568717, JString, required = true,
                                 default = nil)
  if valid_568717 != nil:
    section.add "subscriptionId", valid_568717
  var valid_568718 = path.getOrDefault("rosettaNetProcessConfigurationName")
  valid_568718 = validateParameter(valid_568718, JString, required = true,
                                 default = nil)
  if valid_568718 != nil:
    section.add "rosettaNetProcessConfigurationName", valid_568718
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568719 = query.getOrDefault("api-version")
  valid_568719 = validateParameter(valid_568719, JString, required = true,
                                 default = nil)
  if valid_568719 != nil:
    section.add "api-version", valid_568719
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

proc call*(call_568721: Call_RosettaNetProcessConfigurationsCreateOrUpdate_568712;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account RosettaNetProcessConfiguration.
  ## 
  let valid = call_568721.validator(path, query, header, formData, body)
  let scheme = call_568721.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568721.url(scheme.get, call_568721.host, call_568721.base,
                         call_568721.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568721, url, valid)

proc call*(call_568722: Call_RosettaNetProcessConfigurationsCreateOrUpdate_568712;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          rosettaNetProcessConfigurationName: string;
          rosettaNetProcessConfiguration: JsonNode): Recallable =
  ## rosettaNetProcessConfigurationsCreateOrUpdate
  ## Creates or updates an integration account RosettaNetProcessConfiguration.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   rosettaNetProcessConfigurationName: string (required)
  ##                                     : The integration account RosettaNet ProcessConfiguration name.
  ##   rosettaNetProcessConfiguration: JObject (required)
  ##                                 : The integration account RosettaNet ProcessConfiguration.
  var path_568723 = newJObject()
  var query_568724 = newJObject()
  var body_568725 = newJObject()
  add(path_568723, "resourceGroupName", newJString(resourceGroupName))
  add(query_568724, "api-version", newJString(apiVersion))
  add(path_568723, "integrationAccountName", newJString(integrationAccountName))
  add(path_568723, "subscriptionId", newJString(subscriptionId))
  add(path_568723, "rosettaNetProcessConfigurationName",
      newJString(rosettaNetProcessConfigurationName))
  if rosettaNetProcessConfiguration != nil:
    body_568725 = rosettaNetProcessConfiguration
  result = call_568722.call(path_568723, query_568724, nil, nil, body_568725)

var rosettaNetProcessConfigurationsCreateOrUpdate* = Call_RosettaNetProcessConfigurationsCreateOrUpdate_568712(
    name: "rosettaNetProcessConfigurationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/rosettanetprocessconfigurations/{rosettaNetProcessConfigurationName}",
    validator: validate_RosettaNetProcessConfigurationsCreateOrUpdate_568713,
    base: "", url: url_RosettaNetProcessConfigurationsCreateOrUpdate_568714,
    schemes: {Scheme.Https})
type
  Call_RosettaNetProcessConfigurationsGet_568700 = ref object of OpenApiRestCall_567667
proc url_RosettaNetProcessConfigurationsGet_568702(protocol: Scheme; host: string;
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

proc validate_RosettaNetProcessConfigurationsGet_568701(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account RosettaNetProcessConfiguration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   rosettaNetProcessConfigurationName: JString (required)
  ##                                     : The integration account RosettaNetProcessConfiguration name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568703 = path.getOrDefault("resourceGroupName")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "resourceGroupName", valid_568703
  var valid_568704 = path.getOrDefault("integrationAccountName")
  valid_568704 = validateParameter(valid_568704, JString, required = true,
                                 default = nil)
  if valid_568704 != nil:
    section.add "integrationAccountName", valid_568704
  var valid_568705 = path.getOrDefault("subscriptionId")
  valid_568705 = validateParameter(valid_568705, JString, required = true,
                                 default = nil)
  if valid_568705 != nil:
    section.add "subscriptionId", valid_568705
  var valid_568706 = path.getOrDefault("rosettaNetProcessConfigurationName")
  valid_568706 = validateParameter(valid_568706, JString, required = true,
                                 default = nil)
  if valid_568706 != nil:
    section.add "rosettaNetProcessConfigurationName", valid_568706
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568707 = query.getOrDefault("api-version")
  valid_568707 = validateParameter(valid_568707, JString, required = true,
                                 default = nil)
  if valid_568707 != nil:
    section.add "api-version", valid_568707
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568708: Call_RosettaNetProcessConfigurationsGet_568700;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an integration account RosettaNetProcessConfiguration.
  ## 
  let valid = call_568708.validator(path, query, header, formData, body)
  let scheme = call_568708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568708.url(scheme.get, call_568708.host, call_568708.base,
                         call_568708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568708, url, valid)

proc call*(call_568709: Call_RosettaNetProcessConfigurationsGet_568700;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          rosettaNetProcessConfigurationName: string): Recallable =
  ## rosettaNetProcessConfigurationsGet
  ## Gets an integration account RosettaNetProcessConfiguration.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   rosettaNetProcessConfigurationName: string (required)
  ##                                     : The integration account RosettaNetProcessConfiguration name.
  var path_568710 = newJObject()
  var query_568711 = newJObject()
  add(path_568710, "resourceGroupName", newJString(resourceGroupName))
  add(query_568711, "api-version", newJString(apiVersion))
  add(path_568710, "integrationAccountName", newJString(integrationAccountName))
  add(path_568710, "subscriptionId", newJString(subscriptionId))
  add(path_568710, "rosettaNetProcessConfigurationName",
      newJString(rosettaNetProcessConfigurationName))
  result = call_568709.call(path_568710, query_568711, nil, nil, nil)

var rosettaNetProcessConfigurationsGet* = Call_RosettaNetProcessConfigurationsGet_568700(
    name: "rosettaNetProcessConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/rosettanetprocessconfigurations/{rosettaNetProcessConfigurationName}",
    validator: validate_RosettaNetProcessConfigurationsGet_568701, base: "",
    url: url_RosettaNetProcessConfigurationsGet_568702, schemes: {Scheme.Https})
type
  Call_RosettaNetProcessConfigurationsDelete_568726 = ref object of OpenApiRestCall_567667
proc url_RosettaNetProcessConfigurationsDelete_568728(protocol: Scheme;
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

proc validate_RosettaNetProcessConfigurationsDelete_568727(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account RosettaNet ProcessConfiguration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   rosettaNetProcessConfigurationName: JString (required)
  ##                                     : The integration account RosettaNetProcessConfiguration name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568729 = path.getOrDefault("resourceGroupName")
  valid_568729 = validateParameter(valid_568729, JString, required = true,
                                 default = nil)
  if valid_568729 != nil:
    section.add "resourceGroupName", valid_568729
  var valid_568730 = path.getOrDefault("integrationAccountName")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "integrationAccountName", valid_568730
  var valid_568731 = path.getOrDefault("subscriptionId")
  valid_568731 = validateParameter(valid_568731, JString, required = true,
                                 default = nil)
  if valid_568731 != nil:
    section.add "subscriptionId", valid_568731
  var valid_568732 = path.getOrDefault("rosettaNetProcessConfigurationName")
  valid_568732 = validateParameter(valid_568732, JString, required = true,
                                 default = nil)
  if valid_568732 != nil:
    section.add "rosettaNetProcessConfigurationName", valid_568732
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568733 = query.getOrDefault("api-version")
  valid_568733 = validateParameter(valid_568733, JString, required = true,
                                 default = nil)
  if valid_568733 != nil:
    section.add "api-version", valid_568733
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568734: Call_RosettaNetProcessConfigurationsDelete_568726;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account RosettaNet ProcessConfiguration.
  ## 
  let valid = call_568734.validator(path, query, header, formData, body)
  let scheme = call_568734.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568734.url(scheme.get, call_568734.host, call_568734.base,
                         call_568734.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568734, url, valid)

proc call*(call_568735: Call_RosettaNetProcessConfigurationsDelete_568726;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          rosettaNetProcessConfigurationName: string): Recallable =
  ## rosettaNetProcessConfigurationsDelete
  ## Deletes an integration account RosettaNet ProcessConfiguration.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   rosettaNetProcessConfigurationName: string (required)
  ##                                     : The integration account RosettaNetProcessConfiguration name.
  var path_568736 = newJObject()
  var query_568737 = newJObject()
  add(path_568736, "resourceGroupName", newJString(resourceGroupName))
  add(query_568737, "api-version", newJString(apiVersion))
  add(path_568736, "integrationAccountName", newJString(integrationAccountName))
  add(path_568736, "subscriptionId", newJString(subscriptionId))
  add(path_568736, "rosettaNetProcessConfigurationName",
      newJString(rosettaNetProcessConfigurationName))
  result = call_568735.call(path_568736, query_568737, nil, nil, nil)

var rosettaNetProcessConfigurationsDelete* = Call_RosettaNetProcessConfigurationsDelete_568726(
    name: "rosettaNetProcessConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/rosettanetprocessconfigurations/{rosettaNetProcessConfigurationName}",
    validator: validate_RosettaNetProcessConfigurationsDelete_568727, base: "",
    url: url_RosettaNetProcessConfigurationsDelete_568728, schemes: {Scheme.Https})
type
  Call_SchemasListByIntegrationAccounts_568738 = ref object of OpenApiRestCall_567667
proc url_SchemasListByIntegrationAccounts_568740(protocol: Scheme; host: string;
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

proc validate_SchemasListByIntegrationAccounts_568739(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account schemas.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568741 = path.getOrDefault("resourceGroupName")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "resourceGroupName", valid_568741
  var valid_568742 = path.getOrDefault("integrationAccountName")
  valid_568742 = validateParameter(valid_568742, JString, required = true,
                                 default = nil)
  if valid_568742 != nil:
    section.add "integrationAccountName", valid_568742
  var valid_568743 = path.getOrDefault("subscriptionId")
  valid_568743 = validateParameter(valid_568743, JString, required = true,
                                 default = nil)
  if valid_568743 != nil:
    section.add "subscriptionId", valid_568743
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
  var valid_568744 = query.getOrDefault("api-version")
  valid_568744 = validateParameter(valid_568744, JString, required = true,
                                 default = nil)
  if valid_568744 != nil:
    section.add "api-version", valid_568744
  var valid_568745 = query.getOrDefault("$top")
  valid_568745 = validateParameter(valid_568745, JInt, required = false, default = nil)
  if valid_568745 != nil:
    section.add "$top", valid_568745
  var valid_568746 = query.getOrDefault("$filter")
  valid_568746 = validateParameter(valid_568746, JString, required = false,
                                 default = nil)
  if valid_568746 != nil:
    section.add "$filter", valid_568746
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568747: Call_SchemasListByIntegrationAccounts_568738;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account schemas.
  ## 
  let valid = call_568747.validator(path, query, header, formData, body)
  let scheme = call_568747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568747.url(scheme.get, call_568747.host, call_568747.base,
                         call_568747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568747, url, valid)

proc call*(call_568748: Call_SchemasListByIntegrationAccounts_568738;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## schemasListByIntegrationAccounts
  ## Gets a list of integration account schemas.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   Filter: string
  ##         : The filter to apply on the operation. Options for filters include: SchemaType.
  var path_568749 = newJObject()
  var query_568750 = newJObject()
  add(path_568749, "resourceGroupName", newJString(resourceGroupName))
  add(query_568750, "api-version", newJString(apiVersion))
  add(path_568749, "integrationAccountName", newJString(integrationAccountName))
  add(path_568749, "subscriptionId", newJString(subscriptionId))
  add(query_568750, "$top", newJInt(Top))
  add(query_568750, "$filter", newJString(Filter))
  result = call_568748.call(path_568749, query_568750, nil, nil, nil)

var schemasListByIntegrationAccounts* = Call_SchemasListByIntegrationAccounts_568738(
    name: "schemasListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas",
    validator: validate_SchemasListByIntegrationAccounts_568739, base: "",
    url: url_SchemasListByIntegrationAccounts_568740, schemes: {Scheme.Https})
type
  Call_SchemasCreateOrUpdate_568763 = ref object of OpenApiRestCall_567667
proc url_SchemasCreateOrUpdate_568765(protocol: Scheme; host: string; base: string;
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

proc validate_SchemasCreateOrUpdate_568764(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account schema.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   schemaName: JString (required)
  ##             : The integration account schema name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568766 = path.getOrDefault("resourceGroupName")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "resourceGroupName", valid_568766
  var valid_568767 = path.getOrDefault("integrationAccountName")
  valid_568767 = validateParameter(valid_568767, JString, required = true,
                                 default = nil)
  if valid_568767 != nil:
    section.add "integrationAccountName", valid_568767
  var valid_568768 = path.getOrDefault("subscriptionId")
  valid_568768 = validateParameter(valid_568768, JString, required = true,
                                 default = nil)
  if valid_568768 != nil:
    section.add "subscriptionId", valid_568768
  var valid_568769 = path.getOrDefault("schemaName")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "schemaName", valid_568769
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568770 = query.getOrDefault("api-version")
  valid_568770 = validateParameter(valid_568770, JString, required = true,
                                 default = nil)
  if valid_568770 != nil:
    section.add "api-version", valid_568770
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

proc call*(call_568772: Call_SchemasCreateOrUpdate_568763; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account schema.
  ## 
  let valid = call_568772.validator(path, query, header, formData, body)
  let scheme = call_568772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568772.url(scheme.get, call_568772.host, call_568772.base,
                         call_568772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568772, url, valid)

proc call*(call_568773: Call_SchemasCreateOrUpdate_568763;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          schemaName: string; schema: JsonNode): Recallable =
  ## schemasCreateOrUpdate
  ## Creates or updates an integration account schema.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   schemaName: string (required)
  ##             : The integration account schema name.
  ##   schema: JObject (required)
  ##         : The integration account schema.
  var path_568774 = newJObject()
  var query_568775 = newJObject()
  var body_568776 = newJObject()
  add(path_568774, "resourceGroupName", newJString(resourceGroupName))
  add(query_568775, "api-version", newJString(apiVersion))
  add(path_568774, "integrationAccountName", newJString(integrationAccountName))
  add(path_568774, "subscriptionId", newJString(subscriptionId))
  add(path_568774, "schemaName", newJString(schemaName))
  if schema != nil:
    body_568776 = schema
  result = call_568773.call(path_568774, query_568775, nil, nil, body_568776)

var schemasCreateOrUpdate* = Call_SchemasCreateOrUpdate_568763(
    name: "schemasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_SchemasCreateOrUpdate_568764, base: "",
    url: url_SchemasCreateOrUpdate_568765, schemes: {Scheme.Https})
type
  Call_SchemasGet_568751 = ref object of OpenApiRestCall_567667
proc url_SchemasGet_568753(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SchemasGet_568752(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account schema.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   schemaName: JString (required)
  ##             : The integration account schema name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568754 = path.getOrDefault("resourceGroupName")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "resourceGroupName", valid_568754
  var valid_568755 = path.getOrDefault("integrationAccountName")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = nil)
  if valid_568755 != nil:
    section.add "integrationAccountName", valid_568755
  var valid_568756 = path.getOrDefault("subscriptionId")
  valid_568756 = validateParameter(valid_568756, JString, required = true,
                                 default = nil)
  if valid_568756 != nil:
    section.add "subscriptionId", valid_568756
  var valid_568757 = path.getOrDefault("schemaName")
  valid_568757 = validateParameter(valid_568757, JString, required = true,
                                 default = nil)
  if valid_568757 != nil:
    section.add "schemaName", valid_568757
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568758 = query.getOrDefault("api-version")
  valid_568758 = validateParameter(valid_568758, JString, required = true,
                                 default = nil)
  if valid_568758 != nil:
    section.add "api-version", valid_568758
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568759: Call_SchemasGet_568751; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account schema.
  ## 
  let valid = call_568759.validator(path, query, header, formData, body)
  let scheme = call_568759.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568759.url(scheme.get, call_568759.host, call_568759.base,
                         call_568759.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568759, url, valid)

proc call*(call_568760: Call_SchemasGet_568751; resourceGroupName: string;
          apiVersion: string; integrationAccountName: string;
          subscriptionId: string; schemaName: string): Recallable =
  ## schemasGet
  ## Gets an integration account schema.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   schemaName: string (required)
  ##             : The integration account schema name.
  var path_568761 = newJObject()
  var query_568762 = newJObject()
  add(path_568761, "resourceGroupName", newJString(resourceGroupName))
  add(query_568762, "api-version", newJString(apiVersion))
  add(path_568761, "integrationAccountName", newJString(integrationAccountName))
  add(path_568761, "subscriptionId", newJString(subscriptionId))
  add(path_568761, "schemaName", newJString(schemaName))
  result = call_568760.call(path_568761, query_568762, nil, nil, nil)

var schemasGet* = Call_SchemasGet_568751(name: "schemasGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
                                      validator: validate_SchemasGet_568752,
                                      base: "", url: url_SchemasGet_568753,
                                      schemes: {Scheme.Https})
type
  Call_SchemasDelete_568777 = ref object of OpenApiRestCall_567667
proc url_SchemasDelete_568779(protocol: Scheme; host: string; base: string;
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

proc validate_SchemasDelete_568778(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account schema.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   schemaName: JString (required)
  ##             : The integration account schema name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568780 = path.getOrDefault("resourceGroupName")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "resourceGroupName", valid_568780
  var valid_568781 = path.getOrDefault("integrationAccountName")
  valid_568781 = validateParameter(valid_568781, JString, required = true,
                                 default = nil)
  if valid_568781 != nil:
    section.add "integrationAccountName", valid_568781
  var valid_568782 = path.getOrDefault("subscriptionId")
  valid_568782 = validateParameter(valid_568782, JString, required = true,
                                 default = nil)
  if valid_568782 != nil:
    section.add "subscriptionId", valid_568782
  var valid_568783 = path.getOrDefault("schemaName")
  valid_568783 = validateParameter(valid_568783, JString, required = true,
                                 default = nil)
  if valid_568783 != nil:
    section.add "schemaName", valid_568783
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568784 = query.getOrDefault("api-version")
  valid_568784 = validateParameter(valid_568784, JString, required = true,
                                 default = nil)
  if valid_568784 != nil:
    section.add "api-version", valid_568784
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568785: Call_SchemasDelete_568777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account schema.
  ## 
  let valid = call_568785.validator(path, query, header, formData, body)
  let scheme = call_568785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568785.url(scheme.get, call_568785.host, call_568785.base,
                         call_568785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568785, url, valid)

proc call*(call_568786: Call_SchemasDelete_568777; resourceGroupName: string;
          apiVersion: string; integrationAccountName: string;
          subscriptionId: string; schemaName: string): Recallable =
  ## schemasDelete
  ## Deletes an integration account schema.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   schemaName: string (required)
  ##             : The integration account schema name.
  var path_568787 = newJObject()
  var query_568788 = newJObject()
  add(path_568787, "resourceGroupName", newJString(resourceGroupName))
  add(query_568788, "api-version", newJString(apiVersion))
  add(path_568787, "integrationAccountName", newJString(integrationAccountName))
  add(path_568787, "subscriptionId", newJString(subscriptionId))
  add(path_568787, "schemaName", newJString(schemaName))
  result = call_568786.call(path_568787, query_568788, nil, nil, nil)

var schemasDelete* = Call_SchemasDelete_568777(name: "schemasDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_SchemasDelete_568778, base: "", url: url_SchemasDelete_568779,
    schemes: {Scheme.Https})
type
  Call_SchemasListContentCallbackUrl_568789 = ref object of OpenApiRestCall_567667
proc url_SchemasListContentCallbackUrl_568791(protocol: Scheme; host: string;
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

proc validate_SchemasListContentCallbackUrl_568790(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the content callback url.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   schemaName: JString (required)
  ##             : The integration account schema name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568792 = path.getOrDefault("resourceGroupName")
  valid_568792 = validateParameter(valid_568792, JString, required = true,
                                 default = nil)
  if valid_568792 != nil:
    section.add "resourceGroupName", valid_568792
  var valid_568793 = path.getOrDefault("integrationAccountName")
  valid_568793 = validateParameter(valid_568793, JString, required = true,
                                 default = nil)
  if valid_568793 != nil:
    section.add "integrationAccountName", valid_568793
  var valid_568794 = path.getOrDefault("subscriptionId")
  valid_568794 = validateParameter(valid_568794, JString, required = true,
                                 default = nil)
  if valid_568794 != nil:
    section.add "subscriptionId", valid_568794
  var valid_568795 = path.getOrDefault("schemaName")
  valid_568795 = validateParameter(valid_568795, JString, required = true,
                                 default = nil)
  if valid_568795 != nil:
    section.add "schemaName", valid_568795
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568796 = query.getOrDefault("api-version")
  valid_568796 = validateParameter(valid_568796, JString, required = true,
                                 default = nil)
  if valid_568796 != nil:
    section.add "api-version", valid_568796
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

proc call*(call_568798: Call_SchemasListContentCallbackUrl_568789; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_568798.validator(path, query, header, formData, body)
  let scheme = call_568798.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568798.url(scheme.get, call_568798.host, call_568798.base,
                         call_568798.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568798, url, valid)

proc call*(call_568799: Call_SchemasListContentCallbackUrl_568789;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          schemaName: string; listContentCallbackUrl: JsonNode): Recallable =
  ## schemasListContentCallbackUrl
  ## Get the content callback url.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   schemaName: string (required)
  ##             : The integration account schema name.
  ##   listContentCallbackUrl: JObject (required)
  var path_568800 = newJObject()
  var query_568801 = newJObject()
  var body_568802 = newJObject()
  add(path_568800, "resourceGroupName", newJString(resourceGroupName))
  add(query_568801, "api-version", newJString(apiVersion))
  add(path_568800, "integrationAccountName", newJString(integrationAccountName))
  add(path_568800, "subscriptionId", newJString(subscriptionId))
  add(path_568800, "schemaName", newJString(schemaName))
  if listContentCallbackUrl != nil:
    body_568802 = listContentCallbackUrl
  result = call_568799.call(path_568800, query_568801, nil, nil, body_568802)

var schemasListContentCallbackUrl* = Call_SchemasListContentCallbackUrl_568789(
    name: "schemasListContentCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}/listContentCallbackUrl",
    validator: validate_SchemasListContentCallbackUrl_568790, base: "",
    url: url_SchemasListContentCallbackUrl_568791, schemes: {Scheme.Https})
type
  Call_SessionsListByIntegrationAccounts_568803 = ref object of OpenApiRestCall_567667
proc url_SessionsListByIntegrationAccounts_568805(protocol: Scheme; host: string;
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

proc validate_SessionsListByIntegrationAccounts_568804(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account sessions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568806 = path.getOrDefault("resourceGroupName")
  valid_568806 = validateParameter(valid_568806, JString, required = true,
                                 default = nil)
  if valid_568806 != nil:
    section.add "resourceGroupName", valid_568806
  var valid_568807 = path.getOrDefault("integrationAccountName")
  valid_568807 = validateParameter(valid_568807, JString, required = true,
                                 default = nil)
  if valid_568807 != nil:
    section.add "integrationAccountName", valid_568807
  var valid_568808 = path.getOrDefault("subscriptionId")
  valid_568808 = validateParameter(valid_568808, JString, required = true,
                                 default = nil)
  if valid_568808 != nil:
    section.add "subscriptionId", valid_568808
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
  var valid_568809 = query.getOrDefault("api-version")
  valid_568809 = validateParameter(valid_568809, JString, required = true,
                                 default = nil)
  if valid_568809 != nil:
    section.add "api-version", valid_568809
  var valid_568810 = query.getOrDefault("$top")
  valid_568810 = validateParameter(valid_568810, JInt, required = false, default = nil)
  if valid_568810 != nil:
    section.add "$top", valid_568810
  var valid_568811 = query.getOrDefault("$filter")
  valid_568811 = validateParameter(valid_568811, JString, required = false,
                                 default = nil)
  if valid_568811 != nil:
    section.add "$filter", valid_568811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568812: Call_SessionsListByIntegrationAccounts_568803;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account sessions.
  ## 
  let valid = call_568812.validator(path, query, header, formData, body)
  let scheme = call_568812.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568812.url(scheme.get, call_568812.host, call_568812.base,
                         call_568812.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568812, url, valid)

proc call*(call_568813: Call_SessionsListByIntegrationAccounts_568803;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## sessionsListByIntegrationAccounts
  ## Gets a list of integration account sessions.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   Filter: string
  ##         : The filter to apply on the operation. Options for filters include: ChangedTime.
  var path_568814 = newJObject()
  var query_568815 = newJObject()
  add(path_568814, "resourceGroupName", newJString(resourceGroupName))
  add(query_568815, "api-version", newJString(apiVersion))
  add(path_568814, "integrationAccountName", newJString(integrationAccountName))
  add(path_568814, "subscriptionId", newJString(subscriptionId))
  add(query_568815, "$top", newJInt(Top))
  add(query_568815, "$filter", newJString(Filter))
  result = call_568813.call(path_568814, query_568815, nil, nil, nil)

var sessionsListByIntegrationAccounts* = Call_SessionsListByIntegrationAccounts_568803(
    name: "sessionsListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions",
    validator: validate_SessionsListByIntegrationAccounts_568804, base: "",
    url: url_SessionsListByIntegrationAccounts_568805, schemes: {Scheme.Https})
type
  Call_SessionsCreateOrUpdate_568828 = ref object of OpenApiRestCall_567667
proc url_SessionsCreateOrUpdate_568830(protocol: Scheme; host: string; base: string;
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

proc validate_SessionsCreateOrUpdate_568829(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   sessionName: JString (required)
  ##              : The integration account session name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568831 = path.getOrDefault("resourceGroupName")
  valid_568831 = validateParameter(valid_568831, JString, required = true,
                                 default = nil)
  if valid_568831 != nil:
    section.add "resourceGroupName", valid_568831
  var valid_568832 = path.getOrDefault("sessionName")
  valid_568832 = validateParameter(valid_568832, JString, required = true,
                                 default = nil)
  if valid_568832 != nil:
    section.add "sessionName", valid_568832
  var valid_568833 = path.getOrDefault("integrationAccountName")
  valid_568833 = validateParameter(valid_568833, JString, required = true,
                                 default = nil)
  if valid_568833 != nil:
    section.add "integrationAccountName", valid_568833
  var valid_568834 = path.getOrDefault("subscriptionId")
  valid_568834 = validateParameter(valid_568834, JString, required = true,
                                 default = nil)
  if valid_568834 != nil:
    section.add "subscriptionId", valid_568834
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568835 = query.getOrDefault("api-version")
  valid_568835 = validateParameter(valid_568835, JString, required = true,
                                 default = nil)
  if valid_568835 != nil:
    section.add "api-version", valid_568835
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

proc call*(call_568837: Call_SessionsCreateOrUpdate_568828; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account session.
  ## 
  let valid = call_568837.validator(path, query, header, formData, body)
  let scheme = call_568837.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568837.url(scheme.get, call_568837.host, call_568837.base,
                         call_568837.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568837, url, valid)

proc call*(call_568838: Call_SessionsCreateOrUpdate_568828;
          resourceGroupName: string; apiVersion: string; sessionName: string;
          integrationAccountName: string; subscriptionId: string; session: JsonNode): Recallable =
  ## sessionsCreateOrUpdate
  ## Creates or updates an integration account session.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   sessionName: string (required)
  ##              : The integration account session name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   session: JObject (required)
  ##          : The integration account session.
  var path_568839 = newJObject()
  var query_568840 = newJObject()
  var body_568841 = newJObject()
  add(path_568839, "resourceGroupName", newJString(resourceGroupName))
  add(query_568840, "api-version", newJString(apiVersion))
  add(path_568839, "sessionName", newJString(sessionName))
  add(path_568839, "integrationAccountName", newJString(integrationAccountName))
  add(path_568839, "subscriptionId", newJString(subscriptionId))
  if session != nil:
    body_568841 = session
  result = call_568838.call(path_568839, query_568840, nil, nil, body_568841)

var sessionsCreateOrUpdate* = Call_SessionsCreateOrUpdate_568828(
    name: "sessionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
    validator: validate_SessionsCreateOrUpdate_568829, base: "",
    url: url_SessionsCreateOrUpdate_568830, schemes: {Scheme.Https})
type
  Call_SessionsGet_568816 = ref object of OpenApiRestCall_567667
proc url_SessionsGet_568818(protocol: Scheme; host: string; base: string;
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

proc validate_SessionsGet_568817(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   sessionName: JString (required)
  ##              : The integration account session name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568819 = path.getOrDefault("resourceGroupName")
  valid_568819 = validateParameter(valid_568819, JString, required = true,
                                 default = nil)
  if valid_568819 != nil:
    section.add "resourceGroupName", valid_568819
  var valid_568820 = path.getOrDefault("sessionName")
  valid_568820 = validateParameter(valid_568820, JString, required = true,
                                 default = nil)
  if valid_568820 != nil:
    section.add "sessionName", valid_568820
  var valid_568821 = path.getOrDefault("integrationAccountName")
  valid_568821 = validateParameter(valid_568821, JString, required = true,
                                 default = nil)
  if valid_568821 != nil:
    section.add "integrationAccountName", valid_568821
  var valid_568822 = path.getOrDefault("subscriptionId")
  valid_568822 = validateParameter(valid_568822, JString, required = true,
                                 default = nil)
  if valid_568822 != nil:
    section.add "subscriptionId", valid_568822
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568823 = query.getOrDefault("api-version")
  valid_568823 = validateParameter(valid_568823, JString, required = true,
                                 default = nil)
  if valid_568823 != nil:
    section.add "api-version", valid_568823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568824: Call_SessionsGet_568816; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account session.
  ## 
  let valid = call_568824.validator(path, query, header, formData, body)
  let scheme = call_568824.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568824.url(scheme.get, call_568824.host, call_568824.base,
                         call_568824.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568824, url, valid)

proc call*(call_568825: Call_SessionsGet_568816; resourceGroupName: string;
          apiVersion: string; sessionName: string; integrationAccountName: string;
          subscriptionId: string): Recallable =
  ## sessionsGet
  ## Gets an integration account session.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   sessionName: string (required)
  ##              : The integration account session name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_568826 = newJObject()
  var query_568827 = newJObject()
  add(path_568826, "resourceGroupName", newJString(resourceGroupName))
  add(query_568827, "api-version", newJString(apiVersion))
  add(path_568826, "sessionName", newJString(sessionName))
  add(path_568826, "integrationAccountName", newJString(integrationAccountName))
  add(path_568826, "subscriptionId", newJString(subscriptionId))
  result = call_568825.call(path_568826, query_568827, nil, nil, nil)

var sessionsGet* = Call_SessionsGet_568816(name: "sessionsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
                                        validator: validate_SessionsGet_568817,
                                        base: "", url: url_SessionsGet_568818,
                                        schemes: {Scheme.Https})
type
  Call_SessionsDelete_568842 = ref object of OpenApiRestCall_567667
proc url_SessionsDelete_568844(protocol: Scheme; host: string; base: string;
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

proc validate_SessionsDelete_568843(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes an integration account session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   sessionName: JString (required)
  ##              : The integration account session name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568845 = path.getOrDefault("resourceGroupName")
  valid_568845 = validateParameter(valid_568845, JString, required = true,
                                 default = nil)
  if valid_568845 != nil:
    section.add "resourceGroupName", valid_568845
  var valid_568846 = path.getOrDefault("sessionName")
  valid_568846 = validateParameter(valid_568846, JString, required = true,
                                 default = nil)
  if valid_568846 != nil:
    section.add "sessionName", valid_568846
  var valid_568847 = path.getOrDefault("integrationAccountName")
  valid_568847 = validateParameter(valid_568847, JString, required = true,
                                 default = nil)
  if valid_568847 != nil:
    section.add "integrationAccountName", valid_568847
  var valid_568848 = path.getOrDefault("subscriptionId")
  valid_568848 = validateParameter(valid_568848, JString, required = true,
                                 default = nil)
  if valid_568848 != nil:
    section.add "subscriptionId", valid_568848
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568849 = query.getOrDefault("api-version")
  valid_568849 = validateParameter(valid_568849, JString, required = true,
                                 default = nil)
  if valid_568849 != nil:
    section.add "api-version", valid_568849
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568850: Call_SessionsDelete_568842; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account session.
  ## 
  let valid = call_568850.validator(path, query, header, formData, body)
  let scheme = call_568850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568850.url(scheme.get, call_568850.host, call_568850.base,
                         call_568850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568850, url, valid)

proc call*(call_568851: Call_SessionsDelete_568842; resourceGroupName: string;
          apiVersion: string; sessionName: string; integrationAccountName: string;
          subscriptionId: string): Recallable =
  ## sessionsDelete
  ## Deletes an integration account session.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   sessionName: string (required)
  ##              : The integration account session name.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_568852 = newJObject()
  var query_568853 = newJObject()
  add(path_568852, "resourceGroupName", newJString(resourceGroupName))
  add(query_568853, "api-version", newJString(apiVersion))
  add(path_568852, "sessionName", newJString(sessionName))
  add(path_568852, "integrationAccountName", newJString(integrationAccountName))
  add(path_568852, "subscriptionId", newJString(subscriptionId))
  result = call_568851.call(path_568852, query_568853, nil, nil, nil)

var sessionsDelete* = Call_SessionsDelete_568842(name: "sessionsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
    validator: validate_SessionsDelete_568843, base: "", url: url_SessionsDelete_568844,
    schemes: {Scheme.Https})
type
  Call_WorkflowsValidate_568854 = ref object of OpenApiRestCall_567667
proc url_WorkflowsValidate_568856(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsValidate_568855(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Validates the workflow definition.
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
  ##   location: JString (required)
  ##           : The workflow location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_568857 = path.getOrDefault("workflowName")
  valid_568857 = validateParameter(valid_568857, JString, required = true,
                                 default = nil)
  if valid_568857 != nil:
    section.add "workflowName", valid_568857
  var valid_568858 = path.getOrDefault("resourceGroupName")
  valid_568858 = validateParameter(valid_568858, JString, required = true,
                                 default = nil)
  if valid_568858 != nil:
    section.add "resourceGroupName", valid_568858
  var valid_568859 = path.getOrDefault("subscriptionId")
  valid_568859 = validateParameter(valid_568859, JString, required = true,
                                 default = nil)
  if valid_568859 != nil:
    section.add "subscriptionId", valid_568859
  var valid_568860 = path.getOrDefault("location")
  valid_568860 = validateParameter(valid_568860, JString, required = true,
                                 default = nil)
  if valid_568860 != nil:
    section.add "location", valid_568860
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568861 = query.getOrDefault("api-version")
  valid_568861 = validateParameter(valid_568861, JString, required = true,
                                 default = nil)
  if valid_568861 != nil:
    section.add "api-version", valid_568861
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

proc call*(call_568863: Call_WorkflowsValidate_568854; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the workflow definition.
  ## 
  let valid = call_568863.validator(path, query, header, formData, body)
  let scheme = call_568863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568863.url(scheme.get, call_568863.host, call_568863.base,
                         call_568863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568863, url, valid)

proc call*(call_568864: Call_WorkflowsValidate_568854; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workflow: JsonNode; location: string): Recallable =
  ## workflowsValidate
  ## Validates the workflow definition.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   workflow: JObject (required)
  ##           : The workflow definition.
  ##   location: string (required)
  ##           : The workflow location.
  var path_568865 = newJObject()
  var query_568866 = newJObject()
  var body_568867 = newJObject()
  add(path_568865, "workflowName", newJString(workflowName))
  add(path_568865, "resourceGroupName", newJString(resourceGroupName))
  add(query_568866, "api-version", newJString(apiVersion))
  add(path_568865, "subscriptionId", newJString(subscriptionId))
  if workflow != nil:
    body_568867 = workflow
  add(path_568865, "location", newJString(location))
  result = call_568864.call(path_568865, query_568866, nil, nil, body_568867)

var workflowsValidate* = Call_WorkflowsValidate_568854(name: "workflowsValidate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/locations/{location}/workflows/{workflowName}/validate",
    validator: validate_WorkflowsValidate_568855, base: "",
    url: url_WorkflowsValidate_568856, schemes: {Scheme.Https})
type
  Call_WorkflowsListByResourceGroup_568868 = ref object of OpenApiRestCall_567667
proc url_WorkflowsListByResourceGroup_568870(protocol: Scheme; host: string;
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

proc validate_WorkflowsListByResourceGroup_568869(path: JsonNode; query: JsonNode;
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
  var valid_568871 = path.getOrDefault("resourceGroupName")
  valid_568871 = validateParameter(valid_568871, JString, required = true,
                                 default = nil)
  if valid_568871 != nil:
    section.add "resourceGroupName", valid_568871
  var valid_568872 = path.getOrDefault("subscriptionId")
  valid_568872 = validateParameter(valid_568872, JString, required = true,
                                 default = nil)
  if valid_568872 != nil:
    section.add "subscriptionId", valid_568872
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
  var valid_568873 = query.getOrDefault("api-version")
  valid_568873 = validateParameter(valid_568873, JString, required = true,
                                 default = nil)
  if valid_568873 != nil:
    section.add "api-version", valid_568873
  var valid_568874 = query.getOrDefault("$top")
  valid_568874 = validateParameter(valid_568874, JInt, required = false, default = nil)
  if valid_568874 != nil:
    section.add "$top", valid_568874
  var valid_568875 = query.getOrDefault("$filter")
  valid_568875 = validateParameter(valid_568875, JString, required = false,
                                 default = nil)
  if valid_568875 != nil:
    section.add "$filter", valid_568875
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568876: Call_WorkflowsListByResourceGroup_568868; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflows by resource group.
  ## 
  let valid = call_568876.validator(path, query, header, formData, body)
  let scheme = call_568876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568876.url(scheme.get, call_568876.host, call_568876.base,
                         call_568876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568876, url, valid)

proc call*(call_568877: Call_WorkflowsListByResourceGroup_568868;
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
  ##         : The filter to apply on the operation. Options for filters include: State, Trigger, and ReferencedResourceId.
  var path_568878 = newJObject()
  var query_568879 = newJObject()
  add(path_568878, "resourceGroupName", newJString(resourceGroupName))
  add(query_568879, "api-version", newJString(apiVersion))
  add(path_568878, "subscriptionId", newJString(subscriptionId))
  add(query_568879, "$top", newJInt(Top))
  add(query_568879, "$filter", newJString(Filter))
  result = call_568877.call(path_568878, query_568879, nil, nil, nil)

var workflowsListByResourceGroup* = Call_WorkflowsListByResourceGroup_568868(
    name: "workflowsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows",
    validator: validate_WorkflowsListByResourceGroup_568869, base: "",
    url: url_WorkflowsListByResourceGroup_568870, schemes: {Scheme.Https})
type
  Call_WorkflowsCreateOrUpdate_568891 = ref object of OpenApiRestCall_567667
proc url_WorkflowsCreateOrUpdate_568893(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsCreateOrUpdate_568892(path: JsonNode; query: JsonNode;
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
  var valid_568894 = path.getOrDefault("workflowName")
  valid_568894 = validateParameter(valid_568894, JString, required = true,
                                 default = nil)
  if valid_568894 != nil:
    section.add "workflowName", valid_568894
  var valid_568895 = path.getOrDefault("resourceGroupName")
  valid_568895 = validateParameter(valid_568895, JString, required = true,
                                 default = nil)
  if valid_568895 != nil:
    section.add "resourceGroupName", valid_568895
  var valid_568896 = path.getOrDefault("subscriptionId")
  valid_568896 = validateParameter(valid_568896, JString, required = true,
                                 default = nil)
  if valid_568896 != nil:
    section.add "subscriptionId", valid_568896
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568897 = query.getOrDefault("api-version")
  valid_568897 = validateParameter(valid_568897, JString, required = true,
                                 default = nil)
  if valid_568897 != nil:
    section.add "api-version", valid_568897
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

proc call*(call_568899: Call_WorkflowsCreateOrUpdate_568891; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a workflow.
  ## 
  let valid = call_568899.validator(path, query, header, formData, body)
  let scheme = call_568899.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568899.url(scheme.get, call_568899.host, call_568899.base,
                         call_568899.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568899, url, valid)

proc call*(call_568900: Call_WorkflowsCreateOrUpdate_568891; workflowName: string;
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
  var path_568901 = newJObject()
  var query_568902 = newJObject()
  var body_568903 = newJObject()
  add(path_568901, "workflowName", newJString(workflowName))
  add(path_568901, "resourceGroupName", newJString(resourceGroupName))
  add(query_568902, "api-version", newJString(apiVersion))
  add(path_568901, "subscriptionId", newJString(subscriptionId))
  if workflow != nil:
    body_568903 = workflow
  result = call_568900.call(path_568901, query_568902, nil, nil, body_568903)

var workflowsCreateOrUpdate* = Call_WorkflowsCreateOrUpdate_568891(
    name: "workflowsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsCreateOrUpdate_568892, base: "",
    url: url_WorkflowsCreateOrUpdate_568893, schemes: {Scheme.Https})
type
  Call_WorkflowsGet_568880 = ref object of OpenApiRestCall_567667
proc url_WorkflowsGet_568882(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsGet_568881(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568883 = path.getOrDefault("workflowName")
  valid_568883 = validateParameter(valid_568883, JString, required = true,
                                 default = nil)
  if valid_568883 != nil:
    section.add "workflowName", valid_568883
  var valid_568884 = path.getOrDefault("resourceGroupName")
  valid_568884 = validateParameter(valid_568884, JString, required = true,
                                 default = nil)
  if valid_568884 != nil:
    section.add "resourceGroupName", valid_568884
  var valid_568885 = path.getOrDefault("subscriptionId")
  valid_568885 = validateParameter(valid_568885, JString, required = true,
                                 default = nil)
  if valid_568885 != nil:
    section.add "subscriptionId", valid_568885
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568886 = query.getOrDefault("api-version")
  valid_568886 = validateParameter(valid_568886, JString, required = true,
                                 default = nil)
  if valid_568886 != nil:
    section.add "api-version", valid_568886
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568887: Call_WorkflowsGet_568880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow.
  ## 
  let valid = call_568887.validator(path, query, header, formData, body)
  let scheme = call_568887.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568887.url(scheme.get, call_568887.host, call_568887.base,
                         call_568887.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568887, url, valid)

proc call*(call_568888: Call_WorkflowsGet_568880; workflowName: string;
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
  var path_568889 = newJObject()
  var query_568890 = newJObject()
  add(path_568889, "workflowName", newJString(workflowName))
  add(path_568889, "resourceGroupName", newJString(resourceGroupName))
  add(query_568890, "api-version", newJString(apiVersion))
  add(path_568889, "subscriptionId", newJString(subscriptionId))
  result = call_568888.call(path_568889, query_568890, nil, nil, nil)

var workflowsGet* = Call_WorkflowsGet_568880(name: "workflowsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsGet_568881, base: "", url: url_WorkflowsGet_568882,
    schemes: {Scheme.Https})
type
  Call_WorkflowsUpdate_568915 = ref object of OpenApiRestCall_567667
proc url_WorkflowsUpdate_568917(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsUpdate_568916(path: JsonNode; query: JsonNode;
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
  var valid_568918 = path.getOrDefault("workflowName")
  valid_568918 = validateParameter(valid_568918, JString, required = true,
                                 default = nil)
  if valid_568918 != nil:
    section.add "workflowName", valid_568918
  var valid_568919 = path.getOrDefault("resourceGroupName")
  valid_568919 = validateParameter(valid_568919, JString, required = true,
                                 default = nil)
  if valid_568919 != nil:
    section.add "resourceGroupName", valid_568919
  var valid_568920 = path.getOrDefault("subscriptionId")
  valid_568920 = validateParameter(valid_568920, JString, required = true,
                                 default = nil)
  if valid_568920 != nil:
    section.add "subscriptionId", valid_568920
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568921 = query.getOrDefault("api-version")
  valid_568921 = validateParameter(valid_568921, JString, required = true,
                                 default = nil)
  if valid_568921 != nil:
    section.add "api-version", valid_568921
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

proc call*(call_568923: Call_WorkflowsUpdate_568915; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a workflow.
  ## 
  let valid = call_568923.validator(path, query, header, formData, body)
  let scheme = call_568923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568923.url(scheme.get, call_568923.host, call_568923.base,
                         call_568923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568923, url, valid)

proc call*(call_568924: Call_WorkflowsUpdate_568915; workflowName: string;
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
  var path_568925 = newJObject()
  var query_568926 = newJObject()
  var body_568927 = newJObject()
  add(path_568925, "workflowName", newJString(workflowName))
  add(path_568925, "resourceGroupName", newJString(resourceGroupName))
  add(query_568926, "api-version", newJString(apiVersion))
  add(path_568925, "subscriptionId", newJString(subscriptionId))
  if workflow != nil:
    body_568927 = workflow
  result = call_568924.call(path_568925, query_568926, nil, nil, body_568927)

var workflowsUpdate* = Call_WorkflowsUpdate_568915(name: "workflowsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsUpdate_568916, base: "", url: url_WorkflowsUpdate_568917,
    schemes: {Scheme.Https})
type
  Call_WorkflowsDelete_568904 = ref object of OpenApiRestCall_567667
proc url_WorkflowsDelete_568906(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsDelete_568905(path: JsonNode; query: JsonNode;
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
  var valid_568907 = path.getOrDefault("workflowName")
  valid_568907 = validateParameter(valid_568907, JString, required = true,
                                 default = nil)
  if valid_568907 != nil:
    section.add "workflowName", valid_568907
  var valid_568908 = path.getOrDefault("resourceGroupName")
  valid_568908 = validateParameter(valid_568908, JString, required = true,
                                 default = nil)
  if valid_568908 != nil:
    section.add "resourceGroupName", valid_568908
  var valid_568909 = path.getOrDefault("subscriptionId")
  valid_568909 = validateParameter(valid_568909, JString, required = true,
                                 default = nil)
  if valid_568909 != nil:
    section.add "subscriptionId", valid_568909
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568910 = query.getOrDefault("api-version")
  valid_568910 = validateParameter(valid_568910, JString, required = true,
                                 default = nil)
  if valid_568910 != nil:
    section.add "api-version", valid_568910
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568911: Call_WorkflowsDelete_568904; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a workflow.
  ## 
  let valid = call_568911.validator(path, query, header, formData, body)
  let scheme = call_568911.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568911.url(scheme.get, call_568911.host, call_568911.base,
                         call_568911.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568911, url, valid)

proc call*(call_568912: Call_WorkflowsDelete_568904; workflowName: string;
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
  var path_568913 = newJObject()
  var query_568914 = newJObject()
  add(path_568913, "workflowName", newJString(workflowName))
  add(path_568913, "resourceGroupName", newJString(resourceGroupName))
  add(query_568914, "api-version", newJString(apiVersion))
  add(path_568913, "subscriptionId", newJString(subscriptionId))
  result = call_568912.call(path_568913, query_568914, nil, nil, nil)

var workflowsDelete* = Call_WorkflowsDelete_568904(name: "workflowsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsDelete_568905, base: "", url: url_WorkflowsDelete_568906,
    schemes: {Scheme.Https})
type
  Call_WorkflowsDisable_568928 = ref object of OpenApiRestCall_567667
proc url_WorkflowsDisable_568930(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsDisable_568929(path: JsonNode; query: JsonNode;
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
  var valid_568931 = path.getOrDefault("workflowName")
  valid_568931 = validateParameter(valid_568931, JString, required = true,
                                 default = nil)
  if valid_568931 != nil:
    section.add "workflowName", valid_568931
  var valid_568932 = path.getOrDefault("resourceGroupName")
  valid_568932 = validateParameter(valid_568932, JString, required = true,
                                 default = nil)
  if valid_568932 != nil:
    section.add "resourceGroupName", valid_568932
  var valid_568933 = path.getOrDefault("subscriptionId")
  valid_568933 = validateParameter(valid_568933, JString, required = true,
                                 default = nil)
  if valid_568933 != nil:
    section.add "subscriptionId", valid_568933
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568934 = query.getOrDefault("api-version")
  valid_568934 = validateParameter(valid_568934, JString, required = true,
                                 default = nil)
  if valid_568934 != nil:
    section.add "api-version", valid_568934
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568935: Call_WorkflowsDisable_568928; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disables a workflow.
  ## 
  let valid = call_568935.validator(path, query, header, formData, body)
  let scheme = call_568935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568935.url(scheme.get, call_568935.host, call_568935.base,
                         call_568935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568935, url, valid)

proc call*(call_568936: Call_WorkflowsDisable_568928; workflowName: string;
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
  var path_568937 = newJObject()
  var query_568938 = newJObject()
  add(path_568937, "workflowName", newJString(workflowName))
  add(path_568937, "resourceGroupName", newJString(resourceGroupName))
  add(query_568938, "api-version", newJString(apiVersion))
  add(path_568937, "subscriptionId", newJString(subscriptionId))
  result = call_568936.call(path_568937, query_568938, nil, nil, nil)

var workflowsDisable* = Call_WorkflowsDisable_568928(name: "workflowsDisable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/disable",
    validator: validate_WorkflowsDisable_568929, base: "",
    url: url_WorkflowsDisable_568930, schemes: {Scheme.Https})
type
  Call_WorkflowsEnable_568939 = ref object of OpenApiRestCall_567667
proc url_WorkflowsEnable_568941(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsEnable_568940(path: JsonNode; query: JsonNode;
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
  var valid_568942 = path.getOrDefault("workflowName")
  valid_568942 = validateParameter(valid_568942, JString, required = true,
                                 default = nil)
  if valid_568942 != nil:
    section.add "workflowName", valid_568942
  var valid_568943 = path.getOrDefault("resourceGroupName")
  valid_568943 = validateParameter(valid_568943, JString, required = true,
                                 default = nil)
  if valid_568943 != nil:
    section.add "resourceGroupName", valid_568943
  var valid_568944 = path.getOrDefault("subscriptionId")
  valid_568944 = validateParameter(valid_568944, JString, required = true,
                                 default = nil)
  if valid_568944 != nil:
    section.add "subscriptionId", valid_568944
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568945 = query.getOrDefault("api-version")
  valid_568945 = validateParameter(valid_568945, JString, required = true,
                                 default = nil)
  if valid_568945 != nil:
    section.add "api-version", valid_568945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568946: Call_WorkflowsEnable_568939; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables a workflow.
  ## 
  let valid = call_568946.validator(path, query, header, formData, body)
  let scheme = call_568946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568946.url(scheme.get, call_568946.host, call_568946.base,
                         call_568946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568946, url, valid)

proc call*(call_568947: Call_WorkflowsEnable_568939; workflowName: string;
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
  var path_568948 = newJObject()
  var query_568949 = newJObject()
  add(path_568948, "workflowName", newJString(workflowName))
  add(path_568948, "resourceGroupName", newJString(resourceGroupName))
  add(query_568949, "api-version", newJString(apiVersion))
  add(path_568948, "subscriptionId", newJString(subscriptionId))
  result = call_568947.call(path_568948, query_568949, nil, nil, nil)

var workflowsEnable* = Call_WorkflowsEnable_568939(name: "workflowsEnable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/enable",
    validator: validate_WorkflowsEnable_568940, base: "", url: url_WorkflowsEnable_568941,
    schemes: {Scheme.Https})
type
  Call_WorkflowsGenerateUpgradedDefinition_568950 = ref object of OpenApiRestCall_567667
proc url_WorkflowsGenerateUpgradedDefinition_568952(protocol: Scheme; host: string;
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

proc validate_WorkflowsGenerateUpgradedDefinition_568951(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates the upgraded definition for a workflow.
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
  var valid_568953 = path.getOrDefault("workflowName")
  valid_568953 = validateParameter(valid_568953, JString, required = true,
                                 default = nil)
  if valid_568953 != nil:
    section.add "workflowName", valid_568953
  var valid_568954 = path.getOrDefault("resourceGroupName")
  valid_568954 = validateParameter(valid_568954, JString, required = true,
                                 default = nil)
  if valid_568954 != nil:
    section.add "resourceGroupName", valid_568954
  var valid_568955 = path.getOrDefault("subscriptionId")
  valid_568955 = validateParameter(valid_568955, JString, required = true,
                                 default = nil)
  if valid_568955 != nil:
    section.add "subscriptionId", valid_568955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568956 = query.getOrDefault("api-version")
  valid_568956 = validateParameter(valid_568956, JString, required = true,
                                 default = nil)
  if valid_568956 != nil:
    section.add "api-version", valid_568956
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

proc call*(call_568958: Call_WorkflowsGenerateUpgradedDefinition_568950;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates the upgraded definition for a workflow.
  ## 
  let valid = call_568958.validator(path, query, header, formData, body)
  let scheme = call_568958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568958.url(scheme.get, call_568958.host, call_568958.base,
                         call_568958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568958, url, valid)

proc call*(call_568959: Call_WorkflowsGenerateUpgradedDefinition_568950;
          workflowName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## workflowsGenerateUpgradedDefinition
  ## Generates the upgraded definition for a workflow.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   parameters: JObject (required)
  ##             : Parameters for generating an upgraded definition.
  var path_568960 = newJObject()
  var query_568961 = newJObject()
  var body_568962 = newJObject()
  add(path_568960, "workflowName", newJString(workflowName))
  add(path_568960, "resourceGroupName", newJString(resourceGroupName))
  add(query_568961, "api-version", newJString(apiVersion))
  add(path_568960, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568962 = parameters
  result = call_568959.call(path_568960, query_568961, nil, nil, body_568962)

var workflowsGenerateUpgradedDefinition* = Call_WorkflowsGenerateUpgradedDefinition_568950(
    name: "workflowsGenerateUpgradedDefinition", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/generateUpgradedDefinition",
    validator: validate_WorkflowsGenerateUpgradedDefinition_568951, base: "",
    url: url_WorkflowsGenerateUpgradedDefinition_568952, schemes: {Scheme.Https})
type
  Call_WorkflowsListCallbackUrl_568963 = ref object of OpenApiRestCall_567667
proc url_WorkflowsListCallbackUrl_568965(protocol: Scheme; host: string;
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

proc validate_WorkflowsListCallbackUrl_568964(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the workflow callback Url.
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
  var valid_568966 = path.getOrDefault("workflowName")
  valid_568966 = validateParameter(valid_568966, JString, required = true,
                                 default = nil)
  if valid_568966 != nil:
    section.add "workflowName", valid_568966
  var valid_568967 = path.getOrDefault("resourceGroupName")
  valid_568967 = validateParameter(valid_568967, JString, required = true,
                                 default = nil)
  if valid_568967 != nil:
    section.add "resourceGroupName", valid_568967
  var valid_568968 = path.getOrDefault("subscriptionId")
  valid_568968 = validateParameter(valid_568968, JString, required = true,
                                 default = nil)
  if valid_568968 != nil:
    section.add "subscriptionId", valid_568968
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568969 = query.getOrDefault("api-version")
  valid_568969 = validateParameter(valid_568969, JString, required = true,
                                 default = nil)
  if valid_568969 != nil:
    section.add "api-version", valid_568969
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

proc call*(call_568971: Call_WorkflowsListCallbackUrl_568963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the workflow callback Url.
  ## 
  let valid = call_568971.validator(path, query, header, formData, body)
  let scheme = call_568971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568971.url(scheme.get, call_568971.host, call_568971.base,
                         call_568971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568971, url, valid)

proc call*(call_568972: Call_WorkflowsListCallbackUrl_568963; workflowName: string;
          resourceGroupName: string; apiVersion: string; listCallbackUrl: JsonNode;
          subscriptionId: string): Recallable =
  ## workflowsListCallbackUrl
  ## Get the workflow callback Url.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   listCallbackUrl: JObject (required)
  ##                  : Which callback url to list.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_568973 = newJObject()
  var query_568974 = newJObject()
  var body_568975 = newJObject()
  add(path_568973, "workflowName", newJString(workflowName))
  add(path_568973, "resourceGroupName", newJString(resourceGroupName))
  add(query_568974, "api-version", newJString(apiVersion))
  if listCallbackUrl != nil:
    body_568975 = listCallbackUrl
  add(path_568973, "subscriptionId", newJString(subscriptionId))
  result = call_568972.call(path_568973, query_568974, nil, nil, body_568975)

var workflowsListCallbackUrl* = Call_WorkflowsListCallbackUrl_568963(
    name: "workflowsListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/listCallbackUrl",
    validator: validate_WorkflowsListCallbackUrl_568964, base: "",
    url: url_WorkflowsListCallbackUrl_568965, schemes: {Scheme.Https})
type
  Call_WorkflowsListSwagger_568976 = ref object of OpenApiRestCall_567667
proc url_WorkflowsListSwagger_568978(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsListSwagger_568977(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an OpenAPI definition for the workflow.
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
  var valid_568979 = path.getOrDefault("workflowName")
  valid_568979 = validateParameter(valid_568979, JString, required = true,
                                 default = nil)
  if valid_568979 != nil:
    section.add "workflowName", valid_568979
  var valid_568980 = path.getOrDefault("resourceGroupName")
  valid_568980 = validateParameter(valid_568980, JString, required = true,
                                 default = nil)
  if valid_568980 != nil:
    section.add "resourceGroupName", valid_568980
  var valid_568981 = path.getOrDefault("subscriptionId")
  valid_568981 = validateParameter(valid_568981, JString, required = true,
                                 default = nil)
  if valid_568981 != nil:
    section.add "subscriptionId", valid_568981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568982 = query.getOrDefault("api-version")
  valid_568982 = validateParameter(valid_568982, JString, required = true,
                                 default = nil)
  if valid_568982 != nil:
    section.add "api-version", valid_568982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568983: Call_WorkflowsListSwagger_568976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an OpenAPI definition for the workflow.
  ## 
  let valid = call_568983.validator(path, query, header, formData, body)
  let scheme = call_568983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568983.url(scheme.get, call_568983.host, call_568983.base,
                         call_568983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568983, url, valid)

proc call*(call_568984: Call_WorkflowsListSwagger_568976; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## workflowsListSwagger
  ## Gets an OpenAPI definition for the workflow.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_568985 = newJObject()
  var query_568986 = newJObject()
  add(path_568985, "workflowName", newJString(workflowName))
  add(path_568985, "resourceGroupName", newJString(resourceGroupName))
  add(query_568986, "api-version", newJString(apiVersion))
  add(path_568985, "subscriptionId", newJString(subscriptionId))
  result = call_568984.call(path_568985, query_568986, nil, nil, nil)

var workflowsListSwagger* = Call_WorkflowsListSwagger_568976(
    name: "workflowsListSwagger", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/listSwagger",
    validator: validate_WorkflowsListSwagger_568977, base: "",
    url: url_WorkflowsListSwagger_568978, schemes: {Scheme.Https})
type
  Call_WorkflowsMove_568987 = ref object of OpenApiRestCall_567667
proc url_WorkflowsMove_568989(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsMove_568988(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Moves an existing workflow.
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
  var valid_568990 = path.getOrDefault("workflowName")
  valid_568990 = validateParameter(valid_568990, JString, required = true,
                                 default = nil)
  if valid_568990 != nil:
    section.add "workflowName", valid_568990
  var valid_568991 = path.getOrDefault("resourceGroupName")
  valid_568991 = validateParameter(valid_568991, JString, required = true,
                                 default = nil)
  if valid_568991 != nil:
    section.add "resourceGroupName", valid_568991
  var valid_568992 = path.getOrDefault("subscriptionId")
  valid_568992 = validateParameter(valid_568992, JString, required = true,
                                 default = nil)
  if valid_568992 != nil:
    section.add "subscriptionId", valid_568992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568993 = query.getOrDefault("api-version")
  valid_568993 = validateParameter(valid_568993, JString, required = true,
                                 default = nil)
  if valid_568993 != nil:
    section.add "api-version", valid_568993
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

proc call*(call_568995: Call_WorkflowsMove_568987; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves an existing workflow.
  ## 
  let valid = call_568995.validator(path, query, header, formData, body)
  let scheme = call_568995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568995.url(scheme.get, call_568995.host, call_568995.base,
                         call_568995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568995, url, valid)

proc call*(call_568996: Call_WorkflowsMove_568987; workflowName: string;
          move: JsonNode; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## workflowsMove
  ## Moves an existing workflow.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   move: JObject (required)
  ##       : The workflow to move.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_568997 = newJObject()
  var query_568998 = newJObject()
  var body_568999 = newJObject()
  add(path_568997, "workflowName", newJString(workflowName))
  if move != nil:
    body_568999 = move
  add(path_568997, "resourceGroupName", newJString(resourceGroupName))
  add(query_568998, "api-version", newJString(apiVersion))
  add(path_568997, "subscriptionId", newJString(subscriptionId))
  result = call_568996.call(path_568997, query_568998, nil, nil, body_568999)

var workflowsMove* = Call_WorkflowsMove_568987(name: "workflowsMove",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/move",
    validator: validate_WorkflowsMove_568988, base: "", url: url_WorkflowsMove_568989,
    schemes: {Scheme.Https})
type
  Call_WorkflowsRegenerateAccessKey_569000 = ref object of OpenApiRestCall_567667
proc url_WorkflowsRegenerateAccessKey_569002(protocol: Scheme; host: string;
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

proc validate_WorkflowsRegenerateAccessKey_569001(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the callback URL access key for request triggers.
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
  var valid_569003 = path.getOrDefault("workflowName")
  valid_569003 = validateParameter(valid_569003, JString, required = true,
                                 default = nil)
  if valid_569003 != nil:
    section.add "workflowName", valid_569003
  var valid_569004 = path.getOrDefault("resourceGroupName")
  valid_569004 = validateParameter(valid_569004, JString, required = true,
                                 default = nil)
  if valid_569004 != nil:
    section.add "resourceGroupName", valid_569004
  var valid_569005 = path.getOrDefault("subscriptionId")
  valid_569005 = validateParameter(valid_569005, JString, required = true,
                                 default = nil)
  if valid_569005 != nil:
    section.add "subscriptionId", valid_569005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569006 = query.getOrDefault("api-version")
  valid_569006 = validateParameter(valid_569006, JString, required = true,
                                 default = nil)
  if valid_569006 != nil:
    section.add "api-version", valid_569006
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

proc call*(call_569008: Call_WorkflowsRegenerateAccessKey_569000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the callback URL access key for request triggers.
  ## 
  let valid = call_569008.validator(path, query, header, formData, body)
  let scheme = call_569008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569008.url(scheme.get, call_569008.host, call_569008.base,
                         call_569008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569008, url, valid)

proc call*(call_569009: Call_WorkflowsRegenerateAccessKey_569000;
          workflowName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; keyType: JsonNode): Recallable =
  ## workflowsRegenerateAccessKey
  ## Regenerates the callback URL access key for request triggers.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   keyType: JObject (required)
  ##          : The access key type.
  var path_569010 = newJObject()
  var query_569011 = newJObject()
  var body_569012 = newJObject()
  add(path_569010, "workflowName", newJString(workflowName))
  add(path_569010, "resourceGroupName", newJString(resourceGroupName))
  add(query_569011, "api-version", newJString(apiVersion))
  add(path_569010, "subscriptionId", newJString(subscriptionId))
  if keyType != nil:
    body_569012 = keyType
  result = call_569009.call(path_569010, query_569011, nil, nil, body_569012)

var workflowsRegenerateAccessKey* = Call_WorkflowsRegenerateAccessKey_569000(
    name: "workflowsRegenerateAccessKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/regenerateAccessKey",
    validator: validate_WorkflowsRegenerateAccessKey_569001, base: "",
    url: url_WorkflowsRegenerateAccessKey_569002, schemes: {Scheme.Https})
type
  Call_WorkflowRunsList_569013 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunsList_569015(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsList_569014(path: JsonNode; query: JsonNode;
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
  var valid_569016 = path.getOrDefault("workflowName")
  valid_569016 = validateParameter(valid_569016, JString, required = true,
                                 default = nil)
  if valid_569016 != nil:
    section.add "workflowName", valid_569016
  var valid_569017 = path.getOrDefault("resourceGroupName")
  valid_569017 = validateParameter(valid_569017, JString, required = true,
                                 default = nil)
  if valid_569017 != nil:
    section.add "resourceGroupName", valid_569017
  var valid_569018 = path.getOrDefault("subscriptionId")
  valid_569018 = validateParameter(valid_569018, JString, required = true,
                                 default = nil)
  if valid_569018 != nil:
    section.add "subscriptionId", valid_569018
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
  var valid_569019 = query.getOrDefault("api-version")
  valid_569019 = validateParameter(valid_569019, JString, required = true,
                                 default = nil)
  if valid_569019 != nil:
    section.add "api-version", valid_569019
  var valid_569020 = query.getOrDefault("$top")
  valid_569020 = validateParameter(valid_569020, JInt, required = false, default = nil)
  if valid_569020 != nil:
    section.add "$top", valid_569020
  var valid_569021 = query.getOrDefault("$filter")
  valid_569021 = validateParameter(valid_569021, JString, required = false,
                                 default = nil)
  if valid_569021 != nil:
    section.add "$filter", valid_569021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569022: Call_WorkflowRunsList_569013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow runs.
  ## 
  let valid = call_569022.validator(path, query, header, formData, body)
  let scheme = call_569022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569022.url(scheme.get, call_569022.host, call_569022.base,
                         call_569022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569022, url, valid)

proc call*(call_569023: Call_WorkflowRunsList_569013; workflowName: string;
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
  ##         : The filter to apply on the operation. Options for filters include: Status, StartTime, and ClientTrackingId.
  var path_569024 = newJObject()
  var query_569025 = newJObject()
  add(path_569024, "workflowName", newJString(workflowName))
  add(path_569024, "resourceGroupName", newJString(resourceGroupName))
  add(query_569025, "api-version", newJString(apiVersion))
  add(path_569024, "subscriptionId", newJString(subscriptionId))
  add(query_569025, "$top", newJInt(Top))
  add(query_569025, "$filter", newJString(Filter))
  result = call_569023.call(path_569024, query_569025, nil, nil, nil)

var workflowRunsList* = Call_WorkflowRunsList_569013(name: "workflowRunsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs",
    validator: validate_WorkflowRunsList_569014, base: "",
    url: url_WorkflowRunsList_569015, schemes: {Scheme.Https})
type
  Call_WorkflowRunsGet_569026 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunsGet_569028(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsGet_569027(path: JsonNode; query: JsonNode;
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
  var valid_569029 = path.getOrDefault("workflowName")
  valid_569029 = validateParameter(valid_569029, JString, required = true,
                                 default = nil)
  if valid_569029 != nil:
    section.add "workflowName", valid_569029
  var valid_569030 = path.getOrDefault("resourceGroupName")
  valid_569030 = validateParameter(valid_569030, JString, required = true,
                                 default = nil)
  if valid_569030 != nil:
    section.add "resourceGroupName", valid_569030
  var valid_569031 = path.getOrDefault("runName")
  valid_569031 = validateParameter(valid_569031, JString, required = true,
                                 default = nil)
  if valid_569031 != nil:
    section.add "runName", valid_569031
  var valid_569032 = path.getOrDefault("subscriptionId")
  valid_569032 = validateParameter(valid_569032, JString, required = true,
                                 default = nil)
  if valid_569032 != nil:
    section.add "subscriptionId", valid_569032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569033 = query.getOrDefault("api-version")
  valid_569033 = validateParameter(valid_569033, JString, required = true,
                                 default = nil)
  if valid_569033 != nil:
    section.add "api-version", valid_569033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569034: Call_WorkflowRunsGet_569026; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow run.
  ## 
  let valid = call_569034.validator(path, query, header, formData, body)
  let scheme = call_569034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569034.url(scheme.get, call_569034.host, call_569034.base,
                         call_569034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569034, url, valid)

proc call*(call_569035: Call_WorkflowRunsGet_569026; workflowName: string;
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
  var path_569036 = newJObject()
  var query_569037 = newJObject()
  add(path_569036, "workflowName", newJString(workflowName))
  add(path_569036, "resourceGroupName", newJString(resourceGroupName))
  add(path_569036, "runName", newJString(runName))
  add(query_569037, "api-version", newJString(apiVersion))
  add(path_569036, "subscriptionId", newJString(subscriptionId))
  result = call_569035.call(path_569036, query_569037, nil, nil, nil)

var workflowRunsGet* = Call_WorkflowRunsGet_569026(name: "workflowRunsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}",
    validator: validate_WorkflowRunsGet_569027, base: "", url: url_WorkflowRunsGet_569028,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunsDelete_569038 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunsDelete_569040(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsDelete_569039(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a workflow run.
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
  var valid_569041 = path.getOrDefault("workflowName")
  valid_569041 = validateParameter(valid_569041, JString, required = true,
                                 default = nil)
  if valid_569041 != nil:
    section.add "workflowName", valid_569041
  var valid_569042 = path.getOrDefault("resourceGroupName")
  valid_569042 = validateParameter(valid_569042, JString, required = true,
                                 default = nil)
  if valid_569042 != nil:
    section.add "resourceGroupName", valid_569042
  var valid_569043 = path.getOrDefault("runName")
  valid_569043 = validateParameter(valid_569043, JString, required = true,
                                 default = nil)
  if valid_569043 != nil:
    section.add "runName", valid_569043
  var valid_569044 = path.getOrDefault("subscriptionId")
  valid_569044 = validateParameter(valid_569044, JString, required = true,
                                 default = nil)
  if valid_569044 != nil:
    section.add "subscriptionId", valid_569044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569045 = query.getOrDefault("api-version")
  valid_569045 = validateParameter(valid_569045, JString, required = true,
                                 default = nil)
  if valid_569045 != nil:
    section.add "api-version", valid_569045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569046: Call_WorkflowRunsDelete_569038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a workflow run.
  ## 
  let valid = call_569046.validator(path, query, header, formData, body)
  let scheme = call_569046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569046.url(scheme.get, call_569046.host, call_569046.base,
                         call_569046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569046, url, valid)

proc call*(call_569047: Call_WorkflowRunsDelete_569038; workflowName: string;
          resourceGroupName: string; runName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## workflowRunsDelete
  ## Deletes a workflow run.
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
  var path_569048 = newJObject()
  var query_569049 = newJObject()
  add(path_569048, "workflowName", newJString(workflowName))
  add(path_569048, "resourceGroupName", newJString(resourceGroupName))
  add(path_569048, "runName", newJString(runName))
  add(query_569049, "api-version", newJString(apiVersion))
  add(path_569048, "subscriptionId", newJString(subscriptionId))
  result = call_569047.call(path_569048, query_569049, nil, nil, nil)

var workflowRunsDelete* = Call_WorkflowRunsDelete_569038(
    name: "workflowRunsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}",
    validator: validate_WorkflowRunsDelete_569039, base: "",
    url: url_WorkflowRunsDelete_569040, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsList_569050 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionsList_569052(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunActionsList_569051(path: JsonNode; query: JsonNode;
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
  var valid_569053 = path.getOrDefault("workflowName")
  valid_569053 = validateParameter(valid_569053, JString, required = true,
                                 default = nil)
  if valid_569053 != nil:
    section.add "workflowName", valid_569053
  var valid_569054 = path.getOrDefault("resourceGroupName")
  valid_569054 = validateParameter(valid_569054, JString, required = true,
                                 default = nil)
  if valid_569054 != nil:
    section.add "resourceGroupName", valid_569054
  var valid_569055 = path.getOrDefault("runName")
  valid_569055 = validateParameter(valid_569055, JString, required = true,
                                 default = nil)
  if valid_569055 != nil:
    section.add "runName", valid_569055
  var valid_569056 = path.getOrDefault("subscriptionId")
  valid_569056 = validateParameter(valid_569056, JString, required = true,
                                 default = nil)
  if valid_569056 != nil:
    section.add "subscriptionId", valid_569056
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
  var valid_569057 = query.getOrDefault("api-version")
  valid_569057 = validateParameter(valid_569057, JString, required = true,
                                 default = nil)
  if valid_569057 != nil:
    section.add "api-version", valid_569057
  var valid_569058 = query.getOrDefault("$top")
  valid_569058 = validateParameter(valid_569058, JInt, required = false, default = nil)
  if valid_569058 != nil:
    section.add "$top", valid_569058
  var valid_569059 = query.getOrDefault("$filter")
  valid_569059 = validateParameter(valid_569059, JString, required = false,
                                 default = nil)
  if valid_569059 != nil:
    section.add "$filter", valid_569059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569060: Call_WorkflowRunActionsList_569050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow run actions.
  ## 
  let valid = call_569060.validator(path, query, header, formData, body)
  let scheme = call_569060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569060.url(scheme.get, call_569060.host, call_569060.base,
                         call_569060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569060, url, valid)

proc call*(call_569061: Call_WorkflowRunActionsList_569050; workflowName: string;
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
  ##         : The filter to apply on the operation. Options for filters include: Status.
  var path_569062 = newJObject()
  var query_569063 = newJObject()
  add(path_569062, "workflowName", newJString(workflowName))
  add(path_569062, "resourceGroupName", newJString(resourceGroupName))
  add(path_569062, "runName", newJString(runName))
  add(query_569063, "api-version", newJString(apiVersion))
  add(path_569062, "subscriptionId", newJString(subscriptionId))
  add(query_569063, "$top", newJInt(Top))
  add(query_569063, "$filter", newJString(Filter))
  result = call_569061.call(path_569062, query_569063, nil, nil, nil)

var workflowRunActionsList* = Call_WorkflowRunActionsList_569050(
    name: "workflowRunActionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions",
    validator: validate_WorkflowRunActionsList_569051, base: "",
    url: url_WorkflowRunActionsList_569052, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsGet_569064 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionsGet_569066(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunActionsGet_569065(path: JsonNode; query: JsonNode;
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
  var valid_569067 = path.getOrDefault("workflowName")
  valid_569067 = validateParameter(valid_569067, JString, required = true,
                                 default = nil)
  if valid_569067 != nil:
    section.add "workflowName", valid_569067
  var valid_569068 = path.getOrDefault("actionName")
  valid_569068 = validateParameter(valid_569068, JString, required = true,
                                 default = nil)
  if valid_569068 != nil:
    section.add "actionName", valid_569068
  var valid_569069 = path.getOrDefault("resourceGroupName")
  valid_569069 = validateParameter(valid_569069, JString, required = true,
                                 default = nil)
  if valid_569069 != nil:
    section.add "resourceGroupName", valid_569069
  var valid_569070 = path.getOrDefault("runName")
  valid_569070 = validateParameter(valid_569070, JString, required = true,
                                 default = nil)
  if valid_569070 != nil:
    section.add "runName", valid_569070
  var valid_569071 = path.getOrDefault("subscriptionId")
  valid_569071 = validateParameter(valid_569071, JString, required = true,
                                 default = nil)
  if valid_569071 != nil:
    section.add "subscriptionId", valid_569071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569072 = query.getOrDefault("api-version")
  valid_569072 = validateParameter(valid_569072, JString, required = true,
                                 default = nil)
  if valid_569072 != nil:
    section.add "api-version", valid_569072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569073: Call_WorkflowRunActionsGet_569064; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow run action.
  ## 
  let valid = call_569073.validator(path, query, header, formData, body)
  let scheme = call_569073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569073.url(scheme.get, call_569073.host, call_569073.base,
                         call_569073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569073, url, valid)

proc call*(call_569074: Call_WorkflowRunActionsGet_569064; workflowName: string;
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
  var path_569075 = newJObject()
  var query_569076 = newJObject()
  add(path_569075, "workflowName", newJString(workflowName))
  add(path_569075, "actionName", newJString(actionName))
  add(path_569075, "resourceGroupName", newJString(resourceGroupName))
  add(path_569075, "runName", newJString(runName))
  add(query_569076, "api-version", newJString(apiVersion))
  add(path_569075, "subscriptionId", newJString(subscriptionId))
  result = call_569074.call(path_569075, query_569076, nil, nil, nil)

var workflowRunActionsGet* = Call_WorkflowRunActionsGet_569064(
    name: "workflowRunActionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}",
    validator: validate_WorkflowRunActionsGet_569065, base: "",
    url: url_WorkflowRunActionsGet_569066, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsListExpressionTraces_569077 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionsListExpressionTraces_569079(protocol: Scheme;
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

proc validate_WorkflowRunActionsListExpressionTraces_569078(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a workflow run expression trace.
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
  var valid_569080 = path.getOrDefault("workflowName")
  valid_569080 = validateParameter(valid_569080, JString, required = true,
                                 default = nil)
  if valid_569080 != nil:
    section.add "workflowName", valid_569080
  var valid_569081 = path.getOrDefault("actionName")
  valid_569081 = validateParameter(valid_569081, JString, required = true,
                                 default = nil)
  if valid_569081 != nil:
    section.add "actionName", valid_569081
  var valid_569082 = path.getOrDefault("resourceGroupName")
  valid_569082 = validateParameter(valid_569082, JString, required = true,
                                 default = nil)
  if valid_569082 != nil:
    section.add "resourceGroupName", valid_569082
  var valid_569083 = path.getOrDefault("runName")
  valid_569083 = validateParameter(valid_569083, JString, required = true,
                                 default = nil)
  if valid_569083 != nil:
    section.add "runName", valid_569083
  var valid_569084 = path.getOrDefault("subscriptionId")
  valid_569084 = validateParameter(valid_569084, JString, required = true,
                                 default = nil)
  if valid_569084 != nil:
    section.add "subscriptionId", valid_569084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569085 = query.getOrDefault("api-version")
  valid_569085 = validateParameter(valid_569085, JString, required = true,
                                 default = nil)
  if valid_569085 != nil:
    section.add "api-version", valid_569085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569086: Call_WorkflowRunActionsListExpressionTraces_569077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a workflow run expression trace.
  ## 
  let valid = call_569086.validator(path, query, header, formData, body)
  let scheme = call_569086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569086.url(scheme.get, call_569086.host, call_569086.base,
                         call_569086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569086, url, valid)

proc call*(call_569087: Call_WorkflowRunActionsListExpressionTraces_569077;
          workflowName: string; actionName: string; resourceGroupName: string;
          runName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## workflowRunActionsListExpressionTraces
  ## Lists a workflow run expression trace.
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
  var path_569088 = newJObject()
  var query_569089 = newJObject()
  add(path_569088, "workflowName", newJString(workflowName))
  add(path_569088, "actionName", newJString(actionName))
  add(path_569088, "resourceGroupName", newJString(resourceGroupName))
  add(path_569088, "runName", newJString(runName))
  add(query_569089, "api-version", newJString(apiVersion))
  add(path_569088, "subscriptionId", newJString(subscriptionId))
  result = call_569087.call(path_569088, query_569089, nil, nil, nil)

var workflowRunActionsListExpressionTraces* = Call_WorkflowRunActionsListExpressionTraces_569077(
    name: "workflowRunActionsListExpressionTraces", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/listExpressionTraces",
    validator: validate_WorkflowRunActionsListExpressionTraces_569078, base: "",
    url: url_WorkflowRunActionsListExpressionTraces_569079,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsList_569090 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionRepetitionsList_569092(protocol: Scheme; host: string;
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

proc validate_WorkflowRunActionRepetitionsList_569091(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all of a workflow run action repetitions.
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
  var valid_569093 = path.getOrDefault("workflowName")
  valid_569093 = validateParameter(valid_569093, JString, required = true,
                                 default = nil)
  if valid_569093 != nil:
    section.add "workflowName", valid_569093
  var valid_569094 = path.getOrDefault("actionName")
  valid_569094 = validateParameter(valid_569094, JString, required = true,
                                 default = nil)
  if valid_569094 != nil:
    section.add "actionName", valid_569094
  var valid_569095 = path.getOrDefault("resourceGroupName")
  valid_569095 = validateParameter(valid_569095, JString, required = true,
                                 default = nil)
  if valid_569095 != nil:
    section.add "resourceGroupName", valid_569095
  var valid_569096 = path.getOrDefault("runName")
  valid_569096 = validateParameter(valid_569096, JString, required = true,
                                 default = nil)
  if valid_569096 != nil:
    section.add "runName", valid_569096
  var valid_569097 = path.getOrDefault("subscriptionId")
  valid_569097 = validateParameter(valid_569097, JString, required = true,
                                 default = nil)
  if valid_569097 != nil:
    section.add "subscriptionId", valid_569097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569098 = query.getOrDefault("api-version")
  valid_569098 = validateParameter(valid_569098, JString, required = true,
                                 default = nil)
  if valid_569098 != nil:
    section.add "api-version", valid_569098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569099: Call_WorkflowRunActionRepetitionsList_569090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all of a workflow run action repetitions.
  ## 
  let valid = call_569099.validator(path, query, header, formData, body)
  let scheme = call_569099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569099.url(scheme.get, call_569099.host, call_569099.base,
                         call_569099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569099, url, valid)

proc call*(call_569100: Call_WorkflowRunActionRepetitionsList_569090;
          workflowName: string; actionName: string; resourceGroupName: string;
          runName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## workflowRunActionRepetitionsList
  ## Get all of a workflow run action repetitions.
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
  var path_569101 = newJObject()
  var query_569102 = newJObject()
  add(path_569101, "workflowName", newJString(workflowName))
  add(path_569101, "actionName", newJString(actionName))
  add(path_569101, "resourceGroupName", newJString(resourceGroupName))
  add(path_569101, "runName", newJString(runName))
  add(query_569102, "api-version", newJString(apiVersion))
  add(path_569101, "subscriptionId", newJString(subscriptionId))
  result = call_569100.call(path_569101, query_569102, nil, nil, nil)

var workflowRunActionRepetitionsList* = Call_WorkflowRunActionRepetitionsList_569090(
    name: "workflowRunActionRepetitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions",
    validator: validate_WorkflowRunActionRepetitionsList_569091, base: "",
    url: url_WorkflowRunActionRepetitionsList_569092, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsGet_569103 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionRepetitionsGet_569105(protocol: Scheme; host: string;
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

proc validate_WorkflowRunActionRepetitionsGet_569104(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a workflow run action repetition.
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
  ##   repetitionName: JString (required)
  ##                 : The workflow repetition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_569106 = path.getOrDefault("workflowName")
  valid_569106 = validateParameter(valid_569106, JString, required = true,
                                 default = nil)
  if valid_569106 != nil:
    section.add "workflowName", valid_569106
  var valid_569107 = path.getOrDefault("actionName")
  valid_569107 = validateParameter(valid_569107, JString, required = true,
                                 default = nil)
  if valid_569107 != nil:
    section.add "actionName", valid_569107
  var valid_569108 = path.getOrDefault("resourceGroupName")
  valid_569108 = validateParameter(valid_569108, JString, required = true,
                                 default = nil)
  if valid_569108 != nil:
    section.add "resourceGroupName", valid_569108
  var valid_569109 = path.getOrDefault("runName")
  valid_569109 = validateParameter(valid_569109, JString, required = true,
                                 default = nil)
  if valid_569109 != nil:
    section.add "runName", valid_569109
  var valid_569110 = path.getOrDefault("subscriptionId")
  valid_569110 = validateParameter(valid_569110, JString, required = true,
                                 default = nil)
  if valid_569110 != nil:
    section.add "subscriptionId", valid_569110
  var valid_569111 = path.getOrDefault("repetitionName")
  valid_569111 = validateParameter(valid_569111, JString, required = true,
                                 default = nil)
  if valid_569111 != nil:
    section.add "repetitionName", valid_569111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569112 = query.getOrDefault("api-version")
  valid_569112 = validateParameter(valid_569112, JString, required = true,
                                 default = nil)
  if valid_569112 != nil:
    section.add "api-version", valid_569112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569113: Call_WorkflowRunActionRepetitionsGet_569103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a workflow run action repetition.
  ## 
  let valid = call_569113.validator(path, query, header, formData, body)
  let scheme = call_569113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569113.url(scheme.get, call_569113.host, call_569113.base,
                         call_569113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569113, url, valid)

proc call*(call_569114: Call_WorkflowRunActionRepetitionsGet_569103;
          workflowName: string; actionName: string; resourceGroupName: string;
          runName: string; apiVersion: string; subscriptionId: string;
          repetitionName: string): Recallable =
  ## workflowRunActionRepetitionsGet
  ## Get a workflow run action repetition.
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
  ##   repetitionName: string (required)
  ##                 : The workflow repetition.
  var path_569115 = newJObject()
  var query_569116 = newJObject()
  add(path_569115, "workflowName", newJString(workflowName))
  add(path_569115, "actionName", newJString(actionName))
  add(path_569115, "resourceGroupName", newJString(resourceGroupName))
  add(path_569115, "runName", newJString(runName))
  add(query_569116, "api-version", newJString(apiVersion))
  add(path_569115, "subscriptionId", newJString(subscriptionId))
  add(path_569115, "repetitionName", newJString(repetitionName))
  result = call_569114.call(path_569115, query_569116, nil, nil, nil)

var workflowRunActionRepetitionsGet* = Call_WorkflowRunActionRepetitionsGet_569103(
    name: "workflowRunActionRepetitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}",
    validator: validate_WorkflowRunActionRepetitionsGet_569104, base: "",
    url: url_WorkflowRunActionRepetitionsGet_569105, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsListExpressionTraces_569117 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionRepetitionsListExpressionTraces_569119(
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

proc validate_WorkflowRunActionRepetitionsListExpressionTraces_569118(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists a workflow run expression trace.
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
  ##   repetitionName: JString (required)
  ##                 : The workflow repetition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_569120 = path.getOrDefault("workflowName")
  valid_569120 = validateParameter(valid_569120, JString, required = true,
                                 default = nil)
  if valid_569120 != nil:
    section.add "workflowName", valid_569120
  var valid_569121 = path.getOrDefault("actionName")
  valid_569121 = validateParameter(valid_569121, JString, required = true,
                                 default = nil)
  if valid_569121 != nil:
    section.add "actionName", valid_569121
  var valid_569122 = path.getOrDefault("resourceGroupName")
  valid_569122 = validateParameter(valid_569122, JString, required = true,
                                 default = nil)
  if valid_569122 != nil:
    section.add "resourceGroupName", valid_569122
  var valid_569123 = path.getOrDefault("runName")
  valid_569123 = validateParameter(valid_569123, JString, required = true,
                                 default = nil)
  if valid_569123 != nil:
    section.add "runName", valid_569123
  var valid_569124 = path.getOrDefault("subscriptionId")
  valid_569124 = validateParameter(valid_569124, JString, required = true,
                                 default = nil)
  if valid_569124 != nil:
    section.add "subscriptionId", valid_569124
  var valid_569125 = path.getOrDefault("repetitionName")
  valid_569125 = validateParameter(valid_569125, JString, required = true,
                                 default = nil)
  if valid_569125 != nil:
    section.add "repetitionName", valid_569125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569126 = query.getOrDefault("api-version")
  valid_569126 = validateParameter(valid_569126, JString, required = true,
                                 default = nil)
  if valid_569126 != nil:
    section.add "api-version", valid_569126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569127: Call_WorkflowRunActionRepetitionsListExpressionTraces_569117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a workflow run expression trace.
  ## 
  let valid = call_569127.validator(path, query, header, formData, body)
  let scheme = call_569127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569127.url(scheme.get, call_569127.host, call_569127.base,
                         call_569127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569127, url, valid)

proc call*(call_569128: Call_WorkflowRunActionRepetitionsListExpressionTraces_569117;
          workflowName: string; actionName: string; resourceGroupName: string;
          runName: string; apiVersion: string; subscriptionId: string;
          repetitionName: string): Recallable =
  ## workflowRunActionRepetitionsListExpressionTraces
  ## Lists a workflow run expression trace.
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
  ##   repetitionName: string (required)
  ##                 : The workflow repetition.
  var path_569129 = newJObject()
  var query_569130 = newJObject()
  add(path_569129, "workflowName", newJString(workflowName))
  add(path_569129, "actionName", newJString(actionName))
  add(path_569129, "resourceGroupName", newJString(resourceGroupName))
  add(path_569129, "runName", newJString(runName))
  add(query_569130, "api-version", newJString(apiVersion))
  add(path_569129, "subscriptionId", newJString(subscriptionId))
  add(path_569129, "repetitionName", newJString(repetitionName))
  result = call_569128.call(path_569129, query_569130, nil, nil, nil)

var workflowRunActionRepetitionsListExpressionTraces* = Call_WorkflowRunActionRepetitionsListExpressionTraces_569117(
    name: "workflowRunActionRepetitionsListExpressionTraces",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/listExpressionTraces",
    validator: validate_WorkflowRunActionRepetitionsListExpressionTraces_569118,
    base: "", url: url_WorkflowRunActionRepetitionsListExpressionTraces_569119,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsRequestHistoriesList_569131 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionRepetitionsRequestHistoriesList_569133(
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

proc validate_WorkflowRunActionRepetitionsRequestHistoriesList_569132(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List a workflow run repetition request history.
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
  ##   repetitionName: JString (required)
  ##                 : The workflow repetition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_569134 = path.getOrDefault("workflowName")
  valid_569134 = validateParameter(valid_569134, JString, required = true,
                                 default = nil)
  if valid_569134 != nil:
    section.add "workflowName", valid_569134
  var valid_569135 = path.getOrDefault("actionName")
  valid_569135 = validateParameter(valid_569135, JString, required = true,
                                 default = nil)
  if valid_569135 != nil:
    section.add "actionName", valid_569135
  var valid_569136 = path.getOrDefault("resourceGroupName")
  valid_569136 = validateParameter(valid_569136, JString, required = true,
                                 default = nil)
  if valid_569136 != nil:
    section.add "resourceGroupName", valid_569136
  var valid_569137 = path.getOrDefault("runName")
  valid_569137 = validateParameter(valid_569137, JString, required = true,
                                 default = nil)
  if valid_569137 != nil:
    section.add "runName", valid_569137
  var valid_569138 = path.getOrDefault("subscriptionId")
  valid_569138 = validateParameter(valid_569138, JString, required = true,
                                 default = nil)
  if valid_569138 != nil:
    section.add "subscriptionId", valid_569138
  var valid_569139 = path.getOrDefault("repetitionName")
  valid_569139 = validateParameter(valid_569139, JString, required = true,
                                 default = nil)
  if valid_569139 != nil:
    section.add "repetitionName", valid_569139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569140 = query.getOrDefault("api-version")
  valid_569140 = validateParameter(valid_569140, JString, required = true,
                                 default = nil)
  if valid_569140 != nil:
    section.add "api-version", valid_569140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569141: Call_WorkflowRunActionRepetitionsRequestHistoriesList_569131;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a workflow run repetition request history.
  ## 
  let valid = call_569141.validator(path, query, header, formData, body)
  let scheme = call_569141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569141.url(scheme.get, call_569141.host, call_569141.base,
                         call_569141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569141, url, valid)

proc call*(call_569142: Call_WorkflowRunActionRepetitionsRequestHistoriesList_569131;
          workflowName: string; actionName: string; resourceGroupName: string;
          runName: string; apiVersion: string; subscriptionId: string;
          repetitionName: string): Recallable =
  ## workflowRunActionRepetitionsRequestHistoriesList
  ## List a workflow run repetition request history.
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
  ##   repetitionName: string (required)
  ##                 : The workflow repetition.
  var path_569143 = newJObject()
  var query_569144 = newJObject()
  add(path_569143, "workflowName", newJString(workflowName))
  add(path_569143, "actionName", newJString(actionName))
  add(path_569143, "resourceGroupName", newJString(resourceGroupName))
  add(path_569143, "runName", newJString(runName))
  add(query_569144, "api-version", newJString(apiVersion))
  add(path_569143, "subscriptionId", newJString(subscriptionId))
  add(path_569143, "repetitionName", newJString(repetitionName))
  result = call_569142.call(path_569143, query_569144, nil, nil, nil)

var workflowRunActionRepetitionsRequestHistoriesList* = Call_WorkflowRunActionRepetitionsRequestHistoriesList_569131(
    name: "workflowRunActionRepetitionsRequestHistoriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/requestHistories",
    validator: validate_WorkflowRunActionRepetitionsRequestHistoriesList_569132,
    base: "", url: url_WorkflowRunActionRepetitionsRequestHistoriesList_569133,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsRequestHistoriesGet_569145 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionRepetitionsRequestHistoriesGet_569147(protocol: Scheme;
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

proc validate_WorkflowRunActionRepetitionsRequestHistoriesGet_569146(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a workflow run repetition request history.
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
  ##   requestHistoryName: JString (required)
  ##                     : The request history name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   repetitionName: JString (required)
  ##                 : The workflow repetition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_569148 = path.getOrDefault("workflowName")
  valid_569148 = validateParameter(valid_569148, JString, required = true,
                                 default = nil)
  if valid_569148 != nil:
    section.add "workflowName", valid_569148
  var valid_569149 = path.getOrDefault("actionName")
  valid_569149 = validateParameter(valid_569149, JString, required = true,
                                 default = nil)
  if valid_569149 != nil:
    section.add "actionName", valid_569149
  var valid_569150 = path.getOrDefault("resourceGroupName")
  valid_569150 = validateParameter(valid_569150, JString, required = true,
                                 default = nil)
  if valid_569150 != nil:
    section.add "resourceGroupName", valid_569150
  var valid_569151 = path.getOrDefault("runName")
  valid_569151 = validateParameter(valid_569151, JString, required = true,
                                 default = nil)
  if valid_569151 != nil:
    section.add "runName", valid_569151
  var valid_569152 = path.getOrDefault("requestHistoryName")
  valid_569152 = validateParameter(valid_569152, JString, required = true,
                                 default = nil)
  if valid_569152 != nil:
    section.add "requestHistoryName", valid_569152
  var valid_569153 = path.getOrDefault("subscriptionId")
  valid_569153 = validateParameter(valid_569153, JString, required = true,
                                 default = nil)
  if valid_569153 != nil:
    section.add "subscriptionId", valid_569153
  var valid_569154 = path.getOrDefault("repetitionName")
  valid_569154 = validateParameter(valid_569154, JString, required = true,
                                 default = nil)
  if valid_569154 != nil:
    section.add "repetitionName", valid_569154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569155 = query.getOrDefault("api-version")
  valid_569155 = validateParameter(valid_569155, JString, required = true,
                                 default = nil)
  if valid_569155 != nil:
    section.add "api-version", valid_569155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569156: Call_WorkflowRunActionRepetitionsRequestHistoriesGet_569145;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a workflow run repetition request history.
  ## 
  let valid = call_569156.validator(path, query, header, formData, body)
  let scheme = call_569156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569156.url(scheme.get, call_569156.host, call_569156.base,
                         call_569156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569156, url, valid)

proc call*(call_569157: Call_WorkflowRunActionRepetitionsRequestHistoriesGet_569145;
          workflowName: string; actionName: string; resourceGroupName: string;
          runName: string; apiVersion: string; requestHistoryName: string;
          subscriptionId: string; repetitionName: string): Recallable =
  ## workflowRunActionRepetitionsRequestHistoriesGet
  ## Gets a workflow run repetition request history.
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
  ##   requestHistoryName: string (required)
  ##                     : The request history name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   repetitionName: string (required)
  ##                 : The workflow repetition.
  var path_569158 = newJObject()
  var query_569159 = newJObject()
  add(path_569158, "workflowName", newJString(workflowName))
  add(path_569158, "actionName", newJString(actionName))
  add(path_569158, "resourceGroupName", newJString(resourceGroupName))
  add(path_569158, "runName", newJString(runName))
  add(query_569159, "api-version", newJString(apiVersion))
  add(path_569158, "requestHistoryName", newJString(requestHistoryName))
  add(path_569158, "subscriptionId", newJString(subscriptionId))
  add(path_569158, "repetitionName", newJString(repetitionName))
  result = call_569157.call(path_569158, query_569159, nil, nil, nil)

var workflowRunActionRepetitionsRequestHistoriesGet* = Call_WorkflowRunActionRepetitionsRequestHistoriesGet_569145(
    name: "workflowRunActionRepetitionsRequestHistoriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/requestHistories/{requestHistoryName}",
    validator: validate_WorkflowRunActionRepetitionsRequestHistoriesGet_569146,
    base: "", url: url_WorkflowRunActionRepetitionsRequestHistoriesGet_569147,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRequestHistoriesList_569160 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionRequestHistoriesList_569162(protocol: Scheme;
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

proc validate_WorkflowRunActionRequestHistoriesList_569161(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List a workflow run request history.
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
  var valid_569163 = path.getOrDefault("workflowName")
  valid_569163 = validateParameter(valid_569163, JString, required = true,
                                 default = nil)
  if valid_569163 != nil:
    section.add "workflowName", valid_569163
  var valid_569164 = path.getOrDefault("actionName")
  valid_569164 = validateParameter(valid_569164, JString, required = true,
                                 default = nil)
  if valid_569164 != nil:
    section.add "actionName", valid_569164
  var valid_569165 = path.getOrDefault("resourceGroupName")
  valid_569165 = validateParameter(valid_569165, JString, required = true,
                                 default = nil)
  if valid_569165 != nil:
    section.add "resourceGroupName", valid_569165
  var valid_569166 = path.getOrDefault("runName")
  valid_569166 = validateParameter(valid_569166, JString, required = true,
                                 default = nil)
  if valid_569166 != nil:
    section.add "runName", valid_569166
  var valid_569167 = path.getOrDefault("subscriptionId")
  valid_569167 = validateParameter(valid_569167, JString, required = true,
                                 default = nil)
  if valid_569167 != nil:
    section.add "subscriptionId", valid_569167
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569168 = query.getOrDefault("api-version")
  valid_569168 = validateParameter(valid_569168, JString, required = true,
                                 default = nil)
  if valid_569168 != nil:
    section.add "api-version", valid_569168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569169: Call_WorkflowRunActionRequestHistoriesList_569160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a workflow run request history.
  ## 
  let valid = call_569169.validator(path, query, header, formData, body)
  let scheme = call_569169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569169.url(scheme.get, call_569169.host, call_569169.base,
                         call_569169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569169, url, valid)

proc call*(call_569170: Call_WorkflowRunActionRequestHistoriesList_569160;
          workflowName: string; actionName: string; resourceGroupName: string;
          runName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## workflowRunActionRequestHistoriesList
  ## List a workflow run request history.
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
  var path_569171 = newJObject()
  var query_569172 = newJObject()
  add(path_569171, "workflowName", newJString(workflowName))
  add(path_569171, "actionName", newJString(actionName))
  add(path_569171, "resourceGroupName", newJString(resourceGroupName))
  add(path_569171, "runName", newJString(runName))
  add(query_569172, "api-version", newJString(apiVersion))
  add(path_569171, "subscriptionId", newJString(subscriptionId))
  result = call_569170.call(path_569171, query_569172, nil, nil, nil)

var workflowRunActionRequestHistoriesList* = Call_WorkflowRunActionRequestHistoriesList_569160(
    name: "workflowRunActionRequestHistoriesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/requestHistories",
    validator: validate_WorkflowRunActionRequestHistoriesList_569161, base: "",
    url: url_WorkflowRunActionRequestHistoriesList_569162, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRequestHistoriesGet_569173 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionRequestHistoriesGet_569175(protocol: Scheme;
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

proc validate_WorkflowRunActionRequestHistoriesGet_569174(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a workflow run request history.
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
  ##   requestHistoryName: JString (required)
  ##                     : The request history name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_569176 = path.getOrDefault("workflowName")
  valid_569176 = validateParameter(valid_569176, JString, required = true,
                                 default = nil)
  if valid_569176 != nil:
    section.add "workflowName", valid_569176
  var valid_569177 = path.getOrDefault("actionName")
  valid_569177 = validateParameter(valid_569177, JString, required = true,
                                 default = nil)
  if valid_569177 != nil:
    section.add "actionName", valid_569177
  var valid_569178 = path.getOrDefault("resourceGroupName")
  valid_569178 = validateParameter(valid_569178, JString, required = true,
                                 default = nil)
  if valid_569178 != nil:
    section.add "resourceGroupName", valid_569178
  var valid_569179 = path.getOrDefault("runName")
  valid_569179 = validateParameter(valid_569179, JString, required = true,
                                 default = nil)
  if valid_569179 != nil:
    section.add "runName", valid_569179
  var valid_569180 = path.getOrDefault("requestHistoryName")
  valid_569180 = validateParameter(valid_569180, JString, required = true,
                                 default = nil)
  if valid_569180 != nil:
    section.add "requestHistoryName", valid_569180
  var valid_569181 = path.getOrDefault("subscriptionId")
  valid_569181 = validateParameter(valid_569181, JString, required = true,
                                 default = nil)
  if valid_569181 != nil:
    section.add "subscriptionId", valid_569181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569182 = query.getOrDefault("api-version")
  valid_569182 = validateParameter(valid_569182, JString, required = true,
                                 default = nil)
  if valid_569182 != nil:
    section.add "api-version", valid_569182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569183: Call_WorkflowRunActionRequestHistoriesGet_569173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a workflow run request history.
  ## 
  let valid = call_569183.validator(path, query, header, formData, body)
  let scheme = call_569183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569183.url(scheme.get, call_569183.host, call_569183.base,
                         call_569183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569183, url, valid)

proc call*(call_569184: Call_WorkflowRunActionRequestHistoriesGet_569173;
          workflowName: string; actionName: string; resourceGroupName: string;
          runName: string; apiVersion: string; requestHistoryName: string;
          subscriptionId: string): Recallable =
  ## workflowRunActionRequestHistoriesGet
  ## Gets a workflow run request history.
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
  ##   requestHistoryName: string (required)
  ##                     : The request history name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_569185 = newJObject()
  var query_569186 = newJObject()
  add(path_569185, "workflowName", newJString(workflowName))
  add(path_569185, "actionName", newJString(actionName))
  add(path_569185, "resourceGroupName", newJString(resourceGroupName))
  add(path_569185, "runName", newJString(runName))
  add(query_569186, "api-version", newJString(apiVersion))
  add(path_569185, "requestHistoryName", newJString(requestHistoryName))
  add(path_569185, "subscriptionId", newJString(subscriptionId))
  result = call_569184.call(path_569185, query_569186, nil, nil, nil)

var workflowRunActionRequestHistoriesGet* = Call_WorkflowRunActionRequestHistoriesGet_569173(
    name: "workflowRunActionRequestHistoriesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/requestHistories/{requestHistoryName}",
    validator: validate_WorkflowRunActionRequestHistoriesGet_569174, base: "",
    url: url_WorkflowRunActionRequestHistoriesGet_569175, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionScopedRepetitionsList_569187 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionScopedRepetitionsList_569189(protocol: Scheme;
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

proc validate_WorkflowRunActionScopedRepetitionsList_569188(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the workflow run action scoped repetitions.
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
  var valid_569190 = path.getOrDefault("workflowName")
  valid_569190 = validateParameter(valid_569190, JString, required = true,
                                 default = nil)
  if valid_569190 != nil:
    section.add "workflowName", valid_569190
  var valid_569191 = path.getOrDefault("actionName")
  valid_569191 = validateParameter(valid_569191, JString, required = true,
                                 default = nil)
  if valid_569191 != nil:
    section.add "actionName", valid_569191
  var valid_569192 = path.getOrDefault("resourceGroupName")
  valid_569192 = validateParameter(valid_569192, JString, required = true,
                                 default = nil)
  if valid_569192 != nil:
    section.add "resourceGroupName", valid_569192
  var valid_569193 = path.getOrDefault("runName")
  valid_569193 = validateParameter(valid_569193, JString, required = true,
                                 default = nil)
  if valid_569193 != nil:
    section.add "runName", valid_569193
  var valid_569194 = path.getOrDefault("subscriptionId")
  valid_569194 = validateParameter(valid_569194, JString, required = true,
                                 default = nil)
  if valid_569194 != nil:
    section.add "subscriptionId", valid_569194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569195 = query.getOrDefault("api-version")
  valid_569195 = validateParameter(valid_569195, JString, required = true,
                                 default = nil)
  if valid_569195 != nil:
    section.add "api-version", valid_569195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569196: Call_WorkflowRunActionScopedRepetitionsList_569187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the workflow run action scoped repetitions.
  ## 
  let valid = call_569196.validator(path, query, header, formData, body)
  let scheme = call_569196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569196.url(scheme.get, call_569196.host, call_569196.base,
                         call_569196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569196, url, valid)

proc call*(call_569197: Call_WorkflowRunActionScopedRepetitionsList_569187;
          workflowName: string; actionName: string; resourceGroupName: string;
          runName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## workflowRunActionScopedRepetitionsList
  ## List the workflow run action scoped repetitions.
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
  var path_569198 = newJObject()
  var query_569199 = newJObject()
  add(path_569198, "workflowName", newJString(workflowName))
  add(path_569198, "actionName", newJString(actionName))
  add(path_569198, "resourceGroupName", newJString(resourceGroupName))
  add(path_569198, "runName", newJString(runName))
  add(query_569199, "api-version", newJString(apiVersion))
  add(path_569198, "subscriptionId", newJString(subscriptionId))
  result = call_569197.call(path_569198, query_569199, nil, nil, nil)

var workflowRunActionScopedRepetitionsList* = Call_WorkflowRunActionScopedRepetitionsList_569187(
    name: "workflowRunActionScopedRepetitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/scopeRepetitions",
    validator: validate_WorkflowRunActionScopedRepetitionsList_569188, base: "",
    url: url_WorkflowRunActionScopedRepetitionsList_569189,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionScopedRepetitionsGet_569200 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionScopedRepetitionsGet_569202(protocol: Scheme;
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

proc validate_WorkflowRunActionScopedRepetitionsGet_569201(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a workflow run action scoped repetition.
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
  ##   repetitionName: JString (required)
  ##                 : The workflow repetition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_569203 = path.getOrDefault("workflowName")
  valid_569203 = validateParameter(valid_569203, JString, required = true,
                                 default = nil)
  if valid_569203 != nil:
    section.add "workflowName", valid_569203
  var valid_569204 = path.getOrDefault("actionName")
  valid_569204 = validateParameter(valid_569204, JString, required = true,
                                 default = nil)
  if valid_569204 != nil:
    section.add "actionName", valid_569204
  var valid_569205 = path.getOrDefault("resourceGroupName")
  valid_569205 = validateParameter(valid_569205, JString, required = true,
                                 default = nil)
  if valid_569205 != nil:
    section.add "resourceGroupName", valid_569205
  var valid_569206 = path.getOrDefault("runName")
  valid_569206 = validateParameter(valid_569206, JString, required = true,
                                 default = nil)
  if valid_569206 != nil:
    section.add "runName", valid_569206
  var valid_569207 = path.getOrDefault("subscriptionId")
  valid_569207 = validateParameter(valid_569207, JString, required = true,
                                 default = nil)
  if valid_569207 != nil:
    section.add "subscriptionId", valid_569207
  var valid_569208 = path.getOrDefault("repetitionName")
  valid_569208 = validateParameter(valid_569208, JString, required = true,
                                 default = nil)
  if valid_569208 != nil:
    section.add "repetitionName", valid_569208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569209 = query.getOrDefault("api-version")
  valid_569209 = validateParameter(valid_569209, JString, required = true,
                                 default = nil)
  if valid_569209 != nil:
    section.add "api-version", valid_569209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569210: Call_WorkflowRunActionScopedRepetitionsGet_569200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a workflow run action scoped repetition.
  ## 
  let valid = call_569210.validator(path, query, header, formData, body)
  let scheme = call_569210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569210.url(scheme.get, call_569210.host, call_569210.base,
                         call_569210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569210, url, valid)

proc call*(call_569211: Call_WorkflowRunActionScopedRepetitionsGet_569200;
          workflowName: string; actionName: string; resourceGroupName: string;
          runName: string; apiVersion: string; subscriptionId: string;
          repetitionName: string): Recallable =
  ## workflowRunActionScopedRepetitionsGet
  ## Get a workflow run action scoped repetition.
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
  ##   repetitionName: string (required)
  ##                 : The workflow repetition.
  var path_569212 = newJObject()
  var query_569213 = newJObject()
  add(path_569212, "workflowName", newJString(workflowName))
  add(path_569212, "actionName", newJString(actionName))
  add(path_569212, "resourceGroupName", newJString(resourceGroupName))
  add(path_569212, "runName", newJString(runName))
  add(query_569213, "api-version", newJString(apiVersion))
  add(path_569212, "subscriptionId", newJString(subscriptionId))
  add(path_569212, "repetitionName", newJString(repetitionName))
  result = call_569211.call(path_569212, query_569213, nil, nil, nil)

var workflowRunActionScopedRepetitionsGet* = Call_WorkflowRunActionScopedRepetitionsGet_569200(
    name: "workflowRunActionScopedRepetitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/scopeRepetitions/{repetitionName}",
    validator: validate_WorkflowRunActionScopedRepetitionsGet_569201, base: "",
    url: url_WorkflowRunActionScopedRepetitionsGet_569202, schemes: {Scheme.Https})
type
  Call_WorkflowRunsCancel_569214 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunsCancel_569216(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsCancel_569215(path: JsonNode; query: JsonNode;
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
  var valid_569217 = path.getOrDefault("workflowName")
  valid_569217 = validateParameter(valid_569217, JString, required = true,
                                 default = nil)
  if valid_569217 != nil:
    section.add "workflowName", valid_569217
  var valid_569218 = path.getOrDefault("resourceGroupName")
  valid_569218 = validateParameter(valid_569218, JString, required = true,
                                 default = nil)
  if valid_569218 != nil:
    section.add "resourceGroupName", valid_569218
  var valid_569219 = path.getOrDefault("runName")
  valid_569219 = validateParameter(valid_569219, JString, required = true,
                                 default = nil)
  if valid_569219 != nil:
    section.add "runName", valid_569219
  var valid_569220 = path.getOrDefault("subscriptionId")
  valid_569220 = validateParameter(valid_569220, JString, required = true,
                                 default = nil)
  if valid_569220 != nil:
    section.add "subscriptionId", valid_569220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569221 = query.getOrDefault("api-version")
  valid_569221 = validateParameter(valid_569221, JString, required = true,
                                 default = nil)
  if valid_569221 != nil:
    section.add "api-version", valid_569221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569222: Call_WorkflowRunsCancel_569214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a workflow run.
  ## 
  let valid = call_569222.validator(path, query, header, formData, body)
  let scheme = call_569222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569222.url(scheme.get, call_569222.host, call_569222.base,
                         call_569222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569222, url, valid)

proc call*(call_569223: Call_WorkflowRunsCancel_569214; workflowName: string;
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
  var path_569224 = newJObject()
  var query_569225 = newJObject()
  add(path_569224, "workflowName", newJString(workflowName))
  add(path_569224, "resourceGroupName", newJString(resourceGroupName))
  add(path_569224, "runName", newJString(runName))
  add(query_569225, "api-version", newJString(apiVersion))
  add(path_569224, "subscriptionId", newJString(subscriptionId))
  result = call_569223.call(path_569224, query_569225, nil, nil, nil)

var workflowRunsCancel* = Call_WorkflowRunsCancel_569214(
    name: "workflowRunsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/cancel",
    validator: validate_WorkflowRunsCancel_569215, base: "",
    url: url_WorkflowRunsCancel_569216, schemes: {Scheme.Https})
type
  Call_WorkflowRunOperationsGet_569226 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunOperationsGet_569228(protocol: Scheme; host: string;
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

proc validate_WorkflowRunOperationsGet_569227(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an operation for a run.
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
  ##   operationId: JString (required)
  ##              : The workflow operation id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_569229 = path.getOrDefault("workflowName")
  valid_569229 = validateParameter(valid_569229, JString, required = true,
                                 default = nil)
  if valid_569229 != nil:
    section.add "workflowName", valid_569229
  var valid_569230 = path.getOrDefault("resourceGroupName")
  valid_569230 = validateParameter(valid_569230, JString, required = true,
                                 default = nil)
  if valid_569230 != nil:
    section.add "resourceGroupName", valid_569230
  var valid_569231 = path.getOrDefault("runName")
  valid_569231 = validateParameter(valid_569231, JString, required = true,
                                 default = nil)
  if valid_569231 != nil:
    section.add "runName", valid_569231
  var valid_569232 = path.getOrDefault("subscriptionId")
  valid_569232 = validateParameter(valid_569232, JString, required = true,
                                 default = nil)
  if valid_569232 != nil:
    section.add "subscriptionId", valid_569232
  var valid_569233 = path.getOrDefault("operationId")
  valid_569233 = validateParameter(valid_569233, JString, required = true,
                                 default = nil)
  if valid_569233 != nil:
    section.add "operationId", valid_569233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569234 = query.getOrDefault("api-version")
  valid_569234 = validateParameter(valid_569234, JString, required = true,
                                 default = nil)
  if valid_569234 != nil:
    section.add "api-version", valid_569234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569235: Call_WorkflowRunOperationsGet_569226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an operation for a run.
  ## 
  let valid = call_569235.validator(path, query, header, formData, body)
  let scheme = call_569235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569235.url(scheme.get, call_569235.host, call_569235.base,
                         call_569235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569235, url, valid)

proc call*(call_569236: Call_WorkflowRunOperationsGet_569226; workflowName: string;
          resourceGroupName: string; runName: string; apiVersion: string;
          subscriptionId: string; operationId: string): Recallable =
  ## workflowRunOperationsGet
  ## Gets an operation for a run.
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
  ##   operationId: string (required)
  ##              : The workflow operation id.
  var path_569237 = newJObject()
  var query_569238 = newJObject()
  add(path_569237, "workflowName", newJString(workflowName))
  add(path_569237, "resourceGroupName", newJString(resourceGroupName))
  add(path_569237, "runName", newJString(runName))
  add(query_569238, "api-version", newJString(apiVersion))
  add(path_569237, "subscriptionId", newJString(subscriptionId))
  add(path_569237, "operationId", newJString(operationId))
  result = call_569236.call(path_569237, query_569238, nil, nil, nil)

var workflowRunOperationsGet* = Call_WorkflowRunOperationsGet_569226(
    name: "workflowRunOperationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/operations/{operationId}",
    validator: validate_WorkflowRunOperationsGet_569227, base: "",
    url: url_WorkflowRunOperationsGet_569228, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersList_569239 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggersList_569241(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersList_569240(path: JsonNode; query: JsonNode;
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
  var valid_569242 = path.getOrDefault("workflowName")
  valid_569242 = validateParameter(valid_569242, JString, required = true,
                                 default = nil)
  if valid_569242 != nil:
    section.add "workflowName", valid_569242
  var valid_569243 = path.getOrDefault("resourceGroupName")
  valid_569243 = validateParameter(valid_569243, JString, required = true,
                                 default = nil)
  if valid_569243 != nil:
    section.add "resourceGroupName", valid_569243
  var valid_569244 = path.getOrDefault("subscriptionId")
  valid_569244 = validateParameter(valid_569244, JString, required = true,
                                 default = nil)
  if valid_569244 != nil:
    section.add "subscriptionId", valid_569244
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
  var valid_569245 = query.getOrDefault("api-version")
  valid_569245 = validateParameter(valid_569245, JString, required = true,
                                 default = nil)
  if valid_569245 != nil:
    section.add "api-version", valid_569245
  var valid_569246 = query.getOrDefault("$top")
  valid_569246 = validateParameter(valid_569246, JInt, required = false, default = nil)
  if valid_569246 != nil:
    section.add "$top", valid_569246
  var valid_569247 = query.getOrDefault("$filter")
  valid_569247 = validateParameter(valid_569247, JString, required = false,
                                 default = nil)
  if valid_569247 != nil:
    section.add "$filter", valid_569247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569248: Call_WorkflowTriggersList_569239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow triggers.
  ## 
  let valid = call_569248.validator(path, query, header, formData, body)
  let scheme = call_569248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569248.url(scheme.get, call_569248.host, call_569248.base,
                         call_569248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569248, url, valid)

proc call*(call_569249: Call_WorkflowTriggersList_569239; workflowName: string;
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
  var path_569250 = newJObject()
  var query_569251 = newJObject()
  add(path_569250, "workflowName", newJString(workflowName))
  add(path_569250, "resourceGroupName", newJString(resourceGroupName))
  add(query_569251, "api-version", newJString(apiVersion))
  add(path_569250, "subscriptionId", newJString(subscriptionId))
  add(query_569251, "$top", newJInt(Top))
  add(query_569251, "$filter", newJString(Filter))
  result = call_569249.call(path_569250, query_569251, nil, nil, nil)

var workflowTriggersList* = Call_WorkflowTriggersList_569239(
    name: "workflowTriggersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers",
    validator: validate_WorkflowTriggersList_569240, base: "",
    url: url_WorkflowTriggersList_569241, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersGet_569252 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggersGet_569254(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersGet_569253(path: JsonNode; query: JsonNode;
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
  var valid_569255 = path.getOrDefault("workflowName")
  valid_569255 = validateParameter(valid_569255, JString, required = true,
                                 default = nil)
  if valid_569255 != nil:
    section.add "workflowName", valid_569255
  var valid_569256 = path.getOrDefault("resourceGroupName")
  valid_569256 = validateParameter(valid_569256, JString, required = true,
                                 default = nil)
  if valid_569256 != nil:
    section.add "resourceGroupName", valid_569256
  var valid_569257 = path.getOrDefault("subscriptionId")
  valid_569257 = validateParameter(valid_569257, JString, required = true,
                                 default = nil)
  if valid_569257 != nil:
    section.add "subscriptionId", valid_569257
  var valid_569258 = path.getOrDefault("triggerName")
  valid_569258 = validateParameter(valid_569258, JString, required = true,
                                 default = nil)
  if valid_569258 != nil:
    section.add "triggerName", valid_569258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569259 = query.getOrDefault("api-version")
  valid_569259 = validateParameter(valid_569259, JString, required = true,
                                 default = nil)
  if valid_569259 != nil:
    section.add "api-version", valid_569259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569260: Call_WorkflowTriggersGet_569252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow trigger.
  ## 
  let valid = call_569260.validator(path, query, header, formData, body)
  let scheme = call_569260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569260.url(scheme.get, call_569260.host, call_569260.base,
                         call_569260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569260, url, valid)

proc call*(call_569261: Call_WorkflowTriggersGet_569252; workflowName: string;
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
  var path_569262 = newJObject()
  var query_569263 = newJObject()
  add(path_569262, "workflowName", newJString(workflowName))
  add(path_569262, "resourceGroupName", newJString(resourceGroupName))
  add(query_569263, "api-version", newJString(apiVersion))
  add(path_569262, "subscriptionId", newJString(subscriptionId))
  add(path_569262, "triggerName", newJString(triggerName))
  result = call_569261.call(path_569262, query_569263, nil, nil, nil)

var workflowTriggersGet* = Call_WorkflowTriggersGet_569252(
    name: "workflowTriggersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}",
    validator: validate_WorkflowTriggersGet_569253, base: "",
    url: url_WorkflowTriggersGet_569254, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesList_569264 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggerHistoriesList_569266(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesList_569265(path: JsonNode; query: JsonNode;
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
  var valid_569267 = path.getOrDefault("workflowName")
  valid_569267 = validateParameter(valid_569267, JString, required = true,
                                 default = nil)
  if valid_569267 != nil:
    section.add "workflowName", valid_569267
  var valid_569268 = path.getOrDefault("resourceGroupName")
  valid_569268 = validateParameter(valid_569268, JString, required = true,
                                 default = nil)
  if valid_569268 != nil:
    section.add "resourceGroupName", valid_569268
  var valid_569269 = path.getOrDefault("subscriptionId")
  valid_569269 = validateParameter(valid_569269, JString, required = true,
                                 default = nil)
  if valid_569269 != nil:
    section.add "subscriptionId", valid_569269
  var valid_569270 = path.getOrDefault("triggerName")
  valid_569270 = validateParameter(valid_569270, JString, required = true,
                                 default = nil)
  if valid_569270 != nil:
    section.add "triggerName", valid_569270
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
  var valid_569271 = query.getOrDefault("api-version")
  valid_569271 = validateParameter(valid_569271, JString, required = true,
                                 default = nil)
  if valid_569271 != nil:
    section.add "api-version", valid_569271
  var valid_569272 = query.getOrDefault("$top")
  valid_569272 = validateParameter(valid_569272, JInt, required = false, default = nil)
  if valid_569272 != nil:
    section.add "$top", valid_569272
  var valid_569273 = query.getOrDefault("$filter")
  valid_569273 = validateParameter(valid_569273, JString, required = false,
                                 default = nil)
  if valid_569273 != nil:
    section.add "$filter", valid_569273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569274: Call_WorkflowTriggerHistoriesList_569264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow trigger histories.
  ## 
  let valid = call_569274.validator(path, query, header, formData, body)
  let scheme = call_569274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569274.url(scheme.get, call_569274.host, call_569274.base,
                         call_569274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569274, url, valid)

proc call*(call_569275: Call_WorkflowTriggerHistoriesList_569264;
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
  ##         : The filter to apply on the operation. Options for filters include: Status, StartTime, and ClientTrackingId.
  var path_569276 = newJObject()
  var query_569277 = newJObject()
  add(path_569276, "workflowName", newJString(workflowName))
  add(path_569276, "resourceGroupName", newJString(resourceGroupName))
  add(query_569277, "api-version", newJString(apiVersion))
  add(path_569276, "subscriptionId", newJString(subscriptionId))
  add(query_569277, "$top", newJInt(Top))
  add(path_569276, "triggerName", newJString(triggerName))
  add(query_569277, "$filter", newJString(Filter))
  result = call_569275.call(path_569276, query_569277, nil, nil, nil)

var workflowTriggerHistoriesList* = Call_WorkflowTriggerHistoriesList_569264(
    name: "workflowTriggerHistoriesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories",
    validator: validate_WorkflowTriggerHistoriesList_569265, base: "",
    url: url_WorkflowTriggerHistoriesList_569266, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesGet_569278 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggerHistoriesGet_569280(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesGet_569279(path: JsonNode; query: JsonNode;
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
  ##              : The workflow trigger history name. Corresponds to the run name for triggers that resulted in a run.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_569281 = path.getOrDefault("workflowName")
  valid_569281 = validateParameter(valid_569281, JString, required = true,
                                 default = nil)
  if valid_569281 != nil:
    section.add "workflowName", valid_569281
  var valid_569282 = path.getOrDefault("resourceGroupName")
  valid_569282 = validateParameter(valid_569282, JString, required = true,
                                 default = nil)
  if valid_569282 != nil:
    section.add "resourceGroupName", valid_569282
  var valid_569283 = path.getOrDefault("historyName")
  valid_569283 = validateParameter(valid_569283, JString, required = true,
                                 default = nil)
  if valid_569283 != nil:
    section.add "historyName", valid_569283
  var valid_569284 = path.getOrDefault("subscriptionId")
  valid_569284 = validateParameter(valid_569284, JString, required = true,
                                 default = nil)
  if valid_569284 != nil:
    section.add "subscriptionId", valid_569284
  var valid_569285 = path.getOrDefault("triggerName")
  valid_569285 = validateParameter(valid_569285, JString, required = true,
                                 default = nil)
  if valid_569285 != nil:
    section.add "triggerName", valid_569285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569286 = query.getOrDefault("api-version")
  valid_569286 = validateParameter(valid_569286, JString, required = true,
                                 default = nil)
  if valid_569286 != nil:
    section.add "api-version", valid_569286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569287: Call_WorkflowTriggerHistoriesGet_569278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow trigger history.
  ## 
  let valid = call_569287.validator(path, query, header, formData, body)
  let scheme = call_569287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569287.url(scheme.get, call_569287.host, call_569287.base,
                         call_569287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569287, url, valid)

proc call*(call_569288: Call_WorkflowTriggerHistoriesGet_569278;
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
  ##              : The workflow trigger history name. Corresponds to the run name for triggers that resulted in a run.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  var path_569289 = newJObject()
  var query_569290 = newJObject()
  add(path_569289, "workflowName", newJString(workflowName))
  add(path_569289, "resourceGroupName", newJString(resourceGroupName))
  add(query_569290, "api-version", newJString(apiVersion))
  add(path_569289, "historyName", newJString(historyName))
  add(path_569289, "subscriptionId", newJString(subscriptionId))
  add(path_569289, "triggerName", newJString(triggerName))
  result = call_569288.call(path_569289, query_569290, nil, nil, nil)

var workflowTriggerHistoriesGet* = Call_WorkflowTriggerHistoriesGet_569278(
    name: "workflowTriggerHistoriesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories/{historyName}",
    validator: validate_WorkflowTriggerHistoriesGet_569279, base: "",
    url: url_WorkflowTriggerHistoriesGet_569280, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesResubmit_569291 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggerHistoriesResubmit_569293(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesResubmit_569292(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resubmits a workflow run based on the trigger history.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowName: JString (required)
  ##               : The workflow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   historyName: JString (required)
  ##              : The workflow trigger history name. Corresponds to the run name for triggers that resulted in a run.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_569294 = path.getOrDefault("workflowName")
  valid_569294 = validateParameter(valid_569294, JString, required = true,
                                 default = nil)
  if valid_569294 != nil:
    section.add "workflowName", valid_569294
  var valid_569295 = path.getOrDefault("resourceGroupName")
  valid_569295 = validateParameter(valid_569295, JString, required = true,
                                 default = nil)
  if valid_569295 != nil:
    section.add "resourceGroupName", valid_569295
  var valid_569296 = path.getOrDefault("historyName")
  valid_569296 = validateParameter(valid_569296, JString, required = true,
                                 default = nil)
  if valid_569296 != nil:
    section.add "historyName", valid_569296
  var valid_569297 = path.getOrDefault("subscriptionId")
  valid_569297 = validateParameter(valid_569297, JString, required = true,
                                 default = nil)
  if valid_569297 != nil:
    section.add "subscriptionId", valid_569297
  var valid_569298 = path.getOrDefault("triggerName")
  valid_569298 = validateParameter(valid_569298, JString, required = true,
                                 default = nil)
  if valid_569298 != nil:
    section.add "triggerName", valid_569298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569299 = query.getOrDefault("api-version")
  valid_569299 = validateParameter(valid_569299, JString, required = true,
                                 default = nil)
  if valid_569299 != nil:
    section.add "api-version", valid_569299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569300: Call_WorkflowTriggerHistoriesResubmit_569291;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resubmits a workflow run based on the trigger history.
  ## 
  let valid = call_569300.validator(path, query, header, formData, body)
  let scheme = call_569300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569300.url(scheme.get, call_569300.host, call_569300.base,
                         call_569300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569300, url, valid)

proc call*(call_569301: Call_WorkflowTriggerHistoriesResubmit_569291;
          workflowName: string; resourceGroupName: string; apiVersion: string;
          historyName: string; subscriptionId: string; triggerName: string): Recallable =
  ## workflowTriggerHistoriesResubmit
  ## Resubmits a workflow run based on the trigger history.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   historyName: string (required)
  ##              : The workflow trigger history name. Corresponds to the run name for triggers that resulted in a run.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  var path_569302 = newJObject()
  var query_569303 = newJObject()
  add(path_569302, "workflowName", newJString(workflowName))
  add(path_569302, "resourceGroupName", newJString(resourceGroupName))
  add(query_569303, "api-version", newJString(apiVersion))
  add(path_569302, "historyName", newJString(historyName))
  add(path_569302, "subscriptionId", newJString(subscriptionId))
  add(path_569302, "triggerName", newJString(triggerName))
  result = call_569301.call(path_569302, query_569303, nil, nil, nil)

var workflowTriggerHistoriesResubmit* = Call_WorkflowTriggerHistoriesResubmit_569291(
    name: "workflowTriggerHistoriesResubmit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories/{historyName}/resubmit",
    validator: validate_WorkflowTriggerHistoriesResubmit_569292, base: "",
    url: url_WorkflowTriggerHistoriesResubmit_569293, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersListCallbackUrl_569304 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggersListCallbackUrl_569306(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggersListCallbackUrl_569305(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the callback URL for a workflow trigger.
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
  var valid_569307 = path.getOrDefault("workflowName")
  valid_569307 = validateParameter(valid_569307, JString, required = true,
                                 default = nil)
  if valid_569307 != nil:
    section.add "workflowName", valid_569307
  var valid_569308 = path.getOrDefault("resourceGroupName")
  valid_569308 = validateParameter(valid_569308, JString, required = true,
                                 default = nil)
  if valid_569308 != nil:
    section.add "resourceGroupName", valid_569308
  var valid_569309 = path.getOrDefault("subscriptionId")
  valid_569309 = validateParameter(valid_569309, JString, required = true,
                                 default = nil)
  if valid_569309 != nil:
    section.add "subscriptionId", valid_569309
  var valid_569310 = path.getOrDefault("triggerName")
  valid_569310 = validateParameter(valid_569310, JString, required = true,
                                 default = nil)
  if valid_569310 != nil:
    section.add "triggerName", valid_569310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569311 = query.getOrDefault("api-version")
  valid_569311 = validateParameter(valid_569311, JString, required = true,
                                 default = nil)
  if valid_569311 != nil:
    section.add "api-version", valid_569311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569312: Call_WorkflowTriggersListCallbackUrl_569304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the callback URL for a workflow trigger.
  ## 
  let valid = call_569312.validator(path, query, header, formData, body)
  let scheme = call_569312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569312.url(scheme.get, call_569312.host, call_569312.base,
                         call_569312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569312, url, valid)

proc call*(call_569313: Call_WorkflowTriggersListCallbackUrl_569304;
          workflowName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; triggerName: string): Recallable =
  ## workflowTriggersListCallbackUrl
  ## Get the callback URL for a workflow trigger.
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
  var path_569314 = newJObject()
  var query_569315 = newJObject()
  add(path_569314, "workflowName", newJString(workflowName))
  add(path_569314, "resourceGroupName", newJString(resourceGroupName))
  add(query_569315, "api-version", newJString(apiVersion))
  add(path_569314, "subscriptionId", newJString(subscriptionId))
  add(path_569314, "triggerName", newJString(triggerName))
  result = call_569313.call(path_569314, query_569315, nil, nil, nil)

var workflowTriggersListCallbackUrl* = Call_WorkflowTriggersListCallbackUrl_569304(
    name: "workflowTriggersListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/listCallbackUrl",
    validator: validate_WorkflowTriggersListCallbackUrl_569305, base: "",
    url: url_WorkflowTriggersListCallbackUrl_569306, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersReset_569316 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggersReset_569318(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersReset_569317(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets a workflow trigger.
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
  var valid_569319 = path.getOrDefault("workflowName")
  valid_569319 = validateParameter(valid_569319, JString, required = true,
                                 default = nil)
  if valid_569319 != nil:
    section.add "workflowName", valid_569319
  var valid_569320 = path.getOrDefault("resourceGroupName")
  valid_569320 = validateParameter(valid_569320, JString, required = true,
                                 default = nil)
  if valid_569320 != nil:
    section.add "resourceGroupName", valid_569320
  var valid_569321 = path.getOrDefault("subscriptionId")
  valid_569321 = validateParameter(valid_569321, JString, required = true,
                                 default = nil)
  if valid_569321 != nil:
    section.add "subscriptionId", valid_569321
  var valid_569322 = path.getOrDefault("triggerName")
  valid_569322 = validateParameter(valid_569322, JString, required = true,
                                 default = nil)
  if valid_569322 != nil:
    section.add "triggerName", valid_569322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569323 = query.getOrDefault("api-version")
  valid_569323 = validateParameter(valid_569323, JString, required = true,
                                 default = nil)
  if valid_569323 != nil:
    section.add "api-version", valid_569323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569324: Call_WorkflowTriggersReset_569316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets a workflow trigger.
  ## 
  let valid = call_569324.validator(path, query, header, formData, body)
  let scheme = call_569324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569324.url(scheme.get, call_569324.host, call_569324.base,
                         call_569324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569324, url, valid)

proc call*(call_569325: Call_WorkflowTriggersReset_569316; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          triggerName: string): Recallable =
  ## workflowTriggersReset
  ## Resets a workflow trigger.
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
  var path_569326 = newJObject()
  var query_569327 = newJObject()
  add(path_569326, "workflowName", newJString(workflowName))
  add(path_569326, "resourceGroupName", newJString(resourceGroupName))
  add(query_569327, "api-version", newJString(apiVersion))
  add(path_569326, "subscriptionId", newJString(subscriptionId))
  add(path_569326, "triggerName", newJString(triggerName))
  result = call_569325.call(path_569326, query_569327, nil, nil, nil)

var workflowTriggersReset* = Call_WorkflowTriggersReset_569316(
    name: "workflowTriggersReset", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/reset",
    validator: validate_WorkflowTriggersReset_569317, base: "",
    url: url_WorkflowTriggersReset_569318, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersRun_569328 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggersRun_569330(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersRun_569329(path: JsonNode; query: JsonNode;
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
  var valid_569331 = path.getOrDefault("workflowName")
  valid_569331 = validateParameter(valid_569331, JString, required = true,
                                 default = nil)
  if valid_569331 != nil:
    section.add "workflowName", valid_569331
  var valid_569332 = path.getOrDefault("resourceGroupName")
  valid_569332 = validateParameter(valid_569332, JString, required = true,
                                 default = nil)
  if valid_569332 != nil:
    section.add "resourceGroupName", valid_569332
  var valid_569333 = path.getOrDefault("subscriptionId")
  valid_569333 = validateParameter(valid_569333, JString, required = true,
                                 default = nil)
  if valid_569333 != nil:
    section.add "subscriptionId", valid_569333
  var valid_569334 = path.getOrDefault("triggerName")
  valid_569334 = validateParameter(valid_569334, JString, required = true,
                                 default = nil)
  if valid_569334 != nil:
    section.add "triggerName", valid_569334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569335 = query.getOrDefault("api-version")
  valid_569335 = validateParameter(valid_569335, JString, required = true,
                                 default = nil)
  if valid_569335 != nil:
    section.add "api-version", valid_569335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569336: Call_WorkflowTriggersRun_569328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a workflow trigger.
  ## 
  let valid = call_569336.validator(path, query, header, formData, body)
  let scheme = call_569336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569336.url(scheme.get, call_569336.host, call_569336.base,
                         call_569336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569336, url, valid)

proc call*(call_569337: Call_WorkflowTriggersRun_569328; workflowName: string;
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
  var path_569338 = newJObject()
  var query_569339 = newJObject()
  add(path_569338, "workflowName", newJString(workflowName))
  add(path_569338, "resourceGroupName", newJString(resourceGroupName))
  add(query_569339, "api-version", newJString(apiVersion))
  add(path_569338, "subscriptionId", newJString(subscriptionId))
  add(path_569338, "triggerName", newJString(triggerName))
  result = call_569337.call(path_569338, query_569339, nil, nil, nil)

var workflowTriggersRun* = Call_WorkflowTriggersRun_569328(
    name: "workflowTriggersRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/run",
    validator: validate_WorkflowTriggersRun_569329, base: "",
    url: url_WorkflowTriggersRun_569330, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersGetSchemaJson_569340 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggersGetSchemaJson_569342(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggersGetSchemaJson_569341(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the trigger schema as JSON.
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
  var valid_569343 = path.getOrDefault("workflowName")
  valid_569343 = validateParameter(valid_569343, JString, required = true,
                                 default = nil)
  if valid_569343 != nil:
    section.add "workflowName", valid_569343
  var valid_569344 = path.getOrDefault("resourceGroupName")
  valid_569344 = validateParameter(valid_569344, JString, required = true,
                                 default = nil)
  if valid_569344 != nil:
    section.add "resourceGroupName", valid_569344
  var valid_569345 = path.getOrDefault("subscriptionId")
  valid_569345 = validateParameter(valid_569345, JString, required = true,
                                 default = nil)
  if valid_569345 != nil:
    section.add "subscriptionId", valid_569345
  var valid_569346 = path.getOrDefault("triggerName")
  valid_569346 = validateParameter(valid_569346, JString, required = true,
                                 default = nil)
  if valid_569346 != nil:
    section.add "triggerName", valid_569346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569347 = query.getOrDefault("api-version")
  valid_569347 = validateParameter(valid_569347, JString, required = true,
                                 default = nil)
  if valid_569347 != nil:
    section.add "api-version", valid_569347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569348: Call_WorkflowTriggersGetSchemaJson_569340; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the trigger schema as JSON.
  ## 
  let valid = call_569348.validator(path, query, header, formData, body)
  let scheme = call_569348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569348.url(scheme.get, call_569348.host, call_569348.base,
                         call_569348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569348, url, valid)

proc call*(call_569349: Call_WorkflowTriggersGetSchemaJson_569340;
          workflowName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; triggerName: string): Recallable =
  ## workflowTriggersGetSchemaJson
  ## Get the trigger schema as JSON.
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
  var path_569350 = newJObject()
  var query_569351 = newJObject()
  add(path_569350, "workflowName", newJString(workflowName))
  add(path_569350, "resourceGroupName", newJString(resourceGroupName))
  add(query_569351, "api-version", newJString(apiVersion))
  add(path_569350, "subscriptionId", newJString(subscriptionId))
  add(path_569350, "triggerName", newJString(triggerName))
  result = call_569349.call(path_569350, query_569351, nil, nil, nil)

var workflowTriggersGetSchemaJson* = Call_WorkflowTriggersGetSchemaJson_569340(
    name: "workflowTriggersGetSchemaJson", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/schemas/json",
    validator: validate_WorkflowTriggersGetSchemaJson_569341, base: "",
    url: url_WorkflowTriggersGetSchemaJson_569342, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersSetState_569352 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggersSetState_569354(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggersSetState_569353(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the state of a workflow trigger.
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
  var valid_569355 = path.getOrDefault("workflowName")
  valid_569355 = validateParameter(valid_569355, JString, required = true,
                                 default = nil)
  if valid_569355 != nil:
    section.add "workflowName", valid_569355
  var valid_569356 = path.getOrDefault("resourceGroupName")
  valid_569356 = validateParameter(valid_569356, JString, required = true,
                                 default = nil)
  if valid_569356 != nil:
    section.add "resourceGroupName", valid_569356
  var valid_569357 = path.getOrDefault("subscriptionId")
  valid_569357 = validateParameter(valid_569357, JString, required = true,
                                 default = nil)
  if valid_569357 != nil:
    section.add "subscriptionId", valid_569357
  var valid_569358 = path.getOrDefault("triggerName")
  valid_569358 = validateParameter(valid_569358, JString, required = true,
                                 default = nil)
  if valid_569358 != nil:
    section.add "triggerName", valid_569358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569359 = query.getOrDefault("api-version")
  valid_569359 = validateParameter(valid_569359, JString, required = true,
                                 default = nil)
  if valid_569359 != nil:
    section.add "api-version", valid_569359
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

proc call*(call_569361: Call_WorkflowTriggersSetState_569352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of a workflow trigger.
  ## 
  let valid = call_569361.validator(path, query, header, formData, body)
  let scheme = call_569361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569361.url(scheme.get, call_569361.host, call_569361.base,
                         call_569361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569361, url, valid)

proc call*(call_569362: Call_WorkflowTriggersSetState_569352; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          triggerName: string; setState: JsonNode): Recallable =
  ## workflowTriggersSetState
  ## Sets the state of a workflow trigger.
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
  ##   setState: JObject (required)
  ##           : The workflow trigger state.
  var path_569363 = newJObject()
  var query_569364 = newJObject()
  var body_569365 = newJObject()
  add(path_569363, "workflowName", newJString(workflowName))
  add(path_569363, "resourceGroupName", newJString(resourceGroupName))
  add(query_569364, "api-version", newJString(apiVersion))
  add(path_569363, "subscriptionId", newJString(subscriptionId))
  add(path_569363, "triggerName", newJString(triggerName))
  if setState != nil:
    body_569365 = setState
  result = call_569362.call(path_569363, query_569364, nil, nil, body_569365)

var workflowTriggersSetState* = Call_WorkflowTriggersSetState_569352(
    name: "workflowTriggersSetState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/setState",
    validator: validate_WorkflowTriggersSetState_569353, base: "",
    url: url_WorkflowTriggersSetState_569354, schemes: {Scheme.Https})
type
  Call_WorkflowsValidateWorkflow_569366 = ref object of OpenApiRestCall_567667
proc url_WorkflowsValidateWorkflow_569368(protocol: Scheme; host: string;
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

proc validate_WorkflowsValidateWorkflow_569367(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the workflow.
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
  var valid_569369 = path.getOrDefault("workflowName")
  valid_569369 = validateParameter(valid_569369, JString, required = true,
                                 default = nil)
  if valid_569369 != nil:
    section.add "workflowName", valid_569369
  var valid_569370 = path.getOrDefault("resourceGroupName")
  valid_569370 = validateParameter(valid_569370, JString, required = true,
                                 default = nil)
  if valid_569370 != nil:
    section.add "resourceGroupName", valid_569370
  var valid_569371 = path.getOrDefault("subscriptionId")
  valid_569371 = validateParameter(valid_569371, JString, required = true,
                                 default = nil)
  if valid_569371 != nil:
    section.add "subscriptionId", valid_569371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569372 = query.getOrDefault("api-version")
  valid_569372 = validateParameter(valid_569372, JString, required = true,
                                 default = nil)
  if valid_569372 != nil:
    section.add "api-version", valid_569372
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

proc call*(call_569374: Call_WorkflowsValidateWorkflow_569366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the workflow.
  ## 
  let valid = call_569374.validator(path, query, header, formData, body)
  let scheme = call_569374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569374.url(scheme.get, call_569374.host, call_569374.base,
                         call_569374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569374, url, valid)

proc call*(call_569375: Call_WorkflowsValidateWorkflow_569366;
          workflowName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; validate: JsonNode): Recallable =
  ## workflowsValidateWorkflow
  ## Validates the workflow.
  ##   workflowName: string (required)
  ##               : The workflow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   validate: JObject (required)
  ##           : The workflow.
  var path_569376 = newJObject()
  var query_569377 = newJObject()
  var body_569378 = newJObject()
  add(path_569376, "workflowName", newJString(workflowName))
  add(path_569376, "resourceGroupName", newJString(resourceGroupName))
  add(query_569377, "api-version", newJString(apiVersion))
  add(path_569376, "subscriptionId", newJString(subscriptionId))
  if validate != nil:
    body_569378 = validate
  result = call_569375.call(path_569376, query_569377, nil, nil, body_569378)

var workflowsValidateWorkflow* = Call_WorkflowsValidateWorkflow_569366(
    name: "workflowsValidateWorkflow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/validate",
    validator: validate_WorkflowsValidateWorkflow_569367, base: "",
    url: url_WorkflowsValidateWorkflow_569368, schemes: {Scheme.Https})
type
  Call_WorkflowVersionsList_569379 = ref object of OpenApiRestCall_567667
proc url_WorkflowVersionsList_569381(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowVersionsList_569380(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of workflow versions.
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
  var valid_569382 = path.getOrDefault("workflowName")
  valid_569382 = validateParameter(valid_569382, JString, required = true,
                                 default = nil)
  if valid_569382 != nil:
    section.add "workflowName", valid_569382
  var valid_569383 = path.getOrDefault("resourceGroupName")
  valid_569383 = validateParameter(valid_569383, JString, required = true,
                                 default = nil)
  if valid_569383 != nil:
    section.add "resourceGroupName", valid_569383
  var valid_569384 = path.getOrDefault("subscriptionId")
  valid_569384 = validateParameter(valid_569384, JString, required = true,
                                 default = nil)
  if valid_569384 != nil:
    section.add "subscriptionId", valid_569384
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569385 = query.getOrDefault("api-version")
  valid_569385 = validateParameter(valid_569385, JString, required = true,
                                 default = nil)
  if valid_569385 != nil:
    section.add "api-version", valid_569385
  var valid_569386 = query.getOrDefault("$top")
  valid_569386 = validateParameter(valid_569386, JInt, required = false, default = nil)
  if valid_569386 != nil:
    section.add "$top", valid_569386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569387: Call_WorkflowVersionsList_569379; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow versions.
  ## 
  let valid = call_569387.validator(path, query, header, formData, body)
  let scheme = call_569387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569387.url(scheme.get, call_569387.host, call_569387.base,
                         call_569387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569387, url, valid)

proc call*(call_569388: Call_WorkflowVersionsList_569379; workflowName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0): Recallable =
  ## workflowVersionsList
  ## Gets a list of workflow versions.
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
  var path_569389 = newJObject()
  var query_569390 = newJObject()
  add(path_569389, "workflowName", newJString(workflowName))
  add(path_569389, "resourceGroupName", newJString(resourceGroupName))
  add(query_569390, "api-version", newJString(apiVersion))
  add(path_569389, "subscriptionId", newJString(subscriptionId))
  add(query_569390, "$top", newJInt(Top))
  result = call_569388.call(path_569389, query_569390, nil, nil, nil)

var workflowVersionsList* = Call_WorkflowVersionsList_569379(
    name: "workflowVersionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions",
    validator: validate_WorkflowVersionsList_569380, base: "",
    url: url_WorkflowVersionsList_569381, schemes: {Scheme.Https})
type
  Call_WorkflowVersionsGet_569391 = ref object of OpenApiRestCall_567667
proc url_WorkflowVersionsGet_569393(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowVersionsGet_569392(path: JsonNode; query: JsonNode;
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
  var valid_569394 = path.getOrDefault("workflowName")
  valid_569394 = validateParameter(valid_569394, JString, required = true,
                                 default = nil)
  if valid_569394 != nil:
    section.add "workflowName", valid_569394
  var valid_569395 = path.getOrDefault("resourceGroupName")
  valid_569395 = validateParameter(valid_569395, JString, required = true,
                                 default = nil)
  if valid_569395 != nil:
    section.add "resourceGroupName", valid_569395
  var valid_569396 = path.getOrDefault("versionId")
  valid_569396 = validateParameter(valid_569396, JString, required = true,
                                 default = nil)
  if valid_569396 != nil:
    section.add "versionId", valid_569396
  var valid_569397 = path.getOrDefault("subscriptionId")
  valid_569397 = validateParameter(valid_569397, JString, required = true,
                                 default = nil)
  if valid_569397 != nil:
    section.add "subscriptionId", valid_569397
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569398 = query.getOrDefault("api-version")
  valid_569398 = validateParameter(valid_569398, JString, required = true,
                                 default = nil)
  if valid_569398 != nil:
    section.add "api-version", valid_569398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569399: Call_WorkflowVersionsGet_569391; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow version.
  ## 
  let valid = call_569399.validator(path, query, header, formData, body)
  let scheme = call_569399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569399.url(scheme.get, call_569399.host, call_569399.base,
                         call_569399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569399, url, valid)

proc call*(call_569400: Call_WorkflowVersionsGet_569391; workflowName: string;
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
  var path_569401 = newJObject()
  var query_569402 = newJObject()
  add(path_569401, "workflowName", newJString(workflowName))
  add(path_569401, "resourceGroupName", newJString(resourceGroupName))
  add(path_569401, "versionId", newJString(versionId))
  add(query_569402, "api-version", newJString(apiVersion))
  add(path_569401, "subscriptionId", newJString(subscriptionId))
  result = call_569400.call(path_569401, query_569402, nil, nil, nil)

var workflowVersionsGet* = Call_WorkflowVersionsGet_569391(
    name: "workflowVersionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions/{versionId}",
    validator: validate_WorkflowVersionsGet_569392, base: "",
    url: url_WorkflowVersionsGet_569393, schemes: {Scheme.Https})
type
  Call_WorkflowVersionsListCallbackUrl_569403 = ref object of OpenApiRestCall_567667
proc url_WorkflowVersionsListCallbackUrl_569405(protocol: Scheme; host: string;
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

proc validate_WorkflowVersionsListCallbackUrl_569404(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the callback url for a trigger of a workflow version.
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
  ##   triggerName: JString (required)
  ##              : The workflow trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowName` field"
  var valid_569406 = path.getOrDefault("workflowName")
  valid_569406 = validateParameter(valid_569406, JString, required = true,
                                 default = nil)
  if valid_569406 != nil:
    section.add "workflowName", valid_569406
  var valid_569407 = path.getOrDefault("resourceGroupName")
  valid_569407 = validateParameter(valid_569407, JString, required = true,
                                 default = nil)
  if valid_569407 != nil:
    section.add "resourceGroupName", valid_569407
  var valid_569408 = path.getOrDefault("versionId")
  valid_569408 = validateParameter(valid_569408, JString, required = true,
                                 default = nil)
  if valid_569408 != nil:
    section.add "versionId", valid_569408
  var valid_569409 = path.getOrDefault("subscriptionId")
  valid_569409 = validateParameter(valid_569409, JString, required = true,
                                 default = nil)
  if valid_569409 != nil:
    section.add "subscriptionId", valid_569409
  var valid_569410 = path.getOrDefault("triggerName")
  valid_569410 = validateParameter(valid_569410, JString, required = true,
                                 default = nil)
  if valid_569410 != nil:
    section.add "triggerName", valid_569410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569411 = query.getOrDefault("api-version")
  valid_569411 = validateParameter(valid_569411, JString, required = true,
                                 default = nil)
  if valid_569411 != nil:
    section.add "api-version", valid_569411
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

proc call*(call_569413: Call_WorkflowVersionsListCallbackUrl_569403;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the callback url for a trigger of a workflow version.
  ## 
  let valid = call_569413.validator(path, query, header, formData, body)
  let scheme = call_569413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569413.url(scheme.get, call_569413.host, call_569413.base,
                         call_569413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569413, url, valid)

proc call*(call_569414: Call_WorkflowVersionsListCallbackUrl_569403;
          workflowName: string; resourceGroupName: string; versionId: string;
          apiVersion: string; subscriptionId: string; triggerName: string;
          parameters: JsonNode = nil): Recallable =
  ## workflowVersionsListCallbackUrl
  ## Get the callback url for a trigger of a workflow version.
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
  ##   parameters: JObject
  ##             : The callback URL parameters.
  ##   triggerName: string (required)
  ##              : The workflow trigger name.
  var path_569415 = newJObject()
  var query_569416 = newJObject()
  var body_569417 = newJObject()
  add(path_569415, "workflowName", newJString(workflowName))
  add(path_569415, "resourceGroupName", newJString(resourceGroupName))
  add(path_569415, "versionId", newJString(versionId))
  add(query_569416, "api-version", newJString(apiVersion))
  add(path_569415, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_569417 = parameters
  add(path_569415, "triggerName", newJString(triggerName))
  result = call_569414.call(path_569415, query_569416, nil, nil, body_569417)

var workflowVersionsListCallbackUrl* = Call_WorkflowVersionsListCallbackUrl_569403(
    name: "workflowVersionsListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions/{versionId}/triggers/{triggerName}/listCallbackUrl",
    validator: validate_WorkflowVersionsListCallbackUrl_569404, base: "",
    url: url_WorkflowVersionsListCallbackUrl_569405, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
