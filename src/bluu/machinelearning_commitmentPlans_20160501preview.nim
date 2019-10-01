
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567642 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567642](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567642): Option[Scheme] {.used.} =
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
  macServiceName = "machinelearning-commitmentPlans"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567864 = ref object of OpenApiRestCall_567642
proc url_OperationsList_567866(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567865(path: JsonNode; query: JsonNode;
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
  var valid_568025 = query.getOrDefault("api-version")
  valid_568025 = validateParameter(valid_568025, JString, required = true,
                                 default = nil)
  if valid_568025 != nil:
    section.add "api-version", valid_568025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568048: Call_OperationsList_567864; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Azure Machine Learning Studio Commitment Plan RP REST API operations.
  ## 
  let valid = call_568048.validator(path, query, header, formData, body)
  let scheme = call_568048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568048.url(scheme.get, call_568048.host, call_568048.base,
                         call_568048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568048, url, valid)

proc call*(call_568119: Call_OperationsList_567864; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Azure Machine Learning Studio Commitment Plan RP REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  var query_568120 = newJObject()
  add(query_568120, "api-version", newJString(apiVersion))
  result = call_568119.call(nil, query_568120, nil, nil, nil)

var operationsList* = Call_OperationsList_567864(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MachineLearning/operations",
    validator: validate_OperationsList_567865, base: "", url: url_OperationsList_567866,
    schemes: {Scheme.Https})
type
  Call_CommitmentPlansList_568160 = ref object of OpenApiRestCall_567642
proc url_CommitmentPlansList_568162(protocol: Scheme; host: string; base: string;
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

proc validate_CommitmentPlansList_568161(path: JsonNode; query: JsonNode;
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
  var valid_568178 = path.getOrDefault("subscriptionId")
  valid_568178 = validateParameter(valid_568178, JString, required = true,
                                 default = nil)
  if valid_568178 != nil:
    section.add "subscriptionId", valid_568178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   $skipToken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568179 = query.getOrDefault("api-version")
  valid_568179 = validateParameter(valid_568179, JString, required = true,
                                 default = nil)
  if valid_568179 != nil:
    section.add "api-version", valid_568179
  var valid_568180 = query.getOrDefault("$skipToken")
  valid_568180 = validateParameter(valid_568180, JString, required = false,
                                 default = nil)
  if valid_568180 != nil:
    section.add "$skipToken", valid_568180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568181: Call_CommitmentPlansList_568160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all Azure ML commitment plans in a subscription.
  ## 
  let valid = call_568181.validator(path, query, header, formData, body)
  let scheme = call_568181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568181.url(scheme.get, call_568181.host, call_568181.base,
                         call_568181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568181, url, valid)

proc call*(call_568182: Call_CommitmentPlansList_568160; apiVersion: string;
          subscriptionId: string; SkipToken: string = ""): Recallable =
  ## commitmentPlansList
  ## Retrieve all Azure ML commitment plans in a subscription.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   SkipToken: string
  ##            : Continuation token for pagination.
  var path_568183 = newJObject()
  var query_568184 = newJObject()
  add(query_568184, "api-version", newJString(apiVersion))
  add(path_568183, "subscriptionId", newJString(subscriptionId))
  add(query_568184, "$skipToken", newJString(SkipToken))
  result = call_568182.call(path_568183, query_568184, nil, nil, nil)

var commitmentPlansList* = Call_CommitmentPlansList_568160(
    name: "commitmentPlansList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearning/commitmentPlans",
    validator: validate_CommitmentPlansList_568161, base: "",
    url: url_CommitmentPlansList_568162, schemes: {Scheme.Https})
type
  Call_SkusList_568185 = ref object of OpenApiRestCall_567642
proc url_SkusList_568187(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SkusList_568186(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568188 = path.getOrDefault("subscriptionId")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "subscriptionId", valid_568188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568189 = query.getOrDefault("api-version")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "api-version", valid_568189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568190: Call_SkusList_568185; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available commitment plan SKUs.
  ## 
  let valid = call_568190.validator(path, query, header, formData, body)
  let scheme = call_568190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568190.url(scheme.get, call_568190.host, call_568190.base,
                         call_568190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568190, url, valid)

proc call*(call_568191: Call_SkusList_568185; apiVersion: string;
          subscriptionId: string): Recallable =
  ## skusList
  ## Lists the available commitment plan SKUs.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_568192 = newJObject()
  var query_568193 = newJObject()
  add(query_568193, "api-version", newJString(apiVersion))
  add(path_568192, "subscriptionId", newJString(subscriptionId))
  result = call_568191.call(path_568192, query_568193, nil, nil, nil)

var skusList* = Call_SkusList_568185(name: "skusList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearning/skus",
                                  validator: validate_SkusList_568186, base: "",
                                  url: url_SkusList_568187,
                                  schemes: {Scheme.Https})
type
  Call_CommitmentPlansListInResourceGroup_568194 = ref object of OpenApiRestCall_567642
proc url_CommitmentPlansListInResourceGroup_568196(protocol: Scheme; host: string;
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

proc validate_CommitmentPlansListInResourceGroup_568195(path: JsonNode;
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
  var valid_568197 = path.getOrDefault("resourceGroupName")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "resourceGroupName", valid_568197
  var valid_568198 = path.getOrDefault("subscriptionId")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "subscriptionId", valid_568198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   $skipToken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568199 = query.getOrDefault("api-version")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "api-version", valid_568199
  var valid_568200 = query.getOrDefault("$skipToken")
  valid_568200 = validateParameter(valid_568200, JString, required = false,
                                 default = nil)
  if valid_568200 != nil:
    section.add "$skipToken", valid_568200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568201: Call_CommitmentPlansListInResourceGroup_568194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve all Azure ML commitment plans in a resource group.
  ## 
  let valid = call_568201.validator(path, query, header, formData, body)
  let scheme = call_568201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568201.url(scheme.get, call_568201.host, call_568201.base,
                         call_568201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568201, url, valid)

proc call*(call_568202: Call_CommitmentPlansListInResourceGroup_568194;
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
  var path_568203 = newJObject()
  var query_568204 = newJObject()
  add(path_568203, "resourceGroupName", newJString(resourceGroupName))
  add(query_568204, "api-version", newJString(apiVersion))
  add(path_568203, "subscriptionId", newJString(subscriptionId))
  add(query_568204, "$skipToken", newJString(SkipToken))
  result = call_568202.call(path_568203, query_568204, nil, nil, nil)

var commitmentPlansListInResourceGroup* = Call_CommitmentPlansListInResourceGroup_568194(
    name: "commitmentPlansListInResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans",
    validator: validate_CommitmentPlansListInResourceGroup_568195, base: "",
    url: url_CommitmentPlansListInResourceGroup_568196, schemes: {Scheme.Https})
type
  Call_CommitmentPlansCreateOrUpdate_568216 = ref object of OpenApiRestCall_567642
proc url_CommitmentPlansCreateOrUpdate_568218(protocol: Scheme; host: string;
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

proc validate_CommitmentPlansCreateOrUpdate_568217(path: JsonNode; query: JsonNode;
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
  var valid_568219 = path.getOrDefault("resourceGroupName")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "resourceGroupName", valid_568219
  var valid_568220 = path.getOrDefault("commitmentPlanName")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "commitmentPlanName", valid_568220
  var valid_568221 = path.getOrDefault("subscriptionId")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "subscriptionId", valid_568221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
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
  ## parameters in `body` object:
  ##   createOrUpdatePayload: JObject (required)
  ##                        : The payload to create or update the Azure ML commitment plan.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568224: Call_CommitmentPlansCreateOrUpdate_568216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new Azure ML commitment plan resource or updates an existing one.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_CommitmentPlansCreateOrUpdate_568216;
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
  var path_568226 = newJObject()
  var query_568227 = newJObject()
  var body_568228 = newJObject()
  add(path_568226, "resourceGroupName", newJString(resourceGroupName))
  add(query_568227, "api-version", newJString(apiVersion))
  add(path_568226, "commitmentPlanName", newJString(commitmentPlanName))
  add(path_568226, "subscriptionId", newJString(subscriptionId))
  if createOrUpdatePayload != nil:
    body_568228 = createOrUpdatePayload
  result = call_568225.call(path_568226, query_568227, nil, nil, body_568228)

var commitmentPlansCreateOrUpdate* = Call_CommitmentPlansCreateOrUpdate_568216(
    name: "commitmentPlansCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans/{commitmentPlanName}",
    validator: validate_CommitmentPlansCreateOrUpdate_568217, base: "",
    url: url_CommitmentPlansCreateOrUpdate_568218, schemes: {Scheme.Https})
type
  Call_CommitmentPlansGet_568205 = ref object of OpenApiRestCall_567642
proc url_CommitmentPlansGet_568207(protocol: Scheme; host: string; base: string;
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

proc validate_CommitmentPlansGet_568206(path: JsonNode; query: JsonNode;
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
  var valid_568208 = path.getOrDefault("resourceGroupName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "resourceGroupName", valid_568208
  var valid_568209 = path.getOrDefault("commitmentPlanName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "commitmentPlanName", valid_568209
  var valid_568210 = path.getOrDefault("subscriptionId")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "subscriptionId", valid_568210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
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
  if body != nil:
    result.add "body", body

proc call*(call_568212: Call_CommitmentPlansGet_568205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve an Azure ML commitment plan by its subscription, resource group and name.
  ## 
  let valid = call_568212.validator(path, query, header, formData, body)
  let scheme = call_568212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568212.url(scheme.get, call_568212.host, call_568212.base,
                         call_568212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568212, url, valid)

proc call*(call_568213: Call_CommitmentPlansGet_568205; resourceGroupName: string;
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
  var path_568214 = newJObject()
  var query_568215 = newJObject()
  add(path_568214, "resourceGroupName", newJString(resourceGroupName))
  add(query_568215, "api-version", newJString(apiVersion))
  add(path_568214, "commitmentPlanName", newJString(commitmentPlanName))
  add(path_568214, "subscriptionId", newJString(subscriptionId))
  result = call_568213.call(path_568214, query_568215, nil, nil, nil)

var commitmentPlansGet* = Call_CommitmentPlansGet_568205(
    name: "commitmentPlansGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans/{commitmentPlanName}",
    validator: validate_CommitmentPlansGet_568206, base: "",
    url: url_CommitmentPlansGet_568207, schemes: {Scheme.Https})
type
  Call_CommitmentPlansPatch_568240 = ref object of OpenApiRestCall_567642
proc url_CommitmentPlansPatch_568242(protocol: Scheme; host: string; base: string;
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

proc validate_CommitmentPlansPatch_568241(path: JsonNode; query: JsonNode;
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
  var valid_568243 = path.getOrDefault("resourceGroupName")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "resourceGroupName", valid_568243
  var valid_568244 = path.getOrDefault("commitmentPlanName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "commitmentPlanName", valid_568244
  var valid_568245 = path.getOrDefault("subscriptionId")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "subscriptionId", valid_568245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568246 = query.getOrDefault("api-version")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "api-version", valid_568246
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

proc call*(call_568248: Call_CommitmentPlansPatch_568240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch an existing Azure ML commitment plan resource.
  ## 
  let valid = call_568248.validator(path, query, header, formData, body)
  let scheme = call_568248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568248.url(scheme.get, call_568248.host, call_568248.base,
                         call_568248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568248, url, valid)

proc call*(call_568249: Call_CommitmentPlansPatch_568240;
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
  var path_568250 = newJObject()
  var query_568251 = newJObject()
  var body_568252 = newJObject()
  add(path_568250, "resourceGroupName", newJString(resourceGroupName))
  add(query_568251, "api-version", newJString(apiVersion))
  add(path_568250, "commitmentPlanName", newJString(commitmentPlanName))
  add(path_568250, "subscriptionId", newJString(subscriptionId))
  if patchPayload != nil:
    body_568252 = patchPayload
  result = call_568249.call(path_568250, query_568251, nil, nil, body_568252)

var commitmentPlansPatch* = Call_CommitmentPlansPatch_568240(
    name: "commitmentPlansPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans/{commitmentPlanName}",
    validator: validate_CommitmentPlansPatch_568241, base: "",
    url: url_CommitmentPlansPatch_568242, schemes: {Scheme.Https})
type
  Call_CommitmentPlansRemove_568229 = ref object of OpenApiRestCall_567642
proc url_CommitmentPlansRemove_568231(protocol: Scheme; host: string; base: string;
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

proc validate_CommitmentPlansRemove_568230(path: JsonNode; query: JsonNode;
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
  var valid_568232 = path.getOrDefault("resourceGroupName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "resourceGroupName", valid_568232
  var valid_568233 = path.getOrDefault("commitmentPlanName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "commitmentPlanName", valid_568233
  var valid_568234 = path.getOrDefault("subscriptionId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "subscriptionId", valid_568234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568235 = query.getOrDefault("api-version")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "api-version", valid_568235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568236: Call_CommitmentPlansRemove_568229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove an existing Azure ML commitment plan.
  ## 
  let valid = call_568236.validator(path, query, header, formData, body)
  let scheme = call_568236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568236.url(scheme.get, call_568236.host, call_568236.base,
                         call_568236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568236, url, valid)

proc call*(call_568237: Call_CommitmentPlansRemove_568229;
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
  var path_568238 = newJObject()
  var query_568239 = newJObject()
  add(path_568238, "resourceGroupName", newJString(resourceGroupName))
  add(query_568239, "api-version", newJString(apiVersion))
  add(path_568238, "commitmentPlanName", newJString(commitmentPlanName))
  add(path_568238, "subscriptionId", newJString(subscriptionId))
  result = call_568237.call(path_568238, query_568239, nil, nil, nil)

var commitmentPlansRemove* = Call_CommitmentPlansRemove_568229(
    name: "commitmentPlansRemove", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans/{commitmentPlanName}",
    validator: validate_CommitmentPlansRemove_568230, base: "",
    url: url_CommitmentPlansRemove_568231, schemes: {Scheme.Https})
type
  Call_CommitmentAssociationsList_568253 = ref object of OpenApiRestCall_567642
proc url_CommitmentAssociationsList_568255(protocol: Scheme; host: string;
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

proc validate_CommitmentAssociationsList_568254(path: JsonNode; query: JsonNode;
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
  var valid_568256 = path.getOrDefault("resourceGroupName")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "resourceGroupName", valid_568256
  var valid_568257 = path.getOrDefault("commitmentPlanName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "commitmentPlanName", valid_568257
  var valid_568258 = path.getOrDefault("subscriptionId")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "subscriptionId", valid_568258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   $skipToken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568259 = query.getOrDefault("api-version")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "api-version", valid_568259
  var valid_568260 = query.getOrDefault("$skipToken")
  valid_568260 = validateParameter(valid_568260, JString, required = false,
                                 default = nil)
  if valid_568260 != nil:
    section.add "$skipToken", valid_568260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568261: Call_CommitmentAssociationsList_568253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all commitment associations for a parent commitment plan.
  ## 
  let valid = call_568261.validator(path, query, header, formData, body)
  let scheme = call_568261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568261.url(scheme.get, call_568261.host, call_568261.base,
                         call_568261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568261, url, valid)

proc call*(call_568262: Call_CommitmentAssociationsList_568253;
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
  var path_568263 = newJObject()
  var query_568264 = newJObject()
  add(path_568263, "resourceGroupName", newJString(resourceGroupName))
  add(query_568264, "api-version", newJString(apiVersion))
  add(path_568263, "commitmentPlanName", newJString(commitmentPlanName))
  add(path_568263, "subscriptionId", newJString(subscriptionId))
  add(query_568264, "$skipToken", newJString(SkipToken))
  result = call_568262.call(path_568263, query_568264, nil, nil, nil)

var commitmentAssociationsList* = Call_CommitmentAssociationsList_568253(
    name: "commitmentAssociationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans/{commitmentPlanName}/commitmentAssociations",
    validator: validate_CommitmentAssociationsList_568254, base: "",
    url: url_CommitmentAssociationsList_568255, schemes: {Scheme.Https})
type
  Call_CommitmentAssociationsGet_568265 = ref object of OpenApiRestCall_567642
proc url_CommitmentAssociationsGet_568267(protocol: Scheme; host: string;
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

proc validate_CommitmentAssociationsGet_568266(path: JsonNode; query: JsonNode;
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
  var valid_568268 = path.getOrDefault("resourceGroupName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "resourceGroupName", valid_568268
  var valid_568269 = path.getOrDefault("commitmentAssociationName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "commitmentAssociationName", valid_568269
  var valid_568270 = path.getOrDefault("commitmentPlanName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "commitmentPlanName", valid_568270
  var valid_568271 = path.getOrDefault("subscriptionId")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "subscriptionId", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568272 = query.getOrDefault("api-version")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "api-version", valid_568272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568273: Call_CommitmentAssociationsGet_568265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a commitment association.
  ## 
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_CommitmentAssociationsGet_568265;
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
  var path_568275 = newJObject()
  var query_568276 = newJObject()
  add(path_568275, "resourceGroupName", newJString(resourceGroupName))
  add(query_568276, "api-version", newJString(apiVersion))
  add(path_568275, "commitmentAssociationName",
      newJString(commitmentAssociationName))
  add(path_568275, "commitmentPlanName", newJString(commitmentPlanName))
  add(path_568275, "subscriptionId", newJString(subscriptionId))
  result = call_568274.call(path_568275, query_568276, nil, nil, nil)

var commitmentAssociationsGet* = Call_CommitmentAssociationsGet_568265(
    name: "commitmentAssociationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans/{commitmentPlanName}/commitmentAssociations/{commitmentAssociationName}",
    validator: validate_CommitmentAssociationsGet_568266, base: "",
    url: url_CommitmentAssociationsGet_568267, schemes: {Scheme.Https})
type
  Call_CommitmentAssociationsMove_568277 = ref object of OpenApiRestCall_567642
proc url_CommitmentAssociationsMove_568279(protocol: Scheme; host: string;
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

proc validate_CommitmentAssociationsMove_568278(path: JsonNode; query: JsonNode;
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
  var valid_568280 = path.getOrDefault("resourceGroupName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "resourceGroupName", valid_568280
  var valid_568281 = path.getOrDefault("commitmentAssociationName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "commitmentAssociationName", valid_568281
  var valid_568282 = path.getOrDefault("commitmentPlanName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "commitmentPlanName", valid_568282
  var valid_568283 = path.getOrDefault("subscriptionId")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "subscriptionId", valid_568283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568284 = query.getOrDefault("api-version")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "api-version", valid_568284
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

proc call*(call_568286: Call_CommitmentAssociationsMove_568277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Re-parent a commitment association from one commitment plan to another.
  ## 
  let valid = call_568286.validator(path, query, header, formData, body)
  let scheme = call_568286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568286.url(scheme.get, call_568286.host, call_568286.base,
                         call_568286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568286, url, valid)

proc call*(call_568287: Call_CommitmentAssociationsMove_568277;
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
  var path_568288 = newJObject()
  var query_568289 = newJObject()
  var body_568290 = newJObject()
  add(path_568288, "resourceGroupName", newJString(resourceGroupName))
  add(query_568289, "api-version", newJString(apiVersion))
  add(path_568288, "commitmentAssociationName",
      newJString(commitmentAssociationName))
  add(path_568288, "commitmentPlanName", newJString(commitmentPlanName))
  add(path_568288, "subscriptionId", newJString(subscriptionId))
  if movePayload != nil:
    body_568290 = movePayload
  result = call_568287.call(path_568288, query_568289, nil, nil, body_568290)

var commitmentAssociationsMove* = Call_CommitmentAssociationsMove_568277(
    name: "commitmentAssociationsMove", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans/{commitmentPlanName}/commitmentAssociations/{commitmentAssociationName}/move",
    validator: validate_CommitmentAssociationsMove_568278, base: "",
    url: url_CommitmentAssociationsMove_568279, schemes: {Scheme.Https})
type
  Call_UsageHistoryList_568291 = ref object of OpenApiRestCall_567642
proc url_UsageHistoryList_568293(protocol: Scheme; host: string; base: string;
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

proc validate_UsageHistoryList_568292(path: JsonNode; query: JsonNode;
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
  var valid_568294 = path.getOrDefault("resourceGroupName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "resourceGroupName", valid_568294
  var valid_568295 = path.getOrDefault("commitmentPlanName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "commitmentPlanName", valid_568295
  var valid_568296 = path.getOrDefault("subscriptionId")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "subscriptionId", valid_568296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   $skipToken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568297 = query.getOrDefault("api-version")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "api-version", valid_568297
  var valid_568298 = query.getOrDefault("$skipToken")
  valid_568298 = validateParameter(valid_568298, JString, required = false,
                                 default = nil)
  if valid_568298 != nil:
    section.add "$skipToken", valid_568298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568299: Call_UsageHistoryList_568291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the usage history for an Azure ML commitment plan.
  ## 
  let valid = call_568299.validator(path, query, header, formData, body)
  let scheme = call_568299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568299.url(scheme.get, call_568299.host, call_568299.base,
                         call_568299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568299, url, valid)

proc call*(call_568300: Call_UsageHistoryList_568291; resourceGroupName: string;
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
  var path_568301 = newJObject()
  var query_568302 = newJObject()
  add(path_568301, "resourceGroupName", newJString(resourceGroupName))
  add(query_568302, "api-version", newJString(apiVersion))
  add(path_568301, "commitmentPlanName", newJString(commitmentPlanName))
  add(path_568301, "subscriptionId", newJString(subscriptionId))
  add(query_568302, "$skipToken", newJString(SkipToken))
  result = call_568300.call(path_568301, query_568302, nil, nil, nil)

var usageHistoryList* = Call_UsageHistoryList_568291(name: "usageHistoryList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/commitmentPlans/{commitmentPlanName}/usageHistory",
    validator: validate_UsageHistoryList_568292, base: "",
    url: url_UsageHistoryList_568293, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
