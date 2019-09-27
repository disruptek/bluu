
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure ML Commitment Plans Management Client
## version: 2016-05-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## These APIs allow end users to operate on Azure Machine Learning Commitment Plans resources and their child Commitment Association resources. They support CRUD operations for commitment plans, get and list operations for commitment associations, moving commitment associations between commitment plans, and retrieving commitment plan usage history.
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

  OpenApiRestCall_593409 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593409](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593409): Option[Scheme] {.used.} =
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
  macServiceName = "machinelearning-commitmentPlans"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593631 = ref object of OpenApiRestCall_593409
proc url_OperationsList_593633(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593632(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Azure Machine Learning Studio Commitment Plan RP REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593792 = query.getOrDefault("api-version")
  valid_593792 = validateParameter(valid_593792, JString, required = true,
                                 default = nil)
  if valid_593792 != nil:
    section.add "api-version", valid_593792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593815: Call_OperationsList_593631; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Azure Machine Learning Studio Commitment Plan RP REST API operations.
  ## 
  let valid = call_593815.validator(path, query, header, formData, body)
  let scheme = call_593815.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593815.url(scheme.get, call_593815.host, call_593815.base,
                         call_593815.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593815, url, valid)

proc call*(call_593886: Call_OperationsList_593631; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Azure Machine Learning Studio Commitment Plan RP REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  var query_593887 = newJObject()
  add(query_593887, "api-version", newJString(apiVersion))
  result = call_593886.call(nil, query_593887, nil, nil, nil)

var operationsList* = Call_OperationsList_593631(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MachineLearning/operations",
    validator: validate_OperationsList_593632, base: "", url: url_OperationsList_593633,
    schemes: {Scheme.Https})
type
  Call_CommitmentPlansList_593927 = ref object of OpenApiRestCall_593409
proc url_CommitmentPlansList_593929(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/commitmentPlans")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CommitmentPlansList_593928(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieve all Azure ML commitment plans in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593945 = path.getOrDefault("subscriptionId")
  valid_593945 = validateParameter(valid_593945, JString, required = true,
                                 default = nil)
  if valid_593945 != nil:
    section.add "subscriptionId", valid_593945
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   $skipToken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593946 = query.getOrDefault("api-version")
  valid_593946 = validateParameter(valid_593946, JString, required = true,
                                 default = nil)
  if valid_593946 != nil:
    section.add "api-version", valid_593946
  var valid_593947 = query.getOrDefault("$skipToken")
  valid_593947 = validateParameter(valid_593947, JString, required = false,
                                 default = nil)
  if valid_593947 != nil:
    section.add "$skipToken", valid_593947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593948: Call_CommitmentPlansList_593927; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all Azure ML commitment plans in a subscription.
  ## 
  let valid = call_593948.validator(path, query, header, formData, body)
  let scheme = call_593948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593948.url(scheme.get, call_593948.host, call_593948.base,
                         call_593948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593948, url, valid)

proc call*(call_593949: Call_CommitmentPlansList_593927; apiVersion: string;
          subscriptionId: string; SkipToken: string = ""): Recallable =
  ## commitmentPlansList
  ## Retrieve all Azure ML commitment plans in a subscription.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   SkipToken: string
  ##            : Continuation token for pagination.
  var path_593950 = newJObject()
  var query_593951 = newJObject()
  add(query_593951, "api-version", newJString(apiVersion))
  add(path_593950, "subscriptionId", newJString(subscriptionId))
  add(query_593951, "$skipToken", newJString(SkipToken))
  result = call_593949.call(path_593950, query_593951, nil, nil, nil)

var commitmentPlansList* = Call_CommitmentPlansList_593927(
    name: "commitmentPlansList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearning/commitmentPlans",
    validator: validate_CommitmentPlansList_593928, base: "",
    url: url_CommitmentPlansList_593929, schemes: {Scheme.Https})
type
  Call_SkusList_593952 = ref object of OpenApiRestCall_593409
proc url_SkusList_593954(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.MachineLearning/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SkusList_593953(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the available commitment plan SKUs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593955 = path.getOrDefault("subscriptionId")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "subscriptionId", valid_593955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593956 = query.getOrDefault("api-version")
  valid_593956 = validateParameter(valid_593956, JString, required = true,
                                 default = nil)
  if valid_593956 != nil:
    section.add "api-version", valid_593956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593957: Call_SkusList_593952; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available commitment plan SKUs.
  ## 
  let valid = call_593957.validator(path, query, header, formData, body)
  let scheme = call_593957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593957.url(scheme.get, call_593957.host, call_593957.base,
                         call_593957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593957, url, valid)

proc call*(call_593958: Call_SkusList_593952; apiVersion: string;
          subscriptionId: string): Recallable =
  ## skusList
  ## Lists the available commitment plan SKUs.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_593959 = newJObject()
  var query_593960 = newJObject()
  add(query_593960, "api-version", newJString(apiVersion))
  add(path_593959, "subscriptionId", newJString(subscriptionId))
  result = call_593958.call(path_593959, query_593960, nil, nil, nil)

var skusList* = Call_SkusList_593952(name: "skusList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearning/skus",
                                  validator: validate_SkusList_593953, base: "",
                                  url: url_SkusList_593954,
                                  schemes: {Scheme.Https})
type
  Call_CommitmentPlansListInResourceGroup_593961 = ref object of OpenApiRestCall_593409
proc url_CommitmentPlansListInResourceGroup_593963(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/commitmentPlans")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CommitmentPlansListInResourceGroup_593962(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve all Azure ML commitment plans in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593964 = path.getOrDefault("resourceGroupName")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "resourceGroupName", valid_593964
  var valid_593965 = path.getOrDefault("subscriptionId")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "subscriptionId", valid_593965
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   $skipToken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593966 = query.getOrDefault("api-version")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "api-version", valid_593966
  var valid_593967 = query.getOrDefault("$skipToken")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "$skipToken", valid_593967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593968: Call_CommitmentPlansListInResourceGroup_593961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve all Azure ML commitment plans in a resource group.
  ## 
  let valid = call_593968.validator(path, query, header, formData, body)
  let scheme = call_593968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593968.url(scheme.get, call_593968.host, call_593968.base,
                         call_593968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593968, url, valid)

proc call*(call_593969: Call_CommitmentPlansListInResourceGroup_593961;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          SkipToken: string = ""): Recallable =
  ## commitmentPlansListInResourceGroup
  ## Retrieve all Azure ML commitment plans in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   SkipToken: string
  ##            : Continuation token for pagination.
  var path_593970 = newJObject()
  var query_593971 = newJObject()
  add(path_593970, "resourceGroupName", newJString(resourceGroupName))
  add(query_593971, "api-version", newJString(apiVersion))
  add(path_593970, "subscriptionId", newJString(subscriptionId))
  add(query_593971, "$skipToken", newJString(SkipToken))
  result = call_593969.call(path_593970, query_593971, nil, nil, nil)

var commitmentPlansListInResourceGroup* = Call_CommitmentPlansListInResourceGroup_593961(
    name: "commitmentPlansListInResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans",
    validator: validate_CommitmentPlansListInResourceGroup_593962, base: "",
    url: url_CommitmentPlansListInResourceGroup_593963, schemes: {Scheme.Https})
type
  Call_CommitmentPlansCreateOrUpdate_593983 = ref object of OpenApiRestCall_593409
proc url_CommitmentPlansCreateOrUpdate_593985(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "commitmentPlanName" in path,
        "`commitmentPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/commitmentPlans/"),
               (kind: VariableSegment, value: "commitmentPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CommitmentPlansCreateOrUpdate_593984(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new Azure ML commitment plan resource or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   commitmentPlanName: JString (required)
  ##                     : The Azure ML commitment plan name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593986 = path.getOrDefault("resourceGroupName")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "resourceGroupName", valid_593986
  var valid_593987 = path.getOrDefault("commitmentPlanName")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "commitmentPlanName", valid_593987
  var valid_593988 = path.getOrDefault("subscriptionId")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "subscriptionId", valid_593988
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593989 = query.getOrDefault("api-version")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "api-version", valid_593989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createOrUpdatePayload: JObject (required)
  ##                        : The payload to create or update the Azure ML commitment plan.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593991: Call_CommitmentPlansCreateOrUpdate_593983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new Azure ML commitment plan resource or updates an existing one.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_CommitmentPlansCreateOrUpdate_593983;
          resourceGroupName: string; apiVersion: string; commitmentPlanName: string;
          subscriptionId: string; createOrUpdatePayload: JsonNode): Recallable =
  ## commitmentPlansCreateOrUpdate
  ## Create a new Azure ML commitment plan resource or updates an existing one.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   commitmentPlanName: string (required)
  ##                     : The Azure ML commitment plan name.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   createOrUpdatePayload: JObject (required)
  ##                        : The payload to create or update the Azure ML commitment plan.
  var path_593993 = newJObject()
  var query_593994 = newJObject()
  var body_593995 = newJObject()
  add(path_593993, "resourceGroupName", newJString(resourceGroupName))
  add(query_593994, "api-version", newJString(apiVersion))
  add(path_593993, "commitmentPlanName", newJString(commitmentPlanName))
  add(path_593993, "subscriptionId", newJString(subscriptionId))
  if createOrUpdatePayload != nil:
    body_593995 = createOrUpdatePayload
  result = call_593992.call(path_593993, query_593994, nil, nil, body_593995)

var commitmentPlansCreateOrUpdate* = Call_CommitmentPlansCreateOrUpdate_593983(
    name: "commitmentPlansCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans/{commitmentPlanName}",
    validator: validate_CommitmentPlansCreateOrUpdate_593984, base: "",
    url: url_CommitmentPlansCreateOrUpdate_593985, schemes: {Scheme.Https})
type
  Call_CommitmentPlansGet_593972 = ref object of OpenApiRestCall_593409
proc url_CommitmentPlansGet_593974(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "commitmentPlanName" in path,
        "`commitmentPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/commitmentPlans/"),
               (kind: VariableSegment, value: "commitmentPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CommitmentPlansGet_593973(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieve an Azure ML commitment plan by its subscription, resource group and name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   commitmentPlanName: JString (required)
  ##                     : The Azure ML commitment plan name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593975 = path.getOrDefault("resourceGroupName")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "resourceGroupName", valid_593975
  var valid_593976 = path.getOrDefault("commitmentPlanName")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "commitmentPlanName", valid_593976
  var valid_593977 = path.getOrDefault("subscriptionId")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "subscriptionId", valid_593977
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593978 = query.getOrDefault("api-version")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "api-version", valid_593978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593979: Call_CommitmentPlansGet_593972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve an Azure ML commitment plan by its subscription, resource group and name.
  ## 
  let valid = call_593979.validator(path, query, header, formData, body)
  let scheme = call_593979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593979.url(scheme.get, call_593979.host, call_593979.base,
                         call_593979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593979, url, valid)

proc call*(call_593980: Call_CommitmentPlansGet_593972; resourceGroupName: string;
          apiVersion: string; commitmentPlanName: string; subscriptionId: string): Recallable =
  ## commitmentPlansGet
  ## Retrieve an Azure ML commitment plan by its subscription, resource group and name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   commitmentPlanName: string (required)
  ##                     : The Azure ML commitment plan name.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_593981 = newJObject()
  var query_593982 = newJObject()
  add(path_593981, "resourceGroupName", newJString(resourceGroupName))
  add(query_593982, "api-version", newJString(apiVersion))
  add(path_593981, "commitmentPlanName", newJString(commitmentPlanName))
  add(path_593981, "subscriptionId", newJString(subscriptionId))
  result = call_593980.call(path_593981, query_593982, nil, nil, nil)

var commitmentPlansGet* = Call_CommitmentPlansGet_593972(
    name: "commitmentPlansGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans/{commitmentPlanName}",
    validator: validate_CommitmentPlansGet_593973, base: "",
    url: url_CommitmentPlansGet_593974, schemes: {Scheme.Https})
type
  Call_CommitmentPlansPatch_594007 = ref object of OpenApiRestCall_593409
proc url_CommitmentPlansPatch_594009(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "commitmentPlanName" in path,
        "`commitmentPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/commitmentPlans/"),
               (kind: VariableSegment, value: "commitmentPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CommitmentPlansPatch_594008(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch an existing Azure ML commitment plan resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   commitmentPlanName: JString (required)
  ##                     : The Azure ML commitment plan name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594010 = path.getOrDefault("resourceGroupName")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "resourceGroupName", valid_594010
  var valid_594011 = path.getOrDefault("commitmentPlanName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "commitmentPlanName", valid_594011
  var valid_594012 = path.getOrDefault("subscriptionId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "subscriptionId", valid_594012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594013 = query.getOrDefault("api-version")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "api-version", valid_594013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patchPayload: JObject (required)
  ##               : The payload to use to patch the Azure ML commitment plan. Only tags and SKU may be modified on an existing commitment plan.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_CommitmentPlansPatch_594007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch an existing Azure ML commitment plan resource.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_CommitmentPlansPatch_594007;
          resourceGroupName: string; apiVersion: string; commitmentPlanName: string;
          subscriptionId: string; patchPayload: JsonNode): Recallable =
  ## commitmentPlansPatch
  ## Patch an existing Azure ML commitment plan resource.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   commitmentPlanName: string (required)
  ##                     : The Azure ML commitment plan name.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   patchPayload: JObject (required)
  ##               : The payload to use to patch the Azure ML commitment plan. Only tags and SKU may be modified on an existing commitment plan.
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  var body_594019 = newJObject()
  add(path_594017, "resourceGroupName", newJString(resourceGroupName))
  add(query_594018, "api-version", newJString(apiVersion))
  add(path_594017, "commitmentPlanName", newJString(commitmentPlanName))
  add(path_594017, "subscriptionId", newJString(subscriptionId))
  if patchPayload != nil:
    body_594019 = patchPayload
  result = call_594016.call(path_594017, query_594018, nil, nil, body_594019)

var commitmentPlansPatch* = Call_CommitmentPlansPatch_594007(
    name: "commitmentPlansPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans/{commitmentPlanName}",
    validator: validate_CommitmentPlansPatch_594008, base: "",
    url: url_CommitmentPlansPatch_594009, schemes: {Scheme.Https})
type
  Call_CommitmentPlansRemove_593996 = ref object of OpenApiRestCall_593409
proc url_CommitmentPlansRemove_593998(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "commitmentPlanName" in path,
        "`commitmentPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/commitmentPlans/"),
               (kind: VariableSegment, value: "commitmentPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CommitmentPlansRemove_593997(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove an existing Azure ML commitment plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   commitmentPlanName: JString (required)
  ##                     : The Azure ML commitment plan name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593999 = path.getOrDefault("resourceGroupName")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "resourceGroupName", valid_593999
  var valid_594000 = path.getOrDefault("commitmentPlanName")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "commitmentPlanName", valid_594000
  var valid_594001 = path.getOrDefault("subscriptionId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "subscriptionId", valid_594001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594002 = query.getOrDefault("api-version")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "api-version", valid_594002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594003: Call_CommitmentPlansRemove_593996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove an existing Azure ML commitment plan.
  ## 
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_CommitmentPlansRemove_593996;
          resourceGroupName: string; apiVersion: string; commitmentPlanName: string;
          subscriptionId: string): Recallable =
  ## commitmentPlansRemove
  ## Remove an existing Azure ML commitment plan.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   commitmentPlanName: string (required)
  ##                     : The Azure ML commitment plan name.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  add(path_594005, "resourceGroupName", newJString(resourceGroupName))
  add(query_594006, "api-version", newJString(apiVersion))
  add(path_594005, "commitmentPlanName", newJString(commitmentPlanName))
  add(path_594005, "subscriptionId", newJString(subscriptionId))
  result = call_594004.call(path_594005, query_594006, nil, nil, nil)

var commitmentPlansRemove* = Call_CommitmentPlansRemove_593996(
    name: "commitmentPlansRemove", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans/{commitmentPlanName}",
    validator: validate_CommitmentPlansRemove_593997, base: "",
    url: url_CommitmentPlansRemove_593998, schemes: {Scheme.Https})
type
  Call_CommitmentAssociationsList_594020 = ref object of OpenApiRestCall_593409
proc url_CommitmentAssociationsList_594022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "commitmentPlanName" in path,
        "`commitmentPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/commitmentPlans/"),
               (kind: VariableSegment, value: "commitmentPlanName"),
               (kind: ConstantSegment, value: "/commitmentAssociations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CommitmentAssociationsList_594021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all commitment associations for a parent commitment plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   commitmentPlanName: JString (required)
  ##                     : The Azure ML commitment plan name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594023 = path.getOrDefault("resourceGroupName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "resourceGroupName", valid_594023
  var valid_594024 = path.getOrDefault("commitmentPlanName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "commitmentPlanName", valid_594024
  var valid_594025 = path.getOrDefault("subscriptionId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "subscriptionId", valid_594025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   $skipToken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594026 = query.getOrDefault("api-version")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "api-version", valid_594026
  var valid_594027 = query.getOrDefault("$skipToken")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "$skipToken", valid_594027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594028: Call_CommitmentAssociationsList_594020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all commitment associations for a parent commitment plan.
  ## 
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_CommitmentAssociationsList_594020;
          resourceGroupName: string; apiVersion: string; commitmentPlanName: string;
          subscriptionId: string; SkipToken: string = ""): Recallable =
  ## commitmentAssociationsList
  ## Get all commitment associations for a parent commitment plan.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   commitmentPlanName: string (required)
  ##                     : The Azure ML commitment plan name.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   SkipToken: string
  ##            : Continuation token for pagination.
  var path_594030 = newJObject()
  var query_594031 = newJObject()
  add(path_594030, "resourceGroupName", newJString(resourceGroupName))
  add(query_594031, "api-version", newJString(apiVersion))
  add(path_594030, "commitmentPlanName", newJString(commitmentPlanName))
  add(path_594030, "subscriptionId", newJString(subscriptionId))
  add(query_594031, "$skipToken", newJString(SkipToken))
  result = call_594029.call(path_594030, query_594031, nil, nil, nil)

var commitmentAssociationsList* = Call_CommitmentAssociationsList_594020(
    name: "commitmentAssociationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans/{commitmentPlanName}/commitmentAssociations",
    validator: validate_CommitmentAssociationsList_594021, base: "",
    url: url_CommitmentAssociationsList_594022, schemes: {Scheme.Https})
type
  Call_CommitmentAssociationsGet_594032 = ref object of OpenApiRestCall_593409
proc url_CommitmentAssociationsGet_594034(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "commitmentPlanName" in path,
        "`commitmentPlanName` is a required path parameter"
  assert "commitmentAssociationName" in path,
        "`commitmentAssociationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/commitmentPlans/"),
               (kind: VariableSegment, value: "commitmentPlanName"),
               (kind: ConstantSegment, value: "/commitmentAssociations/"),
               (kind: VariableSegment, value: "commitmentAssociationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CommitmentAssociationsGet_594033(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a commitment association.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   commitmentAssociationName: JString (required)
  ##                            : The commitment association name.
  ##   commitmentPlanName: JString (required)
  ##                     : The Azure ML commitment plan name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594035 = path.getOrDefault("resourceGroupName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "resourceGroupName", valid_594035
  var valid_594036 = path.getOrDefault("commitmentAssociationName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "commitmentAssociationName", valid_594036
  var valid_594037 = path.getOrDefault("commitmentPlanName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "commitmentPlanName", valid_594037
  var valid_594038 = path.getOrDefault("subscriptionId")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "subscriptionId", valid_594038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594039 = query.getOrDefault("api-version")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "api-version", valid_594039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594040: Call_CommitmentAssociationsGet_594032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a commitment association.
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_CommitmentAssociationsGet_594032;
          resourceGroupName: string; apiVersion: string;
          commitmentAssociationName: string; commitmentPlanName: string;
          subscriptionId: string): Recallable =
  ## commitmentAssociationsGet
  ## Get a commitment association.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   commitmentAssociationName: string (required)
  ##                            : The commitment association name.
  ##   commitmentPlanName: string (required)
  ##                     : The Azure ML commitment plan name.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_594042 = newJObject()
  var query_594043 = newJObject()
  add(path_594042, "resourceGroupName", newJString(resourceGroupName))
  add(query_594043, "api-version", newJString(apiVersion))
  add(path_594042, "commitmentAssociationName",
      newJString(commitmentAssociationName))
  add(path_594042, "commitmentPlanName", newJString(commitmentPlanName))
  add(path_594042, "subscriptionId", newJString(subscriptionId))
  result = call_594041.call(path_594042, query_594043, nil, nil, nil)

var commitmentAssociationsGet* = Call_CommitmentAssociationsGet_594032(
    name: "commitmentAssociationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans/{commitmentPlanName}/commitmentAssociations/{commitmentAssociationName}",
    validator: validate_CommitmentAssociationsGet_594033, base: "",
    url: url_CommitmentAssociationsGet_594034, schemes: {Scheme.Https})
type
  Call_CommitmentAssociationsMove_594044 = ref object of OpenApiRestCall_593409
proc url_CommitmentAssociationsMove_594046(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "commitmentPlanName" in path,
        "`commitmentPlanName` is a required path parameter"
  assert "commitmentAssociationName" in path,
        "`commitmentAssociationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/commitmentPlans/"),
               (kind: VariableSegment, value: "commitmentPlanName"),
               (kind: ConstantSegment, value: "/commitmentAssociations/"),
               (kind: VariableSegment, value: "commitmentAssociationName"),
               (kind: ConstantSegment, value: "/move")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CommitmentAssociationsMove_594045(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Re-parent a commitment association from one commitment plan to another.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   commitmentAssociationName: JString (required)
  ##                            : The commitment association name.
  ##   commitmentPlanName: JString (required)
  ##                     : The Azure ML commitment plan name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594047 = path.getOrDefault("resourceGroupName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "resourceGroupName", valid_594047
  var valid_594048 = path.getOrDefault("commitmentAssociationName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "commitmentAssociationName", valid_594048
  var valid_594049 = path.getOrDefault("commitmentPlanName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "commitmentPlanName", valid_594049
  var valid_594050 = path.getOrDefault("subscriptionId")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "subscriptionId", valid_594050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594051 = query.getOrDefault("api-version")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "api-version", valid_594051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   movePayload: JObject (required)
  ##              : The move request payload.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594053: Call_CommitmentAssociationsMove_594044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Re-parent a commitment association from one commitment plan to another.
  ## 
  let valid = call_594053.validator(path, query, header, formData, body)
  let scheme = call_594053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594053.url(scheme.get, call_594053.host, call_594053.base,
                         call_594053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594053, url, valid)

proc call*(call_594054: Call_CommitmentAssociationsMove_594044;
          resourceGroupName: string; apiVersion: string;
          commitmentAssociationName: string; commitmentPlanName: string;
          subscriptionId: string; movePayload: JsonNode): Recallable =
  ## commitmentAssociationsMove
  ## Re-parent a commitment association from one commitment plan to another.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   commitmentAssociationName: string (required)
  ##                            : The commitment association name.
  ##   commitmentPlanName: string (required)
  ##                     : The Azure ML commitment plan name.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   movePayload: JObject (required)
  ##              : The move request payload.
  var path_594055 = newJObject()
  var query_594056 = newJObject()
  var body_594057 = newJObject()
  add(path_594055, "resourceGroupName", newJString(resourceGroupName))
  add(query_594056, "api-version", newJString(apiVersion))
  add(path_594055, "commitmentAssociationName",
      newJString(commitmentAssociationName))
  add(path_594055, "commitmentPlanName", newJString(commitmentPlanName))
  add(path_594055, "subscriptionId", newJString(subscriptionId))
  if movePayload != nil:
    body_594057 = movePayload
  result = call_594054.call(path_594055, query_594056, nil, nil, body_594057)

var commitmentAssociationsMove* = Call_CommitmentAssociationsMove_594044(
    name: "commitmentAssociationsMove", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans/{commitmentPlanName}/commitmentAssociations/{commitmentAssociationName}/move",
    validator: validate_CommitmentAssociationsMove_594045, base: "",
    url: url_CommitmentAssociationsMove_594046, schemes: {Scheme.Https})
type
  Call_UsageHistoryList_594058 = ref object of OpenApiRestCall_593409
proc url_UsageHistoryList_594060(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "commitmentPlanName" in path,
        "`commitmentPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/commitmentPlans/"),
               (kind: VariableSegment, value: "commitmentPlanName"),
               (kind: ConstantSegment, value: "/usageHistory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageHistoryList_594059(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieve the usage history for an Azure ML commitment plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   commitmentPlanName: JString (required)
  ##                     : The Azure ML commitment plan name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594061 = path.getOrDefault("resourceGroupName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "resourceGroupName", valid_594061
  var valid_594062 = path.getOrDefault("commitmentPlanName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "commitmentPlanName", valid_594062
  var valid_594063 = path.getOrDefault("subscriptionId")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "subscriptionId", valid_594063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   $skipToken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594064 = query.getOrDefault("api-version")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "api-version", valid_594064
  var valid_594065 = query.getOrDefault("$skipToken")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "$skipToken", valid_594065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_UsageHistoryList_594058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the usage history for an Azure ML commitment plan.
  ## 
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_UsageHistoryList_594058; resourceGroupName: string;
          apiVersion: string; commitmentPlanName: string; subscriptionId: string;
          SkipToken: string = ""): Recallable =
  ## usageHistoryList
  ## Retrieve the usage history for an Azure ML commitment plan.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   commitmentPlanName: string (required)
  ##                     : The Azure ML commitment plan name.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   SkipToken: string
  ##            : Continuation token for pagination.
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  add(path_594068, "resourceGroupName", newJString(resourceGroupName))
  add(query_594069, "api-version", newJString(apiVersion))
  add(path_594068, "commitmentPlanName", newJString(commitmentPlanName))
  add(path_594068, "subscriptionId", newJString(subscriptionId))
  add(query_594069, "$skipToken", newJString(SkipToken))
  result = call_594067.call(path_594068, query_594069, nil, nil, nil)

var usageHistoryList* = Call_UsageHistoryList_594058(name: "usageHistoryList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans/{commitmentPlanName}/usageHistory",
    validator: validate_UsageHistoryList_594059, base: "",
    url: url_UsageHistoryList_594060, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
