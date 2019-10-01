
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: LogicManagementClient
## version: 2018-07-01-preview
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
  Call_OperationsList_567889 = ref object of OpenApiRestCall_567667
proc url_OperationsList_567891(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567890(path: JsonNode; query: JsonNode;
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

proc call*(call_568073: Call_OperationsList_567889; path: JsonNode; query: JsonNode;
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

proc call*(call_568144: Call_OperationsList_567889; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Logic REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version.
  var query_568145 = newJObject()
  add(query_568145, "api-version", newJString(apiVersion))
  result = call_568144.call(nil, query_568145, nil, nil, nil)

var operationsList* = Call_OperationsList_567889(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Logic/operations",
    validator: validate_OperationsList_567890, base: "", url: url_OperationsList_567891,
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
  Call_IntegrationAccountAgreementsList_568280 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountAgreementsList_568282(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAgreementsList_568281(path: JsonNode;
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

proc call*(call_568289: Call_IntegrationAccountAgreementsList_568280;
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

proc call*(call_568290: Call_IntegrationAccountAgreementsList_568280;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## integrationAccountAgreementsList
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

var integrationAccountAgreementsList* = Call_IntegrationAccountAgreementsList_568280(
    name: "integrationAccountAgreementsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements",
    validator: validate_IntegrationAccountAgreementsList_568281, base: "",
    url: url_IntegrationAccountAgreementsList_568282, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsCreateOrUpdate_568305 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountAgreementsCreateOrUpdate_568307(protocol: Scheme;
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

proc validate_IntegrationAccountAgreementsCreateOrUpdate_568306(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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

proc call*(call_568314: Call_IntegrationAccountAgreementsCreateOrUpdate_568305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_568315: Call_IntegrationAccountAgreementsCreateOrUpdate_568305;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          agreementName: string; agreement: JsonNode): Recallable =
  ## integrationAccountAgreementsCreateOrUpdate
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

var integrationAccountAgreementsCreateOrUpdate* = Call_IntegrationAccountAgreementsCreateOrUpdate_568305(
    name: "integrationAccountAgreementsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_IntegrationAccountAgreementsCreateOrUpdate_568306,
    base: "", url: url_IntegrationAccountAgreementsCreateOrUpdate_568307,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsGet_568293 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountAgreementsGet_568295(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAgreementsGet_568294(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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

proc call*(call_568301: Call_IntegrationAccountAgreementsGet_568293;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_568302: Call_IntegrationAccountAgreementsGet_568293;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          agreementName: string): Recallable =
  ## integrationAccountAgreementsGet
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

var integrationAccountAgreementsGet* = Call_IntegrationAccountAgreementsGet_568293(
    name: "integrationAccountAgreementsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_IntegrationAccountAgreementsGet_568294, base: "",
    url: url_IntegrationAccountAgreementsGet_568295, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsDelete_568319 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountAgreementsDelete_568321(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAgreementsDelete_568320(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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

proc call*(call_568327: Call_IntegrationAccountAgreementsDelete_568319;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_568328: Call_IntegrationAccountAgreementsDelete_568319;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          agreementName: string): Recallable =
  ## integrationAccountAgreementsDelete
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

var integrationAccountAgreementsDelete* = Call_IntegrationAccountAgreementsDelete_568319(
    name: "integrationAccountAgreementsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_IntegrationAccountAgreementsDelete_568320, base: "",
    url: url_IntegrationAccountAgreementsDelete_568321, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsListContentCallbackUrl_568331 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountAgreementsListContentCallbackUrl_568333(
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

proc validate_IntegrationAccountAgreementsListContentCallbackUrl_568332(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
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

proc call*(call_568340: Call_IntegrationAccountAgreementsListContentCallbackUrl_568331;
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

proc call*(call_568341: Call_IntegrationAccountAgreementsListContentCallbackUrl_568331;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          agreementName: string; listContentCallbackUrl: JsonNode): Recallable =
  ## integrationAccountAgreementsListContentCallbackUrl
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

var integrationAccountAgreementsListContentCallbackUrl* = Call_IntegrationAccountAgreementsListContentCallbackUrl_568331(
    name: "integrationAccountAgreementsListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountAgreementsListContentCallbackUrl_568332,
    base: "", url: url_IntegrationAccountAgreementsListContentCallbackUrl_568333,
    schemes: {Scheme.Https})
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
  Call_IntegrationAccountCertificatesList_568455 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountCertificatesList_568457(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountCertificatesList_568456(path: JsonNode;
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

proc call*(call_568463: Call_IntegrationAccountCertificatesList_568455;
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

proc call*(call_568464: Call_IntegrationAccountCertificatesList_568455;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0): Recallable =
  ## integrationAccountCertificatesList
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

var integrationAccountCertificatesList* = Call_IntegrationAccountCertificatesList_568455(
    name: "integrationAccountCertificatesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates",
    validator: validate_IntegrationAccountCertificatesList_568456, base: "",
    url: url_IntegrationAccountCertificatesList_568457, schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesCreateOrUpdate_568479 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountCertificatesCreateOrUpdate_568481(protocol: Scheme;
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

proc validate_IntegrationAccountCertificatesCreateOrUpdate_568480(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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

proc call*(call_568488: Call_IntegrationAccountCertificatesCreateOrUpdate_568479;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_568489: Call_IntegrationAccountCertificatesCreateOrUpdate_568479;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          certificate: JsonNode; certificateName: string): Recallable =
  ## integrationAccountCertificatesCreateOrUpdate
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

var integrationAccountCertificatesCreateOrUpdate* = Call_IntegrationAccountCertificatesCreateOrUpdate_568479(
    name: "integrationAccountCertificatesCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_IntegrationAccountCertificatesCreateOrUpdate_568480,
    base: "", url: url_IntegrationAccountCertificatesCreateOrUpdate_568481,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesGet_568467 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountCertificatesGet_568469(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountCertificatesGet_568468(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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

proc call*(call_568475: Call_IntegrationAccountCertificatesGet_568467;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_568476: Call_IntegrationAccountCertificatesGet_568467;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          certificateName: string): Recallable =
  ## integrationAccountCertificatesGet
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

var integrationAccountCertificatesGet* = Call_IntegrationAccountCertificatesGet_568467(
    name: "integrationAccountCertificatesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_IntegrationAccountCertificatesGet_568468, base: "",
    url: url_IntegrationAccountCertificatesGet_568469, schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesDelete_568493 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountCertificatesDelete_568495(protocol: Scheme;
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

proc validate_IntegrationAccountCertificatesDelete_568494(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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

proc call*(call_568501: Call_IntegrationAccountCertificatesDelete_568493;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_568502: Call_IntegrationAccountCertificatesDelete_568493;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          certificateName: string): Recallable =
  ## integrationAccountCertificatesDelete
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

var integrationAccountCertificatesDelete* = Call_IntegrationAccountCertificatesDelete_568493(
    name: "integrationAccountCertificatesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_IntegrationAccountCertificatesDelete_568494, base: "",
    url: url_IntegrationAccountCertificatesDelete_568495, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListCallbackUrl_568505 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountsListCallbackUrl_568507(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsListCallbackUrl_568506(path: JsonNode;
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

proc call*(call_568513: Call_IntegrationAccountsListCallbackUrl_568505;
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

proc call*(call_568514: Call_IntegrationAccountsListCallbackUrl_568505;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## integrationAccountsListCallbackUrl
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

var integrationAccountsListCallbackUrl* = Call_IntegrationAccountsListCallbackUrl_568505(
    name: "integrationAccountsListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/listCallbackUrl",
    validator: validate_IntegrationAccountsListCallbackUrl_568506, base: "",
    url: url_IntegrationAccountsListCallbackUrl_568507, schemes: {Scheme.Https})
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
  Call_IntegrationAccountMapsList_568544 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountMapsList_568546(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountMapsList_568545(path: JsonNode; query: JsonNode;
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

proc call*(call_568553: Call_IntegrationAccountMapsList_568544; path: JsonNode;
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

proc call*(call_568554: Call_IntegrationAccountMapsList_568544;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## integrationAccountMapsList
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

var integrationAccountMapsList* = Call_IntegrationAccountMapsList_568544(
    name: "integrationAccountMapsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps",
    validator: validate_IntegrationAccountMapsList_568545, base: "",
    url: url_IntegrationAccountMapsList_568546, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsCreateOrUpdate_568569 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountMapsCreateOrUpdate_568571(protocol: Scheme;
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

proc validate_IntegrationAccountMapsCreateOrUpdate_568570(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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

proc call*(call_568578: Call_IntegrationAccountMapsCreateOrUpdate_568569;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_568579: Call_IntegrationAccountMapsCreateOrUpdate_568569;
          resourceGroupName: string; map: JsonNode; mapName: string;
          apiVersion: string; integrationAccountName: string; subscriptionId: string): Recallable =
  ## integrationAccountMapsCreateOrUpdate
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

var integrationAccountMapsCreateOrUpdate* = Call_IntegrationAccountMapsCreateOrUpdate_568569(
    name: "integrationAccountMapsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_IntegrationAccountMapsCreateOrUpdate_568570, base: "",
    url: url_IntegrationAccountMapsCreateOrUpdate_568571, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsGet_568557 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountMapsGet_568559(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountMapsGet_568558(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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

proc call*(call_568565: Call_IntegrationAccountMapsGet_568557; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
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

proc call*(call_568566: Call_IntegrationAccountMapsGet_568557;
          resourceGroupName: string; mapName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string): Recallable =
  ## integrationAccountMapsGet
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

var integrationAccountMapsGet* = Call_IntegrationAccountMapsGet_568557(
    name: "integrationAccountMapsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_IntegrationAccountMapsGet_568558, base: "",
    url: url_IntegrationAccountMapsGet_568559, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsDelete_568583 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountMapsDelete_568585(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountMapsDelete_568584(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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

proc call*(call_568591: Call_IntegrationAccountMapsDelete_568583; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
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

proc call*(call_568592: Call_IntegrationAccountMapsDelete_568583;
          resourceGroupName: string; mapName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string): Recallable =
  ## integrationAccountMapsDelete
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

var integrationAccountMapsDelete* = Call_IntegrationAccountMapsDelete_568583(
    name: "integrationAccountMapsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_IntegrationAccountMapsDelete_568584, base: "",
    url: url_IntegrationAccountMapsDelete_568585, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsListContentCallbackUrl_568595 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountMapsListContentCallbackUrl_568597(protocol: Scheme;
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

proc validate_IntegrationAccountMapsListContentCallbackUrl_568596(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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

proc call*(call_568604: Call_IntegrationAccountMapsListContentCallbackUrl_568595;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_568605: Call_IntegrationAccountMapsListContentCallbackUrl_568595;
          resourceGroupName: string; mapName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          listContentCallbackUrl: JsonNode): Recallable =
  ## integrationAccountMapsListContentCallbackUrl
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

var integrationAccountMapsListContentCallbackUrl* = Call_IntegrationAccountMapsListContentCallbackUrl_568595(
    name: "integrationAccountMapsListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountMapsListContentCallbackUrl_568596,
    base: "", url: url_IntegrationAccountMapsListContentCallbackUrl_568597,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersList_568609 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountPartnersList_568611(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountPartnersList_568610(path: JsonNode;
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

proc call*(call_568618: Call_IntegrationAccountPartnersList_568609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
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

proc call*(call_568619: Call_IntegrationAccountPartnersList_568609;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## integrationAccountPartnersList
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

var integrationAccountPartnersList* = Call_IntegrationAccountPartnersList_568609(
    name: "integrationAccountPartnersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners",
    validator: validate_IntegrationAccountPartnersList_568610, base: "",
    url: url_IntegrationAccountPartnersList_568611, schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersCreateOrUpdate_568634 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountPartnersCreateOrUpdate_568636(protocol: Scheme;
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

proc validate_IntegrationAccountPartnersCreateOrUpdate_568635(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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

proc call*(call_568643: Call_IntegrationAccountPartnersCreateOrUpdate_568634;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_568644: Call_IntegrationAccountPartnersCreateOrUpdate_568634;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; partner: JsonNode;
          partnerName: string): Recallable =
  ## integrationAccountPartnersCreateOrUpdate
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

var integrationAccountPartnersCreateOrUpdate* = Call_IntegrationAccountPartnersCreateOrUpdate_568634(
    name: "integrationAccountPartnersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_IntegrationAccountPartnersCreateOrUpdate_568635, base: "",
    url: url_IntegrationAccountPartnersCreateOrUpdate_568636,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersGet_568622 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountPartnersGet_568624(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountPartnersGet_568623(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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

proc call*(call_568630: Call_IntegrationAccountPartnersGet_568622; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
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

proc call*(call_568631: Call_IntegrationAccountPartnersGet_568622;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          partnerName: string): Recallable =
  ## integrationAccountPartnersGet
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

var integrationAccountPartnersGet* = Call_IntegrationAccountPartnersGet_568622(
    name: "integrationAccountPartnersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_IntegrationAccountPartnersGet_568623, base: "",
    url: url_IntegrationAccountPartnersGet_568624, schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersDelete_568648 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountPartnersDelete_568650(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountPartnersDelete_568649(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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

proc call*(call_568656: Call_IntegrationAccountPartnersDelete_568648;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_568657: Call_IntegrationAccountPartnersDelete_568648;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          partnerName: string): Recallable =
  ## integrationAccountPartnersDelete
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

var integrationAccountPartnersDelete* = Call_IntegrationAccountPartnersDelete_568648(
    name: "integrationAccountPartnersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_IntegrationAccountPartnersDelete_568649, base: "",
    url: url_IntegrationAccountPartnersDelete_568650, schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersListContentCallbackUrl_568660 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountPartnersListContentCallbackUrl_568662(
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

proc validate_IntegrationAccountPartnersListContentCallbackUrl_568661(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
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

proc call*(call_568669: Call_IntegrationAccountPartnersListContentCallbackUrl_568660;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_568670: Call_IntegrationAccountPartnersListContentCallbackUrl_568660;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          partnerName: string; listContentCallbackUrl: JsonNode): Recallable =
  ## integrationAccountPartnersListContentCallbackUrl
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

var integrationAccountPartnersListContentCallbackUrl* = Call_IntegrationAccountPartnersListContentCallbackUrl_568660(
    name: "integrationAccountPartnersListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountPartnersListContentCallbackUrl_568661,
    base: "", url: url_IntegrationAccountPartnersListContentCallbackUrl_568662,
    schemes: {Scheme.Https})
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
  Call_IntegrationAccountSchemasList_568687 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountSchemasList_568689(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountSchemasList_568688(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  ##          : The filter to apply on the operation. Options for filters include: SchemaType.
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

proc call*(call_568696: Call_IntegrationAccountSchemasList_568687; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account schemas.
  ## 
  let valid = call_568696.validator(path, query, header, formData, body)
  let scheme = call_568696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568696.url(scheme.get, call_568696.host, call_568696.base,
                         call_568696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568696, url, valid)

proc call*(call_568697: Call_IntegrationAccountSchemasList_568687;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## integrationAccountSchemasList
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
  var path_568698 = newJObject()
  var query_568699 = newJObject()
  add(path_568698, "resourceGroupName", newJString(resourceGroupName))
  add(query_568699, "api-version", newJString(apiVersion))
  add(path_568698, "integrationAccountName", newJString(integrationAccountName))
  add(path_568698, "subscriptionId", newJString(subscriptionId))
  add(query_568699, "$top", newJInt(Top))
  add(query_568699, "$filter", newJString(Filter))
  result = call_568697.call(path_568698, query_568699, nil, nil, nil)

var integrationAccountSchemasList* = Call_IntegrationAccountSchemasList_568687(
    name: "integrationAccountSchemasList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas",
    validator: validate_IntegrationAccountSchemasList_568688, base: "",
    url: url_IntegrationAccountSchemasList_568689, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasCreateOrUpdate_568712 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountSchemasCreateOrUpdate_568714(protocol: Scheme;
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

proc validate_IntegrationAccountSchemasCreateOrUpdate_568713(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_568718 = path.getOrDefault("schemaName")
  valid_568718 = validateParameter(valid_568718, JString, required = true,
                                 default = nil)
  if valid_568718 != nil:
    section.add "schemaName", valid_568718
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
  ##   schema: JObject (required)
  ##         : The integration account schema.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568721: Call_IntegrationAccountSchemasCreateOrUpdate_568712;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account schema.
  ## 
  let valid = call_568721.validator(path, query, header, formData, body)
  let scheme = call_568721.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568721.url(scheme.get, call_568721.host, call_568721.base,
                         call_568721.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568721, url, valid)

proc call*(call_568722: Call_IntegrationAccountSchemasCreateOrUpdate_568712;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          schemaName: string; schema: JsonNode): Recallable =
  ## integrationAccountSchemasCreateOrUpdate
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
  var path_568723 = newJObject()
  var query_568724 = newJObject()
  var body_568725 = newJObject()
  add(path_568723, "resourceGroupName", newJString(resourceGroupName))
  add(query_568724, "api-version", newJString(apiVersion))
  add(path_568723, "integrationAccountName", newJString(integrationAccountName))
  add(path_568723, "subscriptionId", newJString(subscriptionId))
  add(path_568723, "schemaName", newJString(schemaName))
  if schema != nil:
    body_568725 = schema
  result = call_568722.call(path_568723, query_568724, nil, nil, body_568725)

var integrationAccountSchemasCreateOrUpdate* = Call_IntegrationAccountSchemasCreateOrUpdate_568712(
    name: "integrationAccountSchemasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_IntegrationAccountSchemasCreateOrUpdate_568713, base: "",
    url: url_IntegrationAccountSchemasCreateOrUpdate_568714,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasGet_568700 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountSchemasGet_568702(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountSchemasGet_568701(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_568706 = path.getOrDefault("schemaName")
  valid_568706 = validateParameter(valid_568706, JString, required = true,
                                 default = nil)
  if valid_568706 != nil:
    section.add "schemaName", valid_568706
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

proc call*(call_568708: Call_IntegrationAccountSchemasGet_568700; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account schema.
  ## 
  let valid = call_568708.validator(path, query, header, formData, body)
  let scheme = call_568708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568708.url(scheme.get, call_568708.host, call_568708.base,
                         call_568708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568708, url, valid)

proc call*(call_568709: Call_IntegrationAccountSchemasGet_568700;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; schemaName: string): Recallable =
  ## integrationAccountSchemasGet
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
  var path_568710 = newJObject()
  var query_568711 = newJObject()
  add(path_568710, "resourceGroupName", newJString(resourceGroupName))
  add(query_568711, "api-version", newJString(apiVersion))
  add(path_568710, "integrationAccountName", newJString(integrationAccountName))
  add(path_568710, "subscriptionId", newJString(subscriptionId))
  add(path_568710, "schemaName", newJString(schemaName))
  result = call_568709.call(path_568710, query_568711, nil, nil, nil)

var integrationAccountSchemasGet* = Call_IntegrationAccountSchemasGet_568700(
    name: "integrationAccountSchemasGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_IntegrationAccountSchemasGet_568701, base: "",
    url: url_IntegrationAccountSchemasGet_568702, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasDelete_568726 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountSchemasDelete_568728(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountSchemasDelete_568727(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_568732 = path.getOrDefault("schemaName")
  valid_568732 = validateParameter(valid_568732, JString, required = true,
                                 default = nil)
  if valid_568732 != nil:
    section.add "schemaName", valid_568732
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

proc call*(call_568734: Call_IntegrationAccountSchemasDelete_568726;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account schema.
  ## 
  let valid = call_568734.validator(path, query, header, formData, body)
  let scheme = call_568734.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568734.url(scheme.get, call_568734.host, call_568734.base,
                         call_568734.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568734, url, valid)

proc call*(call_568735: Call_IntegrationAccountSchemasDelete_568726;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; schemaName: string): Recallable =
  ## integrationAccountSchemasDelete
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
  var path_568736 = newJObject()
  var query_568737 = newJObject()
  add(path_568736, "resourceGroupName", newJString(resourceGroupName))
  add(query_568737, "api-version", newJString(apiVersion))
  add(path_568736, "integrationAccountName", newJString(integrationAccountName))
  add(path_568736, "subscriptionId", newJString(subscriptionId))
  add(path_568736, "schemaName", newJString(schemaName))
  result = call_568735.call(path_568736, query_568737, nil, nil, nil)

var integrationAccountSchemasDelete* = Call_IntegrationAccountSchemasDelete_568726(
    name: "integrationAccountSchemasDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_IntegrationAccountSchemasDelete_568727, base: "",
    url: url_IntegrationAccountSchemasDelete_568728, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasListContentCallbackUrl_568738 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountSchemasListContentCallbackUrl_568740(protocol: Scheme;
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

proc validate_IntegrationAccountSchemasListContentCallbackUrl_568739(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
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
  var valid_568744 = path.getOrDefault("schemaName")
  valid_568744 = validateParameter(valid_568744, JString, required = true,
                                 default = nil)
  if valid_568744 != nil:
    section.add "schemaName", valid_568744
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568745 = query.getOrDefault("api-version")
  valid_568745 = validateParameter(valid_568745, JString, required = true,
                                 default = nil)
  if valid_568745 != nil:
    section.add "api-version", valid_568745
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

proc call*(call_568747: Call_IntegrationAccountSchemasListContentCallbackUrl_568738;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_568747.validator(path, query, header, formData, body)
  let scheme = call_568747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568747.url(scheme.get, call_568747.host, call_568747.base,
                         call_568747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568747, url, valid)

proc call*(call_568748: Call_IntegrationAccountSchemasListContentCallbackUrl_568738;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          schemaName: string; listContentCallbackUrl: JsonNode): Recallable =
  ## integrationAccountSchemasListContentCallbackUrl
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
  var path_568749 = newJObject()
  var query_568750 = newJObject()
  var body_568751 = newJObject()
  add(path_568749, "resourceGroupName", newJString(resourceGroupName))
  add(query_568750, "api-version", newJString(apiVersion))
  add(path_568749, "integrationAccountName", newJString(integrationAccountName))
  add(path_568749, "subscriptionId", newJString(subscriptionId))
  add(path_568749, "schemaName", newJString(schemaName))
  if listContentCallbackUrl != nil:
    body_568751 = listContentCallbackUrl
  result = call_568748.call(path_568749, query_568750, nil, nil, body_568751)

var integrationAccountSchemasListContentCallbackUrl* = Call_IntegrationAccountSchemasListContentCallbackUrl_568738(
    name: "integrationAccountSchemasListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountSchemasListContentCallbackUrl_568739,
    base: "", url: url_IntegrationAccountSchemasListContentCallbackUrl_568740,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountSessionsList_568752 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountSessionsList_568754(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountSessionsList_568753(path: JsonNode;
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
  var valid_568755 = path.getOrDefault("resourceGroupName")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = nil)
  if valid_568755 != nil:
    section.add "resourceGroupName", valid_568755
  var valid_568756 = path.getOrDefault("integrationAccountName")
  valid_568756 = validateParameter(valid_568756, JString, required = true,
                                 default = nil)
  if valid_568756 != nil:
    section.add "integrationAccountName", valid_568756
  var valid_568757 = path.getOrDefault("subscriptionId")
  valid_568757 = validateParameter(valid_568757, JString, required = true,
                                 default = nil)
  if valid_568757 != nil:
    section.add "subscriptionId", valid_568757
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
  var valid_568758 = query.getOrDefault("api-version")
  valid_568758 = validateParameter(valid_568758, JString, required = true,
                                 default = nil)
  if valid_568758 != nil:
    section.add "api-version", valid_568758
  var valid_568759 = query.getOrDefault("$top")
  valid_568759 = validateParameter(valid_568759, JInt, required = false, default = nil)
  if valid_568759 != nil:
    section.add "$top", valid_568759
  var valid_568760 = query.getOrDefault("$filter")
  valid_568760 = validateParameter(valid_568760, JString, required = false,
                                 default = nil)
  if valid_568760 != nil:
    section.add "$filter", valid_568760
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568761: Call_IntegrationAccountSessionsList_568752; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account sessions.
  ## 
  let valid = call_568761.validator(path, query, header, formData, body)
  let scheme = call_568761.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568761.url(scheme.get, call_568761.host, call_568761.base,
                         call_568761.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568761, url, valid)

proc call*(call_568762: Call_IntegrationAccountSessionsList_568752;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## integrationAccountSessionsList
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
  var path_568763 = newJObject()
  var query_568764 = newJObject()
  add(path_568763, "resourceGroupName", newJString(resourceGroupName))
  add(query_568764, "api-version", newJString(apiVersion))
  add(path_568763, "integrationAccountName", newJString(integrationAccountName))
  add(path_568763, "subscriptionId", newJString(subscriptionId))
  add(query_568764, "$top", newJInt(Top))
  add(query_568764, "$filter", newJString(Filter))
  result = call_568762.call(path_568763, query_568764, nil, nil, nil)

var integrationAccountSessionsList* = Call_IntegrationAccountSessionsList_568752(
    name: "integrationAccountSessionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions",
    validator: validate_IntegrationAccountSessionsList_568753, base: "",
    url: url_IntegrationAccountSessionsList_568754, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSessionsCreateOrUpdate_568777 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountSessionsCreateOrUpdate_568779(protocol: Scheme;
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

proc validate_IntegrationAccountSessionsCreateOrUpdate_568778(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_568780 = path.getOrDefault("resourceGroupName")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "resourceGroupName", valid_568780
  var valid_568781 = path.getOrDefault("sessionName")
  valid_568781 = validateParameter(valid_568781, JString, required = true,
                                 default = nil)
  if valid_568781 != nil:
    section.add "sessionName", valid_568781
  var valid_568782 = path.getOrDefault("integrationAccountName")
  valid_568782 = validateParameter(valid_568782, JString, required = true,
                                 default = nil)
  if valid_568782 != nil:
    section.add "integrationAccountName", valid_568782
  var valid_568783 = path.getOrDefault("subscriptionId")
  valid_568783 = validateParameter(valid_568783, JString, required = true,
                                 default = nil)
  if valid_568783 != nil:
    section.add "subscriptionId", valid_568783
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
  ## parameters in `body` object:
  ##   session: JObject (required)
  ##          : The integration account session.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568786: Call_IntegrationAccountSessionsCreateOrUpdate_568777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account session.
  ## 
  let valid = call_568786.validator(path, query, header, formData, body)
  let scheme = call_568786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568786.url(scheme.get, call_568786.host, call_568786.base,
                         call_568786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568786, url, valid)

proc call*(call_568787: Call_IntegrationAccountSessionsCreateOrUpdate_568777;
          resourceGroupName: string; apiVersion: string; sessionName: string;
          integrationAccountName: string; subscriptionId: string; session: JsonNode): Recallable =
  ## integrationAccountSessionsCreateOrUpdate
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
  var path_568788 = newJObject()
  var query_568789 = newJObject()
  var body_568790 = newJObject()
  add(path_568788, "resourceGroupName", newJString(resourceGroupName))
  add(query_568789, "api-version", newJString(apiVersion))
  add(path_568788, "sessionName", newJString(sessionName))
  add(path_568788, "integrationAccountName", newJString(integrationAccountName))
  add(path_568788, "subscriptionId", newJString(subscriptionId))
  if session != nil:
    body_568790 = session
  result = call_568787.call(path_568788, query_568789, nil, nil, body_568790)

var integrationAccountSessionsCreateOrUpdate* = Call_IntegrationAccountSessionsCreateOrUpdate_568777(
    name: "integrationAccountSessionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
    validator: validate_IntegrationAccountSessionsCreateOrUpdate_568778, base: "",
    url: url_IntegrationAccountSessionsCreateOrUpdate_568779,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountSessionsGet_568765 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountSessionsGet_568767(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountSessionsGet_568766(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_568768 = path.getOrDefault("resourceGroupName")
  valid_568768 = validateParameter(valid_568768, JString, required = true,
                                 default = nil)
  if valid_568768 != nil:
    section.add "resourceGroupName", valid_568768
  var valid_568769 = path.getOrDefault("sessionName")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "sessionName", valid_568769
  var valid_568770 = path.getOrDefault("integrationAccountName")
  valid_568770 = validateParameter(valid_568770, JString, required = true,
                                 default = nil)
  if valid_568770 != nil:
    section.add "integrationAccountName", valid_568770
  var valid_568771 = path.getOrDefault("subscriptionId")
  valid_568771 = validateParameter(valid_568771, JString, required = true,
                                 default = nil)
  if valid_568771 != nil:
    section.add "subscriptionId", valid_568771
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568772 = query.getOrDefault("api-version")
  valid_568772 = validateParameter(valid_568772, JString, required = true,
                                 default = nil)
  if valid_568772 != nil:
    section.add "api-version", valid_568772
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568773: Call_IntegrationAccountSessionsGet_568765; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account session.
  ## 
  let valid = call_568773.validator(path, query, header, formData, body)
  let scheme = call_568773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568773.url(scheme.get, call_568773.host, call_568773.base,
                         call_568773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568773, url, valid)

proc call*(call_568774: Call_IntegrationAccountSessionsGet_568765;
          resourceGroupName: string; apiVersion: string; sessionName: string;
          integrationAccountName: string; subscriptionId: string): Recallable =
  ## integrationAccountSessionsGet
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
  var path_568775 = newJObject()
  var query_568776 = newJObject()
  add(path_568775, "resourceGroupName", newJString(resourceGroupName))
  add(query_568776, "api-version", newJString(apiVersion))
  add(path_568775, "sessionName", newJString(sessionName))
  add(path_568775, "integrationAccountName", newJString(integrationAccountName))
  add(path_568775, "subscriptionId", newJString(subscriptionId))
  result = call_568774.call(path_568775, query_568776, nil, nil, nil)

var integrationAccountSessionsGet* = Call_IntegrationAccountSessionsGet_568765(
    name: "integrationAccountSessionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
    validator: validate_IntegrationAccountSessionsGet_568766, base: "",
    url: url_IntegrationAccountSessionsGet_568767, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSessionsDelete_568791 = ref object of OpenApiRestCall_567667
proc url_IntegrationAccountSessionsDelete_568793(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountSessionsDelete_568792(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_568794 = path.getOrDefault("resourceGroupName")
  valid_568794 = validateParameter(valid_568794, JString, required = true,
                                 default = nil)
  if valid_568794 != nil:
    section.add "resourceGroupName", valid_568794
  var valid_568795 = path.getOrDefault("sessionName")
  valid_568795 = validateParameter(valid_568795, JString, required = true,
                                 default = nil)
  if valid_568795 != nil:
    section.add "sessionName", valid_568795
  var valid_568796 = path.getOrDefault("integrationAccountName")
  valid_568796 = validateParameter(valid_568796, JString, required = true,
                                 default = nil)
  if valid_568796 != nil:
    section.add "integrationAccountName", valid_568796
  var valid_568797 = path.getOrDefault("subscriptionId")
  valid_568797 = validateParameter(valid_568797, JString, required = true,
                                 default = nil)
  if valid_568797 != nil:
    section.add "subscriptionId", valid_568797
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568798 = query.getOrDefault("api-version")
  valid_568798 = validateParameter(valid_568798, JString, required = true,
                                 default = nil)
  if valid_568798 != nil:
    section.add "api-version", valid_568798
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568799: Call_IntegrationAccountSessionsDelete_568791;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account session.
  ## 
  let valid = call_568799.validator(path, query, header, formData, body)
  let scheme = call_568799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568799.url(scheme.get, call_568799.host, call_568799.base,
                         call_568799.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568799, url, valid)

proc call*(call_568800: Call_IntegrationAccountSessionsDelete_568791;
          resourceGroupName: string; apiVersion: string; sessionName: string;
          integrationAccountName: string; subscriptionId: string): Recallable =
  ## integrationAccountSessionsDelete
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
  var path_568801 = newJObject()
  var query_568802 = newJObject()
  add(path_568801, "resourceGroupName", newJString(resourceGroupName))
  add(query_568802, "api-version", newJString(apiVersion))
  add(path_568801, "sessionName", newJString(sessionName))
  add(path_568801, "integrationAccountName", newJString(integrationAccountName))
  add(path_568801, "subscriptionId", newJString(subscriptionId))
  result = call_568800.call(path_568801, query_568802, nil, nil, nil)

var integrationAccountSessionsDelete* = Call_IntegrationAccountSessionsDelete_568791(
    name: "integrationAccountSessionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
    validator: validate_IntegrationAccountSessionsDelete_568792, base: "",
    url: url_IntegrationAccountSessionsDelete_568793, schemes: {Scheme.Https})
type
  Call_WorkflowsValidateByLocation_568803 = ref object of OpenApiRestCall_567667
proc url_WorkflowsValidateByLocation_568805(protocol: Scheme; host: string;
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

proc validate_WorkflowsValidateByLocation_568804(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_568806 = path.getOrDefault("workflowName")
  valid_568806 = validateParameter(valid_568806, JString, required = true,
                                 default = nil)
  if valid_568806 != nil:
    section.add "workflowName", valid_568806
  var valid_568807 = path.getOrDefault("resourceGroupName")
  valid_568807 = validateParameter(valid_568807, JString, required = true,
                                 default = nil)
  if valid_568807 != nil:
    section.add "resourceGroupName", valid_568807
  var valid_568808 = path.getOrDefault("subscriptionId")
  valid_568808 = validateParameter(valid_568808, JString, required = true,
                                 default = nil)
  if valid_568808 != nil:
    section.add "subscriptionId", valid_568808
  var valid_568809 = path.getOrDefault("location")
  valid_568809 = validateParameter(valid_568809, JString, required = true,
                                 default = nil)
  if valid_568809 != nil:
    section.add "location", valid_568809
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568810 = query.getOrDefault("api-version")
  valid_568810 = validateParameter(valid_568810, JString, required = true,
                                 default = nil)
  if valid_568810 != nil:
    section.add "api-version", valid_568810
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

proc call*(call_568812: Call_WorkflowsValidateByLocation_568803; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the workflow definition.
  ## 
  let valid = call_568812.validator(path, query, header, formData, body)
  let scheme = call_568812.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568812.url(scheme.get, call_568812.host, call_568812.base,
                         call_568812.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568812, url, valid)

proc call*(call_568813: Call_WorkflowsValidateByLocation_568803;
          workflowName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; workflow: JsonNode; location: string): Recallable =
  ## workflowsValidateByLocation
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
  var path_568814 = newJObject()
  var query_568815 = newJObject()
  var body_568816 = newJObject()
  add(path_568814, "workflowName", newJString(workflowName))
  add(path_568814, "resourceGroupName", newJString(resourceGroupName))
  add(query_568815, "api-version", newJString(apiVersion))
  add(path_568814, "subscriptionId", newJString(subscriptionId))
  if workflow != nil:
    body_568816 = workflow
  add(path_568814, "location", newJString(location))
  result = call_568813.call(path_568814, query_568815, nil, nil, body_568816)

var workflowsValidateByLocation* = Call_WorkflowsValidateByLocation_568803(
    name: "workflowsValidateByLocation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/locations/{location}/workflows/{workflowName}/validate",
    validator: validate_WorkflowsValidateByLocation_568804, base: "",
    url: url_WorkflowsValidateByLocation_568805, schemes: {Scheme.Https})
type
  Call_WorkflowsListByResourceGroup_568817 = ref object of OpenApiRestCall_567667
proc url_WorkflowsListByResourceGroup_568819(protocol: Scheme; host: string;
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

proc validate_WorkflowsListByResourceGroup_568818(path: JsonNode; query: JsonNode;
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
  var valid_568820 = path.getOrDefault("resourceGroupName")
  valid_568820 = validateParameter(valid_568820, JString, required = true,
                                 default = nil)
  if valid_568820 != nil:
    section.add "resourceGroupName", valid_568820
  var valid_568821 = path.getOrDefault("subscriptionId")
  valid_568821 = validateParameter(valid_568821, JString, required = true,
                                 default = nil)
  if valid_568821 != nil:
    section.add "subscriptionId", valid_568821
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
  var valid_568822 = query.getOrDefault("api-version")
  valid_568822 = validateParameter(valid_568822, JString, required = true,
                                 default = nil)
  if valid_568822 != nil:
    section.add "api-version", valid_568822
  var valid_568823 = query.getOrDefault("$top")
  valid_568823 = validateParameter(valid_568823, JInt, required = false, default = nil)
  if valid_568823 != nil:
    section.add "$top", valid_568823
  var valid_568824 = query.getOrDefault("$filter")
  valid_568824 = validateParameter(valid_568824, JString, required = false,
                                 default = nil)
  if valid_568824 != nil:
    section.add "$filter", valid_568824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568825: Call_WorkflowsListByResourceGroup_568817; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflows by resource group.
  ## 
  let valid = call_568825.validator(path, query, header, formData, body)
  let scheme = call_568825.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568825.url(scheme.get, call_568825.host, call_568825.base,
                         call_568825.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568825, url, valid)

proc call*(call_568826: Call_WorkflowsListByResourceGroup_568817;
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
  var path_568827 = newJObject()
  var query_568828 = newJObject()
  add(path_568827, "resourceGroupName", newJString(resourceGroupName))
  add(query_568828, "api-version", newJString(apiVersion))
  add(path_568827, "subscriptionId", newJString(subscriptionId))
  add(query_568828, "$top", newJInt(Top))
  add(query_568828, "$filter", newJString(Filter))
  result = call_568826.call(path_568827, query_568828, nil, nil, nil)

var workflowsListByResourceGroup* = Call_WorkflowsListByResourceGroup_568817(
    name: "workflowsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows",
    validator: validate_WorkflowsListByResourceGroup_568818, base: "",
    url: url_WorkflowsListByResourceGroup_568819, schemes: {Scheme.Https})
type
  Call_WorkflowsCreateOrUpdate_568840 = ref object of OpenApiRestCall_567667
proc url_WorkflowsCreateOrUpdate_568842(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsCreateOrUpdate_568841(path: JsonNode; query: JsonNode;
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
  var valid_568843 = path.getOrDefault("workflowName")
  valid_568843 = validateParameter(valid_568843, JString, required = true,
                                 default = nil)
  if valid_568843 != nil:
    section.add "workflowName", valid_568843
  var valid_568844 = path.getOrDefault("resourceGroupName")
  valid_568844 = validateParameter(valid_568844, JString, required = true,
                                 default = nil)
  if valid_568844 != nil:
    section.add "resourceGroupName", valid_568844
  var valid_568845 = path.getOrDefault("subscriptionId")
  valid_568845 = validateParameter(valid_568845, JString, required = true,
                                 default = nil)
  if valid_568845 != nil:
    section.add "subscriptionId", valid_568845
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568846 = query.getOrDefault("api-version")
  valid_568846 = validateParameter(valid_568846, JString, required = true,
                                 default = nil)
  if valid_568846 != nil:
    section.add "api-version", valid_568846
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

proc call*(call_568848: Call_WorkflowsCreateOrUpdate_568840; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a workflow.
  ## 
  let valid = call_568848.validator(path, query, header, formData, body)
  let scheme = call_568848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568848.url(scheme.get, call_568848.host, call_568848.base,
                         call_568848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568848, url, valid)

proc call*(call_568849: Call_WorkflowsCreateOrUpdate_568840; workflowName: string;
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
  var path_568850 = newJObject()
  var query_568851 = newJObject()
  var body_568852 = newJObject()
  add(path_568850, "workflowName", newJString(workflowName))
  add(path_568850, "resourceGroupName", newJString(resourceGroupName))
  add(query_568851, "api-version", newJString(apiVersion))
  add(path_568850, "subscriptionId", newJString(subscriptionId))
  if workflow != nil:
    body_568852 = workflow
  result = call_568849.call(path_568850, query_568851, nil, nil, body_568852)

var workflowsCreateOrUpdate* = Call_WorkflowsCreateOrUpdate_568840(
    name: "workflowsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsCreateOrUpdate_568841, base: "",
    url: url_WorkflowsCreateOrUpdate_568842, schemes: {Scheme.Https})
type
  Call_WorkflowsGet_568829 = ref object of OpenApiRestCall_567667
proc url_WorkflowsGet_568831(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsGet_568830(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568832 = path.getOrDefault("workflowName")
  valid_568832 = validateParameter(valid_568832, JString, required = true,
                                 default = nil)
  if valid_568832 != nil:
    section.add "workflowName", valid_568832
  var valid_568833 = path.getOrDefault("resourceGroupName")
  valid_568833 = validateParameter(valid_568833, JString, required = true,
                                 default = nil)
  if valid_568833 != nil:
    section.add "resourceGroupName", valid_568833
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
  if body != nil:
    result.add "body", body

proc call*(call_568836: Call_WorkflowsGet_568829; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow.
  ## 
  let valid = call_568836.validator(path, query, header, formData, body)
  let scheme = call_568836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568836.url(scheme.get, call_568836.host, call_568836.base,
                         call_568836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568836, url, valid)

proc call*(call_568837: Call_WorkflowsGet_568829; workflowName: string;
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
  var path_568838 = newJObject()
  var query_568839 = newJObject()
  add(path_568838, "workflowName", newJString(workflowName))
  add(path_568838, "resourceGroupName", newJString(resourceGroupName))
  add(query_568839, "api-version", newJString(apiVersion))
  add(path_568838, "subscriptionId", newJString(subscriptionId))
  result = call_568837.call(path_568838, query_568839, nil, nil, nil)

var workflowsGet* = Call_WorkflowsGet_568829(name: "workflowsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsGet_568830, base: "", url: url_WorkflowsGet_568831,
    schemes: {Scheme.Https})
type
  Call_WorkflowsUpdate_568864 = ref object of OpenApiRestCall_567667
proc url_WorkflowsUpdate_568866(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsUpdate_568865(path: JsonNode; query: JsonNode;
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
  var valid_568867 = path.getOrDefault("workflowName")
  valid_568867 = validateParameter(valid_568867, JString, required = true,
                                 default = nil)
  if valid_568867 != nil:
    section.add "workflowName", valid_568867
  var valid_568868 = path.getOrDefault("resourceGroupName")
  valid_568868 = validateParameter(valid_568868, JString, required = true,
                                 default = nil)
  if valid_568868 != nil:
    section.add "resourceGroupName", valid_568868
  var valid_568869 = path.getOrDefault("subscriptionId")
  valid_568869 = validateParameter(valid_568869, JString, required = true,
                                 default = nil)
  if valid_568869 != nil:
    section.add "subscriptionId", valid_568869
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568870 = query.getOrDefault("api-version")
  valid_568870 = validateParameter(valid_568870, JString, required = true,
                                 default = nil)
  if valid_568870 != nil:
    section.add "api-version", valid_568870
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

proc call*(call_568872: Call_WorkflowsUpdate_568864; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a workflow.
  ## 
  let valid = call_568872.validator(path, query, header, formData, body)
  let scheme = call_568872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568872.url(scheme.get, call_568872.host, call_568872.base,
                         call_568872.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568872, url, valid)

proc call*(call_568873: Call_WorkflowsUpdate_568864; workflowName: string;
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
  var path_568874 = newJObject()
  var query_568875 = newJObject()
  var body_568876 = newJObject()
  add(path_568874, "workflowName", newJString(workflowName))
  add(path_568874, "resourceGroupName", newJString(resourceGroupName))
  add(query_568875, "api-version", newJString(apiVersion))
  add(path_568874, "subscriptionId", newJString(subscriptionId))
  if workflow != nil:
    body_568876 = workflow
  result = call_568873.call(path_568874, query_568875, nil, nil, body_568876)

var workflowsUpdate* = Call_WorkflowsUpdate_568864(name: "workflowsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsUpdate_568865, base: "", url: url_WorkflowsUpdate_568866,
    schemes: {Scheme.Https})
type
  Call_WorkflowsDelete_568853 = ref object of OpenApiRestCall_567667
proc url_WorkflowsDelete_568855(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsDelete_568854(path: JsonNode; query: JsonNode;
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
  var valid_568856 = path.getOrDefault("workflowName")
  valid_568856 = validateParameter(valid_568856, JString, required = true,
                                 default = nil)
  if valid_568856 != nil:
    section.add "workflowName", valid_568856
  var valid_568857 = path.getOrDefault("resourceGroupName")
  valid_568857 = validateParameter(valid_568857, JString, required = true,
                                 default = nil)
  if valid_568857 != nil:
    section.add "resourceGroupName", valid_568857
  var valid_568858 = path.getOrDefault("subscriptionId")
  valid_568858 = validateParameter(valid_568858, JString, required = true,
                                 default = nil)
  if valid_568858 != nil:
    section.add "subscriptionId", valid_568858
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568859 = query.getOrDefault("api-version")
  valid_568859 = validateParameter(valid_568859, JString, required = true,
                                 default = nil)
  if valid_568859 != nil:
    section.add "api-version", valid_568859
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568860: Call_WorkflowsDelete_568853; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a workflow.
  ## 
  let valid = call_568860.validator(path, query, header, formData, body)
  let scheme = call_568860.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568860.url(scheme.get, call_568860.host, call_568860.base,
                         call_568860.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568860, url, valid)

proc call*(call_568861: Call_WorkflowsDelete_568853; workflowName: string;
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
  var path_568862 = newJObject()
  var query_568863 = newJObject()
  add(path_568862, "workflowName", newJString(workflowName))
  add(path_568862, "resourceGroupName", newJString(resourceGroupName))
  add(query_568863, "api-version", newJString(apiVersion))
  add(path_568862, "subscriptionId", newJString(subscriptionId))
  result = call_568861.call(path_568862, query_568863, nil, nil, nil)

var workflowsDelete* = Call_WorkflowsDelete_568853(name: "workflowsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsDelete_568854, base: "", url: url_WorkflowsDelete_568855,
    schemes: {Scheme.Https})
type
  Call_WorkflowsDisable_568877 = ref object of OpenApiRestCall_567667
proc url_WorkflowsDisable_568879(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsDisable_568878(path: JsonNode; query: JsonNode;
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
  var valid_568880 = path.getOrDefault("workflowName")
  valid_568880 = validateParameter(valid_568880, JString, required = true,
                                 default = nil)
  if valid_568880 != nil:
    section.add "workflowName", valid_568880
  var valid_568881 = path.getOrDefault("resourceGroupName")
  valid_568881 = validateParameter(valid_568881, JString, required = true,
                                 default = nil)
  if valid_568881 != nil:
    section.add "resourceGroupName", valid_568881
  var valid_568882 = path.getOrDefault("subscriptionId")
  valid_568882 = validateParameter(valid_568882, JString, required = true,
                                 default = nil)
  if valid_568882 != nil:
    section.add "subscriptionId", valid_568882
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568883 = query.getOrDefault("api-version")
  valid_568883 = validateParameter(valid_568883, JString, required = true,
                                 default = nil)
  if valid_568883 != nil:
    section.add "api-version", valid_568883
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568884: Call_WorkflowsDisable_568877; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disables a workflow.
  ## 
  let valid = call_568884.validator(path, query, header, formData, body)
  let scheme = call_568884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568884.url(scheme.get, call_568884.host, call_568884.base,
                         call_568884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568884, url, valid)

proc call*(call_568885: Call_WorkflowsDisable_568877; workflowName: string;
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
  var path_568886 = newJObject()
  var query_568887 = newJObject()
  add(path_568886, "workflowName", newJString(workflowName))
  add(path_568886, "resourceGroupName", newJString(resourceGroupName))
  add(query_568887, "api-version", newJString(apiVersion))
  add(path_568886, "subscriptionId", newJString(subscriptionId))
  result = call_568885.call(path_568886, query_568887, nil, nil, nil)

var workflowsDisable* = Call_WorkflowsDisable_568877(name: "workflowsDisable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/disable",
    validator: validate_WorkflowsDisable_568878, base: "",
    url: url_WorkflowsDisable_568879, schemes: {Scheme.Https})
type
  Call_WorkflowsEnable_568888 = ref object of OpenApiRestCall_567667
proc url_WorkflowsEnable_568890(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsEnable_568889(path: JsonNode; query: JsonNode;
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
  var valid_568891 = path.getOrDefault("workflowName")
  valid_568891 = validateParameter(valid_568891, JString, required = true,
                                 default = nil)
  if valid_568891 != nil:
    section.add "workflowName", valid_568891
  var valid_568892 = path.getOrDefault("resourceGroupName")
  valid_568892 = validateParameter(valid_568892, JString, required = true,
                                 default = nil)
  if valid_568892 != nil:
    section.add "resourceGroupName", valid_568892
  var valid_568893 = path.getOrDefault("subscriptionId")
  valid_568893 = validateParameter(valid_568893, JString, required = true,
                                 default = nil)
  if valid_568893 != nil:
    section.add "subscriptionId", valid_568893
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568894 = query.getOrDefault("api-version")
  valid_568894 = validateParameter(valid_568894, JString, required = true,
                                 default = nil)
  if valid_568894 != nil:
    section.add "api-version", valid_568894
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568895: Call_WorkflowsEnable_568888; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables a workflow.
  ## 
  let valid = call_568895.validator(path, query, header, formData, body)
  let scheme = call_568895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568895.url(scheme.get, call_568895.host, call_568895.base,
                         call_568895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568895, url, valid)

proc call*(call_568896: Call_WorkflowsEnable_568888; workflowName: string;
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
  var path_568897 = newJObject()
  var query_568898 = newJObject()
  add(path_568897, "workflowName", newJString(workflowName))
  add(path_568897, "resourceGroupName", newJString(resourceGroupName))
  add(query_568898, "api-version", newJString(apiVersion))
  add(path_568897, "subscriptionId", newJString(subscriptionId))
  result = call_568896.call(path_568897, query_568898, nil, nil, nil)

var workflowsEnable* = Call_WorkflowsEnable_568888(name: "workflowsEnable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/enable",
    validator: validate_WorkflowsEnable_568889, base: "", url: url_WorkflowsEnable_568890,
    schemes: {Scheme.Https})
type
  Call_WorkflowsGenerateUpgradedDefinition_568899 = ref object of OpenApiRestCall_567667
proc url_WorkflowsGenerateUpgradedDefinition_568901(protocol: Scheme; host: string;
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

proc validate_WorkflowsGenerateUpgradedDefinition_568900(path: JsonNode;
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
  var valid_568902 = path.getOrDefault("workflowName")
  valid_568902 = validateParameter(valid_568902, JString, required = true,
                                 default = nil)
  if valid_568902 != nil:
    section.add "workflowName", valid_568902
  var valid_568903 = path.getOrDefault("resourceGroupName")
  valid_568903 = validateParameter(valid_568903, JString, required = true,
                                 default = nil)
  if valid_568903 != nil:
    section.add "resourceGroupName", valid_568903
  var valid_568904 = path.getOrDefault("subscriptionId")
  valid_568904 = validateParameter(valid_568904, JString, required = true,
                                 default = nil)
  if valid_568904 != nil:
    section.add "subscriptionId", valid_568904
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568905 = query.getOrDefault("api-version")
  valid_568905 = validateParameter(valid_568905, JString, required = true,
                                 default = nil)
  if valid_568905 != nil:
    section.add "api-version", valid_568905
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

proc call*(call_568907: Call_WorkflowsGenerateUpgradedDefinition_568899;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates the upgraded definition for a workflow.
  ## 
  let valid = call_568907.validator(path, query, header, formData, body)
  let scheme = call_568907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568907.url(scheme.get, call_568907.host, call_568907.base,
                         call_568907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568907, url, valid)

proc call*(call_568908: Call_WorkflowsGenerateUpgradedDefinition_568899;
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
  var path_568909 = newJObject()
  var query_568910 = newJObject()
  var body_568911 = newJObject()
  add(path_568909, "workflowName", newJString(workflowName))
  add(path_568909, "resourceGroupName", newJString(resourceGroupName))
  add(query_568910, "api-version", newJString(apiVersion))
  add(path_568909, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568911 = parameters
  result = call_568908.call(path_568909, query_568910, nil, nil, body_568911)

var workflowsGenerateUpgradedDefinition* = Call_WorkflowsGenerateUpgradedDefinition_568899(
    name: "workflowsGenerateUpgradedDefinition", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/generateUpgradedDefinition",
    validator: validate_WorkflowsGenerateUpgradedDefinition_568900, base: "",
    url: url_WorkflowsGenerateUpgradedDefinition_568901, schemes: {Scheme.Https})
type
  Call_WorkflowsListCallbackUrl_568912 = ref object of OpenApiRestCall_567667
proc url_WorkflowsListCallbackUrl_568914(protocol: Scheme; host: string;
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

proc validate_WorkflowsListCallbackUrl_568913(path: JsonNode; query: JsonNode;
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
  var valid_568915 = path.getOrDefault("workflowName")
  valid_568915 = validateParameter(valid_568915, JString, required = true,
                                 default = nil)
  if valid_568915 != nil:
    section.add "workflowName", valid_568915
  var valid_568916 = path.getOrDefault("resourceGroupName")
  valid_568916 = validateParameter(valid_568916, JString, required = true,
                                 default = nil)
  if valid_568916 != nil:
    section.add "resourceGroupName", valid_568916
  var valid_568917 = path.getOrDefault("subscriptionId")
  valid_568917 = validateParameter(valid_568917, JString, required = true,
                                 default = nil)
  if valid_568917 != nil:
    section.add "subscriptionId", valid_568917
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568918 = query.getOrDefault("api-version")
  valid_568918 = validateParameter(valid_568918, JString, required = true,
                                 default = nil)
  if valid_568918 != nil:
    section.add "api-version", valid_568918
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

proc call*(call_568920: Call_WorkflowsListCallbackUrl_568912; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the workflow callback Url.
  ## 
  let valid = call_568920.validator(path, query, header, formData, body)
  let scheme = call_568920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568920.url(scheme.get, call_568920.host, call_568920.base,
                         call_568920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568920, url, valid)

proc call*(call_568921: Call_WorkflowsListCallbackUrl_568912; workflowName: string;
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
  var path_568922 = newJObject()
  var query_568923 = newJObject()
  var body_568924 = newJObject()
  add(path_568922, "workflowName", newJString(workflowName))
  add(path_568922, "resourceGroupName", newJString(resourceGroupName))
  add(query_568923, "api-version", newJString(apiVersion))
  if listCallbackUrl != nil:
    body_568924 = listCallbackUrl
  add(path_568922, "subscriptionId", newJString(subscriptionId))
  result = call_568921.call(path_568922, query_568923, nil, nil, body_568924)

var workflowsListCallbackUrl* = Call_WorkflowsListCallbackUrl_568912(
    name: "workflowsListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/listCallbackUrl",
    validator: validate_WorkflowsListCallbackUrl_568913, base: "",
    url: url_WorkflowsListCallbackUrl_568914, schemes: {Scheme.Https})
type
  Call_WorkflowsListSwagger_568925 = ref object of OpenApiRestCall_567667
proc url_WorkflowsListSwagger_568927(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsListSwagger_568926(path: JsonNode; query: JsonNode;
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
  var valid_568928 = path.getOrDefault("workflowName")
  valid_568928 = validateParameter(valid_568928, JString, required = true,
                                 default = nil)
  if valid_568928 != nil:
    section.add "workflowName", valid_568928
  var valid_568929 = path.getOrDefault("resourceGroupName")
  valid_568929 = validateParameter(valid_568929, JString, required = true,
                                 default = nil)
  if valid_568929 != nil:
    section.add "resourceGroupName", valid_568929
  var valid_568930 = path.getOrDefault("subscriptionId")
  valid_568930 = validateParameter(valid_568930, JString, required = true,
                                 default = nil)
  if valid_568930 != nil:
    section.add "subscriptionId", valid_568930
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568931 = query.getOrDefault("api-version")
  valid_568931 = validateParameter(valid_568931, JString, required = true,
                                 default = nil)
  if valid_568931 != nil:
    section.add "api-version", valid_568931
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568932: Call_WorkflowsListSwagger_568925; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an OpenAPI definition for the workflow.
  ## 
  let valid = call_568932.validator(path, query, header, formData, body)
  let scheme = call_568932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568932.url(scheme.get, call_568932.host, call_568932.base,
                         call_568932.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568932, url, valid)

proc call*(call_568933: Call_WorkflowsListSwagger_568925; workflowName: string;
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
  var path_568934 = newJObject()
  var query_568935 = newJObject()
  add(path_568934, "workflowName", newJString(workflowName))
  add(path_568934, "resourceGroupName", newJString(resourceGroupName))
  add(query_568935, "api-version", newJString(apiVersion))
  add(path_568934, "subscriptionId", newJString(subscriptionId))
  result = call_568933.call(path_568934, query_568935, nil, nil, nil)

var workflowsListSwagger* = Call_WorkflowsListSwagger_568925(
    name: "workflowsListSwagger", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/listSwagger",
    validator: validate_WorkflowsListSwagger_568926, base: "",
    url: url_WorkflowsListSwagger_568927, schemes: {Scheme.Https})
type
  Call_WorkflowsMove_568936 = ref object of OpenApiRestCall_567667
proc url_WorkflowsMove_568938(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsMove_568937(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568939 = path.getOrDefault("workflowName")
  valid_568939 = validateParameter(valid_568939, JString, required = true,
                                 default = nil)
  if valid_568939 != nil:
    section.add "workflowName", valid_568939
  var valid_568940 = path.getOrDefault("resourceGroupName")
  valid_568940 = validateParameter(valid_568940, JString, required = true,
                                 default = nil)
  if valid_568940 != nil:
    section.add "resourceGroupName", valid_568940
  var valid_568941 = path.getOrDefault("subscriptionId")
  valid_568941 = validateParameter(valid_568941, JString, required = true,
                                 default = nil)
  if valid_568941 != nil:
    section.add "subscriptionId", valid_568941
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568942 = query.getOrDefault("api-version")
  valid_568942 = validateParameter(valid_568942, JString, required = true,
                                 default = nil)
  if valid_568942 != nil:
    section.add "api-version", valid_568942
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

proc call*(call_568944: Call_WorkflowsMove_568936; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves an existing workflow.
  ## 
  let valid = call_568944.validator(path, query, header, formData, body)
  let scheme = call_568944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568944.url(scheme.get, call_568944.host, call_568944.base,
                         call_568944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568944, url, valid)

proc call*(call_568945: Call_WorkflowsMove_568936; workflowName: string;
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
  var path_568946 = newJObject()
  var query_568947 = newJObject()
  var body_568948 = newJObject()
  add(path_568946, "workflowName", newJString(workflowName))
  if move != nil:
    body_568948 = move
  add(path_568946, "resourceGroupName", newJString(resourceGroupName))
  add(query_568947, "api-version", newJString(apiVersion))
  add(path_568946, "subscriptionId", newJString(subscriptionId))
  result = call_568945.call(path_568946, query_568947, nil, nil, body_568948)

var workflowsMove* = Call_WorkflowsMove_568936(name: "workflowsMove",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/move",
    validator: validate_WorkflowsMove_568937, base: "", url: url_WorkflowsMove_568938,
    schemes: {Scheme.Https})
type
  Call_WorkflowsRegenerateAccessKey_568949 = ref object of OpenApiRestCall_567667
proc url_WorkflowsRegenerateAccessKey_568951(protocol: Scheme; host: string;
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

proc validate_WorkflowsRegenerateAccessKey_568950(path: JsonNode; query: JsonNode;
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
  var valid_568952 = path.getOrDefault("workflowName")
  valid_568952 = validateParameter(valid_568952, JString, required = true,
                                 default = nil)
  if valid_568952 != nil:
    section.add "workflowName", valid_568952
  var valid_568953 = path.getOrDefault("resourceGroupName")
  valid_568953 = validateParameter(valid_568953, JString, required = true,
                                 default = nil)
  if valid_568953 != nil:
    section.add "resourceGroupName", valid_568953
  var valid_568954 = path.getOrDefault("subscriptionId")
  valid_568954 = validateParameter(valid_568954, JString, required = true,
                                 default = nil)
  if valid_568954 != nil:
    section.add "subscriptionId", valid_568954
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568955 = query.getOrDefault("api-version")
  valid_568955 = validateParameter(valid_568955, JString, required = true,
                                 default = nil)
  if valid_568955 != nil:
    section.add "api-version", valid_568955
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

proc call*(call_568957: Call_WorkflowsRegenerateAccessKey_568949; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the callback URL access key for request triggers.
  ## 
  let valid = call_568957.validator(path, query, header, formData, body)
  let scheme = call_568957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568957.url(scheme.get, call_568957.host, call_568957.base,
                         call_568957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568957, url, valid)

proc call*(call_568958: Call_WorkflowsRegenerateAccessKey_568949;
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
  var path_568959 = newJObject()
  var query_568960 = newJObject()
  var body_568961 = newJObject()
  add(path_568959, "workflowName", newJString(workflowName))
  add(path_568959, "resourceGroupName", newJString(resourceGroupName))
  add(query_568960, "api-version", newJString(apiVersion))
  add(path_568959, "subscriptionId", newJString(subscriptionId))
  if keyType != nil:
    body_568961 = keyType
  result = call_568958.call(path_568959, query_568960, nil, nil, body_568961)

var workflowsRegenerateAccessKey* = Call_WorkflowsRegenerateAccessKey_568949(
    name: "workflowsRegenerateAccessKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/regenerateAccessKey",
    validator: validate_WorkflowsRegenerateAccessKey_568950, base: "",
    url: url_WorkflowsRegenerateAccessKey_568951, schemes: {Scheme.Https})
type
  Call_WorkflowRunsList_568962 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunsList_568964(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsList_568963(path: JsonNode; query: JsonNode;
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
  var valid_568965 = path.getOrDefault("workflowName")
  valid_568965 = validateParameter(valid_568965, JString, required = true,
                                 default = nil)
  if valid_568965 != nil:
    section.add "workflowName", valid_568965
  var valid_568966 = path.getOrDefault("resourceGroupName")
  valid_568966 = validateParameter(valid_568966, JString, required = true,
                                 default = nil)
  if valid_568966 != nil:
    section.add "resourceGroupName", valid_568966
  var valid_568967 = path.getOrDefault("subscriptionId")
  valid_568967 = validateParameter(valid_568967, JString, required = true,
                                 default = nil)
  if valid_568967 != nil:
    section.add "subscriptionId", valid_568967
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
  var valid_568968 = query.getOrDefault("api-version")
  valid_568968 = validateParameter(valid_568968, JString, required = true,
                                 default = nil)
  if valid_568968 != nil:
    section.add "api-version", valid_568968
  var valid_568969 = query.getOrDefault("$top")
  valid_568969 = validateParameter(valid_568969, JInt, required = false, default = nil)
  if valid_568969 != nil:
    section.add "$top", valid_568969
  var valid_568970 = query.getOrDefault("$filter")
  valid_568970 = validateParameter(valid_568970, JString, required = false,
                                 default = nil)
  if valid_568970 != nil:
    section.add "$filter", valid_568970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568971: Call_WorkflowRunsList_568962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow runs.
  ## 
  let valid = call_568971.validator(path, query, header, formData, body)
  let scheme = call_568971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568971.url(scheme.get, call_568971.host, call_568971.base,
                         call_568971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568971, url, valid)

proc call*(call_568972: Call_WorkflowRunsList_568962; workflowName: string;
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
  var path_568973 = newJObject()
  var query_568974 = newJObject()
  add(path_568973, "workflowName", newJString(workflowName))
  add(path_568973, "resourceGroupName", newJString(resourceGroupName))
  add(query_568974, "api-version", newJString(apiVersion))
  add(path_568973, "subscriptionId", newJString(subscriptionId))
  add(query_568974, "$top", newJInt(Top))
  add(query_568974, "$filter", newJString(Filter))
  result = call_568972.call(path_568973, query_568974, nil, nil, nil)

var workflowRunsList* = Call_WorkflowRunsList_568962(name: "workflowRunsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs",
    validator: validate_WorkflowRunsList_568963, base: "",
    url: url_WorkflowRunsList_568964, schemes: {Scheme.Https})
type
  Call_WorkflowRunsGet_568975 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunsGet_568977(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsGet_568976(path: JsonNode; query: JsonNode;
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
  var valid_568978 = path.getOrDefault("workflowName")
  valid_568978 = validateParameter(valid_568978, JString, required = true,
                                 default = nil)
  if valid_568978 != nil:
    section.add "workflowName", valid_568978
  var valid_568979 = path.getOrDefault("resourceGroupName")
  valid_568979 = validateParameter(valid_568979, JString, required = true,
                                 default = nil)
  if valid_568979 != nil:
    section.add "resourceGroupName", valid_568979
  var valid_568980 = path.getOrDefault("runName")
  valid_568980 = validateParameter(valid_568980, JString, required = true,
                                 default = nil)
  if valid_568980 != nil:
    section.add "runName", valid_568980
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

proc call*(call_568983: Call_WorkflowRunsGet_568975; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow run.
  ## 
  let valid = call_568983.validator(path, query, header, formData, body)
  let scheme = call_568983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568983.url(scheme.get, call_568983.host, call_568983.base,
                         call_568983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568983, url, valid)

proc call*(call_568984: Call_WorkflowRunsGet_568975; workflowName: string;
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
  var path_568985 = newJObject()
  var query_568986 = newJObject()
  add(path_568985, "workflowName", newJString(workflowName))
  add(path_568985, "resourceGroupName", newJString(resourceGroupName))
  add(path_568985, "runName", newJString(runName))
  add(query_568986, "api-version", newJString(apiVersion))
  add(path_568985, "subscriptionId", newJString(subscriptionId))
  result = call_568984.call(path_568985, query_568986, nil, nil, nil)

var workflowRunsGet* = Call_WorkflowRunsGet_568975(name: "workflowRunsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}",
    validator: validate_WorkflowRunsGet_568976, base: "", url: url_WorkflowRunsGet_568977,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunsDelete_568987 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunsDelete_568989(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsDelete_568988(path: JsonNode; query: JsonNode;
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
  var valid_568992 = path.getOrDefault("runName")
  valid_568992 = validateParameter(valid_568992, JString, required = true,
                                 default = nil)
  if valid_568992 != nil:
    section.add "runName", valid_568992
  var valid_568993 = path.getOrDefault("subscriptionId")
  valid_568993 = validateParameter(valid_568993, JString, required = true,
                                 default = nil)
  if valid_568993 != nil:
    section.add "subscriptionId", valid_568993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568994 = query.getOrDefault("api-version")
  valid_568994 = validateParameter(valid_568994, JString, required = true,
                                 default = nil)
  if valid_568994 != nil:
    section.add "api-version", valid_568994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568995: Call_WorkflowRunsDelete_568987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a workflow run.
  ## 
  let valid = call_568995.validator(path, query, header, formData, body)
  let scheme = call_568995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568995.url(scheme.get, call_568995.host, call_568995.base,
                         call_568995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568995, url, valid)

proc call*(call_568996: Call_WorkflowRunsDelete_568987; workflowName: string;
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
  var path_568997 = newJObject()
  var query_568998 = newJObject()
  add(path_568997, "workflowName", newJString(workflowName))
  add(path_568997, "resourceGroupName", newJString(resourceGroupName))
  add(path_568997, "runName", newJString(runName))
  add(query_568998, "api-version", newJString(apiVersion))
  add(path_568997, "subscriptionId", newJString(subscriptionId))
  result = call_568996.call(path_568997, query_568998, nil, nil, nil)

var workflowRunsDelete* = Call_WorkflowRunsDelete_568987(
    name: "workflowRunsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}",
    validator: validate_WorkflowRunsDelete_568988, base: "",
    url: url_WorkflowRunsDelete_568989, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsList_568999 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionsList_569001(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunActionsList_569000(path: JsonNode; query: JsonNode;
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
  var valid_569002 = path.getOrDefault("workflowName")
  valid_569002 = validateParameter(valid_569002, JString, required = true,
                                 default = nil)
  if valid_569002 != nil:
    section.add "workflowName", valid_569002
  var valid_569003 = path.getOrDefault("resourceGroupName")
  valid_569003 = validateParameter(valid_569003, JString, required = true,
                                 default = nil)
  if valid_569003 != nil:
    section.add "resourceGroupName", valid_569003
  var valid_569004 = path.getOrDefault("runName")
  valid_569004 = validateParameter(valid_569004, JString, required = true,
                                 default = nil)
  if valid_569004 != nil:
    section.add "runName", valid_569004
  var valid_569005 = path.getOrDefault("subscriptionId")
  valid_569005 = validateParameter(valid_569005, JString, required = true,
                                 default = nil)
  if valid_569005 != nil:
    section.add "subscriptionId", valid_569005
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
  var valid_569006 = query.getOrDefault("api-version")
  valid_569006 = validateParameter(valid_569006, JString, required = true,
                                 default = nil)
  if valid_569006 != nil:
    section.add "api-version", valid_569006
  var valid_569007 = query.getOrDefault("$top")
  valid_569007 = validateParameter(valid_569007, JInt, required = false, default = nil)
  if valid_569007 != nil:
    section.add "$top", valid_569007
  var valid_569008 = query.getOrDefault("$filter")
  valid_569008 = validateParameter(valid_569008, JString, required = false,
                                 default = nil)
  if valid_569008 != nil:
    section.add "$filter", valid_569008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569009: Call_WorkflowRunActionsList_568999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow run actions.
  ## 
  let valid = call_569009.validator(path, query, header, formData, body)
  let scheme = call_569009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569009.url(scheme.get, call_569009.host, call_569009.base,
                         call_569009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569009, url, valid)

proc call*(call_569010: Call_WorkflowRunActionsList_568999; workflowName: string;
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
  var path_569011 = newJObject()
  var query_569012 = newJObject()
  add(path_569011, "workflowName", newJString(workflowName))
  add(path_569011, "resourceGroupName", newJString(resourceGroupName))
  add(path_569011, "runName", newJString(runName))
  add(query_569012, "api-version", newJString(apiVersion))
  add(path_569011, "subscriptionId", newJString(subscriptionId))
  add(query_569012, "$top", newJInt(Top))
  add(query_569012, "$filter", newJString(Filter))
  result = call_569010.call(path_569011, query_569012, nil, nil, nil)

var workflowRunActionsList* = Call_WorkflowRunActionsList_568999(
    name: "workflowRunActionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions",
    validator: validate_WorkflowRunActionsList_569000, base: "",
    url: url_WorkflowRunActionsList_569001, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsGet_569013 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionsGet_569015(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunActionsGet_569014(path: JsonNode; query: JsonNode;
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
  var valid_569016 = path.getOrDefault("workflowName")
  valid_569016 = validateParameter(valid_569016, JString, required = true,
                                 default = nil)
  if valid_569016 != nil:
    section.add "workflowName", valid_569016
  var valid_569017 = path.getOrDefault("actionName")
  valid_569017 = validateParameter(valid_569017, JString, required = true,
                                 default = nil)
  if valid_569017 != nil:
    section.add "actionName", valid_569017
  var valid_569018 = path.getOrDefault("resourceGroupName")
  valid_569018 = validateParameter(valid_569018, JString, required = true,
                                 default = nil)
  if valid_569018 != nil:
    section.add "resourceGroupName", valid_569018
  var valid_569019 = path.getOrDefault("runName")
  valid_569019 = validateParameter(valid_569019, JString, required = true,
                                 default = nil)
  if valid_569019 != nil:
    section.add "runName", valid_569019
  var valid_569020 = path.getOrDefault("subscriptionId")
  valid_569020 = validateParameter(valid_569020, JString, required = true,
                                 default = nil)
  if valid_569020 != nil:
    section.add "subscriptionId", valid_569020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569021 = query.getOrDefault("api-version")
  valid_569021 = validateParameter(valid_569021, JString, required = true,
                                 default = nil)
  if valid_569021 != nil:
    section.add "api-version", valid_569021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569022: Call_WorkflowRunActionsGet_569013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow run action.
  ## 
  let valid = call_569022.validator(path, query, header, formData, body)
  let scheme = call_569022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569022.url(scheme.get, call_569022.host, call_569022.base,
                         call_569022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569022, url, valid)

proc call*(call_569023: Call_WorkflowRunActionsGet_569013; workflowName: string;
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
  var path_569024 = newJObject()
  var query_569025 = newJObject()
  add(path_569024, "workflowName", newJString(workflowName))
  add(path_569024, "actionName", newJString(actionName))
  add(path_569024, "resourceGroupName", newJString(resourceGroupName))
  add(path_569024, "runName", newJString(runName))
  add(query_569025, "api-version", newJString(apiVersion))
  add(path_569024, "subscriptionId", newJString(subscriptionId))
  result = call_569023.call(path_569024, query_569025, nil, nil, nil)

var workflowRunActionsGet* = Call_WorkflowRunActionsGet_569013(
    name: "workflowRunActionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}",
    validator: validate_WorkflowRunActionsGet_569014, base: "",
    url: url_WorkflowRunActionsGet_569015, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsListExpressionTraces_569026 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionsListExpressionTraces_569028(protocol: Scheme;
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

proc validate_WorkflowRunActionsListExpressionTraces_569027(path: JsonNode;
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
  var valid_569029 = path.getOrDefault("workflowName")
  valid_569029 = validateParameter(valid_569029, JString, required = true,
                                 default = nil)
  if valid_569029 != nil:
    section.add "workflowName", valid_569029
  var valid_569030 = path.getOrDefault("actionName")
  valid_569030 = validateParameter(valid_569030, JString, required = true,
                                 default = nil)
  if valid_569030 != nil:
    section.add "actionName", valid_569030
  var valid_569031 = path.getOrDefault("resourceGroupName")
  valid_569031 = validateParameter(valid_569031, JString, required = true,
                                 default = nil)
  if valid_569031 != nil:
    section.add "resourceGroupName", valid_569031
  var valid_569032 = path.getOrDefault("runName")
  valid_569032 = validateParameter(valid_569032, JString, required = true,
                                 default = nil)
  if valid_569032 != nil:
    section.add "runName", valid_569032
  var valid_569033 = path.getOrDefault("subscriptionId")
  valid_569033 = validateParameter(valid_569033, JString, required = true,
                                 default = nil)
  if valid_569033 != nil:
    section.add "subscriptionId", valid_569033
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569034 = query.getOrDefault("api-version")
  valid_569034 = validateParameter(valid_569034, JString, required = true,
                                 default = nil)
  if valid_569034 != nil:
    section.add "api-version", valid_569034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569035: Call_WorkflowRunActionsListExpressionTraces_569026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a workflow run expression trace.
  ## 
  let valid = call_569035.validator(path, query, header, formData, body)
  let scheme = call_569035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569035.url(scheme.get, call_569035.host, call_569035.base,
                         call_569035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569035, url, valid)

proc call*(call_569036: Call_WorkflowRunActionsListExpressionTraces_569026;
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
  var path_569037 = newJObject()
  var query_569038 = newJObject()
  add(path_569037, "workflowName", newJString(workflowName))
  add(path_569037, "actionName", newJString(actionName))
  add(path_569037, "resourceGroupName", newJString(resourceGroupName))
  add(path_569037, "runName", newJString(runName))
  add(query_569038, "api-version", newJString(apiVersion))
  add(path_569037, "subscriptionId", newJString(subscriptionId))
  result = call_569036.call(path_569037, query_569038, nil, nil, nil)

var workflowRunActionsListExpressionTraces* = Call_WorkflowRunActionsListExpressionTraces_569026(
    name: "workflowRunActionsListExpressionTraces", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/listExpressionTraces",
    validator: validate_WorkflowRunActionsListExpressionTraces_569027, base: "",
    url: url_WorkflowRunActionsListExpressionTraces_569028,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsList_569039 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionRepetitionsList_569041(protocol: Scheme; host: string;
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

proc validate_WorkflowRunActionRepetitionsList_569040(path: JsonNode;
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
  var valid_569042 = path.getOrDefault("workflowName")
  valid_569042 = validateParameter(valid_569042, JString, required = true,
                                 default = nil)
  if valid_569042 != nil:
    section.add "workflowName", valid_569042
  var valid_569043 = path.getOrDefault("actionName")
  valid_569043 = validateParameter(valid_569043, JString, required = true,
                                 default = nil)
  if valid_569043 != nil:
    section.add "actionName", valid_569043
  var valid_569044 = path.getOrDefault("resourceGroupName")
  valid_569044 = validateParameter(valid_569044, JString, required = true,
                                 default = nil)
  if valid_569044 != nil:
    section.add "resourceGroupName", valid_569044
  var valid_569045 = path.getOrDefault("runName")
  valid_569045 = validateParameter(valid_569045, JString, required = true,
                                 default = nil)
  if valid_569045 != nil:
    section.add "runName", valid_569045
  var valid_569046 = path.getOrDefault("subscriptionId")
  valid_569046 = validateParameter(valid_569046, JString, required = true,
                                 default = nil)
  if valid_569046 != nil:
    section.add "subscriptionId", valid_569046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569047 = query.getOrDefault("api-version")
  valid_569047 = validateParameter(valid_569047, JString, required = true,
                                 default = nil)
  if valid_569047 != nil:
    section.add "api-version", valid_569047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569048: Call_WorkflowRunActionRepetitionsList_569039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all of a workflow run action repetitions.
  ## 
  let valid = call_569048.validator(path, query, header, formData, body)
  let scheme = call_569048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569048.url(scheme.get, call_569048.host, call_569048.base,
                         call_569048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569048, url, valid)

proc call*(call_569049: Call_WorkflowRunActionRepetitionsList_569039;
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
  var path_569050 = newJObject()
  var query_569051 = newJObject()
  add(path_569050, "workflowName", newJString(workflowName))
  add(path_569050, "actionName", newJString(actionName))
  add(path_569050, "resourceGroupName", newJString(resourceGroupName))
  add(path_569050, "runName", newJString(runName))
  add(query_569051, "api-version", newJString(apiVersion))
  add(path_569050, "subscriptionId", newJString(subscriptionId))
  result = call_569049.call(path_569050, query_569051, nil, nil, nil)

var workflowRunActionRepetitionsList* = Call_WorkflowRunActionRepetitionsList_569039(
    name: "workflowRunActionRepetitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions",
    validator: validate_WorkflowRunActionRepetitionsList_569040, base: "",
    url: url_WorkflowRunActionRepetitionsList_569041, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsGet_569052 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionRepetitionsGet_569054(protocol: Scheme; host: string;
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

proc validate_WorkflowRunActionRepetitionsGet_569053(path: JsonNode;
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
  var valid_569055 = path.getOrDefault("workflowName")
  valid_569055 = validateParameter(valid_569055, JString, required = true,
                                 default = nil)
  if valid_569055 != nil:
    section.add "workflowName", valid_569055
  var valid_569056 = path.getOrDefault("actionName")
  valid_569056 = validateParameter(valid_569056, JString, required = true,
                                 default = nil)
  if valid_569056 != nil:
    section.add "actionName", valid_569056
  var valid_569057 = path.getOrDefault("resourceGroupName")
  valid_569057 = validateParameter(valid_569057, JString, required = true,
                                 default = nil)
  if valid_569057 != nil:
    section.add "resourceGroupName", valid_569057
  var valid_569058 = path.getOrDefault("runName")
  valid_569058 = validateParameter(valid_569058, JString, required = true,
                                 default = nil)
  if valid_569058 != nil:
    section.add "runName", valid_569058
  var valid_569059 = path.getOrDefault("subscriptionId")
  valid_569059 = validateParameter(valid_569059, JString, required = true,
                                 default = nil)
  if valid_569059 != nil:
    section.add "subscriptionId", valid_569059
  var valid_569060 = path.getOrDefault("repetitionName")
  valid_569060 = validateParameter(valid_569060, JString, required = true,
                                 default = nil)
  if valid_569060 != nil:
    section.add "repetitionName", valid_569060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569061 = query.getOrDefault("api-version")
  valid_569061 = validateParameter(valid_569061, JString, required = true,
                                 default = nil)
  if valid_569061 != nil:
    section.add "api-version", valid_569061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569062: Call_WorkflowRunActionRepetitionsGet_569052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a workflow run action repetition.
  ## 
  let valid = call_569062.validator(path, query, header, formData, body)
  let scheme = call_569062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569062.url(scheme.get, call_569062.host, call_569062.base,
                         call_569062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569062, url, valid)

proc call*(call_569063: Call_WorkflowRunActionRepetitionsGet_569052;
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
  var path_569064 = newJObject()
  var query_569065 = newJObject()
  add(path_569064, "workflowName", newJString(workflowName))
  add(path_569064, "actionName", newJString(actionName))
  add(path_569064, "resourceGroupName", newJString(resourceGroupName))
  add(path_569064, "runName", newJString(runName))
  add(query_569065, "api-version", newJString(apiVersion))
  add(path_569064, "subscriptionId", newJString(subscriptionId))
  add(path_569064, "repetitionName", newJString(repetitionName))
  result = call_569063.call(path_569064, query_569065, nil, nil, nil)

var workflowRunActionRepetitionsGet* = Call_WorkflowRunActionRepetitionsGet_569052(
    name: "workflowRunActionRepetitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}",
    validator: validate_WorkflowRunActionRepetitionsGet_569053, base: "",
    url: url_WorkflowRunActionRepetitionsGet_569054, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsListExpressionTraces_569066 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionRepetitionsListExpressionTraces_569068(
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

proc validate_WorkflowRunActionRepetitionsListExpressionTraces_569067(
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
  var valid_569069 = path.getOrDefault("workflowName")
  valid_569069 = validateParameter(valid_569069, JString, required = true,
                                 default = nil)
  if valid_569069 != nil:
    section.add "workflowName", valid_569069
  var valid_569070 = path.getOrDefault("actionName")
  valid_569070 = validateParameter(valid_569070, JString, required = true,
                                 default = nil)
  if valid_569070 != nil:
    section.add "actionName", valid_569070
  var valid_569071 = path.getOrDefault("resourceGroupName")
  valid_569071 = validateParameter(valid_569071, JString, required = true,
                                 default = nil)
  if valid_569071 != nil:
    section.add "resourceGroupName", valid_569071
  var valid_569072 = path.getOrDefault("runName")
  valid_569072 = validateParameter(valid_569072, JString, required = true,
                                 default = nil)
  if valid_569072 != nil:
    section.add "runName", valid_569072
  var valid_569073 = path.getOrDefault("subscriptionId")
  valid_569073 = validateParameter(valid_569073, JString, required = true,
                                 default = nil)
  if valid_569073 != nil:
    section.add "subscriptionId", valid_569073
  var valid_569074 = path.getOrDefault("repetitionName")
  valid_569074 = validateParameter(valid_569074, JString, required = true,
                                 default = nil)
  if valid_569074 != nil:
    section.add "repetitionName", valid_569074
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569075 = query.getOrDefault("api-version")
  valid_569075 = validateParameter(valid_569075, JString, required = true,
                                 default = nil)
  if valid_569075 != nil:
    section.add "api-version", valid_569075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569076: Call_WorkflowRunActionRepetitionsListExpressionTraces_569066;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a workflow run expression trace.
  ## 
  let valid = call_569076.validator(path, query, header, formData, body)
  let scheme = call_569076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569076.url(scheme.get, call_569076.host, call_569076.base,
                         call_569076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569076, url, valid)

proc call*(call_569077: Call_WorkflowRunActionRepetitionsListExpressionTraces_569066;
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
  var path_569078 = newJObject()
  var query_569079 = newJObject()
  add(path_569078, "workflowName", newJString(workflowName))
  add(path_569078, "actionName", newJString(actionName))
  add(path_569078, "resourceGroupName", newJString(resourceGroupName))
  add(path_569078, "runName", newJString(runName))
  add(query_569079, "api-version", newJString(apiVersion))
  add(path_569078, "subscriptionId", newJString(subscriptionId))
  add(path_569078, "repetitionName", newJString(repetitionName))
  result = call_569077.call(path_569078, query_569079, nil, nil, nil)

var workflowRunActionRepetitionsListExpressionTraces* = Call_WorkflowRunActionRepetitionsListExpressionTraces_569066(
    name: "workflowRunActionRepetitionsListExpressionTraces",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/listExpressionTraces",
    validator: validate_WorkflowRunActionRepetitionsListExpressionTraces_569067,
    base: "", url: url_WorkflowRunActionRepetitionsListExpressionTraces_569068,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsRequestHistoriesList_569080 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionRepetitionsRequestHistoriesList_569082(
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

proc validate_WorkflowRunActionRepetitionsRequestHistoriesList_569081(
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
  var valid_569083 = path.getOrDefault("workflowName")
  valid_569083 = validateParameter(valid_569083, JString, required = true,
                                 default = nil)
  if valid_569083 != nil:
    section.add "workflowName", valid_569083
  var valid_569084 = path.getOrDefault("actionName")
  valid_569084 = validateParameter(valid_569084, JString, required = true,
                                 default = nil)
  if valid_569084 != nil:
    section.add "actionName", valid_569084
  var valid_569085 = path.getOrDefault("resourceGroupName")
  valid_569085 = validateParameter(valid_569085, JString, required = true,
                                 default = nil)
  if valid_569085 != nil:
    section.add "resourceGroupName", valid_569085
  var valid_569086 = path.getOrDefault("runName")
  valid_569086 = validateParameter(valid_569086, JString, required = true,
                                 default = nil)
  if valid_569086 != nil:
    section.add "runName", valid_569086
  var valid_569087 = path.getOrDefault("subscriptionId")
  valid_569087 = validateParameter(valid_569087, JString, required = true,
                                 default = nil)
  if valid_569087 != nil:
    section.add "subscriptionId", valid_569087
  var valid_569088 = path.getOrDefault("repetitionName")
  valid_569088 = validateParameter(valid_569088, JString, required = true,
                                 default = nil)
  if valid_569088 != nil:
    section.add "repetitionName", valid_569088
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569089 = query.getOrDefault("api-version")
  valid_569089 = validateParameter(valid_569089, JString, required = true,
                                 default = nil)
  if valid_569089 != nil:
    section.add "api-version", valid_569089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569090: Call_WorkflowRunActionRepetitionsRequestHistoriesList_569080;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a workflow run repetition request history.
  ## 
  let valid = call_569090.validator(path, query, header, formData, body)
  let scheme = call_569090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569090.url(scheme.get, call_569090.host, call_569090.base,
                         call_569090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569090, url, valid)

proc call*(call_569091: Call_WorkflowRunActionRepetitionsRequestHistoriesList_569080;
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
  var path_569092 = newJObject()
  var query_569093 = newJObject()
  add(path_569092, "workflowName", newJString(workflowName))
  add(path_569092, "actionName", newJString(actionName))
  add(path_569092, "resourceGroupName", newJString(resourceGroupName))
  add(path_569092, "runName", newJString(runName))
  add(query_569093, "api-version", newJString(apiVersion))
  add(path_569092, "subscriptionId", newJString(subscriptionId))
  add(path_569092, "repetitionName", newJString(repetitionName))
  result = call_569091.call(path_569092, query_569093, nil, nil, nil)

var workflowRunActionRepetitionsRequestHistoriesList* = Call_WorkflowRunActionRepetitionsRequestHistoriesList_569080(
    name: "workflowRunActionRepetitionsRequestHistoriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/requestHistories",
    validator: validate_WorkflowRunActionRepetitionsRequestHistoriesList_569081,
    base: "", url: url_WorkflowRunActionRepetitionsRequestHistoriesList_569082,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsRequestHistoriesGet_569094 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionRepetitionsRequestHistoriesGet_569096(protocol: Scheme;
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

proc validate_WorkflowRunActionRepetitionsRequestHistoriesGet_569095(
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
  var valid_569097 = path.getOrDefault("workflowName")
  valid_569097 = validateParameter(valid_569097, JString, required = true,
                                 default = nil)
  if valid_569097 != nil:
    section.add "workflowName", valid_569097
  var valid_569098 = path.getOrDefault("actionName")
  valid_569098 = validateParameter(valid_569098, JString, required = true,
                                 default = nil)
  if valid_569098 != nil:
    section.add "actionName", valid_569098
  var valid_569099 = path.getOrDefault("resourceGroupName")
  valid_569099 = validateParameter(valid_569099, JString, required = true,
                                 default = nil)
  if valid_569099 != nil:
    section.add "resourceGroupName", valid_569099
  var valid_569100 = path.getOrDefault("runName")
  valid_569100 = validateParameter(valid_569100, JString, required = true,
                                 default = nil)
  if valid_569100 != nil:
    section.add "runName", valid_569100
  var valid_569101 = path.getOrDefault("requestHistoryName")
  valid_569101 = validateParameter(valid_569101, JString, required = true,
                                 default = nil)
  if valid_569101 != nil:
    section.add "requestHistoryName", valid_569101
  var valid_569102 = path.getOrDefault("subscriptionId")
  valid_569102 = validateParameter(valid_569102, JString, required = true,
                                 default = nil)
  if valid_569102 != nil:
    section.add "subscriptionId", valid_569102
  var valid_569103 = path.getOrDefault("repetitionName")
  valid_569103 = validateParameter(valid_569103, JString, required = true,
                                 default = nil)
  if valid_569103 != nil:
    section.add "repetitionName", valid_569103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569104 = query.getOrDefault("api-version")
  valid_569104 = validateParameter(valid_569104, JString, required = true,
                                 default = nil)
  if valid_569104 != nil:
    section.add "api-version", valid_569104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569105: Call_WorkflowRunActionRepetitionsRequestHistoriesGet_569094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a workflow run repetition request history.
  ## 
  let valid = call_569105.validator(path, query, header, formData, body)
  let scheme = call_569105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569105.url(scheme.get, call_569105.host, call_569105.base,
                         call_569105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569105, url, valid)

proc call*(call_569106: Call_WorkflowRunActionRepetitionsRequestHistoriesGet_569094;
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
  var path_569107 = newJObject()
  var query_569108 = newJObject()
  add(path_569107, "workflowName", newJString(workflowName))
  add(path_569107, "actionName", newJString(actionName))
  add(path_569107, "resourceGroupName", newJString(resourceGroupName))
  add(path_569107, "runName", newJString(runName))
  add(query_569108, "api-version", newJString(apiVersion))
  add(path_569107, "requestHistoryName", newJString(requestHistoryName))
  add(path_569107, "subscriptionId", newJString(subscriptionId))
  add(path_569107, "repetitionName", newJString(repetitionName))
  result = call_569106.call(path_569107, query_569108, nil, nil, nil)

var workflowRunActionRepetitionsRequestHistoriesGet* = Call_WorkflowRunActionRepetitionsRequestHistoriesGet_569094(
    name: "workflowRunActionRepetitionsRequestHistoriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/requestHistories/{requestHistoryName}",
    validator: validate_WorkflowRunActionRepetitionsRequestHistoriesGet_569095,
    base: "", url: url_WorkflowRunActionRepetitionsRequestHistoriesGet_569096,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRequestHistoriesList_569109 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionRequestHistoriesList_569111(protocol: Scheme;
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

proc validate_WorkflowRunActionRequestHistoriesList_569110(path: JsonNode;
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
  var valid_569112 = path.getOrDefault("workflowName")
  valid_569112 = validateParameter(valid_569112, JString, required = true,
                                 default = nil)
  if valid_569112 != nil:
    section.add "workflowName", valid_569112
  var valid_569113 = path.getOrDefault("actionName")
  valid_569113 = validateParameter(valid_569113, JString, required = true,
                                 default = nil)
  if valid_569113 != nil:
    section.add "actionName", valid_569113
  var valid_569114 = path.getOrDefault("resourceGroupName")
  valid_569114 = validateParameter(valid_569114, JString, required = true,
                                 default = nil)
  if valid_569114 != nil:
    section.add "resourceGroupName", valid_569114
  var valid_569115 = path.getOrDefault("runName")
  valid_569115 = validateParameter(valid_569115, JString, required = true,
                                 default = nil)
  if valid_569115 != nil:
    section.add "runName", valid_569115
  var valid_569116 = path.getOrDefault("subscriptionId")
  valid_569116 = validateParameter(valid_569116, JString, required = true,
                                 default = nil)
  if valid_569116 != nil:
    section.add "subscriptionId", valid_569116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569117 = query.getOrDefault("api-version")
  valid_569117 = validateParameter(valid_569117, JString, required = true,
                                 default = nil)
  if valid_569117 != nil:
    section.add "api-version", valid_569117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569118: Call_WorkflowRunActionRequestHistoriesList_569109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a workflow run request history.
  ## 
  let valid = call_569118.validator(path, query, header, formData, body)
  let scheme = call_569118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569118.url(scheme.get, call_569118.host, call_569118.base,
                         call_569118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569118, url, valid)

proc call*(call_569119: Call_WorkflowRunActionRequestHistoriesList_569109;
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
  var path_569120 = newJObject()
  var query_569121 = newJObject()
  add(path_569120, "workflowName", newJString(workflowName))
  add(path_569120, "actionName", newJString(actionName))
  add(path_569120, "resourceGroupName", newJString(resourceGroupName))
  add(path_569120, "runName", newJString(runName))
  add(query_569121, "api-version", newJString(apiVersion))
  add(path_569120, "subscriptionId", newJString(subscriptionId))
  result = call_569119.call(path_569120, query_569121, nil, nil, nil)

var workflowRunActionRequestHistoriesList* = Call_WorkflowRunActionRequestHistoriesList_569109(
    name: "workflowRunActionRequestHistoriesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/requestHistories",
    validator: validate_WorkflowRunActionRequestHistoriesList_569110, base: "",
    url: url_WorkflowRunActionRequestHistoriesList_569111, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRequestHistoriesGet_569122 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionRequestHistoriesGet_569124(protocol: Scheme;
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

proc validate_WorkflowRunActionRequestHistoriesGet_569123(path: JsonNode;
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
  var valid_569125 = path.getOrDefault("workflowName")
  valid_569125 = validateParameter(valid_569125, JString, required = true,
                                 default = nil)
  if valid_569125 != nil:
    section.add "workflowName", valid_569125
  var valid_569126 = path.getOrDefault("actionName")
  valid_569126 = validateParameter(valid_569126, JString, required = true,
                                 default = nil)
  if valid_569126 != nil:
    section.add "actionName", valid_569126
  var valid_569127 = path.getOrDefault("resourceGroupName")
  valid_569127 = validateParameter(valid_569127, JString, required = true,
                                 default = nil)
  if valid_569127 != nil:
    section.add "resourceGroupName", valid_569127
  var valid_569128 = path.getOrDefault("runName")
  valid_569128 = validateParameter(valid_569128, JString, required = true,
                                 default = nil)
  if valid_569128 != nil:
    section.add "runName", valid_569128
  var valid_569129 = path.getOrDefault("requestHistoryName")
  valid_569129 = validateParameter(valid_569129, JString, required = true,
                                 default = nil)
  if valid_569129 != nil:
    section.add "requestHistoryName", valid_569129
  var valid_569130 = path.getOrDefault("subscriptionId")
  valid_569130 = validateParameter(valid_569130, JString, required = true,
                                 default = nil)
  if valid_569130 != nil:
    section.add "subscriptionId", valid_569130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569131 = query.getOrDefault("api-version")
  valid_569131 = validateParameter(valid_569131, JString, required = true,
                                 default = nil)
  if valid_569131 != nil:
    section.add "api-version", valid_569131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569132: Call_WorkflowRunActionRequestHistoriesGet_569122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a workflow run request history.
  ## 
  let valid = call_569132.validator(path, query, header, formData, body)
  let scheme = call_569132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569132.url(scheme.get, call_569132.host, call_569132.base,
                         call_569132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569132, url, valid)

proc call*(call_569133: Call_WorkflowRunActionRequestHistoriesGet_569122;
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
  var path_569134 = newJObject()
  var query_569135 = newJObject()
  add(path_569134, "workflowName", newJString(workflowName))
  add(path_569134, "actionName", newJString(actionName))
  add(path_569134, "resourceGroupName", newJString(resourceGroupName))
  add(path_569134, "runName", newJString(runName))
  add(query_569135, "api-version", newJString(apiVersion))
  add(path_569134, "requestHistoryName", newJString(requestHistoryName))
  add(path_569134, "subscriptionId", newJString(subscriptionId))
  result = call_569133.call(path_569134, query_569135, nil, nil, nil)

var workflowRunActionRequestHistoriesGet* = Call_WorkflowRunActionRequestHistoriesGet_569122(
    name: "workflowRunActionRequestHistoriesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/requestHistories/{requestHistoryName}",
    validator: validate_WorkflowRunActionRequestHistoriesGet_569123, base: "",
    url: url_WorkflowRunActionRequestHistoriesGet_569124, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionScopeRepetitionsList_569136 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionScopeRepetitionsList_569138(protocol: Scheme;
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

proc validate_WorkflowRunActionScopeRepetitionsList_569137(path: JsonNode;
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
  var valid_569139 = path.getOrDefault("workflowName")
  valid_569139 = validateParameter(valid_569139, JString, required = true,
                                 default = nil)
  if valid_569139 != nil:
    section.add "workflowName", valid_569139
  var valid_569140 = path.getOrDefault("actionName")
  valid_569140 = validateParameter(valid_569140, JString, required = true,
                                 default = nil)
  if valid_569140 != nil:
    section.add "actionName", valid_569140
  var valid_569141 = path.getOrDefault("resourceGroupName")
  valid_569141 = validateParameter(valid_569141, JString, required = true,
                                 default = nil)
  if valid_569141 != nil:
    section.add "resourceGroupName", valid_569141
  var valid_569142 = path.getOrDefault("runName")
  valid_569142 = validateParameter(valid_569142, JString, required = true,
                                 default = nil)
  if valid_569142 != nil:
    section.add "runName", valid_569142
  var valid_569143 = path.getOrDefault("subscriptionId")
  valid_569143 = validateParameter(valid_569143, JString, required = true,
                                 default = nil)
  if valid_569143 != nil:
    section.add "subscriptionId", valid_569143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569144 = query.getOrDefault("api-version")
  valid_569144 = validateParameter(valid_569144, JString, required = true,
                                 default = nil)
  if valid_569144 != nil:
    section.add "api-version", valid_569144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569145: Call_WorkflowRunActionScopeRepetitionsList_569136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the workflow run action scoped repetitions.
  ## 
  let valid = call_569145.validator(path, query, header, formData, body)
  let scheme = call_569145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569145.url(scheme.get, call_569145.host, call_569145.base,
                         call_569145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569145, url, valid)

proc call*(call_569146: Call_WorkflowRunActionScopeRepetitionsList_569136;
          workflowName: string; actionName: string; resourceGroupName: string;
          runName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## workflowRunActionScopeRepetitionsList
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
  var path_569147 = newJObject()
  var query_569148 = newJObject()
  add(path_569147, "workflowName", newJString(workflowName))
  add(path_569147, "actionName", newJString(actionName))
  add(path_569147, "resourceGroupName", newJString(resourceGroupName))
  add(path_569147, "runName", newJString(runName))
  add(query_569148, "api-version", newJString(apiVersion))
  add(path_569147, "subscriptionId", newJString(subscriptionId))
  result = call_569146.call(path_569147, query_569148, nil, nil, nil)

var workflowRunActionScopeRepetitionsList* = Call_WorkflowRunActionScopeRepetitionsList_569136(
    name: "workflowRunActionScopeRepetitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/scopeRepetitions",
    validator: validate_WorkflowRunActionScopeRepetitionsList_569137, base: "",
    url: url_WorkflowRunActionScopeRepetitionsList_569138, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionScopeRepetitionsGet_569149 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunActionScopeRepetitionsGet_569151(protocol: Scheme;
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

proc validate_WorkflowRunActionScopeRepetitionsGet_569150(path: JsonNode;
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
  var valid_569152 = path.getOrDefault("workflowName")
  valid_569152 = validateParameter(valid_569152, JString, required = true,
                                 default = nil)
  if valid_569152 != nil:
    section.add "workflowName", valid_569152
  var valid_569153 = path.getOrDefault("actionName")
  valid_569153 = validateParameter(valid_569153, JString, required = true,
                                 default = nil)
  if valid_569153 != nil:
    section.add "actionName", valid_569153
  var valid_569154 = path.getOrDefault("resourceGroupName")
  valid_569154 = validateParameter(valid_569154, JString, required = true,
                                 default = nil)
  if valid_569154 != nil:
    section.add "resourceGroupName", valid_569154
  var valid_569155 = path.getOrDefault("runName")
  valid_569155 = validateParameter(valid_569155, JString, required = true,
                                 default = nil)
  if valid_569155 != nil:
    section.add "runName", valid_569155
  var valid_569156 = path.getOrDefault("subscriptionId")
  valid_569156 = validateParameter(valid_569156, JString, required = true,
                                 default = nil)
  if valid_569156 != nil:
    section.add "subscriptionId", valid_569156
  var valid_569157 = path.getOrDefault("repetitionName")
  valid_569157 = validateParameter(valid_569157, JString, required = true,
                                 default = nil)
  if valid_569157 != nil:
    section.add "repetitionName", valid_569157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569158 = query.getOrDefault("api-version")
  valid_569158 = validateParameter(valid_569158, JString, required = true,
                                 default = nil)
  if valid_569158 != nil:
    section.add "api-version", valid_569158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569159: Call_WorkflowRunActionScopeRepetitionsGet_569149;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a workflow run action scoped repetition.
  ## 
  let valid = call_569159.validator(path, query, header, formData, body)
  let scheme = call_569159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569159.url(scheme.get, call_569159.host, call_569159.base,
                         call_569159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569159, url, valid)

proc call*(call_569160: Call_WorkflowRunActionScopeRepetitionsGet_569149;
          workflowName: string; actionName: string; resourceGroupName: string;
          runName: string; apiVersion: string; subscriptionId: string;
          repetitionName: string): Recallable =
  ## workflowRunActionScopeRepetitionsGet
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
  var path_569161 = newJObject()
  var query_569162 = newJObject()
  add(path_569161, "workflowName", newJString(workflowName))
  add(path_569161, "actionName", newJString(actionName))
  add(path_569161, "resourceGroupName", newJString(resourceGroupName))
  add(path_569161, "runName", newJString(runName))
  add(query_569162, "api-version", newJString(apiVersion))
  add(path_569161, "subscriptionId", newJString(subscriptionId))
  add(path_569161, "repetitionName", newJString(repetitionName))
  result = call_569160.call(path_569161, query_569162, nil, nil, nil)

var workflowRunActionScopeRepetitionsGet* = Call_WorkflowRunActionScopeRepetitionsGet_569149(
    name: "workflowRunActionScopeRepetitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/scopeRepetitions/{repetitionName}",
    validator: validate_WorkflowRunActionScopeRepetitionsGet_569150, base: "",
    url: url_WorkflowRunActionScopeRepetitionsGet_569151, schemes: {Scheme.Https})
type
  Call_WorkflowRunsCancel_569163 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunsCancel_569165(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsCancel_569164(path: JsonNode; query: JsonNode;
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
  var valid_569166 = path.getOrDefault("workflowName")
  valid_569166 = validateParameter(valid_569166, JString, required = true,
                                 default = nil)
  if valid_569166 != nil:
    section.add "workflowName", valid_569166
  var valid_569167 = path.getOrDefault("resourceGroupName")
  valid_569167 = validateParameter(valid_569167, JString, required = true,
                                 default = nil)
  if valid_569167 != nil:
    section.add "resourceGroupName", valid_569167
  var valid_569168 = path.getOrDefault("runName")
  valid_569168 = validateParameter(valid_569168, JString, required = true,
                                 default = nil)
  if valid_569168 != nil:
    section.add "runName", valid_569168
  var valid_569169 = path.getOrDefault("subscriptionId")
  valid_569169 = validateParameter(valid_569169, JString, required = true,
                                 default = nil)
  if valid_569169 != nil:
    section.add "subscriptionId", valid_569169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569170 = query.getOrDefault("api-version")
  valid_569170 = validateParameter(valid_569170, JString, required = true,
                                 default = nil)
  if valid_569170 != nil:
    section.add "api-version", valid_569170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569171: Call_WorkflowRunsCancel_569163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a workflow run.
  ## 
  let valid = call_569171.validator(path, query, header, formData, body)
  let scheme = call_569171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569171.url(scheme.get, call_569171.host, call_569171.base,
                         call_569171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569171, url, valid)

proc call*(call_569172: Call_WorkflowRunsCancel_569163; workflowName: string;
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
  var path_569173 = newJObject()
  var query_569174 = newJObject()
  add(path_569173, "workflowName", newJString(workflowName))
  add(path_569173, "resourceGroupName", newJString(resourceGroupName))
  add(path_569173, "runName", newJString(runName))
  add(query_569174, "api-version", newJString(apiVersion))
  add(path_569173, "subscriptionId", newJString(subscriptionId))
  result = call_569172.call(path_569173, query_569174, nil, nil, nil)

var workflowRunsCancel* = Call_WorkflowRunsCancel_569163(
    name: "workflowRunsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/cancel",
    validator: validate_WorkflowRunsCancel_569164, base: "",
    url: url_WorkflowRunsCancel_569165, schemes: {Scheme.Https})
type
  Call_WorkflowRunOperationsGet_569175 = ref object of OpenApiRestCall_567667
proc url_WorkflowRunOperationsGet_569177(protocol: Scheme; host: string;
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

proc validate_WorkflowRunOperationsGet_569176(path: JsonNode; query: JsonNode;
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
  var valid_569178 = path.getOrDefault("workflowName")
  valid_569178 = validateParameter(valid_569178, JString, required = true,
                                 default = nil)
  if valid_569178 != nil:
    section.add "workflowName", valid_569178
  var valid_569179 = path.getOrDefault("resourceGroupName")
  valid_569179 = validateParameter(valid_569179, JString, required = true,
                                 default = nil)
  if valid_569179 != nil:
    section.add "resourceGroupName", valid_569179
  var valid_569180 = path.getOrDefault("runName")
  valid_569180 = validateParameter(valid_569180, JString, required = true,
                                 default = nil)
  if valid_569180 != nil:
    section.add "runName", valid_569180
  var valid_569181 = path.getOrDefault("subscriptionId")
  valid_569181 = validateParameter(valid_569181, JString, required = true,
                                 default = nil)
  if valid_569181 != nil:
    section.add "subscriptionId", valid_569181
  var valid_569182 = path.getOrDefault("operationId")
  valid_569182 = validateParameter(valid_569182, JString, required = true,
                                 default = nil)
  if valid_569182 != nil:
    section.add "operationId", valid_569182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569183 = query.getOrDefault("api-version")
  valid_569183 = validateParameter(valid_569183, JString, required = true,
                                 default = nil)
  if valid_569183 != nil:
    section.add "api-version", valid_569183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569184: Call_WorkflowRunOperationsGet_569175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an operation for a run.
  ## 
  let valid = call_569184.validator(path, query, header, formData, body)
  let scheme = call_569184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569184.url(scheme.get, call_569184.host, call_569184.base,
                         call_569184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569184, url, valid)

proc call*(call_569185: Call_WorkflowRunOperationsGet_569175; workflowName: string;
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
  var path_569186 = newJObject()
  var query_569187 = newJObject()
  add(path_569186, "workflowName", newJString(workflowName))
  add(path_569186, "resourceGroupName", newJString(resourceGroupName))
  add(path_569186, "runName", newJString(runName))
  add(query_569187, "api-version", newJString(apiVersion))
  add(path_569186, "subscriptionId", newJString(subscriptionId))
  add(path_569186, "operationId", newJString(operationId))
  result = call_569185.call(path_569186, query_569187, nil, nil, nil)

var workflowRunOperationsGet* = Call_WorkflowRunOperationsGet_569175(
    name: "workflowRunOperationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/operations/{operationId}",
    validator: validate_WorkflowRunOperationsGet_569176, base: "",
    url: url_WorkflowRunOperationsGet_569177, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersList_569188 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggersList_569190(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersList_569189(path: JsonNode; query: JsonNode;
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
  var valid_569191 = path.getOrDefault("workflowName")
  valid_569191 = validateParameter(valid_569191, JString, required = true,
                                 default = nil)
  if valid_569191 != nil:
    section.add "workflowName", valid_569191
  var valid_569192 = path.getOrDefault("resourceGroupName")
  valid_569192 = validateParameter(valid_569192, JString, required = true,
                                 default = nil)
  if valid_569192 != nil:
    section.add "resourceGroupName", valid_569192
  var valid_569193 = path.getOrDefault("subscriptionId")
  valid_569193 = validateParameter(valid_569193, JString, required = true,
                                 default = nil)
  if valid_569193 != nil:
    section.add "subscriptionId", valid_569193
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
  var valid_569194 = query.getOrDefault("api-version")
  valid_569194 = validateParameter(valid_569194, JString, required = true,
                                 default = nil)
  if valid_569194 != nil:
    section.add "api-version", valid_569194
  var valid_569195 = query.getOrDefault("$top")
  valid_569195 = validateParameter(valid_569195, JInt, required = false, default = nil)
  if valid_569195 != nil:
    section.add "$top", valid_569195
  var valid_569196 = query.getOrDefault("$filter")
  valid_569196 = validateParameter(valid_569196, JString, required = false,
                                 default = nil)
  if valid_569196 != nil:
    section.add "$filter", valid_569196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569197: Call_WorkflowTriggersList_569188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow triggers.
  ## 
  let valid = call_569197.validator(path, query, header, formData, body)
  let scheme = call_569197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569197.url(scheme.get, call_569197.host, call_569197.base,
                         call_569197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569197, url, valid)

proc call*(call_569198: Call_WorkflowTriggersList_569188; workflowName: string;
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
  var path_569199 = newJObject()
  var query_569200 = newJObject()
  add(path_569199, "workflowName", newJString(workflowName))
  add(path_569199, "resourceGroupName", newJString(resourceGroupName))
  add(query_569200, "api-version", newJString(apiVersion))
  add(path_569199, "subscriptionId", newJString(subscriptionId))
  add(query_569200, "$top", newJInt(Top))
  add(query_569200, "$filter", newJString(Filter))
  result = call_569198.call(path_569199, query_569200, nil, nil, nil)

var workflowTriggersList* = Call_WorkflowTriggersList_569188(
    name: "workflowTriggersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers",
    validator: validate_WorkflowTriggersList_569189, base: "",
    url: url_WorkflowTriggersList_569190, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersGet_569201 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggersGet_569203(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersGet_569202(path: JsonNode; query: JsonNode;
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
  var valid_569204 = path.getOrDefault("workflowName")
  valid_569204 = validateParameter(valid_569204, JString, required = true,
                                 default = nil)
  if valid_569204 != nil:
    section.add "workflowName", valid_569204
  var valid_569205 = path.getOrDefault("resourceGroupName")
  valid_569205 = validateParameter(valid_569205, JString, required = true,
                                 default = nil)
  if valid_569205 != nil:
    section.add "resourceGroupName", valid_569205
  var valid_569206 = path.getOrDefault("subscriptionId")
  valid_569206 = validateParameter(valid_569206, JString, required = true,
                                 default = nil)
  if valid_569206 != nil:
    section.add "subscriptionId", valid_569206
  var valid_569207 = path.getOrDefault("triggerName")
  valid_569207 = validateParameter(valid_569207, JString, required = true,
                                 default = nil)
  if valid_569207 != nil:
    section.add "triggerName", valid_569207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569208 = query.getOrDefault("api-version")
  valid_569208 = validateParameter(valid_569208, JString, required = true,
                                 default = nil)
  if valid_569208 != nil:
    section.add "api-version", valid_569208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569209: Call_WorkflowTriggersGet_569201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow trigger.
  ## 
  let valid = call_569209.validator(path, query, header, formData, body)
  let scheme = call_569209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569209.url(scheme.get, call_569209.host, call_569209.base,
                         call_569209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569209, url, valid)

proc call*(call_569210: Call_WorkflowTriggersGet_569201; workflowName: string;
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
  var path_569211 = newJObject()
  var query_569212 = newJObject()
  add(path_569211, "workflowName", newJString(workflowName))
  add(path_569211, "resourceGroupName", newJString(resourceGroupName))
  add(query_569212, "api-version", newJString(apiVersion))
  add(path_569211, "subscriptionId", newJString(subscriptionId))
  add(path_569211, "triggerName", newJString(triggerName))
  result = call_569210.call(path_569211, query_569212, nil, nil, nil)

var workflowTriggersGet* = Call_WorkflowTriggersGet_569201(
    name: "workflowTriggersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}",
    validator: validate_WorkflowTriggersGet_569202, base: "",
    url: url_WorkflowTriggersGet_569203, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesList_569213 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggerHistoriesList_569215(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesList_569214(path: JsonNode; query: JsonNode;
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
  var valid_569216 = path.getOrDefault("workflowName")
  valid_569216 = validateParameter(valid_569216, JString, required = true,
                                 default = nil)
  if valid_569216 != nil:
    section.add "workflowName", valid_569216
  var valid_569217 = path.getOrDefault("resourceGroupName")
  valid_569217 = validateParameter(valid_569217, JString, required = true,
                                 default = nil)
  if valid_569217 != nil:
    section.add "resourceGroupName", valid_569217
  var valid_569218 = path.getOrDefault("subscriptionId")
  valid_569218 = validateParameter(valid_569218, JString, required = true,
                                 default = nil)
  if valid_569218 != nil:
    section.add "subscriptionId", valid_569218
  var valid_569219 = path.getOrDefault("triggerName")
  valid_569219 = validateParameter(valid_569219, JString, required = true,
                                 default = nil)
  if valid_569219 != nil:
    section.add "triggerName", valid_569219
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
  var valid_569220 = query.getOrDefault("api-version")
  valid_569220 = validateParameter(valid_569220, JString, required = true,
                                 default = nil)
  if valid_569220 != nil:
    section.add "api-version", valid_569220
  var valid_569221 = query.getOrDefault("$top")
  valid_569221 = validateParameter(valid_569221, JInt, required = false, default = nil)
  if valid_569221 != nil:
    section.add "$top", valid_569221
  var valid_569222 = query.getOrDefault("$filter")
  valid_569222 = validateParameter(valid_569222, JString, required = false,
                                 default = nil)
  if valid_569222 != nil:
    section.add "$filter", valid_569222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569223: Call_WorkflowTriggerHistoriesList_569213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow trigger histories.
  ## 
  let valid = call_569223.validator(path, query, header, formData, body)
  let scheme = call_569223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569223.url(scheme.get, call_569223.host, call_569223.base,
                         call_569223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569223, url, valid)

proc call*(call_569224: Call_WorkflowTriggerHistoriesList_569213;
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
  var path_569225 = newJObject()
  var query_569226 = newJObject()
  add(path_569225, "workflowName", newJString(workflowName))
  add(path_569225, "resourceGroupName", newJString(resourceGroupName))
  add(query_569226, "api-version", newJString(apiVersion))
  add(path_569225, "subscriptionId", newJString(subscriptionId))
  add(query_569226, "$top", newJInt(Top))
  add(path_569225, "triggerName", newJString(triggerName))
  add(query_569226, "$filter", newJString(Filter))
  result = call_569224.call(path_569225, query_569226, nil, nil, nil)

var workflowTriggerHistoriesList* = Call_WorkflowTriggerHistoriesList_569213(
    name: "workflowTriggerHistoriesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories",
    validator: validate_WorkflowTriggerHistoriesList_569214, base: "",
    url: url_WorkflowTriggerHistoriesList_569215, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesGet_569227 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggerHistoriesGet_569229(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesGet_569228(path: JsonNode; query: JsonNode;
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
  var valid_569230 = path.getOrDefault("workflowName")
  valid_569230 = validateParameter(valid_569230, JString, required = true,
                                 default = nil)
  if valid_569230 != nil:
    section.add "workflowName", valid_569230
  var valid_569231 = path.getOrDefault("resourceGroupName")
  valid_569231 = validateParameter(valid_569231, JString, required = true,
                                 default = nil)
  if valid_569231 != nil:
    section.add "resourceGroupName", valid_569231
  var valid_569232 = path.getOrDefault("historyName")
  valid_569232 = validateParameter(valid_569232, JString, required = true,
                                 default = nil)
  if valid_569232 != nil:
    section.add "historyName", valid_569232
  var valid_569233 = path.getOrDefault("subscriptionId")
  valid_569233 = validateParameter(valid_569233, JString, required = true,
                                 default = nil)
  if valid_569233 != nil:
    section.add "subscriptionId", valid_569233
  var valid_569234 = path.getOrDefault("triggerName")
  valid_569234 = validateParameter(valid_569234, JString, required = true,
                                 default = nil)
  if valid_569234 != nil:
    section.add "triggerName", valid_569234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569235 = query.getOrDefault("api-version")
  valid_569235 = validateParameter(valid_569235, JString, required = true,
                                 default = nil)
  if valid_569235 != nil:
    section.add "api-version", valid_569235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569236: Call_WorkflowTriggerHistoriesGet_569227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow trigger history.
  ## 
  let valid = call_569236.validator(path, query, header, formData, body)
  let scheme = call_569236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569236.url(scheme.get, call_569236.host, call_569236.base,
                         call_569236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569236, url, valid)

proc call*(call_569237: Call_WorkflowTriggerHistoriesGet_569227;
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
  var path_569238 = newJObject()
  var query_569239 = newJObject()
  add(path_569238, "workflowName", newJString(workflowName))
  add(path_569238, "resourceGroupName", newJString(resourceGroupName))
  add(query_569239, "api-version", newJString(apiVersion))
  add(path_569238, "historyName", newJString(historyName))
  add(path_569238, "subscriptionId", newJString(subscriptionId))
  add(path_569238, "triggerName", newJString(triggerName))
  result = call_569237.call(path_569238, query_569239, nil, nil, nil)

var workflowTriggerHistoriesGet* = Call_WorkflowTriggerHistoriesGet_569227(
    name: "workflowTriggerHistoriesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories/{historyName}",
    validator: validate_WorkflowTriggerHistoriesGet_569228, base: "",
    url: url_WorkflowTriggerHistoriesGet_569229, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesResubmit_569240 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggerHistoriesResubmit_569242(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesResubmit_569241(path: JsonNode;
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
  var valid_569243 = path.getOrDefault("workflowName")
  valid_569243 = validateParameter(valid_569243, JString, required = true,
                                 default = nil)
  if valid_569243 != nil:
    section.add "workflowName", valid_569243
  var valid_569244 = path.getOrDefault("resourceGroupName")
  valid_569244 = validateParameter(valid_569244, JString, required = true,
                                 default = nil)
  if valid_569244 != nil:
    section.add "resourceGroupName", valid_569244
  var valid_569245 = path.getOrDefault("historyName")
  valid_569245 = validateParameter(valid_569245, JString, required = true,
                                 default = nil)
  if valid_569245 != nil:
    section.add "historyName", valid_569245
  var valid_569246 = path.getOrDefault("subscriptionId")
  valid_569246 = validateParameter(valid_569246, JString, required = true,
                                 default = nil)
  if valid_569246 != nil:
    section.add "subscriptionId", valid_569246
  var valid_569247 = path.getOrDefault("triggerName")
  valid_569247 = validateParameter(valid_569247, JString, required = true,
                                 default = nil)
  if valid_569247 != nil:
    section.add "triggerName", valid_569247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569248 = query.getOrDefault("api-version")
  valid_569248 = validateParameter(valid_569248, JString, required = true,
                                 default = nil)
  if valid_569248 != nil:
    section.add "api-version", valid_569248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569249: Call_WorkflowTriggerHistoriesResubmit_569240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resubmits a workflow run based on the trigger history.
  ## 
  let valid = call_569249.validator(path, query, header, formData, body)
  let scheme = call_569249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569249.url(scheme.get, call_569249.host, call_569249.base,
                         call_569249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569249, url, valid)

proc call*(call_569250: Call_WorkflowTriggerHistoriesResubmit_569240;
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
  var path_569251 = newJObject()
  var query_569252 = newJObject()
  add(path_569251, "workflowName", newJString(workflowName))
  add(path_569251, "resourceGroupName", newJString(resourceGroupName))
  add(query_569252, "api-version", newJString(apiVersion))
  add(path_569251, "historyName", newJString(historyName))
  add(path_569251, "subscriptionId", newJString(subscriptionId))
  add(path_569251, "triggerName", newJString(triggerName))
  result = call_569250.call(path_569251, query_569252, nil, nil, nil)

var workflowTriggerHistoriesResubmit* = Call_WorkflowTriggerHistoriesResubmit_569240(
    name: "workflowTriggerHistoriesResubmit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories/{historyName}/resubmit",
    validator: validate_WorkflowTriggerHistoriesResubmit_569241, base: "",
    url: url_WorkflowTriggerHistoriesResubmit_569242, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersListCallbackUrl_569253 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggersListCallbackUrl_569255(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggersListCallbackUrl_569254(path: JsonNode;
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
  var valid_569256 = path.getOrDefault("workflowName")
  valid_569256 = validateParameter(valid_569256, JString, required = true,
                                 default = nil)
  if valid_569256 != nil:
    section.add "workflowName", valid_569256
  var valid_569257 = path.getOrDefault("resourceGroupName")
  valid_569257 = validateParameter(valid_569257, JString, required = true,
                                 default = nil)
  if valid_569257 != nil:
    section.add "resourceGroupName", valid_569257
  var valid_569258 = path.getOrDefault("subscriptionId")
  valid_569258 = validateParameter(valid_569258, JString, required = true,
                                 default = nil)
  if valid_569258 != nil:
    section.add "subscriptionId", valid_569258
  var valid_569259 = path.getOrDefault("triggerName")
  valid_569259 = validateParameter(valid_569259, JString, required = true,
                                 default = nil)
  if valid_569259 != nil:
    section.add "triggerName", valid_569259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569260 = query.getOrDefault("api-version")
  valid_569260 = validateParameter(valid_569260, JString, required = true,
                                 default = nil)
  if valid_569260 != nil:
    section.add "api-version", valid_569260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569261: Call_WorkflowTriggersListCallbackUrl_569253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the callback URL for a workflow trigger.
  ## 
  let valid = call_569261.validator(path, query, header, formData, body)
  let scheme = call_569261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569261.url(scheme.get, call_569261.host, call_569261.base,
                         call_569261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569261, url, valid)

proc call*(call_569262: Call_WorkflowTriggersListCallbackUrl_569253;
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
  var path_569263 = newJObject()
  var query_569264 = newJObject()
  add(path_569263, "workflowName", newJString(workflowName))
  add(path_569263, "resourceGroupName", newJString(resourceGroupName))
  add(query_569264, "api-version", newJString(apiVersion))
  add(path_569263, "subscriptionId", newJString(subscriptionId))
  add(path_569263, "triggerName", newJString(triggerName))
  result = call_569262.call(path_569263, query_569264, nil, nil, nil)

var workflowTriggersListCallbackUrl* = Call_WorkflowTriggersListCallbackUrl_569253(
    name: "workflowTriggersListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/listCallbackUrl",
    validator: validate_WorkflowTriggersListCallbackUrl_569254, base: "",
    url: url_WorkflowTriggersListCallbackUrl_569255, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersReset_569265 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggersReset_569267(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersReset_569266(path: JsonNode; query: JsonNode;
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
  var valid_569268 = path.getOrDefault("workflowName")
  valid_569268 = validateParameter(valid_569268, JString, required = true,
                                 default = nil)
  if valid_569268 != nil:
    section.add "workflowName", valid_569268
  var valid_569269 = path.getOrDefault("resourceGroupName")
  valid_569269 = validateParameter(valid_569269, JString, required = true,
                                 default = nil)
  if valid_569269 != nil:
    section.add "resourceGroupName", valid_569269
  var valid_569270 = path.getOrDefault("subscriptionId")
  valid_569270 = validateParameter(valid_569270, JString, required = true,
                                 default = nil)
  if valid_569270 != nil:
    section.add "subscriptionId", valid_569270
  var valid_569271 = path.getOrDefault("triggerName")
  valid_569271 = validateParameter(valid_569271, JString, required = true,
                                 default = nil)
  if valid_569271 != nil:
    section.add "triggerName", valid_569271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569272 = query.getOrDefault("api-version")
  valid_569272 = validateParameter(valid_569272, JString, required = true,
                                 default = nil)
  if valid_569272 != nil:
    section.add "api-version", valid_569272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569273: Call_WorkflowTriggersReset_569265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets a workflow trigger.
  ## 
  let valid = call_569273.validator(path, query, header, formData, body)
  let scheme = call_569273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569273.url(scheme.get, call_569273.host, call_569273.base,
                         call_569273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569273, url, valid)

proc call*(call_569274: Call_WorkflowTriggersReset_569265; workflowName: string;
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
  var path_569275 = newJObject()
  var query_569276 = newJObject()
  add(path_569275, "workflowName", newJString(workflowName))
  add(path_569275, "resourceGroupName", newJString(resourceGroupName))
  add(query_569276, "api-version", newJString(apiVersion))
  add(path_569275, "subscriptionId", newJString(subscriptionId))
  add(path_569275, "triggerName", newJString(triggerName))
  result = call_569274.call(path_569275, query_569276, nil, nil, nil)

var workflowTriggersReset* = Call_WorkflowTriggersReset_569265(
    name: "workflowTriggersReset", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/reset",
    validator: validate_WorkflowTriggersReset_569266, base: "",
    url: url_WorkflowTriggersReset_569267, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersRun_569277 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggersRun_569279(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersRun_569278(path: JsonNode; query: JsonNode;
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
  var valid_569280 = path.getOrDefault("workflowName")
  valid_569280 = validateParameter(valid_569280, JString, required = true,
                                 default = nil)
  if valid_569280 != nil:
    section.add "workflowName", valid_569280
  var valid_569281 = path.getOrDefault("resourceGroupName")
  valid_569281 = validateParameter(valid_569281, JString, required = true,
                                 default = nil)
  if valid_569281 != nil:
    section.add "resourceGroupName", valid_569281
  var valid_569282 = path.getOrDefault("subscriptionId")
  valid_569282 = validateParameter(valid_569282, JString, required = true,
                                 default = nil)
  if valid_569282 != nil:
    section.add "subscriptionId", valid_569282
  var valid_569283 = path.getOrDefault("triggerName")
  valid_569283 = validateParameter(valid_569283, JString, required = true,
                                 default = nil)
  if valid_569283 != nil:
    section.add "triggerName", valid_569283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569284 = query.getOrDefault("api-version")
  valid_569284 = validateParameter(valid_569284, JString, required = true,
                                 default = nil)
  if valid_569284 != nil:
    section.add "api-version", valid_569284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569285: Call_WorkflowTriggersRun_569277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a workflow trigger.
  ## 
  let valid = call_569285.validator(path, query, header, formData, body)
  let scheme = call_569285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569285.url(scheme.get, call_569285.host, call_569285.base,
                         call_569285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569285, url, valid)

proc call*(call_569286: Call_WorkflowTriggersRun_569277; workflowName: string;
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
  var path_569287 = newJObject()
  var query_569288 = newJObject()
  add(path_569287, "workflowName", newJString(workflowName))
  add(path_569287, "resourceGroupName", newJString(resourceGroupName))
  add(query_569288, "api-version", newJString(apiVersion))
  add(path_569287, "subscriptionId", newJString(subscriptionId))
  add(path_569287, "triggerName", newJString(triggerName))
  result = call_569286.call(path_569287, query_569288, nil, nil, nil)

var workflowTriggersRun* = Call_WorkflowTriggersRun_569277(
    name: "workflowTriggersRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/run",
    validator: validate_WorkflowTriggersRun_569278, base: "",
    url: url_WorkflowTriggersRun_569279, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersGetSchemaJson_569289 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggersGetSchemaJson_569291(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggersGetSchemaJson_569290(path: JsonNode; query: JsonNode;
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
  var valid_569292 = path.getOrDefault("workflowName")
  valid_569292 = validateParameter(valid_569292, JString, required = true,
                                 default = nil)
  if valid_569292 != nil:
    section.add "workflowName", valid_569292
  var valid_569293 = path.getOrDefault("resourceGroupName")
  valid_569293 = validateParameter(valid_569293, JString, required = true,
                                 default = nil)
  if valid_569293 != nil:
    section.add "resourceGroupName", valid_569293
  var valid_569294 = path.getOrDefault("subscriptionId")
  valid_569294 = validateParameter(valid_569294, JString, required = true,
                                 default = nil)
  if valid_569294 != nil:
    section.add "subscriptionId", valid_569294
  var valid_569295 = path.getOrDefault("triggerName")
  valid_569295 = validateParameter(valid_569295, JString, required = true,
                                 default = nil)
  if valid_569295 != nil:
    section.add "triggerName", valid_569295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569296 = query.getOrDefault("api-version")
  valid_569296 = validateParameter(valid_569296, JString, required = true,
                                 default = nil)
  if valid_569296 != nil:
    section.add "api-version", valid_569296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569297: Call_WorkflowTriggersGetSchemaJson_569289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the trigger schema as JSON.
  ## 
  let valid = call_569297.validator(path, query, header, formData, body)
  let scheme = call_569297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569297.url(scheme.get, call_569297.host, call_569297.base,
                         call_569297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569297, url, valid)

proc call*(call_569298: Call_WorkflowTriggersGetSchemaJson_569289;
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
  var path_569299 = newJObject()
  var query_569300 = newJObject()
  add(path_569299, "workflowName", newJString(workflowName))
  add(path_569299, "resourceGroupName", newJString(resourceGroupName))
  add(query_569300, "api-version", newJString(apiVersion))
  add(path_569299, "subscriptionId", newJString(subscriptionId))
  add(path_569299, "triggerName", newJString(triggerName))
  result = call_569298.call(path_569299, query_569300, nil, nil, nil)

var workflowTriggersGetSchemaJson* = Call_WorkflowTriggersGetSchemaJson_569289(
    name: "workflowTriggersGetSchemaJson", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/schemas/json",
    validator: validate_WorkflowTriggersGetSchemaJson_569290, base: "",
    url: url_WorkflowTriggersGetSchemaJson_569291, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersSetState_569301 = ref object of OpenApiRestCall_567667
proc url_WorkflowTriggersSetState_569303(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggersSetState_569302(path: JsonNode; query: JsonNode;
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
  var valid_569304 = path.getOrDefault("workflowName")
  valid_569304 = validateParameter(valid_569304, JString, required = true,
                                 default = nil)
  if valid_569304 != nil:
    section.add "workflowName", valid_569304
  var valid_569305 = path.getOrDefault("resourceGroupName")
  valid_569305 = validateParameter(valid_569305, JString, required = true,
                                 default = nil)
  if valid_569305 != nil:
    section.add "resourceGroupName", valid_569305
  var valid_569306 = path.getOrDefault("subscriptionId")
  valid_569306 = validateParameter(valid_569306, JString, required = true,
                                 default = nil)
  if valid_569306 != nil:
    section.add "subscriptionId", valid_569306
  var valid_569307 = path.getOrDefault("triggerName")
  valid_569307 = validateParameter(valid_569307, JString, required = true,
                                 default = nil)
  if valid_569307 != nil:
    section.add "triggerName", valid_569307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569308 = query.getOrDefault("api-version")
  valid_569308 = validateParameter(valid_569308, JString, required = true,
                                 default = nil)
  if valid_569308 != nil:
    section.add "api-version", valid_569308
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

proc call*(call_569310: Call_WorkflowTriggersSetState_569301; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of a workflow trigger.
  ## 
  let valid = call_569310.validator(path, query, header, formData, body)
  let scheme = call_569310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569310.url(scheme.get, call_569310.host, call_569310.base,
                         call_569310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569310, url, valid)

proc call*(call_569311: Call_WorkflowTriggersSetState_569301; workflowName: string;
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
  var path_569312 = newJObject()
  var query_569313 = newJObject()
  var body_569314 = newJObject()
  add(path_569312, "workflowName", newJString(workflowName))
  add(path_569312, "resourceGroupName", newJString(resourceGroupName))
  add(query_569313, "api-version", newJString(apiVersion))
  add(path_569312, "subscriptionId", newJString(subscriptionId))
  add(path_569312, "triggerName", newJString(triggerName))
  if setState != nil:
    body_569314 = setState
  result = call_569311.call(path_569312, query_569313, nil, nil, body_569314)

var workflowTriggersSetState* = Call_WorkflowTriggersSetState_569301(
    name: "workflowTriggersSetState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/setState",
    validator: validate_WorkflowTriggersSetState_569302, base: "",
    url: url_WorkflowTriggersSetState_569303, schemes: {Scheme.Https})
type
  Call_WorkflowsValidateByResourceGroup_569315 = ref object of OpenApiRestCall_567667
proc url_WorkflowsValidateByResourceGroup_569317(protocol: Scheme; host: string;
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

proc validate_WorkflowsValidateByResourceGroup_569316(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_569318 = path.getOrDefault("workflowName")
  valid_569318 = validateParameter(valid_569318, JString, required = true,
                                 default = nil)
  if valid_569318 != nil:
    section.add "workflowName", valid_569318
  var valid_569319 = path.getOrDefault("resourceGroupName")
  valid_569319 = validateParameter(valid_569319, JString, required = true,
                                 default = nil)
  if valid_569319 != nil:
    section.add "resourceGroupName", valid_569319
  var valid_569320 = path.getOrDefault("subscriptionId")
  valid_569320 = validateParameter(valid_569320, JString, required = true,
                                 default = nil)
  if valid_569320 != nil:
    section.add "subscriptionId", valid_569320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569321 = query.getOrDefault("api-version")
  valid_569321 = validateParameter(valid_569321, JString, required = true,
                                 default = nil)
  if valid_569321 != nil:
    section.add "api-version", valid_569321
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

proc call*(call_569323: Call_WorkflowsValidateByResourceGroup_569315;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates the workflow.
  ## 
  let valid = call_569323.validator(path, query, header, formData, body)
  let scheme = call_569323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569323.url(scheme.get, call_569323.host, call_569323.base,
                         call_569323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569323, url, valid)

proc call*(call_569324: Call_WorkflowsValidateByResourceGroup_569315;
          workflowName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; validate: JsonNode): Recallable =
  ## workflowsValidateByResourceGroup
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
  var path_569325 = newJObject()
  var query_569326 = newJObject()
  var body_569327 = newJObject()
  add(path_569325, "workflowName", newJString(workflowName))
  add(path_569325, "resourceGroupName", newJString(resourceGroupName))
  add(query_569326, "api-version", newJString(apiVersion))
  add(path_569325, "subscriptionId", newJString(subscriptionId))
  if validate != nil:
    body_569327 = validate
  result = call_569324.call(path_569325, query_569326, nil, nil, body_569327)

var workflowsValidateByResourceGroup* = Call_WorkflowsValidateByResourceGroup_569315(
    name: "workflowsValidateByResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/validate",
    validator: validate_WorkflowsValidateByResourceGroup_569316, base: "",
    url: url_WorkflowsValidateByResourceGroup_569317, schemes: {Scheme.Https})
type
  Call_WorkflowVersionsList_569328 = ref object of OpenApiRestCall_567667
proc url_WorkflowVersionsList_569330(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowVersionsList_569329(path: JsonNode; query: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569334 = query.getOrDefault("api-version")
  valid_569334 = validateParameter(valid_569334, JString, required = true,
                                 default = nil)
  if valid_569334 != nil:
    section.add "api-version", valid_569334
  var valid_569335 = query.getOrDefault("$top")
  valid_569335 = validateParameter(valid_569335, JInt, required = false, default = nil)
  if valid_569335 != nil:
    section.add "$top", valid_569335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569336: Call_WorkflowVersionsList_569328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow versions.
  ## 
  let valid = call_569336.validator(path, query, header, formData, body)
  let scheme = call_569336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569336.url(scheme.get, call_569336.host, call_569336.base,
                         call_569336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569336, url, valid)

proc call*(call_569337: Call_WorkflowVersionsList_569328; workflowName: string;
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
  var path_569338 = newJObject()
  var query_569339 = newJObject()
  add(path_569338, "workflowName", newJString(workflowName))
  add(path_569338, "resourceGroupName", newJString(resourceGroupName))
  add(query_569339, "api-version", newJString(apiVersion))
  add(path_569338, "subscriptionId", newJString(subscriptionId))
  add(query_569339, "$top", newJInt(Top))
  result = call_569337.call(path_569338, query_569339, nil, nil, nil)

var workflowVersionsList* = Call_WorkflowVersionsList_569328(
    name: "workflowVersionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions",
    validator: validate_WorkflowVersionsList_569329, base: "",
    url: url_WorkflowVersionsList_569330, schemes: {Scheme.Https})
type
  Call_WorkflowVersionsGet_569340 = ref object of OpenApiRestCall_567667
proc url_WorkflowVersionsGet_569342(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowVersionsGet_569341(path: JsonNode; query: JsonNode;
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
  var valid_569345 = path.getOrDefault("versionId")
  valid_569345 = validateParameter(valid_569345, JString, required = true,
                                 default = nil)
  if valid_569345 != nil:
    section.add "versionId", valid_569345
  var valid_569346 = path.getOrDefault("subscriptionId")
  valid_569346 = validateParameter(valid_569346, JString, required = true,
                                 default = nil)
  if valid_569346 != nil:
    section.add "subscriptionId", valid_569346
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

proc call*(call_569348: Call_WorkflowVersionsGet_569340; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow version.
  ## 
  let valid = call_569348.validator(path, query, header, formData, body)
  let scheme = call_569348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569348.url(scheme.get, call_569348.host, call_569348.base,
                         call_569348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569348, url, valid)

proc call*(call_569349: Call_WorkflowVersionsGet_569340; workflowName: string;
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
  var path_569350 = newJObject()
  var query_569351 = newJObject()
  add(path_569350, "workflowName", newJString(workflowName))
  add(path_569350, "resourceGroupName", newJString(resourceGroupName))
  add(path_569350, "versionId", newJString(versionId))
  add(query_569351, "api-version", newJString(apiVersion))
  add(path_569350, "subscriptionId", newJString(subscriptionId))
  result = call_569349.call(path_569350, query_569351, nil, nil, nil)

var workflowVersionsGet* = Call_WorkflowVersionsGet_569340(
    name: "workflowVersionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions/{versionId}",
    validator: validate_WorkflowVersionsGet_569341, base: "",
    url: url_WorkflowVersionsGet_569342, schemes: {Scheme.Https})
type
  Call_WorkflowVersionTriggersListCallbackUrl_569352 = ref object of OpenApiRestCall_567667
proc url_WorkflowVersionTriggersListCallbackUrl_569354(protocol: Scheme;
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

proc validate_WorkflowVersionTriggersListCallbackUrl_569353(path: JsonNode;
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
  var valid_569357 = path.getOrDefault("versionId")
  valid_569357 = validateParameter(valid_569357, JString, required = true,
                                 default = nil)
  if valid_569357 != nil:
    section.add "versionId", valid_569357
  var valid_569358 = path.getOrDefault("subscriptionId")
  valid_569358 = validateParameter(valid_569358, JString, required = true,
                                 default = nil)
  if valid_569358 != nil:
    section.add "subscriptionId", valid_569358
  var valid_569359 = path.getOrDefault("triggerName")
  valid_569359 = validateParameter(valid_569359, JString, required = true,
                                 default = nil)
  if valid_569359 != nil:
    section.add "triggerName", valid_569359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569360 = query.getOrDefault("api-version")
  valid_569360 = validateParameter(valid_569360, JString, required = true,
                                 default = nil)
  if valid_569360 != nil:
    section.add "api-version", valid_569360
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

proc call*(call_569362: Call_WorkflowVersionTriggersListCallbackUrl_569352;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the callback url for a trigger of a workflow version.
  ## 
  let valid = call_569362.validator(path, query, header, formData, body)
  let scheme = call_569362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569362.url(scheme.get, call_569362.host, call_569362.base,
                         call_569362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569362, url, valid)

proc call*(call_569363: Call_WorkflowVersionTriggersListCallbackUrl_569352;
          workflowName: string; resourceGroupName: string; versionId: string;
          apiVersion: string; subscriptionId: string; triggerName: string;
          parameters: JsonNode = nil): Recallable =
  ## workflowVersionTriggersListCallbackUrl
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
  var path_569364 = newJObject()
  var query_569365 = newJObject()
  var body_569366 = newJObject()
  add(path_569364, "workflowName", newJString(workflowName))
  add(path_569364, "resourceGroupName", newJString(resourceGroupName))
  add(path_569364, "versionId", newJString(versionId))
  add(query_569365, "api-version", newJString(apiVersion))
  add(path_569364, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_569366 = parameters
  add(path_569364, "triggerName", newJString(triggerName))
  result = call_569363.call(path_569364, query_569365, nil, nil, body_569366)

var workflowVersionTriggersListCallbackUrl* = Call_WorkflowVersionTriggersListCallbackUrl_569352(
    name: "workflowVersionTriggersListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions/{versionId}/triggers/{triggerName}/listCallbackUrl",
    validator: validate_WorkflowVersionTriggersListCallbackUrl_569353, base: "",
    url: url_WorkflowVersionTriggersListCallbackUrl_569354,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
