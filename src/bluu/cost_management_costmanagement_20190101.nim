
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: CostManagementClient
## version: 2019-01-01
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
  ## Lists all of the available cost management REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
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
  ## Lists all of the available cost management REST API operations.
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
  ## Lists all of the available cost management REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  var query_568137 = newJObject()
  add(query_568137, "api-version", newJString(apiVersion))
  result = call_568136.call(nil, query_568137, nil, nil, nil)

var operationsList* = Call_OperationsList_567881(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/operations",
    validator: validate_OperationsList_567882, base: "", url: url_OperationsList_567883,
    schemes: {Scheme.Https})
type
  Call_DimensionsListBySubscription_568177 = ref object of OpenApiRestCall_567659
proc url_DimensionsListBySubscription_568179(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/dimensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DimensionsListBySubscription_568178(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the dimensions by the defined scope.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with dimension operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope and '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope..
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568195 = path.getOrDefault("scope")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "scope", valid_568195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   $expand: JString
  ##          : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N dimension data.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568196 = query.getOrDefault("api-version")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "api-version", valid_568196
  var valid_568197 = query.getOrDefault("$expand")
  valid_568197 = validateParameter(valid_568197, JString, required = false,
                                 default = nil)
  if valid_568197 != nil:
    section.add "$expand", valid_568197
  var valid_568198 = query.getOrDefault("$top")
  valid_568198 = validateParameter(valid_568198, JInt, required = false, default = nil)
  if valid_568198 != nil:
    section.add "$top", valid_568198
  var valid_568199 = query.getOrDefault("$skiptoken")
  valid_568199 = validateParameter(valid_568199, JString, required = false,
                                 default = nil)
  if valid_568199 != nil:
    section.add "$skiptoken", valid_568199
  var valid_568200 = query.getOrDefault("$filter")
  valid_568200 = validateParameter(valid_568200, JString, required = false,
                                 default = nil)
  if valid_568200 != nil:
    section.add "$filter", valid_568200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568201: Call_DimensionsListBySubscription_568177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by the defined scope.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568201.validator(path, query, header, formData, body)
  let scheme = call_568201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568201.url(scheme.get, call_568201.host, call_568201.base,
                         call_568201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568201, url, valid)

proc call*(call_568202: Call_DimensionsListBySubscription_568177;
          apiVersion: string; scope: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## dimensionsListBySubscription
  ## Lists the dimensions by the defined scope.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   Expand: string
  ##         : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N dimension data.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   scope: string (required)
  ##        : The scope associated with dimension operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope and '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope..
  ##   Filter: string
  ##         : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_568203 = newJObject()
  var query_568204 = newJObject()
  add(query_568204, "api-version", newJString(apiVersion))
  add(query_568204, "$expand", newJString(Expand))
  add(query_568204, "$top", newJInt(Top))
  add(query_568204, "$skiptoken", newJString(Skiptoken))
  add(path_568203, "scope", newJString(scope))
  add(query_568204, "$filter", newJString(Filter))
  result = call_568202.call(path_568203, query_568204, nil, nil, nil)

var dimensionsListBySubscription* = Call_DimensionsListBySubscription_568177(
    name: "dimensionsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListBySubscription_568178, base: "",
    url: url_DimensionsListBySubscription_568179, schemes: {Scheme.Https})
type
  Call_ExportsList_568205 = ref object of OpenApiRestCall_567659
proc url_ExportsList_568207(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/exports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportsList_568206(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all exports at the given scope.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with export operations. This includes '/subscriptions/{subscriptionId}' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope and 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568208 = path.getOrDefault("scope")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "scope", valid_568208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568209 = query.getOrDefault("api-version")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "api-version", valid_568209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568210: Call_ExportsList_568205; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all exports at the given scope.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_ExportsList_568205; apiVersion: string; scope: string): Recallable =
  ## exportsList
  ## Lists all exports at the given scope.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   scope: string (required)
  ##        : The scope associated with export operations. This includes '/subscriptions/{subscriptionId}' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope and 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope.
  var path_568212 = newJObject()
  var query_568213 = newJObject()
  add(query_568213, "api-version", newJString(apiVersion))
  add(path_568212, "scope", newJString(scope))
  result = call_568211.call(path_568212, query_568213, nil, nil, nil)

var exportsList* = Call_ExportsList_568205(name: "exportsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/{scope}/providers/Microsoft.CostManagement/exports",
                                        validator: validate_ExportsList_568206,
                                        base: "", url: url_ExportsList_568207,
                                        schemes: {Scheme.Https})
type
  Call_ExportsCreateOrUpdate_568224 = ref object of OpenApiRestCall_567659
proc url_ExportsCreateOrUpdate_568226(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "exportName" in path, "`exportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/exports/"),
               (kind: VariableSegment, value: "exportName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportsCreateOrUpdate_568225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a export. Update operation requires latest eTag to be set in the request. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   exportName: JString (required)
  ##             : Export Name.
  ##   scope: JString (required)
  ##        : The scope associated with export operations. This includes '/subscriptions/{subscriptionId}' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope and 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `exportName` field"
  var valid_568227 = path.getOrDefault("exportName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "exportName", valid_568227
  var valid_568228 = path.getOrDefault("scope")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "scope", valid_568228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568229 = query.getOrDefault("api-version")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "api-version", valid_568229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Export operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568231: Call_ExportsCreateOrUpdate_568224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a export. Update operation requires latest eTag to be set in the request. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568231.validator(path, query, header, formData, body)
  let scheme = call_568231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568231.url(scheme.get, call_568231.host, call_568231.base,
                         call_568231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568231, url, valid)

proc call*(call_568232: Call_ExportsCreateOrUpdate_568224; exportName: string;
          apiVersion: string; parameters: JsonNode; scope: string): Recallable =
  ## exportsCreateOrUpdate
  ## The operation to create or update a export. Update operation requires latest eTag to be set in the request. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   exportName: string (required)
  ##             : Export Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Export operation.
  ##   scope: string (required)
  ##        : The scope associated with export operations. This includes '/subscriptions/{subscriptionId}' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope and 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope.
  var path_568233 = newJObject()
  var query_568234 = newJObject()
  var body_568235 = newJObject()
  add(path_568233, "exportName", newJString(exportName))
  add(query_568234, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568235 = parameters
  add(path_568233, "scope", newJString(scope))
  result = call_568232.call(path_568233, query_568234, nil, nil, body_568235)

var exportsCreateOrUpdate* = Call_ExportsCreateOrUpdate_568224(
    name: "exportsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.CostManagement/exports/{exportName}",
    validator: validate_ExportsCreateOrUpdate_568225, base: "",
    url: url_ExportsCreateOrUpdate_568226, schemes: {Scheme.Https})
type
  Call_ExportsGet_568214 = ref object of OpenApiRestCall_567659
proc url_ExportsGet_568216(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "exportName" in path, "`exportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/exports/"),
               (kind: VariableSegment, value: "exportName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportsGet_568215(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the export for the defined scope by export name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   exportName: JString (required)
  ##             : Export Name.
  ##   scope: JString (required)
  ##        : The scope associated with export operations. This includes '/subscriptions/{subscriptionId}' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope and 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `exportName` field"
  var valid_568217 = path.getOrDefault("exportName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "exportName", valid_568217
  var valid_568218 = path.getOrDefault("scope")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "scope", valid_568218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568219 = query.getOrDefault("api-version")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "api-version", valid_568219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568220: Call_ExportsGet_568214; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the export for the defined scope by export name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568220.validator(path, query, header, formData, body)
  let scheme = call_568220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568220.url(scheme.get, call_568220.host, call_568220.base,
                         call_568220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568220, url, valid)

proc call*(call_568221: Call_ExportsGet_568214; exportName: string;
          apiVersion: string; scope: string): Recallable =
  ## exportsGet
  ## Gets the export for the defined scope by export name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   exportName: string (required)
  ##             : Export Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   scope: string (required)
  ##        : The scope associated with export operations. This includes '/subscriptions/{subscriptionId}' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope and 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope.
  var path_568222 = newJObject()
  var query_568223 = newJObject()
  add(path_568222, "exportName", newJString(exportName))
  add(query_568223, "api-version", newJString(apiVersion))
  add(path_568222, "scope", newJString(scope))
  result = call_568221.call(path_568222, query_568223, nil, nil, nil)

var exportsGet* = Call_ExportsGet_568214(name: "exportsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/{scope}/providers/Microsoft.CostManagement/exports/{exportName}",
                                      validator: validate_ExportsGet_568215,
                                      base: "", url: url_ExportsGet_568216,
                                      schemes: {Scheme.Https})
type
  Call_ExportsDelete_568236 = ref object of OpenApiRestCall_567659
proc url_ExportsDelete_568238(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "exportName" in path, "`exportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/exports/"),
               (kind: VariableSegment, value: "exportName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportsDelete_568237(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a export.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   exportName: JString (required)
  ##             : Export Name.
  ##   scope: JString (required)
  ##        : The scope associated with export operations. This includes '/subscriptions/{subscriptionId}' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope and 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `exportName` field"
  var valid_568239 = path.getOrDefault("exportName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "exportName", valid_568239
  var valid_568240 = path.getOrDefault("scope")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "scope", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
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

proc call*(call_568242: Call_ExportsDelete_568236; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a export.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568242.validator(path, query, header, formData, body)
  let scheme = call_568242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568242.url(scheme.get, call_568242.host, call_568242.base,
                         call_568242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568242, url, valid)

proc call*(call_568243: Call_ExportsDelete_568236; exportName: string;
          apiVersion: string; scope: string): Recallable =
  ## exportsDelete
  ## The operation to delete a export.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   exportName: string (required)
  ##             : Export Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   scope: string (required)
  ##        : The scope associated with export operations. This includes '/subscriptions/{subscriptionId}' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope and 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope.
  var path_568244 = newJObject()
  var query_568245 = newJObject()
  add(path_568244, "exportName", newJString(exportName))
  add(query_568245, "api-version", newJString(apiVersion))
  add(path_568244, "scope", newJString(scope))
  result = call_568243.call(path_568244, query_568245, nil, nil, nil)

var exportsDelete* = Call_ExportsDelete_568236(name: "exportsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.CostManagement/exports/{exportName}",
    validator: validate_ExportsDelete_568237, base: "", url: url_ExportsDelete_568238,
    schemes: {Scheme.Https})
type
  Call_ExportsExecute_568246 = ref object of OpenApiRestCall_567659
proc url_ExportsExecute_568248(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "exportName" in path, "`exportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/exports/"),
               (kind: VariableSegment, value: "exportName"),
               (kind: ConstantSegment, value: "/run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportsExecute_568247(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The operation to execute a export.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   exportName: JString (required)
  ##             : Export Name.
  ##   scope: JString (required)
  ##        : The scope associated with export operations. This includes '/subscriptions/{subscriptionId}' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope and 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `exportName` field"
  var valid_568249 = path.getOrDefault("exportName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "exportName", valid_568249
  var valid_568250 = path.getOrDefault("scope")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "scope", valid_568250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568251 = query.getOrDefault("api-version")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "api-version", valid_568251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568252: Call_ExportsExecute_568246; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to execute a export.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568252.validator(path, query, header, formData, body)
  let scheme = call_568252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568252.url(scheme.get, call_568252.host, call_568252.base,
                         call_568252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568252, url, valid)

proc call*(call_568253: Call_ExportsExecute_568246; exportName: string;
          apiVersion: string; scope: string): Recallable =
  ## exportsExecute
  ## The operation to execute a export.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   exportName: string (required)
  ##             : Export Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   scope: string (required)
  ##        : The scope associated with export operations. This includes '/subscriptions/{subscriptionId}' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope and 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope.
  var path_568254 = newJObject()
  var query_568255 = newJObject()
  add(path_568254, "exportName", newJString(exportName))
  add(query_568255, "api-version", newJString(apiVersion))
  add(path_568254, "scope", newJString(scope))
  result = call_568253.call(path_568254, query_568255, nil, nil, nil)

var exportsExecute* = Call_ExportsExecute_568246(name: "exportsExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/{scope}/providers/Microsoft.CostManagement/exports/{exportName}/run",
    validator: validate_ExportsExecute_568247, base: "", url: url_ExportsExecute_568248,
    schemes: {Scheme.Https})
type
  Call_ExportsGetExecutionHistory_568256 = ref object of OpenApiRestCall_567659
proc url_ExportsGetExecutionHistory_568258(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "exportName" in path, "`exportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/exports/"),
               (kind: VariableSegment, value: "exportName"),
               (kind: ConstantSegment, value: "/runHistory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportsGetExecutionHistory_568257(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the execution history of a export for the defined scope by export name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   exportName: JString (required)
  ##             : Export Name.
  ##   scope: JString (required)
  ##        : The scope associated with export operations. This includes '/subscriptions/{subscriptionId}' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope and 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `exportName` field"
  var valid_568259 = path.getOrDefault("exportName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "exportName", valid_568259
  var valid_568260 = path.getOrDefault("scope")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "scope", valid_568260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568261 = query.getOrDefault("api-version")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "api-version", valid_568261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568262: Call_ExportsGetExecutionHistory_568256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the execution history of a export for the defined scope by export name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568262.validator(path, query, header, formData, body)
  let scheme = call_568262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568262.url(scheme.get, call_568262.host, call_568262.base,
                         call_568262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568262, url, valid)

proc call*(call_568263: Call_ExportsGetExecutionHistory_568256; exportName: string;
          apiVersion: string; scope: string): Recallable =
  ## exportsGetExecutionHistory
  ## Gets the execution history of a export for the defined scope by export name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   exportName: string (required)
  ##             : Export Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   scope: string (required)
  ##        : The scope associated with export operations. This includes '/subscriptions/{subscriptionId}' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope and 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope.
  var path_568264 = newJObject()
  var query_568265 = newJObject()
  add(path_568264, "exportName", newJString(exportName))
  add(query_568265, "api-version", newJString(apiVersion))
  add(path_568264, "scope", newJString(scope))
  result = call_568263.call(path_568264, query_568265, nil, nil, nil)

var exportsGetExecutionHistory* = Call_ExportsGetExecutionHistory_568256(
    name: "exportsGetExecutionHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.CostManagement/exports/{exportName}/runHistory",
    validator: validate_ExportsGetExecutionHistory_568257, base: "",
    url: url_ExportsGetExecutionHistory_568258, schemes: {Scheme.Https})
type
  Call_QueryUsageByScope_568266 = ref object of OpenApiRestCall_567659
proc url_QueryUsageByScope_568268(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryUsageByScope_568267(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Query the usage data for scope defined.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with query operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope and 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope and '/providers/Microsoft.Management/managementGroups/{managementGroupId} for Management Group scope..
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568286 = path.getOrDefault("scope")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "scope", valid_568286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568287 = query.getOrDefault("api-version")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "api-version", valid_568287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Query Config operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568289: Call_QueryUsageByScope_568266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the usage data for scope defined.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568289.validator(path, query, header, formData, body)
  let scheme = call_568289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568289.url(scheme.get, call_568289.host, call_568289.base,
                         call_568289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568289, url, valid)

proc call*(call_568290: Call_QueryUsageByScope_568266; apiVersion: string;
          parameters: JsonNode; scope: string): Recallable =
  ## queryUsageByScope
  ## Query the usage data for scope defined.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Query Config operation.
  ##   scope: string (required)
  ##        : The scope associated with query operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope and 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope and '/providers/Microsoft.Management/managementGroups/{managementGroupId} for Management Group scope..
  var path_568291 = newJObject()
  var query_568292 = newJObject()
  var body_568293 = newJObject()
  add(query_568292, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568293 = parameters
  add(path_568291, "scope", newJString(scope))
  result = call_568290.call(path_568291, query_568292, nil, nil, body_568293)

var queryUsageByScope* = Call_QueryUsageByScope_568266(name: "queryUsageByScope",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.CostManagement/query",
    validator: validate_QueryUsageByScope_568267, base: "",
    url: url_QueryUsageByScope_568268, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
