
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Machine Learning Workspaces
## version: 2019-06-01
## termsOfService: (not provided)
## license: (not provided)
## 
## These APIs allow end users to operate on Azure Machine Learning Workspace resources.
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

  OpenApiRestCall_573668 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573668](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573668): Option[Scheme] {.used.} =
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
  macServiceName = "machinelearningservices-machineLearningServices"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_573890 = ref object of OpenApiRestCall_573668
proc url_OperationsList_573892(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573891(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Azure Machine Learning Workspaces REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574051 = query.getOrDefault("api-version")
  valid_574051 = validateParameter(valid_574051, JString, required = true,
                                 default = nil)
  if valid_574051 != nil:
    section.add "api-version", valid_574051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574074: Call_OperationsList_573890; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Azure Machine Learning Workspaces REST API operations.
  ## 
  let valid = call_574074.validator(path, query, header, formData, body)
  let scheme = call_574074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574074.url(scheme.get, call_574074.host, call_574074.base,
                         call_574074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574074, url, valid)

proc call*(call_574145: Call_OperationsList_573890; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Azure Machine Learning Workspaces REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  var query_574146 = newJObject()
  add(query_574146, "api-version", newJString(apiVersion))
  result = call_574145.call(nil, query_574146, nil, nil, nil)

var operationsList* = Call_OperationsList_573890(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MachineLearningServices/operations",
    validator: validate_OperationsList_573891, base: "", url: url_OperationsList_573892,
    schemes: {Scheme.Https})
type
  Call_QuotasList_574186 = ref object of OpenApiRestCall_573668
proc url_QuotasList_574188(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/Quotas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotasList_574187(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the currently assigned Workspace Quotas based on VMFamily.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   location: JString (required)
  ##           : The location for which resource usage is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574203 = path.getOrDefault("subscriptionId")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "subscriptionId", valid_574203
  var valid_574204 = path.getOrDefault("location")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "location", valid_574204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574205 = query.getOrDefault("api-version")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "api-version", valid_574205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574206: Call_QuotasList_574186; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the currently assigned Workspace Quotas based on VMFamily.
  ## 
  let valid = call_574206.validator(path, query, header, formData, body)
  let scheme = call_574206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574206.url(scheme.get, call_574206.host, call_574206.base,
                         call_574206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574206, url, valid)

proc call*(call_574207: Call_QuotasList_574186; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## quotasList
  ## Gets the currently assigned Workspace Quotas based on VMFamily.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   location: string (required)
  ##           : The location for which resource usage is queried.
  var path_574208 = newJObject()
  var query_574209 = newJObject()
  add(query_574209, "api-version", newJString(apiVersion))
  add(path_574208, "subscriptionId", newJString(subscriptionId))
  add(path_574208, "location", newJString(location))
  result = call_574207.call(path_574208, query_574209, nil, nil, nil)

var quotasList* = Call_QuotasList_574186(name: "quotasList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/Quotas",
                                      validator: validate_QuotasList_574187,
                                      base: "", url: url_QuotasList_574188,
                                      schemes: {Scheme.Https})
type
  Call_QuotasUpdate_574210 = ref object of OpenApiRestCall_573668
proc url_QuotasUpdate_574212(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/updateQuotas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotasUpdate_574211(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Update quota for each VM family in workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   location: JString (required)
  ##           : The location for update quota is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574230 = path.getOrDefault("subscriptionId")
  valid_574230 = validateParameter(valid_574230, JString, required = true,
                                 default = nil)
  if valid_574230 != nil:
    section.add "subscriptionId", valid_574230
  var valid_574231 = path.getOrDefault("location")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "location", valid_574231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574232 = query.getOrDefault("api-version")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "api-version", valid_574232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Quota update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574234: Call_QuotasUpdate_574210; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update quota for each VM family in workspace.
  ## 
  let valid = call_574234.validator(path, query, header, formData, body)
  let scheme = call_574234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574234.url(scheme.get, call_574234.host, call_574234.base,
                         call_574234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574234, url, valid)

proc call*(call_574235: Call_QuotasUpdate_574210; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; location: string): Recallable =
  ## quotasUpdate
  ## Update quota for each VM family in workspace.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   parameters: JObject (required)
  ##             : Quota update parameters.
  ##   location: string (required)
  ##           : The location for update quota is queried.
  var path_574236 = newJObject()
  var query_574237 = newJObject()
  var body_574238 = newJObject()
  add(query_574237, "api-version", newJString(apiVersion))
  add(path_574236, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574238 = parameters
  add(path_574236, "location", newJString(location))
  result = call_574235.call(path_574236, query_574237, nil, nil, body_574238)

var quotasUpdate* = Call_QuotasUpdate_574210(name: "quotasUpdate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/updateQuotas",
    validator: validate_QuotasUpdate_574211, base: "", url: url_QuotasUpdate_574212,
    schemes: {Scheme.Https})
type
  Call_UsagesList_574239 = ref object of OpenApiRestCall_573668
proc url_UsagesList_574241(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsagesList_574240(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current usage information as well as limits for AML resources for given subscription and location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   location: JString (required)
  ##           : The location for which resource usage is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574242 = path.getOrDefault("subscriptionId")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "subscriptionId", valid_574242
  var valid_574243 = path.getOrDefault("location")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "location", valid_574243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  ##   expandChildren: JString
  ##                 : Specifies if detailed usages of child resources are required.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574244 = query.getOrDefault("api-version")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "api-version", valid_574244
  var valid_574245 = query.getOrDefault("expandChildren")
  valid_574245 = validateParameter(valid_574245, JString, required = false,
                                 default = nil)
  if valid_574245 != nil:
    section.add "expandChildren", valid_574245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574246: Call_UsagesList_574239; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current usage information as well as limits for AML resources for given subscription and location.
  ## 
  let valid = call_574246.validator(path, query, header, formData, body)
  let scheme = call_574246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574246.url(scheme.get, call_574246.host, call_574246.base,
                         call_574246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574246, url, valid)

proc call*(call_574247: Call_UsagesList_574239; apiVersion: string;
          subscriptionId: string; location: string; expandChildren: string = ""): Recallable =
  ## usagesList
  ## Gets the current usage information as well as limits for AML resources for given subscription and location.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   expandChildren: string
  ##                 : Specifies if detailed usages of child resources are required.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   location: string (required)
  ##           : The location for which resource usage is queried.
  var path_574248 = newJObject()
  var query_574249 = newJObject()
  add(query_574249, "api-version", newJString(apiVersion))
  add(query_574249, "expandChildren", newJString(expandChildren))
  add(path_574248, "subscriptionId", newJString(subscriptionId))
  add(path_574248, "location", newJString(location))
  result = call_574247.call(path_574248, query_574249, nil, nil, nil)

var usagesList* = Call_UsagesList_574239(name: "usagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/usages",
                                      validator: validate_UsagesList_574240,
                                      base: "", url: url_UsagesList_574241,
                                      schemes: {Scheme.Https})
type
  Call_VirtualMachineSizesList_574250 = ref object of OpenApiRestCall_573668
proc url_VirtualMachineSizesList_574252(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/vmSizes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSizesList_574251(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns supported VM Sizes in a location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   location: JString (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574253 = path.getOrDefault("subscriptionId")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = nil)
  if valid_574253 != nil:
    section.add "subscriptionId", valid_574253
  var valid_574254 = path.getOrDefault("location")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "location", valid_574254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574255 = query.getOrDefault("api-version")
  valid_574255 = validateParameter(valid_574255, JString, required = true,
                                 default = nil)
  if valid_574255 != nil:
    section.add "api-version", valid_574255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574256: Call_VirtualMachineSizesList_574250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns supported VM Sizes in a location
  ## 
  let valid = call_574256.validator(path, query, header, formData, body)
  let scheme = call_574256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574256.url(scheme.get, call_574256.host, call_574256.base,
                         call_574256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574256, url, valid)

proc call*(call_574257: Call_VirtualMachineSizesList_574250; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## virtualMachineSizesList
  ## Returns supported VM Sizes in a location
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   location: string (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  var path_574258 = newJObject()
  var query_574259 = newJObject()
  add(query_574259, "api-version", newJString(apiVersion))
  add(path_574258, "subscriptionId", newJString(subscriptionId))
  add(path_574258, "location", newJString(location))
  result = call_574257.call(path_574258, query_574259, nil, nil, nil)

var virtualMachineSizesList* = Call_VirtualMachineSizesList_574250(
    name: "virtualMachineSizesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/vmSizes",
    validator: validate_VirtualMachineSizesList_574251, base: "",
    url: url_VirtualMachineSizesList_574252, schemes: {Scheme.Https})
type
  Call_WorkspacesListBySubscription_574260 = ref object of OpenApiRestCall_573668
proc url_WorkspacesListBySubscription_574262(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListBySubscription_574261(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available machine learning workspaces under the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574264 = path.getOrDefault("subscriptionId")
  valid_574264 = validateParameter(valid_574264, JString, required = true,
                                 default = nil)
  if valid_574264 != nil:
    section.add "subscriptionId", valid_574264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574265 = query.getOrDefault("api-version")
  valid_574265 = validateParameter(valid_574265, JString, required = true,
                                 default = nil)
  if valid_574265 != nil:
    section.add "api-version", valid_574265
  var valid_574266 = query.getOrDefault("$skiptoken")
  valid_574266 = validateParameter(valid_574266, JString, required = false,
                                 default = nil)
  if valid_574266 != nil:
    section.add "$skiptoken", valid_574266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574267: Call_WorkspacesListBySubscription_574260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available machine learning workspaces under the specified subscription.
  ## 
  let valid = call_574267.validator(path, query, header, formData, body)
  let scheme = call_574267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574267.url(scheme.get, call_574267.host, call_574267.base,
                         call_574267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574267, url, valid)

proc call*(call_574268: Call_WorkspacesListBySubscription_574260;
          apiVersion: string; subscriptionId: string; Skiptoken: string = ""): Recallable =
  ## workspacesListBySubscription
  ## Lists all the available machine learning workspaces under the specified subscription.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  var path_574269 = newJObject()
  var query_574270 = newJObject()
  add(query_574270, "api-version", newJString(apiVersion))
  add(path_574269, "subscriptionId", newJString(subscriptionId))
  add(query_574270, "$skiptoken", newJString(Skiptoken))
  result = call_574268.call(path_574269, query_574270, nil, nil, nil)

var workspacesListBySubscription* = Call_WorkspacesListBySubscription_574260(
    name: "workspacesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/workspaces",
    validator: validate_WorkspacesListBySubscription_574261, base: "",
    url: url_WorkspacesListBySubscription_574262, schemes: {Scheme.Https})
type
  Call_WorkspacesListByResourceGroup_574271 = ref object of OpenApiRestCall_573668
proc url_WorkspacesListByResourceGroup_574273(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.MachineLearningServices/workspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListByResourceGroup_574272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available machine learning workspaces under the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574274 = path.getOrDefault("resourceGroupName")
  valid_574274 = validateParameter(valid_574274, JString, required = true,
                                 default = nil)
  if valid_574274 != nil:
    section.add "resourceGroupName", valid_574274
  var valid_574275 = path.getOrDefault("subscriptionId")
  valid_574275 = validateParameter(valid_574275, JString, required = true,
                                 default = nil)
  if valid_574275 != nil:
    section.add "subscriptionId", valid_574275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574276 = query.getOrDefault("api-version")
  valid_574276 = validateParameter(valid_574276, JString, required = true,
                                 default = nil)
  if valid_574276 != nil:
    section.add "api-version", valid_574276
  var valid_574277 = query.getOrDefault("$skiptoken")
  valid_574277 = validateParameter(valid_574277, JString, required = false,
                                 default = nil)
  if valid_574277 != nil:
    section.add "$skiptoken", valid_574277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574278: Call_WorkspacesListByResourceGroup_574271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available machine learning workspaces under the specified resource group.
  ## 
  let valid = call_574278.validator(path, query, header, formData, body)
  let scheme = call_574278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574278.url(scheme.get, call_574278.host, call_574278.base,
                         call_574278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574278, url, valid)

proc call*(call_574279: Call_WorkspacesListByResourceGroup_574271;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Skiptoken: string = ""): Recallable =
  ## workspacesListByResourceGroup
  ## Lists all the available machine learning workspaces under the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  var path_574280 = newJObject()
  var query_574281 = newJObject()
  add(path_574280, "resourceGroupName", newJString(resourceGroupName))
  add(query_574281, "api-version", newJString(apiVersion))
  add(path_574280, "subscriptionId", newJString(subscriptionId))
  add(query_574281, "$skiptoken", newJString(Skiptoken))
  result = call_574279.call(path_574280, query_574281, nil, nil, nil)

var workspacesListByResourceGroup* = Call_WorkspacesListByResourceGroup_574271(
    name: "workspacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces",
    validator: validate_WorkspacesListByResourceGroup_574272, base: "",
    url: url_WorkspacesListByResourceGroup_574273, schemes: {Scheme.Https})
type
  Call_WorkspacesCreateOrUpdate_574293 = ref object of OpenApiRestCall_573668
proc url_WorkspacesCreateOrUpdate_574295(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesCreateOrUpdate_574294(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a workspace with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574296 = path.getOrDefault("resourceGroupName")
  valid_574296 = validateParameter(valid_574296, JString, required = true,
                                 default = nil)
  if valid_574296 != nil:
    section.add "resourceGroupName", valid_574296
  var valid_574297 = path.getOrDefault("subscriptionId")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = nil)
  if valid_574297 != nil:
    section.add "subscriptionId", valid_574297
  var valid_574298 = path.getOrDefault("workspaceName")
  valid_574298 = validateParameter(valid_574298, JString, required = true,
                                 default = nil)
  if valid_574298 != nil:
    section.add "workspaceName", valid_574298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574299 = query.getOrDefault("api-version")
  valid_574299 = validateParameter(valid_574299, JString, required = true,
                                 default = nil)
  if valid_574299 != nil:
    section.add "api-version", valid_574299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for creating or updating a machine learning workspace.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574301: Call_WorkspacesCreateOrUpdate_574293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a workspace with the specified parameters.
  ## 
  let valid = call_574301.validator(path, query, header, formData, body)
  let scheme = call_574301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574301.url(scheme.get, call_574301.host, call_574301.base,
                         call_574301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574301, url, valid)

proc call*(call_574302: Call_WorkspacesCreateOrUpdate_574293;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; workspaceName: string): Recallable =
  ## workspacesCreateOrUpdate
  ## Creates or updates a workspace with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   parameters: JObject (required)
  ##             : The parameters for creating or updating a machine learning workspace.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_574303 = newJObject()
  var query_574304 = newJObject()
  var body_574305 = newJObject()
  add(path_574303, "resourceGroupName", newJString(resourceGroupName))
  add(query_574304, "api-version", newJString(apiVersion))
  add(path_574303, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574305 = parameters
  add(path_574303, "workspaceName", newJString(workspaceName))
  result = call_574302.call(path_574303, query_574304, nil, nil, body_574305)

var workspacesCreateOrUpdate* = Call_WorkspacesCreateOrUpdate_574293(
    name: "workspacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}",
    validator: validate_WorkspacesCreateOrUpdate_574294, base: "",
    url: url_WorkspacesCreateOrUpdate_574295, schemes: {Scheme.Https})
type
  Call_WorkspacesGet_574282 = ref object of OpenApiRestCall_573668
proc url_WorkspacesGet_574284(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesGet_574283(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified machine learning workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574285 = path.getOrDefault("resourceGroupName")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = nil)
  if valid_574285 != nil:
    section.add "resourceGroupName", valid_574285
  var valid_574286 = path.getOrDefault("subscriptionId")
  valid_574286 = validateParameter(valid_574286, JString, required = true,
                                 default = nil)
  if valid_574286 != nil:
    section.add "subscriptionId", valid_574286
  var valid_574287 = path.getOrDefault("workspaceName")
  valid_574287 = validateParameter(valid_574287, JString, required = true,
                                 default = nil)
  if valid_574287 != nil:
    section.add "workspaceName", valid_574287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574288 = query.getOrDefault("api-version")
  valid_574288 = validateParameter(valid_574288, JString, required = true,
                                 default = nil)
  if valid_574288 != nil:
    section.add "api-version", valid_574288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574289: Call_WorkspacesGet_574282; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified machine learning workspace.
  ## 
  let valid = call_574289.validator(path, query, header, formData, body)
  let scheme = call_574289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574289.url(scheme.get, call_574289.host, call_574289.base,
                         call_574289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574289, url, valid)

proc call*(call_574290: Call_WorkspacesGet_574282; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesGet
  ## Gets the properties of the specified machine learning workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_574291 = newJObject()
  var query_574292 = newJObject()
  add(path_574291, "resourceGroupName", newJString(resourceGroupName))
  add(query_574292, "api-version", newJString(apiVersion))
  add(path_574291, "subscriptionId", newJString(subscriptionId))
  add(path_574291, "workspaceName", newJString(workspaceName))
  result = call_574290.call(path_574291, query_574292, nil, nil, nil)

var workspacesGet* = Call_WorkspacesGet_574282(name: "workspacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}",
    validator: validate_WorkspacesGet_574283, base: "", url: url_WorkspacesGet_574284,
    schemes: {Scheme.Https})
type
  Call_WorkspacesUpdate_574317 = ref object of OpenApiRestCall_573668
proc url_WorkspacesUpdate_574319(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesUpdate_574318(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a machine learning workspace with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574320 = path.getOrDefault("resourceGroupName")
  valid_574320 = validateParameter(valid_574320, JString, required = true,
                                 default = nil)
  if valid_574320 != nil:
    section.add "resourceGroupName", valid_574320
  var valid_574321 = path.getOrDefault("subscriptionId")
  valid_574321 = validateParameter(valid_574321, JString, required = true,
                                 default = nil)
  if valid_574321 != nil:
    section.add "subscriptionId", valid_574321
  var valid_574322 = path.getOrDefault("workspaceName")
  valid_574322 = validateParameter(valid_574322, JString, required = true,
                                 default = nil)
  if valid_574322 != nil:
    section.add "workspaceName", valid_574322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574323 = query.getOrDefault("api-version")
  valid_574323 = validateParameter(valid_574323, JString, required = true,
                                 default = nil)
  if valid_574323 != nil:
    section.add "api-version", valid_574323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for updating a machine learning workspace.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574325: Call_WorkspacesUpdate_574317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a machine learning workspace with the specified parameters.
  ## 
  let valid = call_574325.validator(path, query, header, formData, body)
  let scheme = call_574325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574325.url(scheme.get, call_574325.host, call_574325.base,
                         call_574325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574325, url, valid)

proc call*(call_574326: Call_WorkspacesUpdate_574317; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          workspaceName: string): Recallable =
  ## workspacesUpdate
  ## Updates a machine learning workspace with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   parameters: JObject (required)
  ##             : The parameters for updating a machine learning workspace.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_574327 = newJObject()
  var query_574328 = newJObject()
  var body_574329 = newJObject()
  add(path_574327, "resourceGroupName", newJString(resourceGroupName))
  add(query_574328, "api-version", newJString(apiVersion))
  add(path_574327, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574329 = parameters
  add(path_574327, "workspaceName", newJString(workspaceName))
  result = call_574326.call(path_574327, query_574328, nil, nil, body_574329)

var workspacesUpdate* = Call_WorkspacesUpdate_574317(name: "workspacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}",
    validator: validate_WorkspacesUpdate_574318, base: "",
    url: url_WorkspacesUpdate_574319, schemes: {Scheme.Https})
type
  Call_WorkspacesDelete_574306 = ref object of OpenApiRestCall_573668
proc url_WorkspacesDelete_574308(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesDelete_574307(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a machine learning workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574309 = path.getOrDefault("resourceGroupName")
  valid_574309 = validateParameter(valid_574309, JString, required = true,
                                 default = nil)
  if valid_574309 != nil:
    section.add "resourceGroupName", valid_574309
  var valid_574310 = path.getOrDefault("subscriptionId")
  valid_574310 = validateParameter(valid_574310, JString, required = true,
                                 default = nil)
  if valid_574310 != nil:
    section.add "subscriptionId", valid_574310
  var valid_574311 = path.getOrDefault("workspaceName")
  valid_574311 = validateParameter(valid_574311, JString, required = true,
                                 default = nil)
  if valid_574311 != nil:
    section.add "workspaceName", valid_574311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574312 = query.getOrDefault("api-version")
  valid_574312 = validateParameter(valid_574312, JString, required = true,
                                 default = nil)
  if valid_574312 != nil:
    section.add "api-version", valid_574312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574313: Call_WorkspacesDelete_574306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a machine learning workspace.
  ## 
  let valid = call_574313.validator(path, query, header, formData, body)
  let scheme = call_574313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574313.url(scheme.get, call_574313.host, call_574313.base,
                         call_574313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574313, url, valid)

proc call*(call_574314: Call_WorkspacesDelete_574306; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesDelete
  ## Deletes a machine learning workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_574315 = newJObject()
  var query_574316 = newJObject()
  add(path_574315, "resourceGroupName", newJString(resourceGroupName))
  add(query_574316, "api-version", newJString(apiVersion))
  add(path_574315, "subscriptionId", newJString(subscriptionId))
  add(path_574315, "workspaceName", newJString(workspaceName))
  result = call_574314.call(path_574315, query_574316, nil, nil, nil)

var workspacesDelete* = Call_WorkspacesDelete_574306(name: "workspacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}",
    validator: validate_WorkspacesDelete_574307, base: "",
    url: url_WorkspacesDelete_574308, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeListByWorkspace_574330 = ref object of OpenApiRestCall_573668
proc url_MachineLearningComputeListByWorkspace_574332(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeListByWorkspace_574331(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets computes in specified workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574333 = path.getOrDefault("resourceGroupName")
  valid_574333 = validateParameter(valid_574333, JString, required = true,
                                 default = nil)
  if valid_574333 != nil:
    section.add "resourceGroupName", valid_574333
  var valid_574334 = path.getOrDefault("subscriptionId")
  valid_574334 = validateParameter(valid_574334, JString, required = true,
                                 default = nil)
  if valid_574334 != nil:
    section.add "subscriptionId", valid_574334
  var valid_574335 = path.getOrDefault("workspaceName")
  valid_574335 = validateParameter(valid_574335, JString, required = true,
                                 default = nil)
  if valid_574335 != nil:
    section.add "workspaceName", valid_574335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574336 = query.getOrDefault("api-version")
  valid_574336 = validateParameter(valid_574336, JString, required = true,
                                 default = nil)
  if valid_574336 != nil:
    section.add "api-version", valid_574336
  var valid_574337 = query.getOrDefault("$skiptoken")
  valid_574337 = validateParameter(valid_574337, JString, required = false,
                                 default = nil)
  if valid_574337 != nil:
    section.add "$skiptoken", valid_574337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574338: Call_MachineLearningComputeListByWorkspace_574330;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets computes in specified workspace.
  ## 
  let valid = call_574338.validator(path, query, header, formData, body)
  let scheme = call_574338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574338.url(scheme.get, call_574338.host, call_574338.base,
                         call_574338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574338, url, valid)

proc call*(call_574339: Call_MachineLearningComputeListByWorkspace_574330;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string; Skiptoken: string = ""): Recallable =
  ## machineLearningComputeListByWorkspace
  ## Gets computes in specified workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_574340 = newJObject()
  var query_574341 = newJObject()
  add(path_574340, "resourceGroupName", newJString(resourceGroupName))
  add(query_574341, "api-version", newJString(apiVersion))
  add(path_574340, "subscriptionId", newJString(subscriptionId))
  add(query_574341, "$skiptoken", newJString(Skiptoken))
  add(path_574340, "workspaceName", newJString(workspaceName))
  result = call_574339.call(path_574340, query_574341, nil, nil, nil)

var machineLearningComputeListByWorkspace* = Call_MachineLearningComputeListByWorkspace_574330(
    name: "machineLearningComputeListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes",
    validator: validate_MachineLearningComputeListByWorkspace_574331, base: "",
    url: url_MachineLearningComputeListByWorkspace_574332, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeCreateOrUpdate_574354 = ref object of OpenApiRestCall_573668
proc url_MachineLearningComputeCreateOrUpdate_574356(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeCreateOrUpdate_574355(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574357 = path.getOrDefault("resourceGroupName")
  valid_574357 = validateParameter(valid_574357, JString, required = true,
                                 default = nil)
  if valid_574357 != nil:
    section.add "resourceGroupName", valid_574357
  var valid_574358 = path.getOrDefault("subscriptionId")
  valid_574358 = validateParameter(valid_574358, JString, required = true,
                                 default = nil)
  if valid_574358 != nil:
    section.add "subscriptionId", valid_574358
  var valid_574359 = path.getOrDefault("computeName")
  valid_574359 = validateParameter(valid_574359, JString, required = true,
                                 default = nil)
  if valid_574359 != nil:
    section.add "computeName", valid_574359
  var valid_574360 = path.getOrDefault("workspaceName")
  valid_574360 = validateParameter(valid_574360, JString, required = true,
                                 default = nil)
  if valid_574360 != nil:
    section.add "workspaceName", valid_574360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Payload with Machine Learning compute definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574363: Call_MachineLearningComputeCreateOrUpdate_574354;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.
  ## 
  let valid = call_574363.validator(path, query, header, formData, body)
  let scheme = call_574363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574363.url(scheme.get, call_574363.host, call_574363.base,
                         call_574363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574363, url, valid)

proc call*(call_574364: Call_MachineLearningComputeCreateOrUpdate_574354;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; parameters: JsonNode; workspaceName: string): Recallable =
  ## machineLearningComputeCreateOrUpdate
  ## Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   parameters: JObject (required)
  ##             : Payload with Machine Learning compute definition.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_574365 = newJObject()
  var query_574366 = newJObject()
  var body_574367 = newJObject()
  add(path_574365, "resourceGroupName", newJString(resourceGroupName))
  add(query_574366, "api-version", newJString(apiVersion))
  add(path_574365, "subscriptionId", newJString(subscriptionId))
  add(path_574365, "computeName", newJString(computeName))
  if parameters != nil:
    body_574367 = parameters
  add(path_574365, "workspaceName", newJString(workspaceName))
  result = call_574364.call(path_574365, query_574366, nil, nil, body_574367)

var machineLearningComputeCreateOrUpdate* = Call_MachineLearningComputeCreateOrUpdate_574354(
    name: "machineLearningComputeCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}",
    validator: validate_MachineLearningComputeCreateOrUpdate_574355, base: "",
    url: url_MachineLearningComputeCreateOrUpdate_574356, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeGet_574342 = ref object of OpenApiRestCall_573668
proc url_MachineLearningComputeGet_574344(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeGet_574343(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets compute definition by its name. Any secrets (storage keys, service credentials, etc) are not returned - use 'keys' nested resource to get them.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574345 = path.getOrDefault("resourceGroupName")
  valid_574345 = validateParameter(valid_574345, JString, required = true,
                                 default = nil)
  if valid_574345 != nil:
    section.add "resourceGroupName", valid_574345
  var valid_574346 = path.getOrDefault("subscriptionId")
  valid_574346 = validateParameter(valid_574346, JString, required = true,
                                 default = nil)
  if valid_574346 != nil:
    section.add "subscriptionId", valid_574346
  var valid_574347 = path.getOrDefault("computeName")
  valid_574347 = validateParameter(valid_574347, JString, required = true,
                                 default = nil)
  if valid_574347 != nil:
    section.add "computeName", valid_574347
  var valid_574348 = path.getOrDefault("workspaceName")
  valid_574348 = validateParameter(valid_574348, JString, required = true,
                                 default = nil)
  if valid_574348 != nil:
    section.add "workspaceName", valid_574348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574349 = query.getOrDefault("api-version")
  valid_574349 = validateParameter(valid_574349, JString, required = true,
                                 default = nil)
  if valid_574349 != nil:
    section.add "api-version", valid_574349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574350: Call_MachineLearningComputeGet_574342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets compute definition by its name. Any secrets (storage keys, service credentials, etc) are not returned - use 'keys' nested resource to get them.
  ## 
  let valid = call_574350.validator(path, query, header, formData, body)
  let scheme = call_574350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574350.url(scheme.get, call_574350.host, call_574350.base,
                         call_574350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574350, url, valid)

proc call*(call_574351: Call_MachineLearningComputeGet_574342;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; workspaceName: string): Recallable =
  ## machineLearningComputeGet
  ## Gets compute definition by its name. Any secrets (storage keys, service credentials, etc) are not returned - use 'keys' nested resource to get them.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_574352 = newJObject()
  var query_574353 = newJObject()
  add(path_574352, "resourceGroupName", newJString(resourceGroupName))
  add(query_574353, "api-version", newJString(apiVersion))
  add(path_574352, "subscriptionId", newJString(subscriptionId))
  add(path_574352, "computeName", newJString(computeName))
  add(path_574352, "workspaceName", newJString(workspaceName))
  result = call_574351.call(path_574352, query_574353, nil, nil, nil)

var machineLearningComputeGet* = Call_MachineLearningComputeGet_574342(
    name: "machineLearningComputeGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}",
    validator: validate_MachineLearningComputeGet_574343, base: "",
    url: url_MachineLearningComputeGet_574344, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeUpdate_574394 = ref object of OpenApiRestCall_573668
proc url_MachineLearningComputeUpdate_574396(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeUpdate_574395(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates properties of a compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574397 = path.getOrDefault("resourceGroupName")
  valid_574397 = validateParameter(valid_574397, JString, required = true,
                                 default = nil)
  if valid_574397 != nil:
    section.add "resourceGroupName", valid_574397
  var valid_574398 = path.getOrDefault("subscriptionId")
  valid_574398 = validateParameter(valid_574398, JString, required = true,
                                 default = nil)
  if valid_574398 != nil:
    section.add "subscriptionId", valid_574398
  var valid_574399 = path.getOrDefault("computeName")
  valid_574399 = validateParameter(valid_574399, JString, required = true,
                                 default = nil)
  if valid_574399 != nil:
    section.add "computeName", valid_574399
  var valid_574400 = path.getOrDefault("workspaceName")
  valid_574400 = validateParameter(valid_574400, JString, required = true,
                                 default = nil)
  if valid_574400 != nil:
    section.add "workspaceName", valid_574400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574401 = query.getOrDefault("api-version")
  valid_574401 = validateParameter(valid_574401, JString, required = true,
                                 default = nil)
  if valid_574401 != nil:
    section.add "api-version", valid_574401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters for cluster update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574403: Call_MachineLearningComputeUpdate_574394; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates properties of a compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation.
  ## 
  let valid = call_574403.validator(path, query, header, formData, body)
  let scheme = call_574403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574403.url(scheme.get, call_574403.host, call_574403.base,
                         call_574403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574403, url, valid)

proc call*(call_574404: Call_MachineLearningComputeUpdate_574394;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; parameters: JsonNode; workspaceName: string): Recallable =
  ## machineLearningComputeUpdate
  ## Updates properties of a compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   parameters: JObject (required)
  ##             : Additional parameters for cluster update.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_574405 = newJObject()
  var query_574406 = newJObject()
  var body_574407 = newJObject()
  add(path_574405, "resourceGroupName", newJString(resourceGroupName))
  add(query_574406, "api-version", newJString(apiVersion))
  add(path_574405, "subscriptionId", newJString(subscriptionId))
  add(path_574405, "computeName", newJString(computeName))
  if parameters != nil:
    body_574407 = parameters
  add(path_574405, "workspaceName", newJString(workspaceName))
  result = call_574404.call(path_574405, query_574406, nil, nil, body_574407)

var machineLearningComputeUpdate* = Call_MachineLearningComputeUpdate_574394(
    name: "machineLearningComputeUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}",
    validator: validate_MachineLearningComputeUpdate_574395, base: "",
    url: url_MachineLearningComputeUpdate_574396, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeDelete_574368 = ref object of OpenApiRestCall_573668
proc url_MachineLearningComputeDelete_574370(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeDelete_574369(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specified Machine Learning compute.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574371 = path.getOrDefault("resourceGroupName")
  valid_574371 = validateParameter(valid_574371, JString, required = true,
                                 default = nil)
  if valid_574371 != nil:
    section.add "resourceGroupName", valid_574371
  var valid_574372 = path.getOrDefault("subscriptionId")
  valid_574372 = validateParameter(valid_574372, JString, required = true,
                                 default = nil)
  if valid_574372 != nil:
    section.add "subscriptionId", valid_574372
  var valid_574373 = path.getOrDefault("computeName")
  valid_574373 = validateParameter(valid_574373, JString, required = true,
                                 default = nil)
  if valid_574373 != nil:
    section.add "computeName", valid_574373
  var valid_574374 = path.getOrDefault("workspaceName")
  valid_574374 = validateParameter(valid_574374, JString, required = true,
                                 default = nil)
  if valid_574374 != nil:
    section.add "workspaceName", valid_574374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  ##   underlyingResourceAction: JString (required)
  ##                           : Delete the underlying compute if 'Delete', or detach the underlying compute from workspace if 'Detach'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574375 = query.getOrDefault("api-version")
  valid_574375 = validateParameter(valid_574375, JString, required = true,
                                 default = nil)
  if valid_574375 != nil:
    section.add "api-version", valid_574375
  var valid_574389 = query.getOrDefault("underlyingResourceAction")
  valid_574389 = validateParameter(valid_574389, JString, required = true,
                                 default = newJString("Delete"))
  if valid_574389 != nil:
    section.add "underlyingResourceAction", valid_574389
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574390: Call_MachineLearningComputeDelete_574368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specified Machine Learning compute.
  ## 
  let valid = call_574390.validator(path, query, header, formData, body)
  let scheme = call_574390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574390.url(scheme.get, call_574390.host, call_574390.base,
                         call_574390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574390, url, valid)

proc call*(call_574391: Call_MachineLearningComputeDelete_574368;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; workspaceName: string;
          underlyingResourceAction: string = "Delete"): Recallable =
  ## machineLearningComputeDelete
  ## Deletes specified Machine Learning compute.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   underlyingResourceAction: string (required)
  ##                           : Delete the underlying compute if 'Delete', or detach the underlying compute from workspace if 'Detach'.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_574392 = newJObject()
  var query_574393 = newJObject()
  add(path_574392, "resourceGroupName", newJString(resourceGroupName))
  add(query_574393, "api-version", newJString(apiVersion))
  add(path_574392, "subscriptionId", newJString(subscriptionId))
  add(path_574392, "computeName", newJString(computeName))
  add(query_574393, "underlyingResourceAction",
      newJString(underlyingResourceAction))
  add(path_574392, "workspaceName", newJString(workspaceName))
  result = call_574391.call(path_574392, query_574393, nil, nil, nil)

var machineLearningComputeDelete* = Call_MachineLearningComputeDelete_574368(
    name: "machineLearningComputeDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}",
    validator: validate_MachineLearningComputeDelete_574369, base: "",
    url: url_MachineLearningComputeDelete_574370, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeListKeys_574408 = ref object of OpenApiRestCall_573668
proc url_MachineLearningComputeListKeys_574410(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeListKeys_574409(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574411 = path.getOrDefault("resourceGroupName")
  valid_574411 = validateParameter(valid_574411, JString, required = true,
                                 default = nil)
  if valid_574411 != nil:
    section.add "resourceGroupName", valid_574411
  var valid_574412 = path.getOrDefault("subscriptionId")
  valid_574412 = validateParameter(valid_574412, JString, required = true,
                                 default = nil)
  if valid_574412 != nil:
    section.add "subscriptionId", valid_574412
  var valid_574413 = path.getOrDefault("computeName")
  valid_574413 = validateParameter(valid_574413, JString, required = true,
                                 default = nil)
  if valid_574413 != nil:
    section.add "computeName", valid_574413
  var valid_574414 = path.getOrDefault("workspaceName")
  valid_574414 = validateParameter(valid_574414, JString, required = true,
                                 default = nil)
  if valid_574414 != nil:
    section.add "workspaceName", valid_574414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574415 = query.getOrDefault("api-version")
  valid_574415 = validateParameter(valid_574415, JString, required = true,
                                 default = nil)
  if valid_574415 != nil:
    section.add "api-version", valid_574415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574416: Call_MachineLearningComputeListKeys_574408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).
  ## 
  let valid = call_574416.validator(path, query, header, formData, body)
  let scheme = call_574416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574416.url(scheme.get, call_574416.host, call_574416.base,
                         call_574416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574416, url, valid)

proc call*(call_574417: Call_MachineLearningComputeListKeys_574408;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; workspaceName: string): Recallable =
  ## machineLearningComputeListKeys
  ## Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_574418 = newJObject()
  var query_574419 = newJObject()
  add(path_574418, "resourceGroupName", newJString(resourceGroupName))
  add(query_574419, "api-version", newJString(apiVersion))
  add(path_574418, "subscriptionId", newJString(subscriptionId))
  add(path_574418, "computeName", newJString(computeName))
  add(path_574418, "workspaceName", newJString(workspaceName))
  result = call_574417.call(path_574418, query_574419, nil, nil, nil)

var machineLearningComputeListKeys* = Call_MachineLearningComputeListKeys_574408(
    name: "machineLearningComputeListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}/listKeys",
    validator: validate_MachineLearningComputeListKeys_574409, base: "",
    url: url_MachineLearningComputeListKeys_574410, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeListNodes_574420 = ref object of OpenApiRestCall_573668
proc url_MachineLearningComputeListNodes_574422(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName"),
               (kind: ConstantSegment, value: "/listNodes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeListNodes_574421(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the details (e.g IP address, port etc) of all the compute nodes in the compute.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574423 = path.getOrDefault("resourceGroupName")
  valid_574423 = validateParameter(valid_574423, JString, required = true,
                                 default = nil)
  if valid_574423 != nil:
    section.add "resourceGroupName", valid_574423
  var valid_574424 = path.getOrDefault("subscriptionId")
  valid_574424 = validateParameter(valid_574424, JString, required = true,
                                 default = nil)
  if valid_574424 != nil:
    section.add "subscriptionId", valid_574424
  var valid_574425 = path.getOrDefault("computeName")
  valid_574425 = validateParameter(valid_574425, JString, required = true,
                                 default = nil)
  if valid_574425 != nil:
    section.add "computeName", valid_574425
  var valid_574426 = path.getOrDefault("workspaceName")
  valid_574426 = validateParameter(valid_574426, JString, required = true,
                                 default = nil)
  if valid_574426 != nil:
    section.add "workspaceName", valid_574426
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574427 = query.getOrDefault("api-version")
  valid_574427 = validateParameter(valid_574427, JString, required = true,
                                 default = nil)
  if valid_574427 != nil:
    section.add "api-version", valid_574427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574428: Call_MachineLearningComputeListNodes_574420;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the details (e.g IP address, port etc) of all the compute nodes in the compute.
  ## 
  let valid = call_574428.validator(path, query, header, formData, body)
  let scheme = call_574428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574428.url(scheme.get, call_574428.host, call_574428.base,
                         call_574428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574428, url, valid)

proc call*(call_574429: Call_MachineLearningComputeListNodes_574420;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; workspaceName: string): Recallable =
  ## machineLearningComputeListNodes
  ## Get the details (e.g IP address, port etc) of all the compute nodes in the compute.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_574430 = newJObject()
  var query_574431 = newJObject()
  add(path_574430, "resourceGroupName", newJString(resourceGroupName))
  add(query_574431, "api-version", newJString(apiVersion))
  add(path_574430, "subscriptionId", newJString(subscriptionId))
  add(path_574430, "computeName", newJString(computeName))
  add(path_574430, "workspaceName", newJString(workspaceName))
  result = call_574429.call(path_574430, query_574431, nil, nil, nil)

var machineLearningComputeListNodes* = Call_MachineLearningComputeListNodes_574420(
    name: "machineLearningComputeListNodes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}/listNodes",
    validator: validate_MachineLearningComputeListNodes_574421, base: "",
    url: url_MachineLearningComputeListNodes_574422, schemes: {Scheme.Https})
type
  Call_WorkspacesListKeys_574432 = ref object of OpenApiRestCall_573668
proc url_WorkspacesListKeys_574434(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListKeys_574433(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574435 = path.getOrDefault("resourceGroupName")
  valid_574435 = validateParameter(valid_574435, JString, required = true,
                                 default = nil)
  if valid_574435 != nil:
    section.add "resourceGroupName", valid_574435
  var valid_574436 = path.getOrDefault("subscriptionId")
  valid_574436 = validateParameter(valid_574436, JString, required = true,
                                 default = nil)
  if valid_574436 != nil:
    section.add "subscriptionId", valid_574436
  var valid_574437 = path.getOrDefault("workspaceName")
  valid_574437 = validateParameter(valid_574437, JString, required = true,
                                 default = nil)
  if valid_574437 != nil:
    section.add "workspaceName", valid_574437
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574438 = query.getOrDefault("api-version")
  valid_574438 = validateParameter(valid_574438, JString, required = true,
                                 default = nil)
  if valid_574438 != nil:
    section.add "api-version", valid_574438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574439: Call_WorkspacesListKeys_574432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ## 
  let valid = call_574439.validator(path, query, header, formData, body)
  let scheme = call_574439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574439.url(scheme.get, call_574439.host, call_574439.base,
                         call_574439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574439, url, valid)

proc call*(call_574440: Call_WorkspacesListKeys_574432; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesListKeys
  ## Lists all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_574441 = newJObject()
  var query_574442 = newJObject()
  add(path_574441, "resourceGroupName", newJString(resourceGroupName))
  add(query_574442, "api-version", newJString(apiVersion))
  add(path_574441, "subscriptionId", newJString(subscriptionId))
  add(path_574441, "workspaceName", newJString(workspaceName))
  result = call_574440.call(path_574441, query_574442, nil, nil, nil)

var workspacesListKeys* = Call_WorkspacesListKeys_574432(
    name: "workspacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/listKeys",
    validator: validate_WorkspacesListKeys_574433, base: "",
    url: url_WorkspacesListKeys_574434, schemes: {Scheme.Https})
type
  Call_WorkspacesResyncKeys_574443 = ref object of OpenApiRestCall_573668
proc url_WorkspacesResyncKeys_574445(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/resyncKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesResyncKeys_574444(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resync all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574446 = path.getOrDefault("resourceGroupName")
  valid_574446 = validateParameter(valid_574446, JString, required = true,
                                 default = nil)
  if valid_574446 != nil:
    section.add "resourceGroupName", valid_574446
  var valid_574447 = path.getOrDefault("subscriptionId")
  valid_574447 = validateParameter(valid_574447, JString, required = true,
                                 default = nil)
  if valid_574447 != nil:
    section.add "subscriptionId", valid_574447
  var valid_574448 = path.getOrDefault("workspaceName")
  valid_574448 = validateParameter(valid_574448, JString, required = true,
                                 default = nil)
  if valid_574448 != nil:
    section.add "workspaceName", valid_574448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574449 = query.getOrDefault("api-version")
  valid_574449 = validateParameter(valid_574449, JString, required = true,
                                 default = nil)
  if valid_574449 != nil:
    section.add "api-version", valid_574449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574450: Call_WorkspacesResyncKeys_574443; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resync all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ## 
  let valid = call_574450.validator(path, query, header, formData, body)
  let scheme = call_574450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574450.url(scheme.get, call_574450.host, call_574450.base,
                         call_574450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574450, url, valid)

proc call*(call_574451: Call_WorkspacesResyncKeys_574443;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string): Recallable =
  ## workspacesResyncKeys
  ## Resync all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_574452 = newJObject()
  var query_574453 = newJObject()
  add(path_574452, "resourceGroupName", newJString(resourceGroupName))
  add(query_574453, "api-version", newJString(apiVersion))
  add(path_574452, "subscriptionId", newJString(subscriptionId))
  add(path_574452, "workspaceName", newJString(workspaceName))
  result = call_574451.call(path_574452, query_574453, nil, nil, nil)

var workspacesResyncKeys* = Call_WorkspacesResyncKeys_574443(
    name: "workspacesResyncKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/resyncKeys",
    validator: validate_WorkspacesResyncKeys_574444, base: "",
    url: url_WorkspacesResyncKeys_574445, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
