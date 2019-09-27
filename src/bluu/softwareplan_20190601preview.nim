
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "softwareplan"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SoftwarePlanRegister_593646 = ref object of OpenApiRestCall_593424
proc url_SoftwarePlanRegister_593648(protocol: Scheme; host: string; base: string;
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

proc validate_SoftwarePlanRegister_593647(path: JsonNode; query: JsonNode;
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
  var valid_593821 = path.getOrDefault("subscriptionId")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "subscriptionId", valid_593821
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593822 = query.getOrDefault("api-version")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "api-version", valid_593822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_SoftwarePlanRegister_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register to Microsoft.SoftwarePlan resource provider.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_SoftwarePlanRegister_593646; apiVersion: string;
          subscriptionId: string): Recallable =
  ## softwarePlanRegister
  ## Register to Microsoft.SoftwarePlan resource provider.
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_593917 = newJObject()
  var query_593919 = newJObject()
  add(query_593919, "api-version", newJString(apiVersion))
  add(path_593917, "subscriptionId", newJString(subscriptionId))
  result = call_593916.call(path_593917, query_593919, nil, nil, nil)

var softwarePlanRegister* = Call_SoftwarePlanRegister_593646(
    name: "softwarePlanRegister", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.SoftwarePlan/register",
    validator: validate_SoftwarePlanRegister_593647, base: "",
    url: url_SoftwarePlanRegister_593648, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitList_593958 = ref object of OpenApiRestCall_593424
proc url_HybridUseBenefitList_593960(protocol: Scheme; host: string; base: string;
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

proc validate_HybridUseBenefitList_593959(path: JsonNode; query: JsonNode;
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
  var valid_593962 = path.getOrDefault("scope")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "scope", valid_593962
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  ##   $filter: JString
  ##          : Supports applying filter on the type of SKU
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593963 = query.getOrDefault("api-version")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "api-version", valid_593963
  var valid_593964 = query.getOrDefault("$filter")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "$filter", valid_593964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593965: Call_HybridUseBenefitList_593958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all hybrid use benefits associated with an ARM resource.
  ## 
  let valid = call_593965.validator(path, query, header, formData, body)
  let scheme = call_593965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593965.url(scheme.get, call_593965.host, call_593965.base,
                         call_593965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593965, url, valid)

proc call*(call_593966: Call_HybridUseBenefitList_593958; apiVersion: string;
          scope: string; Filter: string = ""): Recallable =
  ## hybridUseBenefitList
  ## Get all hybrid use benefits associated with an ARM resource.
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  ##   Filter: string
  ##         : Supports applying filter on the type of SKU
  var path_593967 = newJObject()
  var query_593968 = newJObject()
  add(query_593968, "api-version", newJString(apiVersion))
  add(path_593967, "scope", newJString(scope))
  add(query_593968, "$filter", newJString(Filter))
  result = call_593966.call(path_593967, query_593968, nil, nil, nil)

var hybridUseBenefitList* = Call_HybridUseBenefitList_593958(
    name: "hybridUseBenefitList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits",
    validator: validate_HybridUseBenefitList_593959, base: "",
    url: url_HybridUseBenefitList_593960, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitCreate_593979 = ref object of OpenApiRestCall_593424
proc url_HybridUseBenefitCreate_593981(protocol: Scheme; host: string; base: string;
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

proc validate_HybridUseBenefitCreate_593980(path: JsonNode; query: JsonNode;
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
  var valid_593999 = path.getOrDefault("planId")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "planId", valid_593999
  var valid_594000 = path.getOrDefault("scope")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "scope", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
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

proc call*(call_594003: Call_HybridUseBenefitCreate_593979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new hybrid use benefit under a given scope
  ## 
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_HybridUseBenefitCreate_593979; apiVersion: string;
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
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  var body_594007 = newJObject()
  add(query_594006, "api-version", newJString(apiVersion))
  add(path_594005, "planId", newJString(planId))
  add(path_594005, "scope", newJString(scope))
  if body != nil:
    body_594007 = body
  result = call_594004.call(path_594005, query_594006, nil, nil, body_594007)

var hybridUseBenefitCreate* = Call_HybridUseBenefitCreate_593979(
    name: "hybridUseBenefitCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits/{planId}",
    validator: validate_HybridUseBenefitCreate_593980, base: "",
    url: url_HybridUseBenefitCreate_593981, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitGet_593969 = ref object of OpenApiRestCall_593424
proc url_HybridUseBenefitGet_593971(protocol: Scheme; host: string; base: string;
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

proc validate_HybridUseBenefitGet_593970(path: JsonNode; query: JsonNode;
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
  var valid_593972 = path.getOrDefault("planId")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "planId", valid_593972
  var valid_593973 = path.getOrDefault("scope")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "scope", valid_593973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593974 = query.getOrDefault("api-version")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "api-version", valid_593974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_HybridUseBenefitGet_593969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a given plan ID
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_HybridUseBenefitGet_593969; apiVersion: string;
          planId: string; scope: string): Recallable =
  ## hybridUseBenefitGet
  ## Gets a given plan ID
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   planId: string (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  var path_593977 = newJObject()
  var query_593978 = newJObject()
  add(query_593978, "api-version", newJString(apiVersion))
  add(path_593977, "planId", newJString(planId))
  add(path_593977, "scope", newJString(scope))
  result = call_593976.call(path_593977, query_593978, nil, nil, nil)

var hybridUseBenefitGet* = Call_HybridUseBenefitGet_593969(
    name: "hybridUseBenefitGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits/{planId}",
    validator: validate_HybridUseBenefitGet_593970, base: "",
    url: url_HybridUseBenefitGet_593971, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitUpdate_594018 = ref object of OpenApiRestCall_593424
proc url_HybridUseBenefitUpdate_594020(protocol: Scheme; host: string; base: string;
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

proc validate_HybridUseBenefitUpdate_594019(path: JsonNode; query: JsonNode;
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
  var valid_594021 = path.getOrDefault("planId")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "planId", valid_594021
  var valid_594022 = path.getOrDefault("scope")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "scope", valid_594022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594023 = query.getOrDefault("api-version")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "api-version", valid_594023
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

proc call*(call_594025: Call_HybridUseBenefitUpdate_594018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing hybrid use benefit
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_HybridUseBenefitUpdate_594018; apiVersion: string;
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
  var path_594027 = newJObject()
  var query_594028 = newJObject()
  var body_594029 = newJObject()
  add(query_594028, "api-version", newJString(apiVersion))
  add(path_594027, "planId", newJString(planId))
  add(path_594027, "scope", newJString(scope))
  if body != nil:
    body_594029 = body
  result = call_594026.call(path_594027, query_594028, nil, nil, body_594029)

var hybridUseBenefitUpdate* = Call_HybridUseBenefitUpdate_594018(
    name: "hybridUseBenefitUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits/{planId}",
    validator: validate_HybridUseBenefitUpdate_594019, base: "",
    url: url_HybridUseBenefitUpdate_594020, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitDelete_594008 = ref object of OpenApiRestCall_593424
proc url_HybridUseBenefitDelete_594010(protocol: Scheme; host: string; base: string;
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

proc validate_HybridUseBenefitDelete_594009(path: JsonNode; query: JsonNode;
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
  var valid_594011 = path.getOrDefault("planId")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "planId", valid_594011
  var valid_594012 = path.getOrDefault("scope")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "scope", valid_594012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
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
  if body != nil:
    result.add "body", body

proc call*(call_594014: Call_HybridUseBenefitDelete_594008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a given plan ID
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_HybridUseBenefitDelete_594008; apiVersion: string;
          planId: string; scope: string): Recallable =
  ## hybridUseBenefitDelete
  ## Deletes a given plan ID
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   planId: string (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  add(query_594017, "api-version", newJString(apiVersion))
  add(path_594016, "planId", newJString(planId))
  add(path_594016, "scope", newJString(scope))
  result = call_594015.call(path_594016, query_594017, nil, nil, nil)

var hybridUseBenefitDelete* = Call_HybridUseBenefitDelete_594008(
    name: "hybridUseBenefitDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits/{planId}",
    validator: validate_HybridUseBenefitDelete_594009, base: "",
    url: url_HybridUseBenefitDelete_594010, schemes: {Scheme.Https})
type
  Call_HybridUseBenefitRevisionList_594030 = ref object of OpenApiRestCall_593424
proc url_HybridUseBenefitRevisionList_594032(protocol: Scheme; host: string;
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

proc validate_HybridUseBenefitRevisionList_594031(path: JsonNode; query: JsonNode;
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
  var valid_594033 = path.getOrDefault("planId")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "planId", valid_594033
  var valid_594034 = path.getOrDefault("scope")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "scope", valid_594034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594035 = query.getOrDefault("api-version")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "api-version", valid_594035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594036: Call_HybridUseBenefitRevisionList_594030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the version history of a hybrid use benefit
  ## 
  let valid = call_594036.validator(path, query, header, formData, body)
  let scheme = call_594036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594036.url(scheme.get, call_594036.host, call_594036.base,
                         call_594036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594036, url, valid)

proc call*(call_594037: Call_HybridUseBenefitRevisionList_594030;
          apiVersion: string; planId: string; scope: string): Recallable =
  ## hybridUseBenefitRevisionList
  ## Gets the version history of a hybrid use benefit
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   planId: string (required)
  ##         : This is a unique identifier for a plan. Should be a guid.
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  var path_594038 = newJObject()
  var query_594039 = newJObject()
  add(query_594039, "api-version", newJString(apiVersion))
  add(path_594038, "planId", newJString(planId))
  add(path_594038, "scope", newJString(scope))
  result = call_594037.call(path_594038, query_594039, nil, nil, nil)

var hybridUseBenefitRevisionList* = Call_HybridUseBenefitRevisionList_594030(
    name: "hybridUseBenefitRevisionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.SoftwarePlan/hybridUseBenefits/{planId}/revisions",
    validator: validate_HybridUseBenefitRevisionList_594031, base: "",
    url: url_HybridUseBenefitRevisionList_594032, schemes: {Scheme.Https})
type
  Call_OperationsList_594040 = ref object of OpenApiRestCall_593424
proc url_OperationsList_594042(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsList_594041(path: JsonNode; query: JsonNode;
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
  var valid_594043 = path.getOrDefault("scope")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "scope", valid_594043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api-version to be used by the service
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
  if body != nil:
    result.add "body", body

proc call*(call_594045: Call_OperationsList_594040; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the operations.
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_OperationsList_594040; apiVersion: string; scope: string): Recallable =
  ## operationsList
  ## List all the operations.
  ##   apiVersion: string (required)
  ##             : The api-version to be used by the service
  ##   scope: string (required)
  ##        : The scope at which the operation is performed. This is limited to Microsoft.Compute/virtualMachines and Microsoft.Compute/hostGroups/hosts for now
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  add(query_594048, "api-version", newJString(apiVersion))
  add(path_594047, "scope", newJString(scope))
  result = call_594046.call(path_594047, query_594048, nil, nil, nil)

var operationsList* = Call_OperationsList_594040(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.SoftwarePlan/operations",
    validator: validate_OperationsList_594041, base: "", url: url_OperationsList_594042,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
