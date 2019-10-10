
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

  OpenApiRestCall_573667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573667): Option[Scheme] {.used.} =
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
  Call_OperationsList_573889 = ref object of OpenApiRestCall_573667
proc url_OperationsList_573891(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573890(path: JsonNode; query: JsonNode;
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
  var valid_574050 = query.getOrDefault("api-version")
  valid_574050 = validateParameter(valid_574050, JString, required = true,
                                 default = nil)
  if valid_574050 != nil:
    section.add "api-version", valid_574050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574073: Call_OperationsList_573889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Logic REST API operations.
  ## 
  let valid = call_574073.validator(path, query, header, formData, body)
  let scheme = call_574073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574073.url(scheme.get, call_574073.host, call_574073.base,
                         call_574073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574073, url, valid)

proc call*(call_574144: Call_OperationsList_573889; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Logic REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version.
  var query_574145 = newJObject()
  add(query_574145, "api-version", newJString(apiVersion))
  result = call_574144.call(nil, query_574145, nil, nil, nil)

var operationsList* = Call_OperationsList_573889(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Logic/operations",
    validator: validate_OperationsList_573890, base: "", url: url_OperationsList_573891,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListBySubscription_574185 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountsListBySubscription_574187(protocol: Scheme;
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

proc validate_IntegrationAccountsListBySubscription_574186(path: JsonNode;
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
  var valid_574203 = path.getOrDefault("subscriptionId")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "subscriptionId", valid_574203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574204 = query.getOrDefault("api-version")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "api-version", valid_574204
  var valid_574205 = query.getOrDefault("$top")
  valid_574205 = validateParameter(valid_574205, JInt, required = false, default = nil)
  if valid_574205 != nil:
    section.add "$top", valid_574205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574206: Call_IntegrationAccountsListBySubscription_574185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration accounts by subscription.
  ## 
  let valid = call_574206.validator(path, query, header, formData, body)
  let scheme = call_574206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574206.url(scheme.get, call_574206.host, call_574206.base,
                         call_574206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574206, url, valid)

proc call*(call_574207: Call_IntegrationAccountsListBySubscription_574185;
          apiVersion: string; subscriptionId: string; Top: int = 0): Recallable =
  ## integrationAccountsListBySubscription
  ## Gets a list of integration accounts by subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  var path_574208 = newJObject()
  var query_574209 = newJObject()
  add(query_574209, "api-version", newJString(apiVersion))
  add(path_574208, "subscriptionId", newJString(subscriptionId))
  add(query_574209, "$top", newJInt(Top))
  result = call_574207.call(path_574208, query_574209, nil, nil, nil)

var integrationAccountsListBySubscription* = Call_IntegrationAccountsListBySubscription_574185(
    name: "integrationAccountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Logic/integrationAccounts",
    validator: validate_IntegrationAccountsListBySubscription_574186, base: "",
    url: url_IntegrationAccountsListBySubscription_574187, schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentsListBySubscription_574210 = ref object of OpenApiRestCall_573667
proc url_IntegrationServiceEnvironmentsListBySubscription_574212(
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

proc validate_IntegrationServiceEnvironmentsListBySubscription_574211(
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
  var valid_574213 = path.getOrDefault("subscriptionId")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "subscriptionId", valid_574213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574214 = query.getOrDefault("api-version")
  valid_574214 = validateParameter(valid_574214, JString, required = true,
                                 default = nil)
  if valid_574214 != nil:
    section.add "api-version", valid_574214
  var valid_574215 = query.getOrDefault("$top")
  valid_574215 = validateParameter(valid_574215, JInt, required = false, default = nil)
  if valid_574215 != nil:
    section.add "$top", valid_574215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574216: Call_IntegrationServiceEnvironmentsListBySubscription_574210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration service environments by subscription.
  ## 
  let valid = call_574216.validator(path, query, header, formData, body)
  let scheme = call_574216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574216.url(scheme.get, call_574216.host, call_574216.base,
                         call_574216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574216, url, valid)

proc call*(call_574217: Call_IntegrationServiceEnvironmentsListBySubscription_574210;
          apiVersion: string; subscriptionId: string; Top: int = 0): Recallable =
  ## integrationServiceEnvironmentsListBySubscription
  ## Gets a list of integration service environments by subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  var path_574218 = newJObject()
  var query_574219 = newJObject()
  add(query_574219, "api-version", newJString(apiVersion))
  add(path_574218, "subscriptionId", newJString(subscriptionId))
  add(query_574219, "$top", newJInt(Top))
  result = call_574217.call(path_574218, query_574219, nil, nil, nil)

var integrationServiceEnvironmentsListBySubscription* = Call_IntegrationServiceEnvironmentsListBySubscription_574210(
    name: "integrationServiceEnvironmentsListBySubscription",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Logic/integrationServiceEnvironments",
    validator: validate_IntegrationServiceEnvironmentsListBySubscription_574211,
    base: "", url: url_IntegrationServiceEnvironmentsListBySubscription_574212,
    schemes: {Scheme.Https})
type
  Call_WorkflowsListBySubscription_574220 = ref object of OpenApiRestCall_573667
proc url_WorkflowsListBySubscription_574222(protocol: Scheme; host: string;
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

proc validate_WorkflowsListBySubscription_574221(path: JsonNode; query: JsonNode;
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
  var valid_574223 = path.getOrDefault("subscriptionId")
  valid_574223 = validateParameter(valid_574223, JString, required = true,
                                 default = nil)
  if valid_574223 != nil:
    section.add "subscriptionId", valid_574223
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
  var valid_574224 = query.getOrDefault("api-version")
  valid_574224 = validateParameter(valid_574224, JString, required = true,
                                 default = nil)
  if valid_574224 != nil:
    section.add "api-version", valid_574224
  var valid_574225 = query.getOrDefault("$top")
  valid_574225 = validateParameter(valid_574225, JInt, required = false, default = nil)
  if valid_574225 != nil:
    section.add "$top", valid_574225
  var valid_574226 = query.getOrDefault("$filter")
  valid_574226 = validateParameter(valid_574226, JString, required = false,
                                 default = nil)
  if valid_574226 != nil:
    section.add "$filter", valid_574226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574227: Call_WorkflowsListBySubscription_574220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflows by subscription.
  ## 
  let valid = call_574227.validator(path, query, header, formData, body)
  let scheme = call_574227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574227.url(scheme.get, call_574227.host, call_574227.base,
                         call_574227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574227, url, valid)

proc call*(call_574228: Call_WorkflowsListBySubscription_574220;
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
  var path_574229 = newJObject()
  var query_574230 = newJObject()
  add(query_574230, "api-version", newJString(apiVersion))
  add(path_574229, "subscriptionId", newJString(subscriptionId))
  add(query_574230, "$top", newJInt(Top))
  add(query_574230, "$filter", newJString(Filter))
  result = call_574228.call(path_574229, query_574230, nil, nil, nil)

var workflowsListBySubscription* = Call_WorkflowsListBySubscription_574220(
    name: "workflowsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Logic/workflows",
    validator: validate_WorkflowsListBySubscription_574221, base: "",
    url: url_WorkflowsListBySubscription_574222, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListByResourceGroup_574231 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountsListByResourceGroup_574233(protocol: Scheme;
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

proc validate_IntegrationAccountsListByResourceGroup_574232(path: JsonNode;
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
  var valid_574234 = path.getOrDefault("resourceGroupName")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "resourceGroupName", valid_574234
  var valid_574235 = path.getOrDefault("subscriptionId")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "subscriptionId", valid_574235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574236 = query.getOrDefault("api-version")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "api-version", valid_574236
  var valid_574237 = query.getOrDefault("$top")
  valid_574237 = validateParameter(valid_574237, JInt, required = false, default = nil)
  if valid_574237 != nil:
    section.add "$top", valid_574237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574238: Call_IntegrationAccountsListByResourceGroup_574231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration accounts by resource group.
  ## 
  let valid = call_574238.validator(path, query, header, formData, body)
  let scheme = call_574238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574238.url(scheme.get, call_574238.host, call_574238.base,
                         call_574238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574238, url, valid)

proc call*(call_574239: Call_IntegrationAccountsListByResourceGroup_574231;
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
  var path_574240 = newJObject()
  var query_574241 = newJObject()
  add(path_574240, "resourceGroupName", newJString(resourceGroupName))
  add(query_574241, "api-version", newJString(apiVersion))
  add(path_574240, "subscriptionId", newJString(subscriptionId))
  add(query_574241, "$top", newJInt(Top))
  result = call_574239.call(path_574240, query_574241, nil, nil, nil)

var integrationAccountsListByResourceGroup* = Call_IntegrationAccountsListByResourceGroup_574231(
    name: "integrationAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts",
    validator: validate_IntegrationAccountsListByResourceGroup_574232, base: "",
    url: url_IntegrationAccountsListByResourceGroup_574233,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountsCreateOrUpdate_574253 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountsCreateOrUpdate_574255(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsCreateOrUpdate_574254(path: JsonNode;
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
  var valid_574256 = path.getOrDefault("resourceGroupName")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = nil)
  if valid_574256 != nil:
    section.add "resourceGroupName", valid_574256
  var valid_574257 = path.getOrDefault("integrationAccountName")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "integrationAccountName", valid_574257
  var valid_574258 = path.getOrDefault("subscriptionId")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "subscriptionId", valid_574258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574259 = query.getOrDefault("api-version")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "api-version", valid_574259
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

proc call*(call_574261: Call_IntegrationAccountsCreateOrUpdate_574253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account.
  ## 
  let valid = call_574261.validator(path, query, header, formData, body)
  let scheme = call_574261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574261.url(scheme.get, call_574261.host, call_574261.base,
                         call_574261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574261, url, valid)

proc call*(call_574262: Call_IntegrationAccountsCreateOrUpdate_574253;
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
  var path_574263 = newJObject()
  var query_574264 = newJObject()
  var body_574265 = newJObject()
  add(path_574263, "resourceGroupName", newJString(resourceGroupName))
  add(query_574264, "api-version", newJString(apiVersion))
  add(path_574263, "integrationAccountName", newJString(integrationAccountName))
  add(path_574263, "subscriptionId", newJString(subscriptionId))
  if integrationAccount != nil:
    body_574265 = integrationAccount
  result = call_574262.call(path_574263, query_574264, nil, nil, body_574265)

var integrationAccountsCreateOrUpdate* = Call_IntegrationAccountsCreateOrUpdate_574253(
    name: "integrationAccountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsCreateOrUpdate_574254, base: "",
    url: url_IntegrationAccountsCreateOrUpdate_574255, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsGet_574242 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountsGet_574244(protocol: Scheme; host: string; base: string;
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

proc validate_IntegrationAccountsGet_574243(path: JsonNode; query: JsonNode;
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
  var valid_574245 = path.getOrDefault("resourceGroupName")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "resourceGroupName", valid_574245
  var valid_574246 = path.getOrDefault("integrationAccountName")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "integrationAccountName", valid_574246
  var valid_574247 = path.getOrDefault("subscriptionId")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "subscriptionId", valid_574247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574248 = query.getOrDefault("api-version")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "api-version", valid_574248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574249: Call_IntegrationAccountsGet_574242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account.
  ## 
  let valid = call_574249.validator(path, query, header, formData, body)
  let scheme = call_574249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574249.url(scheme.get, call_574249.host, call_574249.base,
                         call_574249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574249, url, valid)

proc call*(call_574250: Call_IntegrationAccountsGet_574242;
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
  var path_574251 = newJObject()
  var query_574252 = newJObject()
  add(path_574251, "resourceGroupName", newJString(resourceGroupName))
  add(query_574252, "api-version", newJString(apiVersion))
  add(path_574251, "integrationAccountName", newJString(integrationAccountName))
  add(path_574251, "subscriptionId", newJString(subscriptionId))
  result = call_574250.call(path_574251, query_574252, nil, nil, nil)

var integrationAccountsGet* = Call_IntegrationAccountsGet_574242(
    name: "integrationAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsGet_574243, base: "",
    url: url_IntegrationAccountsGet_574244, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsUpdate_574277 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountsUpdate_574279(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsUpdate_574278(path: JsonNode; query: JsonNode;
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
  var valid_574280 = path.getOrDefault("resourceGroupName")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "resourceGroupName", valid_574280
  var valid_574281 = path.getOrDefault("integrationAccountName")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "integrationAccountName", valid_574281
  var valid_574282 = path.getOrDefault("subscriptionId")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "subscriptionId", valid_574282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574283 = query.getOrDefault("api-version")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "api-version", valid_574283
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

proc call*(call_574285: Call_IntegrationAccountsUpdate_574277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an integration account.
  ## 
  let valid = call_574285.validator(path, query, header, formData, body)
  let scheme = call_574285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574285.url(scheme.get, call_574285.host, call_574285.base,
                         call_574285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574285, url, valid)

proc call*(call_574286: Call_IntegrationAccountsUpdate_574277;
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
  var path_574287 = newJObject()
  var query_574288 = newJObject()
  var body_574289 = newJObject()
  add(path_574287, "resourceGroupName", newJString(resourceGroupName))
  add(query_574288, "api-version", newJString(apiVersion))
  add(path_574287, "integrationAccountName", newJString(integrationAccountName))
  add(path_574287, "subscriptionId", newJString(subscriptionId))
  if integrationAccount != nil:
    body_574289 = integrationAccount
  result = call_574286.call(path_574287, query_574288, nil, nil, body_574289)

var integrationAccountsUpdate* = Call_IntegrationAccountsUpdate_574277(
    name: "integrationAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsUpdate_574278, base: "",
    url: url_IntegrationAccountsUpdate_574279, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsDelete_574266 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountsDelete_574268(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsDelete_574267(path: JsonNode; query: JsonNode;
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
  var valid_574269 = path.getOrDefault("resourceGroupName")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "resourceGroupName", valid_574269
  var valid_574270 = path.getOrDefault("integrationAccountName")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "integrationAccountName", valid_574270
  var valid_574271 = path.getOrDefault("subscriptionId")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "subscriptionId", valid_574271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574272 = query.getOrDefault("api-version")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "api-version", valid_574272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574273: Call_IntegrationAccountsDelete_574266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account.
  ## 
  let valid = call_574273.validator(path, query, header, formData, body)
  let scheme = call_574273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574273.url(scheme.get, call_574273.host, call_574273.base,
                         call_574273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574273, url, valid)

proc call*(call_574274: Call_IntegrationAccountsDelete_574266;
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
  var path_574275 = newJObject()
  var query_574276 = newJObject()
  add(path_574275, "resourceGroupName", newJString(resourceGroupName))
  add(query_574276, "api-version", newJString(apiVersion))
  add(path_574275, "integrationAccountName", newJString(integrationAccountName))
  add(path_574275, "subscriptionId", newJString(subscriptionId))
  result = call_574274.call(path_574275, query_574276, nil, nil, nil)

var integrationAccountsDelete* = Call_IntegrationAccountsDelete_574266(
    name: "integrationAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsDelete_574267, base: "",
    url: url_IntegrationAccountsDelete_574268, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsList_574290 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountAgreementsList_574292(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAgreementsList_574291(path: JsonNode;
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
  var valid_574293 = path.getOrDefault("resourceGroupName")
  valid_574293 = validateParameter(valid_574293, JString, required = true,
                                 default = nil)
  if valid_574293 != nil:
    section.add "resourceGroupName", valid_574293
  var valid_574294 = path.getOrDefault("integrationAccountName")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "integrationAccountName", valid_574294
  var valid_574295 = path.getOrDefault("subscriptionId")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "subscriptionId", valid_574295
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
  var valid_574296 = query.getOrDefault("api-version")
  valid_574296 = validateParameter(valid_574296, JString, required = true,
                                 default = nil)
  if valid_574296 != nil:
    section.add "api-version", valid_574296
  var valid_574297 = query.getOrDefault("$top")
  valid_574297 = validateParameter(valid_574297, JInt, required = false, default = nil)
  if valid_574297 != nil:
    section.add "$top", valid_574297
  var valid_574298 = query.getOrDefault("$filter")
  valid_574298 = validateParameter(valid_574298, JString, required = false,
                                 default = nil)
  if valid_574298 != nil:
    section.add "$filter", valid_574298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574299: Call_IntegrationAccountAgreementsList_574290;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account agreements.
  ## 
  let valid = call_574299.validator(path, query, header, formData, body)
  let scheme = call_574299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574299.url(scheme.get, call_574299.host, call_574299.base,
                         call_574299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574299, url, valid)

proc call*(call_574300: Call_IntegrationAccountAgreementsList_574290;
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
  var path_574301 = newJObject()
  var query_574302 = newJObject()
  add(path_574301, "resourceGroupName", newJString(resourceGroupName))
  add(query_574302, "api-version", newJString(apiVersion))
  add(path_574301, "integrationAccountName", newJString(integrationAccountName))
  add(path_574301, "subscriptionId", newJString(subscriptionId))
  add(query_574302, "$top", newJInt(Top))
  add(query_574302, "$filter", newJString(Filter))
  result = call_574300.call(path_574301, query_574302, nil, nil, nil)

var integrationAccountAgreementsList* = Call_IntegrationAccountAgreementsList_574290(
    name: "integrationAccountAgreementsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements",
    validator: validate_IntegrationAccountAgreementsList_574291, base: "",
    url: url_IntegrationAccountAgreementsList_574292, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsCreateOrUpdate_574315 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountAgreementsCreateOrUpdate_574317(protocol: Scheme;
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

proc validate_IntegrationAccountAgreementsCreateOrUpdate_574316(path: JsonNode;
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
  var valid_574318 = path.getOrDefault("resourceGroupName")
  valid_574318 = validateParameter(valid_574318, JString, required = true,
                                 default = nil)
  if valid_574318 != nil:
    section.add "resourceGroupName", valid_574318
  var valid_574319 = path.getOrDefault("integrationAccountName")
  valid_574319 = validateParameter(valid_574319, JString, required = true,
                                 default = nil)
  if valid_574319 != nil:
    section.add "integrationAccountName", valid_574319
  var valid_574320 = path.getOrDefault("subscriptionId")
  valid_574320 = validateParameter(valid_574320, JString, required = true,
                                 default = nil)
  if valid_574320 != nil:
    section.add "subscriptionId", valid_574320
  var valid_574321 = path.getOrDefault("agreementName")
  valid_574321 = validateParameter(valid_574321, JString, required = true,
                                 default = nil)
  if valid_574321 != nil:
    section.add "agreementName", valid_574321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574322 = query.getOrDefault("api-version")
  valid_574322 = validateParameter(valid_574322, JString, required = true,
                                 default = nil)
  if valid_574322 != nil:
    section.add "api-version", valid_574322
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

proc call*(call_574324: Call_IntegrationAccountAgreementsCreateOrUpdate_574315;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account agreement.
  ## 
  let valid = call_574324.validator(path, query, header, formData, body)
  let scheme = call_574324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574324.url(scheme.get, call_574324.host, call_574324.base,
                         call_574324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574324, url, valid)

proc call*(call_574325: Call_IntegrationAccountAgreementsCreateOrUpdate_574315;
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
  var path_574326 = newJObject()
  var query_574327 = newJObject()
  var body_574328 = newJObject()
  add(path_574326, "resourceGroupName", newJString(resourceGroupName))
  add(query_574327, "api-version", newJString(apiVersion))
  add(path_574326, "integrationAccountName", newJString(integrationAccountName))
  add(path_574326, "subscriptionId", newJString(subscriptionId))
  add(path_574326, "agreementName", newJString(agreementName))
  if agreement != nil:
    body_574328 = agreement
  result = call_574325.call(path_574326, query_574327, nil, nil, body_574328)

var integrationAccountAgreementsCreateOrUpdate* = Call_IntegrationAccountAgreementsCreateOrUpdate_574315(
    name: "integrationAccountAgreementsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_IntegrationAccountAgreementsCreateOrUpdate_574316,
    base: "", url: url_IntegrationAccountAgreementsCreateOrUpdate_574317,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsGet_574303 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountAgreementsGet_574305(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAgreementsGet_574304(path: JsonNode;
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
  var valid_574306 = path.getOrDefault("resourceGroupName")
  valid_574306 = validateParameter(valid_574306, JString, required = true,
                                 default = nil)
  if valid_574306 != nil:
    section.add "resourceGroupName", valid_574306
  var valid_574307 = path.getOrDefault("integrationAccountName")
  valid_574307 = validateParameter(valid_574307, JString, required = true,
                                 default = nil)
  if valid_574307 != nil:
    section.add "integrationAccountName", valid_574307
  var valid_574308 = path.getOrDefault("subscriptionId")
  valid_574308 = validateParameter(valid_574308, JString, required = true,
                                 default = nil)
  if valid_574308 != nil:
    section.add "subscriptionId", valid_574308
  var valid_574309 = path.getOrDefault("agreementName")
  valid_574309 = validateParameter(valid_574309, JString, required = true,
                                 default = nil)
  if valid_574309 != nil:
    section.add "agreementName", valid_574309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574310 = query.getOrDefault("api-version")
  valid_574310 = validateParameter(valid_574310, JString, required = true,
                                 default = nil)
  if valid_574310 != nil:
    section.add "api-version", valid_574310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574311: Call_IntegrationAccountAgreementsGet_574303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an integration account agreement.
  ## 
  let valid = call_574311.validator(path, query, header, formData, body)
  let scheme = call_574311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574311.url(scheme.get, call_574311.host, call_574311.base,
                         call_574311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574311, url, valid)

proc call*(call_574312: Call_IntegrationAccountAgreementsGet_574303;
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
  var path_574313 = newJObject()
  var query_574314 = newJObject()
  add(path_574313, "resourceGroupName", newJString(resourceGroupName))
  add(query_574314, "api-version", newJString(apiVersion))
  add(path_574313, "integrationAccountName", newJString(integrationAccountName))
  add(path_574313, "subscriptionId", newJString(subscriptionId))
  add(path_574313, "agreementName", newJString(agreementName))
  result = call_574312.call(path_574313, query_574314, nil, nil, nil)

var integrationAccountAgreementsGet* = Call_IntegrationAccountAgreementsGet_574303(
    name: "integrationAccountAgreementsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_IntegrationAccountAgreementsGet_574304, base: "",
    url: url_IntegrationAccountAgreementsGet_574305, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsDelete_574329 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountAgreementsDelete_574331(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAgreementsDelete_574330(path: JsonNode;
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
  var valid_574332 = path.getOrDefault("resourceGroupName")
  valid_574332 = validateParameter(valid_574332, JString, required = true,
                                 default = nil)
  if valid_574332 != nil:
    section.add "resourceGroupName", valid_574332
  var valid_574333 = path.getOrDefault("integrationAccountName")
  valid_574333 = validateParameter(valid_574333, JString, required = true,
                                 default = nil)
  if valid_574333 != nil:
    section.add "integrationAccountName", valid_574333
  var valid_574334 = path.getOrDefault("subscriptionId")
  valid_574334 = validateParameter(valid_574334, JString, required = true,
                                 default = nil)
  if valid_574334 != nil:
    section.add "subscriptionId", valid_574334
  var valid_574335 = path.getOrDefault("agreementName")
  valid_574335 = validateParameter(valid_574335, JString, required = true,
                                 default = nil)
  if valid_574335 != nil:
    section.add "agreementName", valid_574335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574336 = query.getOrDefault("api-version")
  valid_574336 = validateParameter(valid_574336, JString, required = true,
                                 default = nil)
  if valid_574336 != nil:
    section.add "api-version", valid_574336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574337: Call_IntegrationAccountAgreementsDelete_574329;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account agreement.
  ## 
  let valid = call_574337.validator(path, query, header, formData, body)
  let scheme = call_574337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574337.url(scheme.get, call_574337.host, call_574337.base,
                         call_574337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574337, url, valid)

proc call*(call_574338: Call_IntegrationAccountAgreementsDelete_574329;
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
  var path_574339 = newJObject()
  var query_574340 = newJObject()
  add(path_574339, "resourceGroupName", newJString(resourceGroupName))
  add(query_574340, "api-version", newJString(apiVersion))
  add(path_574339, "integrationAccountName", newJString(integrationAccountName))
  add(path_574339, "subscriptionId", newJString(subscriptionId))
  add(path_574339, "agreementName", newJString(agreementName))
  result = call_574338.call(path_574339, query_574340, nil, nil, nil)

var integrationAccountAgreementsDelete* = Call_IntegrationAccountAgreementsDelete_574329(
    name: "integrationAccountAgreementsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_IntegrationAccountAgreementsDelete_574330, base: "",
    url: url_IntegrationAccountAgreementsDelete_574331, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsListContentCallbackUrl_574341 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountAgreementsListContentCallbackUrl_574343(
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

proc validate_IntegrationAccountAgreementsListContentCallbackUrl_574342(
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
  var valid_574344 = path.getOrDefault("resourceGroupName")
  valid_574344 = validateParameter(valid_574344, JString, required = true,
                                 default = nil)
  if valid_574344 != nil:
    section.add "resourceGroupName", valid_574344
  var valid_574345 = path.getOrDefault("integrationAccountName")
  valid_574345 = validateParameter(valid_574345, JString, required = true,
                                 default = nil)
  if valid_574345 != nil:
    section.add "integrationAccountName", valid_574345
  var valid_574346 = path.getOrDefault("subscriptionId")
  valid_574346 = validateParameter(valid_574346, JString, required = true,
                                 default = nil)
  if valid_574346 != nil:
    section.add "subscriptionId", valid_574346
  var valid_574347 = path.getOrDefault("agreementName")
  valid_574347 = validateParameter(valid_574347, JString, required = true,
                                 default = nil)
  if valid_574347 != nil:
    section.add "agreementName", valid_574347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574348 = query.getOrDefault("api-version")
  valid_574348 = validateParameter(valid_574348, JString, required = true,
                                 default = nil)
  if valid_574348 != nil:
    section.add "api-version", valid_574348
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

proc call*(call_574350: Call_IntegrationAccountAgreementsListContentCallbackUrl_574341;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_574350.validator(path, query, header, formData, body)
  let scheme = call_574350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574350.url(scheme.get, call_574350.host, call_574350.base,
                         call_574350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574350, url, valid)

proc call*(call_574351: Call_IntegrationAccountAgreementsListContentCallbackUrl_574341;
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
  var path_574352 = newJObject()
  var query_574353 = newJObject()
  var body_574354 = newJObject()
  add(path_574352, "resourceGroupName", newJString(resourceGroupName))
  add(query_574353, "api-version", newJString(apiVersion))
  add(path_574352, "integrationAccountName", newJString(integrationAccountName))
  add(path_574352, "subscriptionId", newJString(subscriptionId))
  add(path_574352, "agreementName", newJString(agreementName))
  if listContentCallbackUrl != nil:
    body_574354 = listContentCallbackUrl
  result = call_574351.call(path_574352, query_574353, nil, nil, body_574354)

var integrationAccountAgreementsListContentCallbackUrl* = Call_IntegrationAccountAgreementsListContentCallbackUrl_574341(
    name: "integrationAccountAgreementsListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountAgreementsListContentCallbackUrl_574342,
    base: "", url: url_IntegrationAccountAgreementsListContentCallbackUrl_574343,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesList_574355 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountAssembliesList_574357(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAssembliesList_574356(path: JsonNode;
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
  var valid_574358 = path.getOrDefault("resourceGroupName")
  valid_574358 = validateParameter(valid_574358, JString, required = true,
                                 default = nil)
  if valid_574358 != nil:
    section.add "resourceGroupName", valid_574358
  var valid_574359 = path.getOrDefault("integrationAccountName")
  valid_574359 = validateParameter(valid_574359, JString, required = true,
                                 default = nil)
  if valid_574359 != nil:
    section.add "integrationAccountName", valid_574359
  var valid_574360 = path.getOrDefault("subscriptionId")
  valid_574360 = validateParameter(valid_574360, JString, required = true,
                                 default = nil)
  if valid_574360 != nil:
    section.add "subscriptionId", valid_574360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574361 = query.getOrDefault("api-version")
  valid_574361 = validateParameter(valid_574361, JString, required = true,
                                 default = nil)
  if valid_574361 != nil:
    section.add "api-version", valid_574361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574362: Call_IntegrationAccountAssembliesList_574355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the assemblies for an integration account.
  ## 
  let valid = call_574362.validator(path, query, header, formData, body)
  let scheme = call_574362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574362.url(scheme.get, call_574362.host, call_574362.base,
                         call_574362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574362, url, valid)

proc call*(call_574363: Call_IntegrationAccountAssembliesList_574355;
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
  var path_574364 = newJObject()
  var query_574365 = newJObject()
  add(path_574364, "resourceGroupName", newJString(resourceGroupName))
  add(query_574365, "api-version", newJString(apiVersion))
  add(path_574364, "integrationAccountName", newJString(integrationAccountName))
  add(path_574364, "subscriptionId", newJString(subscriptionId))
  result = call_574363.call(path_574364, query_574365, nil, nil, nil)

var integrationAccountAssembliesList* = Call_IntegrationAccountAssembliesList_574355(
    name: "integrationAccountAssembliesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies",
    validator: validate_IntegrationAccountAssembliesList_574356, base: "",
    url: url_IntegrationAccountAssembliesList_574357, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesCreateOrUpdate_574378 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountAssembliesCreateOrUpdate_574380(protocol: Scheme;
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

proc validate_IntegrationAccountAssembliesCreateOrUpdate_574379(path: JsonNode;
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
  var valid_574381 = path.getOrDefault("resourceGroupName")
  valid_574381 = validateParameter(valid_574381, JString, required = true,
                                 default = nil)
  if valid_574381 != nil:
    section.add "resourceGroupName", valid_574381
  var valid_574382 = path.getOrDefault("integrationAccountName")
  valid_574382 = validateParameter(valid_574382, JString, required = true,
                                 default = nil)
  if valid_574382 != nil:
    section.add "integrationAccountName", valid_574382
  var valid_574383 = path.getOrDefault("subscriptionId")
  valid_574383 = validateParameter(valid_574383, JString, required = true,
                                 default = nil)
  if valid_574383 != nil:
    section.add "subscriptionId", valid_574383
  var valid_574384 = path.getOrDefault("assemblyArtifactName")
  valid_574384 = validateParameter(valid_574384, JString, required = true,
                                 default = nil)
  if valid_574384 != nil:
    section.add "assemblyArtifactName", valid_574384
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574385 = query.getOrDefault("api-version")
  valid_574385 = validateParameter(valid_574385, JString, required = true,
                                 default = nil)
  if valid_574385 != nil:
    section.add "api-version", valid_574385
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

proc call*(call_574387: Call_IntegrationAccountAssembliesCreateOrUpdate_574378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an assembly for an integration account.
  ## 
  let valid = call_574387.validator(path, query, header, formData, body)
  let scheme = call_574387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574387.url(scheme.get, call_574387.host, call_574387.base,
                         call_574387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574387, url, valid)

proc call*(call_574388: Call_IntegrationAccountAssembliesCreateOrUpdate_574378;
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
  var path_574389 = newJObject()
  var query_574390 = newJObject()
  var body_574391 = newJObject()
  add(path_574389, "resourceGroupName", newJString(resourceGroupName))
  add(query_574390, "api-version", newJString(apiVersion))
  add(path_574389, "integrationAccountName", newJString(integrationAccountName))
  add(path_574389, "subscriptionId", newJString(subscriptionId))
  if assemblyArtifact != nil:
    body_574391 = assemblyArtifact
  add(path_574389, "assemblyArtifactName", newJString(assemblyArtifactName))
  result = call_574388.call(path_574389, query_574390, nil, nil, body_574391)

var integrationAccountAssembliesCreateOrUpdate* = Call_IntegrationAccountAssembliesCreateOrUpdate_574378(
    name: "integrationAccountAssembliesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}",
    validator: validate_IntegrationAccountAssembliesCreateOrUpdate_574379,
    base: "", url: url_IntegrationAccountAssembliesCreateOrUpdate_574380,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesGet_574366 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountAssembliesGet_574368(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAssembliesGet_574367(path: JsonNode;
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
  var valid_574369 = path.getOrDefault("resourceGroupName")
  valid_574369 = validateParameter(valid_574369, JString, required = true,
                                 default = nil)
  if valid_574369 != nil:
    section.add "resourceGroupName", valid_574369
  var valid_574370 = path.getOrDefault("integrationAccountName")
  valid_574370 = validateParameter(valid_574370, JString, required = true,
                                 default = nil)
  if valid_574370 != nil:
    section.add "integrationAccountName", valid_574370
  var valid_574371 = path.getOrDefault("subscriptionId")
  valid_574371 = validateParameter(valid_574371, JString, required = true,
                                 default = nil)
  if valid_574371 != nil:
    section.add "subscriptionId", valid_574371
  var valid_574372 = path.getOrDefault("assemblyArtifactName")
  valid_574372 = validateParameter(valid_574372, JString, required = true,
                                 default = nil)
  if valid_574372 != nil:
    section.add "assemblyArtifactName", valid_574372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574373 = query.getOrDefault("api-version")
  valid_574373 = validateParameter(valid_574373, JString, required = true,
                                 default = nil)
  if valid_574373 != nil:
    section.add "api-version", valid_574373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574374: Call_IntegrationAccountAssembliesGet_574366;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an assembly for an integration account.
  ## 
  let valid = call_574374.validator(path, query, header, formData, body)
  let scheme = call_574374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574374.url(scheme.get, call_574374.host, call_574374.base,
                         call_574374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574374, url, valid)

proc call*(call_574375: Call_IntegrationAccountAssembliesGet_574366;
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
  var path_574376 = newJObject()
  var query_574377 = newJObject()
  add(path_574376, "resourceGroupName", newJString(resourceGroupName))
  add(query_574377, "api-version", newJString(apiVersion))
  add(path_574376, "integrationAccountName", newJString(integrationAccountName))
  add(path_574376, "subscriptionId", newJString(subscriptionId))
  add(path_574376, "assemblyArtifactName", newJString(assemblyArtifactName))
  result = call_574375.call(path_574376, query_574377, nil, nil, nil)

var integrationAccountAssembliesGet* = Call_IntegrationAccountAssembliesGet_574366(
    name: "integrationAccountAssembliesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}",
    validator: validate_IntegrationAccountAssembliesGet_574367, base: "",
    url: url_IntegrationAccountAssembliesGet_574368, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesDelete_574392 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountAssembliesDelete_574394(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAssembliesDelete_574393(path: JsonNode;
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
  var valid_574395 = path.getOrDefault("resourceGroupName")
  valid_574395 = validateParameter(valid_574395, JString, required = true,
                                 default = nil)
  if valid_574395 != nil:
    section.add "resourceGroupName", valid_574395
  var valid_574396 = path.getOrDefault("integrationAccountName")
  valid_574396 = validateParameter(valid_574396, JString, required = true,
                                 default = nil)
  if valid_574396 != nil:
    section.add "integrationAccountName", valid_574396
  var valid_574397 = path.getOrDefault("subscriptionId")
  valid_574397 = validateParameter(valid_574397, JString, required = true,
                                 default = nil)
  if valid_574397 != nil:
    section.add "subscriptionId", valid_574397
  var valid_574398 = path.getOrDefault("assemblyArtifactName")
  valid_574398 = validateParameter(valid_574398, JString, required = true,
                                 default = nil)
  if valid_574398 != nil:
    section.add "assemblyArtifactName", valid_574398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574399 = query.getOrDefault("api-version")
  valid_574399 = validateParameter(valid_574399, JString, required = true,
                                 default = nil)
  if valid_574399 != nil:
    section.add "api-version", valid_574399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574400: Call_IntegrationAccountAssembliesDelete_574392;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an assembly for an integration account.
  ## 
  let valid = call_574400.validator(path, query, header, formData, body)
  let scheme = call_574400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574400.url(scheme.get, call_574400.host, call_574400.base,
                         call_574400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574400, url, valid)

proc call*(call_574401: Call_IntegrationAccountAssembliesDelete_574392;
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
  var path_574402 = newJObject()
  var query_574403 = newJObject()
  add(path_574402, "resourceGroupName", newJString(resourceGroupName))
  add(query_574403, "api-version", newJString(apiVersion))
  add(path_574402, "integrationAccountName", newJString(integrationAccountName))
  add(path_574402, "subscriptionId", newJString(subscriptionId))
  add(path_574402, "assemblyArtifactName", newJString(assemblyArtifactName))
  result = call_574401.call(path_574402, query_574403, nil, nil, nil)

var integrationAccountAssembliesDelete* = Call_IntegrationAccountAssembliesDelete_574392(
    name: "integrationAccountAssembliesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}",
    validator: validate_IntegrationAccountAssembliesDelete_574393, base: "",
    url: url_IntegrationAccountAssembliesDelete_574394, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesListContentCallbackUrl_574404 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountAssembliesListContentCallbackUrl_574406(
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

proc validate_IntegrationAccountAssembliesListContentCallbackUrl_574405(
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
  var valid_574407 = path.getOrDefault("resourceGroupName")
  valid_574407 = validateParameter(valid_574407, JString, required = true,
                                 default = nil)
  if valid_574407 != nil:
    section.add "resourceGroupName", valid_574407
  var valid_574408 = path.getOrDefault("integrationAccountName")
  valid_574408 = validateParameter(valid_574408, JString, required = true,
                                 default = nil)
  if valid_574408 != nil:
    section.add "integrationAccountName", valid_574408
  var valid_574409 = path.getOrDefault("subscriptionId")
  valid_574409 = validateParameter(valid_574409, JString, required = true,
                                 default = nil)
  if valid_574409 != nil:
    section.add "subscriptionId", valid_574409
  var valid_574410 = path.getOrDefault("assemblyArtifactName")
  valid_574410 = validateParameter(valid_574410, JString, required = true,
                                 default = nil)
  if valid_574410 != nil:
    section.add "assemblyArtifactName", valid_574410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574411 = query.getOrDefault("api-version")
  valid_574411 = validateParameter(valid_574411, JString, required = true,
                                 default = nil)
  if valid_574411 != nil:
    section.add "api-version", valid_574411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574412: Call_IntegrationAccountAssembliesListContentCallbackUrl_574404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url for an integration account assembly.
  ## 
  let valid = call_574412.validator(path, query, header, formData, body)
  let scheme = call_574412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574412.url(scheme.get, call_574412.host, call_574412.base,
                         call_574412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574412, url, valid)

proc call*(call_574413: Call_IntegrationAccountAssembliesListContentCallbackUrl_574404;
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
  var path_574414 = newJObject()
  var query_574415 = newJObject()
  add(path_574414, "resourceGroupName", newJString(resourceGroupName))
  add(query_574415, "api-version", newJString(apiVersion))
  add(path_574414, "integrationAccountName", newJString(integrationAccountName))
  add(path_574414, "subscriptionId", newJString(subscriptionId))
  add(path_574414, "assemblyArtifactName", newJString(assemblyArtifactName))
  result = call_574413.call(path_574414, query_574415, nil, nil, nil)

var integrationAccountAssembliesListContentCallbackUrl* = Call_IntegrationAccountAssembliesListContentCallbackUrl_574404(
    name: "integrationAccountAssembliesListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountAssembliesListContentCallbackUrl_574405,
    base: "", url: url_IntegrationAccountAssembliesListContentCallbackUrl_574406,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsList_574416 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountBatchConfigurationsList_574418(protocol: Scheme;
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

proc validate_IntegrationAccountBatchConfigurationsList_574417(path: JsonNode;
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
  var valid_574419 = path.getOrDefault("resourceGroupName")
  valid_574419 = validateParameter(valid_574419, JString, required = true,
                                 default = nil)
  if valid_574419 != nil:
    section.add "resourceGroupName", valid_574419
  var valid_574420 = path.getOrDefault("integrationAccountName")
  valid_574420 = validateParameter(valid_574420, JString, required = true,
                                 default = nil)
  if valid_574420 != nil:
    section.add "integrationAccountName", valid_574420
  var valid_574421 = path.getOrDefault("subscriptionId")
  valid_574421 = validateParameter(valid_574421, JString, required = true,
                                 default = nil)
  if valid_574421 != nil:
    section.add "subscriptionId", valid_574421
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574422 = query.getOrDefault("api-version")
  valid_574422 = validateParameter(valid_574422, JString, required = true,
                                 default = nil)
  if valid_574422 != nil:
    section.add "api-version", valid_574422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574423: Call_IntegrationAccountBatchConfigurationsList_574416;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the batch configurations for an integration account.
  ## 
  let valid = call_574423.validator(path, query, header, formData, body)
  let scheme = call_574423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574423.url(scheme.get, call_574423.host, call_574423.base,
                         call_574423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574423, url, valid)

proc call*(call_574424: Call_IntegrationAccountBatchConfigurationsList_574416;
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
  var path_574425 = newJObject()
  var query_574426 = newJObject()
  add(path_574425, "resourceGroupName", newJString(resourceGroupName))
  add(query_574426, "api-version", newJString(apiVersion))
  add(path_574425, "integrationAccountName", newJString(integrationAccountName))
  add(path_574425, "subscriptionId", newJString(subscriptionId))
  result = call_574424.call(path_574425, query_574426, nil, nil, nil)

var integrationAccountBatchConfigurationsList* = Call_IntegrationAccountBatchConfigurationsList_574416(
    name: "integrationAccountBatchConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations",
    validator: validate_IntegrationAccountBatchConfigurationsList_574417,
    base: "", url: url_IntegrationAccountBatchConfigurationsList_574418,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_574439 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountBatchConfigurationsCreateOrUpdate_574441(
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

proc validate_IntegrationAccountBatchConfigurationsCreateOrUpdate_574440(
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
  var valid_574442 = path.getOrDefault("resourceGroupName")
  valid_574442 = validateParameter(valid_574442, JString, required = true,
                                 default = nil)
  if valid_574442 != nil:
    section.add "resourceGroupName", valid_574442
  var valid_574443 = path.getOrDefault("integrationAccountName")
  valid_574443 = validateParameter(valid_574443, JString, required = true,
                                 default = nil)
  if valid_574443 != nil:
    section.add "integrationAccountName", valid_574443
  var valid_574444 = path.getOrDefault("subscriptionId")
  valid_574444 = validateParameter(valid_574444, JString, required = true,
                                 default = nil)
  if valid_574444 != nil:
    section.add "subscriptionId", valid_574444
  var valid_574445 = path.getOrDefault("batchConfigurationName")
  valid_574445 = validateParameter(valid_574445, JString, required = true,
                                 default = nil)
  if valid_574445 != nil:
    section.add "batchConfigurationName", valid_574445
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574446 = query.getOrDefault("api-version")
  valid_574446 = validateParameter(valid_574446, JString, required = true,
                                 default = nil)
  if valid_574446 != nil:
    section.add "api-version", valid_574446
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

proc call*(call_574448: Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_574439;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a batch configuration for an integration account.
  ## 
  let valid = call_574448.validator(path, query, header, formData, body)
  let scheme = call_574448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574448.url(scheme.get, call_574448.host, call_574448.base,
                         call_574448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574448, url, valid)

proc call*(call_574449: Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_574439;
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
  var path_574450 = newJObject()
  var query_574451 = newJObject()
  var body_574452 = newJObject()
  add(path_574450, "resourceGroupName", newJString(resourceGroupName))
  add(query_574451, "api-version", newJString(apiVersion))
  add(path_574450, "integrationAccountName", newJString(integrationAccountName))
  add(path_574450, "subscriptionId", newJString(subscriptionId))
  add(path_574450, "batchConfigurationName", newJString(batchConfigurationName))
  if batchConfiguration != nil:
    body_574452 = batchConfiguration
  result = call_574449.call(path_574450, query_574451, nil, nil, body_574452)

var integrationAccountBatchConfigurationsCreateOrUpdate* = Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_574439(
    name: "integrationAccountBatchConfigurationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations/{batchConfigurationName}",
    validator: validate_IntegrationAccountBatchConfigurationsCreateOrUpdate_574440,
    base: "", url: url_IntegrationAccountBatchConfigurationsCreateOrUpdate_574441,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsGet_574427 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountBatchConfigurationsGet_574429(protocol: Scheme;
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

proc validate_IntegrationAccountBatchConfigurationsGet_574428(path: JsonNode;
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
  var valid_574430 = path.getOrDefault("resourceGroupName")
  valid_574430 = validateParameter(valid_574430, JString, required = true,
                                 default = nil)
  if valid_574430 != nil:
    section.add "resourceGroupName", valid_574430
  var valid_574431 = path.getOrDefault("integrationAccountName")
  valid_574431 = validateParameter(valid_574431, JString, required = true,
                                 default = nil)
  if valid_574431 != nil:
    section.add "integrationAccountName", valid_574431
  var valid_574432 = path.getOrDefault("subscriptionId")
  valid_574432 = validateParameter(valid_574432, JString, required = true,
                                 default = nil)
  if valid_574432 != nil:
    section.add "subscriptionId", valid_574432
  var valid_574433 = path.getOrDefault("batchConfigurationName")
  valid_574433 = validateParameter(valid_574433, JString, required = true,
                                 default = nil)
  if valid_574433 != nil:
    section.add "batchConfigurationName", valid_574433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574434 = query.getOrDefault("api-version")
  valid_574434 = validateParameter(valid_574434, JString, required = true,
                                 default = nil)
  if valid_574434 != nil:
    section.add "api-version", valid_574434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574435: Call_IntegrationAccountBatchConfigurationsGet_574427;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a batch configuration for an integration account.
  ## 
  let valid = call_574435.validator(path, query, header, formData, body)
  let scheme = call_574435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574435.url(scheme.get, call_574435.host, call_574435.base,
                         call_574435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574435, url, valid)

proc call*(call_574436: Call_IntegrationAccountBatchConfigurationsGet_574427;
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
  var path_574437 = newJObject()
  var query_574438 = newJObject()
  add(path_574437, "resourceGroupName", newJString(resourceGroupName))
  add(query_574438, "api-version", newJString(apiVersion))
  add(path_574437, "integrationAccountName", newJString(integrationAccountName))
  add(path_574437, "subscriptionId", newJString(subscriptionId))
  add(path_574437, "batchConfigurationName", newJString(batchConfigurationName))
  result = call_574436.call(path_574437, query_574438, nil, nil, nil)

var integrationAccountBatchConfigurationsGet* = Call_IntegrationAccountBatchConfigurationsGet_574427(
    name: "integrationAccountBatchConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations/{batchConfigurationName}",
    validator: validate_IntegrationAccountBatchConfigurationsGet_574428, base: "",
    url: url_IntegrationAccountBatchConfigurationsGet_574429,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsDelete_574453 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountBatchConfigurationsDelete_574455(protocol: Scheme;
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

proc validate_IntegrationAccountBatchConfigurationsDelete_574454(path: JsonNode;
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
  var valid_574456 = path.getOrDefault("resourceGroupName")
  valid_574456 = validateParameter(valid_574456, JString, required = true,
                                 default = nil)
  if valid_574456 != nil:
    section.add "resourceGroupName", valid_574456
  var valid_574457 = path.getOrDefault("integrationAccountName")
  valid_574457 = validateParameter(valid_574457, JString, required = true,
                                 default = nil)
  if valid_574457 != nil:
    section.add "integrationAccountName", valid_574457
  var valid_574458 = path.getOrDefault("subscriptionId")
  valid_574458 = validateParameter(valid_574458, JString, required = true,
                                 default = nil)
  if valid_574458 != nil:
    section.add "subscriptionId", valid_574458
  var valid_574459 = path.getOrDefault("batchConfigurationName")
  valid_574459 = validateParameter(valid_574459, JString, required = true,
                                 default = nil)
  if valid_574459 != nil:
    section.add "batchConfigurationName", valid_574459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574460 = query.getOrDefault("api-version")
  valid_574460 = validateParameter(valid_574460, JString, required = true,
                                 default = nil)
  if valid_574460 != nil:
    section.add "api-version", valid_574460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574461: Call_IntegrationAccountBatchConfigurationsDelete_574453;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a batch configuration for an integration account.
  ## 
  let valid = call_574461.validator(path, query, header, formData, body)
  let scheme = call_574461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574461.url(scheme.get, call_574461.host, call_574461.base,
                         call_574461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574461, url, valid)

proc call*(call_574462: Call_IntegrationAccountBatchConfigurationsDelete_574453;
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
  var path_574463 = newJObject()
  var query_574464 = newJObject()
  add(path_574463, "resourceGroupName", newJString(resourceGroupName))
  add(query_574464, "api-version", newJString(apiVersion))
  add(path_574463, "integrationAccountName", newJString(integrationAccountName))
  add(path_574463, "subscriptionId", newJString(subscriptionId))
  add(path_574463, "batchConfigurationName", newJString(batchConfigurationName))
  result = call_574462.call(path_574463, query_574464, nil, nil, nil)

var integrationAccountBatchConfigurationsDelete* = Call_IntegrationAccountBatchConfigurationsDelete_574453(
    name: "integrationAccountBatchConfigurationsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations/{batchConfigurationName}",
    validator: validate_IntegrationAccountBatchConfigurationsDelete_574454,
    base: "", url: url_IntegrationAccountBatchConfigurationsDelete_574455,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesList_574465 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountCertificatesList_574467(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountCertificatesList_574466(path: JsonNode;
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
  var valid_574468 = path.getOrDefault("resourceGroupName")
  valid_574468 = validateParameter(valid_574468, JString, required = true,
                                 default = nil)
  if valid_574468 != nil:
    section.add "resourceGroupName", valid_574468
  var valid_574469 = path.getOrDefault("integrationAccountName")
  valid_574469 = validateParameter(valid_574469, JString, required = true,
                                 default = nil)
  if valid_574469 != nil:
    section.add "integrationAccountName", valid_574469
  var valid_574470 = path.getOrDefault("subscriptionId")
  valid_574470 = validateParameter(valid_574470, JString, required = true,
                                 default = nil)
  if valid_574470 != nil:
    section.add "subscriptionId", valid_574470
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574471 = query.getOrDefault("api-version")
  valid_574471 = validateParameter(valid_574471, JString, required = true,
                                 default = nil)
  if valid_574471 != nil:
    section.add "api-version", valid_574471
  var valid_574472 = query.getOrDefault("$top")
  valid_574472 = validateParameter(valid_574472, JInt, required = false, default = nil)
  if valid_574472 != nil:
    section.add "$top", valid_574472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574473: Call_IntegrationAccountCertificatesList_574465;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account certificates.
  ## 
  let valid = call_574473.validator(path, query, header, formData, body)
  let scheme = call_574473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574473.url(scheme.get, call_574473.host, call_574473.base,
                         call_574473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574473, url, valid)

proc call*(call_574474: Call_IntegrationAccountCertificatesList_574465;
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
  var path_574475 = newJObject()
  var query_574476 = newJObject()
  add(path_574475, "resourceGroupName", newJString(resourceGroupName))
  add(query_574476, "api-version", newJString(apiVersion))
  add(path_574475, "integrationAccountName", newJString(integrationAccountName))
  add(path_574475, "subscriptionId", newJString(subscriptionId))
  add(query_574476, "$top", newJInt(Top))
  result = call_574474.call(path_574475, query_574476, nil, nil, nil)

var integrationAccountCertificatesList* = Call_IntegrationAccountCertificatesList_574465(
    name: "integrationAccountCertificatesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates",
    validator: validate_IntegrationAccountCertificatesList_574466, base: "",
    url: url_IntegrationAccountCertificatesList_574467, schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesCreateOrUpdate_574489 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountCertificatesCreateOrUpdate_574491(protocol: Scheme;
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

proc validate_IntegrationAccountCertificatesCreateOrUpdate_574490(path: JsonNode;
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
  var valid_574492 = path.getOrDefault("resourceGroupName")
  valid_574492 = validateParameter(valid_574492, JString, required = true,
                                 default = nil)
  if valid_574492 != nil:
    section.add "resourceGroupName", valid_574492
  var valid_574493 = path.getOrDefault("integrationAccountName")
  valid_574493 = validateParameter(valid_574493, JString, required = true,
                                 default = nil)
  if valid_574493 != nil:
    section.add "integrationAccountName", valid_574493
  var valid_574494 = path.getOrDefault("subscriptionId")
  valid_574494 = validateParameter(valid_574494, JString, required = true,
                                 default = nil)
  if valid_574494 != nil:
    section.add "subscriptionId", valid_574494
  var valid_574495 = path.getOrDefault("certificateName")
  valid_574495 = validateParameter(valid_574495, JString, required = true,
                                 default = nil)
  if valid_574495 != nil:
    section.add "certificateName", valid_574495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574496 = query.getOrDefault("api-version")
  valid_574496 = validateParameter(valid_574496, JString, required = true,
                                 default = nil)
  if valid_574496 != nil:
    section.add "api-version", valid_574496
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

proc call*(call_574498: Call_IntegrationAccountCertificatesCreateOrUpdate_574489;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account certificate.
  ## 
  let valid = call_574498.validator(path, query, header, formData, body)
  let scheme = call_574498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574498.url(scheme.get, call_574498.host, call_574498.base,
                         call_574498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574498, url, valid)

proc call*(call_574499: Call_IntegrationAccountCertificatesCreateOrUpdate_574489;
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
  var path_574500 = newJObject()
  var query_574501 = newJObject()
  var body_574502 = newJObject()
  add(path_574500, "resourceGroupName", newJString(resourceGroupName))
  add(query_574501, "api-version", newJString(apiVersion))
  add(path_574500, "integrationAccountName", newJString(integrationAccountName))
  add(path_574500, "subscriptionId", newJString(subscriptionId))
  if certificate != nil:
    body_574502 = certificate
  add(path_574500, "certificateName", newJString(certificateName))
  result = call_574499.call(path_574500, query_574501, nil, nil, body_574502)

var integrationAccountCertificatesCreateOrUpdate* = Call_IntegrationAccountCertificatesCreateOrUpdate_574489(
    name: "integrationAccountCertificatesCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_IntegrationAccountCertificatesCreateOrUpdate_574490,
    base: "", url: url_IntegrationAccountCertificatesCreateOrUpdate_574491,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesGet_574477 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountCertificatesGet_574479(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountCertificatesGet_574478(path: JsonNode;
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
  var valid_574480 = path.getOrDefault("resourceGroupName")
  valid_574480 = validateParameter(valid_574480, JString, required = true,
                                 default = nil)
  if valid_574480 != nil:
    section.add "resourceGroupName", valid_574480
  var valid_574481 = path.getOrDefault("integrationAccountName")
  valid_574481 = validateParameter(valid_574481, JString, required = true,
                                 default = nil)
  if valid_574481 != nil:
    section.add "integrationAccountName", valid_574481
  var valid_574482 = path.getOrDefault("subscriptionId")
  valid_574482 = validateParameter(valid_574482, JString, required = true,
                                 default = nil)
  if valid_574482 != nil:
    section.add "subscriptionId", valid_574482
  var valid_574483 = path.getOrDefault("certificateName")
  valid_574483 = validateParameter(valid_574483, JString, required = true,
                                 default = nil)
  if valid_574483 != nil:
    section.add "certificateName", valid_574483
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574484 = query.getOrDefault("api-version")
  valid_574484 = validateParameter(valid_574484, JString, required = true,
                                 default = nil)
  if valid_574484 != nil:
    section.add "api-version", valid_574484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574485: Call_IntegrationAccountCertificatesGet_574477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an integration account certificate.
  ## 
  let valid = call_574485.validator(path, query, header, formData, body)
  let scheme = call_574485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574485.url(scheme.get, call_574485.host, call_574485.base,
                         call_574485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574485, url, valid)

proc call*(call_574486: Call_IntegrationAccountCertificatesGet_574477;
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
  var path_574487 = newJObject()
  var query_574488 = newJObject()
  add(path_574487, "resourceGroupName", newJString(resourceGroupName))
  add(query_574488, "api-version", newJString(apiVersion))
  add(path_574487, "integrationAccountName", newJString(integrationAccountName))
  add(path_574487, "subscriptionId", newJString(subscriptionId))
  add(path_574487, "certificateName", newJString(certificateName))
  result = call_574486.call(path_574487, query_574488, nil, nil, nil)

var integrationAccountCertificatesGet* = Call_IntegrationAccountCertificatesGet_574477(
    name: "integrationAccountCertificatesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_IntegrationAccountCertificatesGet_574478, base: "",
    url: url_IntegrationAccountCertificatesGet_574479, schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesDelete_574503 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountCertificatesDelete_574505(protocol: Scheme;
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

proc validate_IntegrationAccountCertificatesDelete_574504(path: JsonNode;
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
  var valid_574506 = path.getOrDefault("resourceGroupName")
  valid_574506 = validateParameter(valid_574506, JString, required = true,
                                 default = nil)
  if valid_574506 != nil:
    section.add "resourceGroupName", valid_574506
  var valid_574507 = path.getOrDefault("integrationAccountName")
  valid_574507 = validateParameter(valid_574507, JString, required = true,
                                 default = nil)
  if valid_574507 != nil:
    section.add "integrationAccountName", valid_574507
  var valid_574508 = path.getOrDefault("subscriptionId")
  valid_574508 = validateParameter(valid_574508, JString, required = true,
                                 default = nil)
  if valid_574508 != nil:
    section.add "subscriptionId", valid_574508
  var valid_574509 = path.getOrDefault("certificateName")
  valid_574509 = validateParameter(valid_574509, JString, required = true,
                                 default = nil)
  if valid_574509 != nil:
    section.add "certificateName", valid_574509
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574510 = query.getOrDefault("api-version")
  valid_574510 = validateParameter(valid_574510, JString, required = true,
                                 default = nil)
  if valid_574510 != nil:
    section.add "api-version", valid_574510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574511: Call_IntegrationAccountCertificatesDelete_574503;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account certificate.
  ## 
  let valid = call_574511.validator(path, query, header, formData, body)
  let scheme = call_574511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574511.url(scheme.get, call_574511.host, call_574511.base,
                         call_574511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574511, url, valid)

proc call*(call_574512: Call_IntegrationAccountCertificatesDelete_574503;
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
  var path_574513 = newJObject()
  var query_574514 = newJObject()
  add(path_574513, "resourceGroupName", newJString(resourceGroupName))
  add(query_574514, "api-version", newJString(apiVersion))
  add(path_574513, "integrationAccountName", newJString(integrationAccountName))
  add(path_574513, "subscriptionId", newJString(subscriptionId))
  add(path_574513, "certificateName", newJString(certificateName))
  result = call_574512.call(path_574513, query_574514, nil, nil, nil)

var integrationAccountCertificatesDelete* = Call_IntegrationAccountCertificatesDelete_574503(
    name: "integrationAccountCertificatesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_IntegrationAccountCertificatesDelete_574504, base: "",
    url: url_IntegrationAccountCertificatesDelete_574505, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListCallbackUrl_574515 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountsListCallbackUrl_574517(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsListCallbackUrl_574516(path: JsonNode;
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
  var valid_574518 = path.getOrDefault("resourceGroupName")
  valid_574518 = validateParameter(valid_574518, JString, required = true,
                                 default = nil)
  if valid_574518 != nil:
    section.add "resourceGroupName", valid_574518
  var valid_574519 = path.getOrDefault("integrationAccountName")
  valid_574519 = validateParameter(valid_574519, JString, required = true,
                                 default = nil)
  if valid_574519 != nil:
    section.add "integrationAccountName", valid_574519
  var valid_574520 = path.getOrDefault("subscriptionId")
  valid_574520 = validateParameter(valid_574520, JString, required = true,
                                 default = nil)
  if valid_574520 != nil:
    section.add "subscriptionId", valid_574520
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574521 = query.getOrDefault("api-version")
  valid_574521 = validateParameter(valid_574521, JString, required = true,
                                 default = nil)
  if valid_574521 != nil:
    section.add "api-version", valid_574521
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

proc call*(call_574523: Call_IntegrationAccountsListCallbackUrl_574515;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the integration account callback URL.
  ## 
  let valid = call_574523.validator(path, query, header, formData, body)
  let scheme = call_574523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574523.url(scheme.get, call_574523.host, call_574523.base,
                         call_574523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574523, url, valid)

proc call*(call_574524: Call_IntegrationAccountsListCallbackUrl_574515;
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
  var path_574525 = newJObject()
  var query_574526 = newJObject()
  var body_574527 = newJObject()
  add(path_574525, "resourceGroupName", newJString(resourceGroupName))
  add(query_574526, "api-version", newJString(apiVersion))
  add(path_574525, "integrationAccountName", newJString(integrationAccountName))
  add(path_574525, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574527 = parameters
  result = call_574524.call(path_574525, query_574526, nil, nil, body_574527)

var integrationAccountsListCallbackUrl* = Call_IntegrationAccountsListCallbackUrl_574515(
    name: "integrationAccountsListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/listCallbackUrl",
    validator: validate_IntegrationAccountsListCallbackUrl_574516, base: "",
    url: url_IntegrationAccountsListCallbackUrl_574517, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListKeyVaultKeys_574528 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountsListKeyVaultKeys_574530(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsListKeyVaultKeys_574529(path: JsonNode;
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
  var valid_574531 = path.getOrDefault("resourceGroupName")
  valid_574531 = validateParameter(valid_574531, JString, required = true,
                                 default = nil)
  if valid_574531 != nil:
    section.add "resourceGroupName", valid_574531
  var valid_574532 = path.getOrDefault("integrationAccountName")
  valid_574532 = validateParameter(valid_574532, JString, required = true,
                                 default = nil)
  if valid_574532 != nil:
    section.add "integrationAccountName", valid_574532
  var valid_574533 = path.getOrDefault("subscriptionId")
  valid_574533 = validateParameter(valid_574533, JString, required = true,
                                 default = nil)
  if valid_574533 != nil:
    section.add "subscriptionId", valid_574533
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574534 = query.getOrDefault("api-version")
  valid_574534 = validateParameter(valid_574534, JString, required = true,
                                 default = nil)
  if valid_574534 != nil:
    section.add "api-version", valid_574534
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

proc call*(call_574536: Call_IntegrationAccountsListKeyVaultKeys_574528;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the integration account's Key Vault keys.
  ## 
  let valid = call_574536.validator(path, query, header, formData, body)
  let scheme = call_574536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574536.url(scheme.get, call_574536.host, call_574536.base,
                         call_574536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574536, url, valid)

proc call*(call_574537: Call_IntegrationAccountsListKeyVaultKeys_574528;
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
  var path_574538 = newJObject()
  var query_574539 = newJObject()
  var body_574540 = newJObject()
  add(path_574538, "resourceGroupName", newJString(resourceGroupName))
  add(query_574539, "api-version", newJString(apiVersion))
  add(path_574538, "integrationAccountName", newJString(integrationAccountName))
  add(path_574538, "subscriptionId", newJString(subscriptionId))
  if listKeyVaultKeys != nil:
    body_574540 = listKeyVaultKeys
  result = call_574537.call(path_574538, query_574539, nil, nil, body_574540)

var integrationAccountsListKeyVaultKeys* = Call_IntegrationAccountsListKeyVaultKeys_574528(
    name: "integrationAccountsListKeyVaultKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/listKeyVaultKeys",
    validator: validate_IntegrationAccountsListKeyVaultKeys_574529, base: "",
    url: url_IntegrationAccountsListKeyVaultKeys_574530, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsLogTrackingEvents_574541 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountsLogTrackingEvents_574543(protocol: Scheme;
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

proc validate_IntegrationAccountsLogTrackingEvents_574542(path: JsonNode;
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
  var valid_574544 = path.getOrDefault("resourceGroupName")
  valid_574544 = validateParameter(valid_574544, JString, required = true,
                                 default = nil)
  if valid_574544 != nil:
    section.add "resourceGroupName", valid_574544
  var valid_574545 = path.getOrDefault("integrationAccountName")
  valid_574545 = validateParameter(valid_574545, JString, required = true,
                                 default = nil)
  if valid_574545 != nil:
    section.add "integrationAccountName", valid_574545
  var valid_574546 = path.getOrDefault("subscriptionId")
  valid_574546 = validateParameter(valid_574546, JString, required = true,
                                 default = nil)
  if valid_574546 != nil:
    section.add "subscriptionId", valid_574546
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574547 = query.getOrDefault("api-version")
  valid_574547 = validateParameter(valid_574547, JString, required = true,
                                 default = nil)
  if valid_574547 != nil:
    section.add "api-version", valid_574547
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

proc call*(call_574549: Call_IntegrationAccountsLogTrackingEvents_574541;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Logs the integration account's tracking events.
  ## 
  let valid = call_574549.validator(path, query, header, formData, body)
  let scheme = call_574549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574549.url(scheme.get, call_574549.host, call_574549.base,
                         call_574549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574549, url, valid)

proc call*(call_574550: Call_IntegrationAccountsLogTrackingEvents_574541;
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
  var path_574551 = newJObject()
  var query_574552 = newJObject()
  var body_574553 = newJObject()
  add(path_574551, "resourceGroupName", newJString(resourceGroupName))
  add(query_574552, "api-version", newJString(apiVersion))
  add(path_574551, "integrationAccountName", newJString(integrationAccountName))
  add(path_574551, "subscriptionId", newJString(subscriptionId))
  if logTrackingEvents != nil:
    body_574553 = logTrackingEvents
  result = call_574550.call(path_574551, query_574552, nil, nil, body_574553)

var integrationAccountsLogTrackingEvents* = Call_IntegrationAccountsLogTrackingEvents_574541(
    name: "integrationAccountsLogTrackingEvents", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/logTrackingEvents",
    validator: validate_IntegrationAccountsLogTrackingEvents_574542, base: "",
    url: url_IntegrationAccountsLogTrackingEvents_574543, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsList_574554 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountMapsList_574556(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountMapsList_574555(path: JsonNode; query: JsonNode;
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
  var valid_574557 = path.getOrDefault("resourceGroupName")
  valid_574557 = validateParameter(valid_574557, JString, required = true,
                                 default = nil)
  if valid_574557 != nil:
    section.add "resourceGroupName", valid_574557
  var valid_574558 = path.getOrDefault("integrationAccountName")
  valid_574558 = validateParameter(valid_574558, JString, required = true,
                                 default = nil)
  if valid_574558 != nil:
    section.add "integrationAccountName", valid_574558
  var valid_574559 = path.getOrDefault("subscriptionId")
  valid_574559 = validateParameter(valid_574559, JString, required = true,
                                 default = nil)
  if valid_574559 != nil:
    section.add "subscriptionId", valid_574559
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
  var valid_574560 = query.getOrDefault("api-version")
  valid_574560 = validateParameter(valid_574560, JString, required = true,
                                 default = nil)
  if valid_574560 != nil:
    section.add "api-version", valid_574560
  var valid_574561 = query.getOrDefault("$top")
  valid_574561 = validateParameter(valid_574561, JInt, required = false, default = nil)
  if valid_574561 != nil:
    section.add "$top", valid_574561
  var valid_574562 = query.getOrDefault("$filter")
  valid_574562 = validateParameter(valid_574562, JString, required = false,
                                 default = nil)
  if valid_574562 != nil:
    section.add "$filter", valid_574562
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574563: Call_IntegrationAccountMapsList_574554; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account maps.
  ## 
  let valid = call_574563.validator(path, query, header, formData, body)
  let scheme = call_574563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574563.url(scheme.get, call_574563.host, call_574563.base,
                         call_574563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574563, url, valid)

proc call*(call_574564: Call_IntegrationAccountMapsList_574554;
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
  var path_574565 = newJObject()
  var query_574566 = newJObject()
  add(path_574565, "resourceGroupName", newJString(resourceGroupName))
  add(query_574566, "api-version", newJString(apiVersion))
  add(path_574565, "integrationAccountName", newJString(integrationAccountName))
  add(path_574565, "subscriptionId", newJString(subscriptionId))
  add(query_574566, "$top", newJInt(Top))
  add(query_574566, "$filter", newJString(Filter))
  result = call_574564.call(path_574565, query_574566, nil, nil, nil)

var integrationAccountMapsList* = Call_IntegrationAccountMapsList_574554(
    name: "integrationAccountMapsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps",
    validator: validate_IntegrationAccountMapsList_574555, base: "",
    url: url_IntegrationAccountMapsList_574556, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsCreateOrUpdate_574579 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountMapsCreateOrUpdate_574581(protocol: Scheme;
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

proc validate_IntegrationAccountMapsCreateOrUpdate_574580(path: JsonNode;
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
  var valid_574582 = path.getOrDefault("resourceGroupName")
  valid_574582 = validateParameter(valid_574582, JString, required = true,
                                 default = nil)
  if valid_574582 != nil:
    section.add "resourceGroupName", valid_574582
  var valid_574583 = path.getOrDefault("mapName")
  valid_574583 = validateParameter(valid_574583, JString, required = true,
                                 default = nil)
  if valid_574583 != nil:
    section.add "mapName", valid_574583
  var valid_574584 = path.getOrDefault("integrationAccountName")
  valid_574584 = validateParameter(valid_574584, JString, required = true,
                                 default = nil)
  if valid_574584 != nil:
    section.add "integrationAccountName", valid_574584
  var valid_574585 = path.getOrDefault("subscriptionId")
  valid_574585 = validateParameter(valid_574585, JString, required = true,
                                 default = nil)
  if valid_574585 != nil:
    section.add "subscriptionId", valid_574585
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574586 = query.getOrDefault("api-version")
  valid_574586 = validateParameter(valid_574586, JString, required = true,
                                 default = nil)
  if valid_574586 != nil:
    section.add "api-version", valid_574586
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

proc call*(call_574588: Call_IntegrationAccountMapsCreateOrUpdate_574579;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account map.
  ## 
  let valid = call_574588.validator(path, query, header, formData, body)
  let scheme = call_574588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574588.url(scheme.get, call_574588.host, call_574588.base,
                         call_574588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574588, url, valid)

proc call*(call_574589: Call_IntegrationAccountMapsCreateOrUpdate_574579;
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
  var path_574590 = newJObject()
  var query_574591 = newJObject()
  var body_574592 = newJObject()
  add(path_574590, "resourceGroupName", newJString(resourceGroupName))
  if map != nil:
    body_574592 = map
  add(path_574590, "mapName", newJString(mapName))
  add(query_574591, "api-version", newJString(apiVersion))
  add(path_574590, "integrationAccountName", newJString(integrationAccountName))
  add(path_574590, "subscriptionId", newJString(subscriptionId))
  result = call_574589.call(path_574590, query_574591, nil, nil, body_574592)

var integrationAccountMapsCreateOrUpdate* = Call_IntegrationAccountMapsCreateOrUpdate_574579(
    name: "integrationAccountMapsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_IntegrationAccountMapsCreateOrUpdate_574580, base: "",
    url: url_IntegrationAccountMapsCreateOrUpdate_574581, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsGet_574567 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountMapsGet_574569(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountMapsGet_574568(path: JsonNode; query: JsonNode;
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
  var valid_574570 = path.getOrDefault("resourceGroupName")
  valid_574570 = validateParameter(valid_574570, JString, required = true,
                                 default = nil)
  if valid_574570 != nil:
    section.add "resourceGroupName", valid_574570
  var valid_574571 = path.getOrDefault("mapName")
  valid_574571 = validateParameter(valid_574571, JString, required = true,
                                 default = nil)
  if valid_574571 != nil:
    section.add "mapName", valid_574571
  var valid_574572 = path.getOrDefault("integrationAccountName")
  valid_574572 = validateParameter(valid_574572, JString, required = true,
                                 default = nil)
  if valid_574572 != nil:
    section.add "integrationAccountName", valid_574572
  var valid_574573 = path.getOrDefault("subscriptionId")
  valid_574573 = validateParameter(valid_574573, JString, required = true,
                                 default = nil)
  if valid_574573 != nil:
    section.add "subscriptionId", valid_574573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574574 = query.getOrDefault("api-version")
  valid_574574 = validateParameter(valid_574574, JString, required = true,
                                 default = nil)
  if valid_574574 != nil:
    section.add "api-version", valid_574574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574575: Call_IntegrationAccountMapsGet_574567; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account map.
  ## 
  let valid = call_574575.validator(path, query, header, formData, body)
  let scheme = call_574575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574575.url(scheme.get, call_574575.host, call_574575.base,
                         call_574575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574575, url, valid)

proc call*(call_574576: Call_IntegrationAccountMapsGet_574567;
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
  var path_574577 = newJObject()
  var query_574578 = newJObject()
  add(path_574577, "resourceGroupName", newJString(resourceGroupName))
  add(path_574577, "mapName", newJString(mapName))
  add(query_574578, "api-version", newJString(apiVersion))
  add(path_574577, "integrationAccountName", newJString(integrationAccountName))
  add(path_574577, "subscriptionId", newJString(subscriptionId))
  result = call_574576.call(path_574577, query_574578, nil, nil, nil)

var integrationAccountMapsGet* = Call_IntegrationAccountMapsGet_574567(
    name: "integrationAccountMapsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_IntegrationAccountMapsGet_574568, base: "",
    url: url_IntegrationAccountMapsGet_574569, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsDelete_574593 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountMapsDelete_574595(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountMapsDelete_574594(path: JsonNode; query: JsonNode;
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
  var valid_574596 = path.getOrDefault("resourceGroupName")
  valid_574596 = validateParameter(valid_574596, JString, required = true,
                                 default = nil)
  if valid_574596 != nil:
    section.add "resourceGroupName", valid_574596
  var valid_574597 = path.getOrDefault("mapName")
  valid_574597 = validateParameter(valid_574597, JString, required = true,
                                 default = nil)
  if valid_574597 != nil:
    section.add "mapName", valid_574597
  var valid_574598 = path.getOrDefault("integrationAccountName")
  valid_574598 = validateParameter(valid_574598, JString, required = true,
                                 default = nil)
  if valid_574598 != nil:
    section.add "integrationAccountName", valid_574598
  var valid_574599 = path.getOrDefault("subscriptionId")
  valid_574599 = validateParameter(valid_574599, JString, required = true,
                                 default = nil)
  if valid_574599 != nil:
    section.add "subscriptionId", valid_574599
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574600 = query.getOrDefault("api-version")
  valid_574600 = validateParameter(valid_574600, JString, required = true,
                                 default = nil)
  if valid_574600 != nil:
    section.add "api-version", valid_574600
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574601: Call_IntegrationAccountMapsDelete_574593; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account map.
  ## 
  let valid = call_574601.validator(path, query, header, formData, body)
  let scheme = call_574601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574601.url(scheme.get, call_574601.host, call_574601.base,
                         call_574601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574601, url, valid)

proc call*(call_574602: Call_IntegrationAccountMapsDelete_574593;
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
  var path_574603 = newJObject()
  var query_574604 = newJObject()
  add(path_574603, "resourceGroupName", newJString(resourceGroupName))
  add(path_574603, "mapName", newJString(mapName))
  add(query_574604, "api-version", newJString(apiVersion))
  add(path_574603, "integrationAccountName", newJString(integrationAccountName))
  add(path_574603, "subscriptionId", newJString(subscriptionId))
  result = call_574602.call(path_574603, query_574604, nil, nil, nil)

var integrationAccountMapsDelete* = Call_IntegrationAccountMapsDelete_574593(
    name: "integrationAccountMapsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_IntegrationAccountMapsDelete_574594, base: "",
    url: url_IntegrationAccountMapsDelete_574595, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsListContentCallbackUrl_574605 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountMapsListContentCallbackUrl_574607(protocol: Scheme;
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

proc validate_IntegrationAccountMapsListContentCallbackUrl_574606(path: JsonNode;
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
  var valid_574608 = path.getOrDefault("resourceGroupName")
  valid_574608 = validateParameter(valid_574608, JString, required = true,
                                 default = nil)
  if valid_574608 != nil:
    section.add "resourceGroupName", valid_574608
  var valid_574609 = path.getOrDefault("mapName")
  valid_574609 = validateParameter(valid_574609, JString, required = true,
                                 default = nil)
  if valid_574609 != nil:
    section.add "mapName", valid_574609
  var valid_574610 = path.getOrDefault("integrationAccountName")
  valid_574610 = validateParameter(valid_574610, JString, required = true,
                                 default = nil)
  if valid_574610 != nil:
    section.add "integrationAccountName", valid_574610
  var valid_574611 = path.getOrDefault("subscriptionId")
  valid_574611 = validateParameter(valid_574611, JString, required = true,
                                 default = nil)
  if valid_574611 != nil:
    section.add "subscriptionId", valid_574611
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574612 = query.getOrDefault("api-version")
  valid_574612 = validateParameter(valid_574612, JString, required = true,
                                 default = nil)
  if valid_574612 != nil:
    section.add "api-version", valid_574612
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

proc call*(call_574614: Call_IntegrationAccountMapsListContentCallbackUrl_574605;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_574614.validator(path, query, header, formData, body)
  let scheme = call_574614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574614.url(scheme.get, call_574614.host, call_574614.base,
                         call_574614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574614, url, valid)

proc call*(call_574615: Call_IntegrationAccountMapsListContentCallbackUrl_574605;
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
  var path_574616 = newJObject()
  var query_574617 = newJObject()
  var body_574618 = newJObject()
  add(path_574616, "resourceGroupName", newJString(resourceGroupName))
  add(path_574616, "mapName", newJString(mapName))
  add(query_574617, "api-version", newJString(apiVersion))
  add(path_574616, "integrationAccountName", newJString(integrationAccountName))
  add(path_574616, "subscriptionId", newJString(subscriptionId))
  if listContentCallbackUrl != nil:
    body_574618 = listContentCallbackUrl
  result = call_574615.call(path_574616, query_574617, nil, nil, body_574618)

var integrationAccountMapsListContentCallbackUrl* = Call_IntegrationAccountMapsListContentCallbackUrl_574605(
    name: "integrationAccountMapsListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountMapsListContentCallbackUrl_574606,
    base: "", url: url_IntegrationAccountMapsListContentCallbackUrl_574607,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersList_574619 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountPartnersList_574621(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountPartnersList_574620(path: JsonNode;
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
  var valid_574622 = path.getOrDefault("resourceGroupName")
  valid_574622 = validateParameter(valid_574622, JString, required = true,
                                 default = nil)
  if valid_574622 != nil:
    section.add "resourceGroupName", valid_574622
  var valid_574623 = path.getOrDefault("integrationAccountName")
  valid_574623 = validateParameter(valid_574623, JString, required = true,
                                 default = nil)
  if valid_574623 != nil:
    section.add "integrationAccountName", valid_574623
  var valid_574624 = path.getOrDefault("subscriptionId")
  valid_574624 = validateParameter(valid_574624, JString, required = true,
                                 default = nil)
  if valid_574624 != nil:
    section.add "subscriptionId", valid_574624
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
  var valid_574625 = query.getOrDefault("api-version")
  valid_574625 = validateParameter(valid_574625, JString, required = true,
                                 default = nil)
  if valid_574625 != nil:
    section.add "api-version", valid_574625
  var valid_574626 = query.getOrDefault("$top")
  valid_574626 = validateParameter(valid_574626, JInt, required = false, default = nil)
  if valid_574626 != nil:
    section.add "$top", valid_574626
  var valid_574627 = query.getOrDefault("$filter")
  valid_574627 = validateParameter(valid_574627, JString, required = false,
                                 default = nil)
  if valid_574627 != nil:
    section.add "$filter", valid_574627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574628: Call_IntegrationAccountPartnersList_574619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account partners.
  ## 
  let valid = call_574628.validator(path, query, header, formData, body)
  let scheme = call_574628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574628.url(scheme.get, call_574628.host, call_574628.base,
                         call_574628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574628, url, valid)

proc call*(call_574629: Call_IntegrationAccountPartnersList_574619;
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
  var path_574630 = newJObject()
  var query_574631 = newJObject()
  add(path_574630, "resourceGroupName", newJString(resourceGroupName))
  add(query_574631, "api-version", newJString(apiVersion))
  add(path_574630, "integrationAccountName", newJString(integrationAccountName))
  add(path_574630, "subscriptionId", newJString(subscriptionId))
  add(query_574631, "$top", newJInt(Top))
  add(query_574631, "$filter", newJString(Filter))
  result = call_574629.call(path_574630, query_574631, nil, nil, nil)

var integrationAccountPartnersList* = Call_IntegrationAccountPartnersList_574619(
    name: "integrationAccountPartnersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners",
    validator: validate_IntegrationAccountPartnersList_574620, base: "",
    url: url_IntegrationAccountPartnersList_574621, schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersCreateOrUpdate_574644 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountPartnersCreateOrUpdate_574646(protocol: Scheme;
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

proc validate_IntegrationAccountPartnersCreateOrUpdate_574645(path: JsonNode;
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
  var valid_574647 = path.getOrDefault("resourceGroupName")
  valid_574647 = validateParameter(valid_574647, JString, required = true,
                                 default = nil)
  if valid_574647 != nil:
    section.add "resourceGroupName", valid_574647
  var valid_574648 = path.getOrDefault("integrationAccountName")
  valid_574648 = validateParameter(valid_574648, JString, required = true,
                                 default = nil)
  if valid_574648 != nil:
    section.add "integrationAccountName", valid_574648
  var valid_574649 = path.getOrDefault("subscriptionId")
  valid_574649 = validateParameter(valid_574649, JString, required = true,
                                 default = nil)
  if valid_574649 != nil:
    section.add "subscriptionId", valid_574649
  var valid_574650 = path.getOrDefault("partnerName")
  valid_574650 = validateParameter(valid_574650, JString, required = true,
                                 default = nil)
  if valid_574650 != nil:
    section.add "partnerName", valid_574650
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574651 = query.getOrDefault("api-version")
  valid_574651 = validateParameter(valid_574651, JString, required = true,
                                 default = nil)
  if valid_574651 != nil:
    section.add "api-version", valid_574651
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

proc call*(call_574653: Call_IntegrationAccountPartnersCreateOrUpdate_574644;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account partner.
  ## 
  let valid = call_574653.validator(path, query, header, formData, body)
  let scheme = call_574653.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574653.url(scheme.get, call_574653.host, call_574653.base,
                         call_574653.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574653, url, valid)

proc call*(call_574654: Call_IntegrationAccountPartnersCreateOrUpdate_574644;
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
  var path_574655 = newJObject()
  var query_574656 = newJObject()
  var body_574657 = newJObject()
  add(path_574655, "resourceGroupName", newJString(resourceGroupName))
  add(query_574656, "api-version", newJString(apiVersion))
  add(path_574655, "integrationAccountName", newJString(integrationAccountName))
  add(path_574655, "subscriptionId", newJString(subscriptionId))
  if partner != nil:
    body_574657 = partner
  add(path_574655, "partnerName", newJString(partnerName))
  result = call_574654.call(path_574655, query_574656, nil, nil, body_574657)

var integrationAccountPartnersCreateOrUpdate* = Call_IntegrationAccountPartnersCreateOrUpdate_574644(
    name: "integrationAccountPartnersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_IntegrationAccountPartnersCreateOrUpdate_574645, base: "",
    url: url_IntegrationAccountPartnersCreateOrUpdate_574646,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersGet_574632 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountPartnersGet_574634(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountPartnersGet_574633(path: JsonNode; query: JsonNode;
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
  var valid_574635 = path.getOrDefault("resourceGroupName")
  valid_574635 = validateParameter(valid_574635, JString, required = true,
                                 default = nil)
  if valid_574635 != nil:
    section.add "resourceGroupName", valid_574635
  var valid_574636 = path.getOrDefault("integrationAccountName")
  valid_574636 = validateParameter(valid_574636, JString, required = true,
                                 default = nil)
  if valid_574636 != nil:
    section.add "integrationAccountName", valid_574636
  var valid_574637 = path.getOrDefault("subscriptionId")
  valid_574637 = validateParameter(valid_574637, JString, required = true,
                                 default = nil)
  if valid_574637 != nil:
    section.add "subscriptionId", valid_574637
  var valid_574638 = path.getOrDefault("partnerName")
  valid_574638 = validateParameter(valid_574638, JString, required = true,
                                 default = nil)
  if valid_574638 != nil:
    section.add "partnerName", valid_574638
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574639 = query.getOrDefault("api-version")
  valid_574639 = validateParameter(valid_574639, JString, required = true,
                                 default = nil)
  if valid_574639 != nil:
    section.add "api-version", valid_574639
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574640: Call_IntegrationAccountPartnersGet_574632; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account partner.
  ## 
  let valid = call_574640.validator(path, query, header, formData, body)
  let scheme = call_574640.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574640.url(scheme.get, call_574640.host, call_574640.base,
                         call_574640.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574640, url, valid)

proc call*(call_574641: Call_IntegrationAccountPartnersGet_574632;
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
  var path_574642 = newJObject()
  var query_574643 = newJObject()
  add(path_574642, "resourceGroupName", newJString(resourceGroupName))
  add(query_574643, "api-version", newJString(apiVersion))
  add(path_574642, "integrationAccountName", newJString(integrationAccountName))
  add(path_574642, "subscriptionId", newJString(subscriptionId))
  add(path_574642, "partnerName", newJString(partnerName))
  result = call_574641.call(path_574642, query_574643, nil, nil, nil)

var integrationAccountPartnersGet* = Call_IntegrationAccountPartnersGet_574632(
    name: "integrationAccountPartnersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_IntegrationAccountPartnersGet_574633, base: "",
    url: url_IntegrationAccountPartnersGet_574634, schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersDelete_574658 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountPartnersDelete_574660(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountPartnersDelete_574659(path: JsonNode;
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
  var valid_574661 = path.getOrDefault("resourceGroupName")
  valid_574661 = validateParameter(valid_574661, JString, required = true,
                                 default = nil)
  if valid_574661 != nil:
    section.add "resourceGroupName", valid_574661
  var valid_574662 = path.getOrDefault("integrationAccountName")
  valid_574662 = validateParameter(valid_574662, JString, required = true,
                                 default = nil)
  if valid_574662 != nil:
    section.add "integrationAccountName", valid_574662
  var valid_574663 = path.getOrDefault("subscriptionId")
  valid_574663 = validateParameter(valid_574663, JString, required = true,
                                 default = nil)
  if valid_574663 != nil:
    section.add "subscriptionId", valid_574663
  var valid_574664 = path.getOrDefault("partnerName")
  valid_574664 = validateParameter(valid_574664, JString, required = true,
                                 default = nil)
  if valid_574664 != nil:
    section.add "partnerName", valid_574664
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574665 = query.getOrDefault("api-version")
  valid_574665 = validateParameter(valid_574665, JString, required = true,
                                 default = nil)
  if valid_574665 != nil:
    section.add "api-version", valid_574665
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574666: Call_IntegrationAccountPartnersDelete_574658;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account partner.
  ## 
  let valid = call_574666.validator(path, query, header, formData, body)
  let scheme = call_574666.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574666.url(scheme.get, call_574666.host, call_574666.base,
                         call_574666.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574666, url, valid)

proc call*(call_574667: Call_IntegrationAccountPartnersDelete_574658;
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
  var path_574668 = newJObject()
  var query_574669 = newJObject()
  add(path_574668, "resourceGroupName", newJString(resourceGroupName))
  add(query_574669, "api-version", newJString(apiVersion))
  add(path_574668, "integrationAccountName", newJString(integrationAccountName))
  add(path_574668, "subscriptionId", newJString(subscriptionId))
  add(path_574668, "partnerName", newJString(partnerName))
  result = call_574667.call(path_574668, query_574669, nil, nil, nil)

var integrationAccountPartnersDelete* = Call_IntegrationAccountPartnersDelete_574658(
    name: "integrationAccountPartnersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_IntegrationAccountPartnersDelete_574659, base: "",
    url: url_IntegrationAccountPartnersDelete_574660, schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersListContentCallbackUrl_574670 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountPartnersListContentCallbackUrl_574672(
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

proc validate_IntegrationAccountPartnersListContentCallbackUrl_574671(
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
  var valid_574673 = path.getOrDefault("resourceGroupName")
  valid_574673 = validateParameter(valid_574673, JString, required = true,
                                 default = nil)
  if valid_574673 != nil:
    section.add "resourceGroupName", valid_574673
  var valid_574674 = path.getOrDefault("integrationAccountName")
  valid_574674 = validateParameter(valid_574674, JString, required = true,
                                 default = nil)
  if valid_574674 != nil:
    section.add "integrationAccountName", valid_574674
  var valid_574675 = path.getOrDefault("subscriptionId")
  valid_574675 = validateParameter(valid_574675, JString, required = true,
                                 default = nil)
  if valid_574675 != nil:
    section.add "subscriptionId", valid_574675
  var valid_574676 = path.getOrDefault("partnerName")
  valid_574676 = validateParameter(valid_574676, JString, required = true,
                                 default = nil)
  if valid_574676 != nil:
    section.add "partnerName", valid_574676
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574677 = query.getOrDefault("api-version")
  valid_574677 = validateParameter(valid_574677, JString, required = true,
                                 default = nil)
  if valid_574677 != nil:
    section.add "api-version", valid_574677
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

proc call*(call_574679: Call_IntegrationAccountPartnersListContentCallbackUrl_574670;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_574679.validator(path, query, header, formData, body)
  let scheme = call_574679.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574679.url(scheme.get, call_574679.host, call_574679.base,
                         call_574679.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574679, url, valid)

proc call*(call_574680: Call_IntegrationAccountPartnersListContentCallbackUrl_574670;
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
  var path_574681 = newJObject()
  var query_574682 = newJObject()
  var body_574683 = newJObject()
  add(path_574681, "resourceGroupName", newJString(resourceGroupName))
  add(query_574682, "api-version", newJString(apiVersion))
  add(path_574681, "integrationAccountName", newJString(integrationAccountName))
  add(path_574681, "subscriptionId", newJString(subscriptionId))
  add(path_574681, "partnerName", newJString(partnerName))
  if listContentCallbackUrl != nil:
    body_574683 = listContentCallbackUrl
  result = call_574680.call(path_574681, query_574682, nil, nil, body_574683)

var integrationAccountPartnersListContentCallbackUrl* = Call_IntegrationAccountPartnersListContentCallbackUrl_574670(
    name: "integrationAccountPartnersListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountPartnersListContentCallbackUrl_574671,
    base: "", url: url_IntegrationAccountPartnersListContentCallbackUrl_574672,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountsRegenerateAccessKey_574684 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountsRegenerateAccessKey_574686(protocol: Scheme;
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

proc validate_IntegrationAccountsRegenerateAccessKey_574685(path: JsonNode;
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
  var valid_574687 = path.getOrDefault("resourceGroupName")
  valid_574687 = validateParameter(valid_574687, JString, required = true,
                                 default = nil)
  if valid_574687 != nil:
    section.add "resourceGroupName", valid_574687
  var valid_574688 = path.getOrDefault("integrationAccountName")
  valid_574688 = validateParameter(valid_574688, JString, required = true,
                                 default = nil)
  if valid_574688 != nil:
    section.add "integrationAccountName", valid_574688
  var valid_574689 = path.getOrDefault("subscriptionId")
  valid_574689 = validateParameter(valid_574689, JString, required = true,
                                 default = nil)
  if valid_574689 != nil:
    section.add "subscriptionId", valid_574689
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574690 = query.getOrDefault("api-version")
  valid_574690 = validateParameter(valid_574690, JString, required = true,
                                 default = nil)
  if valid_574690 != nil:
    section.add "api-version", valid_574690
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

proc call*(call_574692: Call_IntegrationAccountsRegenerateAccessKey_574684;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the integration account access key.
  ## 
  let valid = call_574692.validator(path, query, header, formData, body)
  let scheme = call_574692.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574692.url(scheme.get, call_574692.host, call_574692.base,
                         call_574692.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574692, url, valid)

proc call*(call_574693: Call_IntegrationAccountsRegenerateAccessKey_574684;
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
  var path_574694 = newJObject()
  var query_574695 = newJObject()
  var body_574696 = newJObject()
  add(path_574694, "resourceGroupName", newJString(resourceGroupName))
  add(query_574695, "api-version", newJString(apiVersion))
  add(path_574694, "integrationAccountName", newJString(integrationAccountName))
  add(path_574694, "subscriptionId", newJString(subscriptionId))
  if regenerateAccessKey != nil:
    body_574696 = regenerateAccessKey
  result = call_574693.call(path_574694, query_574695, nil, nil, body_574696)

var integrationAccountsRegenerateAccessKey* = Call_IntegrationAccountsRegenerateAccessKey_574684(
    name: "integrationAccountsRegenerateAccessKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/regenerateAccessKey",
    validator: validate_IntegrationAccountsRegenerateAccessKey_574685, base: "",
    url: url_IntegrationAccountsRegenerateAccessKey_574686,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasList_574697 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountSchemasList_574699(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountSchemasList_574698(path: JsonNode; query: JsonNode;
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
  var valid_574700 = path.getOrDefault("resourceGroupName")
  valid_574700 = validateParameter(valid_574700, JString, required = true,
                                 default = nil)
  if valid_574700 != nil:
    section.add "resourceGroupName", valid_574700
  var valid_574701 = path.getOrDefault("integrationAccountName")
  valid_574701 = validateParameter(valid_574701, JString, required = true,
                                 default = nil)
  if valid_574701 != nil:
    section.add "integrationAccountName", valid_574701
  var valid_574702 = path.getOrDefault("subscriptionId")
  valid_574702 = validateParameter(valid_574702, JString, required = true,
                                 default = nil)
  if valid_574702 != nil:
    section.add "subscriptionId", valid_574702
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
  var valid_574703 = query.getOrDefault("api-version")
  valid_574703 = validateParameter(valid_574703, JString, required = true,
                                 default = nil)
  if valid_574703 != nil:
    section.add "api-version", valid_574703
  var valid_574704 = query.getOrDefault("$top")
  valid_574704 = validateParameter(valid_574704, JInt, required = false, default = nil)
  if valid_574704 != nil:
    section.add "$top", valid_574704
  var valid_574705 = query.getOrDefault("$filter")
  valid_574705 = validateParameter(valid_574705, JString, required = false,
                                 default = nil)
  if valid_574705 != nil:
    section.add "$filter", valid_574705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574706: Call_IntegrationAccountSchemasList_574697; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account schemas.
  ## 
  let valid = call_574706.validator(path, query, header, formData, body)
  let scheme = call_574706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574706.url(scheme.get, call_574706.host, call_574706.base,
                         call_574706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574706, url, valid)

proc call*(call_574707: Call_IntegrationAccountSchemasList_574697;
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
  var path_574708 = newJObject()
  var query_574709 = newJObject()
  add(path_574708, "resourceGroupName", newJString(resourceGroupName))
  add(query_574709, "api-version", newJString(apiVersion))
  add(path_574708, "integrationAccountName", newJString(integrationAccountName))
  add(path_574708, "subscriptionId", newJString(subscriptionId))
  add(query_574709, "$top", newJInt(Top))
  add(query_574709, "$filter", newJString(Filter))
  result = call_574707.call(path_574708, query_574709, nil, nil, nil)

var integrationAccountSchemasList* = Call_IntegrationAccountSchemasList_574697(
    name: "integrationAccountSchemasList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas",
    validator: validate_IntegrationAccountSchemasList_574698, base: "",
    url: url_IntegrationAccountSchemasList_574699, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasCreateOrUpdate_574722 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountSchemasCreateOrUpdate_574724(protocol: Scheme;
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

proc validate_IntegrationAccountSchemasCreateOrUpdate_574723(path: JsonNode;
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
  var valid_574725 = path.getOrDefault("resourceGroupName")
  valid_574725 = validateParameter(valid_574725, JString, required = true,
                                 default = nil)
  if valid_574725 != nil:
    section.add "resourceGroupName", valid_574725
  var valid_574726 = path.getOrDefault("integrationAccountName")
  valid_574726 = validateParameter(valid_574726, JString, required = true,
                                 default = nil)
  if valid_574726 != nil:
    section.add "integrationAccountName", valid_574726
  var valid_574727 = path.getOrDefault("subscriptionId")
  valid_574727 = validateParameter(valid_574727, JString, required = true,
                                 default = nil)
  if valid_574727 != nil:
    section.add "subscriptionId", valid_574727
  var valid_574728 = path.getOrDefault("schemaName")
  valid_574728 = validateParameter(valid_574728, JString, required = true,
                                 default = nil)
  if valid_574728 != nil:
    section.add "schemaName", valid_574728
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574729 = query.getOrDefault("api-version")
  valid_574729 = validateParameter(valid_574729, JString, required = true,
                                 default = nil)
  if valid_574729 != nil:
    section.add "api-version", valid_574729
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

proc call*(call_574731: Call_IntegrationAccountSchemasCreateOrUpdate_574722;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account schema.
  ## 
  let valid = call_574731.validator(path, query, header, formData, body)
  let scheme = call_574731.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574731.url(scheme.get, call_574731.host, call_574731.base,
                         call_574731.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574731, url, valid)

proc call*(call_574732: Call_IntegrationAccountSchemasCreateOrUpdate_574722;
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
  var path_574733 = newJObject()
  var query_574734 = newJObject()
  var body_574735 = newJObject()
  add(path_574733, "resourceGroupName", newJString(resourceGroupName))
  add(query_574734, "api-version", newJString(apiVersion))
  add(path_574733, "integrationAccountName", newJString(integrationAccountName))
  add(path_574733, "subscriptionId", newJString(subscriptionId))
  add(path_574733, "schemaName", newJString(schemaName))
  if schema != nil:
    body_574735 = schema
  result = call_574732.call(path_574733, query_574734, nil, nil, body_574735)

var integrationAccountSchemasCreateOrUpdate* = Call_IntegrationAccountSchemasCreateOrUpdate_574722(
    name: "integrationAccountSchemasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_IntegrationAccountSchemasCreateOrUpdate_574723, base: "",
    url: url_IntegrationAccountSchemasCreateOrUpdate_574724,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasGet_574710 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountSchemasGet_574712(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountSchemasGet_574711(path: JsonNode; query: JsonNode;
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
  var valid_574713 = path.getOrDefault("resourceGroupName")
  valid_574713 = validateParameter(valid_574713, JString, required = true,
                                 default = nil)
  if valid_574713 != nil:
    section.add "resourceGroupName", valid_574713
  var valid_574714 = path.getOrDefault("integrationAccountName")
  valid_574714 = validateParameter(valid_574714, JString, required = true,
                                 default = nil)
  if valid_574714 != nil:
    section.add "integrationAccountName", valid_574714
  var valid_574715 = path.getOrDefault("subscriptionId")
  valid_574715 = validateParameter(valid_574715, JString, required = true,
                                 default = nil)
  if valid_574715 != nil:
    section.add "subscriptionId", valid_574715
  var valid_574716 = path.getOrDefault("schemaName")
  valid_574716 = validateParameter(valid_574716, JString, required = true,
                                 default = nil)
  if valid_574716 != nil:
    section.add "schemaName", valid_574716
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574717 = query.getOrDefault("api-version")
  valid_574717 = validateParameter(valid_574717, JString, required = true,
                                 default = nil)
  if valid_574717 != nil:
    section.add "api-version", valid_574717
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574718: Call_IntegrationAccountSchemasGet_574710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account schema.
  ## 
  let valid = call_574718.validator(path, query, header, formData, body)
  let scheme = call_574718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574718.url(scheme.get, call_574718.host, call_574718.base,
                         call_574718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574718, url, valid)

proc call*(call_574719: Call_IntegrationAccountSchemasGet_574710;
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
  var path_574720 = newJObject()
  var query_574721 = newJObject()
  add(path_574720, "resourceGroupName", newJString(resourceGroupName))
  add(query_574721, "api-version", newJString(apiVersion))
  add(path_574720, "integrationAccountName", newJString(integrationAccountName))
  add(path_574720, "subscriptionId", newJString(subscriptionId))
  add(path_574720, "schemaName", newJString(schemaName))
  result = call_574719.call(path_574720, query_574721, nil, nil, nil)

var integrationAccountSchemasGet* = Call_IntegrationAccountSchemasGet_574710(
    name: "integrationAccountSchemasGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_IntegrationAccountSchemasGet_574711, base: "",
    url: url_IntegrationAccountSchemasGet_574712, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasDelete_574736 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountSchemasDelete_574738(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountSchemasDelete_574737(path: JsonNode;
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
  var valid_574739 = path.getOrDefault("resourceGroupName")
  valid_574739 = validateParameter(valid_574739, JString, required = true,
                                 default = nil)
  if valid_574739 != nil:
    section.add "resourceGroupName", valid_574739
  var valid_574740 = path.getOrDefault("integrationAccountName")
  valid_574740 = validateParameter(valid_574740, JString, required = true,
                                 default = nil)
  if valid_574740 != nil:
    section.add "integrationAccountName", valid_574740
  var valid_574741 = path.getOrDefault("subscriptionId")
  valid_574741 = validateParameter(valid_574741, JString, required = true,
                                 default = nil)
  if valid_574741 != nil:
    section.add "subscriptionId", valid_574741
  var valid_574742 = path.getOrDefault("schemaName")
  valid_574742 = validateParameter(valid_574742, JString, required = true,
                                 default = nil)
  if valid_574742 != nil:
    section.add "schemaName", valid_574742
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574743 = query.getOrDefault("api-version")
  valid_574743 = validateParameter(valid_574743, JString, required = true,
                                 default = nil)
  if valid_574743 != nil:
    section.add "api-version", valid_574743
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574744: Call_IntegrationAccountSchemasDelete_574736;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account schema.
  ## 
  let valid = call_574744.validator(path, query, header, formData, body)
  let scheme = call_574744.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574744.url(scheme.get, call_574744.host, call_574744.base,
                         call_574744.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574744, url, valid)

proc call*(call_574745: Call_IntegrationAccountSchemasDelete_574736;
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
  var path_574746 = newJObject()
  var query_574747 = newJObject()
  add(path_574746, "resourceGroupName", newJString(resourceGroupName))
  add(query_574747, "api-version", newJString(apiVersion))
  add(path_574746, "integrationAccountName", newJString(integrationAccountName))
  add(path_574746, "subscriptionId", newJString(subscriptionId))
  add(path_574746, "schemaName", newJString(schemaName))
  result = call_574745.call(path_574746, query_574747, nil, nil, nil)

var integrationAccountSchemasDelete* = Call_IntegrationAccountSchemasDelete_574736(
    name: "integrationAccountSchemasDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_IntegrationAccountSchemasDelete_574737, base: "",
    url: url_IntegrationAccountSchemasDelete_574738, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasListContentCallbackUrl_574748 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountSchemasListContentCallbackUrl_574750(protocol: Scheme;
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

proc validate_IntegrationAccountSchemasListContentCallbackUrl_574749(
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
  var valid_574751 = path.getOrDefault("resourceGroupName")
  valid_574751 = validateParameter(valid_574751, JString, required = true,
                                 default = nil)
  if valid_574751 != nil:
    section.add "resourceGroupName", valid_574751
  var valid_574752 = path.getOrDefault("integrationAccountName")
  valid_574752 = validateParameter(valid_574752, JString, required = true,
                                 default = nil)
  if valid_574752 != nil:
    section.add "integrationAccountName", valid_574752
  var valid_574753 = path.getOrDefault("subscriptionId")
  valid_574753 = validateParameter(valid_574753, JString, required = true,
                                 default = nil)
  if valid_574753 != nil:
    section.add "subscriptionId", valid_574753
  var valid_574754 = path.getOrDefault("schemaName")
  valid_574754 = validateParameter(valid_574754, JString, required = true,
                                 default = nil)
  if valid_574754 != nil:
    section.add "schemaName", valid_574754
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574755 = query.getOrDefault("api-version")
  valid_574755 = validateParameter(valid_574755, JString, required = true,
                                 default = nil)
  if valid_574755 != nil:
    section.add "api-version", valid_574755
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

proc call*(call_574757: Call_IntegrationAccountSchemasListContentCallbackUrl_574748;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_574757.validator(path, query, header, formData, body)
  let scheme = call_574757.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574757.url(scheme.get, call_574757.host, call_574757.base,
                         call_574757.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574757, url, valid)

proc call*(call_574758: Call_IntegrationAccountSchemasListContentCallbackUrl_574748;
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
  var path_574759 = newJObject()
  var query_574760 = newJObject()
  var body_574761 = newJObject()
  add(path_574759, "resourceGroupName", newJString(resourceGroupName))
  add(query_574760, "api-version", newJString(apiVersion))
  add(path_574759, "integrationAccountName", newJString(integrationAccountName))
  add(path_574759, "subscriptionId", newJString(subscriptionId))
  add(path_574759, "schemaName", newJString(schemaName))
  if listContentCallbackUrl != nil:
    body_574761 = listContentCallbackUrl
  result = call_574758.call(path_574759, query_574760, nil, nil, body_574761)

var integrationAccountSchemasListContentCallbackUrl* = Call_IntegrationAccountSchemasListContentCallbackUrl_574748(
    name: "integrationAccountSchemasListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountSchemasListContentCallbackUrl_574749,
    base: "", url: url_IntegrationAccountSchemasListContentCallbackUrl_574750,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountSessionsList_574762 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountSessionsList_574764(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountSessionsList_574763(path: JsonNode;
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
  var valid_574765 = path.getOrDefault("resourceGroupName")
  valid_574765 = validateParameter(valid_574765, JString, required = true,
                                 default = nil)
  if valid_574765 != nil:
    section.add "resourceGroupName", valid_574765
  var valid_574766 = path.getOrDefault("integrationAccountName")
  valid_574766 = validateParameter(valid_574766, JString, required = true,
                                 default = nil)
  if valid_574766 != nil:
    section.add "integrationAccountName", valid_574766
  var valid_574767 = path.getOrDefault("subscriptionId")
  valid_574767 = validateParameter(valid_574767, JString, required = true,
                                 default = nil)
  if valid_574767 != nil:
    section.add "subscriptionId", valid_574767
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
  var valid_574768 = query.getOrDefault("api-version")
  valid_574768 = validateParameter(valid_574768, JString, required = true,
                                 default = nil)
  if valid_574768 != nil:
    section.add "api-version", valid_574768
  var valid_574769 = query.getOrDefault("$top")
  valid_574769 = validateParameter(valid_574769, JInt, required = false, default = nil)
  if valid_574769 != nil:
    section.add "$top", valid_574769
  var valid_574770 = query.getOrDefault("$filter")
  valid_574770 = validateParameter(valid_574770, JString, required = false,
                                 default = nil)
  if valid_574770 != nil:
    section.add "$filter", valid_574770
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574771: Call_IntegrationAccountSessionsList_574762; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account sessions.
  ## 
  let valid = call_574771.validator(path, query, header, formData, body)
  let scheme = call_574771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574771.url(scheme.get, call_574771.host, call_574771.base,
                         call_574771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574771, url, valid)

proc call*(call_574772: Call_IntegrationAccountSessionsList_574762;
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
  var path_574773 = newJObject()
  var query_574774 = newJObject()
  add(path_574773, "resourceGroupName", newJString(resourceGroupName))
  add(query_574774, "api-version", newJString(apiVersion))
  add(path_574773, "integrationAccountName", newJString(integrationAccountName))
  add(path_574773, "subscriptionId", newJString(subscriptionId))
  add(query_574774, "$top", newJInt(Top))
  add(query_574774, "$filter", newJString(Filter))
  result = call_574772.call(path_574773, query_574774, nil, nil, nil)

var integrationAccountSessionsList* = Call_IntegrationAccountSessionsList_574762(
    name: "integrationAccountSessionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions",
    validator: validate_IntegrationAccountSessionsList_574763, base: "",
    url: url_IntegrationAccountSessionsList_574764, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSessionsCreateOrUpdate_574787 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountSessionsCreateOrUpdate_574789(protocol: Scheme;
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

proc validate_IntegrationAccountSessionsCreateOrUpdate_574788(path: JsonNode;
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
  var valid_574790 = path.getOrDefault("resourceGroupName")
  valid_574790 = validateParameter(valid_574790, JString, required = true,
                                 default = nil)
  if valid_574790 != nil:
    section.add "resourceGroupName", valid_574790
  var valid_574791 = path.getOrDefault("sessionName")
  valid_574791 = validateParameter(valid_574791, JString, required = true,
                                 default = nil)
  if valid_574791 != nil:
    section.add "sessionName", valid_574791
  var valid_574792 = path.getOrDefault("integrationAccountName")
  valid_574792 = validateParameter(valid_574792, JString, required = true,
                                 default = nil)
  if valid_574792 != nil:
    section.add "integrationAccountName", valid_574792
  var valid_574793 = path.getOrDefault("subscriptionId")
  valid_574793 = validateParameter(valid_574793, JString, required = true,
                                 default = nil)
  if valid_574793 != nil:
    section.add "subscriptionId", valid_574793
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574794 = query.getOrDefault("api-version")
  valid_574794 = validateParameter(valid_574794, JString, required = true,
                                 default = nil)
  if valid_574794 != nil:
    section.add "api-version", valid_574794
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

proc call*(call_574796: Call_IntegrationAccountSessionsCreateOrUpdate_574787;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account session.
  ## 
  let valid = call_574796.validator(path, query, header, formData, body)
  let scheme = call_574796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574796.url(scheme.get, call_574796.host, call_574796.base,
                         call_574796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574796, url, valid)

proc call*(call_574797: Call_IntegrationAccountSessionsCreateOrUpdate_574787;
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
  var path_574798 = newJObject()
  var query_574799 = newJObject()
  var body_574800 = newJObject()
  add(path_574798, "resourceGroupName", newJString(resourceGroupName))
  add(query_574799, "api-version", newJString(apiVersion))
  add(path_574798, "sessionName", newJString(sessionName))
  add(path_574798, "integrationAccountName", newJString(integrationAccountName))
  add(path_574798, "subscriptionId", newJString(subscriptionId))
  if session != nil:
    body_574800 = session
  result = call_574797.call(path_574798, query_574799, nil, nil, body_574800)

var integrationAccountSessionsCreateOrUpdate* = Call_IntegrationAccountSessionsCreateOrUpdate_574787(
    name: "integrationAccountSessionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
    validator: validate_IntegrationAccountSessionsCreateOrUpdate_574788, base: "",
    url: url_IntegrationAccountSessionsCreateOrUpdate_574789,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountSessionsGet_574775 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountSessionsGet_574777(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountSessionsGet_574776(path: JsonNode; query: JsonNode;
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
  var valid_574778 = path.getOrDefault("resourceGroupName")
  valid_574778 = validateParameter(valid_574778, JString, required = true,
                                 default = nil)
  if valid_574778 != nil:
    section.add "resourceGroupName", valid_574778
  var valid_574779 = path.getOrDefault("sessionName")
  valid_574779 = validateParameter(valid_574779, JString, required = true,
                                 default = nil)
  if valid_574779 != nil:
    section.add "sessionName", valid_574779
  var valid_574780 = path.getOrDefault("integrationAccountName")
  valid_574780 = validateParameter(valid_574780, JString, required = true,
                                 default = nil)
  if valid_574780 != nil:
    section.add "integrationAccountName", valid_574780
  var valid_574781 = path.getOrDefault("subscriptionId")
  valid_574781 = validateParameter(valid_574781, JString, required = true,
                                 default = nil)
  if valid_574781 != nil:
    section.add "subscriptionId", valid_574781
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574782 = query.getOrDefault("api-version")
  valid_574782 = validateParameter(valid_574782, JString, required = true,
                                 default = nil)
  if valid_574782 != nil:
    section.add "api-version", valid_574782
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574783: Call_IntegrationAccountSessionsGet_574775; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account session.
  ## 
  let valid = call_574783.validator(path, query, header, formData, body)
  let scheme = call_574783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574783.url(scheme.get, call_574783.host, call_574783.base,
                         call_574783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574783, url, valid)

proc call*(call_574784: Call_IntegrationAccountSessionsGet_574775;
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
  var path_574785 = newJObject()
  var query_574786 = newJObject()
  add(path_574785, "resourceGroupName", newJString(resourceGroupName))
  add(query_574786, "api-version", newJString(apiVersion))
  add(path_574785, "sessionName", newJString(sessionName))
  add(path_574785, "integrationAccountName", newJString(integrationAccountName))
  add(path_574785, "subscriptionId", newJString(subscriptionId))
  result = call_574784.call(path_574785, query_574786, nil, nil, nil)

var integrationAccountSessionsGet* = Call_IntegrationAccountSessionsGet_574775(
    name: "integrationAccountSessionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
    validator: validate_IntegrationAccountSessionsGet_574776, base: "",
    url: url_IntegrationAccountSessionsGet_574777, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSessionsDelete_574801 = ref object of OpenApiRestCall_573667
proc url_IntegrationAccountSessionsDelete_574803(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountSessionsDelete_574802(path: JsonNode;
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
  var valid_574804 = path.getOrDefault("resourceGroupName")
  valid_574804 = validateParameter(valid_574804, JString, required = true,
                                 default = nil)
  if valid_574804 != nil:
    section.add "resourceGroupName", valid_574804
  var valid_574805 = path.getOrDefault("sessionName")
  valid_574805 = validateParameter(valid_574805, JString, required = true,
                                 default = nil)
  if valid_574805 != nil:
    section.add "sessionName", valid_574805
  var valid_574806 = path.getOrDefault("integrationAccountName")
  valid_574806 = validateParameter(valid_574806, JString, required = true,
                                 default = nil)
  if valid_574806 != nil:
    section.add "integrationAccountName", valid_574806
  var valid_574807 = path.getOrDefault("subscriptionId")
  valid_574807 = validateParameter(valid_574807, JString, required = true,
                                 default = nil)
  if valid_574807 != nil:
    section.add "subscriptionId", valid_574807
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574808 = query.getOrDefault("api-version")
  valid_574808 = validateParameter(valid_574808, JString, required = true,
                                 default = nil)
  if valid_574808 != nil:
    section.add "api-version", valid_574808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574809: Call_IntegrationAccountSessionsDelete_574801;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account session.
  ## 
  let valid = call_574809.validator(path, query, header, formData, body)
  let scheme = call_574809.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574809.url(scheme.get, call_574809.host, call_574809.base,
                         call_574809.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574809, url, valid)

proc call*(call_574810: Call_IntegrationAccountSessionsDelete_574801;
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
  var path_574811 = newJObject()
  var query_574812 = newJObject()
  add(path_574811, "resourceGroupName", newJString(resourceGroupName))
  add(query_574812, "api-version", newJString(apiVersion))
  add(path_574811, "sessionName", newJString(sessionName))
  add(path_574811, "integrationAccountName", newJString(integrationAccountName))
  add(path_574811, "subscriptionId", newJString(subscriptionId))
  result = call_574810.call(path_574811, query_574812, nil, nil, nil)

var integrationAccountSessionsDelete* = Call_IntegrationAccountSessionsDelete_574801(
    name: "integrationAccountSessionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
    validator: validate_IntegrationAccountSessionsDelete_574802, base: "",
    url: url_IntegrationAccountSessionsDelete_574803, schemes: {Scheme.Https})
type
  Call_WorkflowsValidateByLocation_574813 = ref object of OpenApiRestCall_573667
proc url_WorkflowsValidateByLocation_574815(protocol: Scheme; host: string;
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

proc validate_WorkflowsValidateByLocation_574814(path: JsonNode; query: JsonNode;
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
  var valid_574816 = path.getOrDefault("workflowName")
  valid_574816 = validateParameter(valid_574816, JString, required = true,
                                 default = nil)
  if valid_574816 != nil:
    section.add "workflowName", valid_574816
  var valid_574817 = path.getOrDefault("resourceGroupName")
  valid_574817 = validateParameter(valid_574817, JString, required = true,
                                 default = nil)
  if valid_574817 != nil:
    section.add "resourceGroupName", valid_574817
  var valid_574818 = path.getOrDefault("subscriptionId")
  valid_574818 = validateParameter(valid_574818, JString, required = true,
                                 default = nil)
  if valid_574818 != nil:
    section.add "subscriptionId", valid_574818
  var valid_574819 = path.getOrDefault("location")
  valid_574819 = validateParameter(valid_574819, JString, required = true,
                                 default = nil)
  if valid_574819 != nil:
    section.add "location", valid_574819
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574820 = query.getOrDefault("api-version")
  valid_574820 = validateParameter(valid_574820, JString, required = true,
                                 default = nil)
  if valid_574820 != nil:
    section.add "api-version", valid_574820
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574821: Call_WorkflowsValidateByLocation_574813; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the workflow definition.
  ## 
  let valid = call_574821.validator(path, query, header, formData, body)
  let scheme = call_574821.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574821.url(scheme.get, call_574821.host, call_574821.base,
                         call_574821.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574821, url, valid)

proc call*(call_574822: Call_WorkflowsValidateByLocation_574813;
          workflowName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
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
  ##   location: string (required)
  ##           : The workflow location.
  var path_574823 = newJObject()
  var query_574824 = newJObject()
  add(path_574823, "workflowName", newJString(workflowName))
  add(path_574823, "resourceGroupName", newJString(resourceGroupName))
  add(query_574824, "api-version", newJString(apiVersion))
  add(path_574823, "subscriptionId", newJString(subscriptionId))
  add(path_574823, "location", newJString(location))
  result = call_574822.call(path_574823, query_574824, nil, nil, nil)

var workflowsValidateByLocation* = Call_WorkflowsValidateByLocation_574813(
    name: "workflowsValidateByLocation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/locations/{location}/workflows/{workflowName}/validate",
    validator: validate_WorkflowsValidateByLocation_574814, base: "",
    url: url_WorkflowsValidateByLocation_574815, schemes: {Scheme.Https})
type
  Call_WorkflowsListByResourceGroup_574825 = ref object of OpenApiRestCall_573667
proc url_WorkflowsListByResourceGroup_574827(protocol: Scheme; host: string;
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

proc validate_WorkflowsListByResourceGroup_574826(path: JsonNode; query: JsonNode;
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
  var valid_574828 = path.getOrDefault("resourceGroupName")
  valid_574828 = validateParameter(valid_574828, JString, required = true,
                                 default = nil)
  if valid_574828 != nil:
    section.add "resourceGroupName", valid_574828
  var valid_574829 = path.getOrDefault("subscriptionId")
  valid_574829 = validateParameter(valid_574829, JString, required = true,
                                 default = nil)
  if valid_574829 != nil:
    section.add "subscriptionId", valid_574829
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
  var valid_574830 = query.getOrDefault("api-version")
  valid_574830 = validateParameter(valid_574830, JString, required = true,
                                 default = nil)
  if valid_574830 != nil:
    section.add "api-version", valid_574830
  var valid_574831 = query.getOrDefault("$top")
  valid_574831 = validateParameter(valid_574831, JInt, required = false, default = nil)
  if valid_574831 != nil:
    section.add "$top", valid_574831
  var valid_574832 = query.getOrDefault("$filter")
  valid_574832 = validateParameter(valid_574832, JString, required = false,
                                 default = nil)
  if valid_574832 != nil:
    section.add "$filter", valid_574832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574833: Call_WorkflowsListByResourceGroup_574825; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflows by resource group.
  ## 
  let valid = call_574833.validator(path, query, header, formData, body)
  let scheme = call_574833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574833.url(scheme.get, call_574833.host, call_574833.base,
                         call_574833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574833, url, valid)

proc call*(call_574834: Call_WorkflowsListByResourceGroup_574825;
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
  var path_574835 = newJObject()
  var query_574836 = newJObject()
  add(path_574835, "resourceGroupName", newJString(resourceGroupName))
  add(query_574836, "api-version", newJString(apiVersion))
  add(path_574835, "subscriptionId", newJString(subscriptionId))
  add(query_574836, "$top", newJInt(Top))
  add(query_574836, "$filter", newJString(Filter))
  result = call_574834.call(path_574835, query_574836, nil, nil, nil)

var workflowsListByResourceGroup* = Call_WorkflowsListByResourceGroup_574825(
    name: "workflowsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows",
    validator: validate_WorkflowsListByResourceGroup_574826, base: "",
    url: url_WorkflowsListByResourceGroup_574827, schemes: {Scheme.Https})
type
  Call_WorkflowsCreateOrUpdate_574848 = ref object of OpenApiRestCall_573667
proc url_WorkflowsCreateOrUpdate_574850(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsCreateOrUpdate_574849(path: JsonNode; query: JsonNode;
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
  var valid_574851 = path.getOrDefault("workflowName")
  valid_574851 = validateParameter(valid_574851, JString, required = true,
                                 default = nil)
  if valid_574851 != nil:
    section.add "workflowName", valid_574851
  var valid_574852 = path.getOrDefault("resourceGroupName")
  valid_574852 = validateParameter(valid_574852, JString, required = true,
                                 default = nil)
  if valid_574852 != nil:
    section.add "resourceGroupName", valid_574852
  var valid_574853 = path.getOrDefault("subscriptionId")
  valid_574853 = validateParameter(valid_574853, JString, required = true,
                                 default = nil)
  if valid_574853 != nil:
    section.add "subscriptionId", valid_574853
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574854 = query.getOrDefault("api-version")
  valid_574854 = validateParameter(valid_574854, JString, required = true,
                                 default = nil)
  if valid_574854 != nil:
    section.add "api-version", valid_574854
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

proc call*(call_574856: Call_WorkflowsCreateOrUpdate_574848; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a workflow.
  ## 
  let valid = call_574856.validator(path, query, header, formData, body)
  let scheme = call_574856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574856.url(scheme.get, call_574856.host, call_574856.base,
                         call_574856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574856, url, valid)

proc call*(call_574857: Call_WorkflowsCreateOrUpdate_574848; workflowName: string;
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
  var path_574858 = newJObject()
  var query_574859 = newJObject()
  var body_574860 = newJObject()
  add(path_574858, "workflowName", newJString(workflowName))
  add(path_574858, "resourceGroupName", newJString(resourceGroupName))
  add(query_574859, "api-version", newJString(apiVersion))
  add(path_574858, "subscriptionId", newJString(subscriptionId))
  if workflow != nil:
    body_574860 = workflow
  result = call_574857.call(path_574858, query_574859, nil, nil, body_574860)

var workflowsCreateOrUpdate* = Call_WorkflowsCreateOrUpdate_574848(
    name: "workflowsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsCreateOrUpdate_574849, base: "",
    url: url_WorkflowsCreateOrUpdate_574850, schemes: {Scheme.Https})
type
  Call_WorkflowsGet_574837 = ref object of OpenApiRestCall_573667
proc url_WorkflowsGet_574839(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsGet_574838(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574840 = path.getOrDefault("workflowName")
  valid_574840 = validateParameter(valid_574840, JString, required = true,
                                 default = nil)
  if valid_574840 != nil:
    section.add "workflowName", valid_574840
  var valid_574841 = path.getOrDefault("resourceGroupName")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = nil)
  if valid_574841 != nil:
    section.add "resourceGroupName", valid_574841
  var valid_574842 = path.getOrDefault("subscriptionId")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = nil)
  if valid_574842 != nil:
    section.add "subscriptionId", valid_574842
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574843 = query.getOrDefault("api-version")
  valid_574843 = validateParameter(valid_574843, JString, required = true,
                                 default = nil)
  if valid_574843 != nil:
    section.add "api-version", valid_574843
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574844: Call_WorkflowsGet_574837; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow.
  ## 
  let valid = call_574844.validator(path, query, header, formData, body)
  let scheme = call_574844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574844.url(scheme.get, call_574844.host, call_574844.base,
                         call_574844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574844, url, valid)

proc call*(call_574845: Call_WorkflowsGet_574837; workflowName: string;
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
  var path_574846 = newJObject()
  var query_574847 = newJObject()
  add(path_574846, "workflowName", newJString(workflowName))
  add(path_574846, "resourceGroupName", newJString(resourceGroupName))
  add(query_574847, "api-version", newJString(apiVersion))
  add(path_574846, "subscriptionId", newJString(subscriptionId))
  result = call_574845.call(path_574846, query_574847, nil, nil, nil)

var workflowsGet* = Call_WorkflowsGet_574837(name: "workflowsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsGet_574838, base: "", url: url_WorkflowsGet_574839,
    schemes: {Scheme.Https})
type
  Call_WorkflowsUpdate_574872 = ref object of OpenApiRestCall_573667
proc url_WorkflowsUpdate_574874(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsUpdate_574873(path: JsonNode; query: JsonNode;
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
  var valid_574875 = path.getOrDefault("workflowName")
  valid_574875 = validateParameter(valid_574875, JString, required = true,
                                 default = nil)
  if valid_574875 != nil:
    section.add "workflowName", valid_574875
  var valid_574876 = path.getOrDefault("resourceGroupName")
  valid_574876 = validateParameter(valid_574876, JString, required = true,
                                 default = nil)
  if valid_574876 != nil:
    section.add "resourceGroupName", valid_574876
  var valid_574877 = path.getOrDefault("subscriptionId")
  valid_574877 = validateParameter(valid_574877, JString, required = true,
                                 default = nil)
  if valid_574877 != nil:
    section.add "subscriptionId", valid_574877
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574878 = query.getOrDefault("api-version")
  valid_574878 = validateParameter(valid_574878, JString, required = true,
                                 default = nil)
  if valid_574878 != nil:
    section.add "api-version", valid_574878
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

proc call*(call_574880: Call_WorkflowsUpdate_574872; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a workflow.
  ## 
  let valid = call_574880.validator(path, query, header, formData, body)
  let scheme = call_574880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574880.url(scheme.get, call_574880.host, call_574880.base,
                         call_574880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574880, url, valid)

proc call*(call_574881: Call_WorkflowsUpdate_574872; workflowName: string;
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
  var path_574882 = newJObject()
  var query_574883 = newJObject()
  var body_574884 = newJObject()
  add(path_574882, "workflowName", newJString(workflowName))
  add(path_574882, "resourceGroupName", newJString(resourceGroupName))
  add(query_574883, "api-version", newJString(apiVersion))
  add(path_574882, "subscriptionId", newJString(subscriptionId))
  if workflow != nil:
    body_574884 = workflow
  result = call_574881.call(path_574882, query_574883, nil, nil, body_574884)

var workflowsUpdate* = Call_WorkflowsUpdate_574872(name: "workflowsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsUpdate_574873, base: "", url: url_WorkflowsUpdate_574874,
    schemes: {Scheme.Https})
type
  Call_WorkflowsDelete_574861 = ref object of OpenApiRestCall_573667
proc url_WorkflowsDelete_574863(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsDelete_574862(path: JsonNode; query: JsonNode;
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
  var valid_574864 = path.getOrDefault("workflowName")
  valid_574864 = validateParameter(valid_574864, JString, required = true,
                                 default = nil)
  if valid_574864 != nil:
    section.add "workflowName", valid_574864
  var valid_574865 = path.getOrDefault("resourceGroupName")
  valid_574865 = validateParameter(valid_574865, JString, required = true,
                                 default = nil)
  if valid_574865 != nil:
    section.add "resourceGroupName", valid_574865
  var valid_574866 = path.getOrDefault("subscriptionId")
  valid_574866 = validateParameter(valid_574866, JString, required = true,
                                 default = nil)
  if valid_574866 != nil:
    section.add "subscriptionId", valid_574866
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574867 = query.getOrDefault("api-version")
  valid_574867 = validateParameter(valid_574867, JString, required = true,
                                 default = nil)
  if valid_574867 != nil:
    section.add "api-version", valid_574867
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574868: Call_WorkflowsDelete_574861; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a workflow.
  ## 
  let valid = call_574868.validator(path, query, header, formData, body)
  let scheme = call_574868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574868.url(scheme.get, call_574868.host, call_574868.base,
                         call_574868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574868, url, valid)

proc call*(call_574869: Call_WorkflowsDelete_574861; workflowName: string;
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
  var path_574870 = newJObject()
  var query_574871 = newJObject()
  add(path_574870, "workflowName", newJString(workflowName))
  add(path_574870, "resourceGroupName", newJString(resourceGroupName))
  add(query_574871, "api-version", newJString(apiVersion))
  add(path_574870, "subscriptionId", newJString(subscriptionId))
  result = call_574869.call(path_574870, query_574871, nil, nil, nil)

var workflowsDelete* = Call_WorkflowsDelete_574861(name: "workflowsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsDelete_574862, base: "", url: url_WorkflowsDelete_574863,
    schemes: {Scheme.Https})
type
  Call_WorkflowsDisable_574885 = ref object of OpenApiRestCall_573667
proc url_WorkflowsDisable_574887(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsDisable_574886(path: JsonNode; query: JsonNode;
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
  var valid_574888 = path.getOrDefault("workflowName")
  valid_574888 = validateParameter(valid_574888, JString, required = true,
                                 default = nil)
  if valid_574888 != nil:
    section.add "workflowName", valid_574888
  var valid_574889 = path.getOrDefault("resourceGroupName")
  valid_574889 = validateParameter(valid_574889, JString, required = true,
                                 default = nil)
  if valid_574889 != nil:
    section.add "resourceGroupName", valid_574889
  var valid_574890 = path.getOrDefault("subscriptionId")
  valid_574890 = validateParameter(valid_574890, JString, required = true,
                                 default = nil)
  if valid_574890 != nil:
    section.add "subscriptionId", valid_574890
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574891 = query.getOrDefault("api-version")
  valid_574891 = validateParameter(valid_574891, JString, required = true,
                                 default = nil)
  if valid_574891 != nil:
    section.add "api-version", valid_574891
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574892: Call_WorkflowsDisable_574885; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disables a workflow.
  ## 
  let valid = call_574892.validator(path, query, header, formData, body)
  let scheme = call_574892.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574892.url(scheme.get, call_574892.host, call_574892.base,
                         call_574892.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574892, url, valid)

proc call*(call_574893: Call_WorkflowsDisable_574885; workflowName: string;
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
  var path_574894 = newJObject()
  var query_574895 = newJObject()
  add(path_574894, "workflowName", newJString(workflowName))
  add(path_574894, "resourceGroupName", newJString(resourceGroupName))
  add(query_574895, "api-version", newJString(apiVersion))
  add(path_574894, "subscriptionId", newJString(subscriptionId))
  result = call_574893.call(path_574894, query_574895, nil, nil, nil)

var workflowsDisable* = Call_WorkflowsDisable_574885(name: "workflowsDisable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/disable",
    validator: validate_WorkflowsDisable_574886, base: "",
    url: url_WorkflowsDisable_574887, schemes: {Scheme.Https})
type
  Call_WorkflowsEnable_574896 = ref object of OpenApiRestCall_573667
proc url_WorkflowsEnable_574898(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsEnable_574897(path: JsonNode; query: JsonNode;
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
  var valid_574899 = path.getOrDefault("workflowName")
  valid_574899 = validateParameter(valid_574899, JString, required = true,
                                 default = nil)
  if valid_574899 != nil:
    section.add "workflowName", valid_574899
  var valid_574900 = path.getOrDefault("resourceGroupName")
  valid_574900 = validateParameter(valid_574900, JString, required = true,
                                 default = nil)
  if valid_574900 != nil:
    section.add "resourceGroupName", valid_574900
  var valid_574901 = path.getOrDefault("subscriptionId")
  valid_574901 = validateParameter(valid_574901, JString, required = true,
                                 default = nil)
  if valid_574901 != nil:
    section.add "subscriptionId", valid_574901
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574902 = query.getOrDefault("api-version")
  valid_574902 = validateParameter(valid_574902, JString, required = true,
                                 default = nil)
  if valid_574902 != nil:
    section.add "api-version", valid_574902
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574903: Call_WorkflowsEnable_574896; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables a workflow.
  ## 
  let valid = call_574903.validator(path, query, header, formData, body)
  let scheme = call_574903.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574903.url(scheme.get, call_574903.host, call_574903.base,
                         call_574903.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574903, url, valid)

proc call*(call_574904: Call_WorkflowsEnable_574896; workflowName: string;
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
  var path_574905 = newJObject()
  var query_574906 = newJObject()
  add(path_574905, "workflowName", newJString(workflowName))
  add(path_574905, "resourceGroupName", newJString(resourceGroupName))
  add(query_574906, "api-version", newJString(apiVersion))
  add(path_574905, "subscriptionId", newJString(subscriptionId))
  result = call_574904.call(path_574905, query_574906, nil, nil, nil)

var workflowsEnable* = Call_WorkflowsEnable_574896(name: "workflowsEnable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/enable",
    validator: validate_WorkflowsEnable_574897, base: "", url: url_WorkflowsEnable_574898,
    schemes: {Scheme.Https})
type
  Call_WorkflowsGenerateUpgradedDefinition_574907 = ref object of OpenApiRestCall_573667
proc url_WorkflowsGenerateUpgradedDefinition_574909(protocol: Scheme; host: string;
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

proc validate_WorkflowsGenerateUpgradedDefinition_574908(path: JsonNode;
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
  var valid_574910 = path.getOrDefault("workflowName")
  valid_574910 = validateParameter(valid_574910, JString, required = true,
                                 default = nil)
  if valid_574910 != nil:
    section.add "workflowName", valid_574910
  var valid_574911 = path.getOrDefault("resourceGroupName")
  valid_574911 = validateParameter(valid_574911, JString, required = true,
                                 default = nil)
  if valid_574911 != nil:
    section.add "resourceGroupName", valid_574911
  var valid_574912 = path.getOrDefault("subscriptionId")
  valid_574912 = validateParameter(valid_574912, JString, required = true,
                                 default = nil)
  if valid_574912 != nil:
    section.add "subscriptionId", valid_574912
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574913 = query.getOrDefault("api-version")
  valid_574913 = validateParameter(valid_574913, JString, required = true,
                                 default = nil)
  if valid_574913 != nil:
    section.add "api-version", valid_574913
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

proc call*(call_574915: Call_WorkflowsGenerateUpgradedDefinition_574907;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates the upgraded definition for a workflow.
  ## 
  let valid = call_574915.validator(path, query, header, formData, body)
  let scheme = call_574915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574915.url(scheme.get, call_574915.host, call_574915.base,
                         call_574915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574915, url, valid)

proc call*(call_574916: Call_WorkflowsGenerateUpgradedDefinition_574907;
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
  var path_574917 = newJObject()
  var query_574918 = newJObject()
  var body_574919 = newJObject()
  add(path_574917, "workflowName", newJString(workflowName))
  add(path_574917, "resourceGroupName", newJString(resourceGroupName))
  add(query_574918, "api-version", newJString(apiVersion))
  add(path_574917, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574919 = parameters
  result = call_574916.call(path_574917, query_574918, nil, nil, body_574919)

var workflowsGenerateUpgradedDefinition* = Call_WorkflowsGenerateUpgradedDefinition_574907(
    name: "workflowsGenerateUpgradedDefinition", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/generateUpgradedDefinition",
    validator: validate_WorkflowsGenerateUpgradedDefinition_574908, base: "",
    url: url_WorkflowsGenerateUpgradedDefinition_574909, schemes: {Scheme.Https})
type
  Call_WorkflowsListCallbackUrl_574920 = ref object of OpenApiRestCall_573667
proc url_WorkflowsListCallbackUrl_574922(protocol: Scheme; host: string;
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

proc validate_WorkflowsListCallbackUrl_574921(path: JsonNode; query: JsonNode;
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
  var valid_574923 = path.getOrDefault("workflowName")
  valid_574923 = validateParameter(valid_574923, JString, required = true,
                                 default = nil)
  if valid_574923 != nil:
    section.add "workflowName", valid_574923
  var valid_574924 = path.getOrDefault("resourceGroupName")
  valid_574924 = validateParameter(valid_574924, JString, required = true,
                                 default = nil)
  if valid_574924 != nil:
    section.add "resourceGroupName", valid_574924
  var valid_574925 = path.getOrDefault("subscriptionId")
  valid_574925 = validateParameter(valid_574925, JString, required = true,
                                 default = nil)
  if valid_574925 != nil:
    section.add "subscriptionId", valid_574925
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574926 = query.getOrDefault("api-version")
  valid_574926 = validateParameter(valid_574926, JString, required = true,
                                 default = nil)
  if valid_574926 != nil:
    section.add "api-version", valid_574926
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

proc call*(call_574928: Call_WorkflowsListCallbackUrl_574920; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the workflow callback Url.
  ## 
  let valid = call_574928.validator(path, query, header, formData, body)
  let scheme = call_574928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574928.url(scheme.get, call_574928.host, call_574928.base,
                         call_574928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574928, url, valid)

proc call*(call_574929: Call_WorkflowsListCallbackUrl_574920; workflowName: string;
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
  var path_574930 = newJObject()
  var query_574931 = newJObject()
  var body_574932 = newJObject()
  add(path_574930, "workflowName", newJString(workflowName))
  add(path_574930, "resourceGroupName", newJString(resourceGroupName))
  add(query_574931, "api-version", newJString(apiVersion))
  if listCallbackUrl != nil:
    body_574932 = listCallbackUrl
  add(path_574930, "subscriptionId", newJString(subscriptionId))
  result = call_574929.call(path_574930, query_574931, nil, nil, body_574932)

var workflowsListCallbackUrl* = Call_WorkflowsListCallbackUrl_574920(
    name: "workflowsListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/listCallbackUrl",
    validator: validate_WorkflowsListCallbackUrl_574921, base: "",
    url: url_WorkflowsListCallbackUrl_574922, schemes: {Scheme.Https})
type
  Call_WorkflowsListSwagger_574933 = ref object of OpenApiRestCall_573667
proc url_WorkflowsListSwagger_574935(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsListSwagger_574934(path: JsonNode; query: JsonNode;
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
  var valid_574936 = path.getOrDefault("workflowName")
  valid_574936 = validateParameter(valid_574936, JString, required = true,
                                 default = nil)
  if valid_574936 != nil:
    section.add "workflowName", valid_574936
  var valid_574937 = path.getOrDefault("resourceGroupName")
  valid_574937 = validateParameter(valid_574937, JString, required = true,
                                 default = nil)
  if valid_574937 != nil:
    section.add "resourceGroupName", valid_574937
  var valid_574938 = path.getOrDefault("subscriptionId")
  valid_574938 = validateParameter(valid_574938, JString, required = true,
                                 default = nil)
  if valid_574938 != nil:
    section.add "subscriptionId", valid_574938
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574939 = query.getOrDefault("api-version")
  valid_574939 = validateParameter(valid_574939, JString, required = true,
                                 default = nil)
  if valid_574939 != nil:
    section.add "api-version", valid_574939
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574940: Call_WorkflowsListSwagger_574933; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an OpenAPI definition for the workflow.
  ## 
  let valid = call_574940.validator(path, query, header, formData, body)
  let scheme = call_574940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574940.url(scheme.get, call_574940.host, call_574940.base,
                         call_574940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574940, url, valid)

proc call*(call_574941: Call_WorkflowsListSwagger_574933; workflowName: string;
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
  var path_574942 = newJObject()
  var query_574943 = newJObject()
  add(path_574942, "workflowName", newJString(workflowName))
  add(path_574942, "resourceGroupName", newJString(resourceGroupName))
  add(query_574943, "api-version", newJString(apiVersion))
  add(path_574942, "subscriptionId", newJString(subscriptionId))
  result = call_574941.call(path_574942, query_574943, nil, nil, nil)

var workflowsListSwagger* = Call_WorkflowsListSwagger_574933(
    name: "workflowsListSwagger", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/listSwagger",
    validator: validate_WorkflowsListSwagger_574934, base: "",
    url: url_WorkflowsListSwagger_574935, schemes: {Scheme.Https})
type
  Call_WorkflowsMove_574944 = ref object of OpenApiRestCall_573667
proc url_WorkflowsMove_574946(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsMove_574945(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574947 = path.getOrDefault("workflowName")
  valid_574947 = validateParameter(valid_574947, JString, required = true,
                                 default = nil)
  if valid_574947 != nil:
    section.add "workflowName", valid_574947
  var valid_574948 = path.getOrDefault("resourceGroupName")
  valid_574948 = validateParameter(valid_574948, JString, required = true,
                                 default = nil)
  if valid_574948 != nil:
    section.add "resourceGroupName", valid_574948
  var valid_574949 = path.getOrDefault("subscriptionId")
  valid_574949 = validateParameter(valid_574949, JString, required = true,
                                 default = nil)
  if valid_574949 != nil:
    section.add "subscriptionId", valid_574949
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574950 = query.getOrDefault("api-version")
  valid_574950 = validateParameter(valid_574950, JString, required = true,
                                 default = nil)
  if valid_574950 != nil:
    section.add "api-version", valid_574950
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

proc call*(call_574952: Call_WorkflowsMove_574944; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves an existing workflow.
  ## 
  let valid = call_574952.validator(path, query, header, formData, body)
  let scheme = call_574952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574952.url(scheme.get, call_574952.host, call_574952.base,
                         call_574952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574952, url, valid)

proc call*(call_574953: Call_WorkflowsMove_574944; workflowName: string;
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
  var path_574954 = newJObject()
  var query_574955 = newJObject()
  var body_574956 = newJObject()
  add(path_574954, "workflowName", newJString(workflowName))
  if move != nil:
    body_574956 = move
  add(path_574954, "resourceGroupName", newJString(resourceGroupName))
  add(query_574955, "api-version", newJString(apiVersion))
  add(path_574954, "subscriptionId", newJString(subscriptionId))
  result = call_574953.call(path_574954, query_574955, nil, nil, body_574956)

var workflowsMove* = Call_WorkflowsMove_574944(name: "workflowsMove",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/move",
    validator: validate_WorkflowsMove_574945, base: "", url: url_WorkflowsMove_574946,
    schemes: {Scheme.Https})
type
  Call_WorkflowsRegenerateAccessKey_574957 = ref object of OpenApiRestCall_573667
proc url_WorkflowsRegenerateAccessKey_574959(protocol: Scheme; host: string;
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

proc validate_WorkflowsRegenerateAccessKey_574958(path: JsonNode; query: JsonNode;
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
  var valid_574960 = path.getOrDefault("workflowName")
  valid_574960 = validateParameter(valid_574960, JString, required = true,
                                 default = nil)
  if valid_574960 != nil:
    section.add "workflowName", valid_574960
  var valid_574961 = path.getOrDefault("resourceGroupName")
  valid_574961 = validateParameter(valid_574961, JString, required = true,
                                 default = nil)
  if valid_574961 != nil:
    section.add "resourceGroupName", valid_574961
  var valid_574962 = path.getOrDefault("subscriptionId")
  valid_574962 = validateParameter(valid_574962, JString, required = true,
                                 default = nil)
  if valid_574962 != nil:
    section.add "subscriptionId", valid_574962
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574963 = query.getOrDefault("api-version")
  valid_574963 = validateParameter(valid_574963, JString, required = true,
                                 default = nil)
  if valid_574963 != nil:
    section.add "api-version", valid_574963
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

proc call*(call_574965: Call_WorkflowsRegenerateAccessKey_574957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the callback URL access key for request triggers.
  ## 
  let valid = call_574965.validator(path, query, header, formData, body)
  let scheme = call_574965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574965.url(scheme.get, call_574965.host, call_574965.base,
                         call_574965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574965, url, valid)

proc call*(call_574966: Call_WorkflowsRegenerateAccessKey_574957;
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
  var path_574967 = newJObject()
  var query_574968 = newJObject()
  var body_574969 = newJObject()
  add(path_574967, "workflowName", newJString(workflowName))
  add(path_574967, "resourceGroupName", newJString(resourceGroupName))
  add(query_574968, "api-version", newJString(apiVersion))
  add(path_574967, "subscriptionId", newJString(subscriptionId))
  if keyType != nil:
    body_574969 = keyType
  result = call_574966.call(path_574967, query_574968, nil, nil, body_574969)

var workflowsRegenerateAccessKey* = Call_WorkflowsRegenerateAccessKey_574957(
    name: "workflowsRegenerateAccessKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/regenerateAccessKey",
    validator: validate_WorkflowsRegenerateAccessKey_574958, base: "",
    url: url_WorkflowsRegenerateAccessKey_574959, schemes: {Scheme.Https})
type
  Call_WorkflowRunsList_574970 = ref object of OpenApiRestCall_573667
proc url_WorkflowRunsList_574972(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsList_574971(path: JsonNode; query: JsonNode;
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
  var valid_574973 = path.getOrDefault("workflowName")
  valid_574973 = validateParameter(valid_574973, JString, required = true,
                                 default = nil)
  if valid_574973 != nil:
    section.add "workflowName", valid_574973
  var valid_574974 = path.getOrDefault("resourceGroupName")
  valid_574974 = validateParameter(valid_574974, JString, required = true,
                                 default = nil)
  if valid_574974 != nil:
    section.add "resourceGroupName", valid_574974
  var valid_574975 = path.getOrDefault("subscriptionId")
  valid_574975 = validateParameter(valid_574975, JString, required = true,
                                 default = nil)
  if valid_574975 != nil:
    section.add "subscriptionId", valid_574975
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
  var valid_574976 = query.getOrDefault("api-version")
  valid_574976 = validateParameter(valid_574976, JString, required = true,
                                 default = nil)
  if valid_574976 != nil:
    section.add "api-version", valid_574976
  var valid_574977 = query.getOrDefault("$top")
  valid_574977 = validateParameter(valid_574977, JInt, required = false, default = nil)
  if valid_574977 != nil:
    section.add "$top", valid_574977
  var valid_574978 = query.getOrDefault("$filter")
  valid_574978 = validateParameter(valid_574978, JString, required = false,
                                 default = nil)
  if valid_574978 != nil:
    section.add "$filter", valid_574978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574979: Call_WorkflowRunsList_574970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow runs.
  ## 
  let valid = call_574979.validator(path, query, header, formData, body)
  let scheme = call_574979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574979.url(scheme.get, call_574979.host, call_574979.base,
                         call_574979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574979, url, valid)

proc call*(call_574980: Call_WorkflowRunsList_574970; workflowName: string;
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
  var path_574981 = newJObject()
  var query_574982 = newJObject()
  add(path_574981, "workflowName", newJString(workflowName))
  add(path_574981, "resourceGroupName", newJString(resourceGroupName))
  add(query_574982, "api-version", newJString(apiVersion))
  add(path_574981, "subscriptionId", newJString(subscriptionId))
  add(query_574982, "$top", newJInt(Top))
  add(query_574982, "$filter", newJString(Filter))
  result = call_574980.call(path_574981, query_574982, nil, nil, nil)

var workflowRunsList* = Call_WorkflowRunsList_574970(name: "workflowRunsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs",
    validator: validate_WorkflowRunsList_574971, base: "",
    url: url_WorkflowRunsList_574972, schemes: {Scheme.Https})
type
  Call_WorkflowRunsGet_574983 = ref object of OpenApiRestCall_573667
proc url_WorkflowRunsGet_574985(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsGet_574984(path: JsonNode; query: JsonNode;
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
  var valid_574986 = path.getOrDefault("workflowName")
  valid_574986 = validateParameter(valid_574986, JString, required = true,
                                 default = nil)
  if valid_574986 != nil:
    section.add "workflowName", valid_574986
  var valid_574987 = path.getOrDefault("resourceGroupName")
  valid_574987 = validateParameter(valid_574987, JString, required = true,
                                 default = nil)
  if valid_574987 != nil:
    section.add "resourceGroupName", valid_574987
  var valid_574988 = path.getOrDefault("runName")
  valid_574988 = validateParameter(valid_574988, JString, required = true,
                                 default = nil)
  if valid_574988 != nil:
    section.add "runName", valid_574988
  var valid_574989 = path.getOrDefault("subscriptionId")
  valid_574989 = validateParameter(valid_574989, JString, required = true,
                                 default = nil)
  if valid_574989 != nil:
    section.add "subscriptionId", valid_574989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574990 = query.getOrDefault("api-version")
  valid_574990 = validateParameter(valid_574990, JString, required = true,
                                 default = nil)
  if valid_574990 != nil:
    section.add "api-version", valid_574990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574991: Call_WorkflowRunsGet_574983; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow run.
  ## 
  let valid = call_574991.validator(path, query, header, formData, body)
  let scheme = call_574991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574991.url(scheme.get, call_574991.host, call_574991.base,
                         call_574991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574991, url, valid)

proc call*(call_574992: Call_WorkflowRunsGet_574983; workflowName: string;
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
  var path_574993 = newJObject()
  var query_574994 = newJObject()
  add(path_574993, "workflowName", newJString(workflowName))
  add(path_574993, "resourceGroupName", newJString(resourceGroupName))
  add(path_574993, "runName", newJString(runName))
  add(query_574994, "api-version", newJString(apiVersion))
  add(path_574993, "subscriptionId", newJString(subscriptionId))
  result = call_574992.call(path_574993, query_574994, nil, nil, nil)

var workflowRunsGet* = Call_WorkflowRunsGet_574983(name: "workflowRunsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}",
    validator: validate_WorkflowRunsGet_574984, base: "", url: url_WorkflowRunsGet_574985,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsList_574995 = ref object of OpenApiRestCall_573667
proc url_WorkflowRunActionsList_574997(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunActionsList_574996(path: JsonNode; query: JsonNode;
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
  var valid_574998 = path.getOrDefault("workflowName")
  valid_574998 = validateParameter(valid_574998, JString, required = true,
                                 default = nil)
  if valid_574998 != nil:
    section.add "workflowName", valid_574998
  var valid_574999 = path.getOrDefault("resourceGroupName")
  valid_574999 = validateParameter(valid_574999, JString, required = true,
                                 default = nil)
  if valid_574999 != nil:
    section.add "resourceGroupName", valid_574999
  var valid_575000 = path.getOrDefault("runName")
  valid_575000 = validateParameter(valid_575000, JString, required = true,
                                 default = nil)
  if valid_575000 != nil:
    section.add "runName", valid_575000
  var valid_575001 = path.getOrDefault("subscriptionId")
  valid_575001 = validateParameter(valid_575001, JString, required = true,
                                 default = nil)
  if valid_575001 != nil:
    section.add "subscriptionId", valid_575001
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
  var valid_575002 = query.getOrDefault("api-version")
  valid_575002 = validateParameter(valid_575002, JString, required = true,
                                 default = nil)
  if valid_575002 != nil:
    section.add "api-version", valid_575002
  var valid_575003 = query.getOrDefault("$top")
  valid_575003 = validateParameter(valid_575003, JInt, required = false, default = nil)
  if valid_575003 != nil:
    section.add "$top", valid_575003
  var valid_575004 = query.getOrDefault("$filter")
  valid_575004 = validateParameter(valid_575004, JString, required = false,
                                 default = nil)
  if valid_575004 != nil:
    section.add "$filter", valid_575004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575005: Call_WorkflowRunActionsList_574995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow run actions.
  ## 
  let valid = call_575005.validator(path, query, header, formData, body)
  let scheme = call_575005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575005.url(scheme.get, call_575005.host, call_575005.base,
                         call_575005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575005, url, valid)

proc call*(call_575006: Call_WorkflowRunActionsList_574995; workflowName: string;
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
  var path_575007 = newJObject()
  var query_575008 = newJObject()
  add(path_575007, "workflowName", newJString(workflowName))
  add(path_575007, "resourceGroupName", newJString(resourceGroupName))
  add(path_575007, "runName", newJString(runName))
  add(query_575008, "api-version", newJString(apiVersion))
  add(path_575007, "subscriptionId", newJString(subscriptionId))
  add(query_575008, "$top", newJInt(Top))
  add(query_575008, "$filter", newJString(Filter))
  result = call_575006.call(path_575007, query_575008, nil, nil, nil)

var workflowRunActionsList* = Call_WorkflowRunActionsList_574995(
    name: "workflowRunActionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions",
    validator: validate_WorkflowRunActionsList_574996, base: "",
    url: url_WorkflowRunActionsList_574997, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsGet_575009 = ref object of OpenApiRestCall_573667
proc url_WorkflowRunActionsGet_575011(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunActionsGet_575010(path: JsonNode; query: JsonNode;
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
  var valid_575012 = path.getOrDefault("workflowName")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = nil)
  if valid_575012 != nil:
    section.add "workflowName", valid_575012
  var valid_575013 = path.getOrDefault("actionName")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "actionName", valid_575013
  var valid_575014 = path.getOrDefault("resourceGroupName")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "resourceGroupName", valid_575014
  var valid_575015 = path.getOrDefault("runName")
  valid_575015 = validateParameter(valid_575015, JString, required = true,
                                 default = nil)
  if valid_575015 != nil:
    section.add "runName", valid_575015
  var valid_575016 = path.getOrDefault("subscriptionId")
  valid_575016 = validateParameter(valid_575016, JString, required = true,
                                 default = nil)
  if valid_575016 != nil:
    section.add "subscriptionId", valid_575016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575017 = query.getOrDefault("api-version")
  valid_575017 = validateParameter(valid_575017, JString, required = true,
                                 default = nil)
  if valid_575017 != nil:
    section.add "api-version", valid_575017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575018: Call_WorkflowRunActionsGet_575009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow run action.
  ## 
  let valid = call_575018.validator(path, query, header, formData, body)
  let scheme = call_575018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575018.url(scheme.get, call_575018.host, call_575018.base,
                         call_575018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575018, url, valid)

proc call*(call_575019: Call_WorkflowRunActionsGet_575009; workflowName: string;
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
  var path_575020 = newJObject()
  var query_575021 = newJObject()
  add(path_575020, "workflowName", newJString(workflowName))
  add(path_575020, "actionName", newJString(actionName))
  add(path_575020, "resourceGroupName", newJString(resourceGroupName))
  add(path_575020, "runName", newJString(runName))
  add(query_575021, "api-version", newJString(apiVersion))
  add(path_575020, "subscriptionId", newJString(subscriptionId))
  result = call_575019.call(path_575020, query_575021, nil, nil, nil)

var workflowRunActionsGet* = Call_WorkflowRunActionsGet_575009(
    name: "workflowRunActionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}",
    validator: validate_WorkflowRunActionsGet_575010, base: "",
    url: url_WorkflowRunActionsGet_575011, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsListExpressionTraces_575022 = ref object of OpenApiRestCall_573667
proc url_WorkflowRunActionsListExpressionTraces_575024(protocol: Scheme;
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

proc validate_WorkflowRunActionsListExpressionTraces_575023(path: JsonNode;
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
  var valid_575025 = path.getOrDefault("workflowName")
  valid_575025 = validateParameter(valid_575025, JString, required = true,
                                 default = nil)
  if valid_575025 != nil:
    section.add "workflowName", valid_575025
  var valid_575026 = path.getOrDefault("actionName")
  valid_575026 = validateParameter(valid_575026, JString, required = true,
                                 default = nil)
  if valid_575026 != nil:
    section.add "actionName", valid_575026
  var valid_575027 = path.getOrDefault("resourceGroupName")
  valid_575027 = validateParameter(valid_575027, JString, required = true,
                                 default = nil)
  if valid_575027 != nil:
    section.add "resourceGroupName", valid_575027
  var valid_575028 = path.getOrDefault("runName")
  valid_575028 = validateParameter(valid_575028, JString, required = true,
                                 default = nil)
  if valid_575028 != nil:
    section.add "runName", valid_575028
  var valid_575029 = path.getOrDefault("subscriptionId")
  valid_575029 = validateParameter(valid_575029, JString, required = true,
                                 default = nil)
  if valid_575029 != nil:
    section.add "subscriptionId", valid_575029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575030 = query.getOrDefault("api-version")
  valid_575030 = validateParameter(valid_575030, JString, required = true,
                                 default = nil)
  if valid_575030 != nil:
    section.add "api-version", valid_575030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575031: Call_WorkflowRunActionsListExpressionTraces_575022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a workflow run expression trace.
  ## 
  let valid = call_575031.validator(path, query, header, formData, body)
  let scheme = call_575031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575031.url(scheme.get, call_575031.host, call_575031.base,
                         call_575031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575031, url, valid)

proc call*(call_575032: Call_WorkflowRunActionsListExpressionTraces_575022;
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
  var path_575033 = newJObject()
  var query_575034 = newJObject()
  add(path_575033, "workflowName", newJString(workflowName))
  add(path_575033, "actionName", newJString(actionName))
  add(path_575033, "resourceGroupName", newJString(resourceGroupName))
  add(path_575033, "runName", newJString(runName))
  add(query_575034, "api-version", newJString(apiVersion))
  add(path_575033, "subscriptionId", newJString(subscriptionId))
  result = call_575032.call(path_575033, query_575034, nil, nil, nil)

var workflowRunActionsListExpressionTraces* = Call_WorkflowRunActionsListExpressionTraces_575022(
    name: "workflowRunActionsListExpressionTraces", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/listExpressionTraces",
    validator: validate_WorkflowRunActionsListExpressionTraces_575023, base: "",
    url: url_WorkflowRunActionsListExpressionTraces_575024,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsList_575035 = ref object of OpenApiRestCall_573667
proc url_WorkflowRunActionRepetitionsList_575037(protocol: Scheme; host: string;
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

proc validate_WorkflowRunActionRepetitionsList_575036(path: JsonNode;
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
  var valid_575038 = path.getOrDefault("workflowName")
  valid_575038 = validateParameter(valid_575038, JString, required = true,
                                 default = nil)
  if valid_575038 != nil:
    section.add "workflowName", valid_575038
  var valid_575039 = path.getOrDefault("actionName")
  valid_575039 = validateParameter(valid_575039, JString, required = true,
                                 default = nil)
  if valid_575039 != nil:
    section.add "actionName", valid_575039
  var valid_575040 = path.getOrDefault("resourceGroupName")
  valid_575040 = validateParameter(valid_575040, JString, required = true,
                                 default = nil)
  if valid_575040 != nil:
    section.add "resourceGroupName", valid_575040
  var valid_575041 = path.getOrDefault("runName")
  valid_575041 = validateParameter(valid_575041, JString, required = true,
                                 default = nil)
  if valid_575041 != nil:
    section.add "runName", valid_575041
  var valid_575042 = path.getOrDefault("subscriptionId")
  valid_575042 = validateParameter(valid_575042, JString, required = true,
                                 default = nil)
  if valid_575042 != nil:
    section.add "subscriptionId", valid_575042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575043 = query.getOrDefault("api-version")
  valid_575043 = validateParameter(valid_575043, JString, required = true,
                                 default = nil)
  if valid_575043 != nil:
    section.add "api-version", valid_575043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575044: Call_WorkflowRunActionRepetitionsList_575035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all of a workflow run action repetitions.
  ## 
  let valid = call_575044.validator(path, query, header, formData, body)
  let scheme = call_575044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575044.url(scheme.get, call_575044.host, call_575044.base,
                         call_575044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575044, url, valid)

proc call*(call_575045: Call_WorkflowRunActionRepetitionsList_575035;
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
  var path_575046 = newJObject()
  var query_575047 = newJObject()
  add(path_575046, "workflowName", newJString(workflowName))
  add(path_575046, "actionName", newJString(actionName))
  add(path_575046, "resourceGroupName", newJString(resourceGroupName))
  add(path_575046, "runName", newJString(runName))
  add(query_575047, "api-version", newJString(apiVersion))
  add(path_575046, "subscriptionId", newJString(subscriptionId))
  result = call_575045.call(path_575046, query_575047, nil, nil, nil)

var workflowRunActionRepetitionsList* = Call_WorkflowRunActionRepetitionsList_575035(
    name: "workflowRunActionRepetitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions",
    validator: validate_WorkflowRunActionRepetitionsList_575036, base: "",
    url: url_WorkflowRunActionRepetitionsList_575037, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsGet_575048 = ref object of OpenApiRestCall_573667
proc url_WorkflowRunActionRepetitionsGet_575050(protocol: Scheme; host: string;
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

proc validate_WorkflowRunActionRepetitionsGet_575049(path: JsonNode;
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
  var valid_575051 = path.getOrDefault("workflowName")
  valid_575051 = validateParameter(valid_575051, JString, required = true,
                                 default = nil)
  if valid_575051 != nil:
    section.add "workflowName", valid_575051
  var valid_575052 = path.getOrDefault("actionName")
  valid_575052 = validateParameter(valid_575052, JString, required = true,
                                 default = nil)
  if valid_575052 != nil:
    section.add "actionName", valid_575052
  var valid_575053 = path.getOrDefault("resourceGroupName")
  valid_575053 = validateParameter(valid_575053, JString, required = true,
                                 default = nil)
  if valid_575053 != nil:
    section.add "resourceGroupName", valid_575053
  var valid_575054 = path.getOrDefault("runName")
  valid_575054 = validateParameter(valid_575054, JString, required = true,
                                 default = nil)
  if valid_575054 != nil:
    section.add "runName", valid_575054
  var valid_575055 = path.getOrDefault("subscriptionId")
  valid_575055 = validateParameter(valid_575055, JString, required = true,
                                 default = nil)
  if valid_575055 != nil:
    section.add "subscriptionId", valid_575055
  var valid_575056 = path.getOrDefault("repetitionName")
  valid_575056 = validateParameter(valid_575056, JString, required = true,
                                 default = nil)
  if valid_575056 != nil:
    section.add "repetitionName", valid_575056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575057 = query.getOrDefault("api-version")
  valid_575057 = validateParameter(valid_575057, JString, required = true,
                                 default = nil)
  if valid_575057 != nil:
    section.add "api-version", valid_575057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575058: Call_WorkflowRunActionRepetitionsGet_575048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a workflow run action repetition.
  ## 
  let valid = call_575058.validator(path, query, header, formData, body)
  let scheme = call_575058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575058.url(scheme.get, call_575058.host, call_575058.base,
                         call_575058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575058, url, valid)

proc call*(call_575059: Call_WorkflowRunActionRepetitionsGet_575048;
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
  var path_575060 = newJObject()
  var query_575061 = newJObject()
  add(path_575060, "workflowName", newJString(workflowName))
  add(path_575060, "actionName", newJString(actionName))
  add(path_575060, "resourceGroupName", newJString(resourceGroupName))
  add(path_575060, "runName", newJString(runName))
  add(query_575061, "api-version", newJString(apiVersion))
  add(path_575060, "subscriptionId", newJString(subscriptionId))
  add(path_575060, "repetitionName", newJString(repetitionName))
  result = call_575059.call(path_575060, query_575061, nil, nil, nil)

var workflowRunActionRepetitionsGet* = Call_WorkflowRunActionRepetitionsGet_575048(
    name: "workflowRunActionRepetitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}",
    validator: validate_WorkflowRunActionRepetitionsGet_575049, base: "",
    url: url_WorkflowRunActionRepetitionsGet_575050, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsListExpressionTraces_575062 = ref object of OpenApiRestCall_573667
proc url_WorkflowRunActionRepetitionsListExpressionTraces_575064(
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

proc validate_WorkflowRunActionRepetitionsListExpressionTraces_575063(
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
  var valid_575065 = path.getOrDefault("workflowName")
  valid_575065 = validateParameter(valid_575065, JString, required = true,
                                 default = nil)
  if valid_575065 != nil:
    section.add "workflowName", valid_575065
  var valid_575066 = path.getOrDefault("actionName")
  valid_575066 = validateParameter(valid_575066, JString, required = true,
                                 default = nil)
  if valid_575066 != nil:
    section.add "actionName", valid_575066
  var valid_575067 = path.getOrDefault("resourceGroupName")
  valid_575067 = validateParameter(valid_575067, JString, required = true,
                                 default = nil)
  if valid_575067 != nil:
    section.add "resourceGroupName", valid_575067
  var valid_575068 = path.getOrDefault("runName")
  valid_575068 = validateParameter(valid_575068, JString, required = true,
                                 default = nil)
  if valid_575068 != nil:
    section.add "runName", valid_575068
  var valid_575069 = path.getOrDefault("subscriptionId")
  valid_575069 = validateParameter(valid_575069, JString, required = true,
                                 default = nil)
  if valid_575069 != nil:
    section.add "subscriptionId", valid_575069
  var valid_575070 = path.getOrDefault("repetitionName")
  valid_575070 = validateParameter(valid_575070, JString, required = true,
                                 default = nil)
  if valid_575070 != nil:
    section.add "repetitionName", valid_575070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575071 = query.getOrDefault("api-version")
  valid_575071 = validateParameter(valid_575071, JString, required = true,
                                 default = nil)
  if valid_575071 != nil:
    section.add "api-version", valid_575071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575072: Call_WorkflowRunActionRepetitionsListExpressionTraces_575062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a workflow run expression trace.
  ## 
  let valid = call_575072.validator(path, query, header, formData, body)
  let scheme = call_575072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575072.url(scheme.get, call_575072.host, call_575072.base,
                         call_575072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575072, url, valid)

proc call*(call_575073: Call_WorkflowRunActionRepetitionsListExpressionTraces_575062;
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
  var path_575074 = newJObject()
  var query_575075 = newJObject()
  add(path_575074, "workflowName", newJString(workflowName))
  add(path_575074, "actionName", newJString(actionName))
  add(path_575074, "resourceGroupName", newJString(resourceGroupName))
  add(path_575074, "runName", newJString(runName))
  add(query_575075, "api-version", newJString(apiVersion))
  add(path_575074, "subscriptionId", newJString(subscriptionId))
  add(path_575074, "repetitionName", newJString(repetitionName))
  result = call_575073.call(path_575074, query_575075, nil, nil, nil)

var workflowRunActionRepetitionsListExpressionTraces* = Call_WorkflowRunActionRepetitionsListExpressionTraces_575062(
    name: "workflowRunActionRepetitionsListExpressionTraces",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/listExpressionTraces",
    validator: validate_WorkflowRunActionRepetitionsListExpressionTraces_575063,
    base: "", url: url_WorkflowRunActionRepetitionsListExpressionTraces_575064,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsRequestHistoriesList_575076 = ref object of OpenApiRestCall_573667
proc url_WorkflowRunActionRepetitionsRequestHistoriesList_575078(
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

proc validate_WorkflowRunActionRepetitionsRequestHistoriesList_575077(
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
  var valid_575079 = path.getOrDefault("workflowName")
  valid_575079 = validateParameter(valid_575079, JString, required = true,
                                 default = nil)
  if valid_575079 != nil:
    section.add "workflowName", valid_575079
  var valid_575080 = path.getOrDefault("actionName")
  valid_575080 = validateParameter(valid_575080, JString, required = true,
                                 default = nil)
  if valid_575080 != nil:
    section.add "actionName", valid_575080
  var valid_575081 = path.getOrDefault("resourceGroupName")
  valid_575081 = validateParameter(valid_575081, JString, required = true,
                                 default = nil)
  if valid_575081 != nil:
    section.add "resourceGroupName", valid_575081
  var valid_575082 = path.getOrDefault("runName")
  valid_575082 = validateParameter(valid_575082, JString, required = true,
                                 default = nil)
  if valid_575082 != nil:
    section.add "runName", valid_575082
  var valid_575083 = path.getOrDefault("subscriptionId")
  valid_575083 = validateParameter(valid_575083, JString, required = true,
                                 default = nil)
  if valid_575083 != nil:
    section.add "subscriptionId", valid_575083
  var valid_575084 = path.getOrDefault("repetitionName")
  valid_575084 = validateParameter(valid_575084, JString, required = true,
                                 default = nil)
  if valid_575084 != nil:
    section.add "repetitionName", valid_575084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575085 = query.getOrDefault("api-version")
  valid_575085 = validateParameter(valid_575085, JString, required = true,
                                 default = nil)
  if valid_575085 != nil:
    section.add "api-version", valid_575085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575086: Call_WorkflowRunActionRepetitionsRequestHistoriesList_575076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a workflow run repetition request history.
  ## 
  let valid = call_575086.validator(path, query, header, formData, body)
  let scheme = call_575086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575086.url(scheme.get, call_575086.host, call_575086.base,
                         call_575086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575086, url, valid)

proc call*(call_575087: Call_WorkflowRunActionRepetitionsRequestHistoriesList_575076;
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
  var path_575088 = newJObject()
  var query_575089 = newJObject()
  add(path_575088, "workflowName", newJString(workflowName))
  add(path_575088, "actionName", newJString(actionName))
  add(path_575088, "resourceGroupName", newJString(resourceGroupName))
  add(path_575088, "runName", newJString(runName))
  add(query_575089, "api-version", newJString(apiVersion))
  add(path_575088, "subscriptionId", newJString(subscriptionId))
  add(path_575088, "repetitionName", newJString(repetitionName))
  result = call_575087.call(path_575088, query_575089, nil, nil, nil)

var workflowRunActionRepetitionsRequestHistoriesList* = Call_WorkflowRunActionRepetitionsRequestHistoriesList_575076(
    name: "workflowRunActionRepetitionsRequestHistoriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/requestHistories",
    validator: validate_WorkflowRunActionRepetitionsRequestHistoriesList_575077,
    base: "", url: url_WorkflowRunActionRepetitionsRequestHistoriesList_575078,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsRequestHistoriesGet_575090 = ref object of OpenApiRestCall_573667
proc url_WorkflowRunActionRepetitionsRequestHistoriesGet_575092(protocol: Scheme;
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

proc validate_WorkflowRunActionRepetitionsRequestHistoriesGet_575091(
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
  var valid_575093 = path.getOrDefault("workflowName")
  valid_575093 = validateParameter(valid_575093, JString, required = true,
                                 default = nil)
  if valid_575093 != nil:
    section.add "workflowName", valid_575093
  var valid_575094 = path.getOrDefault("actionName")
  valid_575094 = validateParameter(valid_575094, JString, required = true,
                                 default = nil)
  if valid_575094 != nil:
    section.add "actionName", valid_575094
  var valid_575095 = path.getOrDefault("resourceGroupName")
  valid_575095 = validateParameter(valid_575095, JString, required = true,
                                 default = nil)
  if valid_575095 != nil:
    section.add "resourceGroupName", valid_575095
  var valid_575096 = path.getOrDefault("runName")
  valid_575096 = validateParameter(valid_575096, JString, required = true,
                                 default = nil)
  if valid_575096 != nil:
    section.add "runName", valid_575096
  var valid_575097 = path.getOrDefault("requestHistoryName")
  valid_575097 = validateParameter(valid_575097, JString, required = true,
                                 default = nil)
  if valid_575097 != nil:
    section.add "requestHistoryName", valid_575097
  var valid_575098 = path.getOrDefault("subscriptionId")
  valid_575098 = validateParameter(valid_575098, JString, required = true,
                                 default = nil)
  if valid_575098 != nil:
    section.add "subscriptionId", valid_575098
  var valid_575099 = path.getOrDefault("repetitionName")
  valid_575099 = validateParameter(valid_575099, JString, required = true,
                                 default = nil)
  if valid_575099 != nil:
    section.add "repetitionName", valid_575099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575100 = query.getOrDefault("api-version")
  valid_575100 = validateParameter(valid_575100, JString, required = true,
                                 default = nil)
  if valid_575100 != nil:
    section.add "api-version", valid_575100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575101: Call_WorkflowRunActionRepetitionsRequestHistoriesGet_575090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a workflow run repetition request history.
  ## 
  let valid = call_575101.validator(path, query, header, formData, body)
  let scheme = call_575101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575101.url(scheme.get, call_575101.host, call_575101.base,
                         call_575101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575101, url, valid)

proc call*(call_575102: Call_WorkflowRunActionRepetitionsRequestHistoriesGet_575090;
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
  var path_575103 = newJObject()
  var query_575104 = newJObject()
  add(path_575103, "workflowName", newJString(workflowName))
  add(path_575103, "actionName", newJString(actionName))
  add(path_575103, "resourceGroupName", newJString(resourceGroupName))
  add(path_575103, "runName", newJString(runName))
  add(query_575104, "api-version", newJString(apiVersion))
  add(path_575103, "requestHistoryName", newJString(requestHistoryName))
  add(path_575103, "subscriptionId", newJString(subscriptionId))
  add(path_575103, "repetitionName", newJString(repetitionName))
  result = call_575102.call(path_575103, query_575104, nil, nil, nil)

var workflowRunActionRepetitionsRequestHistoriesGet* = Call_WorkflowRunActionRepetitionsRequestHistoriesGet_575090(
    name: "workflowRunActionRepetitionsRequestHistoriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/requestHistories/{requestHistoryName}",
    validator: validate_WorkflowRunActionRepetitionsRequestHistoriesGet_575091,
    base: "", url: url_WorkflowRunActionRepetitionsRequestHistoriesGet_575092,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRequestHistoriesList_575105 = ref object of OpenApiRestCall_573667
proc url_WorkflowRunActionRequestHistoriesList_575107(protocol: Scheme;
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

proc validate_WorkflowRunActionRequestHistoriesList_575106(path: JsonNode;
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
  var valid_575108 = path.getOrDefault("workflowName")
  valid_575108 = validateParameter(valid_575108, JString, required = true,
                                 default = nil)
  if valid_575108 != nil:
    section.add "workflowName", valid_575108
  var valid_575109 = path.getOrDefault("actionName")
  valid_575109 = validateParameter(valid_575109, JString, required = true,
                                 default = nil)
  if valid_575109 != nil:
    section.add "actionName", valid_575109
  var valid_575110 = path.getOrDefault("resourceGroupName")
  valid_575110 = validateParameter(valid_575110, JString, required = true,
                                 default = nil)
  if valid_575110 != nil:
    section.add "resourceGroupName", valid_575110
  var valid_575111 = path.getOrDefault("runName")
  valid_575111 = validateParameter(valid_575111, JString, required = true,
                                 default = nil)
  if valid_575111 != nil:
    section.add "runName", valid_575111
  var valid_575112 = path.getOrDefault("subscriptionId")
  valid_575112 = validateParameter(valid_575112, JString, required = true,
                                 default = nil)
  if valid_575112 != nil:
    section.add "subscriptionId", valid_575112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575113 = query.getOrDefault("api-version")
  valid_575113 = validateParameter(valid_575113, JString, required = true,
                                 default = nil)
  if valid_575113 != nil:
    section.add "api-version", valid_575113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575114: Call_WorkflowRunActionRequestHistoriesList_575105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a workflow run request history.
  ## 
  let valid = call_575114.validator(path, query, header, formData, body)
  let scheme = call_575114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575114.url(scheme.get, call_575114.host, call_575114.base,
                         call_575114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575114, url, valid)

proc call*(call_575115: Call_WorkflowRunActionRequestHistoriesList_575105;
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
  var path_575116 = newJObject()
  var query_575117 = newJObject()
  add(path_575116, "workflowName", newJString(workflowName))
  add(path_575116, "actionName", newJString(actionName))
  add(path_575116, "resourceGroupName", newJString(resourceGroupName))
  add(path_575116, "runName", newJString(runName))
  add(query_575117, "api-version", newJString(apiVersion))
  add(path_575116, "subscriptionId", newJString(subscriptionId))
  result = call_575115.call(path_575116, query_575117, nil, nil, nil)

var workflowRunActionRequestHistoriesList* = Call_WorkflowRunActionRequestHistoriesList_575105(
    name: "workflowRunActionRequestHistoriesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/requestHistories",
    validator: validate_WorkflowRunActionRequestHistoriesList_575106, base: "",
    url: url_WorkflowRunActionRequestHistoriesList_575107, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRequestHistoriesGet_575118 = ref object of OpenApiRestCall_573667
proc url_WorkflowRunActionRequestHistoriesGet_575120(protocol: Scheme;
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

proc validate_WorkflowRunActionRequestHistoriesGet_575119(path: JsonNode;
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
  var valid_575121 = path.getOrDefault("workflowName")
  valid_575121 = validateParameter(valid_575121, JString, required = true,
                                 default = nil)
  if valid_575121 != nil:
    section.add "workflowName", valid_575121
  var valid_575122 = path.getOrDefault("actionName")
  valid_575122 = validateParameter(valid_575122, JString, required = true,
                                 default = nil)
  if valid_575122 != nil:
    section.add "actionName", valid_575122
  var valid_575123 = path.getOrDefault("resourceGroupName")
  valid_575123 = validateParameter(valid_575123, JString, required = true,
                                 default = nil)
  if valid_575123 != nil:
    section.add "resourceGroupName", valid_575123
  var valid_575124 = path.getOrDefault("runName")
  valid_575124 = validateParameter(valid_575124, JString, required = true,
                                 default = nil)
  if valid_575124 != nil:
    section.add "runName", valid_575124
  var valid_575125 = path.getOrDefault("requestHistoryName")
  valid_575125 = validateParameter(valid_575125, JString, required = true,
                                 default = nil)
  if valid_575125 != nil:
    section.add "requestHistoryName", valid_575125
  var valid_575126 = path.getOrDefault("subscriptionId")
  valid_575126 = validateParameter(valid_575126, JString, required = true,
                                 default = nil)
  if valid_575126 != nil:
    section.add "subscriptionId", valid_575126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575127 = query.getOrDefault("api-version")
  valid_575127 = validateParameter(valid_575127, JString, required = true,
                                 default = nil)
  if valid_575127 != nil:
    section.add "api-version", valid_575127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575128: Call_WorkflowRunActionRequestHistoriesGet_575118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a workflow run request history.
  ## 
  let valid = call_575128.validator(path, query, header, formData, body)
  let scheme = call_575128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575128.url(scheme.get, call_575128.host, call_575128.base,
                         call_575128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575128, url, valid)

proc call*(call_575129: Call_WorkflowRunActionRequestHistoriesGet_575118;
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
  var path_575130 = newJObject()
  var query_575131 = newJObject()
  add(path_575130, "workflowName", newJString(workflowName))
  add(path_575130, "actionName", newJString(actionName))
  add(path_575130, "resourceGroupName", newJString(resourceGroupName))
  add(path_575130, "runName", newJString(runName))
  add(query_575131, "api-version", newJString(apiVersion))
  add(path_575130, "requestHistoryName", newJString(requestHistoryName))
  add(path_575130, "subscriptionId", newJString(subscriptionId))
  result = call_575129.call(path_575130, query_575131, nil, nil, nil)

var workflowRunActionRequestHistoriesGet* = Call_WorkflowRunActionRequestHistoriesGet_575118(
    name: "workflowRunActionRequestHistoriesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/requestHistories/{requestHistoryName}",
    validator: validate_WorkflowRunActionRequestHistoriesGet_575119, base: "",
    url: url_WorkflowRunActionRequestHistoriesGet_575120, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionScopeRepetitionsList_575132 = ref object of OpenApiRestCall_573667
proc url_WorkflowRunActionScopeRepetitionsList_575134(protocol: Scheme;
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

proc validate_WorkflowRunActionScopeRepetitionsList_575133(path: JsonNode;
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
  var valid_575135 = path.getOrDefault("workflowName")
  valid_575135 = validateParameter(valid_575135, JString, required = true,
                                 default = nil)
  if valid_575135 != nil:
    section.add "workflowName", valid_575135
  var valid_575136 = path.getOrDefault("actionName")
  valid_575136 = validateParameter(valid_575136, JString, required = true,
                                 default = nil)
  if valid_575136 != nil:
    section.add "actionName", valid_575136
  var valid_575137 = path.getOrDefault("resourceGroupName")
  valid_575137 = validateParameter(valid_575137, JString, required = true,
                                 default = nil)
  if valid_575137 != nil:
    section.add "resourceGroupName", valid_575137
  var valid_575138 = path.getOrDefault("runName")
  valid_575138 = validateParameter(valid_575138, JString, required = true,
                                 default = nil)
  if valid_575138 != nil:
    section.add "runName", valid_575138
  var valid_575139 = path.getOrDefault("subscriptionId")
  valid_575139 = validateParameter(valid_575139, JString, required = true,
                                 default = nil)
  if valid_575139 != nil:
    section.add "subscriptionId", valid_575139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_575141: Call_WorkflowRunActionScopeRepetitionsList_575132;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the workflow run action scoped repetitions.
  ## 
  let valid = call_575141.validator(path, query, header, formData, body)
  let scheme = call_575141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575141.url(scheme.get, call_575141.host, call_575141.base,
                         call_575141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575141, url, valid)

proc call*(call_575142: Call_WorkflowRunActionScopeRepetitionsList_575132;
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
  var path_575143 = newJObject()
  var query_575144 = newJObject()
  add(path_575143, "workflowName", newJString(workflowName))
  add(path_575143, "actionName", newJString(actionName))
  add(path_575143, "resourceGroupName", newJString(resourceGroupName))
  add(path_575143, "runName", newJString(runName))
  add(query_575144, "api-version", newJString(apiVersion))
  add(path_575143, "subscriptionId", newJString(subscriptionId))
  result = call_575142.call(path_575143, query_575144, nil, nil, nil)

var workflowRunActionScopeRepetitionsList* = Call_WorkflowRunActionScopeRepetitionsList_575132(
    name: "workflowRunActionScopeRepetitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/scopeRepetitions",
    validator: validate_WorkflowRunActionScopeRepetitionsList_575133, base: "",
    url: url_WorkflowRunActionScopeRepetitionsList_575134, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionScopeRepetitionsGet_575145 = ref object of OpenApiRestCall_573667
proc url_WorkflowRunActionScopeRepetitionsGet_575147(protocol: Scheme;
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

proc validate_WorkflowRunActionScopeRepetitionsGet_575146(path: JsonNode;
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
  var valid_575148 = path.getOrDefault("workflowName")
  valid_575148 = validateParameter(valid_575148, JString, required = true,
                                 default = nil)
  if valid_575148 != nil:
    section.add "workflowName", valid_575148
  var valid_575149 = path.getOrDefault("actionName")
  valid_575149 = validateParameter(valid_575149, JString, required = true,
                                 default = nil)
  if valid_575149 != nil:
    section.add "actionName", valid_575149
  var valid_575150 = path.getOrDefault("resourceGroupName")
  valid_575150 = validateParameter(valid_575150, JString, required = true,
                                 default = nil)
  if valid_575150 != nil:
    section.add "resourceGroupName", valid_575150
  var valid_575151 = path.getOrDefault("runName")
  valid_575151 = validateParameter(valid_575151, JString, required = true,
                                 default = nil)
  if valid_575151 != nil:
    section.add "runName", valid_575151
  var valid_575152 = path.getOrDefault("subscriptionId")
  valid_575152 = validateParameter(valid_575152, JString, required = true,
                                 default = nil)
  if valid_575152 != nil:
    section.add "subscriptionId", valid_575152
  var valid_575153 = path.getOrDefault("repetitionName")
  valid_575153 = validateParameter(valid_575153, JString, required = true,
                                 default = nil)
  if valid_575153 != nil:
    section.add "repetitionName", valid_575153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_575155: Call_WorkflowRunActionScopeRepetitionsGet_575145;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a workflow run action scoped repetition.
  ## 
  let valid = call_575155.validator(path, query, header, formData, body)
  let scheme = call_575155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575155.url(scheme.get, call_575155.host, call_575155.base,
                         call_575155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575155, url, valid)

proc call*(call_575156: Call_WorkflowRunActionScopeRepetitionsGet_575145;
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
  var path_575157 = newJObject()
  var query_575158 = newJObject()
  add(path_575157, "workflowName", newJString(workflowName))
  add(path_575157, "actionName", newJString(actionName))
  add(path_575157, "resourceGroupName", newJString(resourceGroupName))
  add(path_575157, "runName", newJString(runName))
  add(query_575158, "api-version", newJString(apiVersion))
  add(path_575157, "subscriptionId", newJString(subscriptionId))
  add(path_575157, "repetitionName", newJString(repetitionName))
  result = call_575156.call(path_575157, query_575158, nil, nil, nil)

var workflowRunActionScopeRepetitionsGet* = Call_WorkflowRunActionScopeRepetitionsGet_575145(
    name: "workflowRunActionScopeRepetitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/scopeRepetitions/{repetitionName}",
    validator: validate_WorkflowRunActionScopeRepetitionsGet_575146, base: "",
    url: url_WorkflowRunActionScopeRepetitionsGet_575147, schemes: {Scheme.Https})
type
  Call_WorkflowRunsCancel_575159 = ref object of OpenApiRestCall_573667
proc url_WorkflowRunsCancel_575161(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsCancel_575160(path: JsonNode; query: JsonNode;
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
  var valid_575162 = path.getOrDefault("workflowName")
  valid_575162 = validateParameter(valid_575162, JString, required = true,
                                 default = nil)
  if valid_575162 != nil:
    section.add "workflowName", valid_575162
  var valid_575163 = path.getOrDefault("resourceGroupName")
  valid_575163 = validateParameter(valid_575163, JString, required = true,
                                 default = nil)
  if valid_575163 != nil:
    section.add "resourceGroupName", valid_575163
  var valid_575164 = path.getOrDefault("runName")
  valid_575164 = validateParameter(valid_575164, JString, required = true,
                                 default = nil)
  if valid_575164 != nil:
    section.add "runName", valid_575164
  var valid_575165 = path.getOrDefault("subscriptionId")
  valid_575165 = validateParameter(valid_575165, JString, required = true,
                                 default = nil)
  if valid_575165 != nil:
    section.add "subscriptionId", valid_575165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_575167: Call_WorkflowRunsCancel_575159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a workflow run.
  ## 
  let valid = call_575167.validator(path, query, header, formData, body)
  let scheme = call_575167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575167.url(scheme.get, call_575167.host, call_575167.base,
                         call_575167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575167, url, valid)

proc call*(call_575168: Call_WorkflowRunsCancel_575159; workflowName: string;
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
  var path_575169 = newJObject()
  var query_575170 = newJObject()
  add(path_575169, "workflowName", newJString(workflowName))
  add(path_575169, "resourceGroupName", newJString(resourceGroupName))
  add(path_575169, "runName", newJString(runName))
  add(query_575170, "api-version", newJString(apiVersion))
  add(path_575169, "subscriptionId", newJString(subscriptionId))
  result = call_575168.call(path_575169, query_575170, nil, nil, nil)

var workflowRunsCancel* = Call_WorkflowRunsCancel_575159(
    name: "workflowRunsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/cancel",
    validator: validate_WorkflowRunsCancel_575160, base: "",
    url: url_WorkflowRunsCancel_575161, schemes: {Scheme.Https})
type
  Call_WorkflowRunOperationsGet_575171 = ref object of OpenApiRestCall_573667
proc url_WorkflowRunOperationsGet_575173(protocol: Scheme; host: string;
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

proc validate_WorkflowRunOperationsGet_575172(path: JsonNode; query: JsonNode;
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
  var valid_575174 = path.getOrDefault("workflowName")
  valid_575174 = validateParameter(valid_575174, JString, required = true,
                                 default = nil)
  if valid_575174 != nil:
    section.add "workflowName", valid_575174
  var valid_575175 = path.getOrDefault("resourceGroupName")
  valid_575175 = validateParameter(valid_575175, JString, required = true,
                                 default = nil)
  if valid_575175 != nil:
    section.add "resourceGroupName", valid_575175
  var valid_575176 = path.getOrDefault("runName")
  valid_575176 = validateParameter(valid_575176, JString, required = true,
                                 default = nil)
  if valid_575176 != nil:
    section.add "runName", valid_575176
  var valid_575177 = path.getOrDefault("subscriptionId")
  valid_575177 = validateParameter(valid_575177, JString, required = true,
                                 default = nil)
  if valid_575177 != nil:
    section.add "subscriptionId", valid_575177
  var valid_575178 = path.getOrDefault("operationId")
  valid_575178 = validateParameter(valid_575178, JString, required = true,
                                 default = nil)
  if valid_575178 != nil:
    section.add "operationId", valid_575178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575179 = query.getOrDefault("api-version")
  valid_575179 = validateParameter(valid_575179, JString, required = true,
                                 default = nil)
  if valid_575179 != nil:
    section.add "api-version", valid_575179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575180: Call_WorkflowRunOperationsGet_575171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an operation for a run.
  ## 
  let valid = call_575180.validator(path, query, header, formData, body)
  let scheme = call_575180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575180.url(scheme.get, call_575180.host, call_575180.base,
                         call_575180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575180, url, valid)

proc call*(call_575181: Call_WorkflowRunOperationsGet_575171; workflowName: string;
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
  var path_575182 = newJObject()
  var query_575183 = newJObject()
  add(path_575182, "workflowName", newJString(workflowName))
  add(path_575182, "resourceGroupName", newJString(resourceGroupName))
  add(path_575182, "runName", newJString(runName))
  add(query_575183, "api-version", newJString(apiVersion))
  add(path_575182, "subscriptionId", newJString(subscriptionId))
  add(path_575182, "operationId", newJString(operationId))
  result = call_575181.call(path_575182, query_575183, nil, nil, nil)

var workflowRunOperationsGet* = Call_WorkflowRunOperationsGet_575171(
    name: "workflowRunOperationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/operations/{operationId}",
    validator: validate_WorkflowRunOperationsGet_575172, base: "",
    url: url_WorkflowRunOperationsGet_575173, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersList_575184 = ref object of OpenApiRestCall_573667
proc url_WorkflowTriggersList_575186(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersList_575185(path: JsonNode; query: JsonNode;
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
  var valid_575187 = path.getOrDefault("workflowName")
  valid_575187 = validateParameter(valid_575187, JString, required = true,
                                 default = nil)
  if valid_575187 != nil:
    section.add "workflowName", valid_575187
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
  var valid_575190 = query.getOrDefault("api-version")
  valid_575190 = validateParameter(valid_575190, JString, required = true,
                                 default = nil)
  if valid_575190 != nil:
    section.add "api-version", valid_575190
  var valid_575191 = query.getOrDefault("$top")
  valid_575191 = validateParameter(valid_575191, JInt, required = false, default = nil)
  if valid_575191 != nil:
    section.add "$top", valid_575191
  var valid_575192 = query.getOrDefault("$filter")
  valid_575192 = validateParameter(valid_575192, JString, required = false,
                                 default = nil)
  if valid_575192 != nil:
    section.add "$filter", valid_575192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575193: Call_WorkflowTriggersList_575184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow triggers.
  ## 
  let valid = call_575193.validator(path, query, header, formData, body)
  let scheme = call_575193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575193.url(scheme.get, call_575193.host, call_575193.base,
                         call_575193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575193, url, valid)

proc call*(call_575194: Call_WorkflowTriggersList_575184; workflowName: string;
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
  var path_575195 = newJObject()
  var query_575196 = newJObject()
  add(path_575195, "workflowName", newJString(workflowName))
  add(path_575195, "resourceGroupName", newJString(resourceGroupName))
  add(query_575196, "api-version", newJString(apiVersion))
  add(path_575195, "subscriptionId", newJString(subscriptionId))
  add(query_575196, "$top", newJInt(Top))
  add(query_575196, "$filter", newJString(Filter))
  result = call_575194.call(path_575195, query_575196, nil, nil, nil)

var workflowTriggersList* = Call_WorkflowTriggersList_575184(
    name: "workflowTriggersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers",
    validator: validate_WorkflowTriggersList_575185, base: "",
    url: url_WorkflowTriggersList_575186, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersGet_575197 = ref object of OpenApiRestCall_573667
proc url_WorkflowTriggersGet_575199(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersGet_575198(path: JsonNode; query: JsonNode;
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
  var valid_575200 = path.getOrDefault("workflowName")
  valid_575200 = validateParameter(valid_575200, JString, required = true,
                                 default = nil)
  if valid_575200 != nil:
    section.add "workflowName", valid_575200
  var valid_575201 = path.getOrDefault("resourceGroupName")
  valid_575201 = validateParameter(valid_575201, JString, required = true,
                                 default = nil)
  if valid_575201 != nil:
    section.add "resourceGroupName", valid_575201
  var valid_575202 = path.getOrDefault("subscriptionId")
  valid_575202 = validateParameter(valid_575202, JString, required = true,
                                 default = nil)
  if valid_575202 != nil:
    section.add "subscriptionId", valid_575202
  var valid_575203 = path.getOrDefault("triggerName")
  valid_575203 = validateParameter(valid_575203, JString, required = true,
                                 default = nil)
  if valid_575203 != nil:
    section.add "triggerName", valid_575203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_575205: Call_WorkflowTriggersGet_575197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow trigger.
  ## 
  let valid = call_575205.validator(path, query, header, formData, body)
  let scheme = call_575205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575205.url(scheme.get, call_575205.host, call_575205.base,
                         call_575205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575205, url, valid)

proc call*(call_575206: Call_WorkflowTriggersGet_575197; workflowName: string;
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
  var path_575207 = newJObject()
  var query_575208 = newJObject()
  add(path_575207, "workflowName", newJString(workflowName))
  add(path_575207, "resourceGroupName", newJString(resourceGroupName))
  add(query_575208, "api-version", newJString(apiVersion))
  add(path_575207, "subscriptionId", newJString(subscriptionId))
  add(path_575207, "triggerName", newJString(triggerName))
  result = call_575206.call(path_575207, query_575208, nil, nil, nil)

var workflowTriggersGet* = Call_WorkflowTriggersGet_575197(
    name: "workflowTriggersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}",
    validator: validate_WorkflowTriggersGet_575198, base: "",
    url: url_WorkflowTriggersGet_575199, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesList_575209 = ref object of OpenApiRestCall_573667
proc url_WorkflowTriggerHistoriesList_575211(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesList_575210(path: JsonNode; query: JsonNode;
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
  var valid_575212 = path.getOrDefault("workflowName")
  valid_575212 = validateParameter(valid_575212, JString, required = true,
                                 default = nil)
  if valid_575212 != nil:
    section.add "workflowName", valid_575212
  var valid_575213 = path.getOrDefault("resourceGroupName")
  valid_575213 = validateParameter(valid_575213, JString, required = true,
                                 default = nil)
  if valid_575213 != nil:
    section.add "resourceGroupName", valid_575213
  var valid_575214 = path.getOrDefault("subscriptionId")
  valid_575214 = validateParameter(valid_575214, JString, required = true,
                                 default = nil)
  if valid_575214 != nil:
    section.add "subscriptionId", valid_575214
  var valid_575215 = path.getOrDefault("triggerName")
  valid_575215 = validateParameter(valid_575215, JString, required = true,
                                 default = nil)
  if valid_575215 != nil:
    section.add "triggerName", valid_575215
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
  var valid_575216 = query.getOrDefault("api-version")
  valid_575216 = validateParameter(valid_575216, JString, required = true,
                                 default = nil)
  if valid_575216 != nil:
    section.add "api-version", valid_575216
  var valid_575217 = query.getOrDefault("$top")
  valid_575217 = validateParameter(valid_575217, JInt, required = false, default = nil)
  if valid_575217 != nil:
    section.add "$top", valid_575217
  var valid_575218 = query.getOrDefault("$filter")
  valid_575218 = validateParameter(valid_575218, JString, required = false,
                                 default = nil)
  if valid_575218 != nil:
    section.add "$filter", valid_575218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575219: Call_WorkflowTriggerHistoriesList_575209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow trigger histories.
  ## 
  let valid = call_575219.validator(path, query, header, formData, body)
  let scheme = call_575219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575219.url(scheme.get, call_575219.host, call_575219.base,
                         call_575219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575219, url, valid)

proc call*(call_575220: Call_WorkflowTriggerHistoriesList_575209;
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
  var path_575221 = newJObject()
  var query_575222 = newJObject()
  add(path_575221, "workflowName", newJString(workflowName))
  add(path_575221, "resourceGroupName", newJString(resourceGroupName))
  add(query_575222, "api-version", newJString(apiVersion))
  add(path_575221, "subscriptionId", newJString(subscriptionId))
  add(query_575222, "$top", newJInt(Top))
  add(path_575221, "triggerName", newJString(triggerName))
  add(query_575222, "$filter", newJString(Filter))
  result = call_575220.call(path_575221, query_575222, nil, nil, nil)

var workflowTriggerHistoriesList* = Call_WorkflowTriggerHistoriesList_575209(
    name: "workflowTriggerHistoriesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories",
    validator: validate_WorkflowTriggerHistoriesList_575210, base: "",
    url: url_WorkflowTriggerHistoriesList_575211, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesGet_575223 = ref object of OpenApiRestCall_573667
proc url_WorkflowTriggerHistoriesGet_575225(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesGet_575224(path: JsonNode; query: JsonNode;
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
  var valid_575226 = path.getOrDefault("workflowName")
  valid_575226 = validateParameter(valid_575226, JString, required = true,
                                 default = nil)
  if valid_575226 != nil:
    section.add "workflowName", valid_575226
  var valid_575227 = path.getOrDefault("resourceGroupName")
  valid_575227 = validateParameter(valid_575227, JString, required = true,
                                 default = nil)
  if valid_575227 != nil:
    section.add "resourceGroupName", valid_575227
  var valid_575228 = path.getOrDefault("historyName")
  valid_575228 = validateParameter(valid_575228, JString, required = true,
                                 default = nil)
  if valid_575228 != nil:
    section.add "historyName", valid_575228
  var valid_575229 = path.getOrDefault("subscriptionId")
  valid_575229 = validateParameter(valid_575229, JString, required = true,
                                 default = nil)
  if valid_575229 != nil:
    section.add "subscriptionId", valid_575229
  var valid_575230 = path.getOrDefault("triggerName")
  valid_575230 = validateParameter(valid_575230, JString, required = true,
                                 default = nil)
  if valid_575230 != nil:
    section.add "triggerName", valid_575230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575231 = query.getOrDefault("api-version")
  valid_575231 = validateParameter(valid_575231, JString, required = true,
                                 default = nil)
  if valid_575231 != nil:
    section.add "api-version", valid_575231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575232: Call_WorkflowTriggerHistoriesGet_575223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow trigger history.
  ## 
  let valid = call_575232.validator(path, query, header, formData, body)
  let scheme = call_575232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575232.url(scheme.get, call_575232.host, call_575232.base,
                         call_575232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575232, url, valid)

proc call*(call_575233: Call_WorkflowTriggerHistoriesGet_575223;
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
  var path_575234 = newJObject()
  var query_575235 = newJObject()
  add(path_575234, "workflowName", newJString(workflowName))
  add(path_575234, "resourceGroupName", newJString(resourceGroupName))
  add(query_575235, "api-version", newJString(apiVersion))
  add(path_575234, "historyName", newJString(historyName))
  add(path_575234, "subscriptionId", newJString(subscriptionId))
  add(path_575234, "triggerName", newJString(triggerName))
  result = call_575233.call(path_575234, query_575235, nil, nil, nil)

var workflowTriggerHistoriesGet* = Call_WorkflowTriggerHistoriesGet_575223(
    name: "workflowTriggerHistoriesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories/{historyName}",
    validator: validate_WorkflowTriggerHistoriesGet_575224, base: "",
    url: url_WorkflowTriggerHistoriesGet_575225, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesResubmit_575236 = ref object of OpenApiRestCall_573667
proc url_WorkflowTriggerHistoriesResubmit_575238(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesResubmit_575237(path: JsonNode;
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
  var valid_575239 = path.getOrDefault("workflowName")
  valid_575239 = validateParameter(valid_575239, JString, required = true,
                                 default = nil)
  if valid_575239 != nil:
    section.add "workflowName", valid_575239
  var valid_575240 = path.getOrDefault("resourceGroupName")
  valid_575240 = validateParameter(valid_575240, JString, required = true,
                                 default = nil)
  if valid_575240 != nil:
    section.add "resourceGroupName", valid_575240
  var valid_575241 = path.getOrDefault("historyName")
  valid_575241 = validateParameter(valid_575241, JString, required = true,
                                 default = nil)
  if valid_575241 != nil:
    section.add "historyName", valid_575241
  var valid_575242 = path.getOrDefault("subscriptionId")
  valid_575242 = validateParameter(valid_575242, JString, required = true,
                                 default = nil)
  if valid_575242 != nil:
    section.add "subscriptionId", valid_575242
  var valid_575243 = path.getOrDefault("triggerName")
  valid_575243 = validateParameter(valid_575243, JString, required = true,
                                 default = nil)
  if valid_575243 != nil:
    section.add "triggerName", valid_575243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575244 = query.getOrDefault("api-version")
  valid_575244 = validateParameter(valid_575244, JString, required = true,
                                 default = nil)
  if valid_575244 != nil:
    section.add "api-version", valid_575244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575245: Call_WorkflowTriggerHistoriesResubmit_575236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resubmits a workflow run based on the trigger history.
  ## 
  let valid = call_575245.validator(path, query, header, formData, body)
  let scheme = call_575245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575245.url(scheme.get, call_575245.host, call_575245.base,
                         call_575245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575245, url, valid)

proc call*(call_575246: Call_WorkflowTriggerHistoriesResubmit_575236;
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
  var path_575247 = newJObject()
  var query_575248 = newJObject()
  add(path_575247, "workflowName", newJString(workflowName))
  add(path_575247, "resourceGroupName", newJString(resourceGroupName))
  add(query_575248, "api-version", newJString(apiVersion))
  add(path_575247, "historyName", newJString(historyName))
  add(path_575247, "subscriptionId", newJString(subscriptionId))
  add(path_575247, "triggerName", newJString(triggerName))
  result = call_575246.call(path_575247, query_575248, nil, nil, nil)

var workflowTriggerHistoriesResubmit* = Call_WorkflowTriggerHistoriesResubmit_575236(
    name: "workflowTriggerHistoriesResubmit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories/{historyName}/resubmit",
    validator: validate_WorkflowTriggerHistoriesResubmit_575237, base: "",
    url: url_WorkflowTriggerHistoriesResubmit_575238, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersListCallbackUrl_575249 = ref object of OpenApiRestCall_573667
proc url_WorkflowTriggersListCallbackUrl_575251(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggersListCallbackUrl_575250(path: JsonNode;
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
  var valid_575252 = path.getOrDefault("workflowName")
  valid_575252 = validateParameter(valid_575252, JString, required = true,
                                 default = nil)
  if valid_575252 != nil:
    section.add "workflowName", valid_575252
  var valid_575253 = path.getOrDefault("resourceGroupName")
  valid_575253 = validateParameter(valid_575253, JString, required = true,
                                 default = nil)
  if valid_575253 != nil:
    section.add "resourceGroupName", valid_575253
  var valid_575254 = path.getOrDefault("subscriptionId")
  valid_575254 = validateParameter(valid_575254, JString, required = true,
                                 default = nil)
  if valid_575254 != nil:
    section.add "subscriptionId", valid_575254
  var valid_575255 = path.getOrDefault("triggerName")
  valid_575255 = validateParameter(valid_575255, JString, required = true,
                                 default = nil)
  if valid_575255 != nil:
    section.add "triggerName", valid_575255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575256 = query.getOrDefault("api-version")
  valid_575256 = validateParameter(valid_575256, JString, required = true,
                                 default = nil)
  if valid_575256 != nil:
    section.add "api-version", valid_575256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575257: Call_WorkflowTriggersListCallbackUrl_575249;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the callback URL for a workflow trigger.
  ## 
  let valid = call_575257.validator(path, query, header, formData, body)
  let scheme = call_575257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575257.url(scheme.get, call_575257.host, call_575257.base,
                         call_575257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575257, url, valid)

proc call*(call_575258: Call_WorkflowTriggersListCallbackUrl_575249;
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
  var path_575259 = newJObject()
  var query_575260 = newJObject()
  add(path_575259, "workflowName", newJString(workflowName))
  add(path_575259, "resourceGroupName", newJString(resourceGroupName))
  add(query_575260, "api-version", newJString(apiVersion))
  add(path_575259, "subscriptionId", newJString(subscriptionId))
  add(path_575259, "triggerName", newJString(triggerName))
  result = call_575258.call(path_575259, query_575260, nil, nil, nil)

var workflowTriggersListCallbackUrl* = Call_WorkflowTriggersListCallbackUrl_575249(
    name: "workflowTriggersListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/listCallbackUrl",
    validator: validate_WorkflowTriggersListCallbackUrl_575250, base: "",
    url: url_WorkflowTriggersListCallbackUrl_575251, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersReset_575261 = ref object of OpenApiRestCall_573667
proc url_WorkflowTriggersReset_575263(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersReset_575262(path: JsonNode; query: JsonNode;
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
  var valid_575264 = path.getOrDefault("workflowName")
  valid_575264 = validateParameter(valid_575264, JString, required = true,
                                 default = nil)
  if valid_575264 != nil:
    section.add "workflowName", valid_575264
  var valid_575265 = path.getOrDefault("resourceGroupName")
  valid_575265 = validateParameter(valid_575265, JString, required = true,
                                 default = nil)
  if valid_575265 != nil:
    section.add "resourceGroupName", valid_575265
  var valid_575266 = path.getOrDefault("subscriptionId")
  valid_575266 = validateParameter(valid_575266, JString, required = true,
                                 default = nil)
  if valid_575266 != nil:
    section.add "subscriptionId", valid_575266
  var valid_575267 = path.getOrDefault("triggerName")
  valid_575267 = validateParameter(valid_575267, JString, required = true,
                                 default = nil)
  if valid_575267 != nil:
    section.add "triggerName", valid_575267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575268 = query.getOrDefault("api-version")
  valid_575268 = validateParameter(valid_575268, JString, required = true,
                                 default = nil)
  if valid_575268 != nil:
    section.add "api-version", valid_575268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575269: Call_WorkflowTriggersReset_575261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets a workflow trigger.
  ## 
  let valid = call_575269.validator(path, query, header, formData, body)
  let scheme = call_575269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575269.url(scheme.get, call_575269.host, call_575269.base,
                         call_575269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575269, url, valid)

proc call*(call_575270: Call_WorkflowTriggersReset_575261; workflowName: string;
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
  var path_575271 = newJObject()
  var query_575272 = newJObject()
  add(path_575271, "workflowName", newJString(workflowName))
  add(path_575271, "resourceGroupName", newJString(resourceGroupName))
  add(query_575272, "api-version", newJString(apiVersion))
  add(path_575271, "subscriptionId", newJString(subscriptionId))
  add(path_575271, "triggerName", newJString(triggerName))
  result = call_575270.call(path_575271, query_575272, nil, nil, nil)

var workflowTriggersReset* = Call_WorkflowTriggersReset_575261(
    name: "workflowTriggersReset", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/reset",
    validator: validate_WorkflowTriggersReset_575262, base: "",
    url: url_WorkflowTriggersReset_575263, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersRun_575273 = ref object of OpenApiRestCall_573667
proc url_WorkflowTriggersRun_575275(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersRun_575274(path: JsonNode; query: JsonNode;
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
  var valid_575276 = path.getOrDefault("workflowName")
  valid_575276 = validateParameter(valid_575276, JString, required = true,
                                 default = nil)
  if valid_575276 != nil:
    section.add "workflowName", valid_575276
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
  var valid_575279 = path.getOrDefault("triggerName")
  valid_575279 = validateParameter(valid_575279, JString, required = true,
                                 default = nil)
  if valid_575279 != nil:
    section.add "triggerName", valid_575279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575280 = query.getOrDefault("api-version")
  valid_575280 = validateParameter(valid_575280, JString, required = true,
                                 default = nil)
  if valid_575280 != nil:
    section.add "api-version", valid_575280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575281: Call_WorkflowTriggersRun_575273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a workflow trigger.
  ## 
  let valid = call_575281.validator(path, query, header, formData, body)
  let scheme = call_575281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575281.url(scheme.get, call_575281.host, call_575281.base,
                         call_575281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575281, url, valid)

proc call*(call_575282: Call_WorkflowTriggersRun_575273; workflowName: string;
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
  var path_575283 = newJObject()
  var query_575284 = newJObject()
  add(path_575283, "workflowName", newJString(workflowName))
  add(path_575283, "resourceGroupName", newJString(resourceGroupName))
  add(query_575284, "api-version", newJString(apiVersion))
  add(path_575283, "subscriptionId", newJString(subscriptionId))
  add(path_575283, "triggerName", newJString(triggerName))
  result = call_575282.call(path_575283, query_575284, nil, nil, nil)

var workflowTriggersRun* = Call_WorkflowTriggersRun_575273(
    name: "workflowTriggersRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/run",
    validator: validate_WorkflowTriggersRun_575274, base: "",
    url: url_WorkflowTriggersRun_575275, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersGetSchemaJson_575285 = ref object of OpenApiRestCall_573667
proc url_WorkflowTriggersGetSchemaJson_575287(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggersGetSchemaJson_575286(path: JsonNode; query: JsonNode;
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
  var valid_575288 = path.getOrDefault("workflowName")
  valid_575288 = validateParameter(valid_575288, JString, required = true,
                                 default = nil)
  if valid_575288 != nil:
    section.add "workflowName", valid_575288
  var valid_575289 = path.getOrDefault("resourceGroupName")
  valid_575289 = validateParameter(valid_575289, JString, required = true,
                                 default = nil)
  if valid_575289 != nil:
    section.add "resourceGroupName", valid_575289
  var valid_575290 = path.getOrDefault("subscriptionId")
  valid_575290 = validateParameter(valid_575290, JString, required = true,
                                 default = nil)
  if valid_575290 != nil:
    section.add "subscriptionId", valid_575290
  var valid_575291 = path.getOrDefault("triggerName")
  valid_575291 = validateParameter(valid_575291, JString, required = true,
                                 default = nil)
  if valid_575291 != nil:
    section.add "triggerName", valid_575291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575292 = query.getOrDefault("api-version")
  valid_575292 = validateParameter(valid_575292, JString, required = true,
                                 default = nil)
  if valid_575292 != nil:
    section.add "api-version", valid_575292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575293: Call_WorkflowTriggersGetSchemaJson_575285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the trigger schema as JSON.
  ## 
  let valid = call_575293.validator(path, query, header, formData, body)
  let scheme = call_575293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575293.url(scheme.get, call_575293.host, call_575293.base,
                         call_575293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575293, url, valid)

proc call*(call_575294: Call_WorkflowTriggersGetSchemaJson_575285;
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
  var path_575295 = newJObject()
  var query_575296 = newJObject()
  add(path_575295, "workflowName", newJString(workflowName))
  add(path_575295, "resourceGroupName", newJString(resourceGroupName))
  add(query_575296, "api-version", newJString(apiVersion))
  add(path_575295, "subscriptionId", newJString(subscriptionId))
  add(path_575295, "triggerName", newJString(triggerName))
  result = call_575294.call(path_575295, query_575296, nil, nil, nil)

var workflowTriggersGetSchemaJson* = Call_WorkflowTriggersGetSchemaJson_575285(
    name: "workflowTriggersGetSchemaJson", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/schemas/json",
    validator: validate_WorkflowTriggersGetSchemaJson_575286, base: "",
    url: url_WorkflowTriggersGetSchemaJson_575287, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersSetState_575297 = ref object of OpenApiRestCall_573667
proc url_WorkflowTriggersSetState_575299(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggersSetState_575298(path: JsonNode; query: JsonNode;
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
  var valid_575300 = path.getOrDefault("workflowName")
  valid_575300 = validateParameter(valid_575300, JString, required = true,
                                 default = nil)
  if valid_575300 != nil:
    section.add "workflowName", valid_575300
  var valid_575301 = path.getOrDefault("resourceGroupName")
  valid_575301 = validateParameter(valid_575301, JString, required = true,
                                 default = nil)
  if valid_575301 != nil:
    section.add "resourceGroupName", valid_575301
  var valid_575302 = path.getOrDefault("subscriptionId")
  valid_575302 = validateParameter(valid_575302, JString, required = true,
                                 default = nil)
  if valid_575302 != nil:
    section.add "subscriptionId", valid_575302
  var valid_575303 = path.getOrDefault("triggerName")
  valid_575303 = validateParameter(valid_575303, JString, required = true,
                                 default = nil)
  if valid_575303 != nil:
    section.add "triggerName", valid_575303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575304 = query.getOrDefault("api-version")
  valid_575304 = validateParameter(valid_575304, JString, required = true,
                                 default = nil)
  if valid_575304 != nil:
    section.add "api-version", valid_575304
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

proc call*(call_575306: Call_WorkflowTriggersSetState_575297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of a workflow trigger.
  ## 
  let valid = call_575306.validator(path, query, header, formData, body)
  let scheme = call_575306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575306.url(scheme.get, call_575306.host, call_575306.base,
                         call_575306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575306, url, valid)

proc call*(call_575307: Call_WorkflowTriggersSetState_575297; workflowName: string;
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
  var path_575308 = newJObject()
  var query_575309 = newJObject()
  var body_575310 = newJObject()
  add(path_575308, "workflowName", newJString(workflowName))
  add(path_575308, "resourceGroupName", newJString(resourceGroupName))
  add(query_575309, "api-version", newJString(apiVersion))
  add(path_575308, "subscriptionId", newJString(subscriptionId))
  add(path_575308, "triggerName", newJString(triggerName))
  if setState != nil:
    body_575310 = setState
  result = call_575307.call(path_575308, query_575309, nil, nil, body_575310)

var workflowTriggersSetState* = Call_WorkflowTriggersSetState_575297(
    name: "workflowTriggersSetState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/setState",
    validator: validate_WorkflowTriggersSetState_575298, base: "",
    url: url_WorkflowTriggersSetState_575299, schemes: {Scheme.Https})
type
  Call_WorkflowsValidateByResourceGroup_575311 = ref object of OpenApiRestCall_573667
proc url_WorkflowsValidateByResourceGroup_575313(protocol: Scheme; host: string;
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

proc validate_WorkflowsValidateByResourceGroup_575312(path: JsonNode;
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
  var valid_575314 = path.getOrDefault("workflowName")
  valid_575314 = validateParameter(valid_575314, JString, required = true,
                                 default = nil)
  if valid_575314 != nil:
    section.add "workflowName", valid_575314
  var valid_575315 = path.getOrDefault("resourceGroupName")
  valid_575315 = validateParameter(valid_575315, JString, required = true,
                                 default = nil)
  if valid_575315 != nil:
    section.add "resourceGroupName", valid_575315
  var valid_575316 = path.getOrDefault("subscriptionId")
  valid_575316 = validateParameter(valid_575316, JString, required = true,
                                 default = nil)
  if valid_575316 != nil:
    section.add "subscriptionId", valid_575316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575317 = query.getOrDefault("api-version")
  valid_575317 = validateParameter(valid_575317, JString, required = true,
                                 default = nil)
  if valid_575317 != nil:
    section.add "api-version", valid_575317
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

proc call*(call_575319: Call_WorkflowsValidateByResourceGroup_575311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates the workflow.
  ## 
  let valid = call_575319.validator(path, query, header, formData, body)
  let scheme = call_575319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575319.url(scheme.get, call_575319.host, call_575319.base,
                         call_575319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575319, url, valid)

proc call*(call_575320: Call_WorkflowsValidateByResourceGroup_575311;
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
  var path_575321 = newJObject()
  var query_575322 = newJObject()
  var body_575323 = newJObject()
  add(path_575321, "workflowName", newJString(workflowName))
  add(path_575321, "resourceGroupName", newJString(resourceGroupName))
  add(query_575322, "api-version", newJString(apiVersion))
  add(path_575321, "subscriptionId", newJString(subscriptionId))
  if validate != nil:
    body_575323 = validate
  result = call_575320.call(path_575321, query_575322, nil, nil, body_575323)

var workflowsValidateByResourceGroup* = Call_WorkflowsValidateByResourceGroup_575311(
    name: "workflowsValidateByResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/validate",
    validator: validate_WorkflowsValidateByResourceGroup_575312, base: "",
    url: url_WorkflowsValidateByResourceGroup_575313, schemes: {Scheme.Https})
type
  Call_WorkflowVersionsList_575324 = ref object of OpenApiRestCall_573667
proc url_WorkflowVersionsList_575326(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowVersionsList_575325(path: JsonNode; query: JsonNode;
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
  var valid_575327 = path.getOrDefault("workflowName")
  valid_575327 = validateParameter(valid_575327, JString, required = true,
                                 default = nil)
  if valid_575327 != nil:
    section.add "workflowName", valid_575327
  var valid_575328 = path.getOrDefault("resourceGroupName")
  valid_575328 = validateParameter(valid_575328, JString, required = true,
                                 default = nil)
  if valid_575328 != nil:
    section.add "resourceGroupName", valid_575328
  var valid_575329 = path.getOrDefault("subscriptionId")
  valid_575329 = validateParameter(valid_575329, JString, required = true,
                                 default = nil)
  if valid_575329 != nil:
    section.add "subscriptionId", valid_575329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575330 = query.getOrDefault("api-version")
  valid_575330 = validateParameter(valid_575330, JString, required = true,
                                 default = nil)
  if valid_575330 != nil:
    section.add "api-version", valid_575330
  var valid_575331 = query.getOrDefault("$top")
  valid_575331 = validateParameter(valid_575331, JInt, required = false, default = nil)
  if valid_575331 != nil:
    section.add "$top", valid_575331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575332: Call_WorkflowVersionsList_575324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow versions.
  ## 
  let valid = call_575332.validator(path, query, header, formData, body)
  let scheme = call_575332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575332.url(scheme.get, call_575332.host, call_575332.base,
                         call_575332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575332, url, valid)

proc call*(call_575333: Call_WorkflowVersionsList_575324; workflowName: string;
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
  var path_575334 = newJObject()
  var query_575335 = newJObject()
  add(path_575334, "workflowName", newJString(workflowName))
  add(path_575334, "resourceGroupName", newJString(resourceGroupName))
  add(query_575335, "api-version", newJString(apiVersion))
  add(path_575334, "subscriptionId", newJString(subscriptionId))
  add(query_575335, "$top", newJInt(Top))
  result = call_575333.call(path_575334, query_575335, nil, nil, nil)

var workflowVersionsList* = Call_WorkflowVersionsList_575324(
    name: "workflowVersionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions",
    validator: validate_WorkflowVersionsList_575325, base: "",
    url: url_WorkflowVersionsList_575326, schemes: {Scheme.Https})
type
  Call_WorkflowVersionsGet_575336 = ref object of OpenApiRestCall_573667
proc url_WorkflowVersionsGet_575338(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowVersionsGet_575337(path: JsonNode; query: JsonNode;
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
  var valid_575339 = path.getOrDefault("workflowName")
  valid_575339 = validateParameter(valid_575339, JString, required = true,
                                 default = nil)
  if valid_575339 != nil:
    section.add "workflowName", valid_575339
  var valid_575340 = path.getOrDefault("resourceGroupName")
  valid_575340 = validateParameter(valid_575340, JString, required = true,
                                 default = nil)
  if valid_575340 != nil:
    section.add "resourceGroupName", valid_575340
  var valid_575341 = path.getOrDefault("versionId")
  valid_575341 = validateParameter(valid_575341, JString, required = true,
                                 default = nil)
  if valid_575341 != nil:
    section.add "versionId", valid_575341
  var valid_575342 = path.getOrDefault("subscriptionId")
  valid_575342 = validateParameter(valid_575342, JString, required = true,
                                 default = nil)
  if valid_575342 != nil:
    section.add "subscriptionId", valid_575342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575343 = query.getOrDefault("api-version")
  valid_575343 = validateParameter(valid_575343, JString, required = true,
                                 default = nil)
  if valid_575343 != nil:
    section.add "api-version", valid_575343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575344: Call_WorkflowVersionsGet_575336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow version.
  ## 
  let valid = call_575344.validator(path, query, header, formData, body)
  let scheme = call_575344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575344.url(scheme.get, call_575344.host, call_575344.base,
                         call_575344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575344, url, valid)

proc call*(call_575345: Call_WorkflowVersionsGet_575336; workflowName: string;
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
  var path_575346 = newJObject()
  var query_575347 = newJObject()
  add(path_575346, "workflowName", newJString(workflowName))
  add(path_575346, "resourceGroupName", newJString(resourceGroupName))
  add(path_575346, "versionId", newJString(versionId))
  add(query_575347, "api-version", newJString(apiVersion))
  add(path_575346, "subscriptionId", newJString(subscriptionId))
  result = call_575345.call(path_575346, query_575347, nil, nil, nil)

var workflowVersionsGet* = Call_WorkflowVersionsGet_575336(
    name: "workflowVersionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions/{versionId}",
    validator: validate_WorkflowVersionsGet_575337, base: "",
    url: url_WorkflowVersionsGet_575338, schemes: {Scheme.Https})
type
  Call_WorkflowVersionTriggersListCallbackUrl_575348 = ref object of OpenApiRestCall_573667
proc url_WorkflowVersionTriggersListCallbackUrl_575350(protocol: Scheme;
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

proc validate_WorkflowVersionTriggersListCallbackUrl_575349(path: JsonNode;
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
  var valid_575351 = path.getOrDefault("workflowName")
  valid_575351 = validateParameter(valid_575351, JString, required = true,
                                 default = nil)
  if valid_575351 != nil:
    section.add "workflowName", valid_575351
  var valid_575352 = path.getOrDefault("resourceGroupName")
  valid_575352 = validateParameter(valid_575352, JString, required = true,
                                 default = nil)
  if valid_575352 != nil:
    section.add "resourceGroupName", valid_575352
  var valid_575353 = path.getOrDefault("versionId")
  valid_575353 = validateParameter(valid_575353, JString, required = true,
                                 default = nil)
  if valid_575353 != nil:
    section.add "versionId", valid_575353
  var valid_575354 = path.getOrDefault("subscriptionId")
  valid_575354 = validateParameter(valid_575354, JString, required = true,
                                 default = nil)
  if valid_575354 != nil:
    section.add "subscriptionId", valid_575354
  var valid_575355 = path.getOrDefault("triggerName")
  valid_575355 = validateParameter(valid_575355, JString, required = true,
                                 default = nil)
  if valid_575355 != nil:
    section.add "triggerName", valid_575355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575356 = query.getOrDefault("api-version")
  valid_575356 = validateParameter(valid_575356, JString, required = true,
                                 default = nil)
  if valid_575356 != nil:
    section.add "api-version", valid_575356
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

proc call*(call_575358: Call_WorkflowVersionTriggersListCallbackUrl_575348;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the callback url for a trigger of a workflow version.
  ## 
  let valid = call_575358.validator(path, query, header, formData, body)
  let scheme = call_575358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575358.url(scheme.get, call_575358.host, call_575358.base,
                         call_575358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575358, url, valid)

proc call*(call_575359: Call_WorkflowVersionTriggersListCallbackUrl_575348;
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
  var path_575360 = newJObject()
  var query_575361 = newJObject()
  var body_575362 = newJObject()
  add(path_575360, "workflowName", newJString(workflowName))
  add(path_575360, "resourceGroupName", newJString(resourceGroupName))
  add(path_575360, "versionId", newJString(versionId))
  add(query_575361, "api-version", newJString(apiVersion))
  add(path_575360, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575362 = parameters
  add(path_575360, "triggerName", newJString(triggerName))
  result = call_575359.call(path_575360, query_575361, nil, nil, body_575362)

var workflowVersionTriggersListCallbackUrl* = Call_WorkflowVersionTriggersListCallbackUrl_575348(
    name: "workflowVersionTriggersListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions/{versionId}/triggers/{triggerName}/listCallbackUrl",
    validator: validate_WorkflowVersionTriggersListCallbackUrl_575349, base: "",
    url: url_WorkflowVersionTriggersListCallbackUrl_575350,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentsListByResourceGroup_575363 = ref object of OpenApiRestCall_573667
proc url_IntegrationServiceEnvironmentsListByResourceGroup_575365(
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

proc validate_IntegrationServiceEnvironmentsListByResourceGroup_575364(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a list of integration service environments by resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575366 = path.getOrDefault("subscriptionId")
  valid_575366 = validateParameter(valid_575366, JString, required = true,
                                 default = nil)
  if valid_575366 != nil:
    section.add "subscriptionId", valid_575366
  var valid_575367 = path.getOrDefault("resourceGroup")
  valid_575367 = validateParameter(valid_575367, JString, required = true,
                                 default = nil)
  if valid_575367 != nil:
    section.add "resourceGroup", valid_575367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575368 = query.getOrDefault("api-version")
  valid_575368 = validateParameter(valid_575368, JString, required = true,
                                 default = nil)
  if valid_575368 != nil:
    section.add "api-version", valid_575368
  var valid_575369 = query.getOrDefault("$top")
  valid_575369 = validateParameter(valid_575369, JInt, required = false, default = nil)
  if valid_575369 != nil:
    section.add "$top", valid_575369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575370: Call_IntegrationServiceEnvironmentsListByResourceGroup_575363;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration service environments by resource group.
  ## 
  let valid = call_575370.validator(path, query, header, formData, body)
  let scheme = call_575370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575370.url(scheme.get, call_575370.host, call_575370.base,
                         call_575370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575370, url, valid)

proc call*(call_575371: Call_IntegrationServiceEnvironmentsListByResourceGroup_575363;
          apiVersion: string; subscriptionId: string; resourceGroup: string;
          Top: int = 0): Recallable =
  ## integrationServiceEnvironmentsListByResourceGroup
  ## Gets a list of integration service environments by resource group.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   Top: int
  ##      : The number of items to be included in the result.
  var path_575372 = newJObject()
  var query_575373 = newJObject()
  add(query_575373, "api-version", newJString(apiVersion))
  add(path_575372, "subscriptionId", newJString(subscriptionId))
  add(path_575372, "resourceGroup", newJString(resourceGroup))
  add(query_575373, "$top", newJInt(Top))
  result = call_575371.call(path_575372, query_575373, nil, nil, nil)

var integrationServiceEnvironmentsListByResourceGroup* = Call_IntegrationServiceEnvironmentsListByResourceGroup_575363(
    name: "integrationServiceEnvironmentsListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments",
    validator: validate_IntegrationServiceEnvironmentsListByResourceGroup_575364,
    base: "", url: url_IntegrationServiceEnvironmentsListByResourceGroup_575365,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentsCreateOrUpdate_575385 = ref object of OpenApiRestCall_573667
proc url_IntegrationServiceEnvironmentsCreateOrUpdate_575387(protocol: Scheme;
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

proc validate_IntegrationServiceEnvironmentsCreateOrUpdate_575386(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration service environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575388 = path.getOrDefault("subscriptionId")
  valid_575388 = validateParameter(valid_575388, JString, required = true,
                                 default = nil)
  if valid_575388 != nil:
    section.add "subscriptionId", valid_575388
  var valid_575389 = path.getOrDefault("resourceGroup")
  valid_575389 = validateParameter(valid_575389, JString, required = true,
                                 default = nil)
  if valid_575389 != nil:
    section.add "resourceGroup", valid_575389
  var valid_575390 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_575390 = validateParameter(valid_575390, JString, required = true,
                                 default = nil)
  if valid_575390 != nil:
    section.add "integrationServiceEnvironmentName", valid_575390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575391 = query.getOrDefault("api-version")
  valid_575391 = validateParameter(valid_575391, JString, required = true,
                                 default = nil)
  if valid_575391 != nil:
    section.add "api-version", valid_575391
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

proc call*(call_575393: Call_IntegrationServiceEnvironmentsCreateOrUpdate_575385;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration service environment.
  ## 
  let valid = call_575393.validator(path, query, header, formData, body)
  let scheme = call_575393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575393.url(scheme.get, call_575393.host, call_575393.base,
                         call_575393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575393, url, valid)

proc call*(call_575394: Call_IntegrationServiceEnvironmentsCreateOrUpdate_575385;
          integrationServiceEnvironment: JsonNode; apiVersion: string;
          subscriptionId: string; resourceGroup: string;
          integrationServiceEnvironmentName: string): Recallable =
  ## integrationServiceEnvironmentsCreateOrUpdate
  ## Creates or updates an integration service environment.
  ##   integrationServiceEnvironment: JObject (required)
  ##                                : The integration service environment.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  var path_575395 = newJObject()
  var query_575396 = newJObject()
  var body_575397 = newJObject()
  if integrationServiceEnvironment != nil:
    body_575397 = integrationServiceEnvironment
  add(query_575396, "api-version", newJString(apiVersion))
  add(path_575395, "subscriptionId", newJString(subscriptionId))
  add(path_575395, "resourceGroup", newJString(resourceGroup))
  add(path_575395, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  result = call_575394.call(path_575395, query_575396, nil, nil, body_575397)

var integrationServiceEnvironmentsCreateOrUpdate* = Call_IntegrationServiceEnvironmentsCreateOrUpdate_575385(
    name: "integrationServiceEnvironmentsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}",
    validator: validate_IntegrationServiceEnvironmentsCreateOrUpdate_575386,
    base: "", url: url_IntegrationServiceEnvironmentsCreateOrUpdate_575387,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentsGet_575374 = ref object of OpenApiRestCall_573667
proc url_IntegrationServiceEnvironmentsGet_575376(protocol: Scheme; host: string;
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

proc validate_IntegrationServiceEnvironmentsGet_575375(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration service environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575377 = path.getOrDefault("subscriptionId")
  valid_575377 = validateParameter(valid_575377, JString, required = true,
                                 default = nil)
  if valid_575377 != nil:
    section.add "subscriptionId", valid_575377
  var valid_575378 = path.getOrDefault("resourceGroup")
  valid_575378 = validateParameter(valid_575378, JString, required = true,
                                 default = nil)
  if valid_575378 != nil:
    section.add "resourceGroup", valid_575378
  var valid_575379 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_575379 = validateParameter(valid_575379, JString, required = true,
                                 default = nil)
  if valid_575379 != nil:
    section.add "integrationServiceEnvironmentName", valid_575379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575380 = query.getOrDefault("api-version")
  valid_575380 = validateParameter(valid_575380, JString, required = true,
                                 default = nil)
  if valid_575380 != nil:
    section.add "api-version", valid_575380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575381: Call_IntegrationServiceEnvironmentsGet_575374;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an integration service environment.
  ## 
  let valid = call_575381.validator(path, query, header, formData, body)
  let scheme = call_575381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575381.url(scheme.get, call_575381.host, call_575381.base,
                         call_575381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575381, url, valid)

proc call*(call_575382: Call_IntegrationServiceEnvironmentsGet_575374;
          apiVersion: string; subscriptionId: string; resourceGroup: string;
          integrationServiceEnvironmentName: string): Recallable =
  ## integrationServiceEnvironmentsGet
  ## Gets an integration service environment.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  var path_575383 = newJObject()
  var query_575384 = newJObject()
  add(query_575384, "api-version", newJString(apiVersion))
  add(path_575383, "subscriptionId", newJString(subscriptionId))
  add(path_575383, "resourceGroup", newJString(resourceGroup))
  add(path_575383, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  result = call_575382.call(path_575383, query_575384, nil, nil, nil)

var integrationServiceEnvironmentsGet* = Call_IntegrationServiceEnvironmentsGet_575374(
    name: "integrationServiceEnvironmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}",
    validator: validate_IntegrationServiceEnvironmentsGet_575375, base: "",
    url: url_IntegrationServiceEnvironmentsGet_575376, schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentsUpdate_575409 = ref object of OpenApiRestCall_573667
proc url_IntegrationServiceEnvironmentsUpdate_575411(protocol: Scheme;
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

proc validate_IntegrationServiceEnvironmentsUpdate_575410(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an integration service environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575412 = path.getOrDefault("subscriptionId")
  valid_575412 = validateParameter(valid_575412, JString, required = true,
                                 default = nil)
  if valid_575412 != nil:
    section.add "subscriptionId", valid_575412
  var valid_575413 = path.getOrDefault("resourceGroup")
  valid_575413 = validateParameter(valid_575413, JString, required = true,
                                 default = nil)
  if valid_575413 != nil:
    section.add "resourceGroup", valid_575413
  var valid_575414 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_575414 = validateParameter(valid_575414, JString, required = true,
                                 default = nil)
  if valid_575414 != nil:
    section.add "integrationServiceEnvironmentName", valid_575414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575415 = query.getOrDefault("api-version")
  valid_575415 = validateParameter(valid_575415, JString, required = true,
                                 default = nil)
  if valid_575415 != nil:
    section.add "api-version", valid_575415
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

proc call*(call_575417: Call_IntegrationServiceEnvironmentsUpdate_575409;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an integration service environment.
  ## 
  let valid = call_575417.validator(path, query, header, formData, body)
  let scheme = call_575417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575417.url(scheme.get, call_575417.host, call_575417.base,
                         call_575417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575417, url, valid)

proc call*(call_575418: Call_IntegrationServiceEnvironmentsUpdate_575409;
          integrationServiceEnvironment: JsonNode; apiVersion: string;
          subscriptionId: string; resourceGroup: string;
          integrationServiceEnvironmentName: string): Recallable =
  ## integrationServiceEnvironmentsUpdate
  ## Updates an integration service environment.
  ##   integrationServiceEnvironment: JObject (required)
  ##                                : The integration service environment.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  var path_575419 = newJObject()
  var query_575420 = newJObject()
  var body_575421 = newJObject()
  if integrationServiceEnvironment != nil:
    body_575421 = integrationServiceEnvironment
  add(query_575420, "api-version", newJString(apiVersion))
  add(path_575419, "subscriptionId", newJString(subscriptionId))
  add(path_575419, "resourceGroup", newJString(resourceGroup))
  add(path_575419, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  result = call_575418.call(path_575419, query_575420, nil, nil, body_575421)

var integrationServiceEnvironmentsUpdate* = Call_IntegrationServiceEnvironmentsUpdate_575409(
    name: "integrationServiceEnvironmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}",
    validator: validate_IntegrationServiceEnvironmentsUpdate_575410, base: "",
    url: url_IntegrationServiceEnvironmentsUpdate_575411, schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentsDelete_575398 = ref object of OpenApiRestCall_573667
proc url_IntegrationServiceEnvironmentsDelete_575400(protocol: Scheme;
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

proc validate_IntegrationServiceEnvironmentsDelete_575399(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration service environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575401 = path.getOrDefault("subscriptionId")
  valid_575401 = validateParameter(valid_575401, JString, required = true,
                                 default = nil)
  if valid_575401 != nil:
    section.add "subscriptionId", valid_575401
  var valid_575402 = path.getOrDefault("resourceGroup")
  valid_575402 = validateParameter(valid_575402, JString, required = true,
                                 default = nil)
  if valid_575402 != nil:
    section.add "resourceGroup", valid_575402
  var valid_575403 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_575403 = validateParameter(valid_575403, JString, required = true,
                                 default = nil)
  if valid_575403 != nil:
    section.add "integrationServiceEnvironmentName", valid_575403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575404 = query.getOrDefault("api-version")
  valid_575404 = validateParameter(valid_575404, JString, required = true,
                                 default = nil)
  if valid_575404 != nil:
    section.add "api-version", valid_575404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575405: Call_IntegrationServiceEnvironmentsDelete_575398;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration service environment.
  ## 
  let valid = call_575405.validator(path, query, header, formData, body)
  let scheme = call_575405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575405.url(scheme.get, call_575405.host, call_575405.base,
                         call_575405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575405, url, valid)

proc call*(call_575406: Call_IntegrationServiceEnvironmentsDelete_575398;
          apiVersion: string; subscriptionId: string; resourceGroup: string;
          integrationServiceEnvironmentName: string): Recallable =
  ## integrationServiceEnvironmentsDelete
  ## Deletes an integration service environment.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  var path_575407 = newJObject()
  var query_575408 = newJObject()
  add(query_575408, "api-version", newJString(apiVersion))
  add(path_575407, "subscriptionId", newJString(subscriptionId))
  add(path_575407, "resourceGroup", newJString(resourceGroup))
  add(path_575407, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  result = call_575406.call(path_575407, query_575408, nil, nil, nil)

var integrationServiceEnvironmentsDelete* = Call_IntegrationServiceEnvironmentsDelete_575398(
    name: "integrationServiceEnvironmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}",
    validator: validate_IntegrationServiceEnvironmentsDelete_575399, base: "",
    url: url_IntegrationServiceEnvironmentsDelete_575400, schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentNetworkHealthGet_575422 = ref object of OpenApiRestCall_573667
proc url_IntegrationServiceEnvironmentNetworkHealthGet_575424(protocol: Scheme;
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

proc validate_IntegrationServiceEnvironmentNetworkHealthGet_575423(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the integration service environment network health.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575425 = path.getOrDefault("subscriptionId")
  valid_575425 = validateParameter(valid_575425, JString, required = true,
                                 default = nil)
  if valid_575425 != nil:
    section.add "subscriptionId", valid_575425
  var valid_575426 = path.getOrDefault("resourceGroup")
  valid_575426 = validateParameter(valid_575426, JString, required = true,
                                 default = nil)
  if valid_575426 != nil:
    section.add "resourceGroup", valid_575426
  var valid_575427 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_575427 = validateParameter(valid_575427, JString, required = true,
                                 default = nil)
  if valid_575427 != nil:
    section.add "integrationServiceEnvironmentName", valid_575427
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575428 = query.getOrDefault("api-version")
  valid_575428 = validateParameter(valid_575428, JString, required = true,
                                 default = nil)
  if valid_575428 != nil:
    section.add "api-version", valid_575428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575429: Call_IntegrationServiceEnvironmentNetworkHealthGet_575422;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the integration service environment network health.
  ## 
  let valid = call_575429.validator(path, query, header, formData, body)
  let scheme = call_575429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575429.url(scheme.get, call_575429.host, call_575429.base,
                         call_575429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575429, url, valid)

proc call*(call_575430: Call_IntegrationServiceEnvironmentNetworkHealthGet_575422;
          apiVersion: string; subscriptionId: string; resourceGroup: string;
          integrationServiceEnvironmentName: string): Recallable =
  ## integrationServiceEnvironmentNetworkHealthGet
  ## Gets the integration service environment network health.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  var path_575431 = newJObject()
  var query_575432 = newJObject()
  add(query_575432, "api-version", newJString(apiVersion))
  add(path_575431, "subscriptionId", newJString(subscriptionId))
  add(path_575431, "resourceGroup", newJString(resourceGroup))
  add(path_575431, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  result = call_575430.call(path_575431, query_575432, nil, nil, nil)

var integrationServiceEnvironmentNetworkHealthGet* = Call_IntegrationServiceEnvironmentNetworkHealthGet_575422(
    name: "integrationServiceEnvironmentNetworkHealthGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}/health/network",
    validator: validate_IntegrationServiceEnvironmentNetworkHealthGet_575423,
    base: "", url: url_IntegrationServiceEnvironmentNetworkHealthGet_575424,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentManagedApisList_575433 = ref object of OpenApiRestCall_573667
proc url_IntegrationServiceEnvironmentManagedApisList_575435(protocol: Scheme;
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

proc validate_IntegrationServiceEnvironmentManagedApisList_575434(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the integration service environment managed Apis.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575436 = path.getOrDefault("subscriptionId")
  valid_575436 = validateParameter(valid_575436, JString, required = true,
                                 default = nil)
  if valid_575436 != nil:
    section.add "subscriptionId", valid_575436
  var valid_575437 = path.getOrDefault("resourceGroup")
  valid_575437 = validateParameter(valid_575437, JString, required = true,
                                 default = nil)
  if valid_575437 != nil:
    section.add "resourceGroup", valid_575437
  var valid_575438 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_575438 = validateParameter(valid_575438, JString, required = true,
                                 default = nil)
  if valid_575438 != nil:
    section.add "integrationServiceEnvironmentName", valid_575438
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575439 = query.getOrDefault("api-version")
  valid_575439 = validateParameter(valid_575439, JString, required = true,
                                 default = nil)
  if valid_575439 != nil:
    section.add "api-version", valid_575439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575440: Call_IntegrationServiceEnvironmentManagedApisList_575433;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the integration service environment managed Apis.
  ## 
  let valid = call_575440.validator(path, query, header, formData, body)
  let scheme = call_575440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575440.url(scheme.get, call_575440.host, call_575440.base,
                         call_575440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575440, url, valid)

proc call*(call_575441: Call_IntegrationServiceEnvironmentManagedApisList_575433;
          apiVersion: string; subscriptionId: string; resourceGroup: string;
          integrationServiceEnvironmentName: string): Recallable =
  ## integrationServiceEnvironmentManagedApisList
  ## Gets the integration service environment managed Apis.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  var path_575442 = newJObject()
  var query_575443 = newJObject()
  add(query_575443, "api-version", newJString(apiVersion))
  add(path_575442, "subscriptionId", newJString(subscriptionId))
  add(path_575442, "resourceGroup", newJString(resourceGroup))
  add(path_575442, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  result = call_575441.call(path_575442, query_575443, nil, nil, nil)

var integrationServiceEnvironmentManagedApisList* = Call_IntegrationServiceEnvironmentManagedApisList_575433(
    name: "integrationServiceEnvironmentManagedApisList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}/managedApis",
    validator: validate_IntegrationServiceEnvironmentManagedApisList_575434,
    base: "", url: url_IntegrationServiceEnvironmentManagedApisList_575435,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentManagedApisPut_575456 = ref object of OpenApiRestCall_573667
proc url_IntegrationServiceEnvironmentManagedApisPut_575458(protocol: Scheme;
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

proc validate_IntegrationServiceEnvironmentManagedApisPut_575457(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Puts the integration service environment managed Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiName: JString (required)
  ##          : The api name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroup: JString (required)
  ##                : The resource group name.
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiName` field"
  var valid_575459 = path.getOrDefault("apiName")
  valid_575459 = validateParameter(valid_575459, JString, required = true,
                                 default = nil)
  if valid_575459 != nil:
    section.add "apiName", valid_575459
  var valid_575460 = path.getOrDefault("subscriptionId")
  valid_575460 = validateParameter(valid_575460, JString, required = true,
                                 default = nil)
  if valid_575460 != nil:
    section.add "subscriptionId", valid_575460
  var valid_575461 = path.getOrDefault("resourceGroup")
  valid_575461 = validateParameter(valid_575461, JString, required = true,
                                 default = nil)
  if valid_575461 != nil:
    section.add "resourceGroup", valid_575461
  var valid_575462 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_575462 = validateParameter(valid_575462, JString, required = true,
                                 default = nil)
  if valid_575462 != nil:
    section.add "integrationServiceEnvironmentName", valid_575462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575463 = query.getOrDefault("api-version")
  valid_575463 = validateParameter(valid_575463, JString, required = true,
                                 default = nil)
  if valid_575463 != nil:
    section.add "api-version", valid_575463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575464: Call_IntegrationServiceEnvironmentManagedApisPut_575456;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Puts the integration service environment managed Api.
  ## 
  let valid = call_575464.validator(path, query, header, formData, body)
  let scheme = call_575464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575464.url(scheme.get, call_575464.host, call_575464.base,
                         call_575464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575464, url, valid)

proc call*(call_575465: Call_IntegrationServiceEnvironmentManagedApisPut_575456;
          apiVersion: string; apiName: string; subscriptionId: string;
          resourceGroup: string; integrationServiceEnvironmentName: string): Recallable =
  ## integrationServiceEnvironmentManagedApisPut
  ## Puts the integration service environment managed Api.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   apiName: string (required)
  ##          : The api name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroup: string (required)
  ##                : The resource group name.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  var path_575466 = newJObject()
  var query_575467 = newJObject()
  add(query_575467, "api-version", newJString(apiVersion))
  add(path_575466, "apiName", newJString(apiName))
  add(path_575466, "subscriptionId", newJString(subscriptionId))
  add(path_575466, "resourceGroup", newJString(resourceGroup))
  add(path_575466, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  result = call_575465.call(path_575466, query_575467, nil, nil, nil)

var integrationServiceEnvironmentManagedApisPut* = Call_IntegrationServiceEnvironmentManagedApisPut_575456(
    name: "integrationServiceEnvironmentManagedApisPut", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}/managedApis/{apiName}",
    validator: validate_IntegrationServiceEnvironmentManagedApisPut_575457,
    base: "", url: url_IntegrationServiceEnvironmentManagedApisPut_575458,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentManagedApisGet_575444 = ref object of OpenApiRestCall_573667
proc url_IntegrationServiceEnvironmentManagedApisGet_575446(protocol: Scheme;
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

proc validate_IntegrationServiceEnvironmentManagedApisGet_575445(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the integration service environment managed Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiName: JString (required)
  ##          : The api name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroup: JString (required)
  ##                : The resource group name.
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiName` field"
  var valid_575447 = path.getOrDefault("apiName")
  valid_575447 = validateParameter(valid_575447, JString, required = true,
                                 default = nil)
  if valid_575447 != nil:
    section.add "apiName", valid_575447
  var valid_575448 = path.getOrDefault("subscriptionId")
  valid_575448 = validateParameter(valid_575448, JString, required = true,
                                 default = nil)
  if valid_575448 != nil:
    section.add "subscriptionId", valid_575448
  var valid_575449 = path.getOrDefault("resourceGroup")
  valid_575449 = validateParameter(valid_575449, JString, required = true,
                                 default = nil)
  if valid_575449 != nil:
    section.add "resourceGroup", valid_575449
  var valid_575450 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_575450 = validateParameter(valid_575450, JString, required = true,
                                 default = nil)
  if valid_575450 != nil:
    section.add "integrationServiceEnvironmentName", valid_575450
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575451 = query.getOrDefault("api-version")
  valid_575451 = validateParameter(valid_575451, JString, required = true,
                                 default = nil)
  if valid_575451 != nil:
    section.add "api-version", valid_575451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575452: Call_IntegrationServiceEnvironmentManagedApisGet_575444;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the integration service environment managed Api.
  ## 
  let valid = call_575452.validator(path, query, header, formData, body)
  let scheme = call_575452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575452.url(scheme.get, call_575452.host, call_575452.base,
                         call_575452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575452, url, valid)

proc call*(call_575453: Call_IntegrationServiceEnvironmentManagedApisGet_575444;
          apiVersion: string; apiName: string; subscriptionId: string;
          resourceGroup: string; integrationServiceEnvironmentName: string): Recallable =
  ## integrationServiceEnvironmentManagedApisGet
  ## Gets the integration service environment managed Api.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   apiName: string (required)
  ##          : The api name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroup: string (required)
  ##                : The resource group name.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  var path_575454 = newJObject()
  var query_575455 = newJObject()
  add(query_575455, "api-version", newJString(apiVersion))
  add(path_575454, "apiName", newJString(apiName))
  add(path_575454, "subscriptionId", newJString(subscriptionId))
  add(path_575454, "resourceGroup", newJString(resourceGroup))
  add(path_575454, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  result = call_575453.call(path_575454, query_575455, nil, nil, nil)

var integrationServiceEnvironmentManagedApisGet* = Call_IntegrationServiceEnvironmentManagedApisGet_575444(
    name: "integrationServiceEnvironmentManagedApisGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}/managedApis/{apiName}",
    validator: validate_IntegrationServiceEnvironmentManagedApisGet_575445,
    base: "", url: url_IntegrationServiceEnvironmentManagedApisGet_575446,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentManagedApisDelete_575468 = ref object of OpenApiRestCall_573667
proc url_IntegrationServiceEnvironmentManagedApisDelete_575470(protocol: Scheme;
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

proc validate_IntegrationServiceEnvironmentManagedApisDelete_575469(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the integration service environment managed Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiName: JString (required)
  ##          : The api name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiName` field"
  var valid_575471 = path.getOrDefault("apiName")
  valid_575471 = validateParameter(valid_575471, JString, required = true,
                                 default = nil)
  if valid_575471 != nil:
    section.add "apiName", valid_575471
  var valid_575472 = path.getOrDefault("subscriptionId")
  valid_575472 = validateParameter(valid_575472, JString, required = true,
                                 default = nil)
  if valid_575472 != nil:
    section.add "subscriptionId", valid_575472
  var valid_575473 = path.getOrDefault("resourceGroup")
  valid_575473 = validateParameter(valid_575473, JString, required = true,
                                 default = nil)
  if valid_575473 != nil:
    section.add "resourceGroup", valid_575473
  var valid_575474 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_575474 = validateParameter(valid_575474, JString, required = true,
                                 default = nil)
  if valid_575474 != nil:
    section.add "integrationServiceEnvironmentName", valid_575474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575475 = query.getOrDefault("api-version")
  valid_575475 = validateParameter(valid_575475, JString, required = true,
                                 default = nil)
  if valid_575475 != nil:
    section.add "api-version", valid_575475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575476: Call_IntegrationServiceEnvironmentManagedApisDelete_575468;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the integration service environment managed Api.
  ## 
  let valid = call_575476.validator(path, query, header, formData, body)
  let scheme = call_575476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575476.url(scheme.get, call_575476.host, call_575476.base,
                         call_575476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575476, url, valid)

proc call*(call_575477: Call_IntegrationServiceEnvironmentManagedApisDelete_575468;
          apiVersion: string; apiName: string; subscriptionId: string;
          resourceGroup: string; integrationServiceEnvironmentName: string): Recallable =
  ## integrationServiceEnvironmentManagedApisDelete
  ## Deletes the integration service environment managed Api.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   apiName: string (required)
  ##          : The api name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  var path_575478 = newJObject()
  var query_575479 = newJObject()
  add(query_575479, "api-version", newJString(apiVersion))
  add(path_575478, "apiName", newJString(apiName))
  add(path_575478, "subscriptionId", newJString(subscriptionId))
  add(path_575478, "resourceGroup", newJString(resourceGroup))
  add(path_575478, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  result = call_575477.call(path_575478, query_575479, nil, nil, nil)

var integrationServiceEnvironmentManagedApisDelete* = Call_IntegrationServiceEnvironmentManagedApisDelete_575468(
    name: "integrationServiceEnvironmentManagedApisDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}/managedApis/{apiName}",
    validator: validate_IntegrationServiceEnvironmentManagedApisDelete_575469,
    base: "", url: url_IntegrationServiceEnvironmentManagedApisDelete_575470,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentManagedApiOperationsList_575480 = ref object of OpenApiRestCall_573667
proc url_IntegrationServiceEnvironmentManagedApiOperationsList_575482(
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

proc validate_IntegrationServiceEnvironmentManagedApiOperationsList_575481(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the managed Api operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiName: JString (required)
  ##          : The api name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiName` field"
  var valid_575483 = path.getOrDefault("apiName")
  valid_575483 = validateParameter(valid_575483, JString, required = true,
                                 default = nil)
  if valid_575483 != nil:
    section.add "apiName", valid_575483
  var valid_575484 = path.getOrDefault("subscriptionId")
  valid_575484 = validateParameter(valid_575484, JString, required = true,
                                 default = nil)
  if valid_575484 != nil:
    section.add "subscriptionId", valid_575484
  var valid_575485 = path.getOrDefault("resourceGroup")
  valid_575485 = validateParameter(valid_575485, JString, required = true,
                                 default = nil)
  if valid_575485 != nil:
    section.add "resourceGroup", valid_575485
  var valid_575486 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_575486 = validateParameter(valid_575486, JString, required = true,
                                 default = nil)
  if valid_575486 != nil:
    section.add "integrationServiceEnvironmentName", valid_575486
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575487 = query.getOrDefault("api-version")
  valid_575487 = validateParameter(valid_575487, JString, required = true,
                                 default = nil)
  if valid_575487 != nil:
    section.add "api-version", valid_575487
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575488: Call_IntegrationServiceEnvironmentManagedApiOperationsList_575480;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the managed Api operations.
  ## 
  let valid = call_575488.validator(path, query, header, formData, body)
  let scheme = call_575488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575488.url(scheme.get, call_575488.host, call_575488.base,
                         call_575488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575488, url, valid)

proc call*(call_575489: Call_IntegrationServiceEnvironmentManagedApiOperationsList_575480;
          apiVersion: string; apiName: string; subscriptionId: string;
          resourceGroup: string; integrationServiceEnvironmentName: string): Recallable =
  ## integrationServiceEnvironmentManagedApiOperationsList
  ## Gets the managed Api operations.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   apiName: string (required)
  ##          : The api name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  var path_575490 = newJObject()
  var query_575491 = newJObject()
  add(query_575491, "api-version", newJString(apiVersion))
  add(path_575490, "apiName", newJString(apiName))
  add(path_575490, "subscriptionId", newJString(subscriptionId))
  add(path_575490, "resourceGroup", newJString(resourceGroup))
  add(path_575490, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  result = call_575489.call(path_575490, query_575491, nil, nil, nil)

var integrationServiceEnvironmentManagedApiOperationsList* = Call_IntegrationServiceEnvironmentManagedApiOperationsList_575480(
    name: "integrationServiceEnvironmentManagedApiOperationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}/managedApis/{apiName}/apiOperations",
    validator: validate_IntegrationServiceEnvironmentManagedApiOperationsList_575481,
    base: "", url: url_IntegrationServiceEnvironmentManagedApiOperationsList_575482,
    schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentsRestart_575492 = ref object of OpenApiRestCall_573667
proc url_IntegrationServiceEnvironmentsRestart_575494(protocol: Scheme;
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

proc validate_IntegrationServiceEnvironmentsRestart_575493(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restarts an integration service environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575495 = path.getOrDefault("subscriptionId")
  valid_575495 = validateParameter(valid_575495, JString, required = true,
                                 default = nil)
  if valid_575495 != nil:
    section.add "subscriptionId", valid_575495
  var valid_575496 = path.getOrDefault("resourceGroup")
  valid_575496 = validateParameter(valid_575496, JString, required = true,
                                 default = nil)
  if valid_575496 != nil:
    section.add "resourceGroup", valid_575496
  var valid_575497 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_575497 = validateParameter(valid_575497, JString, required = true,
                                 default = nil)
  if valid_575497 != nil:
    section.add "integrationServiceEnvironmentName", valid_575497
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575498 = query.getOrDefault("api-version")
  valid_575498 = validateParameter(valid_575498, JString, required = true,
                                 default = nil)
  if valid_575498 != nil:
    section.add "api-version", valid_575498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575499: Call_IntegrationServiceEnvironmentsRestart_575492;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restarts an integration service environment.
  ## 
  let valid = call_575499.validator(path, query, header, formData, body)
  let scheme = call_575499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575499.url(scheme.get, call_575499.host, call_575499.base,
                         call_575499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575499, url, valid)

proc call*(call_575500: Call_IntegrationServiceEnvironmentsRestart_575492;
          apiVersion: string; subscriptionId: string; resourceGroup: string;
          integrationServiceEnvironmentName: string): Recallable =
  ## integrationServiceEnvironmentsRestart
  ## Restarts an integration service environment.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  var path_575501 = newJObject()
  var query_575502 = newJObject()
  add(query_575502, "api-version", newJString(apiVersion))
  add(path_575501, "subscriptionId", newJString(subscriptionId))
  add(path_575501, "resourceGroup", newJString(resourceGroup))
  add(path_575501, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  result = call_575500.call(path_575501, query_575502, nil, nil, nil)

var integrationServiceEnvironmentsRestart* = Call_IntegrationServiceEnvironmentsRestart_575492(
    name: "integrationServiceEnvironmentsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}/restart",
    validator: validate_IntegrationServiceEnvironmentsRestart_575493, base: "",
    url: url_IntegrationServiceEnvironmentsRestart_575494, schemes: {Scheme.Https})
type
  Call_IntegrationServiceEnvironmentSkusList_575503 = ref object of OpenApiRestCall_573667
proc url_IntegrationServiceEnvironmentSkusList_575505(protocol: Scheme;
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

proc validate_IntegrationServiceEnvironmentSkusList_575504(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration service environment Skus.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   resourceGroup: JString (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: JString (required)
  ##                                    : The integration service environment name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575506 = path.getOrDefault("subscriptionId")
  valid_575506 = validateParameter(valid_575506, JString, required = true,
                                 default = nil)
  if valid_575506 != nil:
    section.add "subscriptionId", valid_575506
  var valid_575507 = path.getOrDefault("resourceGroup")
  valid_575507 = validateParameter(valid_575507, JString, required = true,
                                 default = nil)
  if valid_575507 != nil:
    section.add "resourceGroup", valid_575507
  var valid_575508 = path.getOrDefault("integrationServiceEnvironmentName")
  valid_575508 = validateParameter(valid_575508, JString, required = true,
                                 default = nil)
  if valid_575508 != nil:
    section.add "integrationServiceEnvironmentName", valid_575508
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575509 = query.getOrDefault("api-version")
  valid_575509 = validateParameter(valid_575509, JString, required = true,
                                 default = nil)
  if valid_575509 != nil:
    section.add "api-version", valid_575509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575510: Call_IntegrationServiceEnvironmentSkusList_575503;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration service environment Skus.
  ## 
  let valid = call_575510.validator(path, query, header, formData, body)
  let scheme = call_575510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575510.url(scheme.get, call_575510.host, call_575510.base,
                         call_575510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575510, url, valid)

proc call*(call_575511: Call_IntegrationServiceEnvironmentSkusList_575503;
          apiVersion: string; subscriptionId: string; resourceGroup: string;
          integrationServiceEnvironmentName: string): Recallable =
  ## integrationServiceEnvironmentSkusList
  ## Gets a list of integration service environment Skus.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   resourceGroup: string (required)
  ##                : The resource group.
  ##   integrationServiceEnvironmentName: string (required)
  ##                                    : The integration service environment name.
  var path_575512 = newJObject()
  var query_575513 = newJObject()
  add(query_575513, "api-version", newJString(apiVersion))
  add(path_575512, "subscriptionId", newJString(subscriptionId))
  add(path_575512, "resourceGroup", newJString(resourceGroup))
  add(path_575512, "integrationServiceEnvironmentName",
      newJString(integrationServiceEnvironmentName))
  result = call_575511.call(path_575512, query_575513, nil, nil, nil)

var integrationServiceEnvironmentSkusList* = Call_IntegrationServiceEnvironmentSkusList_575503(
    name: "integrationServiceEnvironmentSkusList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Logic/integrationServiceEnvironments/{integrationServiceEnvironmentName}/skus",
    validator: validate_IntegrationServiceEnvironmentSkusList_575504, base: "",
    url: url_IntegrationServiceEnvironmentSkusList_575505, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
