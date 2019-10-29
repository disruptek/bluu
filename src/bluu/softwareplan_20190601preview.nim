
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Software Plan RP
## version: 2019-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure software plans let users create and manage licenses for various software used in Azure.
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "softwareplan"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SoftwarePlanRegister_563777 = ref object of OpenApiRestCall_563555
proc url_SoftwarePlanRegister_563779(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.SoftwarePlan/register")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SoftwarePlanRegister_563778(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Register to Microsoft.SoftwarePlan resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563954 = path.getOrDefault("subscriptionId")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = nil)
  if valid_563954 != nil:
    section.add "subscriptionId", valid_563954
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563955 = query.getOrDefault("api-version")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "api-version", valid_563955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563978: Call_SoftwarePlanRegister_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register to Microsoft.SoftwarePlan resource provider.
  ## 
  let valid = call_563978.validator(path, query, header, formData, body)
  let scheme = call_563978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563978.url(scheme.get, call_563978.host, call_563978.base,
                         call_563978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563978, url, valid)

proc call*(call_564049: Call_SoftwarePlanRegister_563777; apiVersion: string;
          subscriptionId: string): Recallable =
  ## softwarePlanRegister
  ## Register to Microsoft.SoftwarePlan resource provider.
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_564050 = newJObject()
  var query_564052 = newJObject()
  add(query_564052, "api-version", newJString(apiVersion))
  add(path_564050, "subscriptionId", newJString(subscriptionId))
  result = call_564049.call(path_564050, query_564052, nil, nil, nil)

var softwarePlanRegister* = Call_SoftwarePlanRegister_563777(
    name: "softwarePlanRegister", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.SoftwarePlan/register",
    validator: validate_SoftwarePlanRegister_563778, base: "",
    url: url_SoftwarePlanRegister_563779, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitList_564091 = ref object of OpenApiRestCall_563555
proc url_HybridUseBenefitList_564093(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.SoftwarePlan/hybridUseBenefits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridUseBenefitList_564092(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all hybrid use benefits associated with an ARM resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_564095 = path.getOrDefault("scope")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "scope", valid_564095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  ##   $filter: JString
  ##          : Supports applying filter on the type of SKU
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564096 = query.getOrDefault("api-version")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "api-version", valid_564096
  var valid_564097 = query.getOrDefault("$filter")
  valid_564097 = validateParameter(valid_564097, JString, required = false,
                                 default = nil)
  if valid_564097 != nil:
    section.add "$filter", valid_564097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564098: Call_HybridUseBenefitList_564091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all hybrid use benefits associated with an ARM resource.
  ## 
  let valid = call_564098.validator(path, query, header, formData, body)
  let scheme = call_564098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564098.url(scheme.get, call_564098.host, call_564098.base,
                         call_564098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564098, url, valid)

proc call*(call_564099: Call_HybridUseBenefitList_564091; apiVersion: string;
          scope: string; Filter: string = ""): Recallable =
  ## hybridUseBenefitList
  ## Get all hybrid use benefits associated with an ARM resource.
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   Filter: string
  ##         : Supports applying filter on the type of SKU
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  var path_564100 = newJObject()
  var query_564101 = newJObject()
  add(query_564101, "api-version", newJString(apiVersion))
  add(query_564101, "$filter", newJString(Filter))
  add(path_564100, "scope", newJString(scope))
  result = call_564099.call(path_564100, query_564101, nil, nil, nil)

var hybridUseBenefitList* = Call_HybridUseBenefitList_564091(
    name: "hybridUseBenefitList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits",
    validator: validate_HybridUseBenefitList_564092, base: "",
    url: url_HybridUseBenefitList_564093, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitCreate_564112 = ref object of OpenApiRestCall_563555
proc url_HybridUseBenefitCreate_564114(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "planId" in path, "`planId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.SoftwarePlan/hybridUseBenefits/"),
               (kind: VariableSegment, value: "planId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridUseBenefitCreate_564113(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new hybrid use benefit under a given scope
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   planId: JString (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   scope: JString (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `planId` field"
  var valid_564132 = path.getOrDefault("planId")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "planId", valid_564132
  var valid_564133 = path.getOrDefault("scope")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "scope", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564134 = query.getOrDefault("api-version")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "api-version", valid_564134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for creating a hybrid use benefit
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564136: Call_HybridUseBenefitCreate_564112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new hybrid use benefit under a given scope
  ## 
  let valid = call_564136.validator(path, query, header, formData, body)
  let scheme = call_564136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564136.url(scheme.get, call_564136.host, call_564136.base,
                         call_564136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564136, url, valid)

proc call*(call_564137: Call_HybridUseBenefitCreate_564112; apiVersion: string;
          planId: string; body: JsonNode; scope: string): Recallable =
  ## hybridUseBenefitCreate
  ## Create a new hybrid use benefit under a given scope
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   planId: string (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   body: JObject (required)
  ##       : Request body for creating a hybrid use benefit
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  var path_564138 = newJObject()
  var query_564139 = newJObject()
  var body_564140 = newJObject()
  add(query_564139, "api-version", newJString(apiVersion))
  add(path_564138, "planId", newJString(planId))
  if body != nil:
    body_564140 = body
  add(path_564138, "scope", newJString(scope))
  result = call_564137.call(path_564138, query_564139, nil, nil, body_564140)

var hybridUseBenefitCreate* = Call_HybridUseBenefitCreate_564112(
    name: "hybridUseBenefitCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits/{planId}",
    validator: validate_HybridUseBenefitCreate_564113, base: "",
    url: url_HybridUseBenefitCreate_564114, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitGet_564102 = ref object of OpenApiRestCall_563555
proc url_HybridUseBenefitGet_564104(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "planId" in path, "`planId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.SoftwarePlan/hybridUseBenefits/"),
               (kind: VariableSegment, value: "planId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridUseBenefitGet_564103(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets a given plan ID
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   planId: JString (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   scope: JString (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `planId` field"
  var valid_564105 = path.getOrDefault("planId")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "planId", valid_564105
  var valid_564106 = path.getOrDefault("scope")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "scope", valid_564106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564107 = query.getOrDefault("api-version")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "api-version", valid_564107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_HybridUseBenefitGet_564102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a given plan ID
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_HybridUseBenefitGet_564102; apiVersion: string;
          planId: string; scope: string): Recallable =
  ## hybridUseBenefitGet
  ## Gets a given plan ID
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   planId: string (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  var path_564110 = newJObject()
  var query_564111 = newJObject()
  add(query_564111, "api-version", newJString(apiVersion))
  add(path_564110, "planId", newJString(planId))
  add(path_564110, "scope", newJString(scope))
  result = call_564109.call(path_564110, query_564111, nil, nil, nil)

var hybridUseBenefitGet* = Call_HybridUseBenefitGet_564102(
    name: "hybridUseBenefitGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits/{planId}",
    validator: validate_HybridUseBenefitGet_564103, base: "",
    url: url_HybridUseBenefitGet_564104, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitUpdate_564151 = ref object of OpenApiRestCall_563555
proc url_HybridUseBenefitUpdate_564153(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "planId" in path, "`planId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.SoftwarePlan/hybridUseBenefits/"),
               (kind: VariableSegment, value: "planId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridUseBenefitUpdate_564152(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing hybrid use benefit
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   planId: JString (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   scope: JString (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `planId` field"
  var valid_564154 = path.getOrDefault("planId")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "planId", valid_564154
  var valid_564155 = path.getOrDefault("scope")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "scope", valid_564155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564156 = query.getOrDefault("api-version")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "api-version", valid_564156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for creating a hybrid use benefit
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564158: Call_HybridUseBenefitUpdate_564151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing hybrid use benefit
  ## 
  let valid = call_564158.validator(path, query, header, formData, body)
  let scheme = call_564158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564158.url(scheme.get, call_564158.host, call_564158.base,
                         call_564158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564158, url, valid)

proc call*(call_564159: Call_HybridUseBenefitUpdate_564151; apiVersion: string;
          planId: string; body: JsonNode; scope: string): Recallable =
  ## hybridUseBenefitUpdate
  ## Updates an existing hybrid use benefit
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   planId: string (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   body: JObject (required)
  ##       : Request body for creating a hybrid use benefit
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  var path_564160 = newJObject()
  var query_564161 = newJObject()
  var body_564162 = newJObject()
  add(query_564161, "api-version", newJString(apiVersion))
  add(path_564160, "planId", newJString(planId))
  if body != nil:
    body_564162 = body
  add(path_564160, "scope", newJString(scope))
  result = call_564159.call(path_564160, query_564161, nil, nil, body_564162)

var hybridUseBenefitUpdate* = Call_HybridUseBenefitUpdate_564151(
    name: "hybridUseBenefitUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits/{planId}",
    validator: validate_HybridUseBenefitUpdate_564152, base: "",
    url: url_HybridUseBenefitUpdate_564153, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitDelete_564141 = ref object of OpenApiRestCall_563555
proc url_HybridUseBenefitDelete_564143(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "planId" in path, "`planId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.SoftwarePlan/hybridUseBenefits/"),
               (kind: VariableSegment, value: "planId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridUseBenefitDelete_564142(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a given plan ID
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   planId: JString (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   scope: JString (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `planId` field"
  var valid_564144 = path.getOrDefault("planId")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "planId", valid_564144
  var valid_564145 = path.getOrDefault("scope")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "scope", valid_564145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564146 = query.getOrDefault("api-version")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "api-version", valid_564146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564147: Call_HybridUseBenefitDelete_564141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a given plan ID
  ## 
  let valid = call_564147.validator(path, query, header, formData, body)
  let scheme = call_564147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564147.url(scheme.get, call_564147.host, call_564147.base,
                         call_564147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564147, url, valid)

proc call*(call_564148: Call_HybridUseBenefitDelete_564141; apiVersion: string;
          planId: string; scope: string): Recallable =
  ## hybridUseBenefitDelete
  ## Deletes a given plan ID
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   planId: string (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  var path_564149 = newJObject()
  var query_564150 = newJObject()
  add(query_564150, "api-version", newJString(apiVersion))
  add(path_564149, "planId", newJString(planId))
  add(path_564149, "scope", newJString(scope))
  result = call_564148.call(path_564149, query_564150, nil, nil, nil)

var hybridUseBenefitDelete* = Call_HybridUseBenefitDelete_564141(
    name: "hybridUseBenefitDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits/{planId}",
    validator: validate_HybridUseBenefitDelete_564142, base: "",
    url: url_HybridUseBenefitDelete_564143, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitRevisionList_564163 = ref object of OpenApiRestCall_563555
proc url_HybridUseBenefitRevisionList_564165(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "planId" in path, "`planId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.SoftwarePlan/hybridUseBenefits/"),
               (kind: VariableSegment, value: "planId"),
               (kind: ConstantSegment, value: "/revisions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridUseBenefitRevisionList_564164(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the version history of a hybrid use benefit
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   planId: JString (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   scope: JString (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `planId` field"
  var valid_564166 = path.getOrDefault("planId")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "planId", valid_564166
  var valid_564167 = path.getOrDefault("scope")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "scope", valid_564167
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564168 = query.getOrDefault("api-version")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "api-version", valid_564168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564169: Call_HybridUseBenefitRevisionList_564163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the version history of a hybrid use benefit
  ## 
  let valid = call_564169.validator(path, query, header, formData, body)
  let scheme = call_564169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564169.url(scheme.get, call_564169.host, call_564169.base,
                         call_564169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564169, url, valid)

proc call*(call_564170: Call_HybridUseBenefitRevisionList_564163;
          apiVersion: string; planId: string; scope: string): Recallable =
  ## hybridUseBenefitRevisionList
  ## Gets the version history of a hybrid use benefit
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   planId: string (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  var path_564171 = newJObject()
  var query_564172 = newJObject()
  add(query_564172, "api-version", newJString(apiVersion))
  add(path_564171, "planId", newJString(planId))
  add(path_564171, "scope", newJString(scope))
  result = call_564170.call(path_564171, query_564172, nil, nil, nil)

var hybridUseBenefitRevisionList* = Call_HybridUseBenefitRevisionList_564163(
    name: "hybridUseBenefitRevisionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits/{planId}/revisions",
    validator: validate_HybridUseBenefitRevisionList_564164, base: "",
    url: url_HybridUseBenefitRevisionList_564165, schemes: {Scheme.Https})
type
  Call_OperationsList_564173 = ref object of OpenApiRestCall_563555
proc url_OperationsList_564175(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.SoftwarePlan/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationsList_564174(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List all the operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_564176 = path.getOrDefault("scope")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "scope", valid_564176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564177 = query.getOrDefault("api-version")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "api-version", valid_564177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564178: Call_OperationsList_564173; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the operations.
  ## 
  let valid = call_564178.validator(path, query, header, formData, body)
  let scheme = call_564178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564178.url(scheme.get, call_564178.host, call_564178.base,
                         call_564178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564178, url, valid)

proc call*(call_564179: Call_OperationsList_564173; apiVersion: string; scope: string): Recallable =
  ## operationsList
  ## List all the operations.
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  var path_564180 = newJObject()
  var query_564181 = newJObject()
  add(query_564181, "api-version", newJString(apiVersion))
  add(path_564180, "scope", newJString(scope))
  result = call_564179.call(path_564180, query_564181, nil, nil, nil)

var operationsList* = Call_OperationsList_564173(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.SoftwarePlan/operations",
    validator: validate_OperationsList_564174, base: "", url: url_OperationsList_564175,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
