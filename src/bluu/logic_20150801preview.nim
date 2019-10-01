
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: LogicManagementClient
## version: 2015-08-01-preview
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

  OpenApiRestCall_567650 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567650](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567650): Option[Scheme] {.used.} =
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
  Call_IntegrationAccountsListBySubscription_567872 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountsListBySubscription_567874(protocol: Scheme;
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

proc validate_IntegrationAccountsListBySubscription_567873(path: JsonNode;
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
  var valid_568048 = path.getOrDefault("subscriptionId")
  valid_568048 = validateParameter(valid_568048, JString, required = true,
                                 default = nil)
  if valid_568048 != nil:
    section.add "subscriptionId", valid_568048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568049 = query.getOrDefault("api-version")
  valid_568049 = validateParameter(valid_568049, JString, required = true,
                                 default = nil)
  if valid_568049 != nil:
    section.add "api-version", valid_568049
  var valid_568050 = query.getOrDefault("$top")
  valid_568050 = validateParameter(valid_568050, JInt, required = false, default = nil)
  if valid_568050 != nil:
    section.add "$top", valid_568050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568073: Call_IntegrationAccountsListBySubscription_567872;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration accounts by subscription.
  ## 
  let valid = call_568073.validator(path, query, header, formData, body)
  let scheme = call_568073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568073.url(scheme.get, call_568073.host, call_568073.base,
                         call_568073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568073, url, valid)

proc call*(call_568144: Call_IntegrationAccountsListBySubscription_567872;
          apiVersion: string; subscriptionId: string; Top: int = 0): Recallable =
  ## integrationAccountsListBySubscription
  ## Gets a list of integration accounts by subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  var path_568145 = newJObject()
  var query_568147 = newJObject()
  add(query_568147, "api-version", newJString(apiVersion))
  add(path_568145, "subscriptionId", newJString(subscriptionId))
  add(query_568147, "$top", newJInt(Top))
  result = call_568144.call(path_568145, query_568147, nil, nil, nil)

var integrationAccountsListBySubscription* = Call_IntegrationAccountsListBySubscription_567872(
    name: "integrationAccountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Logic/integrationAccounts",
    validator: validate_IntegrationAccountsListBySubscription_567873, base: "",
    url: url_IntegrationAccountsListBySubscription_567874, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListByResourceGroup_568186 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountsListByResourceGroup_568188(protocol: Scheme;
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

proc validate_IntegrationAccountsListByResourceGroup_568187(path: JsonNode;
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
  var valid_568189 = path.getOrDefault("resourceGroupName")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "resourceGroupName", valid_568189
  var valid_568190 = path.getOrDefault("subscriptionId")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "subscriptionId", valid_568190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568191 = query.getOrDefault("api-version")
  valid_568191 = validateParameter(valid_568191, JString, required = true,
                                 default = nil)
  if valid_568191 != nil:
    section.add "api-version", valid_568191
  var valid_568192 = query.getOrDefault("$top")
  valid_568192 = validateParameter(valid_568192, JInt, required = false, default = nil)
  if valid_568192 != nil:
    section.add "$top", valid_568192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568193: Call_IntegrationAccountsListByResourceGroup_568186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration accounts by resource group.
  ## 
  let valid = call_568193.validator(path, query, header, formData, body)
  let scheme = call_568193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568193.url(scheme.get, call_568193.host, call_568193.base,
                         call_568193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568193, url, valid)

proc call*(call_568194: Call_IntegrationAccountsListByResourceGroup_568186;
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
  var path_568195 = newJObject()
  var query_568196 = newJObject()
  add(path_568195, "resourceGroupName", newJString(resourceGroupName))
  add(query_568196, "api-version", newJString(apiVersion))
  add(path_568195, "subscriptionId", newJString(subscriptionId))
  add(query_568196, "$top", newJInt(Top))
  result = call_568194.call(path_568195, query_568196, nil, nil, nil)

var integrationAccountsListByResourceGroup* = Call_IntegrationAccountsListByResourceGroup_568186(
    name: "integrationAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts",
    validator: validate_IntegrationAccountsListByResourceGroup_568187, base: "",
    url: url_IntegrationAccountsListByResourceGroup_568188,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountsCreateOrUpdate_568208 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountsCreateOrUpdate_568210(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsCreateOrUpdate_568209(path: JsonNode;
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
  var valid_568211 = path.getOrDefault("resourceGroupName")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "resourceGroupName", valid_568211
  var valid_568212 = path.getOrDefault("integrationAccountName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "integrationAccountName", valid_568212
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
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

proc call*(call_568216: Call_IntegrationAccountsCreateOrUpdate_568208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account.
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_IntegrationAccountsCreateOrUpdate_568208;
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
  var path_568218 = newJObject()
  var query_568219 = newJObject()
  var body_568220 = newJObject()
  add(path_568218, "resourceGroupName", newJString(resourceGroupName))
  add(query_568219, "api-version", newJString(apiVersion))
  add(path_568218, "integrationAccountName", newJString(integrationAccountName))
  add(path_568218, "subscriptionId", newJString(subscriptionId))
  if integrationAccount != nil:
    body_568220 = integrationAccount
  result = call_568217.call(path_568218, query_568219, nil, nil, body_568220)

var integrationAccountsCreateOrUpdate* = Call_IntegrationAccountsCreateOrUpdate_568208(
    name: "integrationAccountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsCreateOrUpdate_568209, base: "",
    url: url_IntegrationAccountsCreateOrUpdate_568210, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsGet_568197 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountsGet_568199(protocol: Scheme; host: string; base: string;
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

proc validate_IntegrationAccountsGet_568198(path: JsonNode; query: JsonNode;
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
  var valid_568200 = path.getOrDefault("resourceGroupName")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "resourceGroupName", valid_568200
  var valid_568201 = path.getOrDefault("integrationAccountName")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "integrationAccountName", valid_568201
  var valid_568202 = path.getOrDefault("subscriptionId")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "subscriptionId", valid_568202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568203 = query.getOrDefault("api-version")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "api-version", valid_568203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568204: Call_IntegrationAccountsGet_568197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account.
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_IntegrationAccountsGet_568197;
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
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  add(path_568206, "resourceGroupName", newJString(resourceGroupName))
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "integrationAccountName", newJString(integrationAccountName))
  add(path_568206, "subscriptionId", newJString(subscriptionId))
  result = call_568205.call(path_568206, query_568207, nil, nil, nil)

var integrationAccountsGet* = Call_IntegrationAccountsGet_568197(
    name: "integrationAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsGet_568198, base: "",
    url: url_IntegrationAccountsGet_568199, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsUpdate_568232 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountsUpdate_568234(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsUpdate_568233(path: JsonNode; query: JsonNode;
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
  ## parameters in `body` object:
  ##   integrationAccount: JObject (required)
  ##                     : The integration account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568240: Call_IntegrationAccountsUpdate_568232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an integration account.
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_IntegrationAccountsUpdate_568232;
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
  var path_568242 = newJObject()
  var query_568243 = newJObject()
  var body_568244 = newJObject()
  add(path_568242, "resourceGroupName", newJString(resourceGroupName))
  add(query_568243, "api-version", newJString(apiVersion))
  add(path_568242, "integrationAccountName", newJString(integrationAccountName))
  add(path_568242, "subscriptionId", newJString(subscriptionId))
  if integrationAccount != nil:
    body_568244 = integrationAccount
  result = call_568241.call(path_568242, query_568243, nil, nil, body_568244)

var integrationAccountsUpdate* = Call_IntegrationAccountsUpdate_568232(
    name: "integrationAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsUpdate_568233, base: "",
    url: url_IntegrationAccountsUpdate_568234, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsDelete_568221 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountsDelete_568223(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsDelete_568222(path: JsonNode; query: JsonNode;
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
  var valid_568224 = path.getOrDefault("resourceGroupName")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "resourceGroupName", valid_568224
  var valid_568225 = path.getOrDefault("integrationAccountName")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "integrationAccountName", valid_568225
  var valid_568226 = path.getOrDefault("subscriptionId")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "subscriptionId", valid_568226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568227 = query.getOrDefault("api-version")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "api-version", valid_568227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568228: Call_IntegrationAccountsDelete_568221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account.
  ## 
  let valid = call_568228.validator(path, query, header, formData, body)
  let scheme = call_568228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568228.url(scheme.get, call_568228.host, call_568228.base,
                         call_568228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568228, url, valid)

proc call*(call_568229: Call_IntegrationAccountsDelete_568221;
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
  var path_568230 = newJObject()
  var query_568231 = newJObject()
  add(path_568230, "resourceGroupName", newJString(resourceGroupName))
  add(query_568231, "api-version", newJString(apiVersion))
  add(path_568230, "integrationAccountName", newJString(integrationAccountName))
  add(path_568230, "subscriptionId", newJString(subscriptionId))
  result = call_568229.call(path_568230, query_568231, nil, nil, nil)

var integrationAccountsDelete* = Call_IntegrationAccountsDelete_568221(
    name: "integrationAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsDelete_568222, base: "",
    url: url_IntegrationAccountsDelete_568223, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsList_568245 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountAgreementsList_568247(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAgreementsList_568246(path: JsonNode;
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
  var valid_568248 = path.getOrDefault("resourceGroupName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "resourceGroupName", valid_568248
  var valid_568249 = path.getOrDefault("integrationAccountName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "integrationAccountName", valid_568249
  var valid_568250 = path.getOrDefault("subscriptionId")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "subscriptionId", valid_568250
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
  var valid_568251 = query.getOrDefault("api-version")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "api-version", valid_568251
  var valid_568252 = query.getOrDefault("$top")
  valid_568252 = validateParameter(valid_568252, JInt, required = false, default = nil)
  if valid_568252 != nil:
    section.add "$top", valid_568252
  var valid_568253 = query.getOrDefault("$filter")
  valid_568253 = validateParameter(valid_568253, JString, required = false,
                                 default = nil)
  if valid_568253 != nil:
    section.add "$filter", valid_568253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568254: Call_IntegrationAccountAgreementsList_568245;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account agreements.
  ## 
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_IntegrationAccountAgreementsList_568245;
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
  ##         : The filter to apply on the operation.
  var path_568256 = newJObject()
  var query_568257 = newJObject()
  add(path_568256, "resourceGroupName", newJString(resourceGroupName))
  add(query_568257, "api-version", newJString(apiVersion))
  add(path_568256, "integrationAccountName", newJString(integrationAccountName))
  add(path_568256, "subscriptionId", newJString(subscriptionId))
  add(query_568257, "$top", newJInt(Top))
  add(query_568257, "$filter", newJString(Filter))
  result = call_568255.call(path_568256, query_568257, nil, nil, nil)

var integrationAccountAgreementsList* = Call_IntegrationAccountAgreementsList_568245(
    name: "integrationAccountAgreementsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements",
    validator: validate_IntegrationAccountAgreementsList_568246, base: "",
    url: url_IntegrationAccountAgreementsList_568247, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsCreateOrUpdate_568270 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountAgreementsCreateOrUpdate_568272(protocol: Scheme;
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

proc validate_IntegrationAccountAgreementsCreateOrUpdate_568271(path: JsonNode;
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
  var valid_568273 = path.getOrDefault("resourceGroupName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "resourceGroupName", valid_568273
  var valid_568274 = path.getOrDefault("integrationAccountName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "integrationAccountName", valid_568274
  var valid_568275 = path.getOrDefault("subscriptionId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "subscriptionId", valid_568275
  var valid_568276 = path.getOrDefault("agreementName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "agreementName", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568277 = query.getOrDefault("api-version")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "api-version", valid_568277
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

proc call*(call_568279: Call_IntegrationAccountAgreementsCreateOrUpdate_568270;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account agreement.
  ## 
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_IntegrationAccountAgreementsCreateOrUpdate_568270;
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
  var path_568281 = newJObject()
  var query_568282 = newJObject()
  var body_568283 = newJObject()
  add(path_568281, "resourceGroupName", newJString(resourceGroupName))
  add(query_568282, "api-version", newJString(apiVersion))
  add(path_568281, "integrationAccountName", newJString(integrationAccountName))
  add(path_568281, "subscriptionId", newJString(subscriptionId))
  add(path_568281, "agreementName", newJString(agreementName))
  if agreement != nil:
    body_568283 = agreement
  result = call_568280.call(path_568281, query_568282, nil, nil, body_568283)

var integrationAccountAgreementsCreateOrUpdate* = Call_IntegrationAccountAgreementsCreateOrUpdate_568270(
    name: "integrationAccountAgreementsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_IntegrationAccountAgreementsCreateOrUpdate_568271,
    base: "", url: url_IntegrationAccountAgreementsCreateOrUpdate_568272,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsGet_568258 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountAgreementsGet_568260(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAgreementsGet_568259(path: JsonNode;
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
  var valid_568261 = path.getOrDefault("resourceGroupName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "resourceGroupName", valid_568261
  var valid_568262 = path.getOrDefault("integrationAccountName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "integrationAccountName", valid_568262
  var valid_568263 = path.getOrDefault("subscriptionId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "subscriptionId", valid_568263
  var valid_568264 = path.getOrDefault("agreementName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "agreementName", valid_568264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568265 = query.getOrDefault("api-version")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "api-version", valid_568265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568266: Call_IntegrationAccountAgreementsGet_568258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an integration account agreement.
  ## 
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_IntegrationAccountAgreementsGet_568258;
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
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  add(path_568268, "resourceGroupName", newJString(resourceGroupName))
  add(query_568269, "api-version", newJString(apiVersion))
  add(path_568268, "integrationAccountName", newJString(integrationAccountName))
  add(path_568268, "subscriptionId", newJString(subscriptionId))
  add(path_568268, "agreementName", newJString(agreementName))
  result = call_568267.call(path_568268, query_568269, nil, nil, nil)

var integrationAccountAgreementsGet* = Call_IntegrationAccountAgreementsGet_568258(
    name: "integrationAccountAgreementsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_IntegrationAccountAgreementsGet_568259, base: "",
    url: url_IntegrationAccountAgreementsGet_568260, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsDelete_568284 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountAgreementsDelete_568286(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAgreementsDelete_568285(path: JsonNode;
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
  var valid_568287 = path.getOrDefault("resourceGroupName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "resourceGroupName", valid_568287
  var valid_568288 = path.getOrDefault("integrationAccountName")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "integrationAccountName", valid_568288
  var valid_568289 = path.getOrDefault("subscriptionId")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "subscriptionId", valid_568289
  var valid_568290 = path.getOrDefault("agreementName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "agreementName", valid_568290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568291 = query.getOrDefault("api-version")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "api-version", valid_568291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568292: Call_IntegrationAccountAgreementsDelete_568284;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account agreement.
  ## 
  let valid = call_568292.validator(path, query, header, formData, body)
  let scheme = call_568292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568292.url(scheme.get, call_568292.host, call_568292.base,
                         call_568292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568292, url, valid)

proc call*(call_568293: Call_IntegrationAccountAgreementsDelete_568284;
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
  var path_568294 = newJObject()
  var query_568295 = newJObject()
  add(path_568294, "resourceGroupName", newJString(resourceGroupName))
  add(query_568295, "api-version", newJString(apiVersion))
  add(path_568294, "integrationAccountName", newJString(integrationAccountName))
  add(path_568294, "subscriptionId", newJString(subscriptionId))
  add(path_568294, "agreementName", newJString(agreementName))
  result = call_568293.call(path_568294, query_568295, nil, nil, nil)

var integrationAccountAgreementsDelete* = Call_IntegrationAccountAgreementsDelete_568284(
    name: "integrationAccountAgreementsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_IntegrationAccountAgreementsDelete_568285, base: "",
    url: url_IntegrationAccountAgreementsDelete_568286, schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesList_568296 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountCertificatesList_568298(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountCertificatesList_568297(path: JsonNode;
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
  var valid_568299 = path.getOrDefault("resourceGroupName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "resourceGroupName", valid_568299
  var valid_568300 = path.getOrDefault("integrationAccountName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "integrationAccountName", valid_568300
  var valid_568301 = path.getOrDefault("subscriptionId")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "subscriptionId", valid_568301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568302 = query.getOrDefault("api-version")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "api-version", valid_568302
  var valid_568303 = query.getOrDefault("$top")
  valid_568303 = validateParameter(valid_568303, JInt, required = false, default = nil)
  if valid_568303 != nil:
    section.add "$top", valid_568303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568304: Call_IntegrationAccountCertificatesList_568296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account certificates.
  ## 
  let valid = call_568304.validator(path, query, header, formData, body)
  let scheme = call_568304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568304.url(scheme.get, call_568304.host, call_568304.base,
                         call_568304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568304, url, valid)

proc call*(call_568305: Call_IntegrationAccountCertificatesList_568296;
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
  var path_568306 = newJObject()
  var query_568307 = newJObject()
  add(path_568306, "resourceGroupName", newJString(resourceGroupName))
  add(query_568307, "api-version", newJString(apiVersion))
  add(path_568306, "integrationAccountName", newJString(integrationAccountName))
  add(path_568306, "subscriptionId", newJString(subscriptionId))
  add(query_568307, "$top", newJInt(Top))
  result = call_568305.call(path_568306, query_568307, nil, nil, nil)

var integrationAccountCertificatesList* = Call_IntegrationAccountCertificatesList_568296(
    name: "integrationAccountCertificatesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates",
    validator: validate_IntegrationAccountCertificatesList_568297, base: "",
    url: url_IntegrationAccountCertificatesList_568298, schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesCreateOrUpdate_568320 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountCertificatesCreateOrUpdate_568322(protocol: Scheme;
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

proc validate_IntegrationAccountCertificatesCreateOrUpdate_568321(path: JsonNode;
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
  var valid_568323 = path.getOrDefault("resourceGroupName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "resourceGroupName", valid_568323
  var valid_568324 = path.getOrDefault("integrationAccountName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "integrationAccountName", valid_568324
  var valid_568325 = path.getOrDefault("subscriptionId")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "subscriptionId", valid_568325
  var valid_568326 = path.getOrDefault("certificateName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "certificateName", valid_568326
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568327 = query.getOrDefault("api-version")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "api-version", valid_568327
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

proc call*(call_568329: Call_IntegrationAccountCertificatesCreateOrUpdate_568320;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account certificate.
  ## 
  let valid = call_568329.validator(path, query, header, formData, body)
  let scheme = call_568329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568329.url(scheme.get, call_568329.host, call_568329.base,
                         call_568329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568329, url, valid)

proc call*(call_568330: Call_IntegrationAccountCertificatesCreateOrUpdate_568320;
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
  var path_568331 = newJObject()
  var query_568332 = newJObject()
  var body_568333 = newJObject()
  add(path_568331, "resourceGroupName", newJString(resourceGroupName))
  add(query_568332, "api-version", newJString(apiVersion))
  add(path_568331, "integrationAccountName", newJString(integrationAccountName))
  add(path_568331, "subscriptionId", newJString(subscriptionId))
  if certificate != nil:
    body_568333 = certificate
  add(path_568331, "certificateName", newJString(certificateName))
  result = call_568330.call(path_568331, query_568332, nil, nil, body_568333)

var integrationAccountCertificatesCreateOrUpdate* = Call_IntegrationAccountCertificatesCreateOrUpdate_568320(
    name: "integrationAccountCertificatesCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_IntegrationAccountCertificatesCreateOrUpdate_568321,
    base: "", url: url_IntegrationAccountCertificatesCreateOrUpdate_568322,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesGet_568308 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountCertificatesGet_568310(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountCertificatesGet_568309(path: JsonNode;
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
  var valid_568311 = path.getOrDefault("resourceGroupName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "resourceGroupName", valid_568311
  var valid_568312 = path.getOrDefault("integrationAccountName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "integrationAccountName", valid_568312
  var valid_568313 = path.getOrDefault("subscriptionId")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "subscriptionId", valid_568313
  var valid_568314 = path.getOrDefault("certificateName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "certificateName", valid_568314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568315 = query.getOrDefault("api-version")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "api-version", valid_568315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568316: Call_IntegrationAccountCertificatesGet_568308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an integration account certificate.
  ## 
  let valid = call_568316.validator(path, query, header, formData, body)
  let scheme = call_568316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568316.url(scheme.get, call_568316.host, call_568316.base,
                         call_568316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568316, url, valid)

proc call*(call_568317: Call_IntegrationAccountCertificatesGet_568308;
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
  var path_568318 = newJObject()
  var query_568319 = newJObject()
  add(path_568318, "resourceGroupName", newJString(resourceGroupName))
  add(query_568319, "api-version", newJString(apiVersion))
  add(path_568318, "integrationAccountName", newJString(integrationAccountName))
  add(path_568318, "subscriptionId", newJString(subscriptionId))
  add(path_568318, "certificateName", newJString(certificateName))
  result = call_568317.call(path_568318, query_568319, nil, nil, nil)

var integrationAccountCertificatesGet* = Call_IntegrationAccountCertificatesGet_568308(
    name: "integrationAccountCertificatesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_IntegrationAccountCertificatesGet_568309, base: "",
    url: url_IntegrationAccountCertificatesGet_568310, schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesDelete_568334 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountCertificatesDelete_568336(protocol: Scheme;
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

proc validate_IntegrationAccountCertificatesDelete_568335(path: JsonNode;
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
  var valid_568337 = path.getOrDefault("resourceGroupName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "resourceGroupName", valid_568337
  var valid_568338 = path.getOrDefault("integrationAccountName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "integrationAccountName", valid_568338
  var valid_568339 = path.getOrDefault("subscriptionId")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "subscriptionId", valid_568339
  var valid_568340 = path.getOrDefault("certificateName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "certificateName", valid_568340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568341 = query.getOrDefault("api-version")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "api-version", valid_568341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568342: Call_IntegrationAccountCertificatesDelete_568334;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account certificate.
  ## 
  let valid = call_568342.validator(path, query, header, formData, body)
  let scheme = call_568342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568342.url(scheme.get, call_568342.host, call_568342.base,
                         call_568342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568342, url, valid)

proc call*(call_568343: Call_IntegrationAccountCertificatesDelete_568334;
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
  var path_568344 = newJObject()
  var query_568345 = newJObject()
  add(path_568344, "resourceGroupName", newJString(resourceGroupName))
  add(query_568345, "api-version", newJString(apiVersion))
  add(path_568344, "integrationAccountName", newJString(integrationAccountName))
  add(path_568344, "subscriptionId", newJString(subscriptionId))
  add(path_568344, "certificateName", newJString(certificateName))
  result = call_568343.call(path_568344, query_568345, nil, nil, nil)

var integrationAccountCertificatesDelete* = Call_IntegrationAccountCertificatesDelete_568334(
    name: "integrationAccountCertificatesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_IntegrationAccountCertificatesDelete_568335, base: "",
    url: url_IntegrationAccountCertificatesDelete_568336, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListCallbackUrl_568346 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountsListCallbackUrl_568348(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsListCallbackUrl_568347(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the integration account callback URL.
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
  var valid_568349 = path.getOrDefault("resourceGroupName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "resourceGroupName", valid_568349
  var valid_568350 = path.getOrDefault("integrationAccountName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "integrationAccountName", valid_568350
  var valid_568351 = path.getOrDefault("subscriptionId")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "subscriptionId", valid_568351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568352 = query.getOrDefault("api-version")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "api-version", valid_568352
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

proc call*(call_568354: Call_IntegrationAccountsListCallbackUrl_568346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the integration account callback URL.
  ## 
  let valid = call_568354.validator(path, query, header, formData, body)
  let scheme = call_568354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568354.url(scheme.get, call_568354.host, call_568354.base,
                         call_568354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568354, url, valid)

proc call*(call_568355: Call_IntegrationAccountsListCallbackUrl_568346;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## integrationAccountsListCallbackUrl
  ## Lists the integration account callback URL.
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
  var path_568356 = newJObject()
  var query_568357 = newJObject()
  var body_568358 = newJObject()
  add(path_568356, "resourceGroupName", newJString(resourceGroupName))
  add(query_568357, "api-version", newJString(apiVersion))
  add(path_568356, "integrationAccountName", newJString(integrationAccountName))
  add(path_568356, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568358 = parameters
  result = call_568355.call(path_568356, query_568357, nil, nil, body_568358)

var integrationAccountsListCallbackUrl* = Call_IntegrationAccountsListCallbackUrl_568346(
    name: "integrationAccountsListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/listCallbackUrl",
    validator: validate_IntegrationAccountsListCallbackUrl_568347, base: "",
    url: url_IntegrationAccountsListCallbackUrl_568348, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsList_568359 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountMapsList_568361(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountMapsList_568360(path: JsonNode; query: JsonNode;
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
  var valid_568362 = path.getOrDefault("resourceGroupName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "resourceGroupName", valid_568362
  var valid_568363 = path.getOrDefault("integrationAccountName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "integrationAccountName", valid_568363
  var valid_568364 = path.getOrDefault("subscriptionId")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "subscriptionId", valid_568364
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
  var valid_568365 = query.getOrDefault("api-version")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "api-version", valid_568365
  var valid_568366 = query.getOrDefault("$top")
  valid_568366 = validateParameter(valid_568366, JInt, required = false, default = nil)
  if valid_568366 != nil:
    section.add "$top", valid_568366
  var valid_568367 = query.getOrDefault("$filter")
  valid_568367 = validateParameter(valid_568367, JString, required = false,
                                 default = nil)
  if valid_568367 != nil:
    section.add "$filter", valid_568367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568368: Call_IntegrationAccountMapsList_568359; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account maps.
  ## 
  let valid = call_568368.validator(path, query, header, formData, body)
  let scheme = call_568368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568368.url(scheme.get, call_568368.host, call_568368.base,
                         call_568368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568368, url, valid)

proc call*(call_568369: Call_IntegrationAccountMapsList_568359;
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
  ##         : The filter to apply on the operation.
  var path_568370 = newJObject()
  var query_568371 = newJObject()
  add(path_568370, "resourceGroupName", newJString(resourceGroupName))
  add(query_568371, "api-version", newJString(apiVersion))
  add(path_568370, "integrationAccountName", newJString(integrationAccountName))
  add(path_568370, "subscriptionId", newJString(subscriptionId))
  add(query_568371, "$top", newJInt(Top))
  add(query_568371, "$filter", newJString(Filter))
  result = call_568369.call(path_568370, query_568371, nil, nil, nil)

var integrationAccountMapsList* = Call_IntegrationAccountMapsList_568359(
    name: "integrationAccountMapsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps",
    validator: validate_IntegrationAccountMapsList_568360, base: "",
    url: url_IntegrationAccountMapsList_568361, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsCreateOrUpdate_568384 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountMapsCreateOrUpdate_568386(protocol: Scheme;
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

proc validate_IntegrationAccountMapsCreateOrUpdate_568385(path: JsonNode;
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
  var valid_568387 = path.getOrDefault("resourceGroupName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "resourceGroupName", valid_568387
  var valid_568388 = path.getOrDefault("mapName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "mapName", valid_568388
  var valid_568389 = path.getOrDefault("integrationAccountName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "integrationAccountName", valid_568389
  var valid_568390 = path.getOrDefault("subscriptionId")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "subscriptionId", valid_568390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568391 = query.getOrDefault("api-version")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "api-version", valid_568391
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

proc call*(call_568393: Call_IntegrationAccountMapsCreateOrUpdate_568384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account map.
  ## 
  let valid = call_568393.validator(path, query, header, formData, body)
  let scheme = call_568393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568393.url(scheme.get, call_568393.host, call_568393.base,
                         call_568393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568393, url, valid)

proc call*(call_568394: Call_IntegrationAccountMapsCreateOrUpdate_568384;
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
  var path_568395 = newJObject()
  var query_568396 = newJObject()
  var body_568397 = newJObject()
  add(path_568395, "resourceGroupName", newJString(resourceGroupName))
  if map != nil:
    body_568397 = map
  add(path_568395, "mapName", newJString(mapName))
  add(query_568396, "api-version", newJString(apiVersion))
  add(path_568395, "integrationAccountName", newJString(integrationAccountName))
  add(path_568395, "subscriptionId", newJString(subscriptionId))
  result = call_568394.call(path_568395, query_568396, nil, nil, body_568397)

var integrationAccountMapsCreateOrUpdate* = Call_IntegrationAccountMapsCreateOrUpdate_568384(
    name: "integrationAccountMapsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_IntegrationAccountMapsCreateOrUpdate_568385, base: "",
    url: url_IntegrationAccountMapsCreateOrUpdate_568386, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsGet_568372 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountMapsGet_568374(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountMapsGet_568373(path: JsonNode; query: JsonNode;
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
  var valid_568375 = path.getOrDefault("resourceGroupName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "resourceGroupName", valid_568375
  var valid_568376 = path.getOrDefault("mapName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "mapName", valid_568376
  var valid_568377 = path.getOrDefault("integrationAccountName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "integrationAccountName", valid_568377
  var valid_568378 = path.getOrDefault("subscriptionId")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "subscriptionId", valid_568378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568379 = query.getOrDefault("api-version")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "api-version", valid_568379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568380: Call_IntegrationAccountMapsGet_568372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account map.
  ## 
  let valid = call_568380.validator(path, query, header, formData, body)
  let scheme = call_568380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568380.url(scheme.get, call_568380.host, call_568380.base,
                         call_568380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568380, url, valid)

proc call*(call_568381: Call_IntegrationAccountMapsGet_568372;
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
  var path_568382 = newJObject()
  var query_568383 = newJObject()
  add(path_568382, "resourceGroupName", newJString(resourceGroupName))
  add(path_568382, "mapName", newJString(mapName))
  add(query_568383, "api-version", newJString(apiVersion))
  add(path_568382, "integrationAccountName", newJString(integrationAccountName))
  add(path_568382, "subscriptionId", newJString(subscriptionId))
  result = call_568381.call(path_568382, query_568383, nil, nil, nil)

var integrationAccountMapsGet* = Call_IntegrationAccountMapsGet_568372(
    name: "integrationAccountMapsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_IntegrationAccountMapsGet_568373, base: "",
    url: url_IntegrationAccountMapsGet_568374, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsDelete_568398 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountMapsDelete_568400(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountMapsDelete_568399(path: JsonNode; query: JsonNode;
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
  var valid_568401 = path.getOrDefault("resourceGroupName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "resourceGroupName", valid_568401
  var valid_568402 = path.getOrDefault("mapName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "mapName", valid_568402
  var valid_568403 = path.getOrDefault("integrationAccountName")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "integrationAccountName", valid_568403
  var valid_568404 = path.getOrDefault("subscriptionId")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "subscriptionId", valid_568404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568405 = query.getOrDefault("api-version")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "api-version", valid_568405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568406: Call_IntegrationAccountMapsDelete_568398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account map.
  ## 
  let valid = call_568406.validator(path, query, header, formData, body)
  let scheme = call_568406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568406.url(scheme.get, call_568406.host, call_568406.base,
                         call_568406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568406, url, valid)

proc call*(call_568407: Call_IntegrationAccountMapsDelete_568398;
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
  var path_568408 = newJObject()
  var query_568409 = newJObject()
  add(path_568408, "resourceGroupName", newJString(resourceGroupName))
  add(path_568408, "mapName", newJString(mapName))
  add(query_568409, "api-version", newJString(apiVersion))
  add(path_568408, "integrationAccountName", newJString(integrationAccountName))
  add(path_568408, "subscriptionId", newJString(subscriptionId))
  result = call_568407.call(path_568408, query_568409, nil, nil, nil)

var integrationAccountMapsDelete* = Call_IntegrationAccountMapsDelete_568398(
    name: "integrationAccountMapsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_IntegrationAccountMapsDelete_568399, base: "",
    url: url_IntegrationAccountMapsDelete_568400, schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersList_568410 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountPartnersList_568412(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountPartnersList_568411(path: JsonNode;
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
  var valid_568413 = path.getOrDefault("resourceGroupName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "resourceGroupName", valid_568413
  var valid_568414 = path.getOrDefault("integrationAccountName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "integrationAccountName", valid_568414
  var valid_568415 = path.getOrDefault("subscriptionId")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "subscriptionId", valid_568415
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
  var valid_568416 = query.getOrDefault("api-version")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "api-version", valid_568416
  var valid_568417 = query.getOrDefault("$top")
  valid_568417 = validateParameter(valid_568417, JInt, required = false, default = nil)
  if valid_568417 != nil:
    section.add "$top", valid_568417
  var valid_568418 = query.getOrDefault("$filter")
  valid_568418 = validateParameter(valid_568418, JString, required = false,
                                 default = nil)
  if valid_568418 != nil:
    section.add "$filter", valid_568418
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568419: Call_IntegrationAccountPartnersList_568410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account partners.
  ## 
  let valid = call_568419.validator(path, query, header, formData, body)
  let scheme = call_568419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568419.url(scheme.get, call_568419.host, call_568419.base,
                         call_568419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568419, url, valid)

proc call*(call_568420: Call_IntegrationAccountPartnersList_568410;
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
  ##         : The filter to apply on the operation.
  var path_568421 = newJObject()
  var query_568422 = newJObject()
  add(path_568421, "resourceGroupName", newJString(resourceGroupName))
  add(query_568422, "api-version", newJString(apiVersion))
  add(path_568421, "integrationAccountName", newJString(integrationAccountName))
  add(path_568421, "subscriptionId", newJString(subscriptionId))
  add(query_568422, "$top", newJInt(Top))
  add(query_568422, "$filter", newJString(Filter))
  result = call_568420.call(path_568421, query_568422, nil, nil, nil)

var integrationAccountPartnersList* = Call_IntegrationAccountPartnersList_568410(
    name: "integrationAccountPartnersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners",
    validator: validate_IntegrationAccountPartnersList_568411, base: "",
    url: url_IntegrationAccountPartnersList_568412, schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersCreateOrUpdate_568435 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountPartnersCreateOrUpdate_568437(protocol: Scheme;
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

proc validate_IntegrationAccountPartnersCreateOrUpdate_568436(path: JsonNode;
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
  var valid_568438 = path.getOrDefault("resourceGroupName")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "resourceGroupName", valid_568438
  var valid_568439 = path.getOrDefault("integrationAccountName")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "integrationAccountName", valid_568439
  var valid_568440 = path.getOrDefault("subscriptionId")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "subscriptionId", valid_568440
  var valid_568441 = path.getOrDefault("partnerName")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "partnerName", valid_568441
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568442 = query.getOrDefault("api-version")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "api-version", valid_568442
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

proc call*(call_568444: Call_IntegrationAccountPartnersCreateOrUpdate_568435;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account partner.
  ## 
  let valid = call_568444.validator(path, query, header, formData, body)
  let scheme = call_568444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568444.url(scheme.get, call_568444.host, call_568444.base,
                         call_568444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568444, url, valid)

proc call*(call_568445: Call_IntegrationAccountPartnersCreateOrUpdate_568435;
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
  var path_568446 = newJObject()
  var query_568447 = newJObject()
  var body_568448 = newJObject()
  add(path_568446, "resourceGroupName", newJString(resourceGroupName))
  add(query_568447, "api-version", newJString(apiVersion))
  add(path_568446, "integrationAccountName", newJString(integrationAccountName))
  add(path_568446, "subscriptionId", newJString(subscriptionId))
  if partner != nil:
    body_568448 = partner
  add(path_568446, "partnerName", newJString(partnerName))
  result = call_568445.call(path_568446, query_568447, nil, nil, body_568448)

var integrationAccountPartnersCreateOrUpdate* = Call_IntegrationAccountPartnersCreateOrUpdate_568435(
    name: "integrationAccountPartnersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_IntegrationAccountPartnersCreateOrUpdate_568436, base: "",
    url: url_IntegrationAccountPartnersCreateOrUpdate_568437,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersGet_568423 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountPartnersGet_568425(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountPartnersGet_568424(path: JsonNode; query: JsonNode;
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
  var valid_568426 = path.getOrDefault("resourceGroupName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "resourceGroupName", valid_568426
  var valid_568427 = path.getOrDefault("integrationAccountName")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "integrationAccountName", valid_568427
  var valid_568428 = path.getOrDefault("subscriptionId")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "subscriptionId", valid_568428
  var valid_568429 = path.getOrDefault("partnerName")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "partnerName", valid_568429
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568430 = query.getOrDefault("api-version")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "api-version", valid_568430
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568431: Call_IntegrationAccountPartnersGet_568423; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account partner.
  ## 
  let valid = call_568431.validator(path, query, header, formData, body)
  let scheme = call_568431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568431.url(scheme.get, call_568431.host, call_568431.base,
                         call_568431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568431, url, valid)

proc call*(call_568432: Call_IntegrationAccountPartnersGet_568423;
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
  var path_568433 = newJObject()
  var query_568434 = newJObject()
  add(path_568433, "resourceGroupName", newJString(resourceGroupName))
  add(query_568434, "api-version", newJString(apiVersion))
  add(path_568433, "integrationAccountName", newJString(integrationAccountName))
  add(path_568433, "subscriptionId", newJString(subscriptionId))
  add(path_568433, "partnerName", newJString(partnerName))
  result = call_568432.call(path_568433, query_568434, nil, nil, nil)

var integrationAccountPartnersGet* = Call_IntegrationAccountPartnersGet_568423(
    name: "integrationAccountPartnersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_IntegrationAccountPartnersGet_568424, base: "",
    url: url_IntegrationAccountPartnersGet_568425, schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersDelete_568449 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountPartnersDelete_568451(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountPartnersDelete_568450(path: JsonNode;
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
  var valid_568452 = path.getOrDefault("resourceGroupName")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "resourceGroupName", valid_568452
  var valid_568453 = path.getOrDefault("integrationAccountName")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "integrationAccountName", valid_568453
  var valid_568454 = path.getOrDefault("subscriptionId")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "subscriptionId", valid_568454
  var valid_568455 = path.getOrDefault("partnerName")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "partnerName", valid_568455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568456 = query.getOrDefault("api-version")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "api-version", valid_568456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568457: Call_IntegrationAccountPartnersDelete_568449;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account partner.
  ## 
  let valid = call_568457.validator(path, query, header, formData, body)
  let scheme = call_568457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568457.url(scheme.get, call_568457.host, call_568457.base,
                         call_568457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568457, url, valid)

proc call*(call_568458: Call_IntegrationAccountPartnersDelete_568449;
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
  var path_568459 = newJObject()
  var query_568460 = newJObject()
  add(path_568459, "resourceGroupName", newJString(resourceGroupName))
  add(query_568460, "api-version", newJString(apiVersion))
  add(path_568459, "integrationAccountName", newJString(integrationAccountName))
  add(path_568459, "subscriptionId", newJString(subscriptionId))
  add(path_568459, "partnerName", newJString(partnerName))
  result = call_568458.call(path_568459, query_568460, nil, nil, nil)

var integrationAccountPartnersDelete* = Call_IntegrationAccountPartnersDelete_568449(
    name: "integrationAccountPartnersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_IntegrationAccountPartnersDelete_568450, base: "",
    url: url_IntegrationAccountPartnersDelete_568451, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasList_568461 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountSchemasList_568463(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountSchemasList_568462(path: JsonNode; query: JsonNode;
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
  var valid_568464 = path.getOrDefault("resourceGroupName")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "resourceGroupName", valid_568464
  var valid_568465 = path.getOrDefault("integrationAccountName")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "integrationAccountName", valid_568465
  var valid_568466 = path.getOrDefault("subscriptionId")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "subscriptionId", valid_568466
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
  var valid_568467 = query.getOrDefault("api-version")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "api-version", valid_568467
  var valid_568468 = query.getOrDefault("$top")
  valid_568468 = validateParameter(valid_568468, JInt, required = false, default = nil)
  if valid_568468 != nil:
    section.add "$top", valid_568468
  var valid_568469 = query.getOrDefault("$filter")
  valid_568469 = validateParameter(valid_568469, JString, required = false,
                                 default = nil)
  if valid_568469 != nil:
    section.add "$filter", valid_568469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568470: Call_IntegrationAccountSchemasList_568461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account schemas.
  ## 
  let valid = call_568470.validator(path, query, header, formData, body)
  let scheme = call_568470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568470.url(scheme.get, call_568470.host, call_568470.base,
                         call_568470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568470, url, valid)

proc call*(call_568471: Call_IntegrationAccountSchemasList_568461;
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
  ##         : The filter to apply on the operation.
  var path_568472 = newJObject()
  var query_568473 = newJObject()
  add(path_568472, "resourceGroupName", newJString(resourceGroupName))
  add(query_568473, "api-version", newJString(apiVersion))
  add(path_568472, "integrationAccountName", newJString(integrationAccountName))
  add(path_568472, "subscriptionId", newJString(subscriptionId))
  add(query_568473, "$top", newJInt(Top))
  add(query_568473, "$filter", newJString(Filter))
  result = call_568471.call(path_568472, query_568473, nil, nil, nil)

var integrationAccountSchemasList* = Call_IntegrationAccountSchemasList_568461(
    name: "integrationAccountSchemasList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas",
    validator: validate_IntegrationAccountSchemasList_568462, base: "",
    url: url_IntegrationAccountSchemasList_568463, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasCreateOrUpdate_568486 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountSchemasCreateOrUpdate_568488(protocol: Scheme;
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

proc validate_IntegrationAccountSchemasCreateOrUpdate_568487(path: JsonNode;
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
  var valid_568489 = path.getOrDefault("resourceGroupName")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "resourceGroupName", valid_568489
  var valid_568490 = path.getOrDefault("integrationAccountName")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "integrationAccountName", valid_568490
  var valid_568491 = path.getOrDefault("subscriptionId")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "subscriptionId", valid_568491
  var valid_568492 = path.getOrDefault("schemaName")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "schemaName", valid_568492
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568493 = query.getOrDefault("api-version")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "api-version", valid_568493
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

proc call*(call_568495: Call_IntegrationAccountSchemasCreateOrUpdate_568486;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account schema.
  ## 
  let valid = call_568495.validator(path, query, header, formData, body)
  let scheme = call_568495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568495.url(scheme.get, call_568495.host, call_568495.base,
                         call_568495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568495, url, valid)

proc call*(call_568496: Call_IntegrationAccountSchemasCreateOrUpdate_568486;
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
  var path_568497 = newJObject()
  var query_568498 = newJObject()
  var body_568499 = newJObject()
  add(path_568497, "resourceGroupName", newJString(resourceGroupName))
  add(query_568498, "api-version", newJString(apiVersion))
  add(path_568497, "integrationAccountName", newJString(integrationAccountName))
  add(path_568497, "subscriptionId", newJString(subscriptionId))
  add(path_568497, "schemaName", newJString(schemaName))
  if schema != nil:
    body_568499 = schema
  result = call_568496.call(path_568497, query_568498, nil, nil, body_568499)

var integrationAccountSchemasCreateOrUpdate* = Call_IntegrationAccountSchemasCreateOrUpdate_568486(
    name: "integrationAccountSchemasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_IntegrationAccountSchemasCreateOrUpdate_568487, base: "",
    url: url_IntegrationAccountSchemasCreateOrUpdate_568488,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasGet_568474 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountSchemasGet_568476(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountSchemasGet_568475(path: JsonNode; query: JsonNode;
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
  var valid_568477 = path.getOrDefault("resourceGroupName")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "resourceGroupName", valid_568477
  var valid_568478 = path.getOrDefault("integrationAccountName")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "integrationAccountName", valid_568478
  var valid_568479 = path.getOrDefault("subscriptionId")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "subscriptionId", valid_568479
  var valid_568480 = path.getOrDefault("schemaName")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "schemaName", valid_568480
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568481 = query.getOrDefault("api-version")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "api-version", valid_568481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568482: Call_IntegrationAccountSchemasGet_568474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account schema.
  ## 
  let valid = call_568482.validator(path, query, header, formData, body)
  let scheme = call_568482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568482.url(scheme.get, call_568482.host, call_568482.base,
                         call_568482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568482, url, valid)

proc call*(call_568483: Call_IntegrationAccountSchemasGet_568474;
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
  var path_568484 = newJObject()
  var query_568485 = newJObject()
  add(path_568484, "resourceGroupName", newJString(resourceGroupName))
  add(query_568485, "api-version", newJString(apiVersion))
  add(path_568484, "integrationAccountName", newJString(integrationAccountName))
  add(path_568484, "subscriptionId", newJString(subscriptionId))
  add(path_568484, "schemaName", newJString(schemaName))
  result = call_568483.call(path_568484, query_568485, nil, nil, nil)

var integrationAccountSchemasGet* = Call_IntegrationAccountSchemasGet_568474(
    name: "integrationAccountSchemasGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_IntegrationAccountSchemasGet_568475, base: "",
    url: url_IntegrationAccountSchemasGet_568476, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasDelete_568500 = ref object of OpenApiRestCall_567650
proc url_IntegrationAccountSchemasDelete_568502(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountSchemasDelete_568501(path: JsonNode;
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
  var valid_568503 = path.getOrDefault("resourceGroupName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "resourceGroupName", valid_568503
  var valid_568504 = path.getOrDefault("integrationAccountName")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "integrationAccountName", valid_568504
  var valid_568505 = path.getOrDefault("subscriptionId")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "subscriptionId", valid_568505
  var valid_568506 = path.getOrDefault("schemaName")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "schemaName", valid_568506
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568507 = query.getOrDefault("api-version")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "api-version", valid_568507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568508: Call_IntegrationAccountSchemasDelete_568500;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account schema.
  ## 
  let valid = call_568508.validator(path, query, header, formData, body)
  let scheme = call_568508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568508.url(scheme.get, call_568508.host, call_568508.base,
                         call_568508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568508, url, valid)

proc call*(call_568509: Call_IntegrationAccountSchemasDelete_568500;
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
  var path_568510 = newJObject()
  var query_568511 = newJObject()
  add(path_568510, "resourceGroupName", newJString(resourceGroupName))
  add(query_568511, "api-version", newJString(apiVersion))
  add(path_568510, "integrationAccountName", newJString(integrationAccountName))
  add(path_568510, "subscriptionId", newJString(subscriptionId))
  add(path_568510, "schemaName", newJString(schemaName))
  result = call_568509.call(path_568510, query_568511, nil, nil, nil)

var integrationAccountSchemasDelete* = Call_IntegrationAccountSchemasDelete_568500(
    name: "integrationAccountSchemasDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_IntegrationAccountSchemasDelete_568501, base: "",
    url: url_IntegrationAccountSchemasDelete_568502, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
