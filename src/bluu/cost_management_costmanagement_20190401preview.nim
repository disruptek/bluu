
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: CostManagementClient
## version: 2019-04-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_567659 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567659](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567659): Option[Scheme] {.used.} =
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
  macServiceName = "cost-management-costmanagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567881 = ref object of OpenApiRestCall_567659
proc url_OperationsList_567883(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567882(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available consumption REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568042 = query.getOrDefault("api-version")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "api-version", valid_568042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568065: Call_OperationsList_567881; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available consumption REST API operations.
  ## 
  let valid = call_568065.validator(path, query, header, formData, body)
  let scheme = call_568065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568065.url(scheme.get, call_568065.host, call_568065.base,
                         call_568065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568065, url, valid)

proc call*(call_568136: Call_OperationsList_567881; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available consumption REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  var query_568137 = newJObject()
  add(query_568137, "api-version", newJString(apiVersion))
  result = call_568136.call(nil, query_568137, nil, nil, nil)

var operationsList* = Call_OperationsList_567881(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/operations",
    validator: validate_OperationsList_567882, base: "", url: url_OperationsList_567883,
    schemes: {Scheme.Https})
type
  Call_ViewsList_568177 = ref object of OpenApiRestCall_567659
proc url_ViewsList_568179(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ViewsList_568178(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all views by tenant and object.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568180 = query.getOrDefault("api-version")
  valid_568180 = validateParameter(valid_568180, JString, required = true,
                                 default = nil)
  if valid_568180 != nil:
    section.add "api-version", valid_568180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568181: Call_ViewsList_568177; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all views by tenant and object.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568181.validator(path, query, header, formData, body)
  let scheme = call_568181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568181.url(scheme.get, call_568181.host, call_568181.base,
                         call_568181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568181, url, valid)

proc call*(call_568182: Call_ViewsList_568177; apiVersion: string): Recallable =
  ## viewsList
  ## Lists all views by tenant and object.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  var query_568183 = newJObject()
  add(query_568183, "api-version", newJString(apiVersion))
  result = call_568182.call(nil, query_568183, nil, nil, nil)

var viewsList* = Call_ViewsList_568177(name: "viewsList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/views",
                                    validator: validate_ViewsList_568178,
                                    base: "", url: url_ViewsList_568179,
                                    schemes: {Scheme.Https})
type
  Call_ViewsCreateOrUpdate_568207 = ref object of OpenApiRestCall_567659
proc url_ViewsCreateOrUpdate_568209(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "viewName" in path, "`viewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.CostManagement/views/"),
               (kind: VariableSegment, value: "viewName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ViewsCreateOrUpdate_568208(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The operation to create or update a view. Update operation requires latest eTag to be set in the request. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   viewName: JString (required)
  ##           : View name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `viewName` field"
  var valid_568210 = path.getOrDefault("viewName")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "viewName", valid_568210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568211 = query.getOrDefault("api-version")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "api-version", valid_568211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate View operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568213: Call_ViewsCreateOrUpdate_568207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a view. Update operation requires latest eTag to be set in the request. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568213.validator(path, query, header, formData, body)
  let scheme = call_568213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568213.url(scheme.get, call_568213.host, call_568213.base,
                         call_568213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568213, url, valid)

proc call*(call_568214: Call_ViewsCreateOrUpdate_568207; apiVersion: string;
          viewName: string; parameters: JsonNode): Recallable =
  ## viewsCreateOrUpdate
  ## The operation to create or update a view. Update operation requires latest eTag to be set in the request. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  ##   viewName: string (required)
  ##           : View name
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate View operation.
  var path_568215 = newJObject()
  var query_568216 = newJObject()
  var body_568217 = newJObject()
  add(query_568216, "api-version", newJString(apiVersion))
  add(path_568215, "viewName", newJString(viewName))
  if parameters != nil:
    body_568217 = parameters
  result = call_568214.call(path_568215, query_568216, nil, nil, body_568217)

var viewsCreateOrUpdate* = Call_ViewsCreateOrUpdate_568207(
    name: "viewsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/views/{viewName}",
    validator: validate_ViewsCreateOrUpdate_568208, base: "",
    url: url_ViewsCreateOrUpdate_568209, schemes: {Scheme.Https})
type
  Call_ViewsGet_568184 = ref object of OpenApiRestCall_567659
proc url_ViewsGet_568186(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "viewName" in path, "`viewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.CostManagement/views/"),
               (kind: VariableSegment, value: "viewName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ViewsGet_568185(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the view by view name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   viewName: JString (required)
  ##           : View name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `viewName` field"
  var valid_568201 = path.getOrDefault("viewName")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "viewName", valid_568201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568202 = query.getOrDefault("api-version")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "api-version", valid_568202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568203: Call_ViewsGet_568184; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the view by view name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568203.validator(path, query, header, formData, body)
  let scheme = call_568203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568203.url(scheme.get, call_568203.host, call_568203.base,
                         call_568203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568203, url, valid)

proc call*(call_568204: Call_ViewsGet_568184; apiVersion: string; viewName: string): Recallable =
  ## viewsGet
  ## Gets the view by view name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  ##   viewName: string (required)
  ##           : View name
  var path_568205 = newJObject()
  var query_568206 = newJObject()
  add(query_568206, "api-version", newJString(apiVersion))
  add(path_568205, "viewName", newJString(viewName))
  result = call_568204.call(path_568205, query_568206, nil, nil, nil)

var viewsGet* = Call_ViewsGet_568184(name: "viewsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/providers/Microsoft.CostManagement/views/{viewName}",
                                  validator: validate_ViewsGet_568185, base: "",
                                  url: url_ViewsGet_568186,
                                  schemes: {Scheme.Https})
type
  Call_ViewsDelete_568218 = ref object of OpenApiRestCall_567659
proc url_ViewsDelete_568220(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "viewName" in path, "`viewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.CostManagement/views/"),
               (kind: VariableSegment, value: "viewName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ViewsDelete_568219(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a view.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   viewName: JString (required)
  ##           : View name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `viewName` field"
  var valid_568221 = path.getOrDefault("viewName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "viewName", valid_568221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568222 = query.getOrDefault("api-version")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "api-version", valid_568222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568223: Call_ViewsDelete_568218; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a view.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_ViewsDelete_568218; apiVersion: string; viewName: string): Recallable =
  ## viewsDelete
  ## The operation to delete a view.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  ##   viewName: string (required)
  ##           : View name
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  add(query_568226, "api-version", newJString(apiVersion))
  add(path_568225, "viewName", newJString(viewName))
  result = call_568224.call(path_568225, query_568226, nil, nil, nil)

var viewsDelete* = Call_ViewsDelete_568218(name: "viewsDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/providers/Microsoft.CostManagement/views/{viewName}",
                                        validator: validate_ViewsDelete_568219,
                                        base: "", url: url_ViewsDelete_568220,
                                        schemes: {Scheme.Https})
type
  Call_BudgetsList_568227 = ref object of OpenApiRestCall_567659
proc url_BudgetsList_568229(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/budgets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsList_568228(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all budgets for the defined scope.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/cost-management/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with budget operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for billingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for invoiceSection scope.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568230 = path.getOrDefault("scope")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "scope", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "api-version", valid_568231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568232: Call_BudgetsList_568227; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all budgets for the defined scope.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/cost-management/
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_BudgetsList_568227; apiVersion: string; scope: string): Recallable =
  ## budgetsList
  ## Lists all budgets for the defined scope.
  ## https://docs.microsoft.com/en-us/rest/api/cost-management/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  ##   scope: string (required)
  ##        : The scope associated with budget operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for billingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for invoiceSection scope.
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  add(query_568235, "api-version", newJString(apiVersion))
  add(path_568234, "scope", newJString(scope))
  result = call_568233.call(path_568234, query_568235, nil, nil, nil)

var budgetsList* = Call_BudgetsList_568227(name: "budgetsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/{scope}/providers/Microsoft.CostManagement/budgets",
                                        validator: validate_BudgetsList_568228,
                                        base: "", url: url_BudgetsList_568229,
                                        schemes: {Scheme.Https})
type
  Call_BudgetCreateOrUpdate_568246 = ref object of OpenApiRestCall_567659
proc url_BudgetCreateOrUpdate_568248(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetCreateOrUpdate_568247(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/cost-management/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with budget operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for billingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for invoiceSection scope.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568266 = path.getOrDefault("scope")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "scope", valid_568266
  var valid_568267 = path.getOrDefault("budgetName")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "budgetName", valid_568267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568268 = query.getOrDefault("api-version")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "api-version", valid_568268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters supplied to the Create Budget operation.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568270: Call_BudgetCreateOrUpdate_568246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/cost-management/
  let valid = call_568270.validator(path, query, header, formData, body)
  let scheme = call_568270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568270.url(scheme.get, call_568270.host, call_568270.base,
                         call_568270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568270, url, valid)

proc call*(call_568271: Call_BudgetCreateOrUpdate_568246; apiVersion: string;
          scope: string; budgetName: string; parameters: JsonNode = nil): Recallable =
  ## budgetCreateOrUpdate
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/cost-management/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  ##   parameters: JObject
  ##             : Parameters supplied to the Create Budget operation.
  ##   scope: string (required)
  ##        : The scope associated with budget operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for billingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for invoiceSection scope.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568272 = newJObject()
  var query_568273 = newJObject()
  var body_568274 = newJObject()
  add(query_568273, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568274 = parameters
  add(path_568272, "scope", newJString(scope))
  add(path_568272, "budgetName", newJString(budgetName))
  result = call_568271.call(path_568272, query_568273, nil, nil, body_568274)

var budgetCreateOrUpdate* = Call_BudgetCreateOrUpdate_568246(
    name: "budgetCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.CostManagement/budgets/{budgetName}",
    validator: validate_BudgetCreateOrUpdate_568247, base: "",
    url: url_BudgetCreateOrUpdate_568248, schemes: {Scheme.Https})
type
  Call_BudgetGet_568236 = ref object of OpenApiRestCall_567659
proc url_BudgetGet_568238(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetGet_568237(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the budget for the scope by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/cost-management/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with budget operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for billingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for invoiceSection scope.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568239 = path.getOrDefault("scope")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "scope", valid_568239
  var valid_568240 = path.getOrDefault("budgetName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "budgetName", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568241 = query.getOrDefault("api-version")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "api-version", valid_568241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568242: Call_BudgetGet_568236; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the budget for the scope by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/cost-management/
  let valid = call_568242.validator(path, query, header, formData, body)
  let scheme = call_568242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568242.url(scheme.get, call_568242.host, call_568242.base,
                         call_568242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568242, url, valid)

proc call*(call_568243: Call_BudgetGet_568236; apiVersion: string; scope: string;
          budgetName: string): Recallable =
  ## budgetGet
  ## Gets the budget for the scope by budget name.
  ## https://docs.microsoft.com/en-us/rest/api/cost-management/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  ##   scope: string (required)
  ##        : The scope associated with budget operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for billingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for invoiceSection scope.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568244 = newJObject()
  var query_568245 = newJObject()
  add(query_568245, "api-version", newJString(apiVersion))
  add(path_568244, "scope", newJString(scope))
  add(path_568244, "budgetName", newJString(budgetName))
  result = call_568243.call(path_568244, query_568245, nil, nil, nil)

var budgetGet* = Call_BudgetGet_568236(name: "budgetGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/{scope}/providers/Microsoft.CostManagement/budgets/{budgetName}",
                                    validator: validate_BudgetGet_568237,
                                    base: "", url: url_BudgetGet_568238,
                                    schemes: {Scheme.Https})
type
  Call_BudgetDelete_568275 = ref object of OpenApiRestCall_567659
proc url_BudgetDelete_568277(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetDelete_568276(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/cost-management/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with budget operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for billingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for invoiceSection scope.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568278 = path.getOrDefault("scope")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "scope", valid_568278
  var valid_568279 = path.getOrDefault("budgetName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "budgetName", valid_568279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568280 = query.getOrDefault("api-version")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "api-version", valid_568280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568281: Call_BudgetDelete_568275; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/cost-management/
  let valid = call_568281.validator(path, query, header, formData, body)
  let scheme = call_568281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568281.url(scheme.get, call_568281.host, call_568281.base,
                         call_568281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568281, url, valid)

proc call*(call_568282: Call_BudgetDelete_568275; apiVersion: string; scope: string;
          budgetName: string): Recallable =
  ## budgetDelete
  ## The operation to delete a budget.
  ## https://docs.microsoft.com/en-us/rest/api/cost-management/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  ##   scope: string (required)
  ##        : The scope associated with budget operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for billingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for invoiceSection scope.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568283 = newJObject()
  var query_568284 = newJObject()
  add(query_568284, "api-version", newJString(apiVersion))
  add(path_568283, "scope", newJString(scope))
  add(path_568283, "budgetName", newJString(budgetName))
  result = call_568282.call(path_568283, query_568284, nil, nil, nil)

var budgetDelete* = Call_BudgetDelete_568275(name: "budgetDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.CostManagement/budgets/{budgetName}",
    validator: validate_BudgetDelete_568276, base: "", url: url_BudgetDelete_568277,
    schemes: {Scheme.Https})
type
  Call_ViewsListByScope_568285 = ref object of OpenApiRestCall_567659
proc url_ViewsListByScope_568287(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/views")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ViewsListByScope_568286(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all views at the given scope.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with view operations. This includes 'subscriptions/{subscriptionId}' for subscription scope, 'subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for BillingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for InvoiceSection scope, 'providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## 'providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}' for External Billing Account scope and 
  ## 'providers/Microsoft.CostManagement/externalSubscriptions/{externalSubscriptionName}' for External Subscription scope.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568288 = path.getOrDefault("scope")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "scope", valid_568288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568289 = query.getOrDefault("api-version")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "api-version", valid_568289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568290: Call_ViewsListByScope_568285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all views at the given scope.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568290.validator(path, query, header, formData, body)
  let scheme = call_568290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568290.url(scheme.get, call_568290.host, call_568290.base,
                         call_568290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568290, url, valid)

proc call*(call_568291: Call_ViewsListByScope_568285; apiVersion: string;
          scope: string): Recallable =
  ## viewsListByScope
  ## Lists all views at the given scope.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  ##   scope: string (required)
  ##        : The scope associated with view operations. This includes 'subscriptions/{subscriptionId}' for subscription scope, 'subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for BillingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for InvoiceSection scope, 'providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## 'providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}' for External Billing Account scope and 
  ## 'providers/Microsoft.CostManagement/externalSubscriptions/{externalSubscriptionName}' for External Subscription scope.
  var path_568292 = newJObject()
  var query_568293 = newJObject()
  add(query_568293, "api-version", newJString(apiVersion))
  add(path_568292, "scope", newJString(scope))
  result = call_568291.call(path_568292, query_568293, nil, nil, nil)

var viewsListByScope* = Call_ViewsListByScope_568285(name: "viewsListByScope",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.CostManagement/views",
    validator: validate_ViewsListByScope_568286, base: "",
    url: url_ViewsListByScope_568287, schemes: {Scheme.Https})
type
  Call_ViewsCreateOrUpdateByScope_568304 = ref object of OpenApiRestCall_567659
proc url_ViewsCreateOrUpdateByScope_568306(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "viewName" in path, "`viewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/views/"),
               (kind: VariableSegment, value: "viewName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ViewsCreateOrUpdateByScope_568305(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a view. Update operation requires latest eTag to be set in the request. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   viewName: JString (required)
  ##           : View name
  ##   scope: JString (required)
  ##        : The scope associated with view operations. This includes 'subscriptions/{subscriptionId}' for subscription scope, 'subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for BillingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for InvoiceSection scope, 'providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## 'providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}' for External Billing Account scope and 
  ## 'providers/Microsoft.CostManagement/externalSubscriptions/{externalSubscriptionName}' for External Subscription scope.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `viewName` field"
  var valid_568307 = path.getOrDefault("viewName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "viewName", valid_568307
  var valid_568308 = path.getOrDefault("scope")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "scope", valid_568308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568309 = query.getOrDefault("api-version")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "api-version", valid_568309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate View operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568311: Call_ViewsCreateOrUpdateByScope_568304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a view. Update operation requires latest eTag to be set in the request. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568311.validator(path, query, header, formData, body)
  let scheme = call_568311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568311.url(scheme.get, call_568311.host, call_568311.base,
                         call_568311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568311, url, valid)

proc call*(call_568312: Call_ViewsCreateOrUpdateByScope_568304; apiVersion: string;
          viewName: string; parameters: JsonNode; scope: string): Recallable =
  ## viewsCreateOrUpdateByScope
  ## The operation to create or update a view. Update operation requires latest eTag to be set in the request. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  ##   viewName: string (required)
  ##           : View name
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate View operation.
  ##   scope: string (required)
  ##        : The scope associated with view operations. This includes 'subscriptions/{subscriptionId}' for subscription scope, 'subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for BillingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for InvoiceSection scope, 'providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## 'providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}' for External Billing Account scope and 
  ## 'providers/Microsoft.CostManagement/externalSubscriptions/{externalSubscriptionName}' for External Subscription scope.
  var path_568313 = newJObject()
  var query_568314 = newJObject()
  var body_568315 = newJObject()
  add(query_568314, "api-version", newJString(apiVersion))
  add(path_568313, "viewName", newJString(viewName))
  if parameters != nil:
    body_568315 = parameters
  add(path_568313, "scope", newJString(scope))
  result = call_568312.call(path_568313, query_568314, nil, nil, body_568315)

var viewsCreateOrUpdateByScope* = Call_ViewsCreateOrUpdateByScope_568304(
    name: "viewsCreateOrUpdateByScope", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.CostManagement/views/{viewName}",
    validator: validate_ViewsCreateOrUpdateByScope_568305, base: "",
    url: url_ViewsCreateOrUpdateByScope_568306, schemes: {Scheme.Https})
type
  Call_ViewsGetByScope_568294 = ref object of OpenApiRestCall_567659
proc url_ViewsGetByScope_568296(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "viewName" in path, "`viewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/views/"),
               (kind: VariableSegment, value: "viewName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ViewsGetByScope_568295(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the view for the defined scope by view name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   viewName: JString (required)
  ##           : View name
  ##   scope: JString (required)
  ##        : The scope associated with view operations. This includes 'subscriptions/{subscriptionId}' for subscription scope, 'subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for BillingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for InvoiceSection scope, 'providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## 'providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}' for External Billing Account scope and 
  ## 'providers/Microsoft.CostManagement/externalSubscriptions/{externalSubscriptionName}' for External Subscription scope.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `viewName` field"
  var valid_568297 = path.getOrDefault("viewName")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "viewName", valid_568297
  var valid_568298 = path.getOrDefault("scope")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "scope", valid_568298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568299 = query.getOrDefault("api-version")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "api-version", valid_568299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568300: Call_ViewsGetByScope_568294; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the view for the defined scope by view name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568300.validator(path, query, header, formData, body)
  let scheme = call_568300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568300.url(scheme.get, call_568300.host, call_568300.base,
                         call_568300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568300, url, valid)

proc call*(call_568301: Call_ViewsGetByScope_568294; apiVersion: string;
          viewName: string; scope: string): Recallable =
  ## viewsGetByScope
  ## Gets the view for the defined scope by view name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  ##   viewName: string (required)
  ##           : View name
  ##   scope: string (required)
  ##        : The scope associated with view operations. This includes 'subscriptions/{subscriptionId}' for subscription scope, 'subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for BillingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for InvoiceSection scope, 'providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## 'providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}' for External Billing Account scope and 
  ## 'providers/Microsoft.CostManagement/externalSubscriptions/{externalSubscriptionName}' for External Subscription scope.
  var path_568302 = newJObject()
  var query_568303 = newJObject()
  add(query_568303, "api-version", newJString(apiVersion))
  add(path_568302, "viewName", newJString(viewName))
  add(path_568302, "scope", newJString(scope))
  result = call_568301.call(path_568302, query_568303, nil, nil, nil)

var viewsGetByScope* = Call_ViewsGetByScope_568294(name: "viewsGetByScope",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.CostManagement/views/{viewName}",
    validator: validate_ViewsGetByScope_568295, base: "", url: url_ViewsGetByScope_568296,
    schemes: {Scheme.Https})
type
  Call_ViewsDeleteByScope_568316 = ref object of OpenApiRestCall_567659
proc url_ViewsDeleteByScope_568318(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "viewName" in path, "`viewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/views/"),
               (kind: VariableSegment, value: "viewName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ViewsDeleteByScope_568317(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The operation to delete a view.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   viewName: JString (required)
  ##           : View name
  ##   scope: JString (required)
  ##        : The scope associated with view operations. This includes 'subscriptions/{subscriptionId}' for subscription scope, 'subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for BillingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for InvoiceSection scope, 'providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## 'providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}' for External Billing Account scope and 
  ## 'providers/Microsoft.CostManagement/externalSubscriptions/{externalSubscriptionName}' for External Subscription scope.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `viewName` field"
  var valid_568319 = path.getOrDefault("viewName")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "viewName", valid_568319
  var valid_568320 = path.getOrDefault("scope")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "scope", valid_568320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568321 = query.getOrDefault("api-version")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "api-version", valid_568321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568322: Call_ViewsDeleteByScope_568316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a view.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568322.validator(path, query, header, formData, body)
  let scheme = call_568322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568322.url(scheme.get, call_568322.host, call_568322.base,
                         call_568322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568322, url, valid)

proc call*(call_568323: Call_ViewsDeleteByScope_568316; apiVersion: string;
          viewName: string; scope: string): Recallable =
  ## viewsDeleteByScope
  ## The operation to delete a view.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-04-01-preview
  ##   viewName: string (required)
  ##           : View name
  ##   scope: string (required)
  ##        : The scope associated with view operations. This includes 'subscriptions/{subscriptionId}' for subscription scope, 'subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for BillingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for InvoiceSection scope, 'providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## 'providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}' for External Billing Account scope and 
  ## 'providers/Microsoft.CostManagement/externalSubscriptions/{externalSubscriptionName}' for External Subscription scope.
  var path_568324 = newJObject()
  var query_568325 = newJObject()
  add(query_568325, "api-version", newJString(apiVersion))
  add(path_568324, "viewName", newJString(viewName))
  add(path_568324, "scope", newJString(scope))
  result = call_568323.call(path_568324, query_568325, nil, nil, nil)

var viewsDeleteByScope* = Call_ViewsDeleteByScope_568316(
    name: "viewsDeleteByScope", meth: HttpMethod.HttpDelete,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.CostManagement/views/{viewName}",
    validator: validate_ViewsDeleteByScope_568317, base: "",
    url: url_ViewsDeleteByScope_568318, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
