
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Migrate
## version: 2018-02-02
## termsOfService: (not provided)
## license: (not provided)
## 
## Move your workloads to Azure.
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
  macServiceName = "migrate"
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
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_567988: Call_OperationsList_567881; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  ## 
  let valid = call_567988.validator(path, query, header, formData, body)
  let scheme = call_567988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_567988.url(scheme.get, call_567988.host, call_567988.base,
                         call_567988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_567988, url, valid)

proc call*(call_568072: Call_OperationsList_567881): Recallable =
  ## operationsList
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  result = call_568072.call(nil, nil, nil, nil, nil)

var operationsList* = Call_OperationsList_567881(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Migrate/operations",
    validator: validate_OperationsList_567882, base: "", url: url_OperationsList_567883,
    schemes: {Scheme.Https})
type
  Call_AssessmentOptionsGet_568110 = ref object of OpenApiRestCall_567659
proc url_AssessmentOptionsGet_568112(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/assessmentOptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentOptionsGet_568111(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the available options for the properties of an assessment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   locationName: JString (required)
  ##               : Azure region in which the project is created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568190 = path.getOrDefault("subscriptionId")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "subscriptionId", valid_568190
  var valid_568191 = path.getOrDefault("locationName")
  valid_568191 = validateParameter(valid_568191, JString, required = true,
                                 default = nil)
  if valid_568191 != nil:
    section.add "locationName", valid_568191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568205 = query.getOrDefault("api-version")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568205 != nil:
    section.add "api-version", valid_568205
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568206 = header.getOrDefault("Accept-Language")
  valid_568206 = validateParameter(valid_568206, JString, required = false,
                                 default = nil)
  if valid_568206 != nil:
    section.add "Accept-Language", valid_568206
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568207: Call_AssessmentOptionsGet_568110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the available options for the properties of an assessment.
  ## 
  let valid = call_568207.validator(path, query, header, formData, body)
  let scheme = call_568207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568207.url(scheme.get, call_568207.host, call_568207.base,
                         call_568207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568207, url, valid)

proc call*(call_568208: Call_AssessmentOptionsGet_568110; subscriptionId: string;
          locationName: string; apiVersion: string = "2018-02-02"): Recallable =
  ## assessmentOptionsGet
  ## Get the available options for the properties of an assessment.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   locationName: string (required)
  ##               : Azure region in which the project is created.
  var path_568209 = newJObject()
  var query_568211 = newJObject()
  add(query_568211, "api-version", newJString(apiVersion))
  add(path_568209, "subscriptionId", newJString(subscriptionId))
  add(path_568209, "locationName", newJString(locationName))
  result = call_568208.call(path_568209, query_568211, nil, nil, nil)

var assessmentOptionsGet* = Call_AssessmentOptionsGet_568110(
    name: "assessmentOptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Migrate/locations/{locationName}/assessmentOptions",
    validator: validate_AssessmentOptionsGet_568111, base: "",
    url: url_AssessmentOptionsGet_568112, schemes: {Scheme.Https})
type
  Call_LocationCheckNameAvailability_568213 = ref object of OpenApiRestCall_567659
proc url_LocationCheckNameAvailability_568215(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationCheckNameAvailability_568214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the project name is available in the specified region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   locationName: JString (required)
  ##               : The desired region for the name check.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568233 = path.getOrDefault("subscriptionId")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "subscriptionId", valid_568233
  var valid_568234 = path.getOrDefault("locationName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "locationName", valid_568234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568235 = query.getOrDefault("api-version")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568235 != nil:
    section.add "api-version", valid_568235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Properties needed to check the availability of a name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568237: Call_LocationCheckNameAvailability_568213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the project name is available in the specified region.
  ## 
  let valid = call_568237.validator(path, query, header, formData, body)
  let scheme = call_568237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568237.url(scheme.get, call_568237.host, call_568237.base,
                         call_568237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568237, url, valid)

proc call*(call_568238: Call_LocationCheckNameAvailability_568213;
          subscriptionId: string; parameters: JsonNode; locationName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## locationCheckNameAvailability
  ## Checks whether the project name is available in the specified region.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   parameters: JObject (required)
  ##             : Properties needed to check the availability of a name.
  ##   locationName: string (required)
  ##               : The desired region for the name check.
  var path_568239 = newJObject()
  var query_568240 = newJObject()
  var body_568241 = newJObject()
  add(query_568240, "api-version", newJString(apiVersion))
  add(path_568239, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568241 = parameters
  add(path_568239, "locationName", newJString(locationName))
  result = call_568238.call(path_568239, query_568240, nil, nil, body_568241)

var locationCheckNameAvailability* = Call_LocationCheckNameAvailability_568213(
    name: "locationCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Migrate/locations/{locationName}/checkNameAvailability",
    validator: validate_LocationCheckNameAvailability_568214, base: "",
    url: url_LocationCheckNameAvailability_568215, schemes: {Scheme.Https})
type
  Call_ProjectsListBySubscription_568242 = ref object of OpenApiRestCall_567659
proc url_ProjectsListBySubscription_568244(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsListBySubscription_568243(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the projects in the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568245 = path.getOrDefault("subscriptionId")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "subscriptionId", valid_568245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568246 = query.getOrDefault("api-version")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568246 != nil:
    section.add "api-version", valid_568246
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568247 = header.getOrDefault("Accept-Language")
  valid_568247 = validateParameter(valid_568247, JString, required = false,
                                 default = nil)
  if valid_568247 != nil:
    section.add "Accept-Language", valid_568247
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568248: Call_ProjectsListBySubscription_568242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the projects in the subscription.
  ## 
  let valid = call_568248.validator(path, query, header, formData, body)
  let scheme = call_568248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568248.url(scheme.get, call_568248.host, call_568248.base,
                         call_568248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568248, url, valid)

proc call*(call_568249: Call_ProjectsListBySubscription_568242;
          subscriptionId: string; apiVersion: string = "2018-02-02"): Recallable =
  ## projectsListBySubscription
  ## Get all the projects in the subscription.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  var path_568250 = newJObject()
  var query_568251 = newJObject()
  add(query_568251, "api-version", newJString(apiVersion))
  add(path_568250, "subscriptionId", newJString(subscriptionId))
  result = call_568249.call(path_568250, query_568251, nil, nil, nil)

var projectsListBySubscription* = Call_ProjectsListBySubscription_568242(
    name: "projectsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Migrate/projects",
    validator: validate_ProjectsListBySubscription_568243, base: "",
    url: url_ProjectsListBySubscription_568244, schemes: {Scheme.Https})
type
  Call_AssessmentsListByProject_568252 = ref object of OpenApiRestCall_567659
proc url_AssessmentsListByProject_568254(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/assessments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsListByProject_568253(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all assessments created in the project.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568255 = path.getOrDefault("resourceGroupName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "resourceGroupName", valid_568255
  var valid_568256 = path.getOrDefault("subscriptionId")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "subscriptionId", valid_568256
  var valid_568257 = path.getOrDefault("projectName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "projectName", valid_568257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568258 = query.getOrDefault("api-version")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568258 != nil:
    section.add "api-version", valid_568258
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568259 = header.getOrDefault("Accept-Language")
  valid_568259 = validateParameter(valid_568259, JString, required = false,
                                 default = nil)
  if valid_568259 != nil:
    section.add "Accept-Language", valid_568259
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568260: Call_AssessmentsListByProject_568252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all assessments created in the project.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  let valid = call_568260.validator(path, query, header, formData, body)
  let scheme = call_568260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568260.url(scheme.get, call_568260.host, call_568260.base,
                         call_568260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568260, url, valid)

proc call*(call_568261: Call_AssessmentsListByProject_568252;
          resourceGroupName: string; subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## assessmentsListByProject
  ## Get all assessments created in the project.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568262 = newJObject()
  var query_568263 = newJObject()
  add(path_568262, "resourceGroupName", newJString(resourceGroupName))
  add(query_568263, "api-version", newJString(apiVersion))
  add(path_568262, "subscriptionId", newJString(subscriptionId))
  add(path_568262, "projectName", newJString(projectName))
  result = call_568261.call(path_568262, query_568263, nil, nil, nil)

var assessmentsListByProject* = Call_AssessmentsListByProject_568252(
    name: "assessmentsListByProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/assessments",
    validator: validate_AssessmentsListByProject_568253, base: "",
    url: url_AssessmentsListByProject_568254, schemes: {Scheme.Https})
type
  Call_GroupsListByProject_568264 = ref object of OpenApiRestCall_567659
proc url_GroupsListByProject_568266(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsListByProject_568265(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get all groups created in the project. Returns a json array of objects of type 'group' as specified in the Models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568267 = path.getOrDefault("resourceGroupName")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "resourceGroupName", valid_568267
  var valid_568268 = path.getOrDefault("subscriptionId")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "subscriptionId", valid_568268
  var valid_568269 = path.getOrDefault("projectName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "projectName", valid_568269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568270 = query.getOrDefault("api-version")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568270 != nil:
    section.add "api-version", valid_568270
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568271 = header.getOrDefault("Accept-Language")
  valid_568271 = validateParameter(valid_568271, JString, required = false,
                                 default = nil)
  if valid_568271 != nil:
    section.add "Accept-Language", valid_568271
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568272: Call_GroupsListByProject_568264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all groups created in the project. Returns a json array of objects of type 'group' as specified in the Models section.
  ## 
  let valid = call_568272.validator(path, query, header, formData, body)
  let scheme = call_568272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568272.url(scheme.get, call_568272.host, call_568272.base,
                         call_568272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568272, url, valid)

proc call*(call_568273: Call_GroupsListByProject_568264; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## groupsListByProject
  ## Get all groups created in the project. Returns a json array of objects of type 'group' as specified in the Models section.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568274 = newJObject()
  var query_568275 = newJObject()
  add(path_568274, "resourceGroupName", newJString(resourceGroupName))
  add(query_568275, "api-version", newJString(apiVersion))
  add(path_568274, "subscriptionId", newJString(subscriptionId))
  add(path_568274, "projectName", newJString(projectName))
  result = call_568273.call(path_568274, query_568275, nil, nil, nil)

var groupsListByProject* = Call_GroupsListByProject_568264(
    name: "groupsListByProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups",
    validator: validate_GroupsListByProject_568265, base: "",
    url: url_GroupsListByProject_568266, schemes: {Scheme.Https})
type
  Call_GroupsCreate_568289 = ref object of OpenApiRestCall_567659
proc url_GroupsCreate_568291(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsCreate_568290(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new group by sending a json object of type 'group' as given in Models section as part of the Request Body. The group name in a project is unique. Labels can be applied on a group as part of creation.
  ## 
  ## If a group with the groupName specified in the URL already exists, then this call acts as an update.
  ## 
  ## This operation is Idempotent.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568292 = path.getOrDefault("resourceGroupName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "resourceGroupName", valid_568292
  var valid_568293 = path.getOrDefault("subscriptionId")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "subscriptionId", valid_568293
  var valid_568294 = path.getOrDefault("groupName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "groupName", valid_568294
  var valid_568295 = path.getOrDefault("projectName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "projectName", valid_568295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568296 = query.getOrDefault("api-version")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568296 != nil:
    section.add "api-version", valid_568296
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568297 = header.getOrDefault("Accept-Language")
  valid_568297 = validateParameter(valid_568297, JString, required = false,
                                 default = nil)
  if valid_568297 != nil:
    section.add "Accept-Language", valid_568297
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   group: JObject
  ##        : New or Updated Group object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568299: Call_GroupsCreate_568289; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new group by sending a json object of type 'group' as given in Models section as part of the Request Body. The group name in a project is unique. Labels can be applied on a group as part of creation.
  ## 
  ## If a group with the groupName specified in the URL already exists, then this call acts as an update.
  ## 
  ## This operation is Idempotent.
  ## 
  ## 
  let valid = call_568299.validator(path, query, header, formData, body)
  let scheme = call_568299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568299.url(scheme.get, call_568299.host, call_568299.base,
                         call_568299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568299, url, valid)

proc call*(call_568300: Call_GroupsCreate_568289; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          apiVersion: string = "2018-02-02"; group: JsonNode = nil): Recallable =
  ## groupsCreate
  ## Create a new group by sending a json object of type 'group' as given in Models section as part of the Request Body. The group name in a project is unique. Labels can be applied on a group as part of creation.
  ## 
  ## If a group with the groupName specified in the URL already exists, then this call acts as an update.
  ## 
  ## This operation is Idempotent.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   group: JObject
  ##        : New or Updated Group object.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568301 = newJObject()
  var query_568302 = newJObject()
  var body_568303 = newJObject()
  add(path_568301, "resourceGroupName", newJString(resourceGroupName))
  add(query_568302, "api-version", newJString(apiVersion))
  if group != nil:
    body_568303 = group
  add(path_568301, "subscriptionId", newJString(subscriptionId))
  add(path_568301, "groupName", newJString(groupName))
  add(path_568301, "projectName", newJString(projectName))
  result = call_568300.call(path_568301, query_568302, nil, nil, body_568303)

var groupsCreate* = Call_GroupsCreate_568289(name: "groupsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}",
    validator: validate_GroupsCreate_568290, base: "", url: url_GroupsCreate_568291,
    schemes: {Scheme.Https})
type
  Call_GroupsGet_568276 = ref object of OpenApiRestCall_567659
proc url_GroupsGet_568278(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsGet_568277(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information related to a specific group in the project. Returns a json object of type 'group' as specified in the models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568279 = path.getOrDefault("resourceGroupName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "resourceGroupName", valid_568279
  var valid_568280 = path.getOrDefault("subscriptionId")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "subscriptionId", valid_568280
  var valid_568281 = path.getOrDefault("groupName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "groupName", valid_568281
  var valid_568282 = path.getOrDefault("projectName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "projectName", valid_568282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568283 = query.getOrDefault("api-version")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568283 != nil:
    section.add "api-version", valid_568283
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568284 = header.getOrDefault("Accept-Language")
  valid_568284 = validateParameter(valid_568284, JString, required = false,
                                 default = nil)
  if valid_568284 != nil:
    section.add "Accept-Language", valid_568284
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568285: Call_GroupsGet_568276; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific group in the project. Returns a json object of type 'group' as specified in the models section.
  ## 
  let valid = call_568285.validator(path, query, header, formData, body)
  let scheme = call_568285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568285.url(scheme.get, call_568285.host, call_568285.base,
                         call_568285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568285, url, valid)

proc call*(call_568286: Call_GroupsGet_568276; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## groupsGet
  ## Get information related to a specific group in the project. Returns a json object of type 'group' as specified in the models section.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568287 = newJObject()
  var query_568288 = newJObject()
  add(path_568287, "resourceGroupName", newJString(resourceGroupName))
  add(query_568288, "api-version", newJString(apiVersion))
  add(path_568287, "subscriptionId", newJString(subscriptionId))
  add(path_568287, "groupName", newJString(groupName))
  add(path_568287, "projectName", newJString(projectName))
  result = call_568286.call(path_568287, query_568288, nil, nil, nil)

var groupsGet* = Call_GroupsGet_568276(name: "groupsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}",
                                    validator: validate_GroupsGet_568277,
                                    base: "", url: url_GroupsGet_568278,
                                    schemes: {Scheme.Https})
type
  Call_GroupsDelete_568304 = ref object of OpenApiRestCall_567659
proc url_GroupsDelete_568306(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsDelete_568305(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the group from the project. The machines remain in the project. Deleting a non-existent group results in a no-operation.
  ## 
  ## A group is an aggregation mechanism for machines in a project. Therefore, deleting group does not delete machines in it.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568307 = path.getOrDefault("resourceGroupName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "resourceGroupName", valid_568307
  var valid_568308 = path.getOrDefault("subscriptionId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "subscriptionId", valid_568308
  var valid_568309 = path.getOrDefault("groupName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "groupName", valid_568309
  var valid_568310 = path.getOrDefault("projectName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "projectName", valid_568310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568311 = query.getOrDefault("api-version")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568311 != nil:
    section.add "api-version", valid_568311
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568312 = header.getOrDefault("Accept-Language")
  valid_568312 = validateParameter(valid_568312, JString, required = false,
                                 default = nil)
  if valid_568312 != nil:
    section.add "Accept-Language", valid_568312
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568313: Call_GroupsDelete_568304; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the group from the project. The machines remain in the project. Deleting a non-existent group results in a no-operation.
  ## 
  ## A group is an aggregation mechanism for machines in a project. Therefore, deleting group does not delete machines in it.
  ## 
  ## 
  let valid = call_568313.validator(path, query, header, formData, body)
  let scheme = call_568313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568313.url(scheme.get, call_568313.host, call_568313.base,
                         call_568313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568313, url, valid)

proc call*(call_568314: Call_GroupsDelete_568304; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## groupsDelete
  ## Delete the group from the project. The machines remain in the project. Deleting a non-existent group results in a no-operation.
  ## 
  ## A group is an aggregation mechanism for machines in a project. Therefore, deleting group does not delete machines in it.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568315 = newJObject()
  var query_568316 = newJObject()
  add(path_568315, "resourceGroupName", newJString(resourceGroupName))
  add(query_568316, "api-version", newJString(apiVersion))
  add(path_568315, "subscriptionId", newJString(subscriptionId))
  add(path_568315, "groupName", newJString(groupName))
  add(path_568315, "projectName", newJString(projectName))
  result = call_568314.call(path_568315, query_568316, nil, nil, nil)

var groupsDelete* = Call_GroupsDelete_568304(name: "groupsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}",
    validator: validate_GroupsDelete_568305, base: "", url: url_GroupsDelete_568306,
    schemes: {Scheme.Https})
type
  Call_AssessmentsListByGroup_568317 = ref object of OpenApiRestCall_567659
proc url_AssessmentsListByGroup_568319(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsListByGroup_568318(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all assessments created for the specified group.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568320 = path.getOrDefault("resourceGroupName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "resourceGroupName", valid_568320
  var valid_568321 = path.getOrDefault("subscriptionId")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "subscriptionId", valid_568321
  var valid_568322 = path.getOrDefault("groupName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "groupName", valid_568322
  var valid_568323 = path.getOrDefault("projectName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "projectName", valid_568323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568324 = query.getOrDefault("api-version")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568324 != nil:
    section.add "api-version", valid_568324
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568325 = header.getOrDefault("Accept-Language")
  valid_568325 = validateParameter(valid_568325, JString, required = false,
                                 default = nil)
  if valid_568325 != nil:
    section.add "Accept-Language", valid_568325
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568326: Call_AssessmentsListByGroup_568317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all assessments created for the specified group.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  let valid = call_568326.validator(path, query, header, formData, body)
  let scheme = call_568326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568326.url(scheme.get, call_568326.host, call_568326.base,
                         call_568326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568326, url, valid)

proc call*(call_568327: Call_AssessmentsListByGroup_568317;
          resourceGroupName: string; subscriptionId: string; groupName: string;
          projectName: string; apiVersion: string = "2018-02-02"): Recallable =
  ## assessmentsListByGroup
  ## Get all assessments created for the specified group.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568328 = newJObject()
  var query_568329 = newJObject()
  add(path_568328, "resourceGroupName", newJString(resourceGroupName))
  add(query_568329, "api-version", newJString(apiVersion))
  add(path_568328, "subscriptionId", newJString(subscriptionId))
  add(path_568328, "groupName", newJString(groupName))
  add(path_568328, "projectName", newJString(projectName))
  result = call_568327.call(path_568328, query_568329, nil, nil, nil)

var assessmentsListByGroup* = Call_AssessmentsListByGroup_568317(
    name: "assessmentsListByGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments",
    validator: validate_AssessmentsListByGroup_568318, base: "",
    url: url_AssessmentsListByGroup_568319, schemes: {Scheme.Https})
type
  Call_AssessmentsCreate_568344 = ref object of OpenApiRestCall_567659
proc url_AssessmentsCreate_568346(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsCreate_568345(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Create a new assessment with the given name and the specified settings. Since name of an assessment in a project is a unique identifier, if an assessment with the name provided already exists, then the existing assessment is updated.
  ## 
  ## Any PUT operation, resulting in either create or update on an assessment, will cause the assessment to go in a "InProgress" state. This will be indicated by the field 'computationState' on the Assessment object. During this time no other PUT operation will be allowed on that assessment object, nor will a Delete operation. Once the computation for the assessment is complete, the field 'computationState' will be updated to 'Ready', and then other PUT or DELETE operations can happen on the assessment.
  ## 
  ## When assessment is under computation, any PUT will lead to a 400 - Bad Request error.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568347 = path.getOrDefault("resourceGroupName")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "resourceGroupName", valid_568347
  var valid_568348 = path.getOrDefault("subscriptionId")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "subscriptionId", valid_568348
  var valid_568349 = path.getOrDefault("groupName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "groupName", valid_568349
  var valid_568350 = path.getOrDefault("projectName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "projectName", valid_568350
  var valid_568351 = path.getOrDefault("assessmentName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "assessmentName", valid_568351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568352 = query.getOrDefault("api-version")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568352 != nil:
    section.add "api-version", valid_568352
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568353 = header.getOrDefault("Accept-Language")
  valid_568353 = validateParameter(valid_568353, JString, required = false,
                                 default = nil)
  if valid_568353 != nil:
    section.add "Accept-Language", valid_568353
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   assessment: JObject
  ##             : New or Updated Assessment object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568355: Call_AssessmentsCreate_568344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new assessment with the given name and the specified settings. Since name of an assessment in a project is a unique identifier, if an assessment with the name provided already exists, then the existing assessment is updated.
  ## 
  ## Any PUT operation, resulting in either create or update on an assessment, will cause the assessment to go in a "InProgress" state. This will be indicated by the field 'computationState' on the Assessment object. During this time no other PUT operation will be allowed on that assessment object, nor will a Delete operation. Once the computation for the assessment is complete, the field 'computationState' will be updated to 'Ready', and then other PUT or DELETE operations can happen on the assessment.
  ## 
  ## When assessment is under computation, any PUT will lead to a 400 - Bad Request error.
  ## 
  ## 
  let valid = call_568355.validator(path, query, header, formData, body)
  let scheme = call_568355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568355.url(scheme.get, call_568355.host, call_568355.base,
                         call_568355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568355, url, valid)

proc call*(call_568356: Call_AssessmentsCreate_568344; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          assessmentName: string; apiVersion: string = "2018-02-02";
          assessment: JsonNode = nil): Recallable =
  ## assessmentsCreate
  ## Create a new assessment with the given name and the specified settings. Since name of an assessment in a project is a unique identifier, if an assessment with the name provided already exists, then the existing assessment is updated.
  ## 
  ## Any PUT operation, resulting in either create or update on an assessment, will cause the assessment to go in a "InProgress" state. This will be indicated by the field 'computationState' on the Assessment object. During this time no other PUT operation will be allowed on that assessment object, nor will a Delete operation. Once the computation for the assessment is complete, the field 'computationState' will be updated to 'Ready', and then other PUT or DELETE operations can happen on the assessment.
  ## 
  ## When assessment is under computation, any PUT will lead to a 400 - Bad Request error.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   assessment: JObject
  ##             : New or Updated Assessment object.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_568357 = newJObject()
  var query_568358 = newJObject()
  var body_568359 = newJObject()
  add(path_568357, "resourceGroupName", newJString(resourceGroupName))
  add(query_568358, "api-version", newJString(apiVersion))
  if assessment != nil:
    body_568359 = assessment
  add(path_568357, "subscriptionId", newJString(subscriptionId))
  add(path_568357, "groupName", newJString(groupName))
  add(path_568357, "projectName", newJString(projectName))
  add(path_568357, "assessmentName", newJString(assessmentName))
  result = call_568356.call(path_568357, query_568358, nil, nil, body_568359)

var assessmentsCreate* = Call_AssessmentsCreate_568344(name: "assessmentsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}",
    validator: validate_AssessmentsCreate_568345, base: "",
    url: url_AssessmentsCreate_568346, schemes: {Scheme.Https})
type
  Call_AssessmentsGet_568330 = ref object of OpenApiRestCall_567659
proc url_AssessmentsGet_568332(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsGet_568331(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get an existing assessment with the specified name. Returns a json object of type 'assessment' as specified in Models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568333 = path.getOrDefault("resourceGroupName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "resourceGroupName", valid_568333
  var valid_568334 = path.getOrDefault("subscriptionId")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "subscriptionId", valid_568334
  var valid_568335 = path.getOrDefault("groupName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "groupName", valid_568335
  var valid_568336 = path.getOrDefault("projectName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "projectName", valid_568336
  var valid_568337 = path.getOrDefault("assessmentName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "assessmentName", valid_568337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568338 = query.getOrDefault("api-version")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568338 != nil:
    section.add "api-version", valid_568338
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568339 = header.getOrDefault("Accept-Language")
  valid_568339 = validateParameter(valid_568339, JString, required = false,
                                 default = nil)
  if valid_568339 != nil:
    section.add "Accept-Language", valid_568339
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568340: Call_AssessmentsGet_568330; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an existing assessment with the specified name. Returns a json object of type 'assessment' as specified in Models section.
  ## 
  let valid = call_568340.validator(path, query, header, formData, body)
  let scheme = call_568340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568340.url(scheme.get, call_568340.host, call_568340.base,
                         call_568340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568340, url, valid)

proc call*(call_568341: Call_AssessmentsGet_568330; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          assessmentName: string; apiVersion: string = "2018-02-02"): Recallable =
  ## assessmentsGet
  ## Get an existing assessment with the specified name. Returns a json object of type 'assessment' as specified in Models section.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_568342 = newJObject()
  var query_568343 = newJObject()
  add(path_568342, "resourceGroupName", newJString(resourceGroupName))
  add(query_568343, "api-version", newJString(apiVersion))
  add(path_568342, "subscriptionId", newJString(subscriptionId))
  add(path_568342, "groupName", newJString(groupName))
  add(path_568342, "projectName", newJString(projectName))
  add(path_568342, "assessmentName", newJString(assessmentName))
  result = call_568341.call(path_568342, query_568343, nil, nil, nil)

var assessmentsGet* = Call_AssessmentsGet_568330(name: "assessmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}",
    validator: validate_AssessmentsGet_568331, base: "", url: url_AssessmentsGet_568332,
    schemes: {Scheme.Https})
type
  Call_AssessmentsDelete_568360 = ref object of OpenApiRestCall_567659
proc url_AssessmentsDelete_568362(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsDelete_568361(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete an assessment from the project. The machines remain in the assessment. Deleting a non-existent assessment results in a no-operation.
  ## 
  ## When an assessment is under computation, as indicated by the 'computationState' field, it cannot be deleted. Any such attempt will return a 400 - Bad Request.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568363 = path.getOrDefault("resourceGroupName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "resourceGroupName", valid_568363
  var valid_568364 = path.getOrDefault("subscriptionId")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "subscriptionId", valid_568364
  var valid_568365 = path.getOrDefault("groupName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "groupName", valid_568365
  var valid_568366 = path.getOrDefault("projectName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "projectName", valid_568366
  var valid_568367 = path.getOrDefault("assessmentName")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "assessmentName", valid_568367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568368 = query.getOrDefault("api-version")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568368 != nil:
    section.add "api-version", valid_568368
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568369 = header.getOrDefault("Accept-Language")
  valid_568369 = validateParameter(valid_568369, JString, required = false,
                                 default = nil)
  if valid_568369 != nil:
    section.add "Accept-Language", valid_568369
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568370: Call_AssessmentsDelete_568360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an assessment from the project. The machines remain in the assessment. Deleting a non-existent assessment results in a no-operation.
  ## 
  ## When an assessment is under computation, as indicated by the 'computationState' field, it cannot be deleted. Any such attempt will return a 400 - Bad Request.
  ## 
  ## 
  let valid = call_568370.validator(path, query, header, formData, body)
  let scheme = call_568370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568370.url(scheme.get, call_568370.host, call_568370.base,
                         call_568370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568370, url, valid)

proc call*(call_568371: Call_AssessmentsDelete_568360; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          assessmentName: string; apiVersion: string = "2018-02-02"): Recallable =
  ## assessmentsDelete
  ## Delete an assessment from the project. The machines remain in the assessment. Deleting a non-existent assessment results in a no-operation.
  ## 
  ## When an assessment is under computation, as indicated by the 'computationState' field, it cannot be deleted. Any such attempt will return a 400 - Bad Request.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_568372 = newJObject()
  var query_568373 = newJObject()
  add(path_568372, "resourceGroupName", newJString(resourceGroupName))
  add(query_568373, "api-version", newJString(apiVersion))
  add(path_568372, "subscriptionId", newJString(subscriptionId))
  add(path_568372, "groupName", newJString(groupName))
  add(path_568372, "projectName", newJString(projectName))
  add(path_568372, "assessmentName", newJString(assessmentName))
  result = call_568371.call(path_568372, query_568373, nil, nil, nil)

var assessmentsDelete* = Call_AssessmentsDelete_568360(name: "assessmentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}",
    validator: validate_AssessmentsDelete_568361, base: "",
    url: url_AssessmentsDelete_568362, schemes: {Scheme.Https})
type
  Call_AssessedMachinesListByAssessment_568374 = ref object of OpenApiRestCall_567659
proc url_AssessedMachinesListByAssessment_568376(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName"),
               (kind: ConstantSegment, value: "/assessedMachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessedMachinesListByAssessment_568375(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get list of machines that assessed as part of the specified assessment. Returns a json array of objects of type 'assessedMachine' as specified in the Models section.
  ## 
  ## Whenever an assessment is created or updated, it goes under computation. During this phase, the 'status' field of Assessment object reports 'Computing'.
  ## During the period when the assessment is under computation, the list of assessed machines is empty and no assessed machines are returned by this call.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568377 = path.getOrDefault("resourceGroupName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "resourceGroupName", valid_568377
  var valid_568378 = path.getOrDefault("subscriptionId")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "subscriptionId", valid_568378
  var valid_568379 = path.getOrDefault("groupName")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "groupName", valid_568379
  var valid_568380 = path.getOrDefault("projectName")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "projectName", valid_568380
  var valid_568381 = path.getOrDefault("assessmentName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "assessmentName", valid_568381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568382 = query.getOrDefault("api-version")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568382 != nil:
    section.add "api-version", valid_568382
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568383 = header.getOrDefault("Accept-Language")
  valid_568383 = validateParameter(valid_568383, JString, required = false,
                                 default = nil)
  if valid_568383 != nil:
    section.add "Accept-Language", valid_568383
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568384: Call_AssessedMachinesListByAssessment_568374;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get list of machines that assessed as part of the specified assessment. Returns a json array of objects of type 'assessedMachine' as specified in the Models section.
  ## 
  ## Whenever an assessment is created or updated, it goes under computation. During this phase, the 'status' field of Assessment object reports 'Computing'.
  ## During the period when the assessment is under computation, the list of assessed machines is empty and no assessed machines are returned by this call.
  ## 
  ## 
  let valid = call_568384.validator(path, query, header, formData, body)
  let scheme = call_568384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568384.url(scheme.get, call_568384.host, call_568384.base,
                         call_568384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568384, url, valid)

proc call*(call_568385: Call_AssessedMachinesListByAssessment_568374;
          resourceGroupName: string; subscriptionId: string; groupName: string;
          projectName: string; assessmentName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## assessedMachinesListByAssessment
  ## Get list of machines that assessed as part of the specified assessment. Returns a json array of objects of type 'assessedMachine' as specified in the Models section.
  ## 
  ## Whenever an assessment is created or updated, it goes under computation. During this phase, the 'status' field of Assessment object reports 'Computing'.
  ## During the period when the assessment is under computation, the list of assessed machines is empty and no assessed machines are returned by this call.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_568386 = newJObject()
  var query_568387 = newJObject()
  add(path_568386, "resourceGroupName", newJString(resourceGroupName))
  add(query_568387, "api-version", newJString(apiVersion))
  add(path_568386, "subscriptionId", newJString(subscriptionId))
  add(path_568386, "groupName", newJString(groupName))
  add(path_568386, "projectName", newJString(projectName))
  add(path_568386, "assessmentName", newJString(assessmentName))
  result = call_568385.call(path_568386, query_568387, nil, nil, nil)

var assessedMachinesListByAssessment* = Call_AssessedMachinesListByAssessment_568374(
    name: "assessedMachinesListByAssessment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}/assessedMachines",
    validator: validate_AssessedMachinesListByAssessment_568375, base: "",
    url: url_AssessedMachinesListByAssessment_568376, schemes: {Scheme.Https})
type
  Call_AssessedMachinesGet_568388 = ref object of OpenApiRestCall_567659
proc url_AssessedMachinesGet_568390(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  assert "assessedMachineName" in path,
        "`assessedMachineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName"),
               (kind: ConstantSegment, value: "/assessedMachines/"),
               (kind: VariableSegment, value: "assessedMachineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessedMachinesGet_568389(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get an assessed machine with its size & cost estimate that was evaluated in the specified assessment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   assessedMachineName: JString (required)
  ##                      : Unique name of an assessed machine evaluated as part of an assessment.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568391 = path.getOrDefault("resourceGroupName")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "resourceGroupName", valid_568391
  var valid_568392 = path.getOrDefault("assessedMachineName")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "assessedMachineName", valid_568392
  var valid_568393 = path.getOrDefault("subscriptionId")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "subscriptionId", valid_568393
  var valid_568394 = path.getOrDefault("groupName")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "groupName", valid_568394
  var valid_568395 = path.getOrDefault("projectName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "projectName", valid_568395
  var valid_568396 = path.getOrDefault("assessmentName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "assessmentName", valid_568396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568397 = query.getOrDefault("api-version")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568397 != nil:
    section.add "api-version", valid_568397
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568398 = header.getOrDefault("Accept-Language")
  valid_568398 = validateParameter(valid_568398, JString, required = false,
                                 default = nil)
  if valid_568398 != nil:
    section.add "Accept-Language", valid_568398
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568399: Call_AssessedMachinesGet_568388; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an assessed machine with its size & cost estimate that was evaluated in the specified assessment.
  ## 
  let valid = call_568399.validator(path, query, header, formData, body)
  let scheme = call_568399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568399.url(scheme.get, call_568399.host, call_568399.base,
                         call_568399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568399, url, valid)

proc call*(call_568400: Call_AssessedMachinesGet_568388; resourceGroupName: string;
          assessedMachineName: string; subscriptionId: string; groupName: string;
          projectName: string; assessmentName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## assessedMachinesGet
  ## Get an assessed machine with its size & cost estimate that was evaluated in the specified assessment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   assessedMachineName: string (required)
  ##                      : Unique name of an assessed machine evaluated as part of an assessment.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_568401 = newJObject()
  var query_568402 = newJObject()
  add(path_568401, "resourceGroupName", newJString(resourceGroupName))
  add(query_568402, "api-version", newJString(apiVersion))
  add(path_568401, "assessedMachineName", newJString(assessedMachineName))
  add(path_568401, "subscriptionId", newJString(subscriptionId))
  add(path_568401, "groupName", newJString(groupName))
  add(path_568401, "projectName", newJString(projectName))
  add(path_568401, "assessmentName", newJString(assessmentName))
  result = call_568400.call(path_568401, query_568402, nil, nil, nil)

var assessedMachinesGet* = Call_AssessedMachinesGet_568388(
    name: "assessedMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}/assessedMachines/{assessedMachineName}",
    validator: validate_AssessedMachinesGet_568389, base: "",
    url: url_AssessedMachinesGet_568390, schemes: {Scheme.Https})
type
  Call_AssessmentsGetReportDownloadUrl_568403 = ref object of OpenApiRestCall_567659
proc url_AssessmentsGetReportDownloadUrl_568405(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName"),
               (kind: ConstantSegment, value: "/downloadUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsGetReportDownloadUrl_568404(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the URL for downloading the assessment in a report format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568406 = path.getOrDefault("resourceGroupName")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "resourceGroupName", valid_568406
  var valid_568407 = path.getOrDefault("subscriptionId")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "subscriptionId", valid_568407
  var valid_568408 = path.getOrDefault("groupName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "groupName", valid_568408
  var valid_568409 = path.getOrDefault("projectName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "projectName", valid_568409
  var valid_568410 = path.getOrDefault("assessmentName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "assessmentName", valid_568410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568411 = query.getOrDefault("api-version")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568411 != nil:
    section.add "api-version", valid_568411
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568412 = header.getOrDefault("Accept-Language")
  valid_568412 = validateParameter(valid_568412, JString, required = false,
                                 default = nil)
  if valid_568412 != nil:
    section.add "Accept-Language", valid_568412
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568413: Call_AssessmentsGetReportDownloadUrl_568403;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the URL for downloading the assessment in a report format.
  ## 
  let valid = call_568413.validator(path, query, header, formData, body)
  let scheme = call_568413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568413.url(scheme.get, call_568413.host, call_568413.base,
                         call_568413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568413, url, valid)

proc call*(call_568414: Call_AssessmentsGetReportDownloadUrl_568403;
          resourceGroupName: string; subscriptionId: string; groupName: string;
          projectName: string; assessmentName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## assessmentsGetReportDownloadUrl
  ## Get the URL for downloading the assessment in a report format.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_568415 = newJObject()
  var query_568416 = newJObject()
  add(path_568415, "resourceGroupName", newJString(resourceGroupName))
  add(query_568416, "api-version", newJString(apiVersion))
  add(path_568415, "subscriptionId", newJString(subscriptionId))
  add(path_568415, "groupName", newJString(groupName))
  add(path_568415, "projectName", newJString(projectName))
  add(path_568415, "assessmentName", newJString(assessmentName))
  result = call_568414.call(path_568415, query_568416, nil, nil, nil)

var assessmentsGetReportDownloadUrl* = Call_AssessmentsGetReportDownloadUrl_568403(
    name: "assessmentsGetReportDownloadUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}/downloadUrl",
    validator: validate_AssessmentsGetReportDownloadUrl_568404, base: "",
    url: url_AssessmentsGetReportDownloadUrl_568405, schemes: {Scheme.Https})
type
  Call_MachinesListByProject_568417 = ref object of OpenApiRestCall_567659
proc url_MachinesListByProject_568419(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/machines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesListByProject_568418(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get data of all the machines available in the project. Returns a json array of objects of type 'machine' defined in Models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568420 = path.getOrDefault("resourceGroupName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "resourceGroupName", valid_568420
  var valid_568421 = path.getOrDefault("subscriptionId")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "subscriptionId", valid_568421
  var valid_568422 = path.getOrDefault("projectName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "projectName", valid_568422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568423 = query.getOrDefault("api-version")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568423 != nil:
    section.add "api-version", valid_568423
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568424 = header.getOrDefault("Accept-Language")
  valid_568424 = validateParameter(valid_568424, JString, required = false,
                                 default = nil)
  if valid_568424 != nil:
    section.add "Accept-Language", valid_568424
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568425: Call_MachinesListByProject_568417; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get data of all the machines available in the project. Returns a json array of objects of type 'machine' defined in Models section.
  ## 
  let valid = call_568425.validator(path, query, header, formData, body)
  let scheme = call_568425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568425.url(scheme.get, call_568425.host, call_568425.base,
                         call_568425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568425, url, valid)

proc call*(call_568426: Call_MachinesListByProject_568417;
          resourceGroupName: string; subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## machinesListByProject
  ## Get data of all the machines available in the project. Returns a json array of objects of type 'machine' defined in Models section.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568427 = newJObject()
  var query_568428 = newJObject()
  add(path_568427, "resourceGroupName", newJString(resourceGroupName))
  add(query_568428, "api-version", newJString(apiVersion))
  add(path_568427, "subscriptionId", newJString(subscriptionId))
  add(path_568427, "projectName", newJString(projectName))
  result = call_568426.call(path_568427, query_568428, nil, nil, nil)

var machinesListByProject* = Call_MachinesListByProject_568417(
    name: "machinesListByProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/machines",
    validator: validate_MachinesListByProject_568418, base: "",
    url: url_MachinesListByProject_568419, schemes: {Scheme.Https})
type
  Call_MachinesGet_568429 = ref object of OpenApiRestCall_567659
proc url_MachinesGet_568431(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/machines/"),
               (kind: VariableSegment, value: "machineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesGet_568430(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the machine with the specified name. Returns a json object of type 'machine' defined in Models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   machineName: JString (required)
  ##              : Unique name of a machine in private datacenter.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568432 = path.getOrDefault("resourceGroupName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "resourceGroupName", valid_568432
  var valid_568433 = path.getOrDefault("machineName")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "machineName", valid_568433
  var valid_568434 = path.getOrDefault("subscriptionId")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "subscriptionId", valid_568434
  var valid_568435 = path.getOrDefault("projectName")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "projectName", valid_568435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568436 = query.getOrDefault("api-version")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568436 != nil:
    section.add "api-version", valid_568436
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568437 = header.getOrDefault("Accept-Language")
  valid_568437 = validateParameter(valid_568437, JString, required = false,
                                 default = nil)
  if valid_568437 != nil:
    section.add "Accept-Language", valid_568437
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568438: Call_MachinesGet_568429; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the machine with the specified name. Returns a json object of type 'machine' defined in Models section.
  ## 
  let valid = call_568438.validator(path, query, header, formData, body)
  let scheme = call_568438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568438.url(scheme.get, call_568438.host, call_568438.base,
                         call_568438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568438, url, valid)

proc call*(call_568439: Call_MachinesGet_568429; resourceGroupName: string;
          machineName: string; subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## machinesGet
  ## Get the machine with the specified name. Returns a json object of type 'machine' defined in Models section.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   machineName: string (required)
  ##              : Unique name of a machine in private datacenter.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568440 = newJObject()
  var query_568441 = newJObject()
  add(path_568440, "resourceGroupName", newJString(resourceGroupName))
  add(query_568441, "api-version", newJString(apiVersion))
  add(path_568440, "machineName", newJString(machineName))
  add(path_568440, "subscriptionId", newJString(subscriptionId))
  add(path_568440, "projectName", newJString(projectName))
  result = call_568439.call(path_568440, query_568441, nil, nil, nil)

var machinesGet* = Call_MachinesGet_568429(name: "machinesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/machines/{machineName}",
                                        validator: validate_MachinesGet_568430,
                                        base: "", url: url_MachinesGet_568431,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsListByResourceGroup_568442 = ref object of OpenApiRestCall_567659
proc url_ProjectsListByResourceGroup_568444(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsListByResourceGroup_568443(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the projects in the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568445 = path.getOrDefault("resourceGroupName")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "resourceGroupName", valid_568445
  var valid_568446 = path.getOrDefault("subscriptionId")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "subscriptionId", valid_568446
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568447 = query.getOrDefault("api-version")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568447 != nil:
    section.add "api-version", valid_568447
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568448 = header.getOrDefault("Accept-Language")
  valid_568448 = validateParameter(valid_568448, JString, required = false,
                                 default = nil)
  if valid_568448 != nil:
    section.add "Accept-Language", valid_568448
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568449: Call_ProjectsListByResourceGroup_568442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the projects in the resource group.
  ## 
  let valid = call_568449.validator(path, query, header, formData, body)
  let scheme = call_568449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568449.url(scheme.get, call_568449.host, call_568449.base,
                         call_568449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568449, url, valid)

proc call*(call_568450: Call_ProjectsListByResourceGroup_568442;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## projectsListByResourceGroup
  ## Get all the projects in the resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  var path_568451 = newJObject()
  var query_568452 = newJObject()
  add(path_568451, "resourceGroupName", newJString(resourceGroupName))
  add(query_568452, "api-version", newJString(apiVersion))
  add(path_568451, "subscriptionId", newJString(subscriptionId))
  result = call_568450.call(path_568451, query_568452, nil, nil, nil)

var projectsListByResourceGroup* = Call_ProjectsListByResourceGroup_568442(
    name: "projectsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects",
    validator: validate_ProjectsListByResourceGroup_568443, base: "",
    url: url_ProjectsListByResourceGroup_568444, schemes: {Scheme.Https})
type
  Call_ProjectsCreate_568465 = ref object of OpenApiRestCall_567659
proc url_ProjectsCreate_568467(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsCreate_568466(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create a project with specified name. If a project already exists, update it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568468 = path.getOrDefault("resourceGroupName")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "resourceGroupName", valid_568468
  var valid_568469 = path.getOrDefault("subscriptionId")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "subscriptionId", valid_568469
  var valid_568470 = path.getOrDefault("projectName")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "projectName", valid_568470
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568471 = query.getOrDefault("api-version")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568471 != nil:
    section.add "api-version", valid_568471
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568472 = header.getOrDefault("Accept-Language")
  valid_568472 = validateParameter(valid_568472, JString, required = false,
                                 default = nil)
  if valid_568472 != nil:
    section.add "Accept-Language", valid_568472
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   project: JObject
  ##          : New or Updated project object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568474: Call_ProjectsCreate_568465; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a project with specified name. If a project already exists, update it.
  ## 
  let valid = call_568474.validator(path, query, header, formData, body)
  let scheme = call_568474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568474.url(scheme.get, call_568474.host, call_568474.base,
                         call_568474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568474, url, valid)

proc call*(call_568475: Call_ProjectsCreate_568465; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"; project: JsonNode = nil): Recallable =
  ## projectsCreate
  ## Create a project with specified name. If a project already exists, update it.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   project: JObject
  ##          : New or Updated project object.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568476 = newJObject()
  var query_568477 = newJObject()
  var body_568478 = newJObject()
  add(path_568476, "resourceGroupName", newJString(resourceGroupName))
  add(query_568477, "api-version", newJString(apiVersion))
  add(path_568476, "subscriptionId", newJString(subscriptionId))
  if project != nil:
    body_568478 = project
  add(path_568476, "projectName", newJString(projectName))
  result = call_568475.call(path_568476, query_568477, nil, nil, body_568478)

var projectsCreate* = Call_ProjectsCreate_568465(name: "projectsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
    validator: validate_ProjectsCreate_568466, base: "", url: url_ProjectsCreate_568467,
    schemes: {Scheme.Https})
type
  Call_ProjectsGet_568453 = ref object of OpenApiRestCall_567659
proc url_ProjectsGet_568455(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsGet_568454(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the project with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568456 = path.getOrDefault("resourceGroupName")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "resourceGroupName", valid_568456
  var valid_568457 = path.getOrDefault("subscriptionId")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "subscriptionId", valid_568457
  var valid_568458 = path.getOrDefault("projectName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "projectName", valid_568458
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568459 = query.getOrDefault("api-version")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568459 != nil:
    section.add "api-version", valid_568459
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568460 = header.getOrDefault("Accept-Language")
  valid_568460 = validateParameter(valid_568460, JString, required = false,
                                 default = nil)
  if valid_568460 != nil:
    section.add "Accept-Language", valid_568460
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568461: Call_ProjectsGet_568453; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the project with the specified name.
  ## 
  let valid = call_568461.validator(path, query, header, formData, body)
  let scheme = call_568461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568461.url(scheme.get, call_568461.host, call_568461.base,
                         call_568461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568461, url, valid)

proc call*(call_568462: Call_ProjectsGet_568453; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## projectsGet
  ## Get the project with the specified name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568463 = newJObject()
  var query_568464 = newJObject()
  add(path_568463, "resourceGroupName", newJString(resourceGroupName))
  add(query_568464, "api-version", newJString(apiVersion))
  add(path_568463, "subscriptionId", newJString(subscriptionId))
  add(path_568463, "projectName", newJString(projectName))
  result = call_568462.call(path_568463, query_568464, nil, nil, nil)

var projectsGet* = Call_ProjectsGet_568453(name: "projectsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
                                        validator: validate_ProjectsGet_568454,
                                        base: "", url: url_ProjectsGet_568455,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsUpdate_568491 = ref object of OpenApiRestCall_567659
proc url_ProjectsUpdate_568493(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsUpdate_568492(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update a project with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568494 = path.getOrDefault("resourceGroupName")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "resourceGroupName", valid_568494
  var valid_568495 = path.getOrDefault("subscriptionId")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "subscriptionId", valid_568495
  var valid_568496 = path.getOrDefault("projectName")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "projectName", valid_568496
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568497 = query.getOrDefault("api-version")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568497 != nil:
    section.add "api-version", valid_568497
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568498 = header.getOrDefault("Accept-Language")
  valid_568498 = validateParameter(valid_568498, JString, required = false,
                                 default = nil)
  if valid_568498 != nil:
    section.add "Accept-Language", valid_568498
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   project: JObject
  ##          : Updated project object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568500: Call_ProjectsUpdate_568491; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a project with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  let valid = call_568500.validator(path, query, header, formData, body)
  let scheme = call_568500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568500.url(scheme.get, call_568500.host, call_568500.base,
                         call_568500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568500, url, valid)

proc call*(call_568501: Call_ProjectsUpdate_568491; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"; project: JsonNode = nil): Recallable =
  ## projectsUpdate
  ## Update a project with specified name. Supports partial updates, for example only tags can be provided.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   project: JObject
  ##          : Updated project object.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568502 = newJObject()
  var query_568503 = newJObject()
  var body_568504 = newJObject()
  add(path_568502, "resourceGroupName", newJString(resourceGroupName))
  add(query_568503, "api-version", newJString(apiVersion))
  add(path_568502, "subscriptionId", newJString(subscriptionId))
  if project != nil:
    body_568504 = project
  add(path_568502, "projectName", newJString(projectName))
  result = call_568501.call(path_568502, query_568503, nil, nil, body_568504)

var projectsUpdate* = Call_ProjectsUpdate_568491(name: "projectsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
    validator: validate_ProjectsUpdate_568492, base: "", url: url_ProjectsUpdate_568493,
    schemes: {Scheme.Https})
type
  Call_ProjectsDelete_568479 = ref object of OpenApiRestCall_567659
proc url_ProjectsDelete_568481(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsDelete_568480(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete the project. Deleting non-existent project is a no-operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568482 = path.getOrDefault("resourceGroupName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "resourceGroupName", valid_568482
  var valid_568483 = path.getOrDefault("subscriptionId")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "subscriptionId", valid_568483
  var valid_568484 = path.getOrDefault("projectName")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "projectName", valid_568484
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568485 = query.getOrDefault("api-version")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568485 != nil:
    section.add "api-version", valid_568485
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568486 = header.getOrDefault("Accept-Language")
  valid_568486 = validateParameter(valid_568486, JString, required = false,
                                 default = nil)
  if valid_568486 != nil:
    section.add "Accept-Language", valid_568486
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568487: Call_ProjectsDelete_568479; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the project. Deleting non-existent project is a no-operation.
  ## 
  let valid = call_568487.validator(path, query, header, formData, body)
  let scheme = call_568487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568487.url(scheme.get, call_568487.host, call_568487.base,
                         call_568487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568487, url, valid)

proc call*(call_568488: Call_ProjectsDelete_568479; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## projectsDelete
  ## Delete the project. Deleting non-existent project is a no-operation.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568489 = newJObject()
  var query_568490 = newJObject()
  add(path_568489, "resourceGroupName", newJString(resourceGroupName))
  add(query_568490, "api-version", newJString(apiVersion))
  add(path_568489, "subscriptionId", newJString(subscriptionId))
  add(path_568489, "projectName", newJString(projectName))
  result = call_568488.call(path_568489, query_568490, nil, nil, nil)

var projectsDelete* = Call_ProjectsDelete_568479(name: "projectsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
    validator: validate_ProjectsDelete_568480, base: "", url: url_ProjectsDelete_568481,
    schemes: {Scheme.Https})
type
  Call_ProjectsGetKeys_568505 = ref object of OpenApiRestCall_567659
proc url_ProjectsGetKeys_568507(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/keys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsGetKeys_568506(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the Log Analytics Workspace ID and Primary Key for the specified project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568508 = path.getOrDefault("resourceGroupName")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "resourceGroupName", valid_568508
  var valid_568509 = path.getOrDefault("subscriptionId")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "subscriptionId", valid_568509
  var valid_568510 = path.getOrDefault("projectName")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "projectName", valid_568510
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568511 = query.getOrDefault("api-version")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_568511 != nil:
    section.add "api-version", valid_568511
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568512 = header.getOrDefault("Accept-Language")
  valid_568512 = validateParameter(valid_568512, JString, required = false,
                                 default = nil)
  if valid_568512 != nil:
    section.add "Accept-Language", valid_568512
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568513: Call_ProjectsGetKeys_568505; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Log Analytics Workspace ID and Primary Key for the specified project.
  ## 
  let valid = call_568513.validator(path, query, header, formData, body)
  let scheme = call_568513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568513.url(scheme.get, call_568513.host, call_568513.base,
                         call_568513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568513, url, valid)

proc call*(call_568514: Call_ProjectsGetKeys_568505; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## projectsGetKeys
  ## Gets the Log Analytics Workspace ID and Primary Key for the specified project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568515 = newJObject()
  var query_568516 = newJObject()
  add(path_568515, "resourceGroupName", newJString(resourceGroupName))
  add(query_568516, "api-version", newJString(apiVersion))
  add(path_568515, "subscriptionId", newJString(subscriptionId))
  add(path_568515, "projectName", newJString(projectName))
  result = call_568514.call(path_568515, query_568516, nil, nil, nil)

var projectsGetKeys* = Call_ProjectsGetKeys_568505(name: "projectsGetKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/keys",
    validator: validate_ProjectsGetKeys_568506, base: "", url: url_ProjectsGetKeys_568507,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
