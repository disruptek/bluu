
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "softwareplan"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SoftwarePlanRegister_567879 = ref object of OpenApiRestCall_567657
proc url_SoftwarePlanRegister_567881(protocol: Scheme; host: string; base: string;
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

proc validate_SoftwarePlanRegister_567880(path: JsonNode; query: JsonNode;
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
  var valid_568054 = path.getOrDefault("subscriptionId")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "subscriptionId", valid_568054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568055 = query.getOrDefault("api-version")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "api-version", valid_568055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568078: Call_SoftwarePlanRegister_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register to Microsoft.SoftwarePlan resource provider.
  ## 
  let valid = call_568078.validator(path, query, header, formData, body)
  let scheme = call_568078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568078.url(scheme.get, call_568078.host, call_568078.base,
                         call_568078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568078, url, valid)

proc call*(call_568149: Call_SoftwarePlanRegister_567879; apiVersion: string;
          subscriptionId: string): Recallable =
  ## softwarePlanRegister
  ## Register to Microsoft.SoftwarePlan resource provider.
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568150 = newJObject()
  var query_568152 = newJObject()
  add(query_568152, "api-version", newJString(apiVersion))
  add(path_568150, "subscriptionId", newJString(subscriptionId))
  result = call_568149.call(path_568150, query_568152, nil, nil, nil)

var softwarePlanRegister* = Call_SoftwarePlanRegister_567879(
    name: "softwarePlanRegister", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.SoftwarePlan/register",
    validator: validate_SoftwarePlanRegister_567880, base: "",
    url: url_SoftwarePlanRegister_567881, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitList_568191 = ref object of OpenApiRestCall_567657
proc url_HybridUseBenefitList_568193(protocol: Scheme; host: string; base: string;
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

proc validate_HybridUseBenefitList_568192(path: JsonNode; query: JsonNode;
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
  var valid_568195 = path.getOrDefault("scope")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "scope", valid_568195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  ##   $filter: JString
  ##          : Supports applying filter on the type of SKU
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568196 = query.getOrDefault("api-version")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "api-version", valid_568196
  var valid_568197 = query.getOrDefault("$filter")
  valid_568197 = validateParameter(valid_568197, JString, required = false,
                                 default = nil)
  if valid_568197 != nil:
    section.add "$filter", valid_568197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568198: Call_HybridUseBenefitList_568191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all hybrid use benefits associated with an ARM resource.
  ## 
  let valid = call_568198.validator(path, query, header, formData, body)
  let scheme = call_568198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568198.url(scheme.get, call_568198.host, call_568198.base,
                         call_568198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568198, url, valid)

proc call*(call_568199: Call_HybridUseBenefitList_568191; apiVersion: string;
          scope: string; Filter: string = ""): Recallable =
  ## hybridUseBenefitList
  ## Get all hybrid use benefits associated with an ARM resource.
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  ##   Filter: string
  ##         : Supports applying filter on the type of SKU
  var path_568200 = newJObject()
  var query_568201 = newJObject()
  add(query_568201, "api-version", newJString(apiVersion))
  add(path_568200, "scope", newJString(scope))
  add(query_568201, "$filter", newJString(Filter))
  result = call_568199.call(path_568200, query_568201, nil, nil, nil)

var hybridUseBenefitList* = Call_HybridUseBenefitList_568191(
    name: "hybridUseBenefitList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits",
    validator: validate_HybridUseBenefitList_568192, base: "",
    url: url_HybridUseBenefitList_568193, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitCreate_568212 = ref object of OpenApiRestCall_567657
proc url_HybridUseBenefitCreate_568214(protocol: Scheme; host: string; base: string;
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

proc validate_HybridUseBenefitCreate_568213(path: JsonNode; query: JsonNode;
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
  var valid_568232 = path.getOrDefault("planId")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "planId", valid_568232
  var valid_568233 = path.getOrDefault("scope")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "scope", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
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

proc call*(call_568236: Call_HybridUseBenefitCreate_568212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new hybrid use benefit under a given scope
  ## 
  let valid = call_568236.validator(path, query, header, formData, body)
  let scheme = call_568236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568236.url(scheme.get, call_568236.host, call_568236.base,
                         call_568236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568236, url, valid)

proc call*(call_568237: Call_HybridUseBenefitCreate_568212; apiVersion: string;
          planId: string; scope: string; body: JsonNode): Recallable =
  ## hybridUseBenefitCreate
  ## Create a new hybrid use benefit under a given scope
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   planId: string (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  ##   body: JObject (required)
  ##       : Request body for creating a hybrid use benefit
  var path_568238 = newJObject()
  var query_568239 = newJObject()
  var body_568240 = newJObject()
  add(query_568239, "api-version", newJString(apiVersion))
  add(path_568238, "planId", newJString(planId))
  add(path_568238, "scope", newJString(scope))
  if body != nil:
    body_568240 = body
  result = call_568237.call(path_568238, query_568239, nil, nil, body_568240)

var hybridUseBenefitCreate* = Call_HybridUseBenefitCreate_568212(
    name: "hybridUseBenefitCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits/{planId}",
    validator: validate_HybridUseBenefitCreate_568213, base: "",
    url: url_HybridUseBenefitCreate_568214, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitGet_568202 = ref object of OpenApiRestCall_567657
proc url_HybridUseBenefitGet_568204(protocol: Scheme; host: string; base: string;
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

proc validate_HybridUseBenefitGet_568203(path: JsonNode; query: JsonNode;
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
  var valid_568205 = path.getOrDefault("planId")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "planId", valid_568205
  var valid_568206 = path.getOrDefault("scope")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "scope", valid_568206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568207 = query.getOrDefault("api-version")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "api-version", valid_568207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568208: Call_HybridUseBenefitGet_568202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a given plan ID
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_HybridUseBenefitGet_568202; apiVersion: string;
          planId: string; scope: string): Recallable =
  ## hybridUseBenefitGet
  ## Gets a given plan ID
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   planId: string (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  var path_568210 = newJObject()
  var query_568211 = newJObject()
  add(query_568211, "api-version", newJString(apiVersion))
  add(path_568210, "planId", newJString(planId))
  add(path_568210, "scope", newJString(scope))
  result = call_568209.call(path_568210, query_568211, nil, nil, nil)

var hybridUseBenefitGet* = Call_HybridUseBenefitGet_568202(
    name: "hybridUseBenefitGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits/{planId}",
    validator: validate_HybridUseBenefitGet_568203, base: "",
    url: url_HybridUseBenefitGet_568204, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitUpdate_568251 = ref object of OpenApiRestCall_567657
proc url_HybridUseBenefitUpdate_568253(protocol: Scheme; host: string; base: string;
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

proc validate_HybridUseBenefitUpdate_568252(path: JsonNode; query: JsonNode;
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
  var valid_568254 = path.getOrDefault("planId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "planId", valid_568254
  var valid_568255 = path.getOrDefault("scope")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "scope", valid_568255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568256 = query.getOrDefault("api-version")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "api-version", valid_568256
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

proc call*(call_568258: Call_HybridUseBenefitUpdate_568251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing hybrid use benefit
  ## 
  let valid = call_568258.validator(path, query, header, formData, body)
  let scheme = call_568258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568258.url(scheme.get, call_568258.host, call_568258.base,
                         call_568258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568258, url, valid)

proc call*(call_568259: Call_HybridUseBenefitUpdate_568251; apiVersion: string;
          planId: string; scope: string; body: JsonNode): Recallable =
  ## hybridUseBenefitUpdate
  ## Updates an existing hybrid use benefit
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   planId: string (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  ##   body: JObject (required)
  ##       : Request body for creating a hybrid use benefit
  var path_568260 = newJObject()
  var query_568261 = newJObject()
  var body_568262 = newJObject()
  add(query_568261, "api-version", newJString(apiVersion))
  add(path_568260, "planId", newJString(planId))
  add(path_568260, "scope", newJString(scope))
  if body != nil:
    body_568262 = body
  result = call_568259.call(path_568260, query_568261, nil, nil, body_568262)

var hybridUseBenefitUpdate* = Call_HybridUseBenefitUpdate_568251(
    name: "hybridUseBenefitUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits/{planId}",
    validator: validate_HybridUseBenefitUpdate_568252, base: "",
    url: url_HybridUseBenefitUpdate_568253, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitDelete_568241 = ref object of OpenApiRestCall_567657
proc url_HybridUseBenefitDelete_568243(protocol: Scheme; host: string; base: string;
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

proc validate_HybridUseBenefitDelete_568242(path: JsonNode; query: JsonNode;
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
  var valid_568244 = path.getOrDefault("planId")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "planId", valid_568244
  var valid_568245 = path.getOrDefault("scope")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "scope", valid_568245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
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
  if body != nil:
    result.add "body", body

proc call*(call_568247: Call_HybridUseBenefitDelete_568241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a given plan ID
  ## 
  let valid = call_568247.validator(path, query, header, formData, body)
  let scheme = call_568247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568247.url(scheme.get, call_568247.host, call_568247.base,
                         call_568247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568247, url, valid)

proc call*(call_568248: Call_HybridUseBenefitDelete_568241; apiVersion: string;
          planId: string; scope: string): Recallable =
  ## hybridUseBenefitDelete
  ## Deletes a given plan ID
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   planId: string (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  var path_568249 = newJObject()
  var query_568250 = newJObject()
  add(query_568250, "api-version", newJString(apiVersion))
  add(path_568249, "planId", newJString(planId))
  add(path_568249, "scope", newJString(scope))
  result = call_568248.call(path_568249, query_568250, nil, nil, nil)

var hybridUseBenefitDelete* = Call_HybridUseBenefitDelete_568241(
    name: "hybridUseBenefitDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits/{planId}",
    validator: validate_HybridUseBenefitDelete_568242, base: "",
    url: url_HybridUseBenefitDelete_568243, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitRevisionList_568263 = ref object of OpenApiRestCall_567657
proc url_HybridUseBenefitRevisionList_568265(protocol: Scheme; host: string;
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

proc validate_HybridUseBenefitRevisionList_568264(path: JsonNode; query: JsonNode;
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
  var valid_568266 = path.getOrDefault("planId")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "planId", valid_568266
  var valid_568267 = path.getOrDefault("scope")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "scope", valid_568267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
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
  if body != nil:
    result.add "body", body

proc call*(call_568269: Call_HybridUseBenefitRevisionList_568263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the version history of a hybrid use benefit
  ## 
  let valid = call_568269.validator(path, query, header, formData, body)
  let scheme = call_568269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568269.url(scheme.get, call_568269.host, call_568269.base,
                         call_568269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568269, url, valid)

proc call*(call_568270: Call_HybridUseBenefitRevisionList_568263;
          apiVersion: string; planId: string; scope: string): Recallable =
  ## hybridUseBenefitRevisionList
  ## Gets the version history of a hybrid use benefit
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   planId: string (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  var path_568271 = newJObject()
  var query_568272 = newJObject()
  add(query_568272, "api-version", newJString(apiVersion))
  add(path_568271, "planId", newJString(planId))
  add(path_568271, "scope", newJString(scope))
  result = call_568270.call(path_568271, query_568272, nil, nil, nil)

var hybridUseBenefitRevisionList* = Call_HybridUseBenefitRevisionList_568263(
    name: "hybridUseBenefitRevisionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits/{planId}/revisions",
    validator: validate_HybridUseBenefitRevisionList_568264, base: "",
    url: url_HybridUseBenefitRevisionList_568265, schemes: {Scheme.Https})
type
  Call_OperationsList_568273 = ref object of OpenApiRestCall_567657
proc url_OperationsList_568275(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsList_568274(path: JsonNode; query: JsonNode;
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
  var valid_568276 = path.getOrDefault("scope")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "scope", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
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
  if body != nil:
    result.add "body", body

proc call*(call_568278: Call_OperationsList_568273; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the operations.
  ## 
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_OperationsList_568273; apiVersion: string; scope: string): Recallable =
  ## operationsList
  ## List all the operations.
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  var path_568280 = newJObject()
  var query_568281 = newJObject()
  add(query_568281, "api-version", newJString(apiVersion))
  add(path_568280, "scope", newJString(scope))
  result = call_568279.call(path_568280, query_568281, nil, nil, nil)

var operationsList* = Call_OperationsList_568273(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.SoftwarePlan/operations",
    validator: validate_OperationsList_568274, base: "", url: url_OperationsList_568275,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
