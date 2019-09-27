
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
  Call_ListOperations_593660 = ref object of OpenApiRestCall_593438
proc url_ListOperations_593662(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListOperations_593661(path: JsonNode; query: JsonNode;
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
  var valid_593821 = query.getOrDefault("api-version")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "api-version", valid_593821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593844: Call_ListOperations_593660; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Logic REST API operations.
  ## 
  let valid = call_593844.validator(path, query, header, formData, body)
  let scheme = call_593844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593844.url(scheme.get, call_593844.host, call_593844.base,
                         call_593844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593844, url, valid)

proc call*(call_593915: Call_ListOperations_593660; apiVersion: string): Recallable =
  ## listOperations
  ## Lists all of the available Logic REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version.
  var query_593916 = newJObject()
  add(query_593916, "api-version", newJString(apiVersion))
  result = call_593915.call(nil, query_593916, nil, nil, nil)

var listOperations* = Call_ListOperations_593660(name: "listOperations",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Logic/operations",
    validator: validate_ListOperations_593661, base: "", url: url_ListOperations_593662,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListBySubscription_593956 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountsListBySubscription_593958(protocol: Scheme;
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

proc validate_IntegrationAccountsListBySubscription_593957(path: JsonNode;
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
  var valid_593974 = path.getOrDefault("subscriptionId")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "subscriptionId", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  var valid_593976 = query.getOrDefault("$top")
  valid_593976 = validateParameter(valid_593976, JInt, required = false, default = nil)
  if valid_593976 != nil:
    section.add "$top", valid_593976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593977: Call_IntegrationAccountsListBySubscription_593956;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration accounts by subscription.
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_IntegrationAccountsListBySubscription_593956;
          apiVersion: string; subscriptionId: string; Top: int = 0): Recallable =
  ## integrationAccountsListBySubscription
  ## Gets a list of integration accounts by subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  var path_593979 = newJObject()
  var query_593980 = newJObject()
  add(query_593980, "api-version", newJString(apiVersion))
  add(path_593979, "subscriptionId", newJString(subscriptionId))
  add(query_593980, "$top", newJInt(Top))
  result = call_593978.call(path_593979, query_593980, nil, nil, nil)

var integrationAccountsListBySubscription* = Call_IntegrationAccountsListBySubscription_593956(
    name: "integrationAccountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Logic/integrationAccounts",
    validator: validate_IntegrationAccountsListBySubscription_593957, base: "",
    url: url_IntegrationAccountsListBySubscription_593958, schemes: {Scheme.Https})
type
  Call_WorkflowsListBySubscription_593981 = ref object of OpenApiRestCall_593438
proc url_WorkflowsListBySubscription_593983(protocol: Scheme; host: string;
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

proc validate_WorkflowsListBySubscription_593982(path: JsonNode; query: JsonNode;
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
  var valid_593984 = path.getOrDefault("subscriptionId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "subscriptionId", valid_593984
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
  var valid_593985 = query.getOrDefault("api-version")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "api-version", valid_593985
  var valid_593986 = query.getOrDefault("$top")
  valid_593986 = validateParameter(valid_593986, JInt, required = false, default = nil)
  if valid_593986 != nil:
    section.add "$top", valid_593986
  var valid_593987 = query.getOrDefault("$filter")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "$filter", valid_593987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593988: Call_WorkflowsListBySubscription_593981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflows by subscription.
  ## 
  let valid = call_593988.validator(path, query, header, formData, body)
  let scheme = call_593988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593988.url(scheme.get, call_593988.host, call_593988.base,
                         call_593988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593988, url, valid)

proc call*(call_593989: Call_WorkflowsListBySubscription_593981;
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
  var path_593990 = newJObject()
  var query_593991 = newJObject()
  add(query_593991, "api-version", newJString(apiVersion))
  add(path_593990, "subscriptionId", newJString(subscriptionId))
  add(query_593991, "$top", newJInt(Top))
  add(query_593991, "$filter", newJString(Filter))
  result = call_593989.call(path_593990, query_593991, nil, nil, nil)

var workflowsListBySubscription* = Call_WorkflowsListBySubscription_593981(
    name: "workflowsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Logic/workflows",
    validator: validate_WorkflowsListBySubscription_593982, base: "",
    url: url_WorkflowsListBySubscription_593983, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListByResourceGroup_593992 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountsListByResourceGroup_593994(protocol: Scheme;
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

proc validate_IntegrationAccountsListByResourceGroup_593993(path: JsonNode;
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
  var valid_593995 = path.getOrDefault("resourceGroupName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "resourceGroupName", valid_593995
  var valid_593996 = path.getOrDefault("subscriptionId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "subscriptionId", valid_593996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593997 = query.getOrDefault("api-version")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "api-version", valid_593997
  var valid_593998 = query.getOrDefault("$top")
  valid_593998 = validateParameter(valid_593998, JInt, required = false, default = nil)
  if valid_593998 != nil:
    section.add "$top", valid_593998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593999: Call_IntegrationAccountsListByResourceGroup_593992;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration accounts by resource group.
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_IntegrationAccountsListByResourceGroup_593992;
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
  var path_594001 = newJObject()
  var query_594002 = newJObject()
  add(path_594001, "resourceGroupName", newJString(resourceGroupName))
  add(query_594002, "api-version", newJString(apiVersion))
  add(path_594001, "subscriptionId", newJString(subscriptionId))
  add(query_594002, "$top", newJInt(Top))
  result = call_594000.call(path_594001, query_594002, nil, nil, nil)

var integrationAccountsListByResourceGroup* = Call_IntegrationAccountsListByResourceGroup_593992(
    name: "integrationAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts",
    validator: validate_IntegrationAccountsListByResourceGroup_593993, base: "",
    url: url_IntegrationAccountsListByResourceGroup_593994,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountsCreateOrUpdate_594014 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountsCreateOrUpdate_594016(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsCreateOrUpdate_594015(path: JsonNode;
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
  var valid_594017 = path.getOrDefault("resourceGroupName")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "resourceGroupName", valid_594017
  var valid_594018 = path.getOrDefault("integrationAccountName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "integrationAccountName", valid_594018
  var valid_594019 = path.getOrDefault("subscriptionId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "subscriptionId", valid_594019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594020 = query.getOrDefault("api-version")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "api-version", valid_594020
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

proc call*(call_594022: Call_IntegrationAccountsCreateOrUpdate_594014;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account.
  ## 
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_IntegrationAccountsCreateOrUpdate_594014;
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
  var path_594024 = newJObject()
  var query_594025 = newJObject()
  var body_594026 = newJObject()
  add(path_594024, "resourceGroupName", newJString(resourceGroupName))
  add(query_594025, "api-version", newJString(apiVersion))
  add(path_594024, "integrationAccountName", newJString(integrationAccountName))
  add(path_594024, "subscriptionId", newJString(subscriptionId))
  if integrationAccount != nil:
    body_594026 = integrationAccount
  result = call_594023.call(path_594024, query_594025, nil, nil, body_594026)

var integrationAccountsCreateOrUpdate* = Call_IntegrationAccountsCreateOrUpdate_594014(
    name: "integrationAccountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsCreateOrUpdate_594015, base: "",
    url: url_IntegrationAccountsCreateOrUpdate_594016, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsGet_594003 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountsGet_594005(protocol: Scheme; host: string; base: string;
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

proc validate_IntegrationAccountsGet_594004(path: JsonNode; query: JsonNode;
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
  var valid_594006 = path.getOrDefault("resourceGroupName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "resourceGroupName", valid_594006
  var valid_594007 = path.getOrDefault("integrationAccountName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "integrationAccountName", valid_594007
  var valid_594008 = path.getOrDefault("subscriptionId")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "subscriptionId", valid_594008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_594010: Call_IntegrationAccountsGet_594003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account.
  ## 
  let valid = call_594010.validator(path, query, header, formData, body)
  let scheme = call_594010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594010.url(scheme.get, call_594010.host, call_594010.base,
                         call_594010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594010, url, valid)

proc call*(call_594011: Call_IntegrationAccountsGet_594003;
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
  var path_594012 = newJObject()
  var query_594013 = newJObject()
  add(path_594012, "resourceGroupName", newJString(resourceGroupName))
  add(query_594013, "api-version", newJString(apiVersion))
  add(path_594012, "integrationAccountName", newJString(integrationAccountName))
  add(path_594012, "subscriptionId", newJString(subscriptionId))
  result = call_594011.call(path_594012, query_594013, nil, nil, nil)

var integrationAccountsGet* = Call_IntegrationAccountsGet_594003(
    name: "integrationAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsGet_594004, base: "",
    url: url_IntegrationAccountsGet_594005, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsUpdate_594038 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountsUpdate_594040(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsUpdate_594039(path: JsonNode; query: JsonNode;
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
  var valid_594041 = path.getOrDefault("resourceGroupName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "resourceGroupName", valid_594041
  var valid_594042 = path.getOrDefault("integrationAccountName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "integrationAccountName", valid_594042
  var valid_594043 = path.getOrDefault("subscriptionId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "subscriptionId", valid_594043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594044 = query.getOrDefault("api-version")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "api-version", valid_594044
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

proc call*(call_594046: Call_IntegrationAccountsUpdate_594038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an integration account.
  ## 
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_IntegrationAccountsUpdate_594038;
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
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  var body_594050 = newJObject()
  add(path_594048, "resourceGroupName", newJString(resourceGroupName))
  add(query_594049, "api-version", newJString(apiVersion))
  add(path_594048, "integrationAccountName", newJString(integrationAccountName))
  add(path_594048, "subscriptionId", newJString(subscriptionId))
  if integrationAccount != nil:
    body_594050 = integrationAccount
  result = call_594047.call(path_594048, query_594049, nil, nil, body_594050)

var integrationAccountsUpdate* = Call_IntegrationAccountsUpdate_594038(
    name: "integrationAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsUpdate_594039, base: "",
    url: url_IntegrationAccountsUpdate_594040, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsDelete_594027 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountsDelete_594029(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsDelete_594028(path: JsonNode; query: JsonNode;
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
  var valid_594030 = path.getOrDefault("resourceGroupName")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "resourceGroupName", valid_594030
  var valid_594031 = path.getOrDefault("integrationAccountName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "integrationAccountName", valid_594031
  var valid_594032 = path.getOrDefault("subscriptionId")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "subscriptionId", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "api-version", valid_594033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594034: Call_IntegrationAccountsDelete_594027; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account.
  ## 
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_IntegrationAccountsDelete_594027;
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
  var path_594036 = newJObject()
  var query_594037 = newJObject()
  add(path_594036, "resourceGroupName", newJString(resourceGroupName))
  add(query_594037, "api-version", newJString(apiVersion))
  add(path_594036, "integrationAccountName", newJString(integrationAccountName))
  add(path_594036, "subscriptionId", newJString(subscriptionId))
  result = call_594035.call(path_594036, query_594037, nil, nil, nil)

var integrationAccountsDelete* = Call_IntegrationAccountsDelete_594027(
    name: "integrationAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsDelete_594028, base: "",
    url: url_IntegrationAccountsDelete_594029, schemes: {Scheme.Https})
type
  Call_AgreementsListByIntegrationAccounts_594051 = ref object of OpenApiRestCall_593438
proc url_AgreementsListByIntegrationAccounts_594053(protocol: Scheme; host: string;
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

proc validate_AgreementsListByIntegrationAccounts_594052(path: JsonNode;
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
  var valid_594054 = path.getOrDefault("resourceGroupName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "resourceGroupName", valid_594054
  var valid_594055 = path.getOrDefault("integrationAccountName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "integrationAccountName", valid_594055
  var valid_594056 = path.getOrDefault("subscriptionId")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "subscriptionId", valid_594056
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
  var valid_594057 = query.getOrDefault("api-version")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "api-version", valid_594057
  var valid_594058 = query.getOrDefault("$top")
  valid_594058 = validateParameter(valid_594058, JInt, required = false, default = nil)
  if valid_594058 != nil:
    section.add "$top", valid_594058
  var valid_594059 = query.getOrDefault("$filter")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "$filter", valid_594059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594060: Call_AgreementsListByIntegrationAccounts_594051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account agreements.
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_AgreementsListByIntegrationAccounts_594051;
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
  var path_594062 = newJObject()
  var query_594063 = newJObject()
  add(path_594062, "resourceGroupName", newJString(resourceGroupName))
  add(query_594063, "api-version", newJString(apiVersion))
  add(path_594062, "integrationAccountName", newJString(integrationAccountName))
  add(path_594062, "subscriptionId", newJString(subscriptionId))
  add(query_594063, "$top", newJInt(Top))
  add(query_594063, "$filter", newJString(Filter))
  result = call_594061.call(path_594062, query_594063, nil, nil, nil)

var agreementsListByIntegrationAccounts* = Call_AgreementsListByIntegrationAccounts_594051(
    name: "agreementsListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements",
    validator: validate_AgreementsListByIntegrationAccounts_594052, base: "",
    url: url_AgreementsListByIntegrationAccounts_594053, schemes: {Scheme.Https})
type
  Call_AgreementsCreateOrUpdate_594076 = ref object of OpenApiRestCall_593438
proc url_AgreementsCreateOrUpdate_594078(protocol: Scheme; host: string;
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

proc validate_AgreementsCreateOrUpdate_594077(path: JsonNode; query: JsonNode;
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
  var valid_594079 = path.getOrDefault("resourceGroupName")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "resourceGroupName", valid_594079
  var valid_594080 = path.getOrDefault("integrationAccountName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "integrationAccountName", valid_594080
  var valid_594081 = path.getOrDefault("subscriptionId")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "subscriptionId", valid_594081
  var valid_594082 = path.getOrDefault("agreementName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "agreementName", valid_594082
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594083 = query.getOrDefault("api-version")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "api-version", valid_594083
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

proc call*(call_594085: Call_AgreementsCreateOrUpdate_594076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account agreement.
  ## 
  let valid = call_594085.validator(path, query, header, formData, body)
  let scheme = call_594085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594085.url(scheme.get, call_594085.host, call_594085.base,
                         call_594085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594085, url, valid)

proc call*(call_594086: Call_AgreementsCreateOrUpdate_594076;
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
  var path_594087 = newJObject()
  var query_594088 = newJObject()
  var body_594089 = newJObject()
  add(path_594087, "resourceGroupName", newJString(resourceGroupName))
  add(query_594088, "api-version", newJString(apiVersion))
  add(path_594087, "integrationAccountName", newJString(integrationAccountName))
  add(path_594087, "subscriptionId", newJString(subscriptionId))
  add(path_594087, "agreementName", newJString(agreementName))
  if agreement != nil:
    body_594089 = agreement
  result = call_594086.call(path_594087, query_594088, nil, nil, body_594089)

var agreementsCreateOrUpdate* = Call_AgreementsCreateOrUpdate_594076(
    name: "agreementsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_AgreementsCreateOrUpdate_594077, base: "",
    url: url_AgreementsCreateOrUpdate_594078, schemes: {Scheme.Https})
type
  Call_AgreementsGet_594064 = ref object of OpenApiRestCall_593438
proc url_AgreementsGet_594066(protocol: Scheme; host: string; base: string;
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

proc validate_AgreementsGet_594065(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594067 = path.getOrDefault("resourceGroupName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "resourceGroupName", valid_594067
  var valid_594068 = path.getOrDefault("integrationAccountName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "integrationAccountName", valid_594068
  var valid_594069 = path.getOrDefault("subscriptionId")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "subscriptionId", valid_594069
  var valid_594070 = path.getOrDefault("agreementName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "agreementName", valid_594070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594071 = query.getOrDefault("api-version")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "api-version", valid_594071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594072: Call_AgreementsGet_594064; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account agreement.
  ## 
  let valid = call_594072.validator(path, query, header, formData, body)
  let scheme = call_594072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594072.url(scheme.get, call_594072.host, call_594072.base,
                         call_594072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594072, url, valid)

proc call*(call_594073: Call_AgreementsGet_594064; resourceGroupName: string;
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
  var path_594074 = newJObject()
  var query_594075 = newJObject()
  add(path_594074, "resourceGroupName", newJString(resourceGroupName))
  add(query_594075, "api-version", newJString(apiVersion))
  add(path_594074, "integrationAccountName", newJString(integrationAccountName))
  add(path_594074, "subscriptionId", newJString(subscriptionId))
  add(path_594074, "agreementName", newJString(agreementName))
  result = call_594073.call(path_594074, query_594075, nil, nil, nil)

var agreementsGet* = Call_AgreementsGet_594064(name: "agreementsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_AgreementsGet_594065, base: "", url: url_AgreementsGet_594066,
    schemes: {Scheme.Https})
type
  Call_AgreementsDelete_594090 = ref object of OpenApiRestCall_593438
proc url_AgreementsDelete_594092(protocol: Scheme; host: string; base: string;
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

proc validate_AgreementsDelete_594091(path: JsonNode; query: JsonNode;
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
  var valid_594093 = path.getOrDefault("resourceGroupName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "resourceGroupName", valid_594093
  var valid_594094 = path.getOrDefault("integrationAccountName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "integrationAccountName", valid_594094
  var valid_594095 = path.getOrDefault("subscriptionId")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "subscriptionId", valid_594095
  var valid_594096 = path.getOrDefault("agreementName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "agreementName", valid_594096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594097 = query.getOrDefault("api-version")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "api-version", valid_594097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594098: Call_AgreementsDelete_594090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account agreement.
  ## 
  let valid = call_594098.validator(path, query, header, formData, body)
  let scheme = call_594098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594098.url(scheme.get, call_594098.host, call_594098.base,
                         call_594098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594098, url, valid)

proc call*(call_594099: Call_AgreementsDelete_594090; resourceGroupName: string;
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
  var path_594100 = newJObject()
  var query_594101 = newJObject()
  add(path_594100, "resourceGroupName", newJString(resourceGroupName))
  add(query_594101, "api-version", newJString(apiVersion))
  add(path_594100, "integrationAccountName", newJString(integrationAccountName))
  add(path_594100, "subscriptionId", newJString(subscriptionId))
  add(path_594100, "agreementName", newJString(agreementName))
  result = call_594099.call(path_594100, query_594101, nil, nil, nil)

var agreementsDelete* = Call_AgreementsDelete_594090(name: "agreementsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_AgreementsDelete_594091, base: "",
    url: url_AgreementsDelete_594092, schemes: {Scheme.Https})
type
  Call_AgreementsListContentCallbackUrl_594102 = ref object of OpenApiRestCall_593438
proc url_AgreementsListContentCallbackUrl_594104(protocol: Scheme; host: string;
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

proc validate_AgreementsListContentCallbackUrl_594103(path: JsonNode;
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
  var valid_594105 = path.getOrDefault("resourceGroupName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "resourceGroupName", valid_594105
  var valid_594106 = path.getOrDefault("integrationAccountName")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "integrationAccountName", valid_594106
  var valid_594107 = path.getOrDefault("subscriptionId")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "subscriptionId", valid_594107
  var valid_594108 = path.getOrDefault("agreementName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "agreementName", valid_594108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594109 = query.getOrDefault("api-version")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "api-version", valid_594109
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

proc call*(call_594111: Call_AgreementsListContentCallbackUrl_594102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_594111.validator(path, query, header, formData, body)
  let scheme = call_594111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594111.url(scheme.get, call_594111.host, call_594111.base,
                         call_594111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594111, url, valid)

proc call*(call_594112: Call_AgreementsListContentCallbackUrl_594102;
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
  var path_594113 = newJObject()
  var query_594114 = newJObject()
  var body_594115 = newJObject()
  add(path_594113, "resourceGroupName", newJString(resourceGroupName))
  add(query_594114, "api-version", newJString(apiVersion))
  add(path_594113, "integrationAccountName", newJString(integrationAccountName))
  add(path_594113, "subscriptionId", newJString(subscriptionId))
  add(path_594113, "agreementName", newJString(agreementName))
  if listContentCallbackUrl != nil:
    body_594115 = listContentCallbackUrl
  result = call_594112.call(path_594113, query_594114, nil, nil, body_594115)

var agreementsListContentCallbackUrl* = Call_AgreementsListContentCallbackUrl_594102(
    name: "agreementsListContentCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}/listContentCallbackUrl",
    validator: validate_AgreementsListContentCallbackUrl_594103, base: "",
    url: url_AgreementsListContentCallbackUrl_594104, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesList_594116 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountAssembliesList_594118(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAssembliesList_594117(path: JsonNode;
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
  var valid_594119 = path.getOrDefault("resourceGroupName")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "resourceGroupName", valid_594119
  var valid_594120 = path.getOrDefault("integrationAccountName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "integrationAccountName", valid_594120
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
  if body != nil:
    result.add "body", body

proc call*(call_594123: Call_IntegrationAccountAssembliesList_594116;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the assemblies for an integration account.
  ## 
  let valid = call_594123.validator(path, query, header, formData, body)
  let scheme = call_594123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594123.url(scheme.get, call_594123.host, call_594123.base,
                         call_594123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594123, url, valid)

proc call*(call_594124: Call_IntegrationAccountAssembliesList_594116;
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
  var path_594125 = newJObject()
  var query_594126 = newJObject()
  add(path_594125, "resourceGroupName", newJString(resourceGroupName))
  add(query_594126, "api-version", newJString(apiVersion))
  add(path_594125, "integrationAccountName", newJString(integrationAccountName))
  add(path_594125, "subscriptionId", newJString(subscriptionId))
  result = call_594124.call(path_594125, query_594126, nil, nil, nil)

var integrationAccountAssembliesList* = Call_IntegrationAccountAssembliesList_594116(
    name: "integrationAccountAssembliesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies",
    validator: validate_IntegrationAccountAssembliesList_594117, base: "",
    url: url_IntegrationAccountAssembliesList_594118, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesCreateOrUpdate_594139 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountAssembliesCreateOrUpdate_594141(protocol: Scheme;
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

proc validate_IntegrationAccountAssembliesCreateOrUpdate_594140(path: JsonNode;
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
  var valid_594142 = path.getOrDefault("resourceGroupName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "resourceGroupName", valid_594142
  var valid_594143 = path.getOrDefault("integrationAccountName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "integrationAccountName", valid_594143
  var valid_594144 = path.getOrDefault("subscriptionId")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "subscriptionId", valid_594144
  var valid_594145 = path.getOrDefault("assemblyArtifactName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "assemblyArtifactName", valid_594145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594146 = query.getOrDefault("api-version")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "api-version", valid_594146
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

proc call*(call_594148: Call_IntegrationAccountAssembliesCreateOrUpdate_594139;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an assembly for an integration account.
  ## 
  let valid = call_594148.validator(path, query, header, formData, body)
  let scheme = call_594148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594148.url(scheme.get, call_594148.host, call_594148.base,
                         call_594148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594148, url, valid)

proc call*(call_594149: Call_IntegrationAccountAssembliesCreateOrUpdate_594139;
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
  var path_594150 = newJObject()
  var query_594151 = newJObject()
  var body_594152 = newJObject()
  add(path_594150, "resourceGroupName", newJString(resourceGroupName))
  add(query_594151, "api-version", newJString(apiVersion))
  add(path_594150, "integrationAccountName", newJString(integrationAccountName))
  add(path_594150, "subscriptionId", newJString(subscriptionId))
  if assemblyArtifact != nil:
    body_594152 = assemblyArtifact
  add(path_594150, "assemblyArtifactName", newJString(assemblyArtifactName))
  result = call_594149.call(path_594150, query_594151, nil, nil, body_594152)

var integrationAccountAssembliesCreateOrUpdate* = Call_IntegrationAccountAssembliesCreateOrUpdate_594139(
    name: "integrationAccountAssembliesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}",
    validator: validate_IntegrationAccountAssembliesCreateOrUpdate_594140,
    base: "", url: url_IntegrationAccountAssembliesCreateOrUpdate_594141,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesGet_594127 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountAssembliesGet_594129(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAssembliesGet_594128(path: JsonNode;
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
  var valid_594130 = path.getOrDefault("resourceGroupName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "resourceGroupName", valid_594130
  var valid_594131 = path.getOrDefault("integrationAccountName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "integrationAccountName", valid_594131
  var valid_594132 = path.getOrDefault("subscriptionId")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "subscriptionId", valid_594132
  var valid_594133 = path.getOrDefault("assemblyArtifactName")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "assemblyArtifactName", valid_594133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594134 = query.getOrDefault("api-version")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "api-version", valid_594134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594135: Call_IntegrationAccountAssembliesGet_594127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an assembly for an integration account.
  ## 
  let valid = call_594135.validator(path, query, header, formData, body)
  let scheme = call_594135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594135.url(scheme.get, call_594135.host, call_594135.base,
                         call_594135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594135, url, valid)

proc call*(call_594136: Call_IntegrationAccountAssembliesGet_594127;
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
  var path_594137 = newJObject()
  var query_594138 = newJObject()
  add(path_594137, "resourceGroupName", newJString(resourceGroupName))
  add(query_594138, "api-version", newJString(apiVersion))
  add(path_594137, "integrationAccountName", newJString(integrationAccountName))
  add(path_594137, "subscriptionId", newJString(subscriptionId))
  add(path_594137, "assemblyArtifactName", newJString(assemblyArtifactName))
  result = call_594136.call(path_594137, query_594138, nil, nil, nil)

var integrationAccountAssembliesGet* = Call_IntegrationAccountAssembliesGet_594127(
    name: "integrationAccountAssembliesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}",
    validator: validate_IntegrationAccountAssembliesGet_594128, base: "",
    url: url_IntegrationAccountAssembliesGet_594129, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesDelete_594153 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountAssembliesDelete_594155(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountAssembliesDelete_594154(path: JsonNode;
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
  var valid_594156 = path.getOrDefault("resourceGroupName")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "resourceGroupName", valid_594156
  var valid_594157 = path.getOrDefault("integrationAccountName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "integrationAccountName", valid_594157
  var valid_594158 = path.getOrDefault("subscriptionId")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "subscriptionId", valid_594158
  var valid_594159 = path.getOrDefault("assemblyArtifactName")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "assemblyArtifactName", valid_594159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594160 = query.getOrDefault("api-version")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "api-version", valid_594160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594161: Call_IntegrationAccountAssembliesDelete_594153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an assembly for an integration account.
  ## 
  let valid = call_594161.validator(path, query, header, formData, body)
  let scheme = call_594161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594161.url(scheme.get, call_594161.host, call_594161.base,
                         call_594161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594161, url, valid)

proc call*(call_594162: Call_IntegrationAccountAssembliesDelete_594153;
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
  var path_594163 = newJObject()
  var query_594164 = newJObject()
  add(path_594163, "resourceGroupName", newJString(resourceGroupName))
  add(query_594164, "api-version", newJString(apiVersion))
  add(path_594163, "integrationAccountName", newJString(integrationAccountName))
  add(path_594163, "subscriptionId", newJString(subscriptionId))
  add(path_594163, "assemblyArtifactName", newJString(assemblyArtifactName))
  result = call_594162.call(path_594163, query_594164, nil, nil, nil)

var integrationAccountAssembliesDelete* = Call_IntegrationAccountAssembliesDelete_594153(
    name: "integrationAccountAssembliesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}",
    validator: validate_IntegrationAccountAssembliesDelete_594154, base: "",
    url: url_IntegrationAccountAssembliesDelete_594155, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAssembliesListContentCallbackUrl_594165 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountAssembliesListContentCallbackUrl_594167(
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

proc validate_IntegrationAccountAssembliesListContentCallbackUrl_594166(
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
  var valid_594168 = path.getOrDefault("resourceGroupName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "resourceGroupName", valid_594168
  var valid_594169 = path.getOrDefault("integrationAccountName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "integrationAccountName", valid_594169
  var valid_594170 = path.getOrDefault("subscriptionId")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "subscriptionId", valid_594170
  var valid_594171 = path.getOrDefault("assemblyArtifactName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "assemblyArtifactName", valid_594171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594172 = query.getOrDefault("api-version")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "api-version", valid_594172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594173: Call_IntegrationAccountAssembliesListContentCallbackUrl_594165;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the content callback url for an integration account assembly.
  ## 
  let valid = call_594173.validator(path, query, header, formData, body)
  let scheme = call_594173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594173.url(scheme.get, call_594173.host, call_594173.base,
                         call_594173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594173, url, valid)

proc call*(call_594174: Call_IntegrationAccountAssembliesListContentCallbackUrl_594165;
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
  var path_594175 = newJObject()
  var query_594176 = newJObject()
  add(path_594175, "resourceGroupName", newJString(resourceGroupName))
  add(query_594176, "api-version", newJString(apiVersion))
  add(path_594175, "integrationAccountName", newJString(integrationAccountName))
  add(path_594175, "subscriptionId", newJString(subscriptionId))
  add(path_594175, "assemblyArtifactName", newJString(assemblyArtifactName))
  result = call_594174.call(path_594175, query_594176, nil, nil, nil)

var integrationAccountAssembliesListContentCallbackUrl* = Call_IntegrationAccountAssembliesListContentCallbackUrl_594165(
    name: "integrationAccountAssembliesListContentCallbackUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/assemblies/{assemblyArtifactName}/listContentCallbackUrl",
    validator: validate_IntegrationAccountAssembliesListContentCallbackUrl_594166,
    base: "", url: url_IntegrationAccountAssembliesListContentCallbackUrl_594167,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsList_594177 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountBatchConfigurationsList_594179(protocol: Scheme;
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

proc validate_IntegrationAccountBatchConfigurationsList_594178(path: JsonNode;
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
  var valid_594180 = path.getOrDefault("resourceGroupName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "resourceGroupName", valid_594180
  var valid_594181 = path.getOrDefault("integrationAccountName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "integrationAccountName", valid_594181
  var valid_594182 = path.getOrDefault("subscriptionId")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "subscriptionId", valid_594182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594183 = query.getOrDefault("api-version")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "api-version", valid_594183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594184: Call_IntegrationAccountBatchConfigurationsList_594177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the batch configurations for an integration account.
  ## 
  let valid = call_594184.validator(path, query, header, formData, body)
  let scheme = call_594184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594184.url(scheme.get, call_594184.host, call_594184.base,
                         call_594184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594184, url, valid)

proc call*(call_594185: Call_IntegrationAccountBatchConfigurationsList_594177;
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
  var path_594186 = newJObject()
  var query_594187 = newJObject()
  add(path_594186, "resourceGroupName", newJString(resourceGroupName))
  add(query_594187, "api-version", newJString(apiVersion))
  add(path_594186, "integrationAccountName", newJString(integrationAccountName))
  add(path_594186, "subscriptionId", newJString(subscriptionId))
  result = call_594185.call(path_594186, query_594187, nil, nil, nil)

var integrationAccountBatchConfigurationsList* = Call_IntegrationAccountBatchConfigurationsList_594177(
    name: "integrationAccountBatchConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations",
    validator: validate_IntegrationAccountBatchConfigurationsList_594178,
    base: "", url: url_IntegrationAccountBatchConfigurationsList_594179,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_594200 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountBatchConfigurationsCreateOrUpdate_594202(
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

proc validate_IntegrationAccountBatchConfigurationsCreateOrUpdate_594201(
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
  var valid_594203 = path.getOrDefault("resourceGroupName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "resourceGroupName", valid_594203
  var valid_594204 = path.getOrDefault("integrationAccountName")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "integrationAccountName", valid_594204
  var valid_594205 = path.getOrDefault("subscriptionId")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "subscriptionId", valid_594205
  var valid_594206 = path.getOrDefault("batchConfigurationName")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "batchConfigurationName", valid_594206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594207 = query.getOrDefault("api-version")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "api-version", valid_594207
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

proc call*(call_594209: Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_594200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a batch configuration for an integration account.
  ## 
  let valid = call_594209.validator(path, query, header, formData, body)
  let scheme = call_594209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594209.url(scheme.get, call_594209.host, call_594209.base,
                         call_594209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594209, url, valid)

proc call*(call_594210: Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_594200;
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
  var path_594211 = newJObject()
  var query_594212 = newJObject()
  var body_594213 = newJObject()
  add(path_594211, "resourceGroupName", newJString(resourceGroupName))
  add(query_594212, "api-version", newJString(apiVersion))
  add(path_594211, "integrationAccountName", newJString(integrationAccountName))
  add(path_594211, "subscriptionId", newJString(subscriptionId))
  add(path_594211, "batchConfigurationName", newJString(batchConfigurationName))
  if batchConfiguration != nil:
    body_594213 = batchConfiguration
  result = call_594210.call(path_594211, query_594212, nil, nil, body_594213)

var integrationAccountBatchConfigurationsCreateOrUpdate* = Call_IntegrationAccountBatchConfigurationsCreateOrUpdate_594200(
    name: "integrationAccountBatchConfigurationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations/{batchConfigurationName}",
    validator: validate_IntegrationAccountBatchConfigurationsCreateOrUpdate_594201,
    base: "", url: url_IntegrationAccountBatchConfigurationsCreateOrUpdate_594202,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsGet_594188 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountBatchConfigurationsGet_594190(protocol: Scheme;
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

proc validate_IntegrationAccountBatchConfigurationsGet_594189(path: JsonNode;
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
  var valid_594191 = path.getOrDefault("resourceGroupName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "resourceGroupName", valid_594191
  var valid_594192 = path.getOrDefault("integrationAccountName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "integrationAccountName", valid_594192
  var valid_594193 = path.getOrDefault("subscriptionId")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "subscriptionId", valid_594193
  var valid_594194 = path.getOrDefault("batchConfigurationName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "batchConfigurationName", valid_594194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594195 = query.getOrDefault("api-version")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "api-version", valid_594195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594196: Call_IntegrationAccountBatchConfigurationsGet_594188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a batch configuration for an integration account.
  ## 
  let valid = call_594196.validator(path, query, header, formData, body)
  let scheme = call_594196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594196.url(scheme.get, call_594196.host, call_594196.base,
                         call_594196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594196, url, valid)

proc call*(call_594197: Call_IntegrationAccountBatchConfigurationsGet_594188;
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
  var path_594198 = newJObject()
  var query_594199 = newJObject()
  add(path_594198, "resourceGroupName", newJString(resourceGroupName))
  add(query_594199, "api-version", newJString(apiVersion))
  add(path_594198, "integrationAccountName", newJString(integrationAccountName))
  add(path_594198, "subscriptionId", newJString(subscriptionId))
  add(path_594198, "batchConfigurationName", newJString(batchConfigurationName))
  result = call_594197.call(path_594198, query_594199, nil, nil, nil)

var integrationAccountBatchConfigurationsGet* = Call_IntegrationAccountBatchConfigurationsGet_594188(
    name: "integrationAccountBatchConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations/{batchConfigurationName}",
    validator: validate_IntegrationAccountBatchConfigurationsGet_594189, base: "",
    url: url_IntegrationAccountBatchConfigurationsGet_594190,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountBatchConfigurationsDelete_594214 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountBatchConfigurationsDelete_594216(protocol: Scheme;
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

proc validate_IntegrationAccountBatchConfigurationsDelete_594215(path: JsonNode;
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
  var valid_594217 = path.getOrDefault("resourceGroupName")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "resourceGroupName", valid_594217
  var valid_594218 = path.getOrDefault("integrationAccountName")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "integrationAccountName", valid_594218
  var valid_594219 = path.getOrDefault("subscriptionId")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "subscriptionId", valid_594219
  var valid_594220 = path.getOrDefault("batchConfigurationName")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "batchConfigurationName", valid_594220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594221 = query.getOrDefault("api-version")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "api-version", valid_594221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594222: Call_IntegrationAccountBatchConfigurationsDelete_594214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a batch configuration for an integration account.
  ## 
  let valid = call_594222.validator(path, query, header, formData, body)
  let scheme = call_594222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594222.url(scheme.get, call_594222.host, call_594222.base,
                         call_594222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594222, url, valid)

proc call*(call_594223: Call_IntegrationAccountBatchConfigurationsDelete_594214;
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
  var path_594224 = newJObject()
  var query_594225 = newJObject()
  add(path_594224, "resourceGroupName", newJString(resourceGroupName))
  add(query_594225, "api-version", newJString(apiVersion))
  add(path_594224, "integrationAccountName", newJString(integrationAccountName))
  add(path_594224, "subscriptionId", newJString(subscriptionId))
  add(path_594224, "batchConfigurationName", newJString(batchConfigurationName))
  result = call_594223.call(path_594224, query_594225, nil, nil, nil)

var integrationAccountBatchConfigurationsDelete* = Call_IntegrationAccountBatchConfigurationsDelete_594214(
    name: "integrationAccountBatchConfigurationsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/batchConfigurations/{batchConfigurationName}",
    validator: validate_IntegrationAccountBatchConfigurationsDelete_594215,
    base: "", url: url_IntegrationAccountBatchConfigurationsDelete_594216,
    schemes: {Scheme.Https})
type
  Call_CertificatesListByIntegrationAccounts_594226 = ref object of OpenApiRestCall_593438
proc url_CertificatesListByIntegrationAccounts_594228(protocol: Scheme;
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

proc validate_CertificatesListByIntegrationAccounts_594227(path: JsonNode;
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
  var valid_594229 = path.getOrDefault("resourceGroupName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "resourceGroupName", valid_594229
  var valid_594230 = path.getOrDefault("integrationAccountName")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "integrationAccountName", valid_594230
  var valid_594231 = path.getOrDefault("subscriptionId")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "subscriptionId", valid_594231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594232 = query.getOrDefault("api-version")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "api-version", valid_594232
  var valid_594233 = query.getOrDefault("$top")
  valid_594233 = validateParameter(valid_594233, JInt, required = false, default = nil)
  if valid_594233 != nil:
    section.add "$top", valid_594233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594234: Call_CertificatesListByIntegrationAccounts_594226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account certificates.
  ## 
  let valid = call_594234.validator(path, query, header, formData, body)
  let scheme = call_594234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594234.url(scheme.get, call_594234.host, call_594234.base,
                         call_594234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594234, url, valid)

proc call*(call_594235: Call_CertificatesListByIntegrationAccounts_594226;
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
  var path_594236 = newJObject()
  var query_594237 = newJObject()
  add(path_594236, "resourceGroupName", newJString(resourceGroupName))
  add(query_594237, "api-version", newJString(apiVersion))
  add(path_594236, "integrationAccountName", newJString(integrationAccountName))
  add(path_594236, "subscriptionId", newJString(subscriptionId))
  add(query_594237, "$top", newJInt(Top))
  result = call_594235.call(path_594236, query_594237, nil, nil, nil)

var certificatesListByIntegrationAccounts* = Call_CertificatesListByIntegrationAccounts_594226(
    name: "certificatesListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates",
    validator: validate_CertificatesListByIntegrationAccounts_594227, base: "",
    url: url_CertificatesListByIntegrationAccounts_594228, schemes: {Scheme.Https})
type
  Call_CertificatesCreateOrUpdate_594250 = ref object of OpenApiRestCall_593438
proc url_CertificatesCreateOrUpdate_594252(protocol: Scheme; host: string;
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

proc validate_CertificatesCreateOrUpdate_594251(path: JsonNode; query: JsonNode;
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
  var valid_594253 = path.getOrDefault("resourceGroupName")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "resourceGroupName", valid_594253
  var valid_594254 = path.getOrDefault("integrationAccountName")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "integrationAccountName", valid_594254
  var valid_594255 = path.getOrDefault("subscriptionId")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "subscriptionId", valid_594255
  var valid_594256 = path.getOrDefault("certificateName")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "certificateName", valid_594256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594257 = query.getOrDefault("api-version")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "api-version", valid_594257
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

proc call*(call_594259: Call_CertificatesCreateOrUpdate_594250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account certificate.
  ## 
  let valid = call_594259.validator(path, query, header, formData, body)
  let scheme = call_594259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594259.url(scheme.get, call_594259.host, call_594259.base,
                         call_594259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594259, url, valid)

proc call*(call_594260: Call_CertificatesCreateOrUpdate_594250;
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
  var path_594261 = newJObject()
  var query_594262 = newJObject()
  var body_594263 = newJObject()
  add(path_594261, "resourceGroupName", newJString(resourceGroupName))
  add(query_594262, "api-version", newJString(apiVersion))
  add(path_594261, "integrationAccountName", newJString(integrationAccountName))
  add(path_594261, "subscriptionId", newJString(subscriptionId))
  if certificate != nil:
    body_594263 = certificate
  add(path_594261, "certificateName", newJString(certificateName))
  result = call_594260.call(path_594261, query_594262, nil, nil, body_594263)

var certificatesCreateOrUpdate* = Call_CertificatesCreateOrUpdate_594250(
    name: "certificatesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_CertificatesCreateOrUpdate_594251, base: "",
    url: url_CertificatesCreateOrUpdate_594252, schemes: {Scheme.Https})
type
  Call_CertificatesGet_594238 = ref object of OpenApiRestCall_593438
proc url_CertificatesGet_594240(protocol: Scheme; host: string; base: string;
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

proc validate_CertificatesGet_594239(path: JsonNode; query: JsonNode;
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
  var valid_594241 = path.getOrDefault("resourceGroupName")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "resourceGroupName", valid_594241
  var valid_594242 = path.getOrDefault("integrationAccountName")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "integrationAccountName", valid_594242
  var valid_594243 = path.getOrDefault("subscriptionId")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "subscriptionId", valid_594243
  var valid_594244 = path.getOrDefault("certificateName")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "certificateName", valid_594244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594245 = query.getOrDefault("api-version")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "api-version", valid_594245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594246: Call_CertificatesGet_594238; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account certificate.
  ## 
  let valid = call_594246.validator(path, query, header, formData, body)
  let scheme = call_594246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594246.url(scheme.get, call_594246.host, call_594246.base,
                         call_594246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594246, url, valid)

proc call*(call_594247: Call_CertificatesGet_594238; resourceGroupName: string;
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
  var path_594248 = newJObject()
  var query_594249 = newJObject()
  add(path_594248, "resourceGroupName", newJString(resourceGroupName))
  add(query_594249, "api-version", newJString(apiVersion))
  add(path_594248, "integrationAccountName", newJString(integrationAccountName))
  add(path_594248, "subscriptionId", newJString(subscriptionId))
  add(path_594248, "certificateName", newJString(certificateName))
  result = call_594247.call(path_594248, query_594249, nil, nil, nil)

var certificatesGet* = Call_CertificatesGet_594238(name: "certificatesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_CertificatesGet_594239, base: "", url: url_CertificatesGet_594240,
    schemes: {Scheme.Https})
type
  Call_CertificatesDelete_594264 = ref object of OpenApiRestCall_593438
proc url_CertificatesDelete_594266(protocol: Scheme; host: string; base: string;
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

proc validate_CertificatesDelete_594265(path: JsonNode; query: JsonNode;
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
  var valid_594267 = path.getOrDefault("resourceGroupName")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "resourceGroupName", valid_594267
  var valid_594268 = path.getOrDefault("integrationAccountName")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "integrationAccountName", valid_594268
  var valid_594269 = path.getOrDefault("subscriptionId")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "subscriptionId", valid_594269
  var valid_594270 = path.getOrDefault("certificateName")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "certificateName", valid_594270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594271 = query.getOrDefault("api-version")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "api-version", valid_594271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594272: Call_CertificatesDelete_594264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account certificate.
  ## 
  let valid = call_594272.validator(path, query, header, formData, body)
  let scheme = call_594272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594272.url(scheme.get, call_594272.host, call_594272.base,
                         call_594272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594272, url, valid)

proc call*(call_594273: Call_CertificatesDelete_594264; resourceGroupName: string;
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
  var path_594274 = newJObject()
  var query_594275 = newJObject()
  add(path_594274, "resourceGroupName", newJString(resourceGroupName))
  add(query_594275, "api-version", newJString(apiVersion))
  add(path_594274, "integrationAccountName", newJString(integrationAccountName))
  add(path_594274, "subscriptionId", newJString(subscriptionId))
  add(path_594274, "certificateName", newJString(certificateName))
  result = call_594273.call(path_594274, query_594275, nil, nil, nil)

var certificatesDelete* = Call_CertificatesDelete_594264(
    name: "certificatesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_CertificatesDelete_594265, base: "",
    url: url_CertificatesDelete_594266, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsGetCallbackUrl_594276 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountsGetCallbackUrl_594278(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsGetCallbackUrl_594277(path: JsonNode;
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
  var valid_594279 = path.getOrDefault("resourceGroupName")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "resourceGroupName", valid_594279
  var valid_594280 = path.getOrDefault("integrationAccountName")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "integrationAccountName", valid_594280
  var valid_594281 = path.getOrDefault("subscriptionId")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "subscriptionId", valid_594281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594282 = query.getOrDefault("api-version")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "api-version", valid_594282
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

proc call*(call_594284: Call_IntegrationAccountsGetCallbackUrl_594276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the integration account callback URL.
  ## 
  let valid = call_594284.validator(path, query, header, formData, body)
  let scheme = call_594284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594284.url(scheme.get, call_594284.host, call_594284.base,
                         call_594284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594284, url, valid)

proc call*(call_594285: Call_IntegrationAccountsGetCallbackUrl_594276;
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
  var path_594286 = newJObject()
  var query_594287 = newJObject()
  var body_594288 = newJObject()
  add(path_594286, "resourceGroupName", newJString(resourceGroupName))
  add(query_594287, "api-version", newJString(apiVersion))
  add(path_594286, "integrationAccountName", newJString(integrationAccountName))
  add(path_594286, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594288 = parameters
  result = call_594285.call(path_594286, query_594287, nil, nil, body_594288)

var integrationAccountsGetCallbackUrl* = Call_IntegrationAccountsGetCallbackUrl_594276(
    name: "integrationAccountsGetCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/listCallbackUrl",
    validator: validate_IntegrationAccountsGetCallbackUrl_594277, base: "",
    url: url_IntegrationAccountsGetCallbackUrl_594278, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListKeyVaultKeys_594289 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountsListKeyVaultKeys_594291(protocol: Scheme; host: string;
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

proc validate_IntegrationAccountsListKeyVaultKeys_594290(path: JsonNode;
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
  var valid_594292 = path.getOrDefault("resourceGroupName")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "resourceGroupName", valid_594292
  var valid_594293 = path.getOrDefault("integrationAccountName")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "integrationAccountName", valid_594293
  var valid_594294 = path.getOrDefault("subscriptionId")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "subscriptionId", valid_594294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594295 = query.getOrDefault("api-version")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "api-version", valid_594295
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

proc call*(call_594297: Call_IntegrationAccountsListKeyVaultKeys_594289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the integration account's Key Vault keys.
  ## 
  let valid = call_594297.validator(path, query, header, formData, body)
  let scheme = call_594297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594297.url(scheme.get, call_594297.host, call_594297.base,
                         call_594297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594297, url, valid)

proc call*(call_594298: Call_IntegrationAccountsListKeyVaultKeys_594289;
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
  var path_594299 = newJObject()
  var query_594300 = newJObject()
  var body_594301 = newJObject()
  add(path_594299, "resourceGroupName", newJString(resourceGroupName))
  add(query_594300, "api-version", newJString(apiVersion))
  add(path_594299, "integrationAccountName", newJString(integrationAccountName))
  add(path_594299, "subscriptionId", newJString(subscriptionId))
  if listKeyVaultKeys != nil:
    body_594301 = listKeyVaultKeys
  result = call_594298.call(path_594299, query_594300, nil, nil, body_594301)

var integrationAccountsListKeyVaultKeys* = Call_IntegrationAccountsListKeyVaultKeys_594289(
    name: "integrationAccountsListKeyVaultKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/listKeyVaultKeys",
    validator: validate_IntegrationAccountsListKeyVaultKeys_594290, base: "",
    url: url_IntegrationAccountsListKeyVaultKeys_594291, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsLogTrackingEvents_594302 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountsLogTrackingEvents_594304(protocol: Scheme;
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

proc validate_IntegrationAccountsLogTrackingEvents_594303(path: JsonNode;
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
  var valid_594305 = path.getOrDefault("resourceGroupName")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "resourceGroupName", valid_594305
  var valid_594306 = path.getOrDefault("integrationAccountName")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "integrationAccountName", valid_594306
  var valid_594307 = path.getOrDefault("subscriptionId")
  valid_594307 = validateParameter(valid_594307, JString, required = true,
                                 default = nil)
  if valid_594307 != nil:
    section.add "subscriptionId", valid_594307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594308 = query.getOrDefault("api-version")
  valid_594308 = validateParameter(valid_594308, JString, required = true,
                                 default = nil)
  if valid_594308 != nil:
    section.add "api-version", valid_594308
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

proc call*(call_594310: Call_IntegrationAccountsLogTrackingEvents_594302;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Logs the integration account's tracking events.
  ## 
  let valid = call_594310.validator(path, query, header, formData, body)
  let scheme = call_594310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594310.url(scheme.get, call_594310.host, call_594310.base,
                         call_594310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594310, url, valid)

proc call*(call_594311: Call_IntegrationAccountsLogTrackingEvents_594302;
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
  var path_594312 = newJObject()
  var query_594313 = newJObject()
  var body_594314 = newJObject()
  add(path_594312, "resourceGroupName", newJString(resourceGroupName))
  add(query_594313, "api-version", newJString(apiVersion))
  add(path_594312, "integrationAccountName", newJString(integrationAccountName))
  add(path_594312, "subscriptionId", newJString(subscriptionId))
  if logTrackingEvents != nil:
    body_594314 = logTrackingEvents
  result = call_594311.call(path_594312, query_594313, nil, nil, body_594314)

var integrationAccountsLogTrackingEvents* = Call_IntegrationAccountsLogTrackingEvents_594302(
    name: "integrationAccountsLogTrackingEvents", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/logTrackingEvents",
    validator: validate_IntegrationAccountsLogTrackingEvents_594303, base: "",
    url: url_IntegrationAccountsLogTrackingEvents_594304, schemes: {Scheme.Https})
type
  Call_MapsListByIntegrationAccounts_594315 = ref object of OpenApiRestCall_593438
proc url_MapsListByIntegrationAccounts_594317(protocol: Scheme; host: string;
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

proc validate_MapsListByIntegrationAccounts_594316(path: JsonNode; query: JsonNode;
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
  var valid_594318 = path.getOrDefault("resourceGroupName")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "resourceGroupName", valid_594318
  var valid_594319 = path.getOrDefault("integrationAccountName")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "integrationAccountName", valid_594319
  var valid_594320 = path.getOrDefault("subscriptionId")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "subscriptionId", valid_594320
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
  var valid_594321 = query.getOrDefault("api-version")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "api-version", valid_594321
  var valid_594322 = query.getOrDefault("$top")
  valid_594322 = validateParameter(valid_594322, JInt, required = false, default = nil)
  if valid_594322 != nil:
    section.add "$top", valid_594322
  var valid_594323 = query.getOrDefault("$filter")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "$filter", valid_594323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594324: Call_MapsListByIntegrationAccounts_594315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account maps.
  ## 
  let valid = call_594324.validator(path, query, header, formData, body)
  let scheme = call_594324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594324.url(scheme.get, call_594324.host, call_594324.base,
                         call_594324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594324, url, valid)

proc call*(call_594325: Call_MapsListByIntegrationAccounts_594315;
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
  var path_594326 = newJObject()
  var query_594327 = newJObject()
  add(path_594326, "resourceGroupName", newJString(resourceGroupName))
  add(query_594327, "api-version", newJString(apiVersion))
  add(path_594326, "integrationAccountName", newJString(integrationAccountName))
  add(path_594326, "subscriptionId", newJString(subscriptionId))
  add(query_594327, "$top", newJInt(Top))
  add(query_594327, "$filter", newJString(Filter))
  result = call_594325.call(path_594326, query_594327, nil, nil, nil)

var mapsListByIntegrationAccounts* = Call_MapsListByIntegrationAccounts_594315(
    name: "mapsListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps",
    validator: validate_MapsListByIntegrationAccounts_594316, base: "",
    url: url_MapsListByIntegrationAccounts_594317, schemes: {Scheme.Https})
type
  Call_MapsCreateOrUpdate_594340 = ref object of OpenApiRestCall_593438
proc url_MapsCreateOrUpdate_594342(protocol: Scheme; host: string; base: string;
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

proc validate_MapsCreateOrUpdate_594341(path: JsonNode; query: JsonNode;
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
  var valid_594343 = path.getOrDefault("resourceGroupName")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "resourceGroupName", valid_594343
  var valid_594344 = path.getOrDefault("mapName")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "mapName", valid_594344
  var valid_594345 = path.getOrDefault("integrationAccountName")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "integrationAccountName", valid_594345
  var valid_594346 = path.getOrDefault("subscriptionId")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = nil)
  if valid_594346 != nil:
    section.add "subscriptionId", valid_594346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594347 = query.getOrDefault("api-version")
  valid_594347 = validateParameter(valid_594347, JString, required = true,
                                 default = nil)
  if valid_594347 != nil:
    section.add "api-version", valid_594347
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

proc call*(call_594349: Call_MapsCreateOrUpdate_594340; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account map.
  ## 
  let valid = call_594349.validator(path, query, header, formData, body)
  let scheme = call_594349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594349.url(scheme.get, call_594349.host, call_594349.base,
                         call_594349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594349, url, valid)

proc call*(call_594350: Call_MapsCreateOrUpdate_594340; resourceGroupName: string;
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
  var path_594351 = newJObject()
  var query_594352 = newJObject()
  var body_594353 = newJObject()
  add(path_594351, "resourceGroupName", newJString(resourceGroupName))
  if map != nil:
    body_594353 = map
  add(path_594351, "mapName", newJString(mapName))
  add(query_594352, "api-version", newJString(apiVersion))
  add(path_594351, "integrationAccountName", newJString(integrationAccountName))
  add(path_594351, "subscriptionId", newJString(subscriptionId))
  result = call_594350.call(path_594351, query_594352, nil, nil, body_594353)

var mapsCreateOrUpdate* = Call_MapsCreateOrUpdate_594340(
    name: "mapsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_MapsCreateOrUpdate_594341, base: "",
    url: url_MapsCreateOrUpdate_594342, schemes: {Scheme.Https})
type
  Call_MapsGet_594328 = ref object of OpenApiRestCall_593438
proc url_MapsGet_594330(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_MapsGet_594329(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594331 = path.getOrDefault("resourceGroupName")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "resourceGroupName", valid_594331
  var valid_594332 = path.getOrDefault("mapName")
  valid_594332 = validateParameter(valid_594332, JString, required = true,
                                 default = nil)
  if valid_594332 != nil:
    section.add "mapName", valid_594332
  var valid_594333 = path.getOrDefault("integrationAccountName")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = nil)
  if valid_594333 != nil:
    section.add "integrationAccountName", valid_594333
  var valid_594334 = path.getOrDefault("subscriptionId")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "subscriptionId", valid_594334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594335 = query.getOrDefault("api-version")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = nil)
  if valid_594335 != nil:
    section.add "api-version", valid_594335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594336: Call_MapsGet_594328; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account map.
  ## 
  let valid = call_594336.validator(path, query, header, formData, body)
  let scheme = call_594336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594336.url(scheme.get, call_594336.host, call_594336.base,
                         call_594336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594336, url, valid)

proc call*(call_594337: Call_MapsGet_594328; resourceGroupName: string;
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
  var path_594338 = newJObject()
  var query_594339 = newJObject()
  add(path_594338, "resourceGroupName", newJString(resourceGroupName))
  add(path_594338, "mapName", newJString(mapName))
  add(query_594339, "api-version", newJString(apiVersion))
  add(path_594338, "integrationAccountName", newJString(integrationAccountName))
  add(path_594338, "subscriptionId", newJString(subscriptionId))
  result = call_594337.call(path_594338, query_594339, nil, nil, nil)

var mapsGet* = Call_MapsGet_594328(name: "mapsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
                                validator: validate_MapsGet_594329, base: "",
                                url: url_MapsGet_594330, schemes: {Scheme.Https})
type
  Call_MapsDelete_594354 = ref object of OpenApiRestCall_593438
proc url_MapsDelete_594356(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_MapsDelete_594355(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594357 = path.getOrDefault("resourceGroupName")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "resourceGroupName", valid_594357
  var valid_594358 = path.getOrDefault("mapName")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "mapName", valid_594358
  var valid_594359 = path.getOrDefault("integrationAccountName")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "integrationAccountName", valid_594359
  var valid_594360 = path.getOrDefault("subscriptionId")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "subscriptionId", valid_594360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594361 = query.getOrDefault("api-version")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "api-version", valid_594361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594362: Call_MapsDelete_594354; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account map.
  ## 
  let valid = call_594362.validator(path, query, header, formData, body)
  let scheme = call_594362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594362.url(scheme.get, call_594362.host, call_594362.base,
                         call_594362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594362, url, valid)

proc call*(call_594363: Call_MapsDelete_594354; resourceGroupName: string;
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
  var path_594364 = newJObject()
  var query_594365 = newJObject()
  add(path_594364, "resourceGroupName", newJString(resourceGroupName))
  add(path_594364, "mapName", newJString(mapName))
  add(query_594365, "api-version", newJString(apiVersion))
  add(path_594364, "integrationAccountName", newJString(integrationAccountName))
  add(path_594364, "subscriptionId", newJString(subscriptionId))
  result = call_594363.call(path_594364, query_594365, nil, nil, nil)

var mapsDelete* = Call_MapsDelete_594354(name: "mapsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
                                      validator: validate_MapsDelete_594355,
                                      base: "", url: url_MapsDelete_594356,
                                      schemes: {Scheme.Https})
type
  Call_MapsListContentCallbackUrl_594366 = ref object of OpenApiRestCall_593438
proc url_MapsListContentCallbackUrl_594368(protocol: Scheme; host: string;
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

proc validate_MapsListContentCallbackUrl_594367(path: JsonNode; query: JsonNode;
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
  var valid_594369 = path.getOrDefault("resourceGroupName")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = nil)
  if valid_594369 != nil:
    section.add "resourceGroupName", valid_594369
  var valid_594370 = path.getOrDefault("mapName")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "mapName", valid_594370
  var valid_594371 = path.getOrDefault("integrationAccountName")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "integrationAccountName", valid_594371
  var valid_594372 = path.getOrDefault("subscriptionId")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "subscriptionId", valid_594372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594373 = query.getOrDefault("api-version")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "api-version", valid_594373
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

proc call*(call_594375: Call_MapsListContentCallbackUrl_594366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_594375.validator(path, query, header, formData, body)
  let scheme = call_594375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594375.url(scheme.get, call_594375.host, call_594375.base,
                         call_594375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594375, url, valid)

proc call*(call_594376: Call_MapsListContentCallbackUrl_594366;
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
  var path_594377 = newJObject()
  var query_594378 = newJObject()
  var body_594379 = newJObject()
  add(path_594377, "resourceGroupName", newJString(resourceGroupName))
  add(path_594377, "mapName", newJString(mapName))
  add(query_594378, "api-version", newJString(apiVersion))
  add(path_594377, "integrationAccountName", newJString(integrationAccountName))
  add(path_594377, "subscriptionId", newJString(subscriptionId))
  if listContentCallbackUrl != nil:
    body_594379 = listContentCallbackUrl
  result = call_594376.call(path_594377, query_594378, nil, nil, body_594379)

var mapsListContentCallbackUrl* = Call_MapsListContentCallbackUrl_594366(
    name: "mapsListContentCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}/listContentCallbackUrl",
    validator: validate_MapsListContentCallbackUrl_594367, base: "",
    url: url_MapsListContentCallbackUrl_594368, schemes: {Scheme.Https})
type
  Call_PartnersListByIntegrationAccounts_594380 = ref object of OpenApiRestCall_593438
proc url_PartnersListByIntegrationAccounts_594382(protocol: Scheme; host: string;
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

proc validate_PartnersListByIntegrationAccounts_594381(path: JsonNode;
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
  var valid_594383 = path.getOrDefault("resourceGroupName")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "resourceGroupName", valid_594383
  var valid_594384 = path.getOrDefault("integrationAccountName")
  valid_594384 = validateParameter(valid_594384, JString, required = true,
                                 default = nil)
  if valid_594384 != nil:
    section.add "integrationAccountName", valid_594384
  var valid_594385 = path.getOrDefault("subscriptionId")
  valid_594385 = validateParameter(valid_594385, JString, required = true,
                                 default = nil)
  if valid_594385 != nil:
    section.add "subscriptionId", valid_594385
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
  var valid_594386 = query.getOrDefault("api-version")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "api-version", valid_594386
  var valid_594387 = query.getOrDefault("$top")
  valid_594387 = validateParameter(valid_594387, JInt, required = false, default = nil)
  if valid_594387 != nil:
    section.add "$top", valid_594387
  var valid_594388 = query.getOrDefault("$filter")
  valid_594388 = validateParameter(valid_594388, JString, required = false,
                                 default = nil)
  if valid_594388 != nil:
    section.add "$filter", valid_594388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594389: Call_PartnersListByIntegrationAccounts_594380;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account partners.
  ## 
  let valid = call_594389.validator(path, query, header, formData, body)
  let scheme = call_594389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594389.url(scheme.get, call_594389.host, call_594389.base,
                         call_594389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594389, url, valid)

proc call*(call_594390: Call_PartnersListByIntegrationAccounts_594380;
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
  var path_594391 = newJObject()
  var query_594392 = newJObject()
  add(path_594391, "resourceGroupName", newJString(resourceGroupName))
  add(query_594392, "api-version", newJString(apiVersion))
  add(path_594391, "integrationAccountName", newJString(integrationAccountName))
  add(path_594391, "subscriptionId", newJString(subscriptionId))
  add(query_594392, "$top", newJInt(Top))
  add(query_594392, "$filter", newJString(Filter))
  result = call_594390.call(path_594391, query_594392, nil, nil, nil)

var partnersListByIntegrationAccounts* = Call_PartnersListByIntegrationAccounts_594380(
    name: "partnersListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners",
    validator: validate_PartnersListByIntegrationAccounts_594381, base: "",
    url: url_PartnersListByIntegrationAccounts_594382, schemes: {Scheme.Https})
type
  Call_PartnersCreateOrUpdate_594405 = ref object of OpenApiRestCall_593438
proc url_PartnersCreateOrUpdate_594407(protocol: Scheme; host: string; base: string;
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

proc validate_PartnersCreateOrUpdate_594406(path: JsonNode; query: JsonNode;
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
  var valid_594408 = path.getOrDefault("resourceGroupName")
  valid_594408 = validateParameter(valid_594408, JString, required = true,
                                 default = nil)
  if valid_594408 != nil:
    section.add "resourceGroupName", valid_594408
  var valid_594409 = path.getOrDefault("integrationAccountName")
  valid_594409 = validateParameter(valid_594409, JString, required = true,
                                 default = nil)
  if valid_594409 != nil:
    section.add "integrationAccountName", valid_594409
  var valid_594410 = path.getOrDefault("subscriptionId")
  valid_594410 = validateParameter(valid_594410, JString, required = true,
                                 default = nil)
  if valid_594410 != nil:
    section.add "subscriptionId", valid_594410
  var valid_594411 = path.getOrDefault("partnerName")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "partnerName", valid_594411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594412 = query.getOrDefault("api-version")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "api-version", valid_594412
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

proc call*(call_594414: Call_PartnersCreateOrUpdate_594405; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account partner.
  ## 
  let valid = call_594414.validator(path, query, header, formData, body)
  let scheme = call_594414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594414.url(scheme.get, call_594414.host, call_594414.base,
                         call_594414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594414, url, valid)

proc call*(call_594415: Call_PartnersCreateOrUpdate_594405;
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
  var path_594416 = newJObject()
  var query_594417 = newJObject()
  var body_594418 = newJObject()
  add(path_594416, "resourceGroupName", newJString(resourceGroupName))
  add(query_594417, "api-version", newJString(apiVersion))
  add(path_594416, "integrationAccountName", newJString(integrationAccountName))
  add(path_594416, "subscriptionId", newJString(subscriptionId))
  if partner != nil:
    body_594418 = partner
  add(path_594416, "partnerName", newJString(partnerName))
  result = call_594415.call(path_594416, query_594417, nil, nil, body_594418)

var partnersCreateOrUpdate* = Call_PartnersCreateOrUpdate_594405(
    name: "partnersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_PartnersCreateOrUpdate_594406, base: "",
    url: url_PartnersCreateOrUpdate_594407, schemes: {Scheme.Https})
type
  Call_PartnersGet_594393 = ref object of OpenApiRestCall_593438
proc url_PartnersGet_594395(protocol: Scheme; host: string; base: string;
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

proc validate_PartnersGet_594394(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594396 = path.getOrDefault("resourceGroupName")
  valid_594396 = validateParameter(valid_594396, JString, required = true,
                                 default = nil)
  if valid_594396 != nil:
    section.add "resourceGroupName", valid_594396
  var valid_594397 = path.getOrDefault("integrationAccountName")
  valid_594397 = validateParameter(valid_594397, JString, required = true,
                                 default = nil)
  if valid_594397 != nil:
    section.add "integrationAccountName", valid_594397
  var valid_594398 = path.getOrDefault("subscriptionId")
  valid_594398 = validateParameter(valid_594398, JString, required = true,
                                 default = nil)
  if valid_594398 != nil:
    section.add "subscriptionId", valid_594398
  var valid_594399 = path.getOrDefault("partnerName")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "partnerName", valid_594399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594400 = query.getOrDefault("api-version")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "api-version", valid_594400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594401: Call_PartnersGet_594393; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account partner.
  ## 
  let valid = call_594401.validator(path, query, header, formData, body)
  let scheme = call_594401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594401.url(scheme.get, call_594401.host, call_594401.base,
                         call_594401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594401, url, valid)

proc call*(call_594402: Call_PartnersGet_594393; resourceGroupName: string;
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
  var path_594403 = newJObject()
  var query_594404 = newJObject()
  add(path_594403, "resourceGroupName", newJString(resourceGroupName))
  add(query_594404, "api-version", newJString(apiVersion))
  add(path_594403, "integrationAccountName", newJString(integrationAccountName))
  add(path_594403, "subscriptionId", newJString(subscriptionId))
  add(path_594403, "partnerName", newJString(partnerName))
  result = call_594402.call(path_594403, query_594404, nil, nil, nil)

var partnersGet* = Call_PartnersGet_594393(name: "partnersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
                                        validator: validate_PartnersGet_594394,
                                        base: "", url: url_PartnersGet_594395,
                                        schemes: {Scheme.Https})
type
  Call_PartnersDelete_594419 = ref object of OpenApiRestCall_593438
proc url_PartnersDelete_594421(protocol: Scheme; host: string; base: string;
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

proc validate_PartnersDelete_594420(path: JsonNode; query: JsonNode;
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
  var valid_594422 = path.getOrDefault("resourceGroupName")
  valid_594422 = validateParameter(valid_594422, JString, required = true,
                                 default = nil)
  if valid_594422 != nil:
    section.add "resourceGroupName", valid_594422
  var valid_594423 = path.getOrDefault("integrationAccountName")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "integrationAccountName", valid_594423
  var valid_594424 = path.getOrDefault("subscriptionId")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "subscriptionId", valid_594424
  var valid_594425 = path.getOrDefault("partnerName")
  valid_594425 = validateParameter(valid_594425, JString, required = true,
                                 default = nil)
  if valid_594425 != nil:
    section.add "partnerName", valid_594425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594426 = query.getOrDefault("api-version")
  valid_594426 = validateParameter(valid_594426, JString, required = true,
                                 default = nil)
  if valid_594426 != nil:
    section.add "api-version", valid_594426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594427: Call_PartnersDelete_594419; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account partner.
  ## 
  let valid = call_594427.validator(path, query, header, formData, body)
  let scheme = call_594427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594427.url(scheme.get, call_594427.host, call_594427.base,
                         call_594427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594427, url, valid)

proc call*(call_594428: Call_PartnersDelete_594419; resourceGroupName: string;
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
  var path_594429 = newJObject()
  var query_594430 = newJObject()
  add(path_594429, "resourceGroupName", newJString(resourceGroupName))
  add(query_594430, "api-version", newJString(apiVersion))
  add(path_594429, "integrationAccountName", newJString(integrationAccountName))
  add(path_594429, "subscriptionId", newJString(subscriptionId))
  add(path_594429, "partnerName", newJString(partnerName))
  result = call_594428.call(path_594429, query_594430, nil, nil, nil)

var partnersDelete* = Call_PartnersDelete_594419(name: "partnersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_PartnersDelete_594420, base: "", url: url_PartnersDelete_594421,
    schemes: {Scheme.Https})
type
  Call_PartnersListContentCallbackUrl_594431 = ref object of OpenApiRestCall_593438
proc url_PartnersListContentCallbackUrl_594433(protocol: Scheme; host: string;
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

proc validate_PartnersListContentCallbackUrl_594432(path: JsonNode;
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
  var valid_594434 = path.getOrDefault("resourceGroupName")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "resourceGroupName", valid_594434
  var valid_594435 = path.getOrDefault("integrationAccountName")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "integrationAccountName", valid_594435
  var valid_594436 = path.getOrDefault("subscriptionId")
  valid_594436 = validateParameter(valid_594436, JString, required = true,
                                 default = nil)
  if valid_594436 != nil:
    section.add "subscriptionId", valid_594436
  var valid_594437 = path.getOrDefault("partnerName")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "partnerName", valid_594437
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594438 = query.getOrDefault("api-version")
  valid_594438 = validateParameter(valid_594438, JString, required = true,
                                 default = nil)
  if valid_594438 != nil:
    section.add "api-version", valid_594438
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

proc call*(call_594440: Call_PartnersListContentCallbackUrl_594431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_594440.validator(path, query, header, formData, body)
  let scheme = call_594440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594440.url(scheme.get, call_594440.host, call_594440.base,
                         call_594440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594440, url, valid)

proc call*(call_594441: Call_PartnersListContentCallbackUrl_594431;
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
  var path_594442 = newJObject()
  var query_594443 = newJObject()
  var body_594444 = newJObject()
  add(path_594442, "resourceGroupName", newJString(resourceGroupName))
  add(query_594443, "api-version", newJString(apiVersion))
  add(path_594442, "integrationAccountName", newJString(integrationAccountName))
  add(path_594442, "subscriptionId", newJString(subscriptionId))
  add(path_594442, "partnerName", newJString(partnerName))
  if listContentCallbackUrl != nil:
    body_594444 = listContentCallbackUrl
  result = call_594441.call(path_594442, query_594443, nil, nil, body_594444)

var partnersListContentCallbackUrl* = Call_PartnersListContentCallbackUrl_594431(
    name: "partnersListContentCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}/listContentCallbackUrl",
    validator: validate_PartnersListContentCallbackUrl_594432, base: "",
    url: url_PartnersListContentCallbackUrl_594433, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsRegenerateAccessKey_594445 = ref object of OpenApiRestCall_593438
proc url_IntegrationAccountsRegenerateAccessKey_594447(protocol: Scheme;
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

proc validate_IntegrationAccountsRegenerateAccessKey_594446(path: JsonNode;
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
  var valid_594448 = path.getOrDefault("resourceGroupName")
  valid_594448 = validateParameter(valid_594448, JString, required = true,
                                 default = nil)
  if valid_594448 != nil:
    section.add "resourceGroupName", valid_594448
  var valid_594449 = path.getOrDefault("integrationAccountName")
  valid_594449 = validateParameter(valid_594449, JString, required = true,
                                 default = nil)
  if valid_594449 != nil:
    section.add "integrationAccountName", valid_594449
  var valid_594450 = path.getOrDefault("subscriptionId")
  valid_594450 = validateParameter(valid_594450, JString, required = true,
                                 default = nil)
  if valid_594450 != nil:
    section.add "subscriptionId", valid_594450
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594451 = query.getOrDefault("api-version")
  valid_594451 = validateParameter(valid_594451, JString, required = true,
                                 default = nil)
  if valid_594451 != nil:
    section.add "api-version", valid_594451
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

proc call*(call_594453: Call_IntegrationAccountsRegenerateAccessKey_594445;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the integration account access key.
  ## 
  let valid = call_594453.validator(path, query, header, formData, body)
  let scheme = call_594453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594453.url(scheme.get, call_594453.host, call_594453.base,
                         call_594453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594453, url, valid)

proc call*(call_594454: Call_IntegrationAccountsRegenerateAccessKey_594445;
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
  var path_594455 = newJObject()
  var query_594456 = newJObject()
  var body_594457 = newJObject()
  add(path_594455, "resourceGroupName", newJString(resourceGroupName))
  add(query_594456, "api-version", newJString(apiVersion))
  add(path_594455, "integrationAccountName", newJString(integrationAccountName))
  add(path_594455, "subscriptionId", newJString(subscriptionId))
  if regenerateAccessKey != nil:
    body_594457 = regenerateAccessKey
  result = call_594454.call(path_594455, query_594456, nil, nil, body_594457)

var integrationAccountsRegenerateAccessKey* = Call_IntegrationAccountsRegenerateAccessKey_594445(
    name: "integrationAccountsRegenerateAccessKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/regenerateAccessKey",
    validator: validate_IntegrationAccountsRegenerateAccessKey_594446, base: "",
    url: url_IntegrationAccountsRegenerateAccessKey_594447,
    schemes: {Scheme.Https})
type
  Call_RosettaNetProcessConfigurationsListByIntegrationAccounts_594458 = ref object of OpenApiRestCall_593438
proc url_RosettaNetProcessConfigurationsListByIntegrationAccounts_594460(
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

proc validate_RosettaNetProcessConfigurationsListByIntegrationAccounts_594459(
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
  var valid_594461 = path.getOrDefault("resourceGroupName")
  valid_594461 = validateParameter(valid_594461, JString, required = true,
                                 default = nil)
  if valid_594461 != nil:
    section.add "resourceGroupName", valid_594461
  var valid_594462 = path.getOrDefault("integrationAccountName")
  valid_594462 = validateParameter(valid_594462, JString, required = true,
                                 default = nil)
  if valid_594462 != nil:
    section.add "integrationAccountName", valid_594462
  var valid_594463 = path.getOrDefault("subscriptionId")
  valid_594463 = validateParameter(valid_594463, JString, required = true,
                                 default = nil)
  if valid_594463 != nil:
    section.add "subscriptionId", valid_594463
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
  var valid_594464 = query.getOrDefault("api-version")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "api-version", valid_594464
  var valid_594465 = query.getOrDefault("$top")
  valid_594465 = validateParameter(valid_594465, JInt, required = false, default = nil)
  if valid_594465 != nil:
    section.add "$top", valid_594465
  var valid_594466 = query.getOrDefault("$filter")
  valid_594466 = validateParameter(valid_594466, JString, required = false,
                                 default = nil)
  if valid_594466 != nil:
    section.add "$filter", valid_594466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594467: Call_RosettaNetProcessConfigurationsListByIntegrationAccounts_594458;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account RosettaNet process configurations.
  ## 
  let valid = call_594467.validator(path, query, header, formData, body)
  let scheme = call_594467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594467.url(scheme.get, call_594467.host, call_594467.base,
                         call_594467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594467, url, valid)

proc call*(call_594468: Call_RosettaNetProcessConfigurationsListByIntegrationAccounts_594458;
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
  var path_594469 = newJObject()
  var query_594470 = newJObject()
  add(path_594469, "resourceGroupName", newJString(resourceGroupName))
  add(query_594470, "api-version", newJString(apiVersion))
  add(path_594469, "integrationAccountName", newJString(integrationAccountName))
  add(path_594469, "subscriptionId", newJString(subscriptionId))
  add(query_594470, "$top", newJInt(Top))
  add(query_594470, "$filter", newJString(Filter))
  result = call_594468.call(path_594469, query_594470, nil, nil, nil)

var rosettaNetProcessConfigurationsListByIntegrationAccounts* = Call_RosettaNetProcessConfigurationsListByIntegrationAccounts_594458(
    name: "rosettaNetProcessConfigurationsListByIntegrationAccounts",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/rosettanetprocessconfigurations", validator: validate_RosettaNetProcessConfigurationsListByIntegrationAccounts_594459,
    base: "", url: url_RosettaNetProcessConfigurationsListByIntegrationAccounts_594460,
    schemes: {Scheme.Https})
type
  Call_RosettaNetProcessConfigurationsCreateOrUpdate_594483 = ref object of OpenApiRestCall_593438
proc url_RosettaNetProcessConfigurationsCreateOrUpdate_594485(protocol: Scheme;
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

proc validate_RosettaNetProcessConfigurationsCreateOrUpdate_594484(
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
  var valid_594486 = path.getOrDefault("resourceGroupName")
  valid_594486 = validateParameter(valid_594486, JString, required = true,
                                 default = nil)
  if valid_594486 != nil:
    section.add "resourceGroupName", valid_594486
  var valid_594487 = path.getOrDefault("integrationAccountName")
  valid_594487 = validateParameter(valid_594487, JString, required = true,
                                 default = nil)
  if valid_594487 != nil:
    section.add "integrationAccountName", valid_594487
  var valid_594488 = path.getOrDefault("subscriptionId")
  valid_594488 = validateParameter(valid_594488, JString, required = true,
                                 default = nil)
  if valid_594488 != nil:
    section.add "subscriptionId", valid_594488
  var valid_594489 = path.getOrDefault("rosettaNetProcessConfigurationName")
  valid_594489 = validateParameter(valid_594489, JString, required = true,
                                 default = nil)
  if valid_594489 != nil:
    section.add "rosettaNetProcessConfigurationName", valid_594489
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594490 = query.getOrDefault("api-version")
  valid_594490 = validateParameter(valid_594490, JString, required = true,
                                 default = nil)
  if valid_594490 != nil:
    section.add "api-version", valid_594490
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

proc call*(call_594492: Call_RosettaNetProcessConfigurationsCreateOrUpdate_594483;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account RosettaNetProcessConfiguration.
  ## 
  let valid = call_594492.validator(path, query, header, formData, body)
  let scheme = call_594492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594492.url(scheme.get, call_594492.host, call_594492.base,
                         call_594492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594492, url, valid)

proc call*(call_594493: Call_RosettaNetProcessConfigurationsCreateOrUpdate_594483;
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
  var path_594494 = newJObject()
  var query_594495 = newJObject()
  var body_594496 = newJObject()
  add(path_594494, "resourceGroupName", newJString(resourceGroupName))
  add(query_594495, "api-version", newJString(apiVersion))
  add(path_594494, "integrationAccountName", newJString(integrationAccountName))
  add(path_594494, "subscriptionId", newJString(subscriptionId))
  add(path_594494, "rosettaNetProcessConfigurationName",
      newJString(rosettaNetProcessConfigurationName))
  if rosettaNetProcessConfiguration != nil:
    body_594496 = rosettaNetProcessConfiguration
  result = call_594493.call(path_594494, query_594495, nil, nil, body_594496)

var rosettaNetProcessConfigurationsCreateOrUpdate* = Call_RosettaNetProcessConfigurationsCreateOrUpdate_594483(
    name: "rosettaNetProcessConfigurationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/rosettanetprocessconfigurations/{rosettaNetProcessConfigurationName}",
    validator: validate_RosettaNetProcessConfigurationsCreateOrUpdate_594484,
    base: "", url: url_RosettaNetProcessConfigurationsCreateOrUpdate_594485,
    schemes: {Scheme.Https})
type
  Call_RosettaNetProcessConfigurationsGet_594471 = ref object of OpenApiRestCall_593438
proc url_RosettaNetProcessConfigurationsGet_594473(protocol: Scheme; host: string;
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

proc validate_RosettaNetProcessConfigurationsGet_594472(path: JsonNode;
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
  var valid_594474 = path.getOrDefault("resourceGroupName")
  valid_594474 = validateParameter(valid_594474, JString, required = true,
                                 default = nil)
  if valid_594474 != nil:
    section.add "resourceGroupName", valid_594474
  var valid_594475 = path.getOrDefault("integrationAccountName")
  valid_594475 = validateParameter(valid_594475, JString, required = true,
                                 default = nil)
  if valid_594475 != nil:
    section.add "integrationAccountName", valid_594475
  var valid_594476 = path.getOrDefault("subscriptionId")
  valid_594476 = validateParameter(valid_594476, JString, required = true,
                                 default = nil)
  if valid_594476 != nil:
    section.add "subscriptionId", valid_594476
  var valid_594477 = path.getOrDefault("rosettaNetProcessConfigurationName")
  valid_594477 = validateParameter(valid_594477, JString, required = true,
                                 default = nil)
  if valid_594477 != nil:
    section.add "rosettaNetProcessConfigurationName", valid_594477
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594478 = query.getOrDefault("api-version")
  valid_594478 = validateParameter(valid_594478, JString, required = true,
                                 default = nil)
  if valid_594478 != nil:
    section.add "api-version", valid_594478
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594479: Call_RosettaNetProcessConfigurationsGet_594471;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an integration account RosettaNetProcessConfiguration.
  ## 
  let valid = call_594479.validator(path, query, header, formData, body)
  let scheme = call_594479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594479.url(scheme.get, call_594479.host, call_594479.base,
                         call_594479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594479, url, valid)

proc call*(call_594480: Call_RosettaNetProcessConfigurationsGet_594471;
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
  var path_594481 = newJObject()
  var query_594482 = newJObject()
  add(path_594481, "resourceGroupName", newJString(resourceGroupName))
  add(query_594482, "api-version", newJString(apiVersion))
  add(path_594481, "integrationAccountName", newJString(integrationAccountName))
  add(path_594481, "subscriptionId", newJString(subscriptionId))
  add(path_594481, "rosettaNetProcessConfigurationName",
      newJString(rosettaNetProcessConfigurationName))
  result = call_594480.call(path_594481, query_594482, nil, nil, nil)

var rosettaNetProcessConfigurationsGet* = Call_RosettaNetProcessConfigurationsGet_594471(
    name: "rosettaNetProcessConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/rosettanetprocessconfigurations/{rosettaNetProcessConfigurationName}",
    validator: validate_RosettaNetProcessConfigurationsGet_594472, base: "",
    url: url_RosettaNetProcessConfigurationsGet_594473, schemes: {Scheme.Https})
type
  Call_RosettaNetProcessConfigurationsDelete_594497 = ref object of OpenApiRestCall_593438
proc url_RosettaNetProcessConfigurationsDelete_594499(protocol: Scheme;
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

proc validate_RosettaNetProcessConfigurationsDelete_594498(path: JsonNode;
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
  var valid_594500 = path.getOrDefault("resourceGroupName")
  valid_594500 = validateParameter(valid_594500, JString, required = true,
                                 default = nil)
  if valid_594500 != nil:
    section.add "resourceGroupName", valid_594500
  var valid_594501 = path.getOrDefault("integrationAccountName")
  valid_594501 = validateParameter(valid_594501, JString, required = true,
                                 default = nil)
  if valid_594501 != nil:
    section.add "integrationAccountName", valid_594501
  var valid_594502 = path.getOrDefault("subscriptionId")
  valid_594502 = validateParameter(valid_594502, JString, required = true,
                                 default = nil)
  if valid_594502 != nil:
    section.add "subscriptionId", valid_594502
  var valid_594503 = path.getOrDefault("rosettaNetProcessConfigurationName")
  valid_594503 = validateParameter(valid_594503, JString, required = true,
                                 default = nil)
  if valid_594503 != nil:
    section.add "rosettaNetProcessConfigurationName", valid_594503
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594504 = query.getOrDefault("api-version")
  valid_594504 = validateParameter(valid_594504, JString, required = true,
                                 default = nil)
  if valid_594504 != nil:
    section.add "api-version", valid_594504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594505: Call_RosettaNetProcessConfigurationsDelete_594497;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account RosettaNet ProcessConfiguration.
  ## 
  let valid = call_594505.validator(path, query, header, formData, body)
  let scheme = call_594505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594505.url(scheme.get, call_594505.host, call_594505.base,
                         call_594505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594505, url, valid)

proc call*(call_594506: Call_RosettaNetProcessConfigurationsDelete_594497;
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
  var path_594507 = newJObject()
  var query_594508 = newJObject()
  add(path_594507, "resourceGroupName", newJString(resourceGroupName))
  add(query_594508, "api-version", newJString(apiVersion))
  add(path_594507, "integrationAccountName", newJString(integrationAccountName))
  add(path_594507, "subscriptionId", newJString(subscriptionId))
  add(path_594507, "rosettaNetProcessConfigurationName",
      newJString(rosettaNetProcessConfigurationName))
  result = call_594506.call(path_594507, query_594508, nil, nil, nil)

var rosettaNetProcessConfigurationsDelete* = Call_RosettaNetProcessConfigurationsDelete_594497(
    name: "rosettaNetProcessConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/rosettanetprocessconfigurations/{rosettaNetProcessConfigurationName}",
    validator: validate_RosettaNetProcessConfigurationsDelete_594498, base: "",
    url: url_RosettaNetProcessConfigurationsDelete_594499, schemes: {Scheme.Https})
type
  Call_SchemasListByIntegrationAccounts_594509 = ref object of OpenApiRestCall_593438
proc url_SchemasListByIntegrationAccounts_594511(protocol: Scheme; host: string;
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

proc validate_SchemasListByIntegrationAccounts_594510(path: JsonNode;
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
  var valid_594512 = path.getOrDefault("resourceGroupName")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "resourceGroupName", valid_594512
  var valid_594513 = path.getOrDefault("integrationAccountName")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "integrationAccountName", valid_594513
  var valid_594514 = path.getOrDefault("subscriptionId")
  valid_594514 = validateParameter(valid_594514, JString, required = true,
                                 default = nil)
  if valid_594514 != nil:
    section.add "subscriptionId", valid_594514
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
  var valid_594515 = query.getOrDefault("api-version")
  valid_594515 = validateParameter(valid_594515, JString, required = true,
                                 default = nil)
  if valid_594515 != nil:
    section.add "api-version", valid_594515
  var valid_594516 = query.getOrDefault("$top")
  valid_594516 = validateParameter(valid_594516, JInt, required = false, default = nil)
  if valid_594516 != nil:
    section.add "$top", valid_594516
  var valid_594517 = query.getOrDefault("$filter")
  valid_594517 = validateParameter(valid_594517, JString, required = false,
                                 default = nil)
  if valid_594517 != nil:
    section.add "$filter", valid_594517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594518: Call_SchemasListByIntegrationAccounts_594509;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account schemas.
  ## 
  let valid = call_594518.validator(path, query, header, formData, body)
  let scheme = call_594518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594518.url(scheme.get, call_594518.host, call_594518.base,
                         call_594518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594518, url, valid)

proc call*(call_594519: Call_SchemasListByIntegrationAccounts_594509;
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
  var path_594520 = newJObject()
  var query_594521 = newJObject()
  add(path_594520, "resourceGroupName", newJString(resourceGroupName))
  add(query_594521, "api-version", newJString(apiVersion))
  add(path_594520, "integrationAccountName", newJString(integrationAccountName))
  add(path_594520, "subscriptionId", newJString(subscriptionId))
  add(query_594521, "$top", newJInt(Top))
  add(query_594521, "$filter", newJString(Filter))
  result = call_594519.call(path_594520, query_594521, nil, nil, nil)

var schemasListByIntegrationAccounts* = Call_SchemasListByIntegrationAccounts_594509(
    name: "schemasListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas",
    validator: validate_SchemasListByIntegrationAccounts_594510, base: "",
    url: url_SchemasListByIntegrationAccounts_594511, schemes: {Scheme.Https})
type
  Call_SchemasCreateOrUpdate_594534 = ref object of OpenApiRestCall_593438
proc url_SchemasCreateOrUpdate_594536(protocol: Scheme; host: string; base: string;
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

proc validate_SchemasCreateOrUpdate_594535(path: JsonNode; query: JsonNode;
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
  var valid_594537 = path.getOrDefault("resourceGroupName")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "resourceGroupName", valid_594537
  var valid_594538 = path.getOrDefault("integrationAccountName")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "integrationAccountName", valid_594538
  var valid_594539 = path.getOrDefault("subscriptionId")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "subscriptionId", valid_594539
  var valid_594540 = path.getOrDefault("schemaName")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = nil)
  if valid_594540 != nil:
    section.add "schemaName", valid_594540
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594541 = query.getOrDefault("api-version")
  valid_594541 = validateParameter(valid_594541, JString, required = true,
                                 default = nil)
  if valid_594541 != nil:
    section.add "api-version", valid_594541
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

proc call*(call_594543: Call_SchemasCreateOrUpdate_594534; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account schema.
  ## 
  let valid = call_594543.validator(path, query, header, formData, body)
  let scheme = call_594543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594543.url(scheme.get, call_594543.host, call_594543.base,
                         call_594543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594543, url, valid)

proc call*(call_594544: Call_SchemasCreateOrUpdate_594534;
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
  var path_594545 = newJObject()
  var query_594546 = newJObject()
  var body_594547 = newJObject()
  add(path_594545, "resourceGroupName", newJString(resourceGroupName))
  add(query_594546, "api-version", newJString(apiVersion))
  add(path_594545, "integrationAccountName", newJString(integrationAccountName))
  add(path_594545, "subscriptionId", newJString(subscriptionId))
  add(path_594545, "schemaName", newJString(schemaName))
  if schema != nil:
    body_594547 = schema
  result = call_594544.call(path_594545, query_594546, nil, nil, body_594547)

var schemasCreateOrUpdate* = Call_SchemasCreateOrUpdate_594534(
    name: "schemasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_SchemasCreateOrUpdate_594535, base: "",
    url: url_SchemasCreateOrUpdate_594536, schemes: {Scheme.Https})
type
  Call_SchemasGet_594522 = ref object of OpenApiRestCall_593438
proc url_SchemasGet_594524(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SchemasGet_594523(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594525 = path.getOrDefault("resourceGroupName")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "resourceGroupName", valid_594525
  var valid_594526 = path.getOrDefault("integrationAccountName")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "integrationAccountName", valid_594526
  var valid_594527 = path.getOrDefault("subscriptionId")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "subscriptionId", valid_594527
  var valid_594528 = path.getOrDefault("schemaName")
  valid_594528 = validateParameter(valid_594528, JString, required = true,
                                 default = nil)
  if valid_594528 != nil:
    section.add "schemaName", valid_594528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594529 = query.getOrDefault("api-version")
  valid_594529 = validateParameter(valid_594529, JString, required = true,
                                 default = nil)
  if valid_594529 != nil:
    section.add "api-version", valid_594529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594530: Call_SchemasGet_594522; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account schema.
  ## 
  let valid = call_594530.validator(path, query, header, formData, body)
  let scheme = call_594530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594530.url(scheme.get, call_594530.host, call_594530.base,
                         call_594530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594530, url, valid)

proc call*(call_594531: Call_SchemasGet_594522; resourceGroupName: string;
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
  var path_594532 = newJObject()
  var query_594533 = newJObject()
  add(path_594532, "resourceGroupName", newJString(resourceGroupName))
  add(query_594533, "api-version", newJString(apiVersion))
  add(path_594532, "integrationAccountName", newJString(integrationAccountName))
  add(path_594532, "subscriptionId", newJString(subscriptionId))
  add(path_594532, "schemaName", newJString(schemaName))
  result = call_594531.call(path_594532, query_594533, nil, nil, nil)

var schemasGet* = Call_SchemasGet_594522(name: "schemasGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
                                      validator: validate_SchemasGet_594523,
                                      base: "", url: url_SchemasGet_594524,
                                      schemes: {Scheme.Https})
type
  Call_SchemasDelete_594548 = ref object of OpenApiRestCall_593438
proc url_SchemasDelete_594550(protocol: Scheme; host: string; base: string;
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

proc validate_SchemasDelete_594549(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594551 = path.getOrDefault("resourceGroupName")
  valid_594551 = validateParameter(valid_594551, JString, required = true,
                                 default = nil)
  if valid_594551 != nil:
    section.add "resourceGroupName", valid_594551
  var valid_594552 = path.getOrDefault("integrationAccountName")
  valid_594552 = validateParameter(valid_594552, JString, required = true,
                                 default = nil)
  if valid_594552 != nil:
    section.add "integrationAccountName", valid_594552
  var valid_594553 = path.getOrDefault("subscriptionId")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = nil)
  if valid_594553 != nil:
    section.add "subscriptionId", valid_594553
  var valid_594554 = path.getOrDefault("schemaName")
  valid_594554 = validateParameter(valid_594554, JString, required = true,
                                 default = nil)
  if valid_594554 != nil:
    section.add "schemaName", valid_594554
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594555 = query.getOrDefault("api-version")
  valid_594555 = validateParameter(valid_594555, JString, required = true,
                                 default = nil)
  if valid_594555 != nil:
    section.add "api-version", valid_594555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594556: Call_SchemasDelete_594548; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account schema.
  ## 
  let valid = call_594556.validator(path, query, header, formData, body)
  let scheme = call_594556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594556.url(scheme.get, call_594556.host, call_594556.base,
                         call_594556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594556, url, valid)

proc call*(call_594557: Call_SchemasDelete_594548; resourceGroupName: string;
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
  var path_594558 = newJObject()
  var query_594559 = newJObject()
  add(path_594558, "resourceGroupName", newJString(resourceGroupName))
  add(query_594559, "api-version", newJString(apiVersion))
  add(path_594558, "integrationAccountName", newJString(integrationAccountName))
  add(path_594558, "subscriptionId", newJString(subscriptionId))
  add(path_594558, "schemaName", newJString(schemaName))
  result = call_594557.call(path_594558, query_594559, nil, nil, nil)

var schemasDelete* = Call_SchemasDelete_594548(name: "schemasDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_SchemasDelete_594549, base: "", url: url_SchemasDelete_594550,
    schemes: {Scheme.Https})
type
  Call_SchemasListContentCallbackUrl_594560 = ref object of OpenApiRestCall_593438
proc url_SchemasListContentCallbackUrl_594562(protocol: Scheme; host: string;
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

proc validate_SchemasListContentCallbackUrl_594561(path: JsonNode; query: JsonNode;
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
  var valid_594563 = path.getOrDefault("resourceGroupName")
  valid_594563 = validateParameter(valid_594563, JString, required = true,
                                 default = nil)
  if valid_594563 != nil:
    section.add "resourceGroupName", valid_594563
  var valid_594564 = path.getOrDefault("integrationAccountName")
  valid_594564 = validateParameter(valid_594564, JString, required = true,
                                 default = nil)
  if valid_594564 != nil:
    section.add "integrationAccountName", valid_594564
  var valid_594565 = path.getOrDefault("subscriptionId")
  valid_594565 = validateParameter(valid_594565, JString, required = true,
                                 default = nil)
  if valid_594565 != nil:
    section.add "subscriptionId", valid_594565
  var valid_594566 = path.getOrDefault("schemaName")
  valid_594566 = validateParameter(valid_594566, JString, required = true,
                                 default = nil)
  if valid_594566 != nil:
    section.add "schemaName", valid_594566
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594567 = query.getOrDefault("api-version")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = nil)
  if valid_594567 != nil:
    section.add "api-version", valid_594567
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

proc call*(call_594569: Call_SchemasListContentCallbackUrl_594560; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the content callback url.
  ## 
  let valid = call_594569.validator(path, query, header, formData, body)
  let scheme = call_594569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594569.url(scheme.get, call_594569.host, call_594569.base,
                         call_594569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594569, url, valid)

proc call*(call_594570: Call_SchemasListContentCallbackUrl_594560;
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
  var path_594571 = newJObject()
  var query_594572 = newJObject()
  var body_594573 = newJObject()
  add(path_594571, "resourceGroupName", newJString(resourceGroupName))
  add(query_594572, "api-version", newJString(apiVersion))
  add(path_594571, "integrationAccountName", newJString(integrationAccountName))
  add(path_594571, "subscriptionId", newJString(subscriptionId))
  add(path_594571, "schemaName", newJString(schemaName))
  if listContentCallbackUrl != nil:
    body_594573 = listContentCallbackUrl
  result = call_594570.call(path_594571, query_594572, nil, nil, body_594573)

var schemasListContentCallbackUrl* = Call_SchemasListContentCallbackUrl_594560(
    name: "schemasListContentCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}/listContentCallbackUrl",
    validator: validate_SchemasListContentCallbackUrl_594561, base: "",
    url: url_SchemasListContentCallbackUrl_594562, schemes: {Scheme.Https})
type
  Call_SessionsListByIntegrationAccounts_594574 = ref object of OpenApiRestCall_593438
proc url_SessionsListByIntegrationAccounts_594576(protocol: Scheme; host: string;
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

proc validate_SessionsListByIntegrationAccounts_594575(path: JsonNode;
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
  var valid_594577 = path.getOrDefault("resourceGroupName")
  valid_594577 = validateParameter(valid_594577, JString, required = true,
                                 default = nil)
  if valid_594577 != nil:
    section.add "resourceGroupName", valid_594577
  var valid_594578 = path.getOrDefault("integrationAccountName")
  valid_594578 = validateParameter(valid_594578, JString, required = true,
                                 default = nil)
  if valid_594578 != nil:
    section.add "integrationAccountName", valid_594578
  var valid_594579 = path.getOrDefault("subscriptionId")
  valid_594579 = validateParameter(valid_594579, JString, required = true,
                                 default = nil)
  if valid_594579 != nil:
    section.add "subscriptionId", valid_594579
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
  var valid_594580 = query.getOrDefault("api-version")
  valid_594580 = validateParameter(valid_594580, JString, required = true,
                                 default = nil)
  if valid_594580 != nil:
    section.add "api-version", valid_594580
  var valid_594581 = query.getOrDefault("$top")
  valid_594581 = validateParameter(valid_594581, JInt, required = false, default = nil)
  if valid_594581 != nil:
    section.add "$top", valid_594581
  var valid_594582 = query.getOrDefault("$filter")
  valid_594582 = validateParameter(valid_594582, JString, required = false,
                                 default = nil)
  if valid_594582 != nil:
    section.add "$filter", valid_594582
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594583: Call_SessionsListByIntegrationAccounts_594574;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account sessions.
  ## 
  let valid = call_594583.validator(path, query, header, formData, body)
  let scheme = call_594583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594583.url(scheme.get, call_594583.host, call_594583.base,
                         call_594583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594583, url, valid)

proc call*(call_594584: Call_SessionsListByIntegrationAccounts_594574;
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
  var path_594585 = newJObject()
  var query_594586 = newJObject()
  add(path_594585, "resourceGroupName", newJString(resourceGroupName))
  add(query_594586, "api-version", newJString(apiVersion))
  add(path_594585, "integrationAccountName", newJString(integrationAccountName))
  add(path_594585, "subscriptionId", newJString(subscriptionId))
  add(query_594586, "$top", newJInt(Top))
  add(query_594586, "$filter", newJString(Filter))
  result = call_594584.call(path_594585, query_594586, nil, nil, nil)

var sessionsListByIntegrationAccounts* = Call_SessionsListByIntegrationAccounts_594574(
    name: "sessionsListByIntegrationAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions",
    validator: validate_SessionsListByIntegrationAccounts_594575, base: "",
    url: url_SessionsListByIntegrationAccounts_594576, schemes: {Scheme.Https})
type
  Call_SessionsCreateOrUpdate_594599 = ref object of OpenApiRestCall_593438
proc url_SessionsCreateOrUpdate_594601(protocol: Scheme; host: string; base: string;
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

proc validate_SessionsCreateOrUpdate_594600(path: JsonNode; query: JsonNode;
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
  var valid_594602 = path.getOrDefault("resourceGroupName")
  valid_594602 = validateParameter(valid_594602, JString, required = true,
                                 default = nil)
  if valid_594602 != nil:
    section.add "resourceGroupName", valid_594602
  var valid_594603 = path.getOrDefault("sessionName")
  valid_594603 = validateParameter(valid_594603, JString, required = true,
                                 default = nil)
  if valid_594603 != nil:
    section.add "sessionName", valid_594603
  var valid_594604 = path.getOrDefault("integrationAccountName")
  valid_594604 = validateParameter(valid_594604, JString, required = true,
                                 default = nil)
  if valid_594604 != nil:
    section.add "integrationAccountName", valid_594604
  var valid_594605 = path.getOrDefault("subscriptionId")
  valid_594605 = validateParameter(valid_594605, JString, required = true,
                                 default = nil)
  if valid_594605 != nil:
    section.add "subscriptionId", valid_594605
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594606 = query.getOrDefault("api-version")
  valid_594606 = validateParameter(valid_594606, JString, required = true,
                                 default = nil)
  if valid_594606 != nil:
    section.add "api-version", valid_594606
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

proc call*(call_594608: Call_SessionsCreateOrUpdate_594599; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an integration account session.
  ## 
  let valid = call_594608.validator(path, query, header, formData, body)
  let scheme = call_594608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594608.url(scheme.get, call_594608.host, call_594608.base,
                         call_594608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594608, url, valid)

proc call*(call_594609: Call_SessionsCreateOrUpdate_594599;
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
  var path_594610 = newJObject()
  var query_594611 = newJObject()
  var body_594612 = newJObject()
  add(path_594610, "resourceGroupName", newJString(resourceGroupName))
  add(query_594611, "api-version", newJString(apiVersion))
  add(path_594610, "sessionName", newJString(sessionName))
  add(path_594610, "integrationAccountName", newJString(integrationAccountName))
  add(path_594610, "subscriptionId", newJString(subscriptionId))
  if session != nil:
    body_594612 = session
  result = call_594609.call(path_594610, query_594611, nil, nil, body_594612)

var sessionsCreateOrUpdate* = Call_SessionsCreateOrUpdate_594599(
    name: "sessionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
    validator: validate_SessionsCreateOrUpdate_594600, base: "",
    url: url_SessionsCreateOrUpdate_594601, schemes: {Scheme.Https})
type
  Call_SessionsGet_594587 = ref object of OpenApiRestCall_593438
proc url_SessionsGet_594589(protocol: Scheme; host: string; base: string;
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

proc validate_SessionsGet_594588(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594590 = path.getOrDefault("resourceGroupName")
  valid_594590 = validateParameter(valid_594590, JString, required = true,
                                 default = nil)
  if valid_594590 != nil:
    section.add "resourceGroupName", valid_594590
  var valid_594591 = path.getOrDefault("sessionName")
  valid_594591 = validateParameter(valid_594591, JString, required = true,
                                 default = nil)
  if valid_594591 != nil:
    section.add "sessionName", valid_594591
  var valid_594592 = path.getOrDefault("integrationAccountName")
  valid_594592 = validateParameter(valid_594592, JString, required = true,
                                 default = nil)
  if valid_594592 != nil:
    section.add "integrationAccountName", valid_594592
  var valid_594593 = path.getOrDefault("subscriptionId")
  valid_594593 = validateParameter(valid_594593, JString, required = true,
                                 default = nil)
  if valid_594593 != nil:
    section.add "subscriptionId", valid_594593
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594594 = query.getOrDefault("api-version")
  valid_594594 = validateParameter(valid_594594, JString, required = true,
                                 default = nil)
  if valid_594594 != nil:
    section.add "api-version", valid_594594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594595: Call_SessionsGet_594587; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account session.
  ## 
  let valid = call_594595.validator(path, query, header, formData, body)
  let scheme = call_594595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594595.url(scheme.get, call_594595.host, call_594595.base,
                         call_594595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594595, url, valid)

proc call*(call_594596: Call_SessionsGet_594587; resourceGroupName: string;
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
  var path_594597 = newJObject()
  var query_594598 = newJObject()
  add(path_594597, "resourceGroupName", newJString(resourceGroupName))
  add(query_594598, "api-version", newJString(apiVersion))
  add(path_594597, "sessionName", newJString(sessionName))
  add(path_594597, "integrationAccountName", newJString(integrationAccountName))
  add(path_594597, "subscriptionId", newJString(subscriptionId))
  result = call_594596.call(path_594597, query_594598, nil, nil, nil)

var sessionsGet* = Call_SessionsGet_594587(name: "sessionsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
                                        validator: validate_SessionsGet_594588,
                                        base: "", url: url_SessionsGet_594589,
                                        schemes: {Scheme.Https})
type
  Call_SessionsDelete_594613 = ref object of OpenApiRestCall_593438
proc url_SessionsDelete_594615(protocol: Scheme; host: string; base: string;
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

proc validate_SessionsDelete_594614(path: JsonNode; query: JsonNode;
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
  var valid_594616 = path.getOrDefault("resourceGroupName")
  valid_594616 = validateParameter(valid_594616, JString, required = true,
                                 default = nil)
  if valid_594616 != nil:
    section.add "resourceGroupName", valid_594616
  var valid_594617 = path.getOrDefault("sessionName")
  valid_594617 = validateParameter(valid_594617, JString, required = true,
                                 default = nil)
  if valid_594617 != nil:
    section.add "sessionName", valid_594617
  var valid_594618 = path.getOrDefault("integrationAccountName")
  valid_594618 = validateParameter(valid_594618, JString, required = true,
                                 default = nil)
  if valid_594618 != nil:
    section.add "integrationAccountName", valid_594618
  var valid_594619 = path.getOrDefault("subscriptionId")
  valid_594619 = validateParameter(valid_594619, JString, required = true,
                                 default = nil)
  if valid_594619 != nil:
    section.add "subscriptionId", valid_594619
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594620 = query.getOrDefault("api-version")
  valid_594620 = validateParameter(valid_594620, JString, required = true,
                                 default = nil)
  if valid_594620 != nil:
    section.add "api-version", valid_594620
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594621: Call_SessionsDelete_594613; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account session.
  ## 
  let valid = call_594621.validator(path, query, header, formData, body)
  let scheme = call_594621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594621.url(scheme.get, call_594621.host, call_594621.base,
                         call_594621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594621, url, valid)

proc call*(call_594622: Call_SessionsDelete_594613; resourceGroupName: string;
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
  var path_594623 = newJObject()
  var query_594624 = newJObject()
  add(path_594623, "resourceGroupName", newJString(resourceGroupName))
  add(query_594624, "api-version", newJString(apiVersion))
  add(path_594623, "sessionName", newJString(sessionName))
  add(path_594623, "integrationAccountName", newJString(integrationAccountName))
  add(path_594623, "subscriptionId", newJString(subscriptionId))
  result = call_594622.call(path_594623, query_594624, nil, nil, nil)

var sessionsDelete* = Call_SessionsDelete_594613(name: "sessionsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}",
    validator: validate_SessionsDelete_594614, base: "", url: url_SessionsDelete_594615,
    schemes: {Scheme.Https})
type
  Call_WorkflowsValidate_594625 = ref object of OpenApiRestCall_593438
proc url_WorkflowsValidate_594627(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsValidate_594626(path: JsonNode; query: JsonNode;
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
  var valid_594628 = path.getOrDefault("workflowName")
  valid_594628 = validateParameter(valid_594628, JString, required = true,
                                 default = nil)
  if valid_594628 != nil:
    section.add "workflowName", valid_594628
  var valid_594629 = path.getOrDefault("resourceGroupName")
  valid_594629 = validateParameter(valid_594629, JString, required = true,
                                 default = nil)
  if valid_594629 != nil:
    section.add "resourceGroupName", valid_594629
  var valid_594630 = path.getOrDefault("subscriptionId")
  valid_594630 = validateParameter(valid_594630, JString, required = true,
                                 default = nil)
  if valid_594630 != nil:
    section.add "subscriptionId", valid_594630
  var valid_594631 = path.getOrDefault("location")
  valid_594631 = validateParameter(valid_594631, JString, required = true,
                                 default = nil)
  if valid_594631 != nil:
    section.add "location", valid_594631
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594632 = query.getOrDefault("api-version")
  valid_594632 = validateParameter(valid_594632, JString, required = true,
                                 default = nil)
  if valid_594632 != nil:
    section.add "api-version", valid_594632
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

proc call*(call_594634: Call_WorkflowsValidate_594625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the workflow definition.
  ## 
  let valid = call_594634.validator(path, query, header, formData, body)
  let scheme = call_594634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594634.url(scheme.get, call_594634.host, call_594634.base,
                         call_594634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594634, url, valid)

proc call*(call_594635: Call_WorkflowsValidate_594625; workflowName: string;
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
  var path_594636 = newJObject()
  var query_594637 = newJObject()
  var body_594638 = newJObject()
  add(path_594636, "workflowName", newJString(workflowName))
  add(path_594636, "resourceGroupName", newJString(resourceGroupName))
  add(query_594637, "api-version", newJString(apiVersion))
  add(path_594636, "subscriptionId", newJString(subscriptionId))
  if workflow != nil:
    body_594638 = workflow
  add(path_594636, "location", newJString(location))
  result = call_594635.call(path_594636, query_594637, nil, nil, body_594638)

var workflowsValidate* = Call_WorkflowsValidate_594625(name: "workflowsValidate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/locations/{location}/workflows/{workflowName}/validate",
    validator: validate_WorkflowsValidate_594626, base: "",
    url: url_WorkflowsValidate_594627, schemes: {Scheme.Https})
type
  Call_WorkflowsListByResourceGroup_594639 = ref object of OpenApiRestCall_593438
proc url_WorkflowsListByResourceGroup_594641(protocol: Scheme; host: string;
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

proc validate_WorkflowsListByResourceGroup_594640(path: JsonNode; query: JsonNode;
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
  var valid_594642 = path.getOrDefault("resourceGroupName")
  valid_594642 = validateParameter(valid_594642, JString, required = true,
                                 default = nil)
  if valid_594642 != nil:
    section.add "resourceGroupName", valid_594642
  var valid_594643 = path.getOrDefault("subscriptionId")
  valid_594643 = validateParameter(valid_594643, JString, required = true,
                                 default = nil)
  if valid_594643 != nil:
    section.add "subscriptionId", valid_594643
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
  var valid_594644 = query.getOrDefault("api-version")
  valid_594644 = validateParameter(valid_594644, JString, required = true,
                                 default = nil)
  if valid_594644 != nil:
    section.add "api-version", valid_594644
  var valid_594645 = query.getOrDefault("$top")
  valid_594645 = validateParameter(valid_594645, JInt, required = false, default = nil)
  if valid_594645 != nil:
    section.add "$top", valid_594645
  var valid_594646 = query.getOrDefault("$filter")
  valid_594646 = validateParameter(valid_594646, JString, required = false,
                                 default = nil)
  if valid_594646 != nil:
    section.add "$filter", valid_594646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594647: Call_WorkflowsListByResourceGroup_594639; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflows by resource group.
  ## 
  let valid = call_594647.validator(path, query, header, formData, body)
  let scheme = call_594647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594647.url(scheme.get, call_594647.host, call_594647.base,
                         call_594647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594647, url, valid)

proc call*(call_594648: Call_WorkflowsListByResourceGroup_594639;
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
  var path_594649 = newJObject()
  var query_594650 = newJObject()
  add(path_594649, "resourceGroupName", newJString(resourceGroupName))
  add(query_594650, "api-version", newJString(apiVersion))
  add(path_594649, "subscriptionId", newJString(subscriptionId))
  add(query_594650, "$top", newJInt(Top))
  add(query_594650, "$filter", newJString(Filter))
  result = call_594648.call(path_594649, query_594650, nil, nil, nil)

var workflowsListByResourceGroup* = Call_WorkflowsListByResourceGroup_594639(
    name: "workflowsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows",
    validator: validate_WorkflowsListByResourceGroup_594640, base: "",
    url: url_WorkflowsListByResourceGroup_594641, schemes: {Scheme.Https})
type
  Call_WorkflowsCreateOrUpdate_594662 = ref object of OpenApiRestCall_593438
proc url_WorkflowsCreateOrUpdate_594664(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsCreateOrUpdate_594663(path: JsonNode; query: JsonNode;
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
  var valid_594665 = path.getOrDefault("workflowName")
  valid_594665 = validateParameter(valid_594665, JString, required = true,
                                 default = nil)
  if valid_594665 != nil:
    section.add "workflowName", valid_594665
  var valid_594666 = path.getOrDefault("resourceGroupName")
  valid_594666 = validateParameter(valid_594666, JString, required = true,
                                 default = nil)
  if valid_594666 != nil:
    section.add "resourceGroupName", valid_594666
  var valid_594667 = path.getOrDefault("subscriptionId")
  valid_594667 = validateParameter(valid_594667, JString, required = true,
                                 default = nil)
  if valid_594667 != nil:
    section.add "subscriptionId", valid_594667
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594668 = query.getOrDefault("api-version")
  valid_594668 = validateParameter(valid_594668, JString, required = true,
                                 default = nil)
  if valid_594668 != nil:
    section.add "api-version", valid_594668
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

proc call*(call_594670: Call_WorkflowsCreateOrUpdate_594662; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a workflow.
  ## 
  let valid = call_594670.validator(path, query, header, formData, body)
  let scheme = call_594670.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594670.url(scheme.get, call_594670.host, call_594670.base,
                         call_594670.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594670, url, valid)

proc call*(call_594671: Call_WorkflowsCreateOrUpdate_594662; workflowName: string;
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
  var path_594672 = newJObject()
  var query_594673 = newJObject()
  var body_594674 = newJObject()
  add(path_594672, "workflowName", newJString(workflowName))
  add(path_594672, "resourceGroupName", newJString(resourceGroupName))
  add(query_594673, "api-version", newJString(apiVersion))
  add(path_594672, "subscriptionId", newJString(subscriptionId))
  if workflow != nil:
    body_594674 = workflow
  result = call_594671.call(path_594672, query_594673, nil, nil, body_594674)

var workflowsCreateOrUpdate* = Call_WorkflowsCreateOrUpdate_594662(
    name: "workflowsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsCreateOrUpdate_594663, base: "",
    url: url_WorkflowsCreateOrUpdate_594664, schemes: {Scheme.Https})
type
  Call_WorkflowsGet_594651 = ref object of OpenApiRestCall_593438
proc url_WorkflowsGet_594653(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsGet_594652(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594654 = path.getOrDefault("workflowName")
  valid_594654 = validateParameter(valid_594654, JString, required = true,
                                 default = nil)
  if valid_594654 != nil:
    section.add "workflowName", valid_594654
  var valid_594655 = path.getOrDefault("resourceGroupName")
  valid_594655 = validateParameter(valid_594655, JString, required = true,
                                 default = nil)
  if valid_594655 != nil:
    section.add "resourceGroupName", valid_594655
  var valid_594656 = path.getOrDefault("subscriptionId")
  valid_594656 = validateParameter(valid_594656, JString, required = true,
                                 default = nil)
  if valid_594656 != nil:
    section.add "subscriptionId", valid_594656
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594657 = query.getOrDefault("api-version")
  valid_594657 = validateParameter(valid_594657, JString, required = true,
                                 default = nil)
  if valid_594657 != nil:
    section.add "api-version", valid_594657
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594658: Call_WorkflowsGet_594651; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow.
  ## 
  let valid = call_594658.validator(path, query, header, formData, body)
  let scheme = call_594658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594658.url(scheme.get, call_594658.host, call_594658.base,
                         call_594658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594658, url, valid)

proc call*(call_594659: Call_WorkflowsGet_594651; workflowName: string;
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
  var path_594660 = newJObject()
  var query_594661 = newJObject()
  add(path_594660, "workflowName", newJString(workflowName))
  add(path_594660, "resourceGroupName", newJString(resourceGroupName))
  add(query_594661, "api-version", newJString(apiVersion))
  add(path_594660, "subscriptionId", newJString(subscriptionId))
  result = call_594659.call(path_594660, query_594661, nil, nil, nil)

var workflowsGet* = Call_WorkflowsGet_594651(name: "workflowsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsGet_594652, base: "", url: url_WorkflowsGet_594653,
    schemes: {Scheme.Https})
type
  Call_WorkflowsUpdate_594686 = ref object of OpenApiRestCall_593438
proc url_WorkflowsUpdate_594688(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsUpdate_594687(path: JsonNode; query: JsonNode;
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
  var valid_594689 = path.getOrDefault("workflowName")
  valid_594689 = validateParameter(valid_594689, JString, required = true,
                                 default = nil)
  if valid_594689 != nil:
    section.add "workflowName", valid_594689
  var valid_594690 = path.getOrDefault("resourceGroupName")
  valid_594690 = validateParameter(valid_594690, JString, required = true,
                                 default = nil)
  if valid_594690 != nil:
    section.add "resourceGroupName", valid_594690
  var valid_594691 = path.getOrDefault("subscriptionId")
  valid_594691 = validateParameter(valid_594691, JString, required = true,
                                 default = nil)
  if valid_594691 != nil:
    section.add "subscriptionId", valid_594691
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594692 = query.getOrDefault("api-version")
  valid_594692 = validateParameter(valid_594692, JString, required = true,
                                 default = nil)
  if valid_594692 != nil:
    section.add "api-version", valid_594692
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

proc call*(call_594694: Call_WorkflowsUpdate_594686; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a workflow.
  ## 
  let valid = call_594694.validator(path, query, header, formData, body)
  let scheme = call_594694.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594694.url(scheme.get, call_594694.host, call_594694.base,
                         call_594694.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594694, url, valid)

proc call*(call_594695: Call_WorkflowsUpdate_594686; workflowName: string;
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
  var path_594696 = newJObject()
  var query_594697 = newJObject()
  var body_594698 = newJObject()
  add(path_594696, "workflowName", newJString(workflowName))
  add(path_594696, "resourceGroupName", newJString(resourceGroupName))
  add(query_594697, "api-version", newJString(apiVersion))
  add(path_594696, "subscriptionId", newJString(subscriptionId))
  if workflow != nil:
    body_594698 = workflow
  result = call_594695.call(path_594696, query_594697, nil, nil, body_594698)

var workflowsUpdate* = Call_WorkflowsUpdate_594686(name: "workflowsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsUpdate_594687, base: "", url: url_WorkflowsUpdate_594688,
    schemes: {Scheme.Https})
type
  Call_WorkflowsDelete_594675 = ref object of OpenApiRestCall_593438
proc url_WorkflowsDelete_594677(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsDelete_594676(path: JsonNode; query: JsonNode;
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
  var valid_594678 = path.getOrDefault("workflowName")
  valid_594678 = validateParameter(valid_594678, JString, required = true,
                                 default = nil)
  if valid_594678 != nil:
    section.add "workflowName", valid_594678
  var valid_594679 = path.getOrDefault("resourceGroupName")
  valid_594679 = validateParameter(valid_594679, JString, required = true,
                                 default = nil)
  if valid_594679 != nil:
    section.add "resourceGroupName", valid_594679
  var valid_594680 = path.getOrDefault("subscriptionId")
  valid_594680 = validateParameter(valid_594680, JString, required = true,
                                 default = nil)
  if valid_594680 != nil:
    section.add "subscriptionId", valid_594680
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594681 = query.getOrDefault("api-version")
  valid_594681 = validateParameter(valid_594681, JString, required = true,
                                 default = nil)
  if valid_594681 != nil:
    section.add "api-version", valid_594681
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594682: Call_WorkflowsDelete_594675; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a workflow.
  ## 
  let valid = call_594682.validator(path, query, header, formData, body)
  let scheme = call_594682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594682.url(scheme.get, call_594682.host, call_594682.base,
                         call_594682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594682, url, valid)

proc call*(call_594683: Call_WorkflowsDelete_594675; workflowName: string;
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
  var path_594684 = newJObject()
  var query_594685 = newJObject()
  add(path_594684, "workflowName", newJString(workflowName))
  add(path_594684, "resourceGroupName", newJString(resourceGroupName))
  add(query_594685, "api-version", newJString(apiVersion))
  add(path_594684, "subscriptionId", newJString(subscriptionId))
  result = call_594683.call(path_594684, query_594685, nil, nil, nil)

var workflowsDelete* = Call_WorkflowsDelete_594675(name: "workflowsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}",
    validator: validate_WorkflowsDelete_594676, base: "", url: url_WorkflowsDelete_594677,
    schemes: {Scheme.Https})
type
  Call_WorkflowsDisable_594699 = ref object of OpenApiRestCall_593438
proc url_WorkflowsDisable_594701(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsDisable_594700(path: JsonNode; query: JsonNode;
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
  var valid_594702 = path.getOrDefault("workflowName")
  valid_594702 = validateParameter(valid_594702, JString, required = true,
                                 default = nil)
  if valid_594702 != nil:
    section.add "workflowName", valid_594702
  var valid_594703 = path.getOrDefault("resourceGroupName")
  valid_594703 = validateParameter(valid_594703, JString, required = true,
                                 default = nil)
  if valid_594703 != nil:
    section.add "resourceGroupName", valid_594703
  var valid_594704 = path.getOrDefault("subscriptionId")
  valid_594704 = validateParameter(valid_594704, JString, required = true,
                                 default = nil)
  if valid_594704 != nil:
    section.add "subscriptionId", valid_594704
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594705 = query.getOrDefault("api-version")
  valid_594705 = validateParameter(valid_594705, JString, required = true,
                                 default = nil)
  if valid_594705 != nil:
    section.add "api-version", valid_594705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594706: Call_WorkflowsDisable_594699; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disables a workflow.
  ## 
  let valid = call_594706.validator(path, query, header, formData, body)
  let scheme = call_594706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594706.url(scheme.get, call_594706.host, call_594706.base,
                         call_594706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594706, url, valid)

proc call*(call_594707: Call_WorkflowsDisable_594699; workflowName: string;
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
  var path_594708 = newJObject()
  var query_594709 = newJObject()
  add(path_594708, "workflowName", newJString(workflowName))
  add(path_594708, "resourceGroupName", newJString(resourceGroupName))
  add(query_594709, "api-version", newJString(apiVersion))
  add(path_594708, "subscriptionId", newJString(subscriptionId))
  result = call_594707.call(path_594708, query_594709, nil, nil, nil)

var workflowsDisable* = Call_WorkflowsDisable_594699(name: "workflowsDisable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/disable",
    validator: validate_WorkflowsDisable_594700, base: "",
    url: url_WorkflowsDisable_594701, schemes: {Scheme.Https})
type
  Call_WorkflowsEnable_594710 = ref object of OpenApiRestCall_593438
proc url_WorkflowsEnable_594712(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsEnable_594711(path: JsonNode; query: JsonNode;
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
  var valid_594713 = path.getOrDefault("workflowName")
  valid_594713 = validateParameter(valid_594713, JString, required = true,
                                 default = nil)
  if valid_594713 != nil:
    section.add "workflowName", valid_594713
  var valid_594714 = path.getOrDefault("resourceGroupName")
  valid_594714 = validateParameter(valid_594714, JString, required = true,
                                 default = nil)
  if valid_594714 != nil:
    section.add "resourceGroupName", valid_594714
  var valid_594715 = path.getOrDefault("subscriptionId")
  valid_594715 = validateParameter(valid_594715, JString, required = true,
                                 default = nil)
  if valid_594715 != nil:
    section.add "subscriptionId", valid_594715
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594716 = query.getOrDefault("api-version")
  valid_594716 = validateParameter(valid_594716, JString, required = true,
                                 default = nil)
  if valid_594716 != nil:
    section.add "api-version", valid_594716
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594717: Call_WorkflowsEnable_594710; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables a workflow.
  ## 
  let valid = call_594717.validator(path, query, header, formData, body)
  let scheme = call_594717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594717.url(scheme.get, call_594717.host, call_594717.base,
                         call_594717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594717, url, valid)

proc call*(call_594718: Call_WorkflowsEnable_594710; workflowName: string;
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
  var path_594719 = newJObject()
  var query_594720 = newJObject()
  add(path_594719, "workflowName", newJString(workflowName))
  add(path_594719, "resourceGroupName", newJString(resourceGroupName))
  add(query_594720, "api-version", newJString(apiVersion))
  add(path_594719, "subscriptionId", newJString(subscriptionId))
  result = call_594718.call(path_594719, query_594720, nil, nil, nil)

var workflowsEnable* = Call_WorkflowsEnable_594710(name: "workflowsEnable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/enable",
    validator: validate_WorkflowsEnable_594711, base: "", url: url_WorkflowsEnable_594712,
    schemes: {Scheme.Https})
type
  Call_WorkflowsGenerateUpgradedDefinition_594721 = ref object of OpenApiRestCall_593438
proc url_WorkflowsGenerateUpgradedDefinition_594723(protocol: Scheme; host: string;
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

proc validate_WorkflowsGenerateUpgradedDefinition_594722(path: JsonNode;
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
  var valid_594724 = path.getOrDefault("workflowName")
  valid_594724 = validateParameter(valid_594724, JString, required = true,
                                 default = nil)
  if valid_594724 != nil:
    section.add "workflowName", valid_594724
  var valid_594725 = path.getOrDefault("resourceGroupName")
  valid_594725 = validateParameter(valid_594725, JString, required = true,
                                 default = nil)
  if valid_594725 != nil:
    section.add "resourceGroupName", valid_594725
  var valid_594726 = path.getOrDefault("subscriptionId")
  valid_594726 = validateParameter(valid_594726, JString, required = true,
                                 default = nil)
  if valid_594726 != nil:
    section.add "subscriptionId", valid_594726
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594727 = query.getOrDefault("api-version")
  valid_594727 = validateParameter(valid_594727, JString, required = true,
                                 default = nil)
  if valid_594727 != nil:
    section.add "api-version", valid_594727
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

proc call*(call_594729: Call_WorkflowsGenerateUpgradedDefinition_594721;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates the upgraded definition for a workflow.
  ## 
  let valid = call_594729.validator(path, query, header, formData, body)
  let scheme = call_594729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594729.url(scheme.get, call_594729.host, call_594729.base,
                         call_594729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594729, url, valid)

proc call*(call_594730: Call_WorkflowsGenerateUpgradedDefinition_594721;
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
  var path_594731 = newJObject()
  var query_594732 = newJObject()
  var body_594733 = newJObject()
  add(path_594731, "workflowName", newJString(workflowName))
  add(path_594731, "resourceGroupName", newJString(resourceGroupName))
  add(query_594732, "api-version", newJString(apiVersion))
  add(path_594731, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594733 = parameters
  result = call_594730.call(path_594731, query_594732, nil, nil, body_594733)

var workflowsGenerateUpgradedDefinition* = Call_WorkflowsGenerateUpgradedDefinition_594721(
    name: "workflowsGenerateUpgradedDefinition", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/generateUpgradedDefinition",
    validator: validate_WorkflowsGenerateUpgradedDefinition_594722, base: "",
    url: url_WorkflowsGenerateUpgradedDefinition_594723, schemes: {Scheme.Https})
type
  Call_WorkflowsListCallbackUrl_594734 = ref object of OpenApiRestCall_593438
proc url_WorkflowsListCallbackUrl_594736(protocol: Scheme; host: string;
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

proc validate_WorkflowsListCallbackUrl_594735(path: JsonNode; query: JsonNode;
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
  var valid_594737 = path.getOrDefault("workflowName")
  valid_594737 = validateParameter(valid_594737, JString, required = true,
                                 default = nil)
  if valid_594737 != nil:
    section.add "workflowName", valid_594737
  var valid_594738 = path.getOrDefault("resourceGroupName")
  valid_594738 = validateParameter(valid_594738, JString, required = true,
                                 default = nil)
  if valid_594738 != nil:
    section.add "resourceGroupName", valid_594738
  var valid_594739 = path.getOrDefault("subscriptionId")
  valid_594739 = validateParameter(valid_594739, JString, required = true,
                                 default = nil)
  if valid_594739 != nil:
    section.add "subscriptionId", valid_594739
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594740 = query.getOrDefault("api-version")
  valid_594740 = validateParameter(valid_594740, JString, required = true,
                                 default = nil)
  if valid_594740 != nil:
    section.add "api-version", valid_594740
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

proc call*(call_594742: Call_WorkflowsListCallbackUrl_594734; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the workflow callback Url.
  ## 
  let valid = call_594742.validator(path, query, header, formData, body)
  let scheme = call_594742.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594742.url(scheme.get, call_594742.host, call_594742.base,
                         call_594742.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594742, url, valid)

proc call*(call_594743: Call_WorkflowsListCallbackUrl_594734; workflowName: string;
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
  var path_594744 = newJObject()
  var query_594745 = newJObject()
  var body_594746 = newJObject()
  add(path_594744, "workflowName", newJString(workflowName))
  add(path_594744, "resourceGroupName", newJString(resourceGroupName))
  add(query_594745, "api-version", newJString(apiVersion))
  if listCallbackUrl != nil:
    body_594746 = listCallbackUrl
  add(path_594744, "subscriptionId", newJString(subscriptionId))
  result = call_594743.call(path_594744, query_594745, nil, nil, body_594746)

var workflowsListCallbackUrl* = Call_WorkflowsListCallbackUrl_594734(
    name: "workflowsListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/listCallbackUrl",
    validator: validate_WorkflowsListCallbackUrl_594735, base: "",
    url: url_WorkflowsListCallbackUrl_594736, schemes: {Scheme.Https})
type
  Call_WorkflowsListSwagger_594747 = ref object of OpenApiRestCall_593438
proc url_WorkflowsListSwagger_594749(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsListSwagger_594748(path: JsonNode; query: JsonNode;
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
  var valid_594750 = path.getOrDefault("workflowName")
  valid_594750 = validateParameter(valid_594750, JString, required = true,
                                 default = nil)
  if valid_594750 != nil:
    section.add "workflowName", valid_594750
  var valid_594751 = path.getOrDefault("resourceGroupName")
  valid_594751 = validateParameter(valid_594751, JString, required = true,
                                 default = nil)
  if valid_594751 != nil:
    section.add "resourceGroupName", valid_594751
  var valid_594752 = path.getOrDefault("subscriptionId")
  valid_594752 = validateParameter(valid_594752, JString, required = true,
                                 default = nil)
  if valid_594752 != nil:
    section.add "subscriptionId", valid_594752
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594753 = query.getOrDefault("api-version")
  valid_594753 = validateParameter(valid_594753, JString, required = true,
                                 default = nil)
  if valid_594753 != nil:
    section.add "api-version", valid_594753
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594754: Call_WorkflowsListSwagger_594747; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an OpenAPI definition for the workflow.
  ## 
  let valid = call_594754.validator(path, query, header, formData, body)
  let scheme = call_594754.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594754.url(scheme.get, call_594754.host, call_594754.base,
                         call_594754.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594754, url, valid)

proc call*(call_594755: Call_WorkflowsListSwagger_594747; workflowName: string;
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
  var path_594756 = newJObject()
  var query_594757 = newJObject()
  add(path_594756, "workflowName", newJString(workflowName))
  add(path_594756, "resourceGroupName", newJString(resourceGroupName))
  add(query_594757, "api-version", newJString(apiVersion))
  add(path_594756, "subscriptionId", newJString(subscriptionId))
  result = call_594755.call(path_594756, query_594757, nil, nil, nil)

var workflowsListSwagger* = Call_WorkflowsListSwagger_594747(
    name: "workflowsListSwagger", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/listSwagger",
    validator: validate_WorkflowsListSwagger_594748, base: "",
    url: url_WorkflowsListSwagger_594749, schemes: {Scheme.Https})
type
  Call_WorkflowsMove_594758 = ref object of OpenApiRestCall_593438
proc url_WorkflowsMove_594760(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsMove_594759(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594761 = path.getOrDefault("workflowName")
  valid_594761 = validateParameter(valid_594761, JString, required = true,
                                 default = nil)
  if valid_594761 != nil:
    section.add "workflowName", valid_594761
  var valid_594762 = path.getOrDefault("resourceGroupName")
  valid_594762 = validateParameter(valid_594762, JString, required = true,
                                 default = nil)
  if valid_594762 != nil:
    section.add "resourceGroupName", valid_594762
  var valid_594763 = path.getOrDefault("subscriptionId")
  valid_594763 = validateParameter(valid_594763, JString, required = true,
                                 default = nil)
  if valid_594763 != nil:
    section.add "subscriptionId", valid_594763
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594764 = query.getOrDefault("api-version")
  valid_594764 = validateParameter(valid_594764, JString, required = true,
                                 default = nil)
  if valid_594764 != nil:
    section.add "api-version", valid_594764
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

proc call*(call_594766: Call_WorkflowsMove_594758; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves an existing workflow.
  ## 
  let valid = call_594766.validator(path, query, header, formData, body)
  let scheme = call_594766.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594766.url(scheme.get, call_594766.host, call_594766.base,
                         call_594766.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594766, url, valid)

proc call*(call_594767: Call_WorkflowsMove_594758; workflowName: string;
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
  var path_594768 = newJObject()
  var query_594769 = newJObject()
  var body_594770 = newJObject()
  add(path_594768, "workflowName", newJString(workflowName))
  if move != nil:
    body_594770 = move
  add(path_594768, "resourceGroupName", newJString(resourceGroupName))
  add(query_594769, "api-version", newJString(apiVersion))
  add(path_594768, "subscriptionId", newJString(subscriptionId))
  result = call_594767.call(path_594768, query_594769, nil, nil, body_594770)

var workflowsMove* = Call_WorkflowsMove_594758(name: "workflowsMove",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/move",
    validator: validate_WorkflowsMove_594759, base: "", url: url_WorkflowsMove_594760,
    schemes: {Scheme.Https})
type
  Call_WorkflowsRegenerateAccessKey_594771 = ref object of OpenApiRestCall_593438
proc url_WorkflowsRegenerateAccessKey_594773(protocol: Scheme; host: string;
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

proc validate_WorkflowsRegenerateAccessKey_594772(path: JsonNode; query: JsonNode;
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
  var valid_594774 = path.getOrDefault("workflowName")
  valid_594774 = validateParameter(valid_594774, JString, required = true,
                                 default = nil)
  if valid_594774 != nil:
    section.add "workflowName", valid_594774
  var valid_594775 = path.getOrDefault("resourceGroupName")
  valid_594775 = validateParameter(valid_594775, JString, required = true,
                                 default = nil)
  if valid_594775 != nil:
    section.add "resourceGroupName", valid_594775
  var valid_594776 = path.getOrDefault("subscriptionId")
  valid_594776 = validateParameter(valid_594776, JString, required = true,
                                 default = nil)
  if valid_594776 != nil:
    section.add "subscriptionId", valid_594776
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594777 = query.getOrDefault("api-version")
  valid_594777 = validateParameter(valid_594777, JString, required = true,
                                 default = nil)
  if valid_594777 != nil:
    section.add "api-version", valid_594777
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

proc call*(call_594779: Call_WorkflowsRegenerateAccessKey_594771; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the callback URL access key for request triggers.
  ## 
  let valid = call_594779.validator(path, query, header, formData, body)
  let scheme = call_594779.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594779.url(scheme.get, call_594779.host, call_594779.base,
                         call_594779.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594779, url, valid)

proc call*(call_594780: Call_WorkflowsRegenerateAccessKey_594771;
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
  var path_594781 = newJObject()
  var query_594782 = newJObject()
  var body_594783 = newJObject()
  add(path_594781, "workflowName", newJString(workflowName))
  add(path_594781, "resourceGroupName", newJString(resourceGroupName))
  add(query_594782, "api-version", newJString(apiVersion))
  add(path_594781, "subscriptionId", newJString(subscriptionId))
  if keyType != nil:
    body_594783 = keyType
  result = call_594780.call(path_594781, query_594782, nil, nil, body_594783)

var workflowsRegenerateAccessKey* = Call_WorkflowsRegenerateAccessKey_594771(
    name: "workflowsRegenerateAccessKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/regenerateAccessKey",
    validator: validate_WorkflowsRegenerateAccessKey_594772, base: "",
    url: url_WorkflowsRegenerateAccessKey_594773, schemes: {Scheme.Https})
type
  Call_WorkflowRunsList_594784 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunsList_594786(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsList_594785(path: JsonNode; query: JsonNode;
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
  var valid_594787 = path.getOrDefault("workflowName")
  valid_594787 = validateParameter(valid_594787, JString, required = true,
                                 default = nil)
  if valid_594787 != nil:
    section.add "workflowName", valid_594787
  var valid_594788 = path.getOrDefault("resourceGroupName")
  valid_594788 = validateParameter(valid_594788, JString, required = true,
                                 default = nil)
  if valid_594788 != nil:
    section.add "resourceGroupName", valid_594788
  var valid_594789 = path.getOrDefault("subscriptionId")
  valid_594789 = validateParameter(valid_594789, JString, required = true,
                                 default = nil)
  if valid_594789 != nil:
    section.add "subscriptionId", valid_594789
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
  var valid_594790 = query.getOrDefault("api-version")
  valid_594790 = validateParameter(valid_594790, JString, required = true,
                                 default = nil)
  if valid_594790 != nil:
    section.add "api-version", valid_594790
  var valid_594791 = query.getOrDefault("$top")
  valid_594791 = validateParameter(valid_594791, JInt, required = false, default = nil)
  if valid_594791 != nil:
    section.add "$top", valid_594791
  var valid_594792 = query.getOrDefault("$filter")
  valid_594792 = validateParameter(valid_594792, JString, required = false,
                                 default = nil)
  if valid_594792 != nil:
    section.add "$filter", valid_594792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594793: Call_WorkflowRunsList_594784; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow runs.
  ## 
  let valid = call_594793.validator(path, query, header, formData, body)
  let scheme = call_594793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594793.url(scheme.get, call_594793.host, call_594793.base,
                         call_594793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594793, url, valid)

proc call*(call_594794: Call_WorkflowRunsList_594784; workflowName: string;
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
  var path_594795 = newJObject()
  var query_594796 = newJObject()
  add(path_594795, "workflowName", newJString(workflowName))
  add(path_594795, "resourceGroupName", newJString(resourceGroupName))
  add(query_594796, "api-version", newJString(apiVersion))
  add(path_594795, "subscriptionId", newJString(subscriptionId))
  add(query_594796, "$top", newJInt(Top))
  add(query_594796, "$filter", newJString(Filter))
  result = call_594794.call(path_594795, query_594796, nil, nil, nil)

var workflowRunsList* = Call_WorkflowRunsList_594784(name: "workflowRunsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs",
    validator: validate_WorkflowRunsList_594785, base: "",
    url: url_WorkflowRunsList_594786, schemes: {Scheme.Https})
type
  Call_WorkflowRunsGet_594797 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunsGet_594799(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsGet_594798(path: JsonNode; query: JsonNode;
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
  var valid_594800 = path.getOrDefault("workflowName")
  valid_594800 = validateParameter(valid_594800, JString, required = true,
                                 default = nil)
  if valid_594800 != nil:
    section.add "workflowName", valid_594800
  var valid_594801 = path.getOrDefault("resourceGroupName")
  valid_594801 = validateParameter(valid_594801, JString, required = true,
                                 default = nil)
  if valid_594801 != nil:
    section.add "resourceGroupName", valid_594801
  var valid_594802 = path.getOrDefault("runName")
  valid_594802 = validateParameter(valid_594802, JString, required = true,
                                 default = nil)
  if valid_594802 != nil:
    section.add "runName", valid_594802
  var valid_594803 = path.getOrDefault("subscriptionId")
  valid_594803 = validateParameter(valid_594803, JString, required = true,
                                 default = nil)
  if valid_594803 != nil:
    section.add "subscriptionId", valid_594803
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594804 = query.getOrDefault("api-version")
  valid_594804 = validateParameter(valid_594804, JString, required = true,
                                 default = nil)
  if valid_594804 != nil:
    section.add "api-version", valid_594804
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594805: Call_WorkflowRunsGet_594797; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow run.
  ## 
  let valid = call_594805.validator(path, query, header, formData, body)
  let scheme = call_594805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594805.url(scheme.get, call_594805.host, call_594805.base,
                         call_594805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594805, url, valid)

proc call*(call_594806: Call_WorkflowRunsGet_594797; workflowName: string;
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
  var path_594807 = newJObject()
  var query_594808 = newJObject()
  add(path_594807, "workflowName", newJString(workflowName))
  add(path_594807, "resourceGroupName", newJString(resourceGroupName))
  add(path_594807, "runName", newJString(runName))
  add(query_594808, "api-version", newJString(apiVersion))
  add(path_594807, "subscriptionId", newJString(subscriptionId))
  result = call_594806.call(path_594807, query_594808, nil, nil, nil)

var workflowRunsGet* = Call_WorkflowRunsGet_594797(name: "workflowRunsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}",
    validator: validate_WorkflowRunsGet_594798, base: "", url: url_WorkflowRunsGet_594799,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunsDelete_594809 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunsDelete_594811(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsDelete_594810(path: JsonNode; query: JsonNode;
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
  var valid_594812 = path.getOrDefault("workflowName")
  valid_594812 = validateParameter(valid_594812, JString, required = true,
                                 default = nil)
  if valid_594812 != nil:
    section.add "workflowName", valid_594812
  var valid_594813 = path.getOrDefault("resourceGroupName")
  valid_594813 = validateParameter(valid_594813, JString, required = true,
                                 default = nil)
  if valid_594813 != nil:
    section.add "resourceGroupName", valid_594813
  var valid_594814 = path.getOrDefault("runName")
  valid_594814 = validateParameter(valid_594814, JString, required = true,
                                 default = nil)
  if valid_594814 != nil:
    section.add "runName", valid_594814
  var valid_594815 = path.getOrDefault("subscriptionId")
  valid_594815 = validateParameter(valid_594815, JString, required = true,
                                 default = nil)
  if valid_594815 != nil:
    section.add "subscriptionId", valid_594815
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594816 = query.getOrDefault("api-version")
  valid_594816 = validateParameter(valid_594816, JString, required = true,
                                 default = nil)
  if valid_594816 != nil:
    section.add "api-version", valid_594816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594817: Call_WorkflowRunsDelete_594809; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a workflow run.
  ## 
  let valid = call_594817.validator(path, query, header, formData, body)
  let scheme = call_594817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594817.url(scheme.get, call_594817.host, call_594817.base,
                         call_594817.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594817, url, valid)

proc call*(call_594818: Call_WorkflowRunsDelete_594809; workflowName: string;
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
  var path_594819 = newJObject()
  var query_594820 = newJObject()
  add(path_594819, "workflowName", newJString(workflowName))
  add(path_594819, "resourceGroupName", newJString(resourceGroupName))
  add(path_594819, "runName", newJString(runName))
  add(query_594820, "api-version", newJString(apiVersion))
  add(path_594819, "subscriptionId", newJString(subscriptionId))
  result = call_594818.call(path_594819, query_594820, nil, nil, nil)

var workflowRunsDelete* = Call_WorkflowRunsDelete_594809(
    name: "workflowRunsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}",
    validator: validate_WorkflowRunsDelete_594810, base: "",
    url: url_WorkflowRunsDelete_594811, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsList_594821 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunActionsList_594823(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunActionsList_594822(path: JsonNode; query: JsonNode;
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
  var valid_594824 = path.getOrDefault("workflowName")
  valid_594824 = validateParameter(valid_594824, JString, required = true,
                                 default = nil)
  if valid_594824 != nil:
    section.add "workflowName", valid_594824
  var valid_594825 = path.getOrDefault("resourceGroupName")
  valid_594825 = validateParameter(valid_594825, JString, required = true,
                                 default = nil)
  if valid_594825 != nil:
    section.add "resourceGroupName", valid_594825
  var valid_594826 = path.getOrDefault("runName")
  valid_594826 = validateParameter(valid_594826, JString, required = true,
                                 default = nil)
  if valid_594826 != nil:
    section.add "runName", valid_594826
  var valid_594827 = path.getOrDefault("subscriptionId")
  valid_594827 = validateParameter(valid_594827, JString, required = true,
                                 default = nil)
  if valid_594827 != nil:
    section.add "subscriptionId", valid_594827
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
  var valid_594828 = query.getOrDefault("api-version")
  valid_594828 = validateParameter(valid_594828, JString, required = true,
                                 default = nil)
  if valid_594828 != nil:
    section.add "api-version", valid_594828
  var valid_594829 = query.getOrDefault("$top")
  valid_594829 = validateParameter(valid_594829, JInt, required = false, default = nil)
  if valid_594829 != nil:
    section.add "$top", valid_594829
  var valid_594830 = query.getOrDefault("$filter")
  valid_594830 = validateParameter(valid_594830, JString, required = false,
                                 default = nil)
  if valid_594830 != nil:
    section.add "$filter", valid_594830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594831: Call_WorkflowRunActionsList_594821; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow run actions.
  ## 
  let valid = call_594831.validator(path, query, header, formData, body)
  let scheme = call_594831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594831.url(scheme.get, call_594831.host, call_594831.base,
                         call_594831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594831, url, valid)

proc call*(call_594832: Call_WorkflowRunActionsList_594821; workflowName: string;
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
  var path_594833 = newJObject()
  var query_594834 = newJObject()
  add(path_594833, "workflowName", newJString(workflowName))
  add(path_594833, "resourceGroupName", newJString(resourceGroupName))
  add(path_594833, "runName", newJString(runName))
  add(query_594834, "api-version", newJString(apiVersion))
  add(path_594833, "subscriptionId", newJString(subscriptionId))
  add(query_594834, "$top", newJInt(Top))
  add(query_594834, "$filter", newJString(Filter))
  result = call_594832.call(path_594833, query_594834, nil, nil, nil)

var workflowRunActionsList* = Call_WorkflowRunActionsList_594821(
    name: "workflowRunActionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions",
    validator: validate_WorkflowRunActionsList_594822, base: "",
    url: url_WorkflowRunActionsList_594823, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsGet_594835 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunActionsGet_594837(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunActionsGet_594836(path: JsonNode; query: JsonNode;
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
  var valid_594838 = path.getOrDefault("workflowName")
  valid_594838 = validateParameter(valid_594838, JString, required = true,
                                 default = nil)
  if valid_594838 != nil:
    section.add "workflowName", valid_594838
  var valid_594839 = path.getOrDefault("actionName")
  valid_594839 = validateParameter(valid_594839, JString, required = true,
                                 default = nil)
  if valid_594839 != nil:
    section.add "actionName", valid_594839
  var valid_594840 = path.getOrDefault("resourceGroupName")
  valid_594840 = validateParameter(valid_594840, JString, required = true,
                                 default = nil)
  if valid_594840 != nil:
    section.add "resourceGroupName", valid_594840
  var valid_594841 = path.getOrDefault("runName")
  valid_594841 = validateParameter(valid_594841, JString, required = true,
                                 default = nil)
  if valid_594841 != nil:
    section.add "runName", valid_594841
  var valid_594842 = path.getOrDefault("subscriptionId")
  valid_594842 = validateParameter(valid_594842, JString, required = true,
                                 default = nil)
  if valid_594842 != nil:
    section.add "subscriptionId", valid_594842
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594843 = query.getOrDefault("api-version")
  valid_594843 = validateParameter(valid_594843, JString, required = true,
                                 default = nil)
  if valid_594843 != nil:
    section.add "api-version", valid_594843
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594844: Call_WorkflowRunActionsGet_594835; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow run action.
  ## 
  let valid = call_594844.validator(path, query, header, formData, body)
  let scheme = call_594844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594844.url(scheme.get, call_594844.host, call_594844.base,
                         call_594844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594844, url, valid)

proc call*(call_594845: Call_WorkflowRunActionsGet_594835; workflowName: string;
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
  var path_594846 = newJObject()
  var query_594847 = newJObject()
  add(path_594846, "workflowName", newJString(workflowName))
  add(path_594846, "actionName", newJString(actionName))
  add(path_594846, "resourceGroupName", newJString(resourceGroupName))
  add(path_594846, "runName", newJString(runName))
  add(query_594847, "api-version", newJString(apiVersion))
  add(path_594846, "subscriptionId", newJString(subscriptionId))
  result = call_594845.call(path_594846, query_594847, nil, nil, nil)

var workflowRunActionsGet* = Call_WorkflowRunActionsGet_594835(
    name: "workflowRunActionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}",
    validator: validate_WorkflowRunActionsGet_594836, base: "",
    url: url_WorkflowRunActionsGet_594837, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionsListExpressionTraces_594848 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunActionsListExpressionTraces_594850(protocol: Scheme;
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

proc validate_WorkflowRunActionsListExpressionTraces_594849(path: JsonNode;
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
  var valid_594851 = path.getOrDefault("workflowName")
  valid_594851 = validateParameter(valid_594851, JString, required = true,
                                 default = nil)
  if valid_594851 != nil:
    section.add "workflowName", valid_594851
  var valid_594852 = path.getOrDefault("actionName")
  valid_594852 = validateParameter(valid_594852, JString, required = true,
                                 default = nil)
  if valid_594852 != nil:
    section.add "actionName", valid_594852
  var valid_594853 = path.getOrDefault("resourceGroupName")
  valid_594853 = validateParameter(valid_594853, JString, required = true,
                                 default = nil)
  if valid_594853 != nil:
    section.add "resourceGroupName", valid_594853
  var valid_594854 = path.getOrDefault("runName")
  valid_594854 = validateParameter(valid_594854, JString, required = true,
                                 default = nil)
  if valid_594854 != nil:
    section.add "runName", valid_594854
  var valid_594855 = path.getOrDefault("subscriptionId")
  valid_594855 = validateParameter(valid_594855, JString, required = true,
                                 default = nil)
  if valid_594855 != nil:
    section.add "subscriptionId", valid_594855
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594856 = query.getOrDefault("api-version")
  valid_594856 = validateParameter(valid_594856, JString, required = true,
                                 default = nil)
  if valid_594856 != nil:
    section.add "api-version", valid_594856
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594857: Call_WorkflowRunActionsListExpressionTraces_594848;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a workflow run expression trace.
  ## 
  let valid = call_594857.validator(path, query, header, formData, body)
  let scheme = call_594857.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594857.url(scheme.get, call_594857.host, call_594857.base,
                         call_594857.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594857, url, valid)

proc call*(call_594858: Call_WorkflowRunActionsListExpressionTraces_594848;
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
  var path_594859 = newJObject()
  var query_594860 = newJObject()
  add(path_594859, "workflowName", newJString(workflowName))
  add(path_594859, "actionName", newJString(actionName))
  add(path_594859, "resourceGroupName", newJString(resourceGroupName))
  add(path_594859, "runName", newJString(runName))
  add(query_594860, "api-version", newJString(apiVersion))
  add(path_594859, "subscriptionId", newJString(subscriptionId))
  result = call_594858.call(path_594859, query_594860, nil, nil, nil)

var workflowRunActionsListExpressionTraces* = Call_WorkflowRunActionsListExpressionTraces_594848(
    name: "workflowRunActionsListExpressionTraces", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/listExpressionTraces",
    validator: validate_WorkflowRunActionsListExpressionTraces_594849, base: "",
    url: url_WorkflowRunActionsListExpressionTraces_594850,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsList_594861 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunActionRepetitionsList_594863(protocol: Scheme; host: string;
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

proc validate_WorkflowRunActionRepetitionsList_594862(path: JsonNode;
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
  var valid_594864 = path.getOrDefault("workflowName")
  valid_594864 = validateParameter(valid_594864, JString, required = true,
                                 default = nil)
  if valid_594864 != nil:
    section.add "workflowName", valid_594864
  var valid_594865 = path.getOrDefault("actionName")
  valid_594865 = validateParameter(valid_594865, JString, required = true,
                                 default = nil)
  if valid_594865 != nil:
    section.add "actionName", valid_594865
  var valid_594866 = path.getOrDefault("resourceGroupName")
  valid_594866 = validateParameter(valid_594866, JString, required = true,
                                 default = nil)
  if valid_594866 != nil:
    section.add "resourceGroupName", valid_594866
  var valid_594867 = path.getOrDefault("runName")
  valid_594867 = validateParameter(valid_594867, JString, required = true,
                                 default = nil)
  if valid_594867 != nil:
    section.add "runName", valid_594867
  var valid_594868 = path.getOrDefault("subscriptionId")
  valid_594868 = validateParameter(valid_594868, JString, required = true,
                                 default = nil)
  if valid_594868 != nil:
    section.add "subscriptionId", valid_594868
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594869 = query.getOrDefault("api-version")
  valid_594869 = validateParameter(valid_594869, JString, required = true,
                                 default = nil)
  if valid_594869 != nil:
    section.add "api-version", valid_594869
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594870: Call_WorkflowRunActionRepetitionsList_594861;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all of a workflow run action repetitions.
  ## 
  let valid = call_594870.validator(path, query, header, formData, body)
  let scheme = call_594870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594870.url(scheme.get, call_594870.host, call_594870.base,
                         call_594870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594870, url, valid)

proc call*(call_594871: Call_WorkflowRunActionRepetitionsList_594861;
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
  var path_594872 = newJObject()
  var query_594873 = newJObject()
  add(path_594872, "workflowName", newJString(workflowName))
  add(path_594872, "actionName", newJString(actionName))
  add(path_594872, "resourceGroupName", newJString(resourceGroupName))
  add(path_594872, "runName", newJString(runName))
  add(query_594873, "api-version", newJString(apiVersion))
  add(path_594872, "subscriptionId", newJString(subscriptionId))
  result = call_594871.call(path_594872, query_594873, nil, nil, nil)

var workflowRunActionRepetitionsList* = Call_WorkflowRunActionRepetitionsList_594861(
    name: "workflowRunActionRepetitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions",
    validator: validate_WorkflowRunActionRepetitionsList_594862, base: "",
    url: url_WorkflowRunActionRepetitionsList_594863, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsGet_594874 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunActionRepetitionsGet_594876(protocol: Scheme; host: string;
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

proc validate_WorkflowRunActionRepetitionsGet_594875(path: JsonNode;
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
  var valid_594877 = path.getOrDefault("workflowName")
  valid_594877 = validateParameter(valid_594877, JString, required = true,
                                 default = nil)
  if valid_594877 != nil:
    section.add "workflowName", valid_594877
  var valid_594878 = path.getOrDefault("actionName")
  valid_594878 = validateParameter(valid_594878, JString, required = true,
                                 default = nil)
  if valid_594878 != nil:
    section.add "actionName", valid_594878
  var valid_594879 = path.getOrDefault("resourceGroupName")
  valid_594879 = validateParameter(valid_594879, JString, required = true,
                                 default = nil)
  if valid_594879 != nil:
    section.add "resourceGroupName", valid_594879
  var valid_594880 = path.getOrDefault("runName")
  valid_594880 = validateParameter(valid_594880, JString, required = true,
                                 default = nil)
  if valid_594880 != nil:
    section.add "runName", valid_594880
  var valid_594881 = path.getOrDefault("subscriptionId")
  valid_594881 = validateParameter(valid_594881, JString, required = true,
                                 default = nil)
  if valid_594881 != nil:
    section.add "subscriptionId", valid_594881
  var valid_594882 = path.getOrDefault("repetitionName")
  valid_594882 = validateParameter(valid_594882, JString, required = true,
                                 default = nil)
  if valid_594882 != nil:
    section.add "repetitionName", valid_594882
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594883 = query.getOrDefault("api-version")
  valid_594883 = validateParameter(valid_594883, JString, required = true,
                                 default = nil)
  if valid_594883 != nil:
    section.add "api-version", valid_594883
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594884: Call_WorkflowRunActionRepetitionsGet_594874;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a workflow run action repetition.
  ## 
  let valid = call_594884.validator(path, query, header, formData, body)
  let scheme = call_594884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594884.url(scheme.get, call_594884.host, call_594884.base,
                         call_594884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594884, url, valid)

proc call*(call_594885: Call_WorkflowRunActionRepetitionsGet_594874;
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
  var path_594886 = newJObject()
  var query_594887 = newJObject()
  add(path_594886, "workflowName", newJString(workflowName))
  add(path_594886, "actionName", newJString(actionName))
  add(path_594886, "resourceGroupName", newJString(resourceGroupName))
  add(path_594886, "runName", newJString(runName))
  add(query_594887, "api-version", newJString(apiVersion))
  add(path_594886, "subscriptionId", newJString(subscriptionId))
  add(path_594886, "repetitionName", newJString(repetitionName))
  result = call_594885.call(path_594886, query_594887, nil, nil, nil)

var workflowRunActionRepetitionsGet* = Call_WorkflowRunActionRepetitionsGet_594874(
    name: "workflowRunActionRepetitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}",
    validator: validate_WorkflowRunActionRepetitionsGet_594875, base: "",
    url: url_WorkflowRunActionRepetitionsGet_594876, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsListExpressionTraces_594888 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunActionRepetitionsListExpressionTraces_594890(
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

proc validate_WorkflowRunActionRepetitionsListExpressionTraces_594889(
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
  var valid_594891 = path.getOrDefault("workflowName")
  valid_594891 = validateParameter(valid_594891, JString, required = true,
                                 default = nil)
  if valid_594891 != nil:
    section.add "workflowName", valid_594891
  var valid_594892 = path.getOrDefault("actionName")
  valid_594892 = validateParameter(valid_594892, JString, required = true,
                                 default = nil)
  if valid_594892 != nil:
    section.add "actionName", valid_594892
  var valid_594893 = path.getOrDefault("resourceGroupName")
  valid_594893 = validateParameter(valid_594893, JString, required = true,
                                 default = nil)
  if valid_594893 != nil:
    section.add "resourceGroupName", valid_594893
  var valid_594894 = path.getOrDefault("runName")
  valid_594894 = validateParameter(valid_594894, JString, required = true,
                                 default = nil)
  if valid_594894 != nil:
    section.add "runName", valid_594894
  var valid_594895 = path.getOrDefault("subscriptionId")
  valid_594895 = validateParameter(valid_594895, JString, required = true,
                                 default = nil)
  if valid_594895 != nil:
    section.add "subscriptionId", valid_594895
  var valid_594896 = path.getOrDefault("repetitionName")
  valid_594896 = validateParameter(valid_594896, JString, required = true,
                                 default = nil)
  if valid_594896 != nil:
    section.add "repetitionName", valid_594896
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594897 = query.getOrDefault("api-version")
  valid_594897 = validateParameter(valid_594897, JString, required = true,
                                 default = nil)
  if valid_594897 != nil:
    section.add "api-version", valid_594897
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594898: Call_WorkflowRunActionRepetitionsListExpressionTraces_594888;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a workflow run expression trace.
  ## 
  let valid = call_594898.validator(path, query, header, formData, body)
  let scheme = call_594898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594898.url(scheme.get, call_594898.host, call_594898.base,
                         call_594898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594898, url, valid)

proc call*(call_594899: Call_WorkflowRunActionRepetitionsListExpressionTraces_594888;
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
  var path_594900 = newJObject()
  var query_594901 = newJObject()
  add(path_594900, "workflowName", newJString(workflowName))
  add(path_594900, "actionName", newJString(actionName))
  add(path_594900, "resourceGroupName", newJString(resourceGroupName))
  add(path_594900, "runName", newJString(runName))
  add(query_594901, "api-version", newJString(apiVersion))
  add(path_594900, "subscriptionId", newJString(subscriptionId))
  add(path_594900, "repetitionName", newJString(repetitionName))
  result = call_594899.call(path_594900, query_594901, nil, nil, nil)

var workflowRunActionRepetitionsListExpressionTraces* = Call_WorkflowRunActionRepetitionsListExpressionTraces_594888(
    name: "workflowRunActionRepetitionsListExpressionTraces",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/listExpressionTraces",
    validator: validate_WorkflowRunActionRepetitionsListExpressionTraces_594889,
    base: "", url: url_WorkflowRunActionRepetitionsListExpressionTraces_594890,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsRequestHistoriesList_594902 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunActionRepetitionsRequestHistoriesList_594904(
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

proc validate_WorkflowRunActionRepetitionsRequestHistoriesList_594903(
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
  var valid_594905 = path.getOrDefault("workflowName")
  valid_594905 = validateParameter(valid_594905, JString, required = true,
                                 default = nil)
  if valid_594905 != nil:
    section.add "workflowName", valid_594905
  var valid_594906 = path.getOrDefault("actionName")
  valid_594906 = validateParameter(valid_594906, JString, required = true,
                                 default = nil)
  if valid_594906 != nil:
    section.add "actionName", valid_594906
  var valid_594907 = path.getOrDefault("resourceGroupName")
  valid_594907 = validateParameter(valid_594907, JString, required = true,
                                 default = nil)
  if valid_594907 != nil:
    section.add "resourceGroupName", valid_594907
  var valid_594908 = path.getOrDefault("runName")
  valid_594908 = validateParameter(valid_594908, JString, required = true,
                                 default = nil)
  if valid_594908 != nil:
    section.add "runName", valid_594908
  var valid_594909 = path.getOrDefault("subscriptionId")
  valid_594909 = validateParameter(valid_594909, JString, required = true,
                                 default = nil)
  if valid_594909 != nil:
    section.add "subscriptionId", valid_594909
  var valid_594910 = path.getOrDefault("repetitionName")
  valid_594910 = validateParameter(valid_594910, JString, required = true,
                                 default = nil)
  if valid_594910 != nil:
    section.add "repetitionName", valid_594910
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594911 = query.getOrDefault("api-version")
  valid_594911 = validateParameter(valid_594911, JString, required = true,
                                 default = nil)
  if valid_594911 != nil:
    section.add "api-version", valid_594911
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594912: Call_WorkflowRunActionRepetitionsRequestHistoriesList_594902;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a workflow run repetition request history.
  ## 
  let valid = call_594912.validator(path, query, header, formData, body)
  let scheme = call_594912.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594912.url(scheme.get, call_594912.host, call_594912.base,
                         call_594912.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594912, url, valid)

proc call*(call_594913: Call_WorkflowRunActionRepetitionsRequestHistoriesList_594902;
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
  var path_594914 = newJObject()
  var query_594915 = newJObject()
  add(path_594914, "workflowName", newJString(workflowName))
  add(path_594914, "actionName", newJString(actionName))
  add(path_594914, "resourceGroupName", newJString(resourceGroupName))
  add(path_594914, "runName", newJString(runName))
  add(query_594915, "api-version", newJString(apiVersion))
  add(path_594914, "subscriptionId", newJString(subscriptionId))
  add(path_594914, "repetitionName", newJString(repetitionName))
  result = call_594913.call(path_594914, query_594915, nil, nil, nil)

var workflowRunActionRepetitionsRequestHistoriesList* = Call_WorkflowRunActionRepetitionsRequestHistoriesList_594902(
    name: "workflowRunActionRepetitionsRequestHistoriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/requestHistories",
    validator: validate_WorkflowRunActionRepetitionsRequestHistoriesList_594903,
    base: "", url: url_WorkflowRunActionRepetitionsRequestHistoriesList_594904,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRepetitionsRequestHistoriesGet_594916 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunActionRepetitionsRequestHistoriesGet_594918(protocol: Scheme;
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

proc validate_WorkflowRunActionRepetitionsRequestHistoriesGet_594917(
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
  var valid_594919 = path.getOrDefault("workflowName")
  valid_594919 = validateParameter(valid_594919, JString, required = true,
                                 default = nil)
  if valid_594919 != nil:
    section.add "workflowName", valid_594919
  var valid_594920 = path.getOrDefault("actionName")
  valid_594920 = validateParameter(valid_594920, JString, required = true,
                                 default = nil)
  if valid_594920 != nil:
    section.add "actionName", valid_594920
  var valid_594921 = path.getOrDefault("resourceGroupName")
  valid_594921 = validateParameter(valid_594921, JString, required = true,
                                 default = nil)
  if valid_594921 != nil:
    section.add "resourceGroupName", valid_594921
  var valid_594922 = path.getOrDefault("runName")
  valid_594922 = validateParameter(valid_594922, JString, required = true,
                                 default = nil)
  if valid_594922 != nil:
    section.add "runName", valid_594922
  var valid_594923 = path.getOrDefault("requestHistoryName")
  valid_594923 = validateParameter(valid_594923, JString, required = true,
                                 default = nil)
  if valid_594923 != nil:
    section.add "requestHistoryName", valid_594923
  var valid_594924 = path.getOrDefault("subscriptionId")
  valid_594924 = validateParameter(valid_594924, JString, required = true,
                                 default = nil)
  if valid_594924 != nil:
    section.add "subscriptionId", valid_594924
  var valid_594925 = path.getOrDefault("repetitionName")
  valid_594925 = validateParameter(valid_594925, JString, required = true,
                                 default = nil)
  if valid_594925 != nil:
    section.add "repetitionName", valid_594925
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594926 = query.getOrDefault("api-version")
  valid_594926 = validateParameter(valid_594926, JString, required = true,
                                 default = nil)
  if valid_594926 != nil:
    section.add "api-version", valid_594926
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594927: Call_WorkflowRunActionRepetitionsRequestHistoriesGet_594916;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a workflow run repetition request history.
  ## 
  let valid = call_594927.validator(path, query, header, formData, body)
  let scheme = call_594927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594927.url(scheme.get, call_594927.host, call_594927.base,
                         call_594927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594927, url, valid)

proc call*(call_594928: Call_WorkflowRunActionRepetitionsRequestHistoriesGet_594916;
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
  var path_594929 = newJObject()
  var query_594930 = newJObject()
  add(path_594929, "workflowName", newJString(workflowName))
  add(path_594929, "actionName", newJString(actionName))
  add(path_594929, "resourceGroupName", newJString(resourceGroupName))
  add(path_594929, "runName", newJString(runName))
  add(query_594930, "api-version", newJString(apiVersion))
  add(path_594929, "requestHistoryName", newJString(requestHistoryName))
  add(path_594929, "subscriptionId", newJString(subscriptionId))
  add(path_594929, "repetitionName", newJString(repetitionName))
  result = call_594928.call(path_594929, query_594930, nil, nil, nil)

var workflowRunActionRepetitionsRequestHistoriesGet* = Call_WorkflowRunActionRepetitionsRequestHistoriesGet_594916(
    name: "workflowRunActionRepetitionsRequestHistoriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/repetitions/{repetitionName}/requestHistories/{requestHistoryName}",
    validator: validate_WorkflowRunActionRepetitionsRequestHistoriesGet_594917,
    base: "", url: url_WorkflowRunActionRepetitionsRequestHistoriesGet_594918,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRequestHistoriesList_594931 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunActionRequestHistoriesList_594933(protocol: Scheme;
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

proc validate_WorkflowRunActionRequestHistoriesList_594932(path: JsonNode;
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
  var valid_594934 = path.getOrDefault("workflowName")
  valid_594934 = validateParameter(valid_594934, JString, required = true,
                                 default = nil)
  if valid_594934 != nil:
    section.add "workflowName", valid_594934
  var valid_594935 = path.getOrDefault("actionName")
  valid_594935 = validateParameter(valid_594935, JString, required = true,
                                 default = nil)
  if valid_594935 != nil:
    section.add "actionName", valid_594935
  var valid_594936 = path.getOrDefault("resourceGroupName")
  valid_594936 = validateParameter(valid_594936, JString, required = true,
                                 default = nil)
  if valid_594936 != nil:
    section.add "resourceGroupName", valid_594936
  var valid_594937 = path.getOrDefault("runName")
  valid_594937 = validateParameter(valid_594937, JString, required = true,
                                 default = nil)
  if valid_594937 != nil:
    section.add "runName", valid_594937
  var valid_594938 = path.getOrDefault("subscriptionId")
  valid_594938 = validateParameter(valid_594938, JString, required = true,
                                 default = nil)
  if valid_594938 != nil:
    section.add "subscriptionId", valid_594938
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594939 = query.getOrDefault("api-version")
  valid_594939 = validateParameter(valid_594939, JString, required = true,
                                 default = nil)
  if valid_594939 != nil:
    section.add "api-version", valid_594939
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594940: Call_WorkflowRunActionRequestHistoriesList_594931;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a workflow run request history.
  ## 
  let valid = call_594940.validator(path, query, header, formData, body)
  let scheme = call_594940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594940.url(scheme.get, call_594940.host, call_594940.base,
                         call_594940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594940, url, valid)

proc call*(call_594941: Call_WorkflowRunActionRequestHistoriesList_594931;
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
  var path_594942 = newJObject()
  var query_594943 = newJObject()
  add(path_594942, "workflowName", newJString(workflowName))
  add(path_594942, "actionName", newJString(actionName))
  add(path_594942, "resourceGroupName", newJString(resourceGroupName))
  add(path_594942, "runName", newJString(runName))
  add(query_594943, "api-version", newJString(apiVersion))
  add(path_594942, "subscriptionId", newJString(subscriptionId))
  result = call_594941.call(path_594942, query_594943, nil, nil, nil)

var workflowRunActionRequestHistoriesList* = Call_WorkflowRunActionRequestHistoriesList_594931(
    name: "workflowRunActionRequestHistoriesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/requestHistories",
    validator: validate_WorkflowRunActionRequestHistoriesList_594932, base: "",
    url: url_WorkflowRunActionRequestHistoriesList_594933, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionRequestHistoriesGet_594944 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunActionRequestHistoriesGet_594946(protocol: Scheme;
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

proc validate_WorkflowRunActionRequestHistoriesGet_594945(path: JsonNode;
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
  var valid_594947 = path.getOrDefault("workflowName")
  valid_594947 = validateParameter(valid_594947, JString, required = true,
                                 default = nil)
  if valid_594947 != nil:
    section.add "workflowName", valid_594947
  var valid_594948 = path.getOrDefault("actionName")
  valid_594948 = validateParameter(valid_594948, JString, required = true,
                                 default = nil)
  if valid_594948 != nil:
    section.add "actionName", valid_594948
  var valid_594949 = path.getOrDefault("resourceGroupName")
  valid_594949 = validateParameter(valid_594949, JString, required = true,
                                 default = nil)
  if valid_594949 != nil:
    section.add "resourceGroupName", valid_594949
  var valid_594950 = path.getOrDefault("runName")
  valid_594950 = validateParameter(valid_594950, JString, required = true,
                                 default = nil)
  if valid_594950 != nil:
    section.add "runName", valid_594950
  var valid_594951 = path.getOrDefault("requestHistoryName")
  valid_594951 = validateParameter(valid_594951, JString, required = true,
                                 default = nil)
  if valid_594951 != nil:
    section.add "requestHistoryName", valid_594951
  var valid_594952 = path.getOrDefault("subscriptionId")
  valid_594952 = validateParameter(valid_594952, JString, required = true,
                                 default = nil)
  if valid_594952 != nil:
    section.add "subscriptionId", valid_594952
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594953 = query.getOrDefault("api-version")
  valid_594953 = validateParameter(valid_594953, JString, required = true,
                                 default = nil)
  if valid_594953 != nil:
    section.add "api-version", valid_594953
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594954: Call_WorkflowRunActionRequestHistoriesGet_594944;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a workflow run request history.
  ## 
  let valid = call_594954.validator(path, query, header, formData, body)
  let scheme = call_594954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594954.url(scheme.get, call_594954.host, call_594954.base,
                         call_594954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594954, url, valid)

proc call*(call_594955: Call_WorkflowRunActionRequestHistoriesGet_594944;
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
  var path_594956 = newJObject()
  var query_594957 = newJObject()
  add(path_594956, "workflowName", newJString(workflowName))
  add(path_594956, "actionName", newJString(actionName))
  add(path_594956, "resourceGroupName", newJString(resourceGroupName))
  add(path_594956, "runName", newJString(runName))
  add(query_594957, "api-version", newJString(apiVersion))
  add(path_594956, "requestHistoryName", newJString(requestHistoryName))
  add(path_594956, "subscriptionId", newJString(subscriptionId))
  result = call_594955.call(path_594956, query_594957, nil, nil, nil)

var workflowRunActionRequestHistoriesGet* = Call_WorkflowRunActionRequestHistoriesGet_594944(
    name: "workflowRunActionRequestHistoriesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/requestHistories/{requestHistoryName}",
    validator: validate_WorkflowRunActionRequestHistoriesGet_594945, base: "",
    url: url_WorkflowRunActionRequestHistoriesGet_594946, schemes: {Scheme.Https})
type
  Call_WorkflowRunActionScopedRepetitionsList_594958 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunActionScopedRepetitionsList_594960(protocol: Scheme;
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

proc validate_WorkflowRunActionScopedRepetitionsList_594959(path: JsonNode;
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
  var valid_594961 = path.getOrDefault("workflowName")
  valid_594961 = validateParameter(valid_594961, JString, required = true,
                                 default = nil)
  if valid_594961 != nil:
    section.add "workflowName", valid_594961
  var valid_594962 = path.getOrDefault("actionName")
  valid_594962 = validateParameter(valid_594962, JString, required = true,
                                 default = nil)
  if valid_594962 != nil:
    section.add "actionName", valid_594962
  var valid_594963 = path.getOrDefault("resourceGroupName")
  valid_594963 = validateParameter(valid_594963, JString, required = true,
                                 default = nil)
  if valid_594963 != nil:
    section.add "resourceGroupName", valid_594963
  var valid_594964 = path.getOrDefault("runName")
  valid_594964 = validateParameter(valid_594964, JString, required = true,
                                 default = nil)
  if valid_594964 != nil:
    section.add "runName", valid_594964
  var valid_594965 = path.getOrDefault("subscriptionId")
  valid_594965 = validateParameter(valid_594965, JString, required = true,
                                 default = nil)
  if valid_594965 != nil:
    section.add "subscriptionId", valid_594965
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594966 = query.getOrDefault("api-version")
  valid_594966 = validateParameter(valid_594966, JString, required = true,
                                 default = nil)
  if valid_594966 != nil:
    section.add "api-version", valid_594966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594967: Call_WorkflowRunActionScopedRepetitionsList_594958;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the workflow run action scoped repetitions.
  ## 
  let valid = call_594967.validator(path, query, header, formData, body)
  let scheme = call_594967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594967.url(scheme.get, call_594967.host, call_594967.base,
                         call_594967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594967, url, valid)

proc call*(call_594968: Call_WorkflowRunActionScopedRepetitionsList_594958;
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
  var path_594969 = newJObject()
  var query_594970 = newJObject()
  add(path_594969, "workflowName", newJString(workflowName))
  add(path_594969, "actionName", newJString(actionName))
  add(path_594969, "resourceGroupName", newJString(resourceGroupName))
  add(path_594969, "runName", newJString(runName))
  add(query_594970, "api-version", newJString(apiVersion))
  add(path_594969, "subscriptionId", newJString(subscriptionId))
  result = call_594968.call(path_594969, query_594970, nil, nil, nil)

var workflowRunActionScopedRepetitionsList* = Call_WorkflowRunActionScopedRepetitionsList_594958(
    name: "workflowRunActionScopedRepetitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/scopeRepetitions",
    validator: validate_WorkflowRunActionScopedRepetitionsList_594959, base: "",
    url: url_WorkflowRunActionScopedRepetitionsList_594960,
    schemes: {Scheme.Https})
type
  Call_WorkflowRunActionScopedRepetitionsGet_594971 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunActionScopedRepetitionsGet_594973(protocol: Scheme;
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

proc validate_WorkflowRunActionScopedRepetitionsGet_594972(path: JsonNode;
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
  var valid_594974 = path.getOrDefault("workflowName")
  valid_594974 = validateParameter(valid_594974, JString, required = true,
                                 default = nil)
  if valid_594974 != nil:
    section.add "workflowName", valid_594974
  var valid_594975 = path.getOrDefault("actionName")
  valid_594975 = validateParameter(valid_594975, JString, required = true,
                                 default = nil)
  if valid_594975 != nil:
    section.add "actionName", valid_594975
  var valid_594976 = path.getOrDefault("resourceGroupName")
  valid_594976 = validateParameter(valid_594976, JString, required = true,
                                 default = nil)
  if valid_594976 != nil:
    section.add "resourceGroupName", valid_594976
  var valid_594977 = path.getOrDefault("runName")
  valid_594977 = validateParameter(valid_594977, JString, required = true,
                                 default = nil)
  if valid_594977 != nil:
    section.add "runName", valid_594977
  var valid_594978 = path.getOrDefault("subscriptionId")
  valid_594978 = validateParameter(valid_594978, JString, required = true,
                                 default = nil)
  if valid_594978 != nil:
    section.add "subscriptionId", valid_594978
  var valid_594979 = path.getOrDefault("repetitionName")
  valid_594979 = validateParameter(valid_594979, JString, required = true,
                                 default = nil)
  if valid_594979 != nil:
    section.add "repetitionName", valid_594979
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594980 = query.getOrDefault("api-version")
  valid_594980 = validateParameter(valid_594980, JString, required = true,
                                 default = nil)
  if valid_594980 != nil:
    section.add "api-version", valid_594980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594981: Call_WorkflowRunActionScopedRepetitionsGet_594971;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a workflow run action scoped repetition.
  ## 
  let valid = call_594981.validator(path, query, header, formData, body)
  let scheme = call_594981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594981.url(scheme.get, call_594981.host, call_594981.base,
                         call_594981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594981, url, valid)

proc call*(call_594982: Call_WorkflowRunActionScopedRepetitionsGet_594971;
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
  var path_594983 = newJObject()
  var query_594984 = newJObject()
  add(path_594983, "workflowName", newJString(workflowName))
  add(path_594983, "actionName", newJString(actionName))
  add(path_594983, "resourceGroupName", newJString(resourceGroupName))
  add(path_594983, "runName", newJString(runName))
  add(query_594984, "api-version", newJString(apiVersion))
  add(path_594983, "subscriptionId", newJString(subscriptionId))
  add(path_594983, "repetitionName", newJString(repetitionName))
  result = call_594982.call(path_594983, query_594984, nil, nil, nil)

var workflowRunActionScopedRepetitionsGet* = Call_WorkflowRunActionScopedRepetitionsGet_594971(
    name: "workflowRunActionScopedRepetitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}/scopeRepetitions/{repetitionName}",
    validator: validate_WorkflowRunActionScopedRepetitionsGet_594972, base: "",
    url: url_WorkflowRunActionScopedRepetitionsGet_594973, schemes: {Scheme.Https})
type
  Call_WorkflowRunsCancel_594985 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunsCancel_594987(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowRunsCancel_594986(path: JsonNode; query: JsonNode;
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
  var valid_594988 = path.getOrDefault("workflowName")
  valid_594988 = validateParameter(valid_594988, JString, required = true,
                                 default = nil)
  if valid_594988 != nil:
    section.add "workflowName", valid_594988
  var valid_594989 = path.getOrDefault("resourceGroupName")
  valid_594989 = validateParameter(valid_594989, JString, required = true,
                                 default = nil)
  if valid_594989 != nil:
    section.add "resourceGroupName", valid_594989
  var valid_594990 = path.getOrDefault("runName")
  valid_594990 = validateParameter(valid_594990, JString, required = true,
                                 default = nil)
  if valid_594990 != nil:
    section.add "runName", valid_594990
  var valid_594991 = path.getOrDefault("subscriptionId")
  valid_594991 = validateParameter(valid_594991, JString, required = true,
                                 default = nil)
  if valid_594991 != nil:
    section.add "subscriptionId", valid_594991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594992 = query.getOrDefault("api-version")
  valid_594992 = validateParameter(valid_594992, JString, required = true,
                                 default = nil)
  if valid_594992 != nil:
    section.add "api-version", valid_594992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594993: Call_WorkflowRunsCancel_594985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a workflow run.
  ## 
  let valid = call_594993.validator(path, query, header, formData, body)
  let scheme = call_594993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594993.url(scheme.get, call_594993.host, call_594993.base,
                         call_594993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594993, url, valid)

proc call*(call_594994: Call_WorkflowRunsCancel_594985; workflowName: string;
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
  var path_594995 = newJObject()
  var query_594996 = newJObject()
  add(path_594995, "workflowName", newJString(workflowName))
  add(path_594995, "resourceGroupName", newJString(resourceGroupName))
  add(path_594995, "runName", newJString(runName))
  add(query_594996, "api-version", newJString(apiVersion))
  add(path_594995, "subscriptionId", newJString(subscriptionId))
  result = call_594994.call(path_594995, query_594996, nil, nil, nil)

var workflowRunsCancel* = Call_WorkflowRunsCancel_594985(
    name: "workflowRunsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/cancel",
    validator: validate_WorkflowRunsCancel_594986, base: "",
    url: url_WorkflowRunsCancel_594987, schemes: {Scheme.Https})
type
  Call_WorkflowRunOperationsGet_594997 = ref object of OpenApiRestCall_593438
proc url_WorkflowRunOperationsGet_594999(protocol: Scheme; host: string;
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

proc validate_WorkflowRunOperationsGet_594998(path: JsonNode; query: JsonNode;
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
  var valid_595000 = path.getOrDefault("workflowName")
  valid_595000 = validateParameter(valid_595000, JString, required = true,
                                 default = nil)
  if valid_595000 != nil:
    section.add "workflowName", valid_595000
  var valid_595001 = path.getOrDefault("resourceGroupName")
  valid_595001 = validateParameter(valid_595001, JString, required = true,
                                 default = nil)
  if valid_595001 != nil:
    section.add "resourceGroupName", valid_595001
  var valid_595002 = path.getOrDefault("runName")
  valid_595002 = validateParameter(valid_595002, JString, required = true,
                                 default = nil)
  if valid_595002 != nil:
    section.add "runName", valid_595002
  var valid_595003 = path.getOrDefault("subscriptionId")
  valid_595003 = validateParameter(valid_595003, JString, required = true,
                                 default = nil)
  if valid_595003 != nil:
    section.add "subscriptionId", valid_595003
  var valid_595004 = path.getOrDefault("operationId")
  valid_595004 = validateParameter(valid_595004, JString, required = true,
                                 default = nil)
  if valid_595004 != nil:
    section.add "operationId", valid_595004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595005 = query.getOrDefault("api-version")
  valid_595005 = validateParameter(valid_595005, JString, required = true,
                                 default = nil)
  if valid_595005 != nil:
    section.add "api-version", valid_595005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595006: Call_WorkflowRunOperationsGet_594997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an operation for a run.
  ## 
  let valid = call_595006.validator(path, query, header, formData, body)
  let scheme = call_595006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595006.url(scheme.get, call_595006.host, call_595006.base,
                         call_595006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595006, url, valid)

proc call*(call_595007: Call_WorkflowRunOperationsGet_594997; workflowName: string;
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
  var path_595008 = newJObject()
  var query_595009 = newJObject()
  add(path_595008, "workflowName", newJString(workflowName))
  add(path_595008, "resourceGroupName", newJString(resourceGroupName))
  add(path_595008, "runName", newJString(runName))
  add(query_595009, "api-version", newJString(apiVersion))
  add(path_595008, "subscriptionId", newJString(subscriptionId))
  add(path_595008, "operationId", newJString(operationId))
  result = call_595007.call(path_595008, query_595009, nil, nil, nil)

var workflowRunOperationsGet* = Call_WorkflowRunOperationsGet_594997(
    name: "workflowRunOperationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/operations/{operationId}",
    validator: validate_WorkflowRunOperationsGet_594998, base: "",
    url: url_WorkflowRunOperationsGet_594999, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersList_595010 = ref object of OpenApiRestCall_593438
proc url_WorkflowTriggersList_595012(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersList_595011(path: JsonNode; query: JsonNode;
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
  var valid_595013 = path.getOrDefault("workflowName")
  valid_595013 = validateParameter(valid_595013, JString, required = true,
                                 default = nil)
  if valid_595013 != nil:
    section.add "workflowName", valid_595013
  var valid_595014 = path.getOrDefault("resourceGroupName")
  valid_595014 = validateParameter(valid_595014, JString, required = true,
                                 default = nil)
  if valid_595014 != nil:
    section.add "resourceGroupName", valid_595014
  var valid_595015 = path.getOrDefault("subscriptionId")
  valid_595015 = validateParameter(valid_595015, JString, required = true,
                                 default = nil)
  if valid_595015 != nil:
    section.add "subscriptionId", valid_595015
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
  var valid_595016 = query.getOrDefault("api-version")
  valid_595016 = validateParameter(valid_595016, JString, required = true,
                                 default = nil)
  if valid_595016 != nil:
    section.add "api-version", valid_595016
  var valid_595017 = query.getOrDefault("$top")
  valid_595017 = validateParameter(valid_595017, JInt, required = false, default = nil)
  if valid_595017 != nil:
    section.add "$top", valid_595017
  var valid_595018 = query.getOrDefault("$filter")
  valid_595018 = validateParameter(valid_595018, JString, required = false,
                                 default = nil)
  if valid_595018 != nil:
    section.add "$filter", valid_595018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595019: Call_WorkflowTriggersList_595010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow triggers.
  ## 
  let valid = call_595019.validator(path, query, header, formData, body)
  let scheme = call_595019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595019.url(scheme.get, call_595019.host, call_595019.base,
                         call_595019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595019, url, valid)

proc call*(call_595020: Call_WorkflowTriggersList_595010; workflowName: string;
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
  var path_595021 = newJObject()
  var query_595022 = newJObject()
  add(path_595021, "workflowName", newJString(workflowName))
  add(path_595021, "resourceGroupName", newJString(resourceGroupName))
  add(query_595022, "api-version", newJString(apiVersion))
  add(path_595021, "subscriptionId", newJString(subscriptionId))
  add(query_595022, "$top", newJInt(Top))
  add(query_595022, "$filter", newJString(Filter))
  result = call_595020.call(path_595021, query_595022, nil, nil, nil)

var workflowTriggersList* = Call_WorkflowTriggersList_595010(
    name: "workflowTriggersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers",
    validator: validate_WorkflowTriggersList_595011, base: "",
    url: url_WorkflowTriggersList_595012, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersGet_595023 = ref object of OpenApiRestCall_593438
proc url_WorkflowTriggersGet_595025(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersGet_595024(path: JsonNode; query: JsonNode;
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
  var valid_595026 = path.getOrDefault("workflowName")
  valid_595026 = validateParameter(valid_595026, JString, required = true,
                                 default = nil)
  if valid_595026 != nil:
    section.add "workflowName", valid_595026
  var valid_595027 = path.getOrDefault("resourceGroupName")
  valid_595027 = validateParameter(valid_595027, JString, required = true,
                                 default = nil)
  if valid_595027 != nil:
    section.add "resourceGroupName", valid_595027
  var valid_595028 = path.getOrDefault("subscriptionId")
  valid_595028 = validateParameter(valid_595028, JString, required = true,
                                 default = nil)
  if valid_595028 != nil:
    section.add "subscriptionId", valid_595028
  var valid_595029 = path.getOrDefault("triggerName")
  valid_595029 = validateParameter(valid_595029, JString, required = true,
                                 default = nil)
  if valid_595029 != nil:
    section.add "triggerName", valid_595029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595030 = query.getOrDefault("api-version")
  valid_595030 = validateParameter(valid_595030, JString, required = true,
                                 default = nil)
  if valid_595030 != nil:
    section.add "api-version", valid_595030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595031: Call_WorkflowTriggersGet_595023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow trigger.
  ## 
  let valid = call_595031.validator(path, query, header, formData, body)
  let scheme = call_595031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595031.url(scheme.get, call_595031.host, call_595031.base,
                         call_595031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595031, url, valid)

proc call*(call_595032: Call_WorkflowTriggersGet_595023; workflowName: string;
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
  var path_595033 = newJObject()
  var query_595034 = newJObject()
  add(path_595033, "workflowName", newJString(workflowName))
  add(path_595033, "resourceGroupName", newJString(resourceGroupName))
  add(query_595034, "api-version", newJString(apiVersion))
  add(path_595033, "subscriptionId", newJString(subscriptionId))
  add(path_595033, "triggerName", newJString(triggerName))
  result = call_595032.call(path_595033, query_595034, nil, nil, nil)

var workflowTriggersGet* = Call_WorkflowTriggersGet_595023(
    name: "workflowTriggersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}",
    validator: validate_WorkflowTriggersGet_595024, base: "",
    url: url_WorkflowTriggersGet_595025, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesList_595035 = ref object of OpenApiRestCall_593438
proc url_WorkflowTriggerHistoriesList_595037(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesList_595036(path: JsonNode; query: JsonNode;
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
  var valid_595038 = path.getOrDefault("workflowName")
  valid_595038 = validateParameter(valid_595038, JString, required = true,
                                 default = nil)
  if valid_595038 != nil:
    section.add "workflowName", valid_595038
  var valid_595039 = path.getOrDefault("resourceGroupName")
  valid_595039 = validateParameter(valid_595039, JString, required = true,
                                 default = nil)
  if valid_595039 != nil:
    section.add "resourceGroupName", valid_595039
  var valid_595040 = path.getOrDefault("subscriptionId")
  valid_595040 = validateParameter(valid_595040, JString, required = true,
                                 default = nil)
  if valid_595040 != nil:
    section.add "subscriptionId", valid_595040
  var valid_595041 = path.getOrDefault("triggerName")
  valid_595041 = validateParameter(valid_595041, JString, required = true,
                                 default = nil)
  if valid_595041 != nil:
    section.add "triggerName", valid_595041
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
  var valid_595042 = query.getOrDefault("api-version")
  valid_595042 = validateParameter(valid_595042, JString, required = true,
                                 default = nil)
  if valid_595042 != nil:
    section.add "api-version", valid_595042
  var valid_595043 = query.getOrDefault("$top")
  valid_595043 = validateParameter(valid_595043, JInt, required = false, default = nil)
  if valid_595043 != nil:
    section.add "$top", valid_595043
  var valid_595044 = query.getOrDefault("$filter")
  valid_595044 = validateParameter(valid_595044, JString, required = false,
                                 default = nil)
  if valid_595044 != nil:
    section.add "$filter", valid_595044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595045: Call_WorkflowTriggerHistoriesList_595035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow trigger histories.
  ## 
  let valid = call_595045.validator(path, query, header, formData, body)
  let scheme = call_595045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595045.url(scheme.get, call_595045.host, call_595045.base,
                         call_595045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595045, url, valid)

proc call*(call_595046: Call_WorkflowTriggerHistoriesList_595035;
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
  var path_595047 = newJObject()
  var query_595048 = newJObject()
  add(path_595047, "workflowName", newJString(workflowName))
  add(path_595047, "resourceGroupName", newJString(resourceGroupName))
  add(query_595048, "api-version", newJString(apiVersion))
  add(path_595047, "subscriptionId", newJString(subscriptionId))
  add(query_595048, "$top", newJInt(Top))
  add(path_595047, "triggerName", newJString(triggerName))
  add(query_595048, "$filter", newJString(Filter))
  result = call_595046.call(path_595047, query_595048, nil, nil, nil)

var workflowTriggerHistoriesList* = Call_WorkflowTriggerHistoriesList_595035(
    name: "workflowTriggerHistoriesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories",
    validator: validate_WorkflowTriggerHistoriesList_595036, base: "",
    url: url_WorkflowTriggerHistoriesList_595037, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesGet_595049 = ref object of OpenApiRestCall_593438
proc url_WorkflowTriggerHistoriesGet_595051(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesGet_595050(path: JsonNode; query: JsonNode;
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
  var valid_595052 = path.getOrDefault("workflowName")
  valid_595052 = validateParameter(valid_595052, JString, required = true,
                                 default = nil)
  if valid_595052 != nil:
    section.add "workflowName", valid_595052
  var valid_595053 = path.getOrDefault("resourceGroupName")
  valid_595053 = validateParameter(valid_595053, JString, required = true,
                                 default = nil)
  if valid_595053 != nil:
    section.add "resourceGroupName", valid_595053
  var valid_595054 = path.getOrDefault("historyName")
  valid_595054 = validateParameter(valid_595054, JString, required = true,
                                 default = nil)
  if valid_595054 != nil:
    section.add "historyName", valid_595054
  var valid_595055 = path.getOrDefault("subscriptionId")
  valid_595055 = validateParameter(valid_595055, JString, required = true,
                                 default = nil)
  if valid_595055 != nil:
    section.add "subscriptionId", valid_595055
  var valid_595056 = path.getOrDefault("triggerName")
  valid_595056 = validateParameter(valid_595056, JString, required = true,
                                 default = nil)
  if valid_595056 != nil:
    section.add "triggerName", valid_595056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595057 = query.getOrDefault("api-version")
  valid_595057 = validateParameter(valid_595057, JString, required = true,
                                 default = nil)
  if valid_595057 != nil:
    section.add "api-version", valid_595057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595058: Call_WorkflowTriggerHistoriesGet_595049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow trigger history.
  ## 
  let valid = call_595058.validator(path, query, header, formData, body)
  let scheme = call_595058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595058.url(scheme.get, call_595058.host, call_595058.base,
                         call_595058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595058, url, valid)

proc call*(call_595059: Call_WorkflowTriggerHistoriesGet_595049;
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
  var path_595060 = newJObject()
  var query_595061 = newJObject()
  add(path_595060, "workflowName", newJString(workflowName))
  add(path_595060, "resourceGroupName", newJString(resourceGroupName))
  add(query_595061, "api-version", newJString(apiVersion))
  add(path_595060, "historyName", newJString(historyName))
  add(path_595060, "subscriptionId", newJString(subscriptionId))
  add(path_595060, "triggerName", newJString(triggerName))
  result = call_595059.call(path_595060, query_595061, nil, nil, nil)

var workflowTriggerHistoriesGet* = Call_WorkflowTriggerHistoriesGet_595049(
    name: "workflowTriggerHistoriesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories/{historyName}",
    validator: validate_WorkflowTriggerHistoriesGet_595050, base: "",
    url: url_WorkflowTriggerHistoriesGet_595051, schemes: {Scheme.Https})
type
  Call_WorkflowTriggerHistoriesResubmit_595062 = ref object of OpenApiRestCall_593438
proc url_WorkflowTriggerHistoriesResubmit_595064(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggerHistoriesResubmit_595063(path: JsonNode;
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
  var valid_595065 = path.getOrDefault("workflowName")
  valid_595065 = validateParameter(valid_595065, JString, required = true,
                                 default = nil)
  if valid_595065 != nil:
    section.add "workflowName", valid_595065
  var valid_595066 = path.getOrDefault("resourceGroupName")
  valid_595066 = validateParameter(valid_595066, JString, required = true,
                                 default = nil)
  if valid_595066 != nil:
    section.add "resourceGroupName", valid_595066
  var valid_595067 = path.getOrDefault("historyName")
  valid_595067 = validateParameter(valid_595067, JString, required = true,
                                 default = nil)
  if valid_595067 != nil:
    section.add "historyName", valid_595067
  var valid_595068 = path.getOrDefault("subscriptionId")
  valid_595068 = validateParameter(valid_595068, JString, required = true,
                                 default = nil)
  if valid_595068 != nil:
    section.add "subscriptionId", valid_595068
  var valid_595069 = path.getOrDefault("triggerName")
  valid_595069 = validateParameter(valid_595069, JString, required = true,
                                 default = nil)
  if valid_595069 != nil:
    section.add "triggerName", valid_595069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595070 = query.getOrDefault("api-version")
  valid_595070 = validateParameter(valid_595070, JString, required = true,
                                 default = nil)
  if valid_595070 != nil:
    section.add "api-version", valid_595070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595071: Call_WorkflowTriggerHistoriesResubmit_595062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resubmits a workflow run based on the trigger history.
  ## 
  let valid = call_595071.validator(path, query, header, formData, body)
  let scheme = call_595071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595071.url(scheme.get, call_595071.host, call_595071.base,
                         call_595071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595071, url, valid)

proc call*(call_595072: Call_WorkflowTriggerHistoriesResubmit_595062;
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
  var path_595073 = newJObject()
  var query_595074 = newJObject()
  add(path_595073, "workflowName", newJString(workflowName))
  add(path_595073, "resourceGroupName", newJString(resourceGroupName))
  add(query_595074, "api-version", newJString(apiVersion))
  add(path_595073, "historyName", newJString(historyName))
  add(path_595073, "subscriptionId", newJString(subscriptionId))
  add(path_595073, "triggerName", newJString(triggerName))
  result = call_595072.call(path_595073, query_595074, nil, nil, nil)

var workflowTriggerHistoriesResubmit* = Call_WorkflowTriggerHistoriesResubmit_595062(
    name: "workflowTriggerHistoriesResubmit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories/{historyName}/resubmit",
    validator: validate_WorkflowTriggerHistoriesResubmit_595063, base: "",
    url: url_WorkflowTriggerHistoriesResubmit_595064, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersListCallbackUrl_595075 = ref object of OpenApiRestCall_593438
proc url_WorkflowTriggersListCallbackUrl_595077(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggersListCallbackUrl_595076(path: JsonNode;
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
  var valid_595078 = path.getOrDefault("workflowName")
  valid_595078 = validateParameter(valid_595078, JString, required = true,
                                 default = nil)
  if valid_595078 != nil:
    section.add "workflowName", valid_595078
  var valid_595079 = path.getOrDefault("resourceGroupName")
  valid_595079 = validateParameter(valid_595079, JString, required = true,
                                 default = nil)
  if valid_595079 != nil:
    section.add "resourceGroupName", valid_595079
  var valid_595080 = path.getOrDefault("subscriptionId")
  valid_595080 = validateParameter(valid_595080, JString, required = true,
                                 default = nil)
  if valid_595080 != nil:
    section.add "subscriptionId", valid_595080
  var valid_595081 = path.getOrDefault("triggerName")
  valid_595081 = validateParameter(valid_595081, JString, required = true,
                                 default = nil)
  if valid_595081 != nil:
    section.add "triggerName", valid_595081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595082 = query.getOrDefault("api-version")
  valid_595082 = validateParameter(valid_595082, JString, required = true,
                                 default = nil)
  if valid_595082 != nil:
    section.add "api-version", valid_595082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595083: Call_WorkflowTriggersListCallbackUrl_595075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the callback URL for a workflow trigger.
  ## 
  let valid = call_595083.validator(path, query, header, formData, body)
  let scheme = call_595083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595083.url(scheme.get, call_595083.host, call_595083.base,
                         call_595083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595083, url, valid)

proc call*(call_595084: Call_WorkflowTriggersListCallbackUrl_595075;
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
  var path_595085 = newJObject()
  var query_595086 = newJObject()
  add(path_595085, "workflowName", newJString(workflowName))
  add(path_595085, "resourceGroupName", newJString(resourceGroupName))
  add(query_595086, "api-version", newJString(apiVersion))
  add(path_595085, "subscriptionId", newJString(subscriptionId))
  add(path_595085, "triggerName", newJString(triggerName))
  result = call_595084.call(path_595085, query_595086, nil, nil, nil)

var workflowTriggersListCallbackUrl* = Call_WorkflowTriggersListCallbackUrl_595075(
    name: "workflowTriggersListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/listCallbackUrl",
    validator: validate_WorkflowTriggersListCallbackUrl_595076, base: "",
    url: url_WorkflowTriggersListCallbackUrl_595077, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersReset_595087 = ref object of OpenApiRestCall_593438
proc url_WorkflowTriggersReset_595089(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersReset_595088(path: JsonNode; query: JsonNode;
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
  var valid_595090 = path.getOrDefault("workflowName")
  valid_595090 = validateParameter(valid_595090, JString, required = true,
                                 default = nil)
  if valid_595090 != nil:
    section.add "workflowName", valid_595090
  var valid_595091 = path.getOrDefault("resourceGroupName")
  valid_595091 = validateParameter(valid_595091, JString, required = true,
                                 default = nil)
  if valid_595091 != nil:
    section.add "resourceGroupName", valid_595091
  var valid_595092 = path.getOrDefault("subscriptionId")
  valid_595092 = validateParameter(valid_595092, JString, required = true,
                                 default = nil)
  if valid_595092 != nil:
    section.add "subscriptionId", valid_595092
  var valid_595093 = path.getOrDefault("triggerName")
  valid_595093 = validateParameter(valid_595093, JString, required = true,
                                 default = nil)
  if valid_595093 != nil:
    section.add "triggerName", valid_595093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595094 = query.getOrDefault("api-version")
  valid_595094 = validateParameter(valid_595094, JString, required = true,
                                 default = nil)
  if valid_595094 != nil:
    section.add "api-version", valid_595094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595095: Call_WorkflowTriggersReset_595087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets a workflow trigger.
  ## 
  let valid = call_595095.validator(path, query, header, formData, body)
  let scheme = call_595095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595095.url(scheme.get, call_595095.host, call_595095.base,
                         call_595095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595095, url, valid)

proc call*(call_595096: Call_WorkflowTriggersReset_595087; workflowName: string;
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
  var path_595097 = newJObject()
  var query_595098 = newJObject()
  add(path_595097, "workflowName", newJString(workflowName))
  add(path_595097, "resourceGroupName", newJString(resourceGroupName))
  add(query_595098, "api-version", newJString(apiVersion))
  add(path_595097, "subscriptionId", newJString(subscriptionId))
  add(path_595097, "triggerName", newJString(triggerName))
  result = call_595096.call(path_595097, query_595098, nil, nil, nil)

var workflowTriggersReset* = Call_WorkflowTriggersReset_595087(
    name: "workflowTriggersReset", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/reset",
    validator: validate_WorkflowTriggersReset_595088, base: "",
    url: url_WorkflowTriggersReset_595089, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersRun_595099 = ref object of OpenApiRestCall_593438
proc url_WorkflowTriggersRun_595101(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowTriggersRun_595100(path: JsonNode; query: JsonNode;
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
  var valid_595102 = path.getOrDefault("workflowName")
  valid_595102 = validateParameter(valid_595102, JString, required = true,
                                 default = nil)
  if valid_595102 != nil:
    section.add "workflowName", valid_595102
  var valid_595103 = path.getOrDefault("resourceGroupName")
  valid_595103 = validateParameter(valid_595103, JString, required = true,
                                 default = nil)
  if valid_595103 != nil:
    section.add "resourceGroupName", valid_595103
  var valid_595104 = path.getOrDefault("subscriptionId")
  valid_595104 = validateParameter(valid_595104, JString, required = true,
                                 default = nil)
  if valid_595104 != nil:
    section.add "subscriptionId", valid_595104
  var valid_595105 = path.getOrDefault("triggerName")
  valid_595105 = validateParameter(valid_595105, JString, required = true,
                                 default = nil)
  if valid_595105 != nil:
    section.add "triggerName", valid_595105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595106 = query.getOrDefault("api-version")
  valid_595106 = validateParameter(valid_595106, JString, required = true,
                                 default = nil)
  if valid_595106 != nil:
    section.add "api-version", valid_595106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595107: Call_WorkflowTriggersRun_595099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a workflow trigger.
  ## 
  let valid = call_595107.validator(path, query, header, formData, body)
  let scheme = call_595107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595107.url(scheme.get, call_595107.host, call_595107.base,
                         call_595107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595107, url, valid)

proc call*(call_595108: Call_WorkflowTriggersRun_595099; workflowName: string;
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
  var path_595109 = newJObject()
  var query_595110 = newJObject()
  add(path_595109, "workflowName", newJString(workflowName))
  add(path_595109, "resourceGroupName", newJString(resourceGroupName))
  add(query_595110, "api-version", newJString(apiVersion))
  add(path_595109, "subscriptionId", newJString(subscriptionId))
  add(path_595109, "triggerName", newJString(triggerName))
  result = call_595108.call(path_595109, query_595110, nil, nil, nil)

var workflowTriggersRun* = Call_WorkflowTriggersRun_595099(
    name: "workflowTriggersRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/run",
    validator: validate_WorkflowTriggersRun_595100, base: "",
    url: url_WorkflowTriggersRun_595101, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersGetSchemaJson_595111 = ref object of OpenApiRestCall_593438
proc url_WorkflowTriggersGetSchemaJson_595113(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggersGetSchemaJson_595112(path: JsonNode; query: JsonNode;
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
  var valid_595114 = path.getOrDefault("workflowName")
  valid_595114 = validateParameter(valid_595114, JString, required = true,
                                 default = nil)
  if valid_595114 != nil:
    section.add "workflowName", valid_595114
  var valid_595115 = path.getOrDefault("resourceGroupName")
  valid_595115 = validateParameter(valid_595115, JString, required = true,
                                 default = nil)
  if valid_595115 != nil:
    section.add "resourceGroupName", valid_595115
  var valid_595116 = path.getOrDefault("subscriptionId")
  valid_595116 = validateParameter(valid_595116, JString, required = true,
                                 default = nil)
  if valid_595116 != nil:
    section.add "subscriptionId", valid_595116
  var valid_595117 = path.getOrDefault("triggerName")
  valid_595117 = validateParameter(valid_595117, JString, required = true,
                                 default = nil)
  if valid_595117 != nil:
    section.add "triggerName", valid_595117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595118 = query.getOrDefault("api-version")
  valid_595118 = validateParameter(valid_595118, JString, required = true,
                                 default = nil)
  if valid_595118 != nil:
    section.add "api-version", valid_595118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595119: Call_WorkflowTriggersGetSchemaJson_595111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the trigger schema as JSON.
  ## 
  let valid = call_595119.validator(path, query, header, formData, body)
  let scheme = call_595119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595119.url(scheme.get, call_595119.host, call_595119.base,
                         call_595119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595119, url, valid)

proc call*(call_595120: Call_WorkflowTriggersGetSchemaJson_595111;
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
  var path_595121 = newJObject()
  var query_595122 = newJObject()
  add(path_595121, "workflowName", newJString(workflowName))
  add(path_595121, "resourceGroupName", newJString(resourceGroupName))
  add(query_595122, "api-version", newJString(apiVersion))
  add(path_595121, "subscriptionId", newJString(subscriptionId))
  add(path_595121, "triggerName", newJString(triggerName))
  result = call_595120.call(path_595121, query_595122, nil, nil, nil)

var workflowTriggersGetSchemaJson* = Call_WorkflowTriggersGetSchemaJson_595111(
    name: "workflowTriggersGetSchemaJson", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/schemas/json",
    validator: validate_WorkflowTriggersGetSchemaJson_595112, base: "",
    url: url_WorkflowTriggersGetSchemaJson_595113, schemes: {Scheme.Https})
type
  Call_WorkflowTriggersSetState_595123 = ref object of OpenApiRestCall_593438
proc url_WorkflowTriggersSetState_595125(protocol: Scheme; host: string;
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

proc validate_WorkflowTriggersSetState_595124(path: JsonNode; query: JsonNode;
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
  var valid_595126 = path.getOrDefault("workflowName")
  valid_595126 = validateParameter(valid_595126, JString, required = true,
                                 default = nil)
  if valid_595126 != nil:
    section.add "workflowName", valid_595126
  var valid_595127 = path.getOrDefault("resourceGroupName")
  valid_595127 = validateParameter(valid_595127, JString, required = true,
                                 default = nil)
  if valid_595127 != nil:
    section.add "resourceGroupName", valid_595127
  var valid_595128 = path.getOrDefault("subscriptionId")
  valid_595128 = validateParameter(valid_595128, JString, required = true,
                                 default = nil)
  if valid_595128 != nil:
    section.add "subscriptionId", valid_595128
  var valid_595129 = path.getOrDefault("triggerName")
  valid_595129 = validateParameter(valid_595129, JString, required = true,
                                 default = nil)
  if valid_595129 != nil:
    section.add "triggerName", valid_595129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595130 = query.getOrDefault("api-version")
  valid_595130 = validateParameter(valid_595130, JString, required = true,
                                 default = nil)
  if valid_595130 != nil:
    section.add "api-version", valid_595130
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

proc call*(call_595132: Call_WorkflowTriggersSetState_595123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of a workflow trigger.
  ## 
  let valid = call_595132.validator(path, query, header, formData, body)
  let scheme = call_595132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595132.url(scheme.get, call_595132.host, call_595132.base,
                         call_595132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595132, url, valid)

proc call*(call_595133: Call_WorkflowTriggersSetState_595123; workflowName: string;
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
  var path_595134 = newJObject()
  var query_595135 = newJObject()
  var body_595136 = newJObject()
  add(path_595134, "workflowName", newJString(workflowName))
  add(path_595134, "resourceGroupName", newJString(resourceGroupName))
  add(query_595135, "api-version", newJString(apiVersion))
  add(path_595134, "subscriptionId", newJString(subscriptionId))
  add(path_595134, "triggerName", newJString(triggerName))
  if setState != nil:
    body_595136 = setState
  result = call_595133.call(path_595134, query_595135, nil, nil, body_595136)

var workflowTriggersSetState* = Call_WorkflowTriggersSetState_595123(
    name: "workflowTriggersSetState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/setState",
    validator: validate_WorkflowTriggersSetState_595124, base: "",
    url: url_WorkflowTriggersSetState_595125, schemes: {Scheme.Https})
type
  Call_WorkflowsValidateWorkflow_595137 = ref object of OpenApiRestCall_593438
proc url_WorkflowsValidateWorkflow_595139(protocol: Scheme; host: string;
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

proc validate_WorkflowsValidateWorkflow_595138(path: JsonNode; query: JsonNode;
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
  var valid_595140 = path.getOrDefault("workflowName")
  valid_595140 = validateParameter(valid_595140, JString, required = true,
                                 default = nil)
  if valid_595140 != nil:
    section.add "workflowName", valid_595140
  var valid_595141 = path.getOrDefault("resourceGroupName")
  valid_595141 = validateParameter(valid_595141, JString, required = true,
                                 default = nil)
  if valid_595141 != nil:
    section.add "resourceGroupName", valid_595141
  var valid_595142 = path.getOrDefault("subscriptionId")
  valid_595142 = validateParameter(valid_595142, JString, required = true,
                                 default = nil)
  if valid_595142 != nil:
    section.add "subscriptionId", valid_595142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595143 = query.getOrDefault("api-version")
  valid_595143 = validateParameter(valid_595143, JString, required = true,
                                 default = nil)
  if valid_595143 != nil:
    section.add "api-version", valid_595143
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

proc call*(call_595145: Call_WorkflowsValidateWorkflow_595137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the workflow.
  ## 
  let valid = call_595145.validator(path, query, header, formData, body)
  let scheme = call_595145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595145.url(scheme.get, call_595145.host, call_595145.base,
                         call_595145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595145, url, valid)

proc call*(call_595146: Call_WorkflowsValidateWorkflow_595137;
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
  var path_595147 = newJObject()
  var query_595148 = newJObject()
  var body_595149 = newJObject()
  add(path_595147, "workflowName", newJString(workflowName))
  add(path_595147, "resourceGroupName", newJString(resourceGroupName))
  add(query_595148, "api-version", newJString(apiVersion))
  add(path_595147, "subscriptionId", newJString(subscriptionId))
  if validate != nil:
    body_595149 = validate
  result = call_595146.call(path_595147, query_595148, nil, nil, body_595149)

var workflowsValidateWorkflow* = Call_WorkflowsValidateWorkflow_595137(
    name: "workflowsValidateWorkflow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/validate",
    validator: validate_WorkflowsValidateWorkflow_595138, base: "",
    url: url_WorkflowsValidateWorkflow_595139, schemes: {Scheme.Https})
type
  Call_WorkflowVersionsList_595150 = ref object of OpenApiRestCall_593438
proc url_WorkflowVersionsList_595152(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowVersionsList_595151(path: JsonNode; query: JsonNode;
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
  var valid_595153 = path.getOrDefault("workflowName")
  valid_595153 = validateParameter(valid_595153, JString, required = true,
                                 default = nil)
  if valid_595153 != nil:
    section.add "workflowName", valid_595153
  var valid_595154 = path.getOrDefault("resourceGroupName")
  valid_595154 = validateParameter(valid_595154, JString, required = true,
                                 default = nil)
  if valid_595154 != nil:
    section.add "resourceGroupName", valid_595154
  var valid_595155 = path.getOrDefault("subscriptionId")
  valid_595155 = validateParameter(valid_595155, JString, required = true,
                                 default = nil)
  if valid_595155 != nil:
    section.add "subscriptionId", valid_595155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595156 = query.getOrDefault("api-version")
  valid_595156 = validateParameter(valid_595156, JString, required = true,
                                 default = nil)
  if valid_595156 != nil:
    section.add "api-version", valid_595156
  var valid_595157 = query.getOrDefault("$top")
  valid_595157 = validateParameter(valid_595157, JInt, required = false, default = nil)
  if valid_595157 != nil:
    section.add "$top", valid_595157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595158: Call_WorkflowVersionsList_595150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of workflow versions.
  ## 
  let valid = call_595158.validator(path, query, header, formData, body)
  let scheme = call_595158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595158.url(scheme.get, call_595158.host, call_595158.base,
                         call_595158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595158, url, valid)

proc call*(call_595159: Call_WorkflowVersionsList_595150; workflowName: string;
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
  var path_595160 = newJObject()
  var query_595161 = newJObject()
  add(path_595160, "workflowName", newJString(workflowName))
  add(path_595160, "resourceGroupName", newJString(resourceGroupName))
  add(query_595161, "api-version", newJString(apiVersion))
  add(path_595160, "subscriptionId", newJString(subscriptionId))
  add(query_595161, "$top", newJInt(Top))
  result = call_595159.call(path_595160, query_595161, nil, nil, nil)

var workflowVersionsList* = Call_WorkflowVersionsList_595150(
    name: "workflowVersionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions",
    validator: validate_WorkflowVersionsList_595151, base: "",
    url: url_WorkflowVersionsList_595152, schemes: {Scheme.Https})
type
  Call_WorkflowVersionsGet_595162 = ref object of OpenApiRestCall_593438
proc url_WorkflowVersionsGet_595164(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowVersionsGet_595163(path: JsonNode; query: JsonNode;
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
  var valid_595165 = path.getOrDefault("workflowName")
  valid_595165 = validateParameter(valid_595165, JString, required = true,
                                 default = nil)
  if valid_595165 != nil:
    section.add "workflowName", valid_595165
  var valid_595166 = path.getOrDefault("resourceGroupName")
  valid_595166 = validateParameter(valid_595166, JString, required = true,
                                 default = nil)
  if valid_595166 != nil:
    section.add "resourceGroupName", valid_595166
  var valid_595167 = path.getOrDefault("versionId")
  valid_595167 = validateParameter(valid_595167, JString, required = true,
                                 default = nil)
  if valid_595167 != nil:
    section.add "versionId", valid_595167
  var valid_595168 = path.getOrDefault("subscriptionId")
  valid_595168 = validateParameter(valid_595168, JString, required = true,
                                 default = nil)
  if valid_595168 != nil:
    section.add "subscriptionId", valid_595168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595169 = query.getOrDefault("api-version")
  valid_595169 = validateParameter(valid_595169, JString, required = true,
                                 default = nil)
  if valid_595169 != nil:
    section.add "api-version", valid_595169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595170: Call_WorkflowVersionsGet_595162; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a workflow version.
  ## 
  let valid = call_595170.validator(path, query, header, formData, body)
  let scheme = call_595170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595170.url(scheme.get, call_595170.host, call_595170.base,
                         call_595170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595170, url, valid)

proc call*(call_595171: Call_WorkflowVersionsGet_595162; workflowName: string;
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
  var path_595172 = newJObject()
  var query_595173 = newJObject()
  add(path_595172, "workflowName", newJString(workflowName))
  add(path_595172, "resourceGroupName", newJString(resourceGroupName))
  add(path_595172, "versionId", newJString(versionId))
  add(query_595173, "api-version", newJString(apiVersion))
  add(path_595172, "subscriptionId", newJString(subscriptionId))
  result = call_595171.call(path_595172, query_595173, nil, nil, nil)

var workflowVersionsGet* = Call_WorkflowVersionsGet_595162(
    name: "workflowVersionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions/{versionId}",
    validator: validate_WorkflowVersionsGet_595163, base: "",
    url: url_WorkflowVersionsGet_595164, schemes: {Scheme.Https})
type
  Call_WorkflowVersionsListCallbackUrl_595174 = ref object of OpenApiRestCall_593438
proc url_WorkflowVersionsListCallbackUrl_595176(protocol: Scheme; host: string;
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

proc validate_WorkflowVersionsListCallbackUrl_595175(path: JsonNode;
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
  var valid_595177 = path.getOrDefault("workflowName")
  valid_595177 = validateParameter(valid_595177, JString, required = true,
                                 default = nil)
  if valid_595177 != nil:
    section.add "workflowName", valid_595177
  var valid_595178 = path.getOrDefault("resourceGroupName")
  valid_595178 = validateParameter(valid_595178, JString, required = true,
                                 default = nil)
  if valid_595178 != nil:
    section.add "resourceGroupName", valid_595178
  var valid_595179 = path.getOrDefault("versionId")
  valid_595179 = validateParameter(valid_595179, JString, required = true,
                                 default = nil)
  if valid_595179 != nil:
    section.add "versionId", valid_595179
  var valid_595180 = path.getOrDefault("subscriptionId")
  valid_595180 = validateParameter(valid_595180, JString, required = true,
                                 default = nil)
  if valid_595180 != nil:
    section.add "subscriptionId", valid_595180
  var valid_595181 = path.getOrDefault("triggerName")
  valid_595181 = validateParameter(valid_595181, JString, required = true,
                                 default = nil)
  if valid_595181 != nil:
    section.add "triggerName", valid_595181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595182 = query.getOrDefault("api-version")
  valid_595182 = validateParameter(valid_595182, JString, required = true,
                                 default = nil)
  if valid_595182 != nil:
    section.add "api-version", valid_595182
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

proc call*(call_595184: Call_WorkflowVersionsListCallbackUrl_595174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the callback url for a trigger of a workflow version.
  ## 
  let valid = call_595184.validator(path, query, header, formData, body)
  let scheme = call_595184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595184.url(scheme.get, call_595184.host, call_595184.base,
                         call_595184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595184, url, valid)

proc call*(call_595185: Call_WorkflowVersionsListCallbackUrl_595174;
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
  var path_595186 = newJObject()
  var query_595187 = newJObject()
  var body_595188 = newJObject()
  add(path_595186, "workflowName", newJString(workflowName))
  add(path_595186, "resourceGroupName", newJString(resourceGroupName))
  add(path_595186, "versionId", newJString(versionId))
  add(query_595187, "api-version", newJString(apiVersion))
  add(path_595186, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_595188 = parameters
  add(path_595186, "triggerName", newJString(triggerName))
  result = call_595185.call(path_595186, query_595187, nil, nil, body_595188)

var workflowVersionsListCallbackUrl* = Call_WorkflowVersionsListCallbackUrl_595174(
    name: "workflowVersionsListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions/{versionId}/triggers/{triggerName}/listCallbackUrl",
    validator: validate_WorkflowVersionsListCallbackUrl_595175, base: "",
    url: url_WorkflowVersionsListCallbackUrl_595176, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
